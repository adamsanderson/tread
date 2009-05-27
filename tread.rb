require 'expression_checker'

Shoes.app do
    background "#ddd"
    style(Para, :font => "Monospace 12px")
    
    @exp_checker = ExpressionChecker.new
    
    @header = stack :height=>48, :width=>1.0 do
      background "#fff".."#ddd"
      flow do
        tagline "Welcome to Tread", :font=>"SanSerif"
        # ... add some links for twiddling things here
      end
    end
    
    @console = stack :width => 1.0, :height => -96, :scroll => true

    flow do 
      @input = edit_box(:height=>50, :width=> -60) do |input|
        text = input.text
        run_command(text.chomp("\n")) if text =~ /\n\Z/ && @exp_checker.valid?(text)
      end
      
      button("run"){ run_command(@input.text) }
    end
        
    def run_command(command)
      begin
        result = eval(command, TOPLEVEL_BINDING)
        @console.append do 
          para(command, :stroke=>"#666")
          para(result.inspect)
        end
      rescue Exception=>ex
        
        @console.append do
          stack do
            background '#FFCCCC'..'#FFEEEE'
            stroke '#FFEEEE'
            line 0,0, width,0
            para(command, :stroke=>"#FF0000")
            para(ex.message, :stroke=>"#FF0000")
            trace = stack do
              line 0,0, width,0
              ex.backtrace.each do |line|
                para(line, :stroke=>"#FF3333", :margin=>2)
              end
              hide
            end
            click{ trace.toggle }
          end
        end 
      end
      
      @console.scroll_top = @console.scroll_max
      @input.text = ''
    end
end
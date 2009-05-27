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
        result = self.instance_eval(command)
        @console.append do 
          para(command, :stroke=>"#666")
          para(result.inspect)
        end
      rescue Exception=>ex
        @console.append do 
          para(ex.message, :stroke=>"#FF0000")
        end        
      end
      
      @console.scroll_top = @console.scroll_max
      @input.text = ''
    end
end
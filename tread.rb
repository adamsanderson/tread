require 'expression_checker'

CTRL_ENTER = "\342\200\250" # ctrl-enter (on a mac anyways...)

Shoes.app do
    background "#ddd"
    style(Para, :font => "Monospace 12px")
    
    @exp_checker = ExpressionChecker.new
    
    @console = stack :width => 1.0, :height => -50, :scroll => true do
      para "Welcome to tread"
    end
    flow do 
      @input = edit_box(:height=>50, :width=> -60) do |input|
        text = input.text
        run_command(text.chomp("\n")) if text =~ /\n\Z/ && @exp_checker.valid?(text)
        run_command(text.chomp(CTRL_ENTER)) if text =~ /#{CTRL_ENTER}\Z/ 
      end
      
      button("run"){
        run_command(@input.text)
      }
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
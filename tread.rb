CTRL_ENTER = "\342\200\250" # ctrl-enter (on a mac anyways...)

Shoes.app do
    background "#ddd"
    style(Para, :font => "Monospace 12px")
    
    @console = stack :width => 1.0, :height => -50, :scroll => true do
      para "Welcome to tread"
    end
    flow do 
      @input = edit_box(:height=>50, :width=> -60) do |input|
        if input.text =~ /#{CTRL_ENTER}\Z/ 
          run_command(input.text.chomp(CTRL_ENTER))
        end
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
      @input.text = ''
    end
end
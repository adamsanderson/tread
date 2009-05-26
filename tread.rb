Shoes.app do
    background "#ddd"
    style(Para, :font => "Monospace 12px")
    
    @console = stack :width => 1.0, :height => -50, :scroll => true do
      para "Welcome to tread"
    end
    flow do 
      @input = edit_line(:width=> -60)
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
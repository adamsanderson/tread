class ExceptionPanel < Shoes::Widget
  attr_reader :ex, :cause
  
  def initialize cause, exception
    @ex = exception
    @cause = cause
    
    stack do
      background '#FFCCCC'..'#FFEEEE'
      stroke '#FFEEEE'
      #line 0,0, width,0
      para(cause, :stroke=>"#FF0000")
      para(ex.message, :stroke=>"#FF0000")
      @trace = stack do
        #line 0,0, width,0
        ex.backtrace.each do |line|
          para(line, :stroke=>"#FF3333", :margin=>2)
        end
      end
      click{ @trace.toggle }
    end
    
    @trace.hide
  end
  
end
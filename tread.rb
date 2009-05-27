require 'irb/ruby-lex'
require 'stringio'

CTRL_ENTER = "\342\200\250" # ctrl-enter (on a mac anyways...)

# Adapted from the wizardly expert-irb.rb's MimickIRB
class ExpressionChecker < RubyLex
  def initialize
    super
    reset!
  end
  
  def valid?(str)
    #str = str.chomp("\n")+"\n"
    @io << str
    @io.rewind
    l = lex
    
    ready = l && !l.empty? && !(@ltype or @continue or @indent > 0)
    reset!
    
    ready
  end

  def reset!
    set_input(StringIO.new)
    @seek = 0
    @exp_line_no = @line_no = 1
    @base_char_no = 0
    @char_no = 0
    @rests = []
    @readed = []
    @here_readed = []

    @indent = 0
    @indent_stack = []
    @lex_state = EXPR_BEG
    @space_seen = false
    @here_header = false

    @continue = false
    @line = ""

    @skip_space = false
    @readed_auto_clean_up = false
    @exception_on_syntax_error = true

    @prompt = nil
  end
end

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
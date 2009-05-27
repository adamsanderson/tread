require 'irb/ruby-lex'
require 'stringio'

# Adapted from the wizardly expert-irb.rb's MimickIRB
class ExpressionChecker < RubyLex
  def initialize
    super
    reset!
  end
  
  # Returns true if the +str+ is a valid ruby expression (or at least something that we should try to execute)
  def valid?(str)
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
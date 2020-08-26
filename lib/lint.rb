class Lint
  attr_reader :report_log, :current_file_name
  attr_writer :curr_text, :curr_line

  def initialize(curr_file)
    @report_log = File.new('.results.mm', 'w')
    @current_file_name = curr_file
  end

  def trailing_white_linter
    msg = "File: #{@current_file_name} Line: #{@curr_line + 1} ====> Trailing whitespace detected\n"
    @report_log << msg if @curr_text.chomp[-1] == ' '
  end

  def empty_line_linter
    msg = "File: #{@current_file_name} Line: #{@curr_line + 1} ====> Empty line detected\n"
    @report_log << msg if @curr_text.chomp.chars.all?(' ') || @curr_text.chomp.nil?
  end

  def property_space_linter
    msg = "File: #{@current_file_name} Line: #{@curr_line + 1} ====> No space after colon\n"
    colon_index = @curr_text.index(':')
    @report_log << msg if !colon_index.nil? && @curr_text[colon_index + 1] != ' '
  end

  def colors_lowercase_linter
    msg = "File: #{@current_file_name} Line: #{@curr_line + 1} ====> Colors should be all lower case\n"
    pound_index = @curr_text.index('#')
    semicolon_index = @curr_text.index(';')
    color = @curr_text[pound_index...semicolon_index]
    @report_log << msg if !pound_index.nil? && !semicolon_index.nil? && color != color.downcase
  end

  def no_semicolon_linter
    msg = "File: #{@current_file_name} Line: #{@curr_line + 1} ====> Missing semicolor\n"
    @report_log << msg if !@curr_text.match?(/[{};]/) && !@curr_text.chomp.chars.all?(' ')
  end

  def comment_start_linter
    msg = "File: #{@current_file_name} Line: #{@curr_line + 1} ====> Missing space between /* and content\n"
    @report_log << msg if @curr_text.include?('/*') && !@curr_text.include?('/* ')
  end

  def declaration_space_linter
    msg = "File: #{@current_file_name} Line: #{@curr_line + 1} ====> Missing space before the opening bracket\n"
    @report_log << msg if @curr_text.include?('{') && !@curr_text.include?(' {')
  end
end

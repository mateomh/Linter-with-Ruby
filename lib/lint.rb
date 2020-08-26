class Lint
  attr_reader :report_log, :current_file_name
  attr_writer :curr_text, :curr_line

  def initialize(curr_file)
    @report_log = File.new('.results.mm', 'w+')
    @current_file_name = curr_file
    @empty_count = 0
    @inside_block = false
  end

  def update_msg_header
    @message_header = "File: \e[1;40m\e[1;34m #{@current_file_name} \e[0m "
    @message_header += "Line: \e[1;40m\e[1;35m #{@curr_line + 1} \e[0m ====> "
  end

  def set_inside_block
    @inside_block = true
  end

  def unset_inside_block
    @inside_block = false
  end

  def empty_count
    @empty_count += 1
  end

  def empty_reset
    @empty_count = 0
  end

  def trailing_white_linter
    update_msg_header
    msg = @message_header + "Trailing whitespace detected\n"
    @report_log << msg if @curr_text.chomp[-1] == ' '
  end

  def empty_line_linter
    update_msg_header
    msg = @message_header + "Empty line detected\n"
    @report_log << msg if (@curr_text.chomp.chars.all?(' ') || @curr_text.chomp.nil?) && @inside_block
    @report_log << msg if !@inside_block && @empty_count > 1
  end

  def property_space_linter
    update_msg_header
    msg = @message_header + "No space after colon\n"
    colon_index = @curr_text.index(':')
    @report_log << msg if !colon_index.nil? && @curr_text[colon_index + 1] != ' '
  end

  def colors_lowercase_linter
    update_msg_header
    msg = @message_header + "Colors should be all lower case\n"
    pound_index = @curr_text.index('#')
    semicolon_index = @curr_text.index(';')
    color = @curr_text[pound_index...semicolon_index]
    @report_log << msg if !pound_index.nil? && !semicolon_index.nil? && color != color.downcase
  end

  def no_semicolon_linter
    update_msg_header
    msg = @message_header + "Missing semicolon\n"
    @report_log << msg if !@curr_text.match?(/[{};]/) && !@curr_text.chomp.chars.all?(' ')
  end

  def comment_start_linter
    update_msg_header
    msg = @message_header + "Missing space between /* and content\n"
    @report_log << msg if @curr_text.include?('/*') && !@curr_text.include?('/* ')
  end

  def declaration_space_linter
    update_msg_header
    p @curr_text
    msg = @message_header + "Missing space before the opening bracket\n"
    @report_log << msg if @curr_text.include?('{') && !@curr_text.include?(' {')
  end

  def type_of_line
    # Comment line: Type 1
    # Beginning of block: Type 2
    # End of block: Type 3
    # Empty line: Type 4
    # Regular line: Type 5

    return 'comment' if @curr_text.include?('/*')
    return 'block start' if @curr_text.include?('{')
    return 'block end' if @curr_text.include?('}')
    return 'empty line' if @curr_text.chomp.nil? || @curr_text.chomp.chars.all?(' ')

    'regular'
  end

  def report
    @report_log.rewind
    puts "\e[1;40m\e[1;32m No Errors Found - Good Job \e[0m" if @report_log.gets.nil?
    @report_log.each do |error|
      puts error
    end
  end
end

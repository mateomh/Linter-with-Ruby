class Lint
  attr_reader :report_log, :current_file_name
  attr_writer :curr_text, :curr_line, :empty_count

  def initialize(curr_file)
    @report_log = File.new('.results.mm', 'w+')
    @current_file_name = curr_file
    @empty_count = 0
    @inside_block = false
  end

  def type_of_line
    return 'comment' if @curr_text.include?('/*')
    return 'block start' if @curr_text.include?('{')
    return 'block end' if @curr_text.include?('}')
    return 'empty line' if @curr_text.chomp.nil? || @curr_text.chomp.chars.all?(' ')

    'regular'
  end

  def run_linters(line_type)
    case line_type
    when 'comment'
      empty_reset
      comment_start_linter
      comment_end_linter
      trailing_white_linter
    when 'block start'
      empty_reset
      set_inside_block
      declaration_space_linter
      trailing_white_linter
    when 'block end'
      empty_reset
      unset_inside_block
      block_end_space_linter
      trailing_white_linter
    when 'empty line'
      empty_count
      trailing_white_linter
      empty_line_linter
    when 'regular'
      empty_reset
      trailing_white_linter
      empty_line_linter
      property_space_linter
      colors_lowercase_linter
      no_semicolon_linter
      indentation_linter
    end
  end

  def report
    @report_log.rewind
    puts "\e[1;40m\e[1;36m #{@current_file_name} \e[1;32mNo Errors Found - Good Job \e[0m" if @report_log.gets.nil?
    @report_log.each do |error|
      puts error
    end
    @report_log.close
  end

  private

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
    return @report_log << msg if @curr_text.chomp[-1] == ' '
  end

  def empty_line_linter
    update_msg_header
    msg = @message_header + "Empty line detected\n"
    return @report_log << msg if (@curr_text.chomp.chars.all?(' ') || @curr_text.chomp.nil?) && @inside_block
    return @report_log << msg if !@inside_block && @empty_count != 1
  end

  def property_space_linter
    update_msg_header
    msg = @message_header + "No space after colon\n"
    colon_index = @curr_text.index(':')
    return @report_log << msg if !colon_index.nil? && @curr_text[colon_index + 1] != ' '
  end

  def colors_lowercase_linter
    update_msg_header
    msg = @message_header + "Colors should be all lower case\n"
    pound_index = @curr_text.index('#')
    semicolon_index = @curr_text.index(';')
    color = @curr_text[pound_index...semicolon_index]
    return @report_log << msg if !pound_index.nil? && !semicolon_index.nil? && color != color.downcase
  end

  def no_semicolon_linter
    update_msg_header
    msg = @message_header + "Missing semicolon\n"
    return @report_log << msg if !@curr_text.match?(/[{};]/) && !@curr_text.chomp.chars.all?(' ')
  end

  def comment_start_linter
    update_msg_header
    msg = @message_header + "Missing space between /* and content\n"
    return @report_log << msg if @curr_text.include?('/*') && !@curr_text.include?('/* ')
  end

  def comment_end_linter
    update_msg_header
    msg = @message_header + "Missing space between */ and content\n"
    return @report_log << msg if @curr_text.include?('*/') && !@curr_text.include?(' */')
  end

  def declaration_space_linter
    update_msg_header
    msg = @message_header + "Missing space before the opening bracket\n"
    return @report_log << msg if @curr_text.include?('{') && !@curr_text.include?(' {')
  end

  def block_end_space_linter
    update_msg_header
    msg = @message_header + "Closing bracket should not have inline spaces\n"
    return @report_log << msg if @curr_text[0].include?(' ')
  end

  def indentation_linter
    update_msg_header
    msg = @message_header + "Indentation should be 2 spaces\n"
    text_beginning = @curr_text.index(/\w/)
    return @report_log << msg if @inside_block && @curr_text[0...text_beginning].count(' ') != 2
  end
end

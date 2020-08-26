#!/usr/bin/env ruby
require 'find' # Gets the find module to get all the files in the folder
require './lib/lint'

raise StandardError, 'Too many arguments' if ARGV.length > 1

html_files = []
css_files = []

if !ARGV.empty?
  raise StandardError, 'File does NOT exist' unless File.exist?(ARGV[0])

  css_files.push(ARGV[0])
else
  Find.find('./') do |path|
    html_files.push(File.open(path, 'r')) if File.extname(path) == '.html'
    css_files.push(File.open(path, 'r')) if File.extname(path) == '.css'
  end
end

raise StandardError, 'No files to check in the folder' if css_files.empty?

#results_log = File.new('.results.mm', 'w')
current_file = File.open(css_files[0], 'r')

linter = Lint.new(File.basename(current_file))

current_file.each_with_index do |text, line|
  linter.curr_text = text
  linter.curr_line = line

  # linter.trailing_white_linter
  # linter.empty_line_linter
  # linter.property_space_linter
  # linter.colors_lowercase_linter
  # linter.no_semicolon_linter
  # linter.comment_start_linter
  linter.declaration_space_linter
end

exit(0)

# Checks for trailing white spaces

# current_file.each_with_index do |text, line|
#   if text.chomp[-1] == ' '
#     results_log << "File: #{File.basename(current_file)} Line: #{line+1} ====> Trailing whitespace detected\n"
#   end
# end

# Checks for empty lines

# current_file.rewind
# current_file.each_with_index do |text, line|
#   if text.chomp.count(' ') == text.chomp.length || text.chomp.nil?
#     results_log << "File: #{File.basename(current_file)} Line: #{line+1} ====> Empty line detected\n"
#   end
# end

# Checks for the space after the property

# current_file.rewind
# current_file.each_with_index do |text, line|
#   text_array = text.chomp.chars
#   if text_array.include?(':')
#     if text_array[text_array.index(':')+1] != ' '
#       results_log << "File: #{File.basename(current_file)} Line: #{line+1} ====> No space after colon\n"
#     end
#   end
# end

# Checks for colors lower case

# current_file.rewind
# current_file.each_with_index do |text, line|
#   pound_index = text.index('#')
#   if pound_index != nil
#     semicolon_index = text.index(';')
#     if semicolon_index != nil
#       color = text[pound_index...semicolon_index]
#       if color != color.downcase
#         results_log << "File: #{File.basename(current_file)} Line: #{line+1} ====> Colors should be all lower case\n"
#       end
#     end
#   end
# end

# Checks for semicolon missing

# current_file.rewind
# current_file.each_with_index do |text, line|
#   if text.index(';').nil? && text.index('{').nil? && text.index('}').nil?
#     if !text.chomp.chars.all?(' ')
#       results_log << "File: #{File.basename(current_file)} Line: #{line+1} ====> Missing semicolor\n"
#     end
#   end 
# end

# Checks for space between the comment start and the content

# current_file.rewind
# current_file.each_with_index do |text, line|
#   comment_index = text.index('/')
#   if !comment_index.nil? && text[comment_index+2] != ' '
#     results_log << "File: #{File.basename(current_file)} Line: #{line+1} ====> Missing space after between /* and content\n"
#   end 
# end

# Checks for space between the declaration and the {

# current_file.rewind
# current_file.each_with_index do |text, line|
#   bracket_index = text.index('{')
#   if !bracket_index.nil? && text[bracket_index-1] != ' '
#     results_log << "File: #{File.basename(current_file)} Line: #{line+1} ====> Missing space before the opening bracket\n"
#   end 
# end

# Type of line

current_file.rewind
current_file.each_with_index do |text, line|
  if text.include?('/*')
    p "Comment line"
  elsif text.include?('{')
    p "beginning of block"
  elsif text.include?('}')
    p "end of block"
  elsif text.chomp.nil? || text.chomp.chars.all?(' ')
    p "Empty line"
  else
    p "Regular line"
  end
end

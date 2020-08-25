#!/usr/bin/env ruby
require 'find' # Gets the find module

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

results_log = File.new('.results.mm', 'w')
current_file = File.open(css_files[0], 'r')

# Checks for trailing white spaces

current_file.each_with_index do |text, line|
  if text.chomp[-1] == ' '
    results_log << "File: #{File.basename(current_file)} Line: #{line+1} ====> Trailing whitespace detected\n"
  end
end

# Checks for empty lines

current_file.rewind
current_file.each_with_index do |text, line|
  if text.chomp.count(' ') == text.chomp.length || text.chomp.nil?
    results_log << "File: #{File.basename(current_file)} Line: #{line+1} ====> Empty line detected\n"
  end
end

# Checks for the space after the property

current_file.rewind
current_file.each_with_index do |text, line|
  text_array = text.chomp.chars
  if text_array.include?(':')
    if text_array[text_array.index(':')+1] != ' '
      results_log << "File: #{File.basename(current_file)} Line: #{line+1} ====> No space after colon\n"
    end
  end
end

# Checks for colors lower case

current_file.rewind
current_file.each_with_index do |text, line|
  pound_index = text.index('#')
  if pound_index != nil
    semicolon_index = text.index(';')
    if semicolon_index != nil
      color = text[pound_index...semicolon_index]
      if color != color.downcase
        results_log << "File: #{File.basename(current_file)} Line: #{line+1} ====> Colors should be all lower case\n"
      end
    end
  end
end
#!/usr/bin/env ruby
# rubocop:disable Metrics/BlockLength
require 'find' # Gets the find module to get all the files in the folder
require './lib/lint.rb'

# Checks for the number of arguments passed
raise StandardError, 'Too many arguments' if ARGV.length > 1

html_files = []
css_files = []

if !ARGV.empty?
  # Checks if the file name passed exists
  raise StandardError, 'File does NOT exist' unless File.exist?(ARGV[0])

  css_files.push(ARGV[0])
else
  # If no argument passed gets all the files in the project folder
  Find.find('./') do |path|
    html_files.push(File.open(path, 'r')) if File.extname(path) == '.html'
    css_files.push(File.open(path, 'r')) if File.extname(path) == '.css'
  end
end

# Checks if there are files to check
raise StandardError, 'No files to check in the folder' if css_files.empty?

# Cycles through the files found in the project folder
css_files.each do |filename|
  current_file = File.open(filename, 'r')

  linter = Lint.new(File.basename(current_file))

  # Reads the file line by line
  current_file.each_with_index do |text, line|
    linter.curr_text = text
    linter.curr_line = line
    line_type = linter.type_of_line
    # Calls the linters acording to the type of line
    case line_type
    when 'comment'
      linter.empty_reset
      linter.comment_start_linter
      linter.comment_end_linter
      linter.trailing_white_linter
    when 'block start'
      linter.empty_reset
      linter.set_inside_block
      linter.declaration_space_linter
      linter.trailing_white_linter
    when 'block end'
      linter.empty_reset
      linter.unset_inside_block
      linter.block_end_space_linter
      linter.trailing_white_linter
    when 'empty line'
      linter.empty_count
      linter.trailing_white_linter
      linter.empty_line_linter
    when 'regular'
      linter.empty_reset
      linter.trailing_white_linter
      linter.empty_line_linter
      linter.property_space_linter
      linter.colors_lowercase_linter
      linter.no_semicolon_linter
      linter.indentation_linter
    end
  end
  linter.report
end
# rubocop:enable Metrics/BlockLength

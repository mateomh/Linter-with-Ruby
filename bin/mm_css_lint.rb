# rubocop:disable Metrics/BlockLength
require 'find' # Gets the find module to get all the files in the folder
require_relative '../lib/lint.rb'
require_relative '../lib/checks.rb'
include Checks

# Checks for the number of arguments passed
raise StandardError, 'Too many arguments' if check_arguments_number(ARGV)

css_files = get_files(ARGV)

# Checks if the file passed exists
raise StandardError, 'File does NOT exist' unless get_files(ARGV)

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
    linter.run_linters(line_type)
  end
  linter.report
end
# rubocop:enable Metrics/BlockLength

require 'find' # Gets the find module to get all the files in the folder
require_relative '../lib/lint.rb'
require_relative '../lib/checks.rb'

# Checks for the number of arguments passed
raise StandardError, 'Too many arguments' if Checks.check_arguments_number(ARGV)

css_files = Checks.get_files(ARGV)

# Checks if the file passed exists
raise StandardError, 'File does NOT exist' unless css_files

# Checks if there are files to check
raise StandardError, 'No files to check in the folder' if css_files.empty?

# Cycles through the files found in the project folder
css_files.each do |filename|
  current_file = File.open(filename, 'r')
  linter = Lint.new(File.basename(current_file))
  Checks.linter_check_for(current_file, linter)
  linter.report
end

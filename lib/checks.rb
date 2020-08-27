class Checks
  def self.check_arguments_number(args)
    return true if args.length > 1

    false
  end

  def self.get_files(args)
    css_files = []
    if !args.empty?
      # Checks if the file name passed exists
      return false unless File.exist?(args[0])

      css_files.push(args[0])
    else
      # If no argument passed gets all the files in the project folder
      Find.find('./') do |path|
        css_files.push(File.open(path, 'r')) if File.extname(path) == '.css'
      end
    end
    css_files
  end

  def self.linter_check_for(file, linter)
    file.each_with_index do |text, line|
      linter.curr_text = text
      linter.curr_line = line
      line_type = linter.type_of_line
      # Calls the linters acording to the type of line
      linter.run_linters(line_type)
    end
  end
end

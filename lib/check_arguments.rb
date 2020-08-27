module Check_arguments
  def check_arguments_number(args)
    return true if args.length > 1
    false
  end

  def get_files(args)
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
    return css_files
  end
end
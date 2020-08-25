#!/usr/bin/env ruby
require 'find' # Gets the find module

raise StandardError.new("Too many arguments") if ARGV.length > 1

html_files = []
css_files = []

if !ARGV.empty?
  raise StandardError.new("File does NOT exist") if !File.exists?(ARGV[0])
  html_files.push(ARGV[0]) 
else
  Find.find('./') do |path|
    html_files.push(File.open(path, 'r')) if File.extname(path) == ".html"
    css_files.push(File.open(path, 'r')) if File.extname(path) == ".css"
  end
end

raise StandardError.new("No files to check in the folder")if html_files.empty?
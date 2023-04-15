# Please, run this script in the root dir of t2 (/t2)

ENV['RUBY-ENV'] = 'test'

directory = 'tests'

files = Dir.entries(directory).reject { |file| File.directory?(file) || $PROGRAM_NAME.match?(file) }

root = $PROGRAM_NAME.split("/")
root.pop
root = root.join('/')

files.each do |file|
  puts "##################################### Running tests in the file #{file}... #####################################"
  system("ruby #{root}/#{file}")
  puts "##################################### FINISHED #####################################"
  puts "\n\n"
end

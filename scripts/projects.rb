require "yaml"

projects = YAML.load(File.read(ARGV[0]))
projects.each do |project|
  puts "#{project["name"]}##{project["repo"]}##{project["docs_dir"]}"
end

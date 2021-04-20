require "yaml"

projects = YAML.load(File.read(ARGV[0]))

projects.each do |project|
  if project["name"] == ARGV[1]
    puts project["latest_alias"]
    break
  end
end

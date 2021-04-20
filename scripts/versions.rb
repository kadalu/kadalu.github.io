require "yaml"

projects = YAML.load(File.read(ARGV[0]))

projects.each do |project|
  if project["name"] == ARGV[1]
    # Print each version in new line
    project["versions"].each do |version|
      puts version
    end

    break
  end
end

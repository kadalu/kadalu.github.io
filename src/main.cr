require "yaml"

struct Project
  include YAML::Serializable

  property name = "",
           title = "",
           description = "",
           docs_dir = "docs",
           repo = "",
           versions = [] of String
end

def prepare_versioned_docs(project, version)
  `cd #{ENV["ROOT_DIR"]}/tmprepos/#{project.name} && git checkout -b v#{version} #{version}`
  Dir.mkdir_p("#{ENV["ROOT_DIR"]}/content/docs/#{project.name}")

  project_dir = "#{ENV["ROOT_DIR"]}/content/docs/#{project.name}"
  version_dir = "#{project_dir}/#{version}"
  # Copy the docs directory to respective version directory
  `cp -r #{ENV["ROOT_DIR"]}/tmprepos/#{project.name}/#{project.docs_dir} #{version_dir}`

  # Create empty versions.html file in project root dir
  `echo > #{project_dir}/versions.html`

  # Create empty redirect.html file
  `echo > #{version_dir}/redirect.html`

  # Replace Relative links, *.adoc links
  files = Dir.glob("#{version_dir}/*.adoc")
  files.each do |adoc_file|
    content = File.read(adoc_file)
    content = content
              .gsub(".adoc[", "[")
              .gsub("link:../", "https://github.com/kadalu/#{project.name}/tree/#{version}/")
              .gsub("link:./", "link:/docs/#{project.name}/#{version}/")
    File.write(adoc_file, content)
  end
end

def init_rootdirs
  Dir.mkdir_p("#{ENV["ROOT_DIR"]}/tmprepos")

  # Copy projects.yml to root dir
  `cp #{ARGV[0]} #{ENV["ROOT_DIR"]}/content/docs/`
end

def clone_project(project)
  `git clone --depth 1 #{project.repo} #{ENV["ROOT_DIR"]}/tmprepos/#{project.name}`
  `cd #{ENV["ROOT_DIR"]}/tmprepos/#{project.name} && git fetch --depth=1 origin +refs/tags/*:refs/tags/*`
end

def build_docs_site
  puts ENV["ROOT_DIR"]
  `cd #{ENV["ROOT_DIR"]} && bundle install`
  `cd #{ENV["ROOT_DIR"]} && npm install`
  `cd #{ENV["ROOT_DIR"]} && npm run prod:css`
  `cd #{ENV["ROOT_DIR"]} && bundle exec nanoc compile --env prod`
end

def build(projects)
  ENV["ROOT_DIR"] ||= Path[Dir.current].expand.to_s

  init_rootdirs

  projects.each do |project|
    # Default values and derived fields
    project.name = project.repo.split("/")[-1] if project.name == ""

    if project.versions.size == 0
      # No versions specified
      next
    end

    clone_project(project)

    # Clear the directory before copying the doc directory from repo
    `rm -rf "#{ENV["ROOT_DIR"]}/content/docs/#{project.name}"`

    project.versions.each do |ver|
      prepare_versioned_docs(project, ver)
    end
  end

  build_docs_site
end

if ARGV.size != 1
  STDERR.puts "Usage: kadalu-sitegen <projects-yaml>"
  exit(1)
end

build(Array(Project).from_yaml(File.read(ARGV[0])))

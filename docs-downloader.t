# -*- mode: ruby -*-

require "yaml"

PROJECTS = YAML.load(File.read("./projects.yml"))

TEST "rm -rf tmp_docs && mkdir tmp_docs"

PROJECTS.each do |project|
  # Cleanup and Create the directories
  project_dir = "content/#{project["name"]}"
  TEST "rm -rf #{project_dir}"
  TEST "mkdir -p #{project_dir}"

  project["branches"].each do |branch|
    # Checkout each version tag and copy the docs directory to
    TEST "git clone --depth 1 --branch #{branch["name"]} #{project["repo"]} tmp_docs/#{project["name"]}_#{branch["short_name"]}"

    TEST "mv tmp_docs/#{project["name"]}_#{branch["short_name"]}/#{project["docs_dir"]} #{project_dir}/#{branch["short_name"]}"
    if branch["index"]
      # man cp
      # -n, --no-clobber
      #     do not overwrite an existing file (overrides a previous -i option)
      TEST "cp -n #{project_dir}/#{branch["short_name"]}/#{branch["index"]}.adoc #{project_dir}/#{branch["short_name"]}/index.adoc"
    else
      TEST "cp -n #{project_dir}/#{branch["short_name"]}/README.adoc #{project_dir}/#{branch["short_name"]}/index.adoc"
    end

    # Fix the links
    TEST "ruby scripts/process_files.rb \"#{project_dir}/#{branch["short_name"]}\" #{project["name"]} #{project["repo"]} #{branch["short_name"]} #{branch["name"]}"

    if project["latest_alias"] == branch["short_name"]
      TEST "cp -r #{project_dir}/#{branch["short_name"]} #{project_dir}/latest"
    end

    TEST "rm -rf tmp_docs/#{project["name"]}_#{branch["short_name"]}"
  end
end

# Clone the Rfcs Repo
TEST "rm -rf content/rfcs"
TEST "git clone --depth 1 https://github.com/kadalu/rfcs.git tmp_docs/rfcs"

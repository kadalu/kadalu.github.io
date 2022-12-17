doc_path = ARGV[0]
project_name = ARGV[1]
project_repo = ARGV[2]
version = ARGV[3]
repo_version = ARGV[4]

Dir["#{doc_path}/*.adoc"].each do |adoc_file|
  content = File.read(adoc_file)
              .gsub(".adoc[", "[")
              .gsub("link:../", "#{project_repo}/tree/#{repo_version}/")
              .gsub("link:./", "link:/#{project_name}/#{version}/")
  File.write(adoc_file, content)
end

require "yaml"

include Nanoc::Helpers::Blogging
include Nanoc::Helpers::Text
include Nanoc::Helpers::XMLSitemap
use_helper Nanoc::Helpers::Rendering

module PostHelper
  def slug_and_created_at(post)
    match = /([0-9]+)\-([0-9]+)\-([0-9]+)\-([^\/]+)/.match(post.identifier.without_ext)
    if match
      y, m, d, slug = match.captures

      [slug, "#{y}-#{m}-#{d}"]
    else
      [post.identifier.without_ext, ""]
    end
  end

  def get_pretty_date(date_field)
    attribute_to_time(date_field).strftime('%b %-d, %Y')
  end

  def sort_blog_posts(posts)
    posts.sort do |post_a, post_b|
      slug_a, created_at_a = slug_and_created_at(post_a)
      slug_b, created_at_b = slug_and_created_at(post_b)

      created_at_b <=> created_at_a
    end
  end
end

include PostHelper

def reading_time(content)
  words_per_minute = 150
  unit = 'minutes'
  text = strip_html(content)
  n = (text.scan(/\w+/).length / words_per_minute).to_i

  return "#{n} minutes" if n > 1

  "1 minute"
end

def check_icon
  File.read("./layouts/check_icon.html")
end

def link_from_chapter(project, version, chapter)
  slug = chapter["slug"] ? chapter["slug"] : title.gsub(/\s/, "-").downcase
  "/#{project}/#{version}/#{slug}/"
end

def sidemenu(project, version)
  YAML.load(File.read("./content/#{project}/#{version}/index.yml"))
end

def first_chapter(project, version)
  chapters = YAML.load(File.read("./content/#{project}/#{version}/index.yml"))
  first_one = nil
  sidemenu(project, version).each do |section|
    section["chapters"].each do |chapter|
      first_one = chapter
      break
    end

    break
  end

  first_one
end

$projects = nil

def supported_versions(project_name)
  $projects = list_projects if $projects.nil?

  versions = []
  $projects.each do |project|
    if project["name"] == project_name
      versions = project["versions"]
      break
    end
  end

  versions
end

def list_rfcs
  Dir["./content/rfcs/*.adoc"].sort.map do |entry|
    url = entry.gsub("./content/rfcs/", "").gsub(".adoc", "")
    title = "Introduction"
    if url != "index"
      title = (url.split("-").map {|part| part.capitalize}).join(" ")
    end

    {
      "title" => title,
      "path" => "/rfcs/#{url}.html"
    }
  end
end

def list_projects
  YAML.load(File.read("./projects.yml"))
end

def project_and_version_from_url(item_path)
  $projects = list_projects if $projects.nil?
  parts = item_path.split("/", 4)
  project_name = ""
  project_version = ""
  chapter = ""
  $projects.each do |project|
    if project["name"] == parts[1]
      project_version = parts[2]
      project_name = parts[1]
    end
  end

  if project_name != "" && project_version != "" && parts.size == 4
    chapter = parts[3]
  end
  
  [project_name, project_version, chapter]
end

def project_from_url(item_path)
  parts = item_path.split("/", 4)

  parts[1]
end

def project_from_name(name)
  $projects = list_projects if $projects.nil?
  project = nil
  $projects.each do |proj|
    if proj["name"] == name
      project = proj
      break
    end
  end

  project
end

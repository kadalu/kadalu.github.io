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

AUTHORS = {
  :kadalu => {
    :bio => "Team Kadalu",
    :name => "Kadalu",
    :site => "https://kadalu.io",
    :twitter => "kadaluio"
  },
  :aravindavk => {
    :bio => "Kadalu Maintainer",
    :name => "Aravinda Vishwanathapura",
    :site => "https://aravindavk.in",
    :twitter => "aravindavk"
  },
  :amarts => {
    :bio => "GlusterFS and Kadalu Maintainer",
    :name => "Amar Tumballi",
    :site => "https://medium.com/@tumballi",
    :twitter => "tumballi"
  },
  :sac => {
    :bio => "Kadalu Maintainer",
    :name => "Sachidananda Urs",
    :site => "https://twitter.com/sac314",
    :twitter => "sac314"
  },
  :sankarshanmukhopadhyay => {
    :name => "Sankarshan Mukhopadhyay",
    :site => "https://medium.com/@sankarshan",
    :twitter => "sankarshan"
  }
}

def author_data(id)
  AUTHORS[id]
end

def check_icon
  File.read("./layouts/check_icon.html")
end

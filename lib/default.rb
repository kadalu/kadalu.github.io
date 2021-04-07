include Nanoc::Helpers::Blogging
include Nanoc::Helpers::Text
use_helper Nanoc::Helpers::Rendering

module PostHelper
  def slug_and_created_at(post)
    y, m, d, slug = /([0-9]+)\-([0-9]+)\-([0-9]+)\-([^\/]+)/.match(post.identifier.without_ext).captures

    [slug, "#{y}-#{m}-#{d}"]
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

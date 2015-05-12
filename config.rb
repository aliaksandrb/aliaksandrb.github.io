require 'slim'

###
# Blog settings
###

# Time.zone = "UTC"

prefix_path = ''
activate :blog do |blog|
  # This will add a prefix to all links, template references and source paths
  # blog.prefix = 'dreamingpotato.com'
  prefix_path = blog.prefix.dup if blog.prefix
  # blog.permalink = "{year}/{month}/{day}/{title}.html"
  # Matcher for blog source files
  blog.sources = "articles/{year}-{month}-{day}-{title}.html"
  blog.taglink = "tag/{tag}.html"
  # blog.layout = "layout"
  # blog.summary_separator = /(READMORE)/
  # blog.summary_length = 250
  # blog.year_link = "{year}.html"
  # blog.month_link = "{year}/{month}.html"
  # blog.day_link = "{year}/{month}/{day}.html"
  # blog.default_extension = ".markdown"

  blog.tag_template = "tag.html"
  # blog.calendar_template = "calendar.html"

  # Enable pagination
  blog.paginate = true
  # blog.per_page = 10
  # blog.page_link = "page/{num}"
end

website_link = 'https://aliaksandrb.github.io/'
author_name = 'Aliaksandr Buhayeu'
set :casper, {
  blog: {
    url: website_link,
    name: 'Dreaming Potato',
    description: 'Tech, Fiction, Travel',
    date_format: '%d %B %Y',
    navigation: true,
    logo: nil # Optional
  },
  author: {
    name: author_name,
    bio: 'software engineer, Ruby fan &amp; trainer, just a positive guy', # Optional
    location: 'Minsk, Belarus', # Optional
    website: website_link, # Optional
    gravatar_email: nil # Optional
  },
  navigation: {
    'Home' => "/",
    'About' => "#{prefix_path}/author/#{author_name.parameterize}/"
  }
}

page '/feed.xml', layout: false
page '/sitemap.xml', layout: false

ignore '/partials/*'

ready do
  blog.tags.each do |tag, articles|
    proxy "/tag/#{tag.downcase.parameterize}/feed.xml", '/feed.xml', layout: false do
      @tagname = tag
      @articles = articles[0..5]
    end
  end

  proxy "/author/#{blog_author.name.parameterize}.html", '/author.html', ignore: true
end

###
# Compass
###

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", layout: false
#
# With alternative layout
# page "/path/to/file.html", layout: :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", locals: {
#  which_fake_page: "Rendering a fake page with a local variable" }

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Reload the browser automatically whenever files change
activate :livereload

# Pretty URLs - http://middlemanapp.com/basics/pretty-urls/
activate :directory_indexes

# Middleman-Syntax - https://github.com/middleman/middleman-syntax
set :haml, { ugly: true, format: :html5 }
set :markdown_engine, :redcarpet
set :markdown, fenced_code_blocks: true, smartypants: true
activate :syntax, line_numbers: true

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'
set :partials_dir, 'partials'

activate :google_analytics do |ga|
  ga.tracking_id = 'UA-62859913-1'
  ga.anonymize_ip = false
  # Tracking across a domain and its subdomains (default = nil)
  #ga.domain_name = 'example.com'
  # Tracking across multiple domains and subdomains (default = false)
  #ga.allow_linker = false
  # Tracking Code Debugger (default = false)
  #ga.debug = false
  # Tracking in development environment (default = true)
  ga.development = false
  # Compress the JavaScript code (default = false)
  ga.minify = true
end

# Build-specific configuration
configure :build do
  activate :minify_css
  activate :minify_javascript
  # Enable cache buster
  activate :asset_hash

  # Use relative URLs
  activate :relative_assets
  set :relative_links, true

  # Or use a different image path
  # set :http_prefix, "/Content/images/"

  # gzip text files # NOTE! need a test with github pages
  activate :gzip
end

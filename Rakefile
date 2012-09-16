#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.
require 'open-uri'
require 'nokogiri'

require File.expand_path('../config/application', __FILE__)

WPMap::Application.load_tasks

task :scrape_initial_url => :environment do
  domain = 'http://webpass.net/'
  initialPath = 'buildings'

  initialUrl = domain + initialPath
  doc = Nokogiri::HTML(open(initialUrl))

  doc.css('#nav_tabs li a').each do |link|
      c = City.find_or_create_by_name(link.content)
      c.url = link.attributes['href'].to_s
      c.save
  end
end

#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.
require 'json'
require 'open-uri'
require 'uri'
require 'nokogiri'

require File.expand_path('../config/application', __FILE__)

Geocoder.configure(:always_raise => :all)

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

task :scrape_cities => :environment do
  domain = 'http://webpass.net/'
  City.all.each do |city|
    url = domain + city.url

    doc = Nokogiri::HTML(open(url))

    doc.css('#wide_table tr').each do |row|
      if city.name.include? 'Building Name'
        continue
      end
      name = row.children[0].content
      speeds = row.children[2].content

      b = Building.find_or_create_by_name(name)

      b.speeds = speeds.strip
      b.city = city

      b.save
    end
  end
end

task :geocode_buildings => :environment do
  parsed = 0
  Building.all.each do |building|
    if not building.latlon
      address = building.name + ', ' + building.city.name + ', CA'
			results = Geocoder.search(address)
      if results.length > 0
        location = results[0].geometry['location']
        building.latlon = "#{location['lat']}, #{location['lng']}"
        building.save
        parsed = parsed + 1
      else
        puts "Geocoding building failed with #{results}"
        break
      end
    end
  end
  puts "Geocoded #{parsed} buildings"
end

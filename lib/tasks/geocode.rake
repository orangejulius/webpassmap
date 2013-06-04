require 'open-uri'
Geocoder.configure(always_raise: :all)

DOMAIN = 'http://webpass.net/'

desc "1.) Scrape Webpass for cities"
task scrape_initial_url: :environment do
  initialPath = 'buildings'

  initialUrl = DOMAIN + initialPath
  doc = Nokogiri::HTML(open(initialUrl))

  doc.css('#nav_tabs li a').each do |link|
    c = City.where(name: link.content).first_or_create
    c.url = link.attributes['href'].to_s
    c.save
  end
end

desc "2.) Scrape cities for buildings"
task scrape_cities: :environment do
  City.all.each do |city|
    url = DOMAIN + city.url

    doc = Nokogiri::HTML(open(url))

    doc.css('#wide_table tr').each do |row|
      name = row.children[0].content
      speeds = row.children[2].content

      b = Building.where(name: name).first_or_create

      b.speeds = speeds.strip
      b.city = city

      b.save
    end
  end
end

desc "3.) From addresses, find lat/long for buildings"
task geocode_buildings: :environment do
  parsed = 0
	Building.ungeocoded.each do |building|
		begin
			results = Geocoder.search(building.address)
		rescue
			break
		else
			if results.length > 0
				location = results[0].geometry['location']
				building.latlon = "#{location['lat']}, #{location['lng']}"
				building.save
				parsed = parsed + 1
			else
				puts "Geocoding #{building.address} failed with #{results}"
				break
			end
		end
	end
	puts "Geocoded #{parsed} buildings"
end

require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    index_page = Nokogiri::HTML(open(index_url))
    students_array = []

    index_page.css(".student-card").each do |student|
      students_hash = {}
      students_hash[:name] = student.css(".student-name").text
      students_hash[:location] = student.css(".student-location").text
      students_hash[:profile_url] = student.css("a").attribute("href").value
      students_array << students_hash
    end
    # binding.pry

    students_array
  end

  def self.scrape_profile_page(profile_url)
    links = {}
    # social_links = []
    profile_page = Nokogiri::HTML(open(profile_url))
    social_links = profile_page.css('.social-icon-container a')
    # binding.pry
    social_links.each do |link|
      # profile_full_name = profile_page.css('.profile-name').text.downcase.split

      if link.attribute('href').value.include?("twitter")
        links[:twitter] = link.attribute('href').value
      end

      if link.attribute('href').value.include?("facebook")
        links[:facebook] = link.attribute('href').value
      end

      if link.attribute('href').value.include?("github")
        links[:github] = link.attribute('href').value
      end

      if link.attribute('href').value.include?("linkedin")
        links[:linkedin] = link.attribute('href').value
      end

      # profile_full_name.each do |f_or_l_name|
        if link.at("img").attribute("src").text == "../assets/img/rss-icon.png"
          links[:blog] = link.attribute('href').value
          break
        end
      # end
      # binding.pry

    end


    links[:profile_quote] = profile_page.css(".profile-quote").text
    links[:bio] = profile_page.at('p').text

    links
  end

end

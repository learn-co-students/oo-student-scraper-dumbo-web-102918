require 'open-uri'
require 'pry'
require "nokogiri"

class Scraper

  def self.scrape_index_page(index_url)
    html = open(index_url)
    doc = Nokogiri::HTML(html)

    index_array = []

    doc.css("div.student-card").each do |card|
      index_array << {
        name: card.css("h4.student-name").text,
        location: card.css("p.student-location").text,
        profile_url: card.css("a").attribute("href").text
      }
    end
    index_array
  end

  def self.scrape_profile_page(profile_url)
    html = open(profile_url)
    doc = Nokogiri::HTML(html)

    hash = {}
    doc.css("div.social-icon-container a").each do |link|
      val = link.attribute("href").text

      if val.include?("twitter")
        hash[:twitter] = val
      elsif val.include?("linkedin")
        hash[:linkedin] = val
      elsif val.include?("github")
        hash[:github] = val
      else
        hash[:blog] = val
      end
    end

    hash[:profile_quote] = doc.css("div.profile-quote").text

    hash[:bio] = doc.css("div.description-holder p").text
hash
  end

end

#Scraper.scrape_index_page("./fixtures/student-site/index.html")

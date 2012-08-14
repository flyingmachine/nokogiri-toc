require 'rubygems'
require 'nokogiri'

class NokogiriTOC
  def self.level_text
    [@level["h2"], @level["h3"], @level["h4"]].join(".").gsub(/\.0/, "")
  end
  
  def self.run(html, options = {})
    options[:content_selector] ||= "body"

    doc = Nokogiri::HTML(html)
    toc = doc.create_element("ol")

    @level = {"h2" => 0, "h3" => 0, "h4" => 0}
    selector = %w{h2 h3 h4}.map{|h| Nokogiri::CSS.xpath_for("#{options[:content_selector]} #{h}")}.join("|")
    
    doc.xpath(selector).each do |node|
      @level[node.name] += 1

      @level["h3"] = 0 if node.name == "h2"
      @level["h4"] = 0 if node.name == "h2" || node.name == "h3"
        
      node.content = level_text + " " + node.content
      puts node.content
    end
  end
end

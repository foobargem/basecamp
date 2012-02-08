# encoding: utf-8

require "nokogiri"
require "net/http"
require "uri"

class SimpleHTMLCrawler

  def self.fetch_and_parse(request_uri)
    parser = new
    parser.fetch(request_uri)
    parser.parse
  end


  def fetch(request_uri, limit = 10)
    uri = URI(request_uri)
    res = Net::HTTP.start(uri.host) do |http|
      req = Net::HTTP::Get.new(uri.request_uri)
      req['User-Agent'] = 'Simple crawler 1.0'
      http.request(req)
    end

    case res
    when Net::HTTPSuccess
      @raw_content = res.body
    when Net::HTTPRedirection
      fetch(res['location'], limit - 1)
    else
      @raw_content = ""
    end
  end

  def parse
    @html_doc = Nokogiri::HTML(@raw_content)
    {
      :title => parse_title,
      :desc => parse_desc,
      :images => parse_images
    }
  end


  private

    def parse_title
      title_tags.each do |tag|
        next unless candidate = @html_doc.css(tag).first
        if tag =~ /^meta/
          return candidate.attributes['content'].value.strip
        else
          return candidate.content.strip
        end
      end
      return ""
    end

    def parse_desc
      desc_tags.each do |tag|
        next if (candidates = @html_doc.css(tag)).empty?
        if tag =~ /^meta/
          return candidates.first.attributes['content'].value.strip
        else
          candidates.each do |c|
            if c.content && c.content.strip.length > 10
              return c.content.strip.gsub(/\s/, ' ')
            end
          end
        end
      end
      return ""
    end

    def parse_images
      images = []

      unless (candidates = @html_doc.css(image_og_tag)).empty?
        images << candidates.first.attributes['content'].value
      end

      candidates = @html_doc.search('img[@src]')

      images += candidates.select{ |c|
        c.attributes['src'].value =~ /\.(jpg|jpeg|png).*?$/i
      }.map{ |c| c.attributes['src'].value }

      if images.empty?
        images += candidates.select{ |c|
          c.attributes['src'].value =~ /\.(gif).*?$/i
        }.map{ |c| c.attributes['src'].value }
      end

      return images
    end

    def title_tags
      ['meta[@property="og:title"]', 'meta[@name="title"]', 'title', 'h1']
    end

    def desc_tags
      ['meta[@property="og:description"]', 'meta[@name="description"]', 'p', 'div']
    end

    def image_og_tag
      'meta[@property="og:image"]'
    end

end


require 'rest-client'
require 'nokogiri'

# desc 'scatter article tag'
task :shanbei_cralwer => :environment do
  i = 0
  index_url = 'https://www.shanbay.com/wordbook/202/'
  index_html = RestClient.get(index_url)
  index_docs = Nokogiri::HTML(index_html.body)
  urls = { }
  index_docs.css('.wordbook-wordlist-name a').each do |index_doc|
    index_doc.text.match(/Unit(\d*)$/)
    key = ($1).to_i
    value = 'https://www.shanbay.com' + index_doc.attributes['href'].text
    urls[key] = value
  end

  urls.each do |chapter, url|
    p "开始抓取第#{chapter}章节"
    unit = Unit.find_by_chapter(chapter) ? Unit.find_by_chapter(chapter) : Unit.create(chapter: chapter)
    (1..6).each do |page|
      p "开始抓取第#{chapter}章节第#{page}页"
      page_url = url + "?page=#{page}"
      html = RestClient.get(page_url)
      doc = Nokogiri::HTML(html.body)
      blocks = doc.css('tr.row')
      blocks.map do |block|
        content = block.css('.span2').text
        meaning = block.css('.span10').text
        if Word.create(unit_id: unit.id, content: content, meaning: meaning) 
          p "第#{i}个单词"
          i += 1
        end
      end
    end
  end
end

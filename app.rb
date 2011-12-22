require 'sinatra'
require 'nokogiri'
require 'open-uri'

memo = {}

get '/:id/:size' do |id, size|
  begin
    if memo[id]
      n = memo[id]
    else
      n = Nokogiri::HTML(open("http://twitter.com/#{id}").read)
      n = n.css('img').first
      n = n['src'].to_s
      puts n
      ext = n.match(/(jpg|png|gif|jpeg)$/)
      n = n.match(%r|http\://a[0-9]\.twimg\.com/profile_images/[0-9]+/[0-9\_(n\_)]+|)
      memo[id] = n
    end
    n = "#{n}#{size}.#{ext}"
    puts n
    redirect n
  rescue => e
    p e
    halt 404
  end
end

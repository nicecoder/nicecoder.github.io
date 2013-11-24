#!/bin/ruby
#encoding: utf-8
require 'open-uri'
require 'nokogiri'

#抓取前90排名的chinaz.com技术编程的排行榜
(1..10).each do |page|
url = "http://top.chinaz.com/list.aspx?p=#{page}&t=13"
response = open(url).read
response.force_encoding("GBK")
response.encode!("utf-8")
f = File.open("./_fech/fech#{page}.txt","w+")
f.puts(response)
end

list = File.open("./_fech/web_list.txt","a+")
(1..10).each do |num|
  f = File.open("./_fech/fech#{num}.txt")
  doc = Nokogiri::HTML(f)
  doc.css('div.webItemList>ul>li').each do |x|
    list.puts "- name: "+x.css('figure>a[target]').attr("title")
    list.puts "  url: "+x.css('figure>a[target]').attr("href").to_s.sub("/t_13/site_","").sub(/\.html$/,"")
    list.puts "  desc: "+x.css('div.desc').inner_html.sub(/<b>[^<]*<\/b>/,"")
    list.puts "  tags: [初始化抓取]"
  end
end

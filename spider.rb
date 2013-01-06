# encoding: utf-8
require 'rubygems'
require 'mechanize'
require 'set'


class Spider
	attr_reader :size
	def initialize(link, size) 
	  @parent_link = link
	  @size = size.to_i
	  @store = []
	end

	def fetch_links(link)
		begin
			agent = Mechanize.new
			extracted_urls= []
			extracted_links = agent.get(link).links
			extracted_links.each do |p|
				extracted_urls << p.uri.to_s if p.uri.to_s.start_with?('http')
			end
		rescue Mechanize::Error 
		end	
		extracted_urls
	end

	def crawl
		begin
			@store << @parent_link
			@store.each do |link|
				break if @store.size >= @size
				puts "fetching from #{link}"
				fetch_links(link).each { |l|  @store << l if !@store.include?(l) and @store.size<@size}
			end
		rescue SystemExit, Interrupt
			puts "You stopped crawling"
		end
		puts "Total URL's: #{@store.size}"
		@store
	end
end


puts "Press ctrl+C to exit"
if ARGV[0] =~ URI::regexp
	puts k = Spider.new(ARGV[0].to_s, ARGV[1] || 999).crawl #Seting size if no size is entered 
else
	puts "Please input a valid url"
end		



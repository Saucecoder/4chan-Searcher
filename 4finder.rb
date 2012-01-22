#!/usr/bin/env ruby


require 'net/http'

fourchan = 'boards.4chan.org'
print 'Enter board: '
board = gets.chomp
until board != ''
puts "This field cant be blank"
board = gets.chomp
end
board = "/#{board}/"
#board = "/v/"
pages = [board]
1.upto(15) {|n| pages << "#{board}#{n.to_s}" }
puts 'Enter a comma separated list of keywords.'
keywords = gets.chomp.split(',')
#keywords = ["AGDG", "agdg", "gamedev", "vidyadev"]
=begin
puts "Please enter comma seperated keywords"
  keywords = gets.chomp
  until keywords.gsub(' ', '').gsub(',', '') != ''
    puts 'Please enter valid keywords.'
    keywords = gets.chomp
  end
  keywords = keywords.split(',')
  keywords.each_index do |i|
    keywords[i] = keywords[i].gsub(' ', '').gsub(',', '')
    keywords[i] = nil if keywords[i] == ''
  end
  keywords.compact!
=end
threads = []
puts 'Searching...'
pages.each do |page|
  Net::HTTP.get(fourchan, page).scan(/res\/\d+/).each do |res|
    threads << res unless threads.include? res
  end
end

threads.each do |thread|
  @results_found = false
  Net::HTTP.get(fourchan, board + thread).split("\n").each do |line|
    keywords.each do |key|
      if line.include? key
        puts fourchan + board + thread
        File.open( "results.txt", "a" ) do |the_file| 
         the_file.puts fourchan + board + thread
        @results_found = true
      end
      if not line.include? key
        puts "No threads were found."
        @results_found = false
      end
      end
      break if @results_found == true
    end
    break if @results_found == true
  end
end

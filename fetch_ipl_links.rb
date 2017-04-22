require 'nokogiri'
require "open-uri"


p = ['Gautam Gambhir' ,
'Manan Vohra' ,
'Shikhar Dhawan' ,
'Hashim Amla' ,
'Saurabh Tiwary' ,
'Krunal Pandya' ,
'Chris Morris' ,
'Ravindra Jadeja' ,
'Parveen Kumar' ,
'Bhunveshwar Kumar' ,
'Tymal Mills' ,
'Umesh Yadav' ,
'Moises Henriques' ,
'Ajinkya Rahane' ,
'Hardik Pandya' ,
'Imran Tahir' ,
'Yuvraj Singh' ,
'Jos Buttler' ,
'Carlos Brathwaite' ,
'Robin Uthappa' ,
'Yuzvendra Chahal' ,
'Parthiv Patel' ,
'Jasprit Bumrah' ,
'Zaheer Khan' ,
'Dinesh Karthik' ,
'Sanju Samson' ,
'Shakib Al Hasan' ,
'Kieron Pollard' ,
'Andre Russell' ,
'Amit Mishra' ,
'Kedar Jadhav' ,
'Trent Boult' ,
'Aaron Finch' ,
'Pat Cummins' ,
'Manish Pandey' ,
'Ashish Nehra']

p.each do |x|
	url = "http://www.bing.com/search?q=#{x.split(' ').join('+')}+iplt20+squad"
	page = Nokogiri::HTML(open(url))
	puts "'#{x}': '#{page.css('#b_results li h2 a')[0].attributes['href'].value}'\n"
end
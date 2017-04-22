# require 'rubygems'
# require 'rexml/document'
# require "net/http"
require "open-uri"
require 'slack-notifier'
# require "addressable/uri"

# require 'active_record'
# require 'yaml'
# require 'require_all'
require 'nokogiri'
# require_all 'models/*.rb'

# db_config = YAML::load(File.open('config/database.yml'))
# ActiveRecord::Base.establish_connection(db_config)


# EXTERNAL = YAML::load(File.open('config/external.yml'))

# SEARCH_API = EXTERNAL['search_api']

# SCRAPE = EXTERNAL['scrape']

module Fetch

NOTIFIER = Slack::Notifier.new "https://hooks.slack.com/services/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", channel: "#fantasy-epl", username: "lalit-modi", "icon_emoji": ":monkey_face:"

PLAYERS = {
'Gautam Gambhir': {'url': 'http://www.iplt20.com/teams/kolkata-knight-riders/squad/84/Gautam-Gambhir/', 'team': 'KT', 'real_team': 'kolkata-knight-riders' },
'Manan Vohra': {'url': 'http://www.iplt20.com/teams/kings-xi-punjab/squad/1085/manan-vohra', 'team': 'KT', 'real_team': 'kings-xi-punjab' },
'Shikhar Dhawan': {'url': 'http://www.iplt20.com/teams/sunrisers-hyderabad/squad/41/shikhar-dhawan', 'team': 'KT', 'real_team': 'sunrisers-hyderabad' },
'Hashim Amla': {'url': 'http://www.iplt20.com/teams/kings-xi-punjab/squad/456/Hashim-Amla', 'team': 'KT', 'real_team': 'kings-xi-punjab' },
'Saurabh Tiwary': {'url': 'http://www.iplt20.com/teams/delhi-daredevils/squad/163/Saurabh-Tiwary/', 'team': 'KT', 'real_team': 'delhi-daredevils' },
'Krunal Pandya': {'url': 'http://www.iplt20.com/teams/mumbai-indians/squad/3183/Krunal-Pandya/', 'team': 'KT', 'real_team': 'mumbai-indians' },
'Chris Morris': {'url': 'http://www.iplt20.com/teams/delhi-daredevils/squad/836/chris-morris', 'team': 'KT', 'real_team': 'delhi-daredevils' },
'Ravindra Jadeja': {'url': 'http://www.iplt20.com/teams/gujarat-lions/squad/9/ravindra-jadeja', 'team': 'KT', 'real_team': 'gujarat-lions' },
'Praveen Kumar': {'url': 'http://www.iplt20.com/teams/kings-xi-punjab/squad/77/praveen-kumar', 'team': 'KT', 'real_team': 'kings-xi-punjab' },
'Bhuvneshwar Kumar': {'url': 'http://www.iplt20.com/teams/sunrisers-hyderabad/squad/116/Bhuvneshwar-Kumar/', 'team': 'KT', 'real_team': 'sunrisers-hyderabad' },
'Tymal Mills': {'url': 'http://www.iplt20.com/teams/royal-challengers-bangalore/squad/3319/Tymal-Mills/', 'team': 'KT', 'real_team': 'royal-challengers-bangalore' },
'Umesh Yadav': {'url': 'http://www.iplt20.com/teams/kolkata-knight-riders/squad/59/Umesh-Yadav/', 'team': 'KT', 'real_team': 'kolkata-knight-riders' },
'Moises Henriques': {'url': 'http://www.iplt20.com/teams/sunrisers-hyderabad/squad/388/Moises-Henriques/', 'team': 'WR', 'real_team': 'sunrisers-hyderabad' },
'Ajinkya Rahane': {'url': 'http://www.iplt20.com/teams/rising-pune-supergiant/squad/135/Ajinkya-Rahane/', 'team': 'WR', 'real_team': 'rising-pune-supergiant' },
'Hardik Pandya': {'url': 'http://www.iplt20.com/teams/mumbai-indians/squad/2740/Hardik-Pandya/', 'team': 'WR', 'real_team': 'mumbai-indians' },
'Imran Tahir': {'url': 'http://www.iplt20.com/teams/delhi-daredevils/squad/898/Imran-Tahir/', 'team': 'WR', 'real_team': 'delhi-daredevils' },
'Yuvraj Singh': {'url': 'http://www.iplt20.com/teams/sunrisers-hyderabad/squad/113/yuvraj-singh', 'team': 'WR', 'real_team': 'sunrisers-hyderabad' },
'Jos Buttler': {'url': 'http://www.iplt20.com/teams/mumbai-indians/squad/509/Jos-Buttler/', 'team': 'WR', 'real_team': 'mumbai-indians' },
'Carlos Brathwaite': {'url': 'http://www.iplt20.com/teams/delhi-daredevils/squad/2722/Carlos-Brathwaite/', 'team': 'WR', 'real_team': 'delhi-daredevils' },
'Robin Uthappa': {'url': 'http://www.iplt20.com/teams/kolkata-knight-riders/squad/127/Robin-Uthappa/', 'team': 'WR', 'real_team': 'kolkata-knight-riders' },
'Yuzvendra Chahal': {'url': 'http://www.iplt20.com/teams/royal-challengers-bangalore/squad/111/Yuzvendra-Chahal/', 'team': 'WR', 'real_team': 'royal-challengers-bangalore' },
'Parthiv Patel': {'url': 'http://www.iplt20.com/teams/mumbai-indians/squad/44/Parthiv-Patel/', 'team': 'WR', 'real_team': 'mumbai-indians' },
'Jasprit Bumrah': {'url': 'http://www.iplt20.com/teams/mumbai-indians/squad/1124/Jasprit-Bumrah', 'team': 'WR', 'real_team': 'mumbai-indians' },
'Zaheer Khan': {'url': 'http://www.iplt20.com/teams/delhi-daredevils/squad/165/zaheer-khan', 'team': 'WR', 'real_team': 'delhi-daredevils' },
'Dinesh Karthik': {'url': 'http://www.iplt20.com/teams/delhi-daredevils/squad/102/Dinesh-Karthik/', 'team': 'NN', 'real_team': 'delhi-daredevils' },
'Sanju Samson': {'url': 'http://www.iplt20.com/teams/delhi-daredevils/squad/258/sanju-samson', 'team': 'NN', 'real_team': 'delhi-daredevils' },
'Shakib Al Hasan': {'url': 'http://www.iplt20.com/teams/kolkata-knight-riders/squad/201/Shakib-Al-Hasan/', 'team': 'NN', 'real_team': 'kolkata-knight-riders' },
'Kieron Pollard': {'url': 'http://www.iplt20.com/teams/mumbai-indians/squad/210/Kieron-Pollard/', 'team': 'NN', 'real_team': 'mumbai-indians' },
'Andre Russell': {'url': 'http://www.iplt20.com/teams/kolkata-knight-riders/squad/177/Andre-Russell/', 'team': 'NN', 'real_team': 'kolkata-knight-riders' },
'Amit Mishra': {'url': 'http://www.iplt20.com/teams/delhi-daredevils/squad/30/Amit-Mishra/', 'team': 'NN', 'real_team': 'delhi-daredevils' },
'Kedar Jadhav': {'url': 'http://www.iplt20.com/teams/delhi-daredevils/squad/297/kedar-jadhav', 'team': 'NN', 'real_team': 'delhi-daredevils' },
'Trent Boult': {'url': 'http://www.iplt20.com/teams/sunrisers-hyderabad/squad/969/trent-boult', 'team': 'NN', 'real_team': 'sunrisers-hyderabad' },
'Aaron Finch': {'url': 'http://www.iplt20.com/teams/gujarat-lions/squad/167/Aaron-Finch/', 'team': 'NN', 'real_team': 'gujarat-lions' },
'Pat Cummins': {'url': 'http://www.iplt20.com/teams/kolkata-knight-riders/squad/488/Pat-Cummins/', 'team': 'NN', 'real_team': 'kolkata-knight-riders' },
'Manish Pandey': {'url': 'http://www.iplt20.com/teams/kolkata-knight-riders/squad/123/Manish-Pandey/', 'team': 'NN', 'real_team': 'kolkata-knight-riders' },
'Ashish Nehra': {'url': 'http://www.iplt20.com/teams/sunrisers-hyderabad/squad/115/ashish-nehra', 'team': 'NN', 'real_team': 'sunrisers-hyderabad' }
}
	def self.execute
		begin
		player_stats = {}
		PLAYERS.each do |player, data|
			puts "-"*90
			puts "[ #{Time.now} ] Fetching #{player} - #{data.inspect}"
			puts "-"*90
			page = Nokogiri::HTML(open(data[:url]))

			stat = []
			page.css('.table.player-stats-table').each do |table|
				stat.push(table_to_hash(table))
			end

			player_stats[player] = stat

			puts "#{stat.inspect}"

			puts "-"*90
		end


		team_scores, player_scores = calculate(player_stats)

		notification = "Score Update\n"
		team_scores.each do |team, score|
			notification << "> #{team} : #{score}\n"
		end


		NOTIFIER.ping(notification)
		rescue
			retry
		end
	end


	def self.table_to_hash(page)
		headers = []
		pl = {}
		puts "Fetching Headers...."
		page.css('tr th').each do |h|
			headers.push(h.text)
		end
		puts headers.inspect
		puts page.css('tr')[2..-1].size
		puts "Fetching Player Stats...."
		page.css('tr')[2..-1].each do |h|
			s = h.css('td')
			puts s[0].class.to_s.eql?('Nokogiri::XML::Element')
			if s[0].class.to_s.eql?('Nokogiri::XML::Element') && s[0].text.eql?('2017') 
				puts "Fetching Stats..."
				s.each_with_index do |t,i|
					pl[headers[i].gsub('<b>Batting and Fielding</b>','BATTING_FIELD').gsub('<b>Bowling</b>','BOWLING')] = t.text
				end
				break
			end
		end
		return pl		
	end

	def self.calculate(stats)
		team_scores = {'KT': 0, 'NN': 0, 'WR': 0}
		player_scores = {}
		stats.each do |player, stat|
			# Batting & Fielding
			runs = stat[0]['Runs'].to_i
			sixes = stat[0]['6s'].to_i
			fours = stat[0]['4s'].to_i
			catches = stat[0]['CT'].to_i
			stumps = stat[0]['ST'].to_i
			# fifty_plus = stat[0]['50'].to_i + stat[0]['100'].to_i
			fifty_plus = (runs)/50
			wickets = stat[1]['WKTS'].to_i
			three_plus = (wickets)/3

			score = runs + 
					(sixes*3) + 
					(fours*2) + 
					(wickets*20) + 
					(catches*10) + 
					(stumps*15) + 
					((fifty_plus+three_plus)*20)
			puts "#{player}: #{score}"
			player_scores[player] = score
			team_scores[PLAYERS[player][:team].to_sym] = team_scores[PLAYERS[player][:team].to_sym] + score
		end

		puts team_scores.inspect
		puts player_scores.inspect

		return [team_scores, player_scores]

	end



end


Fetch.execute



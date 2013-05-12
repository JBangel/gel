require 'sinatra'
require './eventlist'

eventlist = GenCon::EventList.load('tmp_dl.zip')
search = %w{1346631 1345695 1346573 1346623 1347662}

set :bind, '0.0.0.0'

get '/' do
  erb :index
end

get '/events' do
  search_parms = params
  @result_list = search_parms.empty? ? eventlist.events : eventlist.search(search_parms)

  erb :events
end

get '/events/:search' do |search|
  event = eventlist.find { |e| e.id == id }

  return "No event found" unless event

  "#{event.id} - #{event.title}<br>#{event.desc}<br><br>"
end

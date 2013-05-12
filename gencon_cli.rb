require 'logging'
require './eventlist'

module GenCon
  def self.get_binding
    binding
  end

  def self.set_log_level level
    Logging.logger.root.level = level
  end

  def self.load filename
    EventList.load filename
  end

  def self.download
    EventList.download
  end
end

layout = Logging::Layouts::Pattern.new :pattern => "[%d] [%-5l] %-20.30c - %m\n"
Logging.logger.root.appenders = Logging.appenders.stdout layout: layout
Logging.logger.root.level = :info

log = Logging::Logger['GenConApp']
log.debug { 'Started script' }

$b = GenCon.get_binding

def handle_input(input)
  begin
    results = eval(input, $b)
    puts " => #{results}"
  rescue SystemExit
    exit
  rescue Exception => e
    puts e.inspect
    puts e.message
    puts e.backtrace
  end
end

repl = -> prompt do
  print prompt
  handle_input gets.chomp!
end

loop do
  repl[">> "]
end







#
#events = GenCon::EventList.load('tmp_dl.zip').events
##events = GenCon::EventList.download.events
#
#search = %w{1346631 1345695 1346573 1346623 1347662}
#
#dl_filename = "tmp_dl.zip"
#GenCon::download_events unless File.exist?(dl_filename)
#
#GenCon::EventFile.new(dl_filename).open
#csvdata = GenCon::load_csv('tmp/ec2013.csv')
##puts csvdata[0]
#
#data = csvdata.select do |line|
#  check = CSV.parse_line(line, {col_sep: ",", quote_char: '"'})[0]
#  rcheck = check[/(\d{7})/, 1]
#  search.include? rcheck
#end
#
#events = []
#data.each do |line|
#  line = CSV.parse_line(line, {col_sep: ",", quote_char: '"'})
#  events << GenCon::Event.new(line[0], line[1], line[2], line[3], line[4], line[5])
#end
#
#events.each { |event| puts event.to_s; puts "" }
#

require 'logging'
require 'enumerator'
require 'open-uri'

require './eventfile'

module GenCon
  class EventList
    include Enumerable

    DOWNLOAD_URI = 'http://community.gencon.com/files/folders/345723/download.aspx'

    attr_reader :events

    def self.load(filename)
      Logging::Logger[self].info { "Loading the events list file"}

      #new_el = self.new
      ef = GenCon::EventFile.new(filename)
      new.send(:events=, ef.events)
    end

    def self.download
      Logging::Logger[self].info { "Downloading the events list"}

      filename = "tmp_dl.zip"
      open(filename, "wb") do |file_out|
        file_out.print open(DOWNLOAD_URI).read
      end

      self.load filename
    end

    def initialize
      @log = Logging::Logger[self]
      @log.info { "Create new EventList object" }
      @events = []
    end

    def each
      @events.each { |event| yield event }
    end

    def search(parms)
      results = events

      parms.keys.each do |key|
        if /\.fuzzy/ =~ key
          skey    = key.split('.').first.to_sym
          pstring = parms[key].gsub(/./) { |l| "#{l}.*"}
          puts "Pattern String = #{pstring.inspect}"
          pattern = Regexp.new(pstring, Regexp::IGNORECASE)
          results = results.select{ |event| event.send(skey) =~ pattern }
        else
          results = results.select{ |event| event.send(key.to_sym) == parms[key] }
        end
      end

      results
    end

    private

    def events= (event_array)
      @events = event_array
      self
    end
  end
end

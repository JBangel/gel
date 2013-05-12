require 'csv'
require 'logging'
require 'zip/zip'

require './event'

module GenCon
  class EventFile
    def initialize(filename)
      @filename = filename
      @log = Logging.logger[self]

      @events = []
    end

    def events
      @events unless @events.empty?
      @log.debug { "Events array empty"}

      parse_csv
    end

    def open
      @log.info { "Opening #{@filename}" }
      entry = Zip::ZipFile.foreach(@filename).select { |entry| entry.name == "event catalog 2013.csv" }
      entry[0].get_input_stream
    end

    def parse_csv
      @log.info { "Parsing the csv" }
      records = []

      zip_entry = Zip::ZipFile.foreach(@filename).select { |entry| entry.name == "event catalog 2013.csv" }
      CSV.parse zip_entry[0].get_input_stream.read, headers: true, header_converters: :symbol do |row|
        records << GenCon::Event.new(row[:game_code],
                                     group:     row[:group],
                                     title:     row[:title],
                                     desc:      row[:short_description],
                                     desc_long: row[:long_description],
                                     type:      row[:event_type])
      end

      @log.info { "Found #{records.count} records" }

      records
    end
  end
end

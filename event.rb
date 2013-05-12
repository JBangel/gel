
#Header
# Game Code,Group,Title,Short Description,Long Description,Event Type,Game System,Rules Edition,Minimum Players,Maximum Players,Age Required,Experience Required,Materials Provided,Start Date,Duration,End Date,GM Names,Web Address,Email Contact,Tournament?,Round Number,Total Rounds,Minimum Play Time,Attendee Registration?,Cost,Location,Room Name,Table Number,Special Category,Tickets Available,Last Modified

module GenCon
  class Event
    attr_reader :id

    def initialize(id, data={})
      @id = id
      @data = data
    end

    def to_s
      @id.to_s
    end

    def <=>(other)
      @id <=> other.id
    end

    def method_missing(m, *args, &block)
      if @data.include? m
        @data[m]
      else
        super
      end
    end
  end
end

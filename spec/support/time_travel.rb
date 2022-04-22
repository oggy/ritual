require 'date'
require 'time'

module Support
  module TimeTravel
    def warp_to(time)
      case time
      when String
        time = Time.parse(time)
        date = Date.new(time.year, time.month, time.day)
      when Time
        date = Date.new(time.year, time.month, time.day)
      when Date
        date = time
        time = date.ctime
      else
        raise ArgumentError, "time must be String, Time, or Date: #{time.inspect}"
      end

      Time.stub(:now).and_return(time)
      Date.stub(:today).and_return(date)
    end

    def stop_time
      warp_to Time.now
    end
  end
end

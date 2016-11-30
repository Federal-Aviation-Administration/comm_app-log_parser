module CommApp

  class LogParser

    VERSION = "1.0.0"

    attr_reader :type

    DELIM = /\_{10}/
    DATE_LINE = /Date, Time:\s+(.+)/
    FACILITY_LINE = /Facility Type\/ID:\s+(.+)/
    TRANSMITTER_OPERATING_FREQUENCY_LINE = /Transmitter Operating Frequency:\s+(.+)/
    RECEIVER_OPERATING_FREQUENCY_LINE = /Receiver Operating Frequency:\s+(.+)/
    IDENT_OF_RADIO = /Identification of Radio:\s+(\w+)/
    RADIO_TYPE = /Radio Type:\s+(.+)/
    TRANSMITTER_SERIAL = /Transmitter Serial Number:\s+(.+)/
    TEST_EQUIPMENT = /Test Equipment:\s+(.+)/
    TIME_FORMAT = "%m/%d/%Y, %k:%M:%S %p"

    DECIMAL = /-?\d*.?\d+/

    def parse(str)
      parse_string(str)
    end

    def parse_log(file_name)
      result = nil
      File.open(file_name) do |f|
        enum = f.each_line
        result = parse_measurements(enum)
      end
      result
    end

    def parse_string(string)
      enum = string.each_line
      parse_measurements(enum)
    end

    protected

    def parse_delimiter(lines)
      lines.next until lines.peek =~ DATE_LINE
    end

    def parse_measurements(lines)
      results = []

      loop do
        line = lines.next
        if line =~ DELIM
          parse_delimiter(lines)
          results << parse_radio(lines)
        end
      end
      results

    end

    def parse_radio(lines)
      result = parse_header(lines)
      if type == 'transmitter'
        full_result = result.merge  TransmitterParser.new.finish_parsing(lines)
      elsif type == 'receiver'
        full_result = result.merge ReceiverParser.new.finish_parsing(lines)
      end
      full_result

    end

    def parse_header(lines)
      result = {}
      result[:date_time] = parse_time(lines.next)
      result[:facility] = parse_facility_line(lines.next)
      result[:operating_freq] = parse_operator_freq(lines.next)
      result
    end

    def finish_parsing(lines)
      result = parse_header2(lines)
      lines.next
      final_result = result.merge parse_radio_measurements(lines)
      final_result[:comments] = parse_comments(lines)
      final_result
    end

    def parse_header2(lines)
      result = {}
      result[:ident] = parse_radio_ident(lines.next)
      result[:radio_type] = parse_radio_type(lines.next)
      result[:serial] = parse_serial(lines.next)
      result[:test_equipment] = parse_test_equipment(lines.next)
      result
    end

    def parse_float(str)
      if DECIMAL.match(str)
        Float(str)
      end
    end

    def parse_enable(str)
      md = /(OFF|ON)/.match(str)
      raise "must be OFF or ON" unless md
      case md[1]
      when 'OFF'
        false
      when 'ON'
        true
      end
    end

    def parse_radio_measurements(lines)
      {}
    end

    def parse_time(line)
      begin
        md = DATE_LINE.match(line)
        if md
          DateTime.strptime(md[1], "%m/%d/%Y, %k:%M:%S %p")
        end
      rescue =>e
        binding.pry
      end
    end

    def parse_facility_line(line)
      md = FACILITY_LINE.match(line)
      md[1] if md
    end

    def parse_operator_freq(line)
      if md  = TRANSMITTER_OPERATING_FREQUENCY_LINE.match(line)
        @type = 'transmitter'
        md[1]
      elsif md = RECEIVER_OPERATING_FREQUENCY_LINE.match(line)
        @type = 'receiver'
        md[1]
      else
        nil
      end
    end

    def parse_transmitter_freq(str)
      md = /(\d+\.?\d+)/.match(str)
      md[1]
    end

    def parse_radio_ident(line)
      md = IDENT_OF_RADIO.match(line)
      md[1] if md
    end

    def parse_radio_type(line)
      md = RADIO_TYPE.match(line)
      md[1] if md
    end

    def parse_serial(line)
      raise 'NotImplemented'
    end

    def parse_test_equipment(line)
      md = TEST_EQUIPMENT.match(line)
      md[1] if md
    end

    def parse_comments(lines)
      result = []
      line = lines.next until line =~ /Comment/
      md = /Comments \(optional\):(.+)/m.match(line)
      result << md[1] unless md[1] == "\n"
      loop do
        next_line = lines.peek
        break if next_line =~ DELIM
        result << lines.next
      end
      if result.empty?
        ""
      else
        result.join("\n")
      end

    end

  end

end

require_relative 'transmitter_parser'
require_relative 'receiver_parser'

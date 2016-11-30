require_relative 'log_parser'
module CommApp

  class LogParser
  end

end

module CommApp

  class TransmitterParser < LogParser

    MEASURED_FREQ = /Measured Frequency \(MHz\):\s+(#{DECIMAL.source})/
    MEASURED_POWER = /Measured Power \(W\):\s+(#{DECIMAL.source})/
    MEASURED_MOD_ON_TONE = /Measured Modulation on Tone \(%\):\s+(.+)/

    def parse_serial(line)
      md = TRANSMITTER_SERIAL.match(line)
      md[1] if md
    end

    def parse_radio_measurements(lines)
      result = {}
      result[:measured_freq] = parse_measured_freq(lines.next)
      result[:measured_power] = parse_measured_power(lines.next)
      result[:measured_modulation] = parse_measured_modulation_on_tone(lines.next)
      lines.next
      result[:osc_freq_step] = parse_osc_frequency_step(lines.next)
      result[:high_or_low_power] = parse_high_or_low_power(lines.next)
      result[:transmitter_power_attenuation_level] = parse_power_attenuation_level_step(lines.next)
      atten_level_max, atten_level_step = parse_max_min_power_attenuation_level_step(lines.next)
      result[:transmitter_max_min_power_attenuation_level] = atten_level_max
      result[:transmitter_max_min_power_attenuation_step] = atten_level_step
      result[:transmitter_modulation_setting] = parse_modulation_setting(lines.next)
      result[:transmitter_atr_switch_setting] = parse_atr_switch_setting(lines.next)
      result[:transmitter_audio_input_setting] = parse_audio_input_setting(lines.next)
      result[:transmitter_in_service_time] = parse_in_service_time(lines.next)
      result[:transmitter_elapsed_time_since_startup] = parse_elapsed_time_since_startup(lines.next)
      result[:transmitter_ptt_timeout_setting] = parse_ptt_timeout_setting(lines.next)
      result[:transmitter_ptt_threshold_setting] = parse_ptt_threshold_setting(lines.next)
      result[:transmitter_software_firmware_active] = parse_software_firmware_active(lines.next)
      result[:transmitter_software_firmware_standby] = parse_software_firmware_standby(lines.next)
      result
    end

    def parse_measured_freq(line)
      md = MEASURED_FREQ.match(line)
      parse_float(md[1]) if md
    end


    def parse_measured_power(line)
      md = MEASURED_POWER.match(line)
      parse_float(md[1]) if md
    end

    def parse_measured_modulation_on_tone(line)
      md = MEASURED_MOD_ON_TONE.match(line)
      parse_float(md[1]) if md
    end

    def parse_osc_frequency_step(line)
      md = /Transmitter OSC Frequency Reference\/Step:(\s+\d+)/.match(line)
      Integer(md[1]) if md
    end

    def parse_high_or_low_power(line)
      md = /Transmitter High\/Low Power:\s+(\w+)/.match(line)
      md[1] if md
    end

    def parse_power_attenuation_level_step(line)
      reg = /Transmitter Power Attenuation Level\/Step:\s+(#{DECIMAL.source})/
      md = reg.match(line)
      parse_float(md[1]) if md
    end



    def parse_max_min_power_attenuation_level_step(line)
      md = /Transmitter Maximum\/Minimum Power Attenuation Level\/Step:(.+)/.match(line)
      if md
        max_min = md[1].split('/')
        max_min.map{|val| parse_float(val)}
      else
        binding.pry
      end
    end

    def parse_modulation_setting(line)
      md = /Transmitter Modulation Setting\/Step:\s+(.+)/.match(line)
      Integer(md[1]) rescue nil
    end

    def parse_atr_switch_setting(line)
      md = /Transmitter ATR Switch Setting:\s+(.+)/.match(line)
      md[1] if md
    end

    def parse_audio_input_setting(line)
      md = /Transmitter Audio Input Setting:\s+(.+)/.match(line)
      md[1] if md
    end

    def parse_in_service_time(line)
      md = /Transmitter In-Service Time:\s+(.+)/.match(line)
      md[1] if md
    end

    def parse_elapsed_time_since_startup(line)
      md = /Transmitter Elapse Time \(since last power-up\):\s+(.+)/.match(line)
      md[1] if md
    end

    def parse_ptt_timeout_setting(line)
      md = /Transmitter PTT Timeout Setting \(sec\):\s+(\d+)/.match(line)
      if md
        Integer( md[1]) rescue nil
      end
    end

    def parse_ptt_threshold_setting(line)
      md = /Transmitter PTT Threshold Setting \(VDC\):\s+(#{DECIMAL.source})/.match(line)
      parse_float(md[1]) if md
    end

    def parse_software_firmware_active(line)
      md = /Transmitter Software\/Firmware \(Active\):\s+(.+)/.match(line)
      md[1] if md
    end

    def parse_software_firmware_standby(line)
      md = /Transmitter Software\/Firmware \(Standby\):\s+(.+)/.match(line)
      md[1] if md
    end

  end

end

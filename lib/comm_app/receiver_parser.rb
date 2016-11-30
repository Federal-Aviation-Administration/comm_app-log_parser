require_relative 'log_parser'
module CommApp

  class ReceiverParser < LogParser

    RECEIVER_SERIAL = /Receiver Serial Number:\s+(.+)/

    def parse_serial(line)
      md = RECEIVER_SERIAL.match(line)
      md[1] if md
    end

    def parse_radio_measurements(lines)
      result = {}
      result[:measured_osc_freq] = parse_measured_osc_freq(lines.next)
      result[:measured_sensitivity_dbm] = parse_measured_sensitivity_dbm(lines.next)
      result[:measured_sensitivity_uv] = parse_measured_sensitivity_uv(lines.next)
      result[:squelch_open_dbm] = parse_squelch_open_dbm(lines.next)
      result[:squelch_open_uv] = parse_squelch_open_uv(lines.next)
      result[:squelch_close_db] = parse_squelch_close_db(lines.next)
      line = lines.next until /Measured Selectivity/ =~ line
      result[:selectivity_6db_upper_bw] = parse_6db_upper_bw(line)
      result[:selectivity_6_db_lower_bw] = parse_6db_lower_bw(lines.next)
      result[:selectivity_60_db_upper_bw] = parse_60db_upper_bw(lines.next)
      result[:selectivity_60_db_lower_bw] = parse_60db_lower_bw(lines.next)
      result[:avc_action_audio_level_varying_db] = parse_avc_action_audio_level_varying_db(lines.next)
      result[:avc_action_audio_level_varying_mod_db] = parse_avc_action_audio_level_varying_mod(lines.next)
      lines.next
      result[:receiver_osc_freq_ref_step] = parse_receiver_osc_freq_ref_step(lines.next)
      result[:receiver_squelch_rf_carrier_enable] = parse_receiver_squelch_rf_carrier_enable(lines.next)
      result[:receiver_squelch_rf_carrier_step] = parse_receiver_squelch_rf_carrier_step(lines.next)
      result[:receiver_audio_snr_enable] = parse_receiver_audio_snr_enable(lines.next)
      result[:receiver_audio_snr_squelch_step_level] = parse_receiver_audio_snr_squelch_step_level(lines.next)
      result[:receiver_audio_input_setting] = parse_receiver_audio_input_setting(lines.next)
      result[:receiver_audio_compressor_enable] = parse_receiver_audio_compressor_enable(lines.next)
      result[:receiver_audio_output_step_level] = parse_receiver_audio_output_step_level(lines.next)
      result[:receiver_mute_audio_enable] = parse_receiver_mute_audio_enable(lines.next)
      result[:receiver_mute_audio_level] = parse_receiver_mute_audio_level(lines.next)
      result[:receiver_mute_audio_delay_release_time_in_ms] = parse_receiver_mute_audio_delay_release_time(lines.next)
      result[:receiver_in_service_time] = parse_receiver_in_service_time(lines.next)
      result[:receiver_elapsed_time_since_startup] = parse_elapsed_time_since_startup(lines.next)
      result[:receiver_software_firmware_active] = parse_software_firmware_active(lines.next)
      result[:receiver_software_firmware_stby] = parse_software_firmware_stby(lines.next)
      result
    end


    def parse_measured_osc_freq(line)
      md = /Measured OSC Frequency \(MHz\):\s+(#{DECIMAL.source})/.match(line)
      if md
        parse_float(md[1])
      end
    end

    def parse_measured_sensitivity_dbm(line)
      md = /Measured Sensitivity \(dBm\):\s+(#{DECIMAL.source})/.match(line)
      if md
        parse_float(md[1])
      end
    end

    def parse_measured_sensitivity_uv(line)
      md = /Measured Sensitivity \(uV\):\s+(#{DECIMAL.source})/.match(line)
      if md
        parse_float(md[1])
      end
    end

    def parse_squelch_open_dbm(line)
      md = /Measured Squelch \(Open, dBm\):\s+(#{DECIMAL.source})/.match(line)
      if md
        parse_float(md[1])
      end
    end

    def parse_squelch_open_uv(line)
      md = /Measured Squelch \(Open, uV\):\s+(#{DECIMAL.source})/.match(line)
      if md
        parse_float(md[1])
      end
    end

    def parse_squelch_close_db(line)
      md = /Measured Squelch \(Close, dB\):\s+(#{DECIMAL.source})/.match(line)
      if md
        parse_float(md[1])
      end
    end

    def parse_6db_upper_bw(line)
      md = /Measured Selectivity - 6dB Upper Bandwidth \(Hz\):\s+(#{DECIMAL.source})/.match(line)
      if md
        parse_float(md[1])
      end
    end

    def parse_6db_lower_bw(line)
      md = /Measured Selectivity - 6dB Lower Bandwidth \(Hz\):\s+(#{DECIMAL.source})/.match(line)
      if md
        parse_float(md[1])
      end
    end

    def parse_60db_upper_bw(line)
      md = /Measured Selectivity - 60dB Upper Bandwidth \(Hz\):\s+(#{DECIMAL.source})/.match(line)
      if md
        parse_float(md[1])
      end
    end

    def parse_60db_lower_bw(line)
      md = /Measured Selectivity - 60dB Lower Bandwidth \(Hz\):\s+(#{DECIMAL.source})/.match(line)
      if md
        parse_float(md[1])
      end
    end

    def parse_avc_action_audio_level_varying_db(line)
      md = /Measured AVC Action - Audio Level - Varying RF \(dB\):\s+(#{DECIMAL.source})/.match(line)
      if md
        parse_float(md[1])
      end
    end

    def parse_avc_action_audio_level_varying_mod(line)
      #    binding.pry
      key = Regexp.new Regexp.escape "Measured AVC Action - Audio Level - Varying % Mod (dB):"
      regex = /#{key.source}\s+(#{DECIMAL.source})/
      md = regex.match(line)
      if md
        parse_float(md[1])
      end
    end

    def parse_receiver_osc_freq_ref_step(line)
      md = /Receiver OSC Frequency Reference\/Step:\s+(#{DECIMAL.source})/.match(line)
      if md
        Integer(md[1])
      end
    end

    def parse_receiver_squelch_rf_carrier_enable(line)
      squelch_regex = Regexp.new Regexp.escape("Receiver Squelch (RF/Carrier) Enable(ON)/Disable(OFF) Setting:")
      md = /#{squelch_regex.source}\s+(.+)/.match(line)
      parse_enable(md[1])
    end

    def parse_receiver_squelch_rf_carrier_step(line)
      md = /Receiver Squelch \(RF\/Carrier\) Setting\/Step:\s+(-?\d+)/.match(line)
      Integer( md[1]) if md
    end

    def parse_receiver_audio_snr_enable(line)
      md = /Receiver Audio SNR \(Noise\) Squelch Enable\(ON\)\/Disable\(OFF\) Setting:\s+(.+)/.match(line)
      return nil unless md
      case md[1]
      when 'OFF'
        false
      when 'ON'
        true
      else
        nil
      end
    end

    def parse_receiver_audio_snr_squelch_step_level(line)
      md = /Receiver Audio SNR \(Noise\) Squelch Level\/Step:\s+(\d+)/.match(line)
      Integer(md[1])
    end

    def parse_receiver_audio_input_setting(line)
      md = /Receiver Audio Input Setting:\s+(.+)/.match(line)
      md[1]
    end

    def parse_receiver_audio_compressor_enable(line)
      md = /Receiver Audio Compressor Enable\(ON\)\/Disable\(OFF\) Setting:\s+(.+)/.match(line)
      parse_enable(md[1])
    end

    def parse_receiver_audio_output_step_level(line)
      md = /Receiver Audio Output Level Setting\/Step:\s+(.+)/.match(line)
      parse_float(md[1])
    end

    def parse_receiver_mute_audio_enable(line)
      md = /Receiver Mute \(Audio\) Enable\(ON\)\/Disable\(OFF\) Setting:\s+(.+)/.match(line)
      parse_enable(md[1])
    end

    def parse_receiver_mute_audio_level(line)
      md = /Receiver Mute \(Audio\) Level Setting \(dB\):\s+(.+)/.match(line)
      md[1]
    end

    def parse_receiver_mute_audio_delay_release_time(line)
      md = /Receiver Mute \(Audio\) Delay Release Time \(ms\):\s+(.+)/.match(line)
      parse_float(md[1])
    end

    def parse_receiver_in_service_time(line)
      md = /Receiver In-Service Time:\s+(.+)/.match(line)
      md[1]
    end

    def parse_elapsed_time_since_startup(line)
      md = /Receiver Elapse Time \(since last power-up\):\s+(.+)/.match(line)
      md[1]
    end

    def parse_software_firmware_active(line)
      md = /Receiver Software\/Firmware \(Active\):\s+(.+)/.match(line)
      md[1]
    end

    def parse_software_firmware_stby(line)
      md = /Receiver Software\/Firmware \(Standby\):\s+(.+)/.match(line)
      md[1]
    end

  end

end

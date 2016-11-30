require_relative '../spec_helper'
require "minitest/spec"
require "minitest/autorun"

#OKC_FILE = TEST + 'data/okc.example.txt'

require "comm_app/log_parser"

module CommApp


  describe LogParser do


    before do
      @parser = LogParser.new
      @text = <<-RADIO
_________________________________________________________________
_________________________________________________________________

Date, Time:  8/23/2016, 2:03:07 PM
Facility Type/ID:  SLCB-RTR
Transmitter Operating Frequency:  322.300 MHz
Identification of Radio:  Main
Radio Type:  CM-300 UDT V2
Transmitter Serial Number:  2UT002741
Test Equipment:  IFR 2947 (Marconi)

Measured Frequency (MHz):  322.300010
Measured Power (W):  10.5
Measured Modulation on Tone (%):  87.5

Transmitter OSC Frequency Reference/Step:  139
Transmitter High/Low Power:  LP
Transmitter Power Attenuation Level/Step:  2.0
Transmitter Maximum/Minimum Power Attenuation Level/Step:  14.0/0.0
Transmitter Modulation Setting/Step:  85
Transmitter ATR Switch Setting:  Transceiver (Normal)
Transmitter Audio Input Setting:  Analog
Transmitter In-Service Time:  23 hour(s)
Transmitter Elapse Time (since last power-up):  0 hour(s), 07 minute(s)
Transmitter PTT Timeout Setting (sec):   0
Transmitter PTT Threshold Setting (VDC):  8.0
Transmitter Software/Firmware (Active):  02.00
Transmitter Software/Firmware (Standby):  02.00

Comments (optional):
_________________________________________________________________
    RADIO

      @result = @parser.parse(@text)[0]
    end

    it 'parses date/time' do
      @result[:date_time].strftime("%m/%d/%Y").must_equal DateTime.new(2016,8,23).strftime("%m/%d/%Y")
    end

    it 'parses facility' do
      @result[:facility].must_equal 'SLCB-RTR'
    end

    it 'parses operation frequency' do
      @result[:operating_freq].must_equal '322.300 MHz'
    end

    it 'parses radio ident' do

      @result[:ident].must_equal 'Main'
    end

    it 'parses radio type' do
      @result.fetch(:radio_type).must_equal 'CM-300 UDT V2'
    end

    it 'parses transmitter serial number' do
      @result.fetch(:serial).must_equal '2UT002741'
    end

    it "parses test equipment" do
      @result.fetch(:test_equipment).must_equal "IFR 2947 (Marconi)"
    end

    it "parses measured frequency" do
      @result.fetch(:measured_freq).must_equal 322.300010
    end

    it "parses measured power" do
      @result.fetch(:measured_power).must_equal 10.5
    end

    it "parses modulation on tone percent" do
      @result.fetch(:measured_modulation).must_equal 87.5
    end

    it "parses osc frequency step" do
      @result.fetch(:osc_freq_step).must_equal 139
    end

    it "parses transmitter high or low power" do
      @result.fetch(:high_or_low_power).must_equal("LP")
    end

    it "parses transmitter power attenuation level" do
      @result.fetch(:transmitter_power_attenuation_level).must_equal 2.0
    end

    it "parses trasmitter maximum minumum power attenuation level" do
      @result.fetch(:transmitter_max_min_power_attenuation_level).must_equal 14.0
      @result.fetch(:transmitter_max_min_power_attenuation_step).must_equal 0.0
    end

    it "parses transmitter moduleation setting/step" do
      @result.fetch(:transmitter_modulation_setting).must_equal 85
    end

    it "parses transmitter atr switch setting" do
      @result.fetch(:transmitter_atr_switch_setting).must_equal "Transceiver (Normal)"
    end

    it "parses transmitter audio input setting" do
      @result.fetch(:transmitter_audio_input_setting).must_equal "Analog"
    end

    it "parses in-service time" do
      @result.fetch(:transmitter_in_service_time).must_equal "23 hour(s)"
    end

    it "parses elapse time since last startup" do
      @result.fetch(:transmitter_elapsed_time_since_startup).must_equal "0 hour(s), 07 minute(s)"
    end

    it "parses pp timout setting" do
      @result.fetch(:transmitter_ptt_timeout_setting).must_equal 0
    end

    it "parses ptt threshold setting" do
      @result.fetch(:transmitter_ptt_threshold_setting).must_equal 8.0
    end

    it "parses software firmware active" do
      @result.fetch(:transmitter_software_firmware_active).must_equal "02.00"
    end

    it "parses software firmware standby" do
      @result.fetch(:transmitter_software_firmware_standby).must_equal "02.00"
    end

    it "parses comments" do
      @result.fetch(:comments).must_equal ""
    end


    describe 'tpr/receiverParser' do

      before do
        @parser = LogParser.new
        @text =<<-RECEIVER
_________________________________________________________________

Date, Time:  8/7/2016, 17:44:54 PM
Facility Type/ID:  SLC ECS
Receiver Operating Frequency:  119.050 MHz
Identification of Radio:  Emergency
Radio Type:  CM-300 VDR V2
Receiver Serial Number:  2VR000730
Test Equipment:  IFR 2947 (Marconi)

Measured OSC Frequency (MHz):  97.649996
Measured Sensitivity (dBm):  -102.9
Measured Sensitivity (uV):  1.60
Measured Squelch (Open, dBm):  -99.3
Measured Squelch (Open, uV):  2.42
Measured Squelch (Close, dB):  4.5
Measured Audio Output (dBm):  -7.9

Measured Selectivity - 6dB Upper Bandwidth (Hz):  12300
Measured Selectivity - 6dB Lower Bandwidth (Hz):  12400
Measured Selectivity - 60dB Upper Bandwidth (Hz):  16800
Measured Selectivity - 60dB Lower Bandwidth (Hz):  18600
Measured AVC Action - Audio Level - Varying RF (dB):  -.3
Measured AVC Action - Audio Level - Varying % Mod (dB):  .3

Receiver OSC Frequency Reference/Step:  168
Receiver Squelch (RF/Carrier) Enable(ON)/Disable(OFF) Setting:  ON
Receiver Squelch (RF/Carrier) Setting/Step:  -37
Receiver Audio SNR (Noise) Squelch Enable(ON)/Disable(OFF) Setting:  ON
Receiver Audio SNR (Noise) Squelch Level/Step:  5
Receiver Audio Input Setting:  Analog
Receiver Audio Compressor Enable(ON)/Disable(OFF) Setting:  ON
Receiver Audio Output Level Setting/Step:  -8.4
Receiver Mute (Audio) Enable(ON)/Disable(OFF) Setting:  OFF
Receiver Mute (Audio) Level Setting (dB):  FULL
Receiver Mute (Audio) Delay Release Time (ms):  0
Receiver In-Service Time:  3 hour(s)
Receiver Elapse Time (since last power-up):  0 hour(s), 12 minute(s)
Receiver Software/Firmware (Active):  02.00
Receiver Software/Firmware (Standby):  02.00

Comments (optional):
_________________________________________________________________
_________________________________________________________________
RECEIVER
        @result = @parser.parse(@text)[0]
      end

      it 'parses date/time' do
        @result[:date_time].strftime("%m/%d/%Y").must_equal DateTime.new(2016,8,7).strftime("%m/%d/%Y")
      end

      it 'parses facility type' do
        @result[:facility].must_equal 'SLC ECS'
      end

      it 'parses operation frequency' do
        @result[:operating_freq].must_equal '119.050 MHz'
      end

      it 'parses radio ident' do
        @result[:ident].must_equal 'Emergency'
      end

      it 'parses radio type' do
        @result[:radio_type].must_equal 'CM-300 VDR V2'
      end

      it 'parsers serial number' do
        @result[:serial].must_equal '2VR000730'
      end

      it 'parses test equipment' do
        @result[:test_equipment].must_equal 'IFR 2947 (Marconi)'
      end

      it 'parses osc frequency' do
        @result[:measured_osc_freq].must_equal 97.649996
      end

      it 'parses sensitivity dbm' do
        @result[:measured_sensitivity_dbm].must_equal -102.9
      end

      it 'parses sensitivity uv' do
        @result[:measured_sensitivity_uv].must_equal 1.60
      end

      it 'parses squelch open dbm' do
        @result[:squelch_open_dbm].must_equal -99.3
      end

      it 'parses squelch open uv' do
        @result[:squelch_open_uv].must_equal 2.42
      end

      it 'parses squelch close db' do
        @result[:squelch_close_db].must_equal 4.5
      end

      it 'parses 6 db upper bandwidth' do
        @result[:selectivity_6db_upper_bw].must_equal 12300
      end

      it 'parses 6 db lower bandwidth' do
        @result[:selectivity_6_db_lower_bw].must_equal 12400
      end

      it 'parses 60 db upper bandwidth' do
        @result[:selectivity_60_db_upper_bw].must_equal 16800
      end

      it 'parses 60 db lower bandwidth' do
        @result[:selectivity_60_db_lower_bw].must_equal 18600
      end

      it 'parses avc action audio level db' do
        @result[:avc_action_audio_level_varying_db].must_equal -0.3
      end

      it 'parses avc action audio level varying mod db' do
        @result[:avc_action_audio_level_varying_mod_db].must_equal 0.3
      end

      it 'parses receiver osc freq reference step' do
        @result[:receiver_osc_freq_ref_step].must_equal 168
      end

      it 'parses receiver squelch rf carrier enable' do
        @result[:receiver_squelch_rf_carrier_enable].must_equal true
      end

      it 'parses receiver squelch rf carrier step' do
        @result[:receiver_squelch_rf_carrier_step].must_equal -37
      end

      it 'parses receiver audio snr squelch enable' do
        @result[:receiver_audio_snr_enable].must_equal true
      end

      it 'parses receiver audio snr squelch level' do
        @result[:receiver_audio_snr_squelch_step_level].must_equal 5
      end

      it 'parses receiver audio input setting' do
        @result[:receiver_audio_input_setting].must_equal 'Analog'
      end

      it 'parses receiver audio compressor enable' do
        @result[:receiver_audio_compressor_enable].must_equal true
      end

      it 'parses receiver audio output step level' do
        @result[:receiver_audio_output_step_level].must_equal -8.4
      end

      it 'parses receiver mute audio enable' do
        @result[:receiver_mute_audio_enable].must_equal false
      end

      it 'parses receiver mute audio level' do
        @result[:receiver_mute_audio_level].must_equal 'FULL'
      end

      it 'parses receiver mute audio delay release time ms' do
        @result[:receiver_mute_audio_delay_release_time_in_ms].must_equal 0
      end

      it 'parses receiver in service time' do
        @result[:receiver_in_service_time].must_equal '3 hour(s)'
      end

      it 'parses elapsed time since startup' do
        @result[:receiver_elapsed_time_since_startup].must_equal "0 hour(s), 12 minute(s)"
      end

      it 'parses receiver software firmware active' do
        @result[:receiver_software_firmware_active].must_equal '02.00'
      end

      it 'parses receiver software firmware standby' do
        @result[:receiver_software_firmware_stby].must_equal '02.00'
      end


    end


    describe 'parsing multiple' do

      before do
        @parser = LogParser.new
        @text = <<-TEXT
_________________________________________________________________
_________________________________________________________________

Date, Time:  8/7/2016, 18:23:29 PM
Facility Type/ID:  SLC ECS
Transmitter Operating Frequency:  119.050 MHz
Identification of Radio:  Emergency
Radio Type:  CM-300 VDT V2
Transmitter Serial Number:  2VT004795
Test Equipment:  IFR 2947 (Marconi)

Measured Frequency (MHz):  119.050019
Measured Power (W):  10.3
Measured Modulation on Tone (%):  89.9

Transmitter OSC Frequency Reference/Step:  141
Transmitter High/Low Power:  LP
Transmitter Power Attenuation Level/Step:  2.2
Transmitter Maximum/Minimum Power Attenuation Level/Step:  14.0/0.0
Transmitter Modulation Setting/Step:  89
Transmitter ATR Switch Setting:  Transceiver (Normal)
Transmitter Audio Input Setting:  Analog
Transmitter In-Service Time:  13 hour(s)
Transmitter Elapse Time (since last power-up):  0 hour(s), 05 minute(s)
Transmitter PTT Timeout Setting (sec):   0
Transmitter PTT Threshold Setting (VDC):  8.0
Transmitter Software/Firmware (Active):  02.00
Transmitter Software/Firmware (Standby):  02.00

Comments (optional):
_________________________________________________________________
_________________________________________________________________

Date, Time:  8/7/2016, 18:17:41 PM
Facility Type/ID:  SLC ECS
Transmitter Operating Frequency:  120.200 MHz
Identification of Radio:  Emergency
Radio Type:  CM-300 VDT V2
Transmitter Serial Number:  2VT004801
Test Equipment:  IFR 2947 (Marconi)

Measured Frequency (MHz):  120.200017
Measured Power (W):  10.2
Measured Modulation on Tone (%):  91.6

Transmitter OSC Frequency Reference/Step:  138
Transmitter High/Low Power:  LP
Transmitter Power Attenuation Level/Step:  2.2
Transmitter Maximum/Minimum Power Attenuation Level/Step:  14.0/0.0
Transmitter Modulation Setting/Step:  95
Transmitter ATR Switch Setting:  Transceiver (Normal)
Transmitter Audio Input Setting:  Analog
Transmitter In-Service Time:  6 hour(s)
Transmitter Elapse Time (since last power-up):  0 hour(s), 06 minute(s)
Transmitter PTT Timeout Setting (sec):   0
Transmitter PTT Threshold Setting (VDC):  8.0
Transmitter Software/Firmware (Active):  02.00
Transmitter Software/Firmware (Standby):  02.00

Comments (optional):
_________________________________________________________________
_________________________________________________________________

Date, Time:  8/7/2016, 18:10:43 PM
Facility Type/ID:  SLC ECS
Transmitter Operating Frequency:  121.900 MHz
Identification of Radio:  Emergency
Radio Type:  CM-300 VDT V2
Transmitter Serial Number:  2VT004747
Test Equipment:  IFR 2947 (Marconi)

Measured Frequency (MHz):  121.900016
Measured Power (W):  9.8
Measured Modulation on Tone (%):  89.9

Transmitter OSC Frequency Reference/Step:  142
Transmitter High/Low Power:  LP
Transmitter Power Attenuation Level/Step:  2.4
Transmitter Maximum/Minimum Power Attenuation Level/Step:  14.0/0.0
Transmitter Modulation Setting/Step:  91
Transmitter ATR Switch Setting:  Transceiver (Normal)
Transmitter Audio Input Setting:  Analog
Transmitter In-Service Time:  6 hour(s)
Transmitter Elapse Time (since last power-up):  0 hour(s), 05 minute(s)
Transmitter PTT Timeout Setting (sec):   0
Transmitter PTT Threshold Setting (VDC):  8.0
Transmitter Software/Firmware (Active):  02.00
Transmitter Software/Firmware (Standby):  02.00

Comments (optional):
_________________________________________________________________
_________________________________________________________________

Date, Time:  8/7/2016, 18:04:39 PM
Facility Type/ID:  SLC ecs
Transmitter Operating Frequency:  123.775 MHz
Identification of Radio:  Emergency
Radio Type:  CM-300 VDT V2
Transmitter Serial Number:  2VT004757
Test Equipment:  IFR 2947 (Marconi)

Measured Frequency (MHz):  123.775017
Measured Power (W):  10.1
Measured Modulation on Tone (%):  90.2

Transmitter OSC Frequency Reference/Step:  138
Transmitter High/Low Power:  LP
Transmitter Power Attenuation Level/Step:  2.4
Transmitter Maximum/Minimum Power Attenuation Level/Step:  14.0/0.0
Transmitter Modulation Setting/Step:  89
Transmitter ATR Switch Setting:  Transceiver (Normal)
Transmitter Audio Input Setting:  Analog
Transmitter In-Service Time:  7 hour(s)
Transmitter Elapse Time (since last power-up):  0 hour(s), 05 minute(s)
Transmitter PTT Timeout Setting (sec):   0
Transmitter PTT Threshold Setting (VDC):  8.0
Transmitter Software/Firmware (Active):  02.00
Transmitter Software/Firmware (Standby):  02.00

Comments (optional):
_________________________________________________________________
_________________________________________________________________

Date, Time:  8/7/2016, 17:57:14 PM
Facility Type/ID:  SLC ECS
Transmitter Operating Frequency:  132.650 MHz
Identification of Radio:  Emergency
Radio Type:  CM-300 VDT V2
Transmitter Serial Number:  2VT004713
Test Equipment:  IFR 2947 (Marconi)

Measured Frequency (MHz):  132.650020
Measured Power (W):  10.1
Measured Modulation on Tone (%):  89.7

Transmitter OSC Frequency Reference/Step:  141
Transmitter High/Low Power:  LP
Transmitter Power Attenuation Level/Step:  2.4
Transmitter Maximum/Minimum Power Attenuation Level/Step:  14.0/0.0
Transmitter Modulation Setting/Step:  89
Transmitter ATR Switch Setting:  Transceiver (Normal)
Transmitter Audio Input Setting:  Analog
Transmitter In-Service Time:  8 hour(s)
Transmitter Elapse Time (since last power-up):  0 hour(s), 07 minute(s)
Transmitter PTT Timeout Setting (sec):   0
Transmitter PTT Threshold Setting (VDC):  8.0
Transmitter Software/Firmware (Active):  02.00
Transmitter Software/Firmware (Standby):  02.00

Comments (optional):
_________________________________________________________________
_________________________________________________________________

Date, Time:  8/7/2016, 17:44:54 PM
Facility Type/ID:  SLC ECS
Receiver Operating Frequency:  119.050 MHz
Identification of Radio:  Emergency
Radio Type:  CM-300 VDR V2
Receiver Serial Number:  2VR000730
Test Equipment:  IFR 2947 (Marconi)

Measured OSC Frequency (MHz):  97.649996
Measured Sensitivity (dBm):  -102.9
Measured Sensitivity (uV):  1.60
Measured Squelch (Open, dBm):  -99.3
Measured Squelch (Open, uV):  2.42
Measured Squelch (Close, dB):  4.5
Measured Audio Output (dBm):  -7.9

Measured Selectivity - 6dB Upper Bandwidth (Hz):  12300
Measured Selectivity - 6dB Lower Bandwidth (Hz):  12400
Measured Selectivity - 60dB Upper Bandwidth (Hz):  16800
Measured Selectivity - 60dB Lower Bandwidth (Hz):  18600
Measured AVC Action - Audio Level - Varying RF (dB):  -.3
Measured AVC Action - Audio Level - Varying % Mod (dB):  .3

Receiver OSC Frequency Reference/Step:  168
Receiver Squelch (RF/Carrier) Enable(ON)/Disable(OFF) Setting:  ON
Receiver Squelch (RF/Carrier) Setting/Step:  -37
Receiver Audio SNR (Noise) Squelch Enable(ON)/Disable(OFF) Setting:  ON
Receiver Audio SNR (Noise) Squelch Level/Step:  5
Receiver Audio Input Setting:  Analog
Receiver Audio Compressor Enable(ON)/Disable(OFF) Setting:  ON
Receiver Audio Output Level Setting/Step:  -8.4
Receiver Mute (Audio) Enable(ON)/Disable(OFF) Setting:  OFF
Receiver Mute (Audio) Level Setting (dB):  FULL
Receiver Mute (Audio) Delay Release Time (ms):  0
Receiver In-Service Time:  3 hour(s)
Receiver Elapse Time (since last power-up):  0 hour(s), 12 minute(s)
Receiver Software/Firmware (Active):  02.00
Receiver Software/Firmware (Standby):  02.00

Comments (optional):
TEXT

      end


      it 'returns correct size of results' do
        result = @parser.parse(@text)
        result.size.must_equal 6
      end

      it 'has correct result' do
        result = @parser.parse(@text)
        result.last[:serial].must_equal '2VR000730'

      end

    end

  end
end

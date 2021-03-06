class RecordingServer
  def initialize
    # Test to ensure that sox is installed
    result = `which sox`
    raise 'Please install sox using an appropriate package manager' if result.empty?
  end

  def start_recording
    filename = 'sample.wav'
    seconds_sample = 10

    system "rm -f #{filename}"

    begin
      # Test to see if the box this is running on has aplay installed
      output = `aplay -l | grep -A 2 Analog`
      matches = output.gsub("\n", '').match(/card (\d+):.*Subdevice #(\d+):/)
      soundcard = "AUDIODRIVER=alsa AUDIODEV=hw:#{matches[1]},#{matches[2]}"
    rescue
      # Do nothing, just catch the error
    end
    system "#{soundcard} rec -c 2 #{filename} trim 0 #{seconds_sample}"
    output = `sox #{filename} -n stat 2>&1 | grep "Maximum amplitude" | awk '{printf $3}'`

    max_amp = output.to_f
    system "rm -f #{filename}"

    #max_amp < 0.1? false : true
    "Result: #{max_amp}"
  end
end
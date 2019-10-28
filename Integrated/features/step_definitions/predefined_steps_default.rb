def awetestlib?
  not Awetestlib::Runner.nil?
rescue
  return false
end

Before do
  @pid_arr = []
  unless awetestlib?
    manifest_file = File.expand_path(File.join(File.dirname(__FILE__), '..', 'manifest.json'))
    require 'json'
    @params = JSON.parse(File.open(manifest_file).read)["params"] #Have access to all params in manifest file
  end
  @text_list = Hash.new()
  @error_file = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'error.txt'))

  if $step_no.to_i < 3
    $step_no = 2
  else
    $step_no = $step_no + 2
  end
  # start_video_recording
end

AfterStep() do
  if @params['capture_all_screenshots']
    take_screenshot
  end
  $step_no = $step_no + 1
  # $step_start_time[$step_no] = Time.now - @video_start_time
end

After do |scenario|
  # end_video_recording
  begin
    if scenario.failed?
      begin
        if scenario.exception.message.include? "Timeout"
          take_screenshot_timeout
        else
          take_screenshot
        end
      rescue
        true
      ensure
      end
      skipped_steps = 0
      scenario.steps.each do |r|
        if r.status.to_s == "skipped"
          skipped_steps +=1
        end
      end
      $step_no += skipped_steps
    else
      $step_no = $step_no - 1
    end
  rescue
    true
  ensure
    @browser.close rescue nil
    @browser.quit rescue nil

    if RUBY_PLATFORM && RUBY_PLATFORM == "java" && @params && (@params["browser"] == "GC" || @params["browser"] == "C")
      Process.kill 'INT', $browser_client.pid+1 rescue nil
      Process.kill 'INT', $browser_client.pid rescue nil
      Process.kill 'INT', $browser.pid+1 rescue nil
      Process.kill 'INT', $browser.pid rescue nil
    end

    if (RUBY_PLATFORM && RUBY_PLATFORM == "java")
      system %{ ps aux | grep selenium-server-standalone.jar | awk '{print $2}'|xargs kill } if(RbConfig::CONFIG['host_os'].include?("darwin"))
      if (@params["browser"] == "IE" || @params["browser"] == "FF") # nested cucumber script
        unless @pid_arr.empty?
          @pid_arr.each do |id|
            system %{ taskkill /pid #{id} /F /t 2>NUL }
          end
        end
      end
      if (@params["browser"] == "FF")
        if(RbConfig::CONFIG['host_os'].include?("darwin"))
          system %{ ps aux | awk '/firefox/ {print $2}'|xargs kill }
        else
          system 'taskkill /F /IM firefox.exe /T 2> NUL'
        end
      end
    else
      system %{ taskkill /F /IM java.exe /T 2>NUL }
    end
  end
end

def take_screenshot_timeout
  abc = File.expand_path("../..", File.dirname(__FILE__))
  file_na = abc.split("/").last
  file_path = File.join(File.dirname(__FILE__), '..', '..', "#{file_na.to_s}_#{$step_no}.jpg")
  if RUBY_PLATFORM && RUBY_PLATFORM == "java"
    #mac
    system("screencapture -m -S -t jpg #{file_path}")
  else
    #win
    require 'win32/screenshot'
    Win32::Screenshot::Take.of(:desktop).write(file_path)
  end
end

def take_screenshot
end

def take_screenshot_from_listener(line_number)
	line_number = '%05d' % line_number
  abc = File.expand_path("../..", File.dirname(__FILE__))
  file_na = abc.split("/").last
  file_path = File.join(File.dirname(__FILE__), '..', '..', "#{file_na.to_s}_#{line_number}_line.jpg")
  unless $browser.nil?
    begin
      $browser.screenshot.save(file_path)
    rescue
    end
  end
end

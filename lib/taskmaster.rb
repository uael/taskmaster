require 'readline'

require 'taskmaster/version'
require 'taskmaster/reader'
require 'taskmaster/config'

module Taskmaster
  def self.main
    begin
      File.readlines(ENV['HOME'] + '/.tmst').each do |line|
        Readline::HISTORY.push(line)
      end
    rescue Exception => ex
      # ignored
    end

    Taskmaster::Config.load
    loop do
      Taskmaster::Reader.getline
    end

    if (f = File.open(ENV['HOME'] + '/.tmst', 'w'))
      Readline::HISTORY.each do |line|
        f.puts line
      end
      f.close
    end
  end
end

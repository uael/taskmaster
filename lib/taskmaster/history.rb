require 'readline'

module Taskmaster
  module History
    HISTO_FILE = ENV['HOME'] + '/.tmst'

    def self.load()
      begin
        File.readlines(HISTO_FILE).each do |line|
          Readline::HISTORY.push(line.chomp)
        end
      rescue Exception
        # ignored
      end
    end

    def self.save()
      begin
        if (f = File.open(HISTO_FILE, 'w'))
          Readline::HISTORY.each do |line|
            f.puts line
          end
          f.close
        end
      rescue Exception
        # ignored
      end
    end
  end
end

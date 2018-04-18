require 'readline'

module Taskmaster
  module History

    def self.load(filename)
      begin
        File.readlines(filename).each do |line|
          Readline::HISTORY.push(line.chomp)
        end
      rescue Exception
        # ignored
      end
    end

    def self.save(filename)
      begin
        if (f = File.open(filename, 'w'))
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

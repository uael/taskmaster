require_relative 'proc'

module Taskmaster
  def self.quit(_args)

    if (f = File.open(ENV['HOME'] + '/.tmst', 'w'))
      Readline::HISTORY.each do |line|
        f.write line + '\n'
      end
      f.close
    end

    puts('kthxbye')
    exit
  end
end

require_relative 'proc'

module Taskmaster
  def self.quit(_args)
    History.save(ENV['HOME'] + '/.tmst')
    puts('kthxbye')
    exit
  end
end

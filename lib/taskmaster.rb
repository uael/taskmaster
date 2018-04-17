require 'readline'

require 'taskmaster/version'
require 'taskmaster/reader'
require 'taskmaster/config'
require 'taskmaster/history'

module Taskmaster
  def self.main
    History.load(ENV['HOME'] + '/.tmst')
    Config.load
    loop do Reader.getline end
    History.save(ENV['HOME'] + '/.tmst')
  end
end

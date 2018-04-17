require 'taskmaster/version'
require 'taskmaster/reader'
require 'taskmaster/config'

module Taskmaster

  def self.main()
    Taskmaster::Config::load()
    loop {
      Taskmaster::Reader::getline()
    }
  end
end

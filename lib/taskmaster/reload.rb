require_relative 'proc'

module Taskmaster

  def self.reload(args)
    if args.length > 0
      return Console::warn("reload: too many arguments")
    end

    Taskmaster::Config::load()
  end
end

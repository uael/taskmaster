require 'yaml'

require_relative 'console'

module Taskmaster
  # noinspection ALL
  module Config
    RC_FILE = ENV['HOME'] + '/.tmrc.yml'
    MAIN_KEY = 'programs'.freeze
    DEFAULT_CONFIG = {
      cmd: '/bin/command-not-found',
      numprocs: 1,
      autostart: true,
      autorestart: 'unexpected', # always/never/unexpected
      exitcodes: [0],
      starttime: 5,
      startretries: 3,
      stopsignal: 'TERM',
      stoptime: 10,
      stdout: '/dev/stdout',
      stderr: '/dev/stderr',
      env: {},
      workingdir: '/tmp',
      umask: 0o22
    }.freeze
    @@data = {}
    @@procs = {}  # TODO: that's not config

    def self.getdata
      @@data
    end

    def self.isConfigured(prog_name)
      @@data.keys.include?(prog_name)
    end

    def self.create
      unless File.exist?(RC_FILE)
        open(RC_FILE, 'w') do |f|
          f.puts(YAML.dump(MAIN_KEY => { editme: DEFAULT_CONFIG }))
        end
        Console.notice(
          "A default config has been generated in '#{RC_FILE}'.",
          'You *might* want to edit it.'
        )
      end
    end

    def self.load
      begin
        create
        data = YAML.load_file(RC_FILE)
      rescue StandardError
        abort("Can't load config file. (#{RC_FILE})")
      end

      if data.keys.include?(MAIN_KEY)
        data = data[MAIN_KEY]
        data.keys.each do |k|
          data[k] = DEFAULT_CONFIG.merge(data[k])
        end
        # TODO: sanitize data from config file
        @@data = data
      end
    end
  end
end

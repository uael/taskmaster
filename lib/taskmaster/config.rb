require 'yaml'

module Taskmaster

  module Config

    RC_FILE = ENV['HOME'] + '/.tmrc.yml'
    MAIN_KEY = 'programs'
    DEFAULT_CONFIG = {
      :cmd => '/bin/command-not-found',
      :numprocs => 1,
      :autostart => true,
      :autorestart => 'unexpected', # always/never/unexpected
      :exitcodes => [0],
      :starttime => 5,
      :startretries => 3,
      :stopsignal => 'TERM',
      :stoptime => 10,
      :stdout => '/dev/stdout',
      :stderr => '/dev/stderr',
      :env => {},
      :workingdir => '/tmp',
      :umask => 022,
    }
    @@config = {}
    @@procs = {}

    def self.getdata()
      @@config
    end

    def self.isconfigured(prog_name)
      @@config.keys.include?(prog_name)
    end

    def self.create()
      unless File.exist?(RC_FILE)
        open(RC_FILE, 'w') {|f|
          f.puts(YAML.dump({MAIN_KEY =>
            {:editme => DEFAULT_CONFIG}
          }))
        }
        puts(
          "A default config has been generated in '#{RC_FILE}'.",
          'You *might* want to edit it.'
        )
      end
    end

    def self.load()
      begin
        create
        data = YAML.load_file(RC_FILE)
      rescue
        abort("Can't load config file. (#{RC_FILE})")
      end

      if data.keys.include?(MAIN_KEY)
        data = data[MAIN_KEY]
        data.keys.each {|k|
          data[k] = DEFAULT_CONFIG.merge(data[k])
        }
        # TODO: sanitize data from config file
        @@config = data
      end
    end
  end
end

require 'popen3'

module Tm
  module Console
    def which(cmd)
      exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
      ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
        exts.each { |ext|
          exe = File.join(path, "#{cmd}#{ext}")
          return exe if File.executable?(exe) && !File.directory?(exe)
        }
      end
      nil
    end
  end

  class Proc
    class Conf
      @cmd = "true"
      @count = 1
      @autostart = true
      @autorestart = "unexpected"
      @exitcodes = [0]
      @startretries = 3
      @stopsignal = "TERM"
      @stoptime = 10
      @stdout = "/dev/stdout"
      @stderr = "/dev/stderr"
      @env = {}
      @workingdir = "/tmp"
      @umask = 022

      # @param [String] cmd
      # @return [String] Resolved command string
      def self.cmd(cmd)
        unless (@cmd = Tm::Console::which(cmd))
          raise ArgumentError, 'Command not found'
        end
        @cmd
      end
    end

    @conf = Conf()
  end
end

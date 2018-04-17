module Taskmaster

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
        unless (@cmd = Taskmaster::Console::which(cmd))
          raise ArgumentError, 'Command not found'
        end
        @cmd
      end
    end

    @conf = Conf.new
  end
end

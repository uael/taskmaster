require 'open3'

module Taskmaster

  class Proc
    # noinspection RubyTooManyInstanceVariablesInspection
    class Conf
      attr_accessor :cmd

      @cmd = 'true'
      @count = 1
      @autostart = true
      @autorestart = 'unexpected'
      @exitcodes = [0]
      @startretries = 3
      @stopsignal = 'TERM'
      @stoptime = 10
      @stdout = '/dev/stdout'
      @stderr = '/dev/stderr'
      @env = {}
      @workingdir = '/tmp'
      @umask = 0o22

      def setcmd(cmd)
        unless (@cmd = Taskmaster::Console.which(cmd))
          raise ArgumentError, "#{cmd}: Command not found"
        end
        @cmd
      end
    end

    @conf = Conf.new
    @threads = []

    def self.new(conf)
      @conf.setcmd conf[:cmd]
    end

    def self.spawn
      @threads.each do |thread|
        thread.exit if thread and thread.instance_of? Thread
      end
      (0..@count).step(1) do
        Console.spawn @conf.cmd do |stdout, stderr, thread|
          puts "stdout: #{stdout}" # => "simple output"
          puts "stderr: #{stderr}" # => "error: an error happened"
          puts "pid: #{thread.pid}" # => 12345
          @threads.push thread
        end
      end
    end
  end
end

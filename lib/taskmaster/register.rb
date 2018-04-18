module Taskmaster

    module Register
        LOG_FILE = ENV["HOME"] + "/tm.log"

        def self.format(line)
            Time.new.strftime("[%Y/%m/%d %H:%M:%S] #{line}")
        end

        def self.log(msg)
            begin
                open(Register::LOG_FILE, "a") { |f|
                    f.puts(Register::format(msg))
                }
            rescue
                abort("Can't write to log file. (#{Register::LOG_FILE})")
            end
        end

        # def self.status(line)
        #     Register::log(line)
        # end

        # def self.start(line)
        #     Register::log(line)
        # end

        # def self.stop(line)
        #     Register::log(line)
        # end

        # def self.restart(line)
        #     Register::log(line)
        # end

        # def self.reload(line)
        #     Register::log(line)
        # end

        # def self.quit(line)
        #     Register::log(line)
        # end

        # def self.launch(line)
        #     Register::log(line)
        # end
    end

end

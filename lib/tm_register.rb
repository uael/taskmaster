module Tm_register
    LOG_FILE = ENV["HOME"] + "/tm.log"

    def self.format(line)
        Time.new.strftime("[%Y/%m/%d %H:%M:%S] #{line}")
    end

    def self.log(msg)
        begin
            open(Tm_register::LOG_FILE, "a") { |f|
                f.puts(Tm_register::format(msg))
            }
        rescue
            abort("Can't write to log file. (#{Tm_register::LOG_FILE})")
        end
    end

    # def self.status(line)
    #     Tm_register::log(line)
    # end

    # def self.start(line)
    #     Tm_register::log(line)
    # end

    # def self.stop(line)
    #     Tm_register::log(line)
    # end

    # def self.restart(line)
    #     Tm_register::log(line)
    # end

    # def self.reload(line)
    #     Tm_register::log(line)
    # end

    # def self.quit(line)
    #     Tm_register::log(line)
    # end

    # def self.launch(line)
    #     Tm_register::log(line)
    # end
end

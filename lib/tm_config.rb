require "yaml"

module Tm_config
    RC_FILE = ENV["HOME"] + "/.tmrc"

    def self.load()
        YAML.load_file(Tm_config::RC_FILE)
    end

    def self.save(data)
        open(Tm_config::RC_FILE, "w") { |f|
            f.puts(YAML.dump(data))
        }
    end
end

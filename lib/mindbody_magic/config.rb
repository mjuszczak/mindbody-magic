require 'yaml'

module MindbodyMagic
  module Config
    def self.load_from_file(filename)
      raise "'#{filename}' doesn't exist." unless File.exist?(filename)
      YAML.load(ERB.new(File.read(filename)).result)
    end
  end
end

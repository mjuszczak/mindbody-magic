require 'sequel'
Sequel.extension :migration

require 'mindbody-api'

require 'active_support'
require 'active_support/core_ext'

require 'mindbody_magic/version'
require 'mindbody_magic/config'

MM_LOGGER = Logger.new($stderr)

module MindbodyMagic
  def self.init(config)
    begin
      DB
    rescue NameError
      raise "DB must be initialized before calling MindbodyMagic.init()"
    end

    require 'mindbody_magic/tasks'
    require 'mindbody_magic/models'

    MindbodyMagic.configure_mb_api(config)
  end

  def self.connect_db(config)
    db_config = config.deep_symbolize_keys[:database]

    raise "no database config provided" if db_config.nil?

    # URL-based database configs need to take precedence, but still pass the other
    # arguments into Sequel.connect.
    db =
      if db_config.key?(:url)
        Sequel.connect(db_config[:url], db_config.reject {|k, v| k == :url }.merge(test: true))
      else
        Sequel.connect(db_config.merge(test: true))
      end

    db.integer_booleans = true if const_defined?('Sequel::SQLite') and db.is_a?(Sequel::SQLite::Database)

    db
  end

  def self.configure_mb_api(config)
    mb_config = config.deep_symbolize_keys[:mindbody]

    raise "no mindbody config provided" if mb_config.nil?

    mb_config[:site_ids] = [ mb_config[:site_id] ]
    mb_config.delete(:site_id)

    MindBody.configure do |mb|
      mb_config.each_pair do |k, v|
        mb.send("#{k}=", v)
      end
    end
  end
end

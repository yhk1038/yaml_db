module YamlDb
  module RakeTasks
    def self.data_dump_task
      SerializationHelper::Base.new(helper).dump(db_dump_data_file(helper.extension))
    end

    def self.data_dump_dir_task
      dir = ENV['dir'] || default_dir_name
      SerializationHelper::Base.new(helper).dump_to_dir(dump_dir("/#{dir}"))
    end

    def self.data_load_task
      truncate = ENV['reset_row'] || false
      SerializationHelper::Base.new(helper).load(db_dump_data_file(helper.extension), truncate)
    end

    def self.data_load_specific_file_task
      dir = ENV['dir'] || 'base'
      file = ENV['file'] || 'view_counts1'
      truncate = ENV['reset_row'] || false
      SerializationHelper::Base.new(helper).load(db_dump_a_file(dir, file, helper.extension), truncate)
    end

    def self.data_load_dir_task
      dir = ENV['dir'] || 'base'
      truncate = ENV['reset_row'] || false
      SerializationHelper::Base.new(helper).load_from_dir(dump_dir("/#{dir}"), truncate)
    end

    private

    def self.default_dir_name
      Time.now.strftime('%FT%H%M%S')
    end

    def self.db_dump_data_file(extension = 'yml')
      "#{dump_dir}/data.#{extension}"
    end

    def self.db_dump_a_file(dir, filename, extension = 'yml')
      ddir = dump_dir("/#{dir}")
      "#{ddir}/#{filename}.#{extension}"
    end

    def self.dump_dir(dir = '')
      "#{Rails.root}/db#{dir}"
    end

    def self.helper
      format_class = ENV['class'] || 'YamlDb::Helper'
      format_class.constantize
    end
  end
end

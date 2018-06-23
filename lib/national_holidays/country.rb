require 'countries'

class NationalHolidays
  class Country
    attr_reader :code, :name

    def self.all
      Dir.glob("#{NationalHolidays.config_directory}/*").sort.map do |country_directory|
        new(File.basename(country_directory))
      end
    end

    def initialize(code)
      @code = code.to_sym
      @name = ISO3166::Country.new(code).name
    end

    def regions
      dir = "#{NationalHolidays.config_directory}/#{code}"

      if Dir.exist?(dir)
        Dir.glob("#{dir}/*.yml").sort.map do |filename|
          Region.new(File.basename(filename).sub(%r{\.yml}, ''))
        end
      else
        raise NationalHolidays::UnknownCountryError, "Unknown country: #{code}"
      end
    end
  end
end

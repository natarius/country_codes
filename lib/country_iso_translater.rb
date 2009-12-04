# provides translation between ISO 3166 names and codes
# country_select plugin should be using ISO 3166 names
# http://www.iso.org/iso/english_country_names_and_code_elements
# additional code types can be added in config/countries.yml with translation methods added in this helper

require 'yaml'

module SunDawg 
  module CountryIsoTranslater
    # allows client application to override YAML hash
    FILE = File.expand_path(File.join(File.dirname(__FILE__), 'countries.yml')) unless defined?(FILE)
    COUNTRIES = YAML.load_file(FILE) unless defined?(COUNTRIES)

    # O(N) translation from iso3166 name to 2-digit code
    def self.translate_iso3166_name_to_alpha2(name)
      translate_standard(name, "name", "alpha2")
    end

    def self.translate_iso3166_name_to_alpha3(name)
      translate_standard(name, "name", "alpha3")
    end

    def self.translate_iso3166_alpha2_to_alpha3(code)
      translate_standard(code, "alpha2", "alpha3")
    end

    def self.translate_iso3166_alpha3_to_name(code)
      translate_standard(code, "alpha3", "name")
    end

    # O(N) translation from one convention standard to another
    def self.translate_standard(s, from_standard, to_standard)
      COUNTRIES.each_pair { |key, value| 
        return value[to_standard] if value[from_standard] == s 
      }
      raise NoCountryError.new("[#{s}] IS NOT VALID")
    end

    # O(1) translation of iso3166 2-digit code to name
    def self.translate_iso3166_alpha2_to_name(code)
      country = COUNTRIES[code]
      raise NoCountryError.new("[#{code}] IS NOT VALID") if country.nil?
      country["name"]  
    end

    # O(1) find for iso 4217 currency information
    def self.get_iso4217_currency_by_iso3166_alpha2(code)
      country = COUNTRIES[code]
      raise NoCountryError.new("[#{code}] IS NOT VALID") if country.nil?
      raise NoCurrencyError.new("[#{code}] HAS NO ISO4217 CURRENCY") if country["currency_iso4217"].nil?
      country["currency_iso4217"]
    end
  
    def self.build_html_unicode(unicode_hex)
      s = ""
      if unicode_hex.class == Fixnum
        s = "&#x#{unicode_hex.to_s(16)}"
      elsif unicode_hex.class == Array
        unicode_hex.each { |i|
          s += "&#x#{i.to_s(16)}"
        }
      end 
      s
    end

    class NoCountryError < StandardError
    end

    class NoCurrencyError < StandardError
    end
  end
end

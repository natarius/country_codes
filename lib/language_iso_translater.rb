# manages language ISO-639 information
# http://en.wikipedia.org/wiki/List_of_ISO_639-1_codes

require 'yaml'

module SunDawg 
  module LanguageIsoTranslater
    # allows client application to override YAML hash
    FILE = File.expand_path(File.join(File.dirname(__FILE__), 'languages.yml')) unless defined?(FILE)
    LANGUAGES = YAML.load_file(FILE) unless defined?(LANGUAGES)

    # O(1) fetch of language properties given the ISO_639_1 2-letter code
    def self.get_iso_639_1_translation(code)
      raise NoLanguageError.new("[#{code}] IS NOT VALID") if LANGUAGES[code].nil?
      LANGUAGES[code]
    end

    class NoLanguageError < StandardError
    end
  end
end

# Needed to process "no" for Norwegian. It is a reserved word in YAML :/.
SunDawg::LanguageIsoTranslater::LANGUAGES.keys.each do |k|
  if k.size > 2
    v = SunDawg::LanguageIsoTranslater::LANGUAGES[k]
    SunDawg::LanguageIsoTranslater::LANGUAGES.delete(k)
    SunDawg::LanguageIsoTranslater::LANGUAGES[k[2..3]] = v
  end
end

require 'test_helper'

# allows override of FILE
module SunDawg 
  module LanguageIsoTranslater
    FILE = "lib/languages.yml"
  end
end

require 'language_iso_translater'

class LangaugeIsoTranslaterTest < Test::Unit::TestCase 
  def test_english
    h = client.get_iso_639_1_translation("en")
    assert_equal "English", h['name']
    assert_equal "eng", h['alpha3t']
  end

  def test_norwegian
    h = client.get_iso_639_1_translation("no")
    assert_equal "Norwegian", h['name']
    assert_equal "nor", h['alpha3t']
  end

  def test_data_integrity
    SunDawg::LanguageIsoTranslater::LANGUAGES.each_pair do |k, v|
      assert_equal 2, k.to_s.size
      assert v['name']
      assert v['family']
      assert v['alpha3t']
      assert_equal 3, v['alpha3t'].size
      assert ['Algonquian', 'Dene-Yeniseian', 'Japonic', 'Quechuan', 'Turkic', 'Northwest Caucasian', 'Nilo-Saharan', 'Language Isolate', 'Tai-Kadai', 'Sino-Tibetan', 'Aymaran', 'Constructed', 'Northeast Caucasian', 'Mongolic', 'Austro-Asiatic', 'South Caucasian', 'Tupi-Guarani', 'Creole', 'Finno-Ugric', 'Eskimo-Aleut', 'Turkic', 'Austronesian', 'Dravidian', 'Indo-European', 'Afro-Asiatic', 'Niger-Congo'].include?(v['family'])
    end    
  end

  protected

  def client
    SunDawg::LanguageIsoTranslater
  end
end

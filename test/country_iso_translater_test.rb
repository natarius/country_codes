require 'test_helper'

# allows override of FILE
module SunDawg 
  module CountryIsoTranslater
    FILE = "lib/countries.yml"
  end
end

require 'country_iso_translater'

class CountryIsoTranslaterTest < Test::Unit::TestCase 
  def test_iso3166_alpha2_to_name
    assert_equal client.translate_iso3166_alpha2_to_name("US"), "United States"
    assert_equal client.translate_iso3166_alpha2_to_name("HU"), "Hungary"
  end

  def test_iso3166_name_to_alpha2
    assert_equal client.translate_iso3166_name_to_alpha2("United States"), "US"
    assert_equal client.translate_iso3166_name_to_alpha2("Jordan"), "JO"
  end

  def test_iso3166_name_to_alpha3
    assert_equal client.translate_iso3166_name_to_alpha3("United States"), "USA"
    assert_equal client.translate_iso3166_name_to_alpha3("Egypt"), "EGY"
  end

  def test_iso3166_alpha3_to_name
    assert_equal client.translate_iso3166_alpha3_to_name("USA"), "United States"
    assert_equal client.translate_iso3166_alpha3_to_name("ESP"), "Spain"
  end

  def test_translate_standard
    assert_equal client.translate_standard("CN", "alpha2", "name"), "China"
    assert_equal client.translate_standard("China", "name", "alpha2"), "CN"
  end

  def test_error_on_invalid_country
    begin
      client.translate_iso3166_name_to_alpha2("Candyland")
      fail "Expected client::NoCountryError"
    rescue client::NoCountryError => e
      assert_equal e.to_s, "[Candyland] IS NOT VALID"
    rescue => e
      fail "Expected client::NoCountryError"
    end
  end

  def test_error_on_invalid_alpha2
    begin
      client.translate_iso3166_alpha2_to_name("XX")
      fail "Expected client::NoCountryError"
    rescue client::NoCountryError => e
      assert_equal e.to_s, "[XX] IS NOT VALID"
    rescue => e
      fail "Expected client::NoCountryError"
    end
  end

  protected

  def client
    SunDawg::CountryIsoTranslater
  end
end

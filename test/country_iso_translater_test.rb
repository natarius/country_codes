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

  def test_get_iso4217_currency_by_iso3166_alpha2
    currency = client.get_iso4217_currency_by_iso3166_alpha2("US")
    assert_equal currency["code"], "USD"
    assert_equal currency["symbol"], "$"
    assert_equal currency["name"], "Dollars"
    assert_equal currency["unicode_hex"], 36
    assert_equal currency["unicode_hex"].to_s(16), "24"

    currency = client.get_iso4217_currency_by_iso3166_alpha2("AF")
    assert_equal currency["code"], "AFN"
    assert_equal currency["symbol"], "؋"
    assert_equal currency["name"], "Afghanis"
    assert_equal currency["unicode_hex"], 1547

    currency = client.get_iso4217_currency_by_iso3166_alpha2("AL")
    assert_equal currency["unicode_hex"].class, Array
    assert_equal currency["unicode_hex"][0], 76

    currency = client.get_iso4217_currency_by_iso3166_alpha2("AT")
    assert_equal currency["code"], "EUR"

    currency = client.get_iso4217_currency_by_iso3166_alpha2("NZ")
    assert_equal currency["code"], "NZD"
  end

  def test_data_integrity
    SunDawg::CountryIsoTranslater::COUNTRIES.each_pair { |k, v|
      # check country codes
      assert_not_nil v["alpha2"]
      assert_not_nil v["alpha3"]
      assert_not_nil v["name"]

      # check currency code and name
      unless v["currency_iso4217"].nil?
        assert_not_nil v["currency_iso4217"]["code"]
        assert_not_nil v["currency_iso4217"]["name"]
        unless v["currency_iso4217"]["alt_currency"].nil?
          assert_not_nil v["currency_iso4217"]["alt_currency"]["code"]
          assert_not_nil v["currency_iso4217"]["alt_currency"]["name"]
        end

        # if symbol is present, make sure unicode_hex is present
        unless v["currency_iso4217"]["symbol"].nil?
          assert_not_nil v["currency_iso4217"]["unicode_hex"]
        end
      end

      # check to make sure currency_iso4217 is spelled correctly
      v.each_pair { |k2, v2|
        assert_equal k2, "currency_iso4217" if (k2[0..1] == "c")
      }
    }
  end

  def test_error_on_invalid_currency
    assert_raise SunDawg::CountryIsoTranslater::NoCountryError do
      client.get_iso4217_currency_by_iso3166_alpha2("XX")
    end

    assert_raise SunDawg::CountryIsoTranslater::NoCurrencyError do
      client.get_iso4217_currency_by_iso3166_alpha2("AX")
    end
  end

  def test_error_on_invalid_country
    assert_raise SunDawg::CountryIsoTranslater::NoCountryError do
      client.translate_iso3166_name_to_alpha2("Candyland")
    end
  end

  def test_error_on_invalid_alpha2
    assert_raise SunDawg::CountryIsoTranslater::NoCountryError do
      client.translate_iso3166_alpha2_to_name("XX")
    end
  end

  def test_build_html_unicode
    currency = client.get_iso4217_currency_by_iso3166_alpha2("US")    
    assert_equal client.build_html_unicode(currency["unicode_hex"]), "&#x24"
    currency = client.get_iso4217_currency_by_iso3166_alpha2("TH")    
    assert_equal client.build_html_unicode(currency["unicode_hex"]), "&#xe3f"
    currency = client.get_iso4217_currency_by_iso3166_alpha2("UZ")
    assert_equal client.build_html_unicode(currency["unicode_hex"]), "&#x43b&#x432"
  end

  protected

  def client
    SunDawg::CountryIsoTranslater
  end
end

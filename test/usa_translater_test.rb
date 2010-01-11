require 'test_helper'

# allows override of FILE
module SunDawg 
  module USAStateTranslater
    FILE = "lib/usa_states.yml"
  end
end

require 'usa_state_translater'

class USAStateTranslaterTest < Test::Unit::TestCase 
  def test_code_to_name
    assert_equal 'California', client.translate_code_to_name('CA')
    assert_equal 'New York', client.translate_code_to_name('NY')
  end

  def test_name_to_code
    assert_equal 'TX', client.translate_name_to_code('Texas')
    assert_equal 'UT', client.translate_name_to_code('Utah')
  end

  def test_data_integrity
    assert_equal 50, SunDawg::USAStateTranslater::USA_STATES.size
  end

  def test_error_on_invalid_name
    assert_raise SunDawg::USAStateTranslater::NoStateError do
      client.translate_name_to_code('Petertopia')
    end
  end

  def test_error_on_invalid_state
    assert_raise SunDawg::USAStateTranslater::NoStateError do
      client.translate_code_to_name('XX')
    end
  end

  protected

  def client
    SunDawg::USAStateTranslater
  end
end

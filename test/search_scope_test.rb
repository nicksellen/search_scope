require File.dirname(__FILE__) + '/test_helper.rb'

class SearchScopeTest < Test::Unit::TestCase
  load_schema

  class Bike < ActiveRecord::Base
  end

  class Insult < ActiveRecord::Base
  end

  def test_schema_has_loaded_correctly
    assert_equal [], Bike.all
    assert_equal [], Insult.all
  end

end


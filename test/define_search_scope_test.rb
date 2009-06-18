require File.dirname(__FILE__) + '/test_helper.rb'

class DefineSearchScopeTest < Test::Unit::TestCase
 load_schema

 class Bike < ActiveRecord::Base
 end

 class Insult < ActiveRecord::Base
 end

 def test_ability_to_define_search_scope
  Bike.send(
   :search_scope,
   :default => :everything, 
   :types => { 
     :everything => [:manufacturer, :model], 
     :model_only => [:model] 
    })
 end

 def test_simple_search
  assert_equal [], Bike.search('anything')
 end

 def test_more_complex_search
  Bike.create(:manufacturer => 'kona')

  assert_equal 1, Bike.search('kona').length
  Bike.destroy_all

  Bike.create(:manufacturer => 'marin', :model => 'point reyes')

  assert_equal 0, Bike.search('kona',:type => :model_only).length

  Bike.destroy_all
 end
end

require File.dirname(__FILE__) + '/../test_helper'

class ProfilePlusExtensionTest < Test::Unit::TestCase
  
  # Replace this with your real tests.
  def test_this_extension
    flunk
  end
  
  def test_initialization
    assert_equal File.join(File.expand_path(RAILS_ROOT), 'vendor', 'extensions', 'profile_plus'), ProfilePlusExtension.root
    assert_equal 'Profile Plus', ProfilePlusExtension.extension_name
  end
  
end

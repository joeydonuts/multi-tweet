require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "/groups" do
  before(:each) do
    @response = request("/groups")
  end
end
require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "/twits" do
  before(:each) do
    @response = request("/twits")
  end
end
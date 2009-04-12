require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "/searches" do
  before(:each) do
    @response = request("/searches")
  end
end
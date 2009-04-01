class Group 
  include DataMapper::Resource

  property :id, Serial
  property :group_name, String
  has n, :friends, :through => Resource
  

end

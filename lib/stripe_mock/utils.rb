module StripeMock
  def self.new_id(prefix)
    "#{ prefix }_#{ Faker::Internet.password(16) }"
  end
end

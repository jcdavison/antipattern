module WaffleHelper
  def to_waffle
    Jbuilder.new do |waffle|
      waffle.(self, *self.display_attributes)
    end
  end
end

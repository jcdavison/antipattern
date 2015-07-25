module JsonHelper
  def to_builder
    Jbuilder.new do |bottle|
      bottle.(self, *self.display_attributes)
    end
  end
end

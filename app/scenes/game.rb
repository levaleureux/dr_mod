
#
# TODO describe
#
class Scene::GameScene
  attr_gtk
  def initialize args
    self.args = args
  end

  def tick
  end

  private

  def main_attrs
    #{ size_enum:                1,
    {
      alignment_enum:           0,
      vertical_alignment_enum:  1,
      size_enum:                10
    }
  end

end

class SceneManager
  attr_gtk

  def initialize args
    args.state.current_scene = :title
    puts args.state.current_scene
  end

  def tick
    # capture the current scene to verify it didn't change through
    # the duration of tick
    current_scene = args.state.current_scene

    if args.state.current_scene != current_scene
      raise "Scene was changed incorrectly. Set args.state.next_scene to change scenes."
    end

    # if next scene was set/requested, then transition the current scene to the next scene
    if args.state.next_scene
      puts "next_scene"
      puts args.state.next_scene
      puts args.state.current_scene
      args.state.current_scene = args.state.next_scene
      #
      # on peut ici réinit ou pas c'est le purpose du manager
      # qui devrait etre remplacer par une state machine
      # avec des effets sur les transitions
      #
      puts "after current_scene"
      puts args.state.current_scene
      args.state.next_scene = nil
    end
  end

end

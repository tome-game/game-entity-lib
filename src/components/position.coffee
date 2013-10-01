class tome.PositionComponent extends tome.EntityComponent
  accessible_attrs: 'x y z'

  distance: (position) ->
    (x = position.x()-@x())*x
    (y = position.y()-@y())*y
    (z = position.z()-@z())*z
    Math.sqrt x+y+z
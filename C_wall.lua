-- Wall class

C_wall = {}

C_wall.WIDTH = 4
C_wall.HEIGHT = 32
C_wall.ADJUST_VALUE = 18
  
  -- valid arguments for side are "left", "right", "bottom", "top"
--[[
  C_wall.createWall = function ( xPos, yPos ) 
    if ( side == "right" ) then
      local wall = display.newRect (xPos, yPos, C_wall.WIDTH, C_wall.HEIGHT )
      wall:setFillColor( 0.0, 0.0, 0.0 ) 
      wall.x = wall.x + C_wall.ADJUST_VALUE
      wall_group:insert( wall )
    elseif ( side == "left" ) then
      local wall = display.newRect (xPos, yPos, C_wall.WIDTH, C_wall.HEIGHT ) 
      wall:setFillColor( 0.0, 0.0, 0.0 )
      wall.x = wall.x - C_wall.ADJUST_VALUE
      wall_group:insert( wall )
    elseif ( side == "bottom" ) then
      local wall = display.newRect (xPos, yPos, C_wall.HEIGHT, C_wall.WIDTH )
      wall:setFillColor( 0.0, 0.0, 0.0 )
      wall.y = wall.y + C_wall.ADJUST_VALUE
      wall_group:insert( wall )
    elseif ( side == "top" ) then
      local wall = display.newRect (xPos, yPos, C_wall.HEIGHT, C_wall.WIDTH )
      wall:setFillColor( 0.0, 0.0, 0.0 )
      wall.y = wall.y - C_wall.ADJUST_VALUE
      wall_group:insert( wall )
    end
    return wall_group
  end
--]]

--
C_wall.createRightWall = function ( xPos, yPos ) 
  local wall = display.newRect (xPos, yPos, C_wall.WIDTH, C_wall.HEIGHT )
  wall:setFillColor( 0.0, 0.0, 0.0 ) 
  wall.x = wall.x + C_wall.ADJUST_VALUE
  return wall
end
--
C_wall.createLeftWall = function ( xPos, yPos ) 
  local wall = display.newRect (xPos, yPos, C_wall.WIDTH, C_wall.HEIGHT ) 
  wall:setFillColor( 0.0, 0.0, 0.0 )
  wall.x = wall.x - C_wall.ADJUST_VALUE
  return wall
end
--
C_wall.createBottomWall = function ( xPos, yPos ) 
  local wall = display.newRect (xPos, yPos, C_wall.HEIGHT, C_wall.WIDTH )
  wall:setFillColor( 0.0, 0.0, 0.0 )
  wall.y = wall.y + C_wall.ADJUST_VALUE
  return wall
end
--
C_wall.createTopWall = function ( xPos, yPos ) 
  local wall = display.newRect (xPos, yPos, C_wall.HEIGHT, C_wall.WIDTH )
  wall:setFillColor( 0.0, 0.0, 0.0 )
  wall.y = wall.y - C_wall.ADJUST_VALUE
  return wall
end
--
return C_wall
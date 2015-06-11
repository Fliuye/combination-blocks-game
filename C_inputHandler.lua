-- inputHandler class

-- local C_math = require ( "C_math" )

--[[
    handles variables and functions relating to touch input
--]]
C_inputHandler = {}

--
C_inputHandler.getDirection = function ( block_group, init_x, init_y, event_x, event_y ) 
  local x_difference = math.abs( init_x - event_x ) 
  local y_difference = math.abs ( init_y - event_y ) 
  
  if ( x_difference > y_difference ) then
    if ( x_difference > 20 ) then -- prevents movement from tap
      block_group.moving = true
      if ( init_x < event_x ) then -- moving right
        return "right" -- x vector is longest
      elseif ( init_x > event_x ) then -- moving left
        return "left" -- x vector is longest
      end
    end
  else -- ( x_difference < y_difference ) then
    if ( y_difference > 20 ) then -- prevents movement from tap
      block_group.moving = true
      if  ( init_y < event_y ) then -- moving down
        return "down" -- y vector is longest 
      elseif ( init_y > event_y ) then -- moving up
        return "up" -- y vector is longest
      end
    end
  end
end

--
C_inputHandler.updateTouch = function  ( block_group, direction )
  for i = 1, block_group.numChildren do
    if ( direction == "right" ) then -- moving right
        -- directional_arrow.rotation = 0
        if (not block_group[i].moving ) then
          block_group[i].hsp = block_group.speed
          block_group[i].moving = true
        end
    elseif ( direction == "left" ) then -- moving left
        -- directional_arrow.rotation = 180
        if (not block_group[i].moving ) then
          block_group[i].hsp = -block_group.speed
          block_group[i].moving = true
        end
    elseif ( direction == "down" ) then -- moving down
      -- directional_arrow.rotation = 90
      if (not block_group[i].moving ) then
        block_group[i].vsp = block_group.speed
        block_group[i].moving = true
      end
    elseif ( direction == "up" ) then -- moving up
      -- directional_arrow.rotation = 270
      if (not block_group[i].moving ) then
        block_group[i].vsp = -block_group.speed
        block_group[i].moving = true
      end
    end
  end
end

--
return C_inputHandler



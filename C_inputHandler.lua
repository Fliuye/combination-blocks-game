-- local C_math = require ( "C_math" )

-- inputHandler class

--[[
    handles variables and functions relating to touch input
--]]
C_inputHandler = {}

-- BLOCK MOVEMENT
-- C_inputHandler.initial_x = 0
-- C_inputHandler.initial_y = 0

-- if more math functions, move this to a C_math.lua file 
C_inputHandler.longestVector = function ( init_x, init_y, event_x, event_y ) 
  local x_difference = math.abs( init_x - event_x ) 
  local y_difference = math.abs ( init_y - event_y ) 
  if ( x_difference > y_difference ) then
    if ( x_difference > 20 ) then -- prevents movement from tap
      current_group.moving = true
      return "x greater" -- x vector is longest
    end
  else
    if ( y_difference > 20 ) then -- prevents movement from tap
      current_group.moving = true
      return "y greater" -- y vector is longest 
    end
  end
end

C_inputHandler.initiateTouchListener = function ( block_group )
  touchListener ( event )

-- pass current_group for parameter block_group
C_inputHandler.touchListener = function ( event )
  if ( not block_group.moving ) then
    local initial_x = 0
    local initial_y = 0
    if ( event.phase == "began" ) then
    -- set initial x, y coordinates to where the tap first began 
      initial_x = event.x
      initial_y = event.y
    elseif ( event.phase == "ended" ) then -- code when touch is lifted off object
      local greater_length = longest_vector ( initial_x, initial_y, event.x, event.y ) -- find which direction has the greatest change in distance
      for i = 1, block_group.numChildren do
        if ( greater_length == "x greater" ) then 
          if ( initial_x > event.x ) then -- moving left
            directional_arrow.rotation = 180
            if (not block_group[i].moving ) then
              block_group[i].hsp = -block_group.speed
              block_group[i].moving = true
            end
          elseif (initial_x < event.x) then -- moving right
            directional_arrow.rotation = 0
            if (not block_group[i].moving ) then
              block_group[i].hsp = block_group.speed
              block_group[i].moving = true
            end
          end
        elseif (greater_length == "y greater" ) then
          if ( initial_y > event.y ) then -- moving up
            directional_arrow.rotation = 270
            if (not block_group[i].moving ) then
              block_group[i].vsp = -block_group.speed
              block_group[i].moving = true
            end
          elseif ( initial_y < event.y ) then -- moving down
            directional_arrow.rotation = 90
            if (not block_group[i].moving ) then
              block_group[i].vsp = block_group.speed
              block_group[i].moving = true
            end
          end
        end
      end
    end
    return true --prevents touch propagation to underlying objects
  end
end

return C_inputHandler



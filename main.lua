-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- INITIALIZATION
-----------------------------------------------------------------
-- initialize display settings 
display.setDefault ( "background", 1, 1, 1 )

-- initialize physics 
local physics = require "physics"
physics.start()
physics.setGravity( 0, 0 ) -- deactivate gravity
-- physics.stop() to deactivate physics

-----------------------------------------------------------------
--  1:32 ,  2:64 ,  3:96 ,  4:128 , 5:160 ,6:192 ,7:224 , 8:256 , 9:288 
-- 10:320, 11:352, 12:384, 13:416, 14:448  

--[[
-- left board x
local lbx  = { -4, 28, 60, 92, 124, 156, 188, 220, 252, 284, 316, 348, 380, 412, 444, 476, 508 }
-- right board x
local rbx  = { 4, 36, 68, 100, 132, 164, 196, 228, 260, 292, 324, 356, 388, 424, 452, 484, 516 }
-- up board y
local uby  = { 32, 64, 96, 128, 160, 192, 224, 256, 288, 320, 352, 384, 416, 448, 480, 512 }
-- down board y
local dby  = {1}
--]]


-- BLOCK
-- local BLOCK = 
local red_group = display.newGroup()
-- physics.addBody ( red_group, "dynamic", { friction = 0, bounce = 0 } )

local red_block = display.newImage ("Assets/red.png", 0, 32 ) 
physics.addBody ( red_block, "dynamic", { friction = 0, bounce = 0 } )
red_group:insert ( red_block )

local red_block_two = display.newImage ("Assets/red.png", 64, 96 ) 
physics.addBody ( red_block_two, "dynamic", { friction = 0, bounce = 0 } )
red_group:insert ( red_block_two )

local directional_arrow = display.newImage("Assets/directional_arrow.png", display.contentWidth, 48 )

local function longest_vector ( init_x, event_x, init_y, event_y ) 
  if ( math.abs( init_x - event_x ) > math.abs ( init_y - event_y ) ) then
    return "x greater" -- x vector is longest
  else
    return "y greater" -- y vector is longest 
  end
end

-- set velocity movement to all blocks of current chosen color
local function setBlockMovement ( block_group, direction, velocity )
  for i = 1, block_group.numChildren do
    if ( direction == "x" ) then
      block_group[i]:setLinearVelocity ( velocity, 0 )
    elseif ( direction == "y" ) then
      block_group[i]:setLinearVelocity ( 0, velocity )
    end
  end
end


-- BLOCK MOVEMENT
local initial_x = 0
local initial_y = 0

local function myTouchListener ( event )
  if ( event.phase == "began" ) then
  -- set initial x, y coordinates to where the tap first began 
    initial_x = event.x
    initial_y = event.y

  elseif ( event.phase == "moved" ) then
  -- code when the touch is moved over the object

  elseif ( event.phase == "ended" ) then
  -- code when touch is lifted off object
    
    -- find which direction has the greatest change in distance
    local greater_length = longest_vector ( initial_x, event.x, initial_y, event.y )
    
    if ( greater_length == "x greater" ) then 
      if ( initial_x > event.x ) then -- moving left
        directional_arrow.rotation = 180
        setBlockMovement ( red_group, "x", -450 )
      elseif (initial_x < event.x) then -- moving right
        directional_arrow.rotation = 0
        setBlockMovement ( red_group, "x", 450 )
      end
    elseif (greater_length == "y greater" ) then
      if ( initial_y > event.y ) then -- moving up
        directional_arrow.rotation = 270
        setBlockMovement ( red_group, "y", -450 )
      elseif ( initial_y < event.y ) then -- moving down
        directional_arrow.rotation = 90
        setBlockMovement ( red_group, "y", 450 )
        -- red_group:setLinearVelocity ( 0, 450 )
      end
    end 
  end
  return true --prevents touch propagation to underlying objects
end

Runtime: addEventListener( "touch", myTouchListener )

-- Tap on block --> selects that color
--[[

--]]

-- COLLISION HANDLER

 -- 15 elements
local board = { 0, 32, 64, 96, 128, 160, 192, 224, 256, 288, 320, 352, 384, 416, 448, 480 }

-- move all left x positions, by -4
-- move all right x positions by +4
-- move all up y positions by -4
-- move all down y positions by +4

local function adjustWalls ( group, direction, value )
  if ( direction == "x" ) then
    for i = 1, group.numChildren do
      group[i].x = group[i].x + value
    end
  elseif ( direction == "y" ) then
    for i = 1, group.numChildren do
      group[i].y = group[i].y + value
    end
  end
end

---[[

local left_wall_group = display.newGroup()
physics.addBody ( left_wall_group, "static" )

local wall_left  = display.newImage ("Assets/wall_left.png",  board[1], board[2] )
local wall_left_a  = display.newImage ("Assets/wall_left.png",  board[1], board[3] )

left_wall_group:insert( wall_left )
left_wall_group:insert( wall_left_a )

adjustWalls (left_wall_group, "x", -4 )

--]]

local top_wall_group = display.newGroup()
local wall_top    = display.newImage ("Assets/wall_top.png", board[1], board[2] - 4 )

local right_wall_group = display.newGroup()
physics.addBody ( right_wall_group, "static" )

local wall_right = display.newImage ("Assets/wall_right.png", board[15] + 4, board[2] )
right_wall_group:insert( wall_right )

adjustWalls (right_wall_group, "x", 4 )

local down_wall_group = display.newGroup()
local wall_bottom  = display.newImage ("Assets/wall_bottom.png", board[1] , board[2] + 4 )
--[[
local function onLocalCollision( self, event )

    if ( event.phase == "began" ) then
        print( self.myName .. ": collision began with " .. event.other.myName )

    elseif ( event.phase == "ended" ) then
        print( self.myName .. ": collision ended with " .. event.other.myName )
    end
end
red_group:addEventListener ( "collision", onLocalCollision )
--]]
--
--[[

--]]



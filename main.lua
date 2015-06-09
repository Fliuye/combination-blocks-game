-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

--[[
Need to add 

[CHECK] ~ block movement ( horizontal // vertical ) 
[CHECK] ~ collision with walls 
~ pre-collision to prevent wall-sticking ( see if collision code works if pushed into wall again after 1st collision )
  
  if block.x + hsp would collide with wall, 
    while block.x + hsp is not colliding with wall
      block.x += sign ( hsp )

LATER
~ boolean checker that will prevent updating of velocity until it ( and all other blocks of its color ) have stopped moving 
~ remove block from group that is colliding with another block and occupying the same space ( after velocities are 0 ) 

--]]

display.setDefault ( "background", 1, 1, 1 )

local board = { 0, 32, 64, 96, 128, 160, 192, 224, 256, 288, 320, 352, 384, 416, 448, 480 }
local block_width = 32  -- width in pixels of a block
local block_height = 32 -- height in pixels of a block
--[[
local move_counter = 0
local best_moves = 5
local move_HUD = display.newText ( tostring( move_counter).." / "..tostring(best_moves), display.contentWidth / 2, display.contentHeight / 10, native.systemFont , 16 ) 
move_HUD:setFillColor( 0, 0, 0 )
--]]

local red = "red"
local blue = "blue"
local yellow = "yellow"

local blue_group = display.newGroup()
local yellow_group = display.newGroup()

local red_group = display.newGroup()
red_group.moving = false
red_group.speed = 6

local function createBlock ( x_pos, y_pos, color )
  local block = display.newRect ( x_pos, y_pos, block_width, block_height )
  block:setFillColor( 1.0, 0.27, 0.27 ) 
  -- local block = display.newImage ("Assets/"..color.name.."_block.png", x_pos, y_pos ) 
  block.moving = false
  block.hsp = 0
  block.vsp = 0
  block.speed = block_speed -- global speed for all blocks

  if ( color == "red" ) then
    red_group:insert ( block )  
    -- print ("red.numChildren: "..tostring(red_group.numChildren))
  elseif ( color == "yellow" ) then
    yellow_group:insert ( block )   
    -- print ("yellow.numChildren: "..tostring(yellow_group.numChildren))
  elseif ( color == "blue" ) then
    blue_group:insert ( block ) 
    -- print ("blue.numChildren: "..tostring(blue_group.numChildren))
  end
end 

createBlock ( board[6], board[8], red )
createBlock ( board[8], board[6], red )
createBlock ( board[10], board[4], red )

--[[
local red_block_a = display.newImage ("Assets/red_block.png", board[6], board[8] ) 
red_block_a.moving = false
red_block_a.hsp = 0
red_block_a.vsp = 0
red_block_a.speed = red_group.speed -- later create method that does this automatically, whenever an instance is created
red_group:insert ( red_block_a )

local red_block_b = display.newImage ("Assets/red_block.png", board[8], board[6] ) 
red_block_b.moving = false
red_block_b.hsp = 0
red_block_b.vsp = 0
red_group:insert ( red_block_b  )
  
local red_block_c = display.newImage ("Assets/red_block.png", board[10], board[4] ) 
red_block_c.moving = false
red_block_c.hsp = 0
red_block_c.vsp = 0
red_group:insert ( red_block_c )

--]]

local current_group = red_group
--[[
-- might have to pass in current group into the method with a getter

local function getCurrentGroup ()
  return current_group
end

--]]
-- print ( tostring(red_group.numChildren ))

local directional_arrow = display.newImage("Assets/directional_arrow.png", display.contentWidth, 48 )

local function longest_vector ( init_x, event_x, init_y, event_y ) 
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

local left_wall_group = display.newGroup()

local wall_left_a = display.newImage ("Assets/wall_horizontal.png",  board[6], board[4] )
local wall_left_b = display.newImage ("Assets/wall_horizontal.png",  board[6], board[5] )
local wall_left_c = display.newImage ("Assets/wall_horizontal.png",  board[6], board[6] )
local wall_left_d = display.newImage ("Assets/wall_horizontal.png",  board[6], board[7] )
local wall_left_e = display.newImage ("Assets/wall_horizontal.png",  board[6], board[8] )

left_wall_group:insert( wall_left_a )
left_wall_group:insert( wall_left_b )
left_wall_group:insert( wall_left_c )
left_wall_group:insert( wall_left_d )
left_wall_group:insert( wall_left_e )

adjustWalls (left_wall_group, "x", -18 )

local top_wall_group = display.newGroup()

local wall_top_a  = display.newImage ("Assets/wall_vertical.png", board[6], board[4] )
local wall_top_b  = display.newImage ("Assets/wall_vertical.png", board[7], board[4] )
local wall_top_c  = display.newImage ("Assets/wall_vertical.png", board[8], board[4] )
local wall_top_d  = display.newImage ("Assets/wall_vertical.png", board[9], board[4] )
local wall_top_e  = display.newImage ("Assets/wall_vertical.png", board[10], board[4] )

top_wall_group:insert ( wall_top_a )
top_wall_group:insert ( wall_top_b )
top_wall_group:insert ( wall_top_c )
top_wall_group:insert ( wall_top_d )
top_wall_group:insert ( wall_top_e )

adjustWalls (top_wall_group, "y", -18 )

local right_wall_group = display.newGroup()

local wall_right_a = display.newImage ("Assets/wall_horizontal.png", board[10] , board[4] )
local wall_right_b = display.newImage ("Assets/wall_horizontal.png", board[10] , board[5] )
local wall_right_c = display.newImage ("Assets/wall_horizontal.png", board[10] , board[6] )
local wall_right_d = display.newImage ("Assets/wall_horizontal.png", board[10] , board[7] )
local wall_right_e = display.newImage ("Assets/wall_horizontal.png", board[10] , board[8] )

right_wall_group:insert( wall_right_a )
right_wall_group:insert( wall_right_b )
right_wall_group:insert( wall_right_c )
right_wall_group:insert( wall_right_d )
right_wall_group:insert( wall_right_e )


adjustWalls (right_wall_group, "x", 18 )

local bottom_wall_group = display.newGroup()
local wall_bottom_a  = display.newImage ("Assets/wall_vertical.png", board[6] , board[8] )
local wall_bottom_b  = display.newImage ("Assets/wall_vertical.png", board[7] , board[8] )
local wall_bottom_c  = display.newImage ("Assets/wall_vertical.png", board[8] , board[8] )
local wall_bottom_d  = display.newImage ("Assets/wall_vertical.png", board[9] , board[8] )
local wall_bottom_e  = display.newImage ("Assets/wall_vertical.png", board[10] , board[8] )

bottom_wall_group:insert ( wall_bottom_a )
bottom_wall_group:insert ( wall_bottom_b )
bottom_wall_group:insert ( wall_bottom_c )
bottom_wall_group:insert ( wall_bottom_d )
bottom_wall_group:insert ( wall_bottom_e )

adjustWalls (bottom_wall_group, "y", 18 )

local function checkLevelComplete ()
  if ( red_group.numChildren <= 1 and blue_group.numChildren <= 1 and yellow_group.numChildren <= 1 ) then -- either 0 or 1 per color 
    -- level complete!
    -- print ("Level Complete")
    -- nextLevel()
    -- current_level = current_level + 1
  end
end

local function updateGroupMoving()
  local checker = false
  if ( current_group.moving ) then
    for i = 1, current_group.numChildren do
      if ( current_group[i].moving ) then -- a block is still moving
        checker = true
      end
    end
  end
  return checker
end

local function checkCombine ( current_block ) 
  if ( current_group.numChildren > 1 ) then
    for i = 1, current_group.numChildren do
      if ( current_group[i] ~= nil ) then -- prevents out of bounds array access
        if ( current_group[i] ~= current_block ) then
          --if (( not current_group[i].moving ) and ( not current_block.moving)) then -- necessary?
          if ( current_group[i].x == current_block.x and current_group[i].y == current_block.y ) then
            -- play animation // particle effect
            current_group:remove( current_group[i] )
            if (current_group.numChildren == 1 ) then
              checkLevelComplete()
            end
          end
          --end
        end
      end
    end
  end
end

-- rectangle-based collision detection ( From Corona webpage -- https://coronalabs.com/blog/2013/07/23/tutorial-non-physics-collision-detection/ )
local function checkCollideLeft ( block, wall_group )
  if ( block == nil ) then  --make sure the first object exists
    return false
  end
  if ( wall_group == nil ) then  --make sure the other object exists
    return false
  end
   
  for i = 1, wall_group.numChildren do -- cycle through all walls of certain direction
    -- local left  = wall_group.contentBounds.xMin <= block_group[i].contentBounds.xMin and wall_group.contentBounds.xMax >= block_group[i].contentBounds.xMin
    local left = block.contentBounds.xMin + block.hsp <= wall_group[i].contentBounds.xMax
    -- check if the next step will collide with a wall ( <-- moving left ) 
    if ( left ) then 
      while ( block.contentBounds.xMin > wall_group[i].contentBounds.xMax ) do
        block.x = block.x - 1
      end
      return true
    end
  end
end

local function checkCollideRight ( block, wall_group )
  if ( block == nil ) then  --make sure the first object exists
    return false
  end
  if ( wall_group == nil ) then  --make sure the other object exists
    return false
  end
   
  for i = 1, wall_group.numChildren do -- cycle through all walls of certain direction
    local right = block.contentBounds.xMax + block.hsp >= wall_group[i].contentBounds.xMin
    -- block_group.contentBounds.xMin >= block_group[i].contentBounds.xMin and obj1.contentBounds.xMin <= block_group[i].contentBounds.xMax
    
    if ( right ) then
      while ( block.contentBounds.xMax < wall_group[i].contentBounds.xMin ) do
        block.x = block.x + 1
      end
      return true
    end 
  end
end

local function checkCollideTop ( block, wall_group )
  if ( block == nil ) then  --make sure the first object exists
    return false
  end
  if ( wall_group == nil ) then  --make sure the other object exists
    return false
  end
   
  for i = 1, wall_group.numChildren do -- cycle through all walls of certain direction
    local top = block.contentBounds.yMin + block.vsp < wall_group[i].contentBounds.yMax
    
    if  ( top ) then
      while ( block.contentBounds.yMin > wall_group[i].contentBounds.yMax ) do
        block.y = block.y - 1
      end
      return true
    end
  end
end

local function checkCollideBottom ( block, wall_group )
  if ( block == nil ) then  --make sure the first object exists
    return false
  end
  if ( wall_group == nil ) then  --make sure the other object exists
    return false
  end
   
  for i = 1, wall_group.numChildren do -- cycle through all walls of certain direction
    local bottom  = block.contentBounds.yMax + block.vsp > wall_group[i].contentBounds.yMin
    if  ( bottom ) then
      while ( block.contentBounds.yMax < wall_group[i].contentBounds.yMin ) do
        block.y = block.y + 1
      end
      return true
    end
  end
end


--current_group = "red" || "blue" || "yellow"
local function moveBlock ( event )

  if ( current_group.moving ) then
    for i = 1, current_group.numChildren do
      if ( current_group[i] ~= nil ) then -- prevents out of bounds array access
        if ( current_group[i].moving ) then 
          if ( current_group[i].hsp > 0 ) then -- moving right   
            if ( checkCollideRight ( current_group[i], right_wall_group ) ) then
              current_group[i].hsp = 0
              current_group[i].moving = false
              checkCombine ( current_group[i] )
              current_group.moving = updateGroupMoving()
            end 
          elseif ( current_group[i].hsp < 0 ) then -- moving left
            if ( checkCollideLeft ( current_group[i], left_wall_group ) ) then
              current_group[i].hsp = 0
              current_group[i].moving = false
              checkCombine ( current_group[i] )
              current_group.moving = updateGroupMoving()
            end
          elseif ( current_group[i].vsp > 0 ) then -- moving down
            if ( checkCollideBottom ( current_group[i], bottom_wall_group ) ) then
              current_group[i].vsp = 0
              current_group[i].moving = false
              checkCombine ( current_group[i] )
              current_group.moving = updateGroupMoving()
            end
          elseif ( current_group[i].vsp < 0 ) then -- moving up 
            if ( checkCollideTop ( current_group[i], top_wall_group ) ) then
              current_group[i].vsp = 0
              current_group[i].moving = false
              checkCombine ( current_group[i] )
              current_group.moving = updateGroupMoving()
            end
          end
        end
        if (current_group[i] ~= nil ) then 
          current_group[i].x = current_group[i].x + current_group[i].hsp
          current_group[i].y = current_group[i].y + current_group[i].vsp
        end
      end
    end
  end
end

Runtime:addEventListener ( "enterFrame", moveBlock )

-- BLOCK MOVEMENT
local initial_x = 0
local initial_y = 0

local function myTouchListener ( event )
  if ( not current_group.moving ) then
    if ( event.phase == "began" ) then
    -- set initial x, y coordinates to where the tap first began 
      initial_x = event.x
      initial_y = event.y
    elseif ( event.phase == "ended" ) then -- code when touch is lifted off object
      local greater_length = longest_vector ( initial_x, event.x, initial_y, event.y ) -- find which direction has the greatest change in distance
      for i = 1, current_group.numChildren do
        if ( greater_length == "x greater" ) then 
          if ( initial_x > event.x ) then -- moving left
            directional_arrow.rotation = 180
            if (not current_group[i].moving ) then
              current_group[i].hsp = -current_group.speed
              current_group[i].moving = true
            end
          elseif (initial_x < event.x) then -- moving right
            directional_arrow.rotation = 0
            if (not current_group[i].moving ) then
              current_group[i].hsp = current_group.speed
              current_group[i].moving = true
            end
          end
        elseif (greater_length == "y greater" ) then
          if ( initial_y > event.y ) then -- moving up
            directional_arrow.rotation = 270
            if (not current_group[i].moving ) then
              current_group[i].vsp = -current_group.speed
              current_group[i].moving = true
            end
          elseif ( initial_y < event.y ) then -- moving down
            directional_arrow.rotation = 90
            if (not current_group[i].moving ) then
              current_group[i].vsp = current_group.speed
              current_group[i].moving = true
            end
          end
        end
      end
    end
    return true --prevents touch propagation to underlying objects
  end
end

Runtime: addEventListener( "touch", myTouchListener )


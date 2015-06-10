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

local myGlobal = require ( "C_global" )
local composer = require ( "composer" )

-- go to level1, or last played level if resuming the device allows continued play
-- composer.gotoScene ("level"..tostring( myGlobal.currentLevel ))
--[[
local options = 
{
  effect = "fade", -- effects can be found -- https://docs.coronalabs.com/api/library/composer/gotoScene.html
  time = 400, -- time duration of the effect
  params = { -- parameters to be passed to the next scene
    sampleVar1 = "string stuff"
    sampleVar2 = 35
  }
}

-- composer.gotoScene (levelName, [ ,options ] ))
--]]

display.setDefault ( "background", 1, 1, 1 )

local board = myGlobal.board
--[[
local move_counter = 0
local best_moves = 5
local move_HUD = display.newText ( tostring( move_counter).." / "..tostring(best_moves), display.contentWidth / 2, display.contentHeight / 10, native.systemFont , 16 ) 
move_HUD:setFillColor( 0, 0, 0 )
--]]

local red_group = myGlobal.createBlockGroup ( "red" ) 
local yellow_group = myGlobal.createBlockGroup ( "yellow" ) 
local blue_group = myGlobal.createBlockGroup ( "blue" ) 

--[[
local red_group = display.newGroup()
red.color = "red"
red_group.moving = false
red_group.speed = 6

local blue_group = display.newGroup()
blue_group.color = "blue"
blue_group.moving = false
blue_group.speed = 6

local yellow_group = display.newGroup()
yellow.color = "yellow"
yellow_group.moving = false
yellow_group.speed = 6
--]]


local createBlock = myGlobal.createBlock

red_group = createBlock ( board[6], board[8], red_group ) 
yellow_group = createBlock ( board[8], board[6], yellow_group )
blue_group = createBlock ( board[10], board[4], blue_group )

local current_group = red_group

-- might have to pass in current group into the method with a getter

local function getCurrentGroup ()
  return current_group
end

--]]

local directional_arrow = display.newImage("Assets/directional_arrow.png", display.contentWidth, 48 )

local function adjustWalls ( group, direction, value )
  if ( direction == "x" ) then
    for i = 1, group.numChildren do
      if ( group[i].side == "right" ) then
        group[i].x = group[i].x + value
      elseif ( group[i].side == "left" ) then
        group[i].x = group[i].x - value
      end
    end
  elseif ( direction == "y" ) then
    for i = 1, group.numChildren do
      if ( group[i].side == "bottom" ) then
        group[i].y = group[i].y + value
      elseif ( group[i].side == "top" ) then
        group[i].y = group[i].y - value
      end
    end
  end
end

local horizontal_wall_group = display.newGroup()

local wall_right_a = display.newImage ("Assets/wall_horizontal.png", board[10] , board[4] )
local wall_right_b = display.newImage ("Assets/wall_horizontal.png", board[10] , board[5] )
local wall_right_c = display.newImage ("Assets/wall_horizontal.png", board[10] , board[6] )
local wall_right_d = display.newImage ("Assets/wall_horizontal.png", board[10] , board[7] )
local wall_right_e = display.newImage ("Assets/wall_horizontal.png", board[10] , board[8] )

wall_right_a.side = "right"
wall_right_b.side = "right"
wall_right_c.side = "right"
wall_right_d.side = "right"
wall_right_e.side = "right"

horizontal_wall_group:insert( wall_right_a )
horizontal_wall_group:insert( wall_right_b )
horizontal_wall_group:insert( wall_right_c )
horizontal_wall_group:insert( wall_right_d )
horizontal_wall_group:insert( wall_right_e )

-- adjustWalls (right_wall_group, "x", 18 )

local wall_left_a = display.newImage ("Assets/wall_horizontal.png",  board[6], board[4] )
local wall_left_b = display.newImage ("Assets/wall_horizontal.png",  board[6], board[5] )
local wall_left_c = display.newImage ("Assets/wall_horizontal.png",  board[6], board[6] )
local wall_left_d = display.newImage ("Assets/wall_horizontal.png",  board[6], board[7] )
local wall_left_e = display.newImage ("Assets/wall_horizontal.png",  board[6], board[8] )

wall_left_a.side = "left"
wall_left_b.side = "left"
wall_left_c.side = "left"
wall_left_d.side = "left"
wall_left_e.side = "left"

horizontal_wall_group:insert( wall_left_a )
horizontal_wall_group:insert( wall_left_b )
horizontal_wall_group:insert( wall_left_c )
horizontal_wall_group:insert( wall_left_d )
horizontal_wall_group:insert( wall_left_e )

adjustWalls (horizontal_wall_group, "x", 18 )

local vertical_wall_group = display.newGroup()

-- local bottom_wall_group = display.newGroup()
local wall_bottom_a  = display.newImage ("Assets/wall_vertical.png", board[6] , board[8] )
local wall_bottom_b  = display.newImage ("Assets/wall_vertical.png", board[7] , board[8] )
local wall_bottom_c  = display.newImage ("Assets/wall_vertical.png", board[8] , board[8] )
local wall_bottom_d  = display.newImage ("Assets/wall_vertical.png", board[9] , board[8] )
local wall_bottom_e  = display.newImage ("Assets/wall_vertical.png", board[10] ,board[8] )

wall_bottom_a.side = "bottom"
wall_bottom_b.side = "bottom"
wall_bottom_c.side = "bottom"
wall_bottom_d.side = "bottom"
wall_bottom_e.side = "bottom"

vertical_wall_group:insert ( wall_bottom_a )
vertical_wall_group:insert ( wall_bottom_b )
vertical_wall_group:insert ( wall_bottom_c )
vertical_wall_group:insert ( wall_bottom_d )
vertical_wall_group:insert ( wall_bottom_e )

-- adjustWalls (bottom_wall_group, "y", 18 )

local wall_top_a  = display.newImage ("Assets/wall_vertical.png", board[6], board[4] )
local wall_top_b  = display.newImage ("Assets/wall_vertical.png", board[7], board[4] )
local wall_top_c  = display.newImage ("Assets/wall_vertical.png", board[8], board[4] )
local wall_top_d  = display.newImage ("Assets/wall_vertical.png", board[9], board[4] )
local wall_top_e  = display.newImage ("Assets/wall_vertical.png", board[10], board[4] )

wall_top_a.side = "top"
wall_top_b.side = "top"
wall_top_c.side = "top"
wall_top_d.side = "top"
wall_top_e.side = "top"

vertical_wall_group:insert ( wall_top_a )
vertical_wall_group:insert ( wall_top_b )
vertical_wall_group:insert ( wall_top_c )
vertical_wall_group:insert ( wall_top_d )
vertical_wall_group:insert ( wall_top_e )

adjustWalls (vertical_wall_group, "y", 18 )

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

local function emptyCollisionTable( block )
  for i = 1, table.maxn(block.collisionTable) do
    table.remove( block.collisionTable )
  end
  block.collisionTable = nil
end

--

local function getRightWalls( block, wall_group )
  if ( block.collisionTable == nil ) then -- first time through collision check
    local collisionTable = {}
    for i = 1, wall_group.numChildren do -- cycle through all walls in direction
      if ( wall_group[i].x > block.x ) then -- walls in general direction      
        if ((wall_group[i].y > block.contentBounds.yMin ) and ( wall_group[i].y < block.contentBounds.yMax )) then -- walls that will intersect
          table.insert(collisionTable, wall_group[i])
        end
      end
    end
    if ( table.maxn( collisionTable ) == 0 ) then -- avoids future checks if there is no wall
      table.insert( collisionTable, 1, "no_wall" )
    end 
    block.collisionTable = collisionTable
  end
  return block
end

local function getLeftWalls( block, wall_group )
  if ( block.collisionTable == nil ) then -- first time through collision check
    local collisionTable = {}
    for i = 1, wall_group.numChildren do -- cycle through all walls in direction
      if ( wall_group[i].x < block.x ) then -- walls in general direction      
        if ((wall_group[i].y > block.contentBounds.yMin ) and ( wall_group[i].y < block.contentBounds.yMax )) then -- walls that will intersect
          table.insert(collisionTable, wall_group[i])
        end
      end
    end
    if ( table.maxn( collisionTable ) == 0 ) then -- avoids future checks if there is no wall
      table.insert( collisionTable, 1, "no_wall" )
    end 
    block.collisionTable = collisionTable
  end
  return block
end

local function getTopWalls( block, wall_group )
  if ( block.collisionTable == nil ) then -- first time through collision check
    local collisionTable = {}
    for i = 1, wall_group.numChildren do -- cycle through all walls in direction
      if ( wall_group[i].y < block.y ) then -- walls in general direction      
        if ((wall_group[i].x > block.contentBounds.xMin ) and ( wall_group[i].x < block.contentBounds.xMax )) then -- walls that will intersect
          table.insert(collisionTable, wall_group[i])
        end
      end
    end
    if ( table.maxn( collisionTable ) == 0 ) then -- avoids future checks if there is no wall
      table.insert( collisionTable, 1, "no_wall" )
    end 
    block.collisionTable = collisionTable
  end
  return block
end

local function getBottomWalls( block, wall_group )
  if ( block.collisionTable == nil ) then -- first time through collision check
    local collisionTable = {}
    for i = 1, wall_group.numChildren do -- cycle through all walls in direction
      if ( wall_group[i].y > block.y ) then -- walls in general direction      
        if ((wall_group[i].x > block.contentBounds.xMin ) and ( wall_group[i].x < block.contentBounds.xMax )) then -- walls that will intersect
          table.insert(collisionTable, wall_group[i])
        end
      end
    end
    if ( table.maxn( collisionTable ) == 0 ) then -- avoids future checks if there is no wall
      table.insert( collisionTable, 1, "no_wall" )
    end 
    block.collisionTable = collisionTable
  end
  return block
end


-- rectangle-based collision detection ( From Corona webpage -- https://coronalabs.com/blog/2013/07/23/tutorial-non-physics-collision-detection/ )
local function checkCollideLeft ( block )
  if ( block == nil ) then  --make sure the first object exists
    return false
  elseif ( block.collisionTable == nil ) then
    return false
  elseif (block.collisionTable[1] == "no_wall" ) then
    -- if block moves off screen, stop checking collisions
    return false
  end 
   
  for i = 1, table.maxn(block.collisionTable) do
    local left = block.contentBounds.xMin + block.hsp <= block.collisionTable[i].contentBounds.xMax
    if ( left ) then 
      while ( block.contentBounds.xMin > block.collisionTable[i].contentBounds.xMax ) do
        block.x = block.x - 1
      end
      emptyCollisionTable( block )
      return true
    end
  end
end

local function checkCollideRight ( block )
  if ( block == nil ) then  --make sure the first object exists
    return false
  elseif ( block.collisionTable == nil ) then
    return false
  elseif (block.collisionTable[1] == "no_wall" ) then
    -- if block moves off screen, stop checking collisions
    return false
  end 
  
  for i = 1, table.maxn(block.collisionTable) do
    local right = block.contentBounds.xMax + block.hsp >= block.collisionTable[i].contentBounds.xMin
    
    if ( right ) then
      while ( block.contentBounds.xMax < block.collisionTable[i].contentBounds.xMin ) do
        block.x = block.x + 1
      end
      emptyCollisionTable( block )
      return true
    end 
  end
end

local function checkCollideTop ( block )
  if ( block == nil ) then  --make sure the first object exists
    return false
  elseif ( block.collisionTable == nil ) then
    return false
  elseif (block.collisionTable[1] == "no_wall" ) then
    -- if block moves off screen, stop checking collisions
    return false
  end 
   
  for i = 1, table.maxn(block.collisionTable) do
    local top = block.contentBounds.yMin + block.vsp < block.collisionTable[i].contentBounds.yMax
    
    if  ( top ) then
      while ( block.contentBounds.yMin > block.collisionTable[i].contentBounds.yMax ) do
        block.y = block.y - 1
      end
      emptyCollisionTable( block )
      return true
    end
  end
end

local function checkCollideBottom ( block )
  if ( block == nil ) then  --make sure the first object exists
    return false
  elseif ( block.collisionTable == nil ) then
    return false
  elseif (block.collisionTable[1] == "no_wall" ) then
    -- if block moves off screen, stop checking collisions
    return false
  end 
   
  for i = 1, table.maxn(block.collisionTable) do
    local bottom  = block.contentBounds.yMax + block.vsp >block.collisionTable[i].contentBounds.yMin
    if  ( bottom ) then
      while ( block.contentBounds.yMax < block.collisionTable[i].contentBounds.yMin ) do
        block.y = block.y + 1
      end
      emptyCollisionTable( block )
      return true
    end
  end
end

--current_group = "red" || "blue" || "yellow"
local function moveBlock ()

  if ( current_group.moving ) then
    for i = 1, current_group.numChildren do
      if ( current_group[i] ~= nil ) then -- prevents out of bounds array access
        if ( current_group[i].moving ) then 
          if ( current_group[i].hsp > 0 ) then -- moving right
            getRightWalls( current_group[i], horizontal_wall_group )
            if ( checkCollideRight ( current_group[i] )) then
              current_group[i].hsp = 0
              current_group[i].moving = false
              checkCombine ( current_group[i] )
              current_group.moving = updateGroupMoving()
            end 
          elseif ( current_group[i].hsp < 0 ) then -- moving left
            getLeftWalls( current_group[i], horizontal_wall_group )
            if ( checkCollideLeft ( current_group[i] )) then
              current_group[i].hsp = 0
              current_group[i].moving = false
              checkCombine ( current_group[i] )
              current_group.moving = updateGroupMoving()
            end
          elseif ( current_group[i].vsp > 0 ) then -- moving down
            getBottomWalls( current_group[i], vertical_wall_group )
            if ( checkCollideBottom ( current_group[i], vertical_wall_group ) ) then
              current_group[i].vsp = 0
              current_group[i].moving = false
              checkCombine ( current_group[i] )
              current_group.moving = updateGroupMoving()
            end
          elseif ( current_group[i].vsp < 0 ) then -- moving up 
            getTopWalls( current_group[i], vertical_wall_group )
            if ( checkCollideTop ( current_group[i], vertical_wall_group ) ) then
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

Runtime:addEventListener( "enterFrame", moveBlock )

local function longestVector ( init_x, init_y, event_x, event_y ) 
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


local initial_x = 0
local initial_y = 0
local function touchListener ( event )
  if ( not current_group.moving ) then
    if ( event.phase == "began" ) then
    -- set initial x, y coordinates to where the tap first began 
      initial_x = event.x
      initial_y = event.y
    elseif ( event.phase == "ended" ) then -- code when touch is lifted off object
      local greater_length = longestVector ( initial_x, initial_y, event.x, event.y ) -- find which direction has the greatest change in distance
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

Runtime: addEventListener( "touch", touchListener )


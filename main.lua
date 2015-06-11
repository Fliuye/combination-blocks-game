local myGlobal = require ( "C_global" )
local composer = require ( "composer" )

--[[
-- go to level1, or last played level if resuming the device allows continued play
-- composer.gotoScene ("level"..tostring( myGlobal.currentLevel ))

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

-- local directional_arrow = display.newImage("Assets/directional_arrow.png", display.contentWidth, 48 )
--]]

-- initialize function for creating block groups
local createBlockGroup = myGlobal.createBlockGroup

local master_block_group = display.newGroup()
local red_group = createBlockGroup ( "red" ) 
local yellow_group = createBlockGroup ( "yellow" ) 
local blue_group = createBlockGroup ( "blue" ) 

master_block_group:insert ( red_group ) 
master_block_group:insert ( yellow_group ) 
master_block_group:insert ( blue_group ) 

-- initialize function for creating blocks
local rBlock = myGlobal.createRedBlock
local yBlock = myGlobal.createYellowBlock
local bBlock = myGlobal.createBlueBlock

-- create the blocks of the level
red_group:insert( rBlock( board[6], board[8] ))

yellow_group:insert( yBlock( board[8], board[6] ))

blue_group:insert( bBlock( board[10], board[4] ))

local current_group = red_group
-- current_group = getStartingColor( level.starting_color )
--[[
local getStartingColor = function ( color )
  for i = 1, master_group.numChildren do
    if ( master_group[i].color == color )
      return master_group[i]
    end
  end
end
--]]

-- create the walls of the level!
local master_wall_group = display.newGroup()
local horizontal_wall_group = display.newGroup()
local vertical_wall_group = display.newGroup()

local rWall = myGlobal.createRightWall -- add right wall
local lWall = myGlobal.createLeftWall -- add left wall
local bWall = myGlobal.createBottomWall -- add bottom wall
local tWall = myGlobal.createTopWall-- add top wall

-- right walls
horizontal_wall_group:insert( rWall( board[10], board[4] ))
horizontal_wall_group:insert( rWall( board[10], board[5] ))
horizontal_wall_group:insert( rWall( board[10], board[6] ))
horizontal_wall_group:insert( rWall( board[10], board[7] ))
horizontal_wall_group:insert( rWall( board[10], board[8] ))

-- left walls
horizontal_wall_group:insert( lWall( board[6], board[4] ))
horizontal_wall_group:insert( lWall( board[6], board[5] ))
horizontal_wall_group:insert( lWall( board[6], board[6] ))
horizontal_wall_group:insert( lWall( board[6], board[7] ))
horizontal_wall_group:insert( lWall( board[6], board[8] ))

-- bottom walls
vertical_wall_group:insert( bWall( board[6], board[8] ))
vertical_wall_group:insert( bWall( board[7], board[8] ))
vertical_wall_group:insert( bWall( board[8], board[8] ))
vertical_wall_group:insert( bWall( board[9], board[8] ))
vertical_wall_group:insert( bWall( board[10], board[8] ))

-- top walls
vertical_wall_group:insert( tWall( board[6], board[4] ))
vertical_wall_group:insert( tWall( board[7], board[4] ))
vertical_wall_group:insert( tWall( board[8], board[4] ))
vertical_wall_group:insert( tWall( board[9], board[4] ))
vertical_wall_group:insert( tWall( board[10], board[4] ))

master_wall_group:insert( horizontal_wall_group )
master_wall_group:insert( vertical_wall_group )

local function updateMovement ()
  myGlobal.moveBlock ( current_group, master_wall_group )
end

Runtime:addEventListener( "enterFrame", updateMovement )

local initial_x = 0
local initial_y = 0

-- chop it up to make the listener more independent
local function touchListener ( event )
  if ( not current_group.moving ) then
    if ( event.phase == "began" ) then
    -- set initial x, y coordinates to where the tap first began 
      initial_x = event.x
      initial_y = event.y
    elseif ( event.phase == "ended" ) then
      -- find which direction has the greatest change in distance
      local move_direction = myGlobal.getDirection (current_group, initial_x, initial_y, event.x, event.y ) 
      myGlobal.updateTouch ( current_group, move_direction ) 
    end
    return true --prevents touch propagation to underlying objects
  end
end

Runtime: addEventListener( "touch", touchListener )

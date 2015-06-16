--[[
Description: 

Level Intention: Level 3

--]]

local composer = require( "composer" )
local C_global = require( "C_global" )

local scene = composer.newScene()
-----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here
print ("welcome to level 3")
-- create references to variables
local board 

local initial_x
local initial_y

local options

-- BLOCK RELATED --
local master_block_group
local red_group
local yellow_group
local blue_group
local current_group

-- WALL RELATED --
local master_wall_group
local horizontal_wall_group
local vertical_wall_group

-- initialize functions
-- GROUPS -- 
local createBlockGroup = C_global.createBlockGroup

-- BLOCKS --
local rBlock = C_global.createRedBlock
local yBlock = C_global.createYellowBlock
local bBlock = C_global.createBlueBlock
local restartBlock = C_global.createRestartBlock

-- WALLS --
local rWall = C_global.createRightWall -- add right wall
local lWall = C_global.createLeftWall -- add left wall
local bWall = C_global.createBottomWall -- add bottom wall
local tWall = C_global.createTopWall-- add top wall

-- LISTENERS --
local touchListener
local updateMovement
local selectColorListener
local restartLevelListener
local previousLevelListener
local nextLevelListener
--

local function createWalls () 
  -- right walls
  horizontal_wall_group:insert( rWall( board[11], board[6] ))
  
  horizontal_wall_group:insert( rWall( board[8], board[3] ))
  horizontal_wall_group:insert( rWall( board[8], board[4] ))
  horizontal_wall_group:insert( rWall( board[8], board[5] ))
  horizontal_wall_group:insert( rWall( board[8], board[7] ))
  horizontal_wall_group:insert( rWall( board[8], board[8] ))
  horizontal_wall_group:insert( rWall( board[8], board[9] ))
  
  -- left walls
  horizontal_wall_group:insert( lWall( board[5], board[6] ))
  
  horizontal_wall_group:insert( lWall( board[8], board[3] ))
  horizontal_wall_group:insert( lWall( board[8], board[4] ))
  horizontal_wall_group:insert( lWall( board[8], board[5] ))
  horizontal_wall_group:insert( lWall( board[8], board[7] ))
  horizontal_wall_group:insert( lWall( board[8], board[8] ))
  horizontal_wall_group:insert( lWall( board[8], board[9] ))
  
  -- bottom walls
  vertical_wall_group:insert( bWall( board[8], board[9] ))
  
  vertical_wall_group:insert( bWall( board[5], board[6] ))
  vertical_wall_group:insert( bWall( board[6], board[6] ))
  vertical_wall_group:insert( bWall( board[7], board[6] ))
  vertical_wall_group:insert( bWall( board[9], board[6] ))
  vertical_wall_group:insert( bWall( board[10], board[6] ))
  vertical_wall_group:insert( bWall( board[11], board[6] ))

  -- top walls
  vertical_wall_group:insert( tWall( board[8], board[3] ))

  vertical_wall_group:insert( tWall( board[5], board[6] ))
  vertical_wall_group:insert( tWall( board[6], board[6] ))
  vertical_wall_group:insert( tWall( board[7], board[6] ))
  vertical_wall_group:insert( tWall( board[9], board[6] ))
  vertical_wall_group:insert( tWall( board[10], board[6] ))
  vertical_wall_group:insert( tWall( board[11], board[6] ))

  master_wall_group:insert( horizontal_wall_group )
  master_wall_group:insert( vertical_wall_group )
end

--
local function createBlocks ()
  red_group:insert( rBlock( board[5], board[6] ))
  red_group:insert( rBlock( board[11], board[6] ))
  blue_group:insert( bBlock( board[8], board[3] ))
  blue_group:insert( bBlock( board[8], board[9] ))
  
  local restart_block = restartBlock( board[16], board[2] )
  restart_block:addEventListener( "tap", restartLevelListener )
  scene.view:insert ( restart_block )
  
  if ( red_group.numChildren >= 1 ) then
    print ( "RED" )
    for i = 1, red_group.numChildren do
      red_group[i]:addEventListener ("tap", selectColorListener ) 
      print ( "change to red" )
    end
  end
  
  if ( yellow_group.numChildren >= 1 ) then
    for j = 1, yellow_group.numChildren do
      yellow_group[j]:addEventListener ("tap", selectColorListener ) 
      print ( "change to yellow" )
    end
  end
    
  if ( blue_group.numChildren >= 1 ) then
    for k = 1, blue_group.numChildren do
      blue_group[k]:addEventListener ("tap", selectColorListener ) 
      print ( "change to blue" )
    end
  end
  
  -- yellow_group:insert( yBlock( board[8], board[6] ))
  -- blue_group:insert( bBlock( board[10], board[4] ))
  
  master_block_group:insert ( red_group ) 
  master_block_group:insert ( yellow_group ) 
  master_block_group:insert ( blue_group ) 
end
--

-- -------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )
  print ("creating!")
  display.setDefault ( "background", 1.0, 1.0, 1.0 )
  
  -- initialize variables
  board = C_global.board
  
  initial_x = 0
  initial_y = 0
  
  -- BLOCK RELATED --
  master_block_group = display.newGroup()
  red_group = createBlockGroup ( "red" ) 
  yellow_group = createBlockGroup ( "yellow" ) 
  blue_group = createBlockGroup ( "blue" ) 
  current_group = red_group

  -- WALL RELATED --
  master_wall_group = display.newGroup()
  horizontal_wall_group = display.newGroup()
  vertical_wall_group = display.newGroup()
  
  -- Initialize the scene here.
  -- Example: add display objects to "sceneGroup", add touch listeners, etc.

  local sceneGroup = self.view

-- INITIALIZE LISTENERS -- 
  touchListener = function ( event )
    if ( not current_group.moving ) then
      if ( event.phase == "began" ) then
      -- set initial x, y coordinates to where the tap first began 
        initial_x = event.x
        initial_y = event.y
      elseif ( event.phase == "ended" ) then
        -- find which direction has the greatest change in distance
        local move_direction = C_global.getDirection (current_group, initial_x, initial_y, event.x, event.y ) 
        C_global.updateTouch ( current_group, move_direction )
      end
      return true --prevents touch propagation to underlying objects
    end
  end

  Runtime:addEventListener( "touch", touchListener )
  updateMovement = function  ()
    C_global.moveBlock ( current_group, master_wall_group )
    if ( current_group.numChildren == 1 ) then
      if (C_global.checkLevelComplete( master_block_group )) then 
        -- LEVEL COMPLETE
        print ("Level Complete")
        print ("current level: "..tostring(C_global.current_level))
        C_global.current_level = C_global.current_level + 1
        print ("new current level: "..tostring(C_global.current_level).."\n")
        composer.gotoScene ("level"..tostring(C_global.current_level), C_global.options )
        -- unload current scene
        -- display win box
        -- go to next scene  
      end
    end
  end

  Runtime:addEventListener( "enterFrame", updateMovement )
  
  selectColorListener = function ( event ) 
    if ( current_group.color ~= event.target.color ) then
      for i = 1, master_block_group.numChildren do
        if ( master_block_group[i].color == event.target.color ) then
          print ( "changing group" )
          current_group = master_block_group[i]
        end
      end
    end
  end
  
  restartLevelListener = function ()
    composer.gotoScene ("level_restart", options )
  end
  
  -- CREATE WALLS --
  createWalls()
  sceneGroup:insert( master_wall_group )
  
-- CREATE BLOCKS --
  createBlocks()
  sceneGroup:insert( master_block_group )
  
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
    
  elseif ( phase == "did" ) then
  
    end
end


-- "scene:hide()"
function scene:hide( event )
    
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
      Runtime:removeEventListener( "touch", touchListener )
      Runtime:removeEventListener( "enterFrame", updateMovement )
    elseif ( phase == "did" ) then
    end
end


-- "scene:destroy()"
function scene:destroy( event )
    print ("destroy")
    local sceneGroup = self.view
    Runtime:removeEventListener( "touch", touchListener )
    Runtime:removeEventListener( "enterFrame", updateMovement )
    -- unlock music & sound effects
    -- update save states, if needed
end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene
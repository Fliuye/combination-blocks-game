local C_block = require ( "C_block" )
local C_wall = require ( "C_wall" )
local C_inputHandler = require ( "C_inputHandler" )

-- global class
local C_global = {}

-- myGlobal.BLOCK_WIDTH = 32
-- myGlobal.BLOCK_HEIGHT = 32
-- myGlobal.BLOCK_SPEED = 8 

C_global.maxLevels = 50
C_global.board = { 0, 32, 64, 96, 128, 160, 192, 224, 256, 288, 320, 352, 384, 416, 448, 480 }

C_global.gameSettings = {}
C_global.gameSettings.currentLevel = 1
C_global.gameSettings.unlockedLevels = 1

C_global.menuSettings = {}
C_global.menuSettings.soundOn = true
C_global.menuSettings.musicOn = true

C_global.levels = {}

---------------
-- functions --
---------------
--[[
myGlobal.getPrefix = function ( original_string )   
  return original_string:sub (1, string.find( original_string, "_" ))
end
--]]

-- BLOCK --
C_global.createRedBlock = C_block.createRedBlock
C_global.createYellowBlock = C_block.createYellowBlock
C_global.createBlueBlock = C_block.createBlueBlock

C_global.createBlockGroup = C_block.createBlockGroup

C_global.getRightWalls = C_block.getRightWalls
C_global.getLeftWalls = C_block.getLeftWalls
C_global.getBottomWalls = C_block.getBottomWalls
C_global.getTopWalls = C_block.getTopWalls

C_global.checkCollideRight = C_block.checkCollideRight
C_global.checkCollideLeft = C_block.checkCollideLeft
C_global.checkCollideBottom = C_block.checkCollideBottom
C_global.checkCollideTop = C_block.checkCollideTop

C_global.moveBlock = C_block.moveBlock

-- WALL -- 
C_global.createRightWall = C_wall.createRightWall
C_global.createLeftWall = C_wall.createLeftWall
C_global.createBottomWall = C_wall.createBottomWall
C_global.createTopWall = C_wall.createTopWall

-- INPUT HANDLER --
C_global.getDirection = C_inputHandler.getDirection
C_global.updateTouch = C_inputHandler.updateTouch

return C_global




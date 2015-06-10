local C_block = require ( "C_block" )
-- local C_inputHandler = require ( "C_inputHandler" )

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
C_global.createBlock = C_block.createBlock
C_global.createBlockGroup = C_block.createBlockGroup

-- INPUT HANDLER --
-- C_global.touchListener = C_inputHandler.touchListener

return C_global




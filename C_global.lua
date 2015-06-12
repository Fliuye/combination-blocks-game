local C_block = require ( "C_block" )
local C_wall = require ( "C_wall" )
local C_inputHandler = require ( "C_inputHandler" )

-- global class
local C_global = {}

C_global.maxLevels = 50
C_global.board = { 0, 32, 64, 96, 128, 160, 192, 224, 256, 288, 320, 352, 384, 416, 448, 480 }
C_global.options = { effect = "fade", time = 1200 }

-- C_global.game = {}
C_global.current_level = 1
C_global.unlocked_levels = 1

--C_global.menu = {}
C_global.sound_on = true
C_global.music_on = true

C_global.levels = {}

---------------
-- functions --
---------------
C_global.checkLevelComplete = function ( master_block_group )
  if ( master_block_group ~= nil ) then
    local level_complete = true
    for i = 1, master_block_group.numChildren do
      if ( not ( master_block_group[i].numChildren <= 1) ) then
        level_complete = false
      end
    end
    return level_complete
  end
end

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




-- Block class

local C_block = {}

-- final variables
C_block.WIDTH = 32
C_block.HEIGHT = 32
C_block.SPEED = 6

C_block.createBlockGroup = function ( color ) 
  local group = display.newGroup()
  group.color = color
  group.moving = false
  group.speed = C_block.SPEED
  return group
end

C_block.createBlock = function ( x_pos, y_pos, block_group )
  local block = display.newRect ( x_pos, y_pos, C_block.WIDTH, C_block.HEIGHT )
  -- local block = display.newImage ("Assets/"..color.name.."_block.png", x_pos, y_pos ) 
  block.collsionGroup = {}
  block.moving = false
  block.hsp = 0
  block.vsp = 0
  block.speed = C_block.SPEED -- global speed for all blocks

  if ( block_group.color == "red" ) then
    block:setFillColor( 1.0, 0.27, 0.27 ) 
    block_group:insert ( block )  
  elseif ( block_group.color == "yellow" ) then
    block:setFillColor( 1.0, 1.0, 0.33 ) 
    block_group:insert ( block )   
  elseif ( block_group.color == "blue" ) then
    block:setFillColor( 0.27, 0.27, 1.0 ) 
    block_group:insert ( block ) 
  end
  return block_group
end 
--[[
C_block.createWallH = function ( x_pos, y_pos, wall_group )
  local wall = display.newImage ("Assets/wall_horizontal.png",  x_pos, y_pos ) 
  wall_group:insert( wall )
  return wall_group
end
--]]

-- COLLISION --

C_block.checkCollideLeft = function  ( block, wall_group )
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

C_block.checkCollideRight = function ( block, wall_group )
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

C_block.checkCollideTop = function ( block, wall_group )
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

C_block.checkCollideBottom = function ( block, wall_group )
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


C_block.moveBlock = function ( block_group )

  if ( block_group.moving ) then
    for i = 1, block_group.numChildren do
      if ( block_group[i] ~= nil ) then -- prevents out of bounds array access
        if ( block_group[i].moving ) then 
          if ( block_group[i].hsp > 0 ) then -- moving right
            -- local wall_group = getRightWalls()
            if ( checkCollideRight ( block_group[i], wall_group ) ) then
              block_group[i].hsp = 0
              block_group[i].moving = false
              checkCombine ( block_group[i] )
              block_group.moving = updateGroupMoving()
            end 
          elseif ( block_group[i].hsp < 0 ) then -- moving left
            -- local wall_group = getLeftWalls()
            if ( checkCollideLeft ( block_group[i], wall_group ) ) then
              block_group[i].hsp = 0
              block_group[i].moving = false
              checkCombine ( block_group[i] )
              block_group.moving = updateGroupMoving()
            end
          elseif ( block_group[i].vsp > 0 ) then -- moving down
            -- local wall_group = getBottomWalls()
            if ( checkCollideBottom ( block_group[i], wall_group ) ) then
              block_group[i].vsp = 0
              block_group[i].moving = false
              checkCombine ( block_group[i] )
              block_group.moving = updateGroupMoving()
            end
          elseif ( block_group[i].vsp < 0 ) then -- moving up 
            -- local wall_group = getTopWalls()
            if ( checkCollideTop ( block_group[i], wall_group ) ) then
              block_group[i].vsp = 0
              block_group[i].moving = false
              checkCombine ( block_group[i] )
              block_group.moving = updateGroupMoving()
            end
          end
        end
        if (block_group[i] ~= nil ) then 
          block_group[i].x = block_group[i].x + block_group[i].hsp
          block_group[i].y = block_group[i].y + block_group[i].vsp
        end
      end
    end
  end
  
end

return C_block

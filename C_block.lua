-- Block class

local C_block = {}

-- final variables
C_block.WIDTH = 32
C_block.HEIGHT = 32
C_block.SPEED = 6

--
C_block.createBlockGroup = function ( color ) 
  local group = display.newGroup()
  group.color = color
  group.moving = false
  group.speed = C_block.SPEED
  return group
end
--
C_block.createRedBlock = function ( x_pos, y_pos )
  local block = display.newRect ( x_pos, y_pos, C_block.WIDTH, C_block.HEIGHT )
  block.collsionGroup = {}
  block.moving = false
  block.hsp = 0
  block.vsp = 0
  block.color = "red"
  block.speed = C_block.SPEED -- global speed for all blocks
  block:setFillColor( 1.0, 0.27, 0.27 ) 
  return block
end 
--
C_block.createYellowBlock = function ( x_pos, y_pos )
  local block = display.newRect ( x_pos, y_pos, C_block.WIDTH, C_block.HEIGHT )
  block.collsionGroup = {}
  block.moving = false
  block.hsp = 0
  block.vsp = 0
  block.color = "yellow"
  block.speed = C_block.SPEED -- global speed for all blocks
  block:setFillColor( 1.0, 1.0, 0.33 ) 
  return block
end 
--
C_block.createBlueBlock = function ( x_pos, y_pos )
  local block = display.newRect ( x_pos, y_pos, C_block.WIDTH, C_block.HEIGHT )
  block.collsionGroup = {}
  block.moving = false
  block.hsp = 0
  block.vsp = 0
  block.color = "blue"
  block.speed = C_block.SPEED -- global speed for all blocks
  block:setFillColor( 0.27, 0.27, 1.0 ) 
  return block
end 


-- UTILITY --
C_block.emptyCollisionTable = function ( block )
  for i = 1, table.maxn( block.collisionTable ) do
    table.remove( block.collisionTable )
  end
  block.collisionTable = nil
end
--
C_block.getRightWalls = function ( block, master_block_group, wall_group ) 
  if ( block.collisionTable == nil ) then -- first time through collision check
    local collisionTable = {}
    for i = 1, wall_group.numChildren do -- cycle through all walls in direction
      if ( wall_group[i].x > block.x ) then -- walls in general direction      
        if ((wall_group[i].y > block.contentBounds.yMin ) and ( wall_group[i].y < block.contentBounds.yMax )) then -- walls that will intersect
          table.insert(collisionTable, wall_group[i])
        end
      end
    end
    -- check all blocks of other colors for potential collisions
    for i = 1, master_block_group.numChildren do 
      if (master_block_group[i].color ~= block.color ) then
        local color_group = master_block_group[i]
        for j = 1, color_group.numChildren do       
          if ( color_group[j].x > block.x ) then
            if ((color_group[j].y > block.contentBounds.yMin ) and ( color_group[j].y < block.contentBounds.yMax )) then -- other colored block will intersect
              table.insert(collisionTable, color_group[j])
            end
          end                
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

C_block.getLeftWalls = function ( block, master_block_group, wall_group )
  if ( block.collisionTable == nil ) then -- first time through collision check
    local collisionTable = {}
    for i = 1, wall_group.numChildren do -- cycle through all walls in direction
      if ( wall_group[i].x < block.x ) then -- walls in general direction      
        if ((wall_group[i].y > block.contentBounds.yMin ) and ( wall_group[i].y < block.contentBounds.yMax )) then -- walls that will intersect
          table.insert(collisionTable, wall_group[i])
        end
      end
    end
    -- check all blocks of other colors for potential collisions
    for i = 1, master_block_group.numChildren do 
      if (master_block_group[i].color ~= block.color ) then
        local color_group = master_block_group[i]
        for j = 1, color_group.numChildren do
          if ( color_group[i].x < block.x ) then
            if ((color_group[j].y > block.contentBounds.yMin ) and ( color_group[j].y < block.contentBounds.yMax )) then -- other colored block will intersect
              table.insert(collisionTable, color_group[j])
            end
          end
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


C_block.getTopWalls = function ( block, master_block_group, wall_group )
  if ( block.collisionTable == nil ) then -- first time through collision check
    local collisionTable = {}
    for i = 1, wall_group.numChildren do -- cycle through all walls in direction
      if ( wall_group[i].y < block.y ) then -- walls in general direction      
        if ((wall_group[i].x > block.contentBounds.xMin ) and ( wall_group[i].x < block.contentBounds.xMax )) then -- walls that will intersect
          table.insert(collisionTable, wall_group[i])
        end
      end
    end
    -- check all blocks of other colors for potential collisions
    for i = 1, master_block_group.numChildren do 
      if (master_block_group[i].color ~= block.color ) then
        local color_group = master_block_group[i]
        for j = 1, color_group.numChildren do
          if ( wall_group[i].y < block.y ) then
            if ((color_group[j].x > block.contentBounds.xMin ) and ( color_group[j].x < block.contentBounds.xMax )) then -- other colored block will intersect
              table.insert(collisionTable, color_group[j])
            end
          end
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

C_block.getBottomWalls = function ( block, master_block_group, wall_group )
  if ( block.collisionTable == nil ) then -- first time through collision check
    local collisionTable = {}
    for i = 1, wall_group.numChildren do -- cycle through all walls in direction
      if ( wall_group[i].y > block.y ) then -- walls in general direction      
        if ((wall_group[i].x > block.contentBounds.xMin ) and ( wall_group[i].x < block.contentBounds.xMax )) then -- walls that will intersect
          table.insert(collisionTable, wall_group[i])
        end
      end
    end
    -- check all blocks of other colors for potential collisions
    for i = 1, master_block_group.numChildren do 
      if (master_block_group[i].color ~= block.color ) then
        local color_group = master_block_group[i]
        for j = 1, color_group.numChildren do
          if ( wall_group[i].y > block.y ) then
            if ((color_group[j].x > block.contentBounds.xMin ) and ( color_group[j].x < block.contentBounds.xMax )) then -- other colored block will intersect
              table.insert(collisionTable, color_group[j])
            end
          end
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


--
C_block.checkCombine = function ( current_block, current_group ) 
  if ( current_group.numChildren > 1 ) then
    for i = 1, current_group.numChildren do
      if ( current_group[i] ~= nil ) then -- prevents out of bounds array access
        if ( current_group[i] ~= current_block ) then
          if ( current_group[i].x == current_block.x and current_group[i].y == current_block.y ) then
            -- play animation // particle effect
            current_group:remove( current_group[i] )
            --[[
            if (current_group.numChildren == 1 ) then
              C_block.checkLevelComplete( current_group.parent )
            end
            --]]
          end
        end
      end
    end
  end
end
--
C_block.updateGroupMoving = function ( current_group )
  local still_moving = false
  if ( current_group.moving ) then
    for i = 1, current_group.numChildren do
      if ( current_group[i].moving ) then -- a block is still moving
        still_moving = true
      end
    end
  end
  return still_moving
end
--

-- COLLISION --
C_block.checkCollideLeft = function ( block )
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
      C_block.emptyCollisionTable( block )
      return true
    end
  end
end

C_block.checkCollideRight = function ( block )
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
      C_block.emptyCollisionTable( block )
      return true
    end 
  end
end

C_block.checkCollideTop = function ( block )
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
      C_block.emptyCollisionTable( block )
      return true
    end
  end
end

C_block.checkCollideBottom = function ( block )
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
      C_block.emptyCollisionTable( block )
      return true
    end
  end
end
--
C_block.moveBlock = function ( block_group, master_wall_group )
  if ( block_group.moving ) then
    for i = 1, block_group.numChildren do
      if ( block_group[i] ~= nil and block_group[i].moving ) then -- prevents out of bounds array access
        if ( block_group[i].hsp > 0 ) then -- moving right
          C_block.getRightWalls ( block_group[i], block_group.parent, master_wall_group[1] )
          if ( C_block.checkCollideRight ( block_group[i] )) then
            block_group[i].hsp = 0
            block_group[i].moving = false
            C_block.checkCombine ( block_group[i], block_group )
            block_group.moving = C_block.updateGroupMoving( block_group )
          end 
        elseif ( block_group[i].hsp < 0 ) then -- moving left
          C_block.getLeftWalls ( block_group[i], block_group.parent, master_wall_group[1] )
          if ( C_block.checkCollideLeft ( block_group[i] )) then
            block_group[i].hsp = 0
            block_group[i].moving = false
            C_block.checkCombine ( block_group[i], block_group )
            block_group.moving = C_block.updateGroupMoving( block_group )
          end
        elseif ( block_group[i].vsp > 0 ) then -- moving down
          C_block.getBottomWalls ( block_group[i], block_group.parent, master_wall_group[2] )
          if ( C_block.checkCollideBottom ( block_group[i] )) then
            block_group[i].vsp = 0
            block_group[i].moving = false
            C_block.checkCombine ( block_group[i], block_group )
            block_group.moving = C_block.updateGroupMoving( block_group )
          end
        elseif ( block_group[i].vsp < 0 ) then -- moving up 
          C_block.getTopWalls ( block_group[i], block_group.parent, master_wall_group[2] )
          if ( C_block.checkCollideTop ( block_group[i] )) then
            block_group[i].vsp = 0
            block_group[i].moving = false
            C_block.checkCombine ( block_group[i], block_group )
            block_group.moving = C_block.updateGroupMoving( block_group )
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

-- Restart Level

--[[
Description: 

Level Restart 

--]]

local composer = require( "composer" )
local C_global = require( "C_global" )

local scene = composer.newScene()
-----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

print ("welcome to level restart")
local options
local nextLevel
 
function scene:create( event ) 
  print ("creating!") 
  local sceneGroup = self.view
  display.setDefault ( "background", 1.0, 1.0, 1.0 )
  options = { effect = "fade", time = 1200 }
  
  nextLevel = function ( event ) 
    print ("nextLevel!")
    print ("level"..tostring( C_global.current_level ))
    composer.removeScene  ("level"..tostring( C_global.current_level ))
    composer.gotoScene ("level"..tostring( C_global.current_level ), options )
  end
end 


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
    Runtime:addEventListener ( "enterFrame", nextLevel ) 
  elseif ( phase == "did" ) then
  
    end
end


-- "scene:hide()"
function scene:hide( event )
    
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
    Runtime:removeEventListener ( "enterFrame", nextLevel ) 
  
    elseif ( phase == "did" ) then
    end
end


-- "scene:destroy()"
function scene:destroy( event )
    print ("destroy")
    local sceneGroup = self.view
  
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
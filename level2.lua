local C_global = require ( "C_global" )
local composer = require ( "composer" )

local tapHandler

local scene = composer.newScene()
print ("welcome to level 2")

-- "scene:create()"
function scene:create( event )

  local sceneGroup = self.view
  
  tapHandler = function ( event )
    print ("level2: we made it!")
    composer.removeScene("level"..tostring(C_global.current_level - 1))
    composer.gotoScene ("level"..tostring(C_global.current_level - 1), C_global.options )
  end
  
  Runtime:addEventListener( "tap", tapHandler )
end

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

    elseif ( phase == "did" ) then

    end
end



function scene:destroy( event )

    local sceneGroup = self.view

end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene
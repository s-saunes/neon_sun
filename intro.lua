local storyboard = require( "storyboard" )
local scene = storyboard.newScene()


function scene:createScene( event )

local group = self.view
local onComplete = function(event)
   storyboard.gotoScene( "indigo", "crossFade", 500 )
end
media.playVideo( "introMedia.mp4", false, onComplete )


end

function scene:exitScene( event )
	local group = self.view
	local sceneName = storyboard.getCurrentSceneName()
	timer.performWithDelay(10,function()

		storyboard.removeScene(sceneName)
		
	end)
end

scene:addEventListener( "exitScene", scene )

scene:addEventListener( "createScene", scene )

return scene
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()


function scene:createScene( event )

local group = self.view
	bg = display.newRect(0,0,480,850)
	image = display.newImage("indigo.png")
	image.xScale = .5
	image.yScale = .5
	image.alpha = 0 
	bg.alpha = 0 
	image.x = 240
	image.y = 360

	print "blip"
	transition.to(image, {alpha = 1, time = 600})
	transition.to(bg, {alpha = 1, time = 600})

   timer.performWithDelay(5000,function ()
   		transition.to(bg,{alpha = 0, time = 400})
   		transition.to(image,{alpha = 0, time = 400, onComplete = function()


   		storyboard.gotoScene( "menu", "crossFade", 500 )
   end })
   	end	)




end

function scene:exitScene( event )
	local group = self.view
	local sceneName = storyboard.getCurrentSceneName()
	
	timer.performWithDelay(10,function()
		image:removeSelf()
		bg:removeSelf()
		storyboard.removeScene(sceneName)
		
	end)
end

scene:addEventListener( "exitScene", scene )

scene:addEventListener( "createScene", scene )

return scene
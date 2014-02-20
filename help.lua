local storyboard = require "storyboard"
local scene = storyboard.newScene()



function scene:createScene(e)

--[[menut=0
group = self.view
fontname = "Arcade"
RelX=display.contentWidth/100
RelY=display.contentHeight/100
g = graphics.newGradient({0,0,0}, {100,30,30}, "down")
background = display.newRect(0,0,display.contentWidth, display.contentHeight)
background:setFillColor(g)
titletext= display.newText (menut,RelX*47,RelY*20,fontname,80)
titletext.text= "Instructions"
group:insert(background)
group:insert(titletext)
]]
end

function scene:enterScene(e)
group = self.view
print ("debug")

function test(e)
print ("lol")
end

timer.performWithDelay(1,test,0)

end

function scene:exitScene(e)
	group = self.view

	local sceneName = storyboard.getCurrentSceneName()
	timer.performWithDelay(10, function() 
		storyboard.removeScene(sceneName)
	end)
end

function scene:destroyScene(e)
group = self.view
end

scene:addEventListener("createScene",scene)
scene:addEventListener("enterScene",scene)
scene:addEventListener("exitScene",scene)
scene:addEventListener("destroyScene",scene)
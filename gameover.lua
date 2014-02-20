local storyboard = require "storyboard"
local scene = storyboard.newScene()

local path = system.pathForFile( "save.txt", system.DocumentsDirectory )
local file = io.open( path, "r" )
if file == nil then highscore = 0; end
if file~=nil then 
	for line in file:lines() do
    	highscore=tonumber(line)
	end
	io.close( file )
end 

menut=" "
fontname = "Arcade"
fontname2= "Arcade"
RelX=display.contentWidth/100
RelY=display.contentHeight/100
g = graphics.newGradient({0,0,0}, {100,30,30}, "down")
h = graphics.newGradient({100,30,30}, {255,30,30}, "down")

local function gotomenu(e)
	
	
	storyboard.gotoScene("menu")
end

local function ontouch(e)
	
	if e.phase == "ended" then 
	Runtime:removeEventListener ("touch", ontouch)
	print ("success")
	transition.to (titletext,{time=1000, alpha=0, xScale=3, yScale=2,y=RelY*45}) 
	transition.to (scoretext2,{time=1000,alpha=0,xScale=3,yScale=2,y=RelY*50})
	transition.to (highscoretext2,{time=1002,alpha=0,xScale=3,yScale=2,y=RelY*55, onComplete=gotomenu})
	transition.to (group,{time=1000,alpha=0})
	
	
	
	
	--backgroundMusicChannel = audio.play( bgmusic, { channel=1, loops=-1, fadein=1000 }  )
	end
end

local function addlistener(e)
Runtime:addEventListener ("touch", ontouch)
end

function movetext()
	scoretext2.alpha=0
	scoretext2.xScale=0.1
	scoretext2.yScale=0.1

	highscoretext2.alpha=0
	highscoretext2.xScale=0.1
	highscoretext2.yScale=0.1
	
	titletext.alpha=0
	titletext.xScale=0.1
	titletext.yScale=0.1
	
	transition.to (titletext,{time=2000, alpha=1, xScale=1, yScale=1,y=RelY*45}) 
	transition.to (scoretext2,{time=2000,alpha=1,xScale=1,yScale=1,y=RelY*50})
	transition.to (highscoretext2,{time=2000,alpha=1,xScale=1,yScale=1,y=RelY*55, onComplete=addlistener})
	transition.to (group,{time=1000,alpha=1})
end

function scene:createScene(e)
	
	group = self.view
	group.alpha=0
	background = display.newRect(0,0,display.contentWidth, display.contentHeight)
	background:setFillColor(g)

	scoretext2=display.newText(menut,RelX*48,RelY*70,fontname,50)
	scoretext2.text="Your Score : "..math.floor(Score/2)
	scoretext2:setTextColor(255,255,255)
	highscoretext2=display.newText(menut,RelX*48,RelY*90,fontname,50)
	highscoretext2.text="Highscore : "..math.floor(highscore/2)
	highscoretext2:setTextColor(255,255,255)
	titletext= display.newText (menut,RelX*47,RelY*10,fontname2,75)
	titletext.text="Game Over"
	titletext:setTextColor(h)

	scoretext2.alpha=1
	scoretext2.xScale=1
	scoretext2.yScale=1

	highscoretext2.alpha=1
	highscoretext2.xScale=1
	highscoretext2.yScale=1
	
	titletext.alpha=1
	titletext.xScale=1
	titletext.yScale=1

	group:insert(background)
	group:insert(scoretext2)
	group:insert(highscoretext2)
	group:insert(titletext)
	group:toFront()

end

function scene:enterScene(e)
	group = self.view
	scoretext2.text="Your Score : "..math.floor(Score/2)
	scoretext2:setReferencePoint (display.CenterReferencePoint)
	scoretext2.alpha=1
	scoretext2.xScale=1
	scoretext2.yScale=1
	highscoretext2.text="Highscore : "..math.floor(highscore/2)
	highscoretext2:setReferencePoint (display.CenterReferencePoint)
	highscoretext2.alpha=1
	highscoretext2.xScale=1
	highscoretext2.yScale=1
	titletext.alpha=1
	titletext.xScale=1
	titletext.yScale=1

	movetext()
	
end

function scene:exitScene(e)
	group = self.view
	
	Runtime:removeEventListener("touch",ontouch)
	
	local sceneName = storyboard.getCurrentSceneName()
	timer.performWithDelay(10, function() 
		storyboard.removeScene(sceneName)
	end)

	--menugroup:removeSelf()
end

function scene:destroyScene(e)
	local group = self.view
	
end


scene:addEventListener("createScene",scene)
scene:addEventListener("enterScene",scene)
scene:addEventListener("exitScene",scene)
scene:addEventListener("destroyScene",scene)

return scene
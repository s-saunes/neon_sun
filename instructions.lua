local storyboard = require "storyboard"
local scene = storyboard.newScene()


function changescene()
	storyboard.gotoScene("menu")	
end



function ontouch(e)
Runtime:removeEventListener("touch", ontouch)
transition.to(group,{time=800, alpha=0, onComplete=changescene})

end

function readstats()
	l=0
	local path = system.pathForFile( "stats.txt", system.DocumentsDirectory )
	local file = io.open( path, "r" )
	if file == nil then 
		for l=0, 13 do
			filestats[l]=0
		end
		maxline = 14
		--print (maxline)
	end
		if file == nil then return;end
		if file~=nil then 
		for line in file:lines() do
    		
    		filestats[l] = tonumber(line)
			l=l+1
		end
		maxline=l	
		io.close( file )
	end 
end

function movebox(event)
	z=event.source

	a=a+.02
	if a>360 then a =0; end
		
		titletext.xScale=1+math.sin(a+180)*.01
		titletext.yScale=1+math.sin(a+90)*.01
				
end


--[[ filestats 

1: invisiball
2: kill *
3: powerball
4: caught powerup
5: lost powerup
6: newton
7: autopilot
8: forcefield
9: extralife
10: reverse
11: rotate
12: gameover
13: total score (floor)*
14: dead (floor)*

]]
function scene:createScene(e)
	group = self.view
	
	menut=0
	fontname2 = "Arcade"
	fontname = "Arcade"
	RelX=display.contentWidth/100
	RelY=display.contentHeight/100
	
	g = graphics.newGradient({0,0,0}, {100,30,30}, "down")
	h = graphics.newGradient({100,30,30}, {255,30,30}, "down")
	background = display.newRect(0,0,display.contentWidth, display.contentHeight)
	background:setFillColor(g)
	
	titletext= display.newText (menut,RelX*46,RelY*5,fontname2,75)
	titletext.text= "Statistics"
	titletext:setTextColor(h)
	group:insert(background)
	group:insert(titletext)
end

function scene:enterScene(e)
group = self.view

a=0
filestats = {}
readstats()

Ytext=35
offset=RelY*4

killtext= display.newText (menut, RelX*15, RelY*10,fontname,30)
killtext.text = ("Bricks Destroyed")
killtext:setReferencePoint (display.CenterLeftReferencePoint)
killtext.x = RelX*Ytext
killtext.y = RelY*15+offset
group:insert(killtext)

killtext2= display.newText (menut, RelX*15, RelY*10,fontname,30)
killtext2.text = (filestats[1])
killtext2:setReferencePoint (display.CenterRightReferencePoint)
killtext2.x = RelX*Ytext-RelX*3
killtext2.y = RelY*15+offset
group:insert(killtext2)


deathtext= display.newText (menut, RelX*15, RelY*10,fontname,30)
deathtext.text = ("Deaths")
deathtext:setReferencePoint (display.CenterLeftReferencePoint)
deathtext.x = RelX*Ytext
deathtext.y = RelY*18+offset
group:insert(deathtext)


deathtext2= display.newText (menut, RelX*15, RelY*10,fontname,30)
deathtext2.text = (math.floor(filestats[13]))
deathtext2:setReferencePoint (display.CenterRightReferencePoint)
deathtext2.x = RelX*Ytext-RelX*3
deathtext2.y = RelY*18+offset
group:insert(deathtext2)

kdtext= display.newText (menut, RelX*15, RelY*10,fontname,30)
kdtext.text = ("Kill / Death Ratio")
kdtext:setReferencePoint (display.CenterLeftReferencePoint)
kdtext.x = RelX*Ytext
kdtext.y = RelY*21+offset
group:insert(kdtext)

yourNumber= filestats[1]/ filestats[13]
kdratio = math.floor(yourNumber*100)/100

kdtext2= display.newText (menut, RelX*15, RelY*10,fontname,30)
kdtext2.text = kdratio
kdtext2:setReferencePoint (display.CenterRightReferencePoint)
kdtext2.x = RelX*Ytext-RelX*3
kdtext2.y = RelY*21+offset
group:insert(kdtext2)

scoretext= display.newText (menut, RelX*15, RelY*10,fontname,30)
scoretext.text = ("Total Score")
scoretext:setReferencePoint (display.CenterLeftReferencePoint)
scoretext.x = RelX*Ytext
scoretext.y = RelY*24+offset
group:insert(scoretext)

scoretext2= display.newText (menut, RelX*15, RelY*10,fontname,30)
scoretext2.text = math.floor(filestats[12])
scoretext2:setReferencePoint (display.CenterRightReferencePoint)
scoretext2.x = RelX*Ytext-RelX*3
scoretext2.y = RelY*24+offset
group:insert(scoretext2)

gotext= display.newText (menut, RelX*15, RelY*10,fontname,30)
gotext.text = ("Games Played")
gotext:setReferencePoint (display.CenterLeftReferencePoint)
gotext.x = RelX*Ytext
gotext.y = RelY*27+offset
group:insert(gotext)

gotext2= display.newText (menut, RelX*15, RelY*10,fontname,30)
gotext2.text = filestats [11]
gotext2:setReferencePoint (display.CenterRightReferencePoint)
gotext2.x = RelX*Ytext-RelX*3
gotext2.y = RelY*27+offset
group:insert(gotext2)

pctext= display.newText (menut, RelX*15, RelY*10,fontname,30)
pctext.text = ("PowerUps Caught")
pctext:setReferencePoint (display.CenterLeftReferencePoint)
pctext.x = RelX*Ytext
pctext.y = RelY*30+offset
group:insert(pctext)

pctext2= display.newText (menut, RelX*15, RelY*10,fontname,30)
pctext2.text = filestats [3]
pctext2:setReferencePoint (display.CenterRightReferencePoint)
pctext2.x = RelX*Ytext-RelX*3
pctext2.y = RelY*30+offset
group:insert(pctext2)

pltext= display.newText (menut, RelX*15, RelY*10,fontname,30)
pltext.text = ("PowerUps Lost")
pltext:setReferencePoint (display.CenterLeftReferencePoint)
pltext.x = RelX*Ytext
pltext.y = RelY*33+offset
group:insert(pltext)

pltext2= display.newText (menut, RelX*15, RelY*10,fontname,30)
pltext2.text = filestats [4]
pltext2:setReferencePoint (display.CenterRightReferencePoint)
pltext2.x = RelX*Ytext-RelX*3
pltext2.y = RelY*33+offset
group:insert(pltext2)

gruetext= display.newText (menut, RelX*15, RelY*10,fontname,30)
gruetext.text = ("Deaths By Grue")
gruetext:setReferencePoint (display.CenterLeftReferencePoint)
gruetext.x = RelX*Ytext
gruetext.y = RelY*36+offset
group:insert(gruetext)

gruetext2= display.newText (menut, RelX*15, RelY*10,fontname,30)
gruetext2.text = "0"
gruetext2:setReferencePoint (display.CenterRightReferencePoint)
gruetext2.x = RelX*Ytext-RelX*3
gruetext2.y = RelY*36+offset
group:insert(gruetext2)
Runtime:addEventListener ("touch", ontouch)
--timer.performWithDelay(1,test,0)

group.alpha=0
transition.to(group,{time=800, alpha=1})

timer.performWithDelay (1,movebox,0)
end

function scene:exitScene(e)
	group = self.view
	timer.cancel(z)

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

return scene
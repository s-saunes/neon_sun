local storyboard = require "storyboard"
scene = storyboard.newScene()
local Particles = require("lib_particle_candy")
playparticles = false


function gethigh()
	local path = system.pathForFile( "save.txt", system.DocumentsDirectory )
	local file = io.open( path, "r" )
	if file == nil then highscore = 0; end
	if file~=nil then 
		for line in file:lines() do
    		highscore=tonumber(line)
		end
		print "got highscore from file"
		io.close( file )
	end 

	local path = system.pathForFile( "options.txt", system.DocumentsDirectory )
	local file = io.open( path, "r" )
	if file == nil then 
		fh = io.open( path, "w" )
   		
   		print "making options"

   		fh:write( "1", "\n" )
   		fh:write( "1", "\n" )
   		fh:write( "1", "\n" )
   		options=false; 
   		io.close( fh )
   	end

	l=0
	if file~=nil then 
		options = true 
		for line in file:lines() do
    		l=l+1
    		optionvalues[l]=tonumber(line)
			
		end
		io.close( file )
	end

	if optionvalues[1]==1 then playsounds=true;end
	if optionvalues[1]==0 then playsounds=false;end
	if optionvalues[2]==1 then playmusic=true;end
	if optionvalues[2]==0 then playmusic=false;end
	if optionvalues[3]==1 then playparticles=true;end
	if optionvalues[3]==0 then playparticles=false;end
	print "got options"
	playparticles = false

end
textsize = {
	Header = 80,
	Button = 40,
	Score = 50,
	Version = 20,

}
a=0
version="0.82 internal beta"
menut=" "
fontname ="Bronic"
fontname2 ="Strenuous"
RelX=display.contentWidth/100
RelY=display.contentHeight/100
g = graphics.newGradient({0,0,0}, {100,30,30}, "down")
h = graphics.newGradient({100,30,30}, {255,30,30}, "down")

function nextboard(e)

	--audio.stop(bgmusic)
	if playparticles == true then 
	Particles.StopAutoUpdate()
	Particles.CleanUp()
	--timer.performWithDelay(1,audio.dispose(bgmusic))
end
print "going to next scene"
storyboard.gotoScene(nextscene)
end

function menuset(e)
	if e.phase == "ended" then 
	
		
		menubox:removeEventListener("touch", menuset)
		menuboxtwo:removeEventListener("touch", menuset2)
		--menuboxthree:removeEventListener("touch", menuset3)
		nextscene="game"
		transition.to(group,{time=500, alpha=0, onComplete=nextboard})
	
	end

end

function menuset2(e)
	if e.phase == "ended" then 
	
		
		menubox:removeEventListener("touch", menuset)
		menuboxtwo:removeEventListener("touch", menuset2)
		--menuboxthree:removeEventListener("touch", menuset3)
		nextscene="instructions"
		transition.to(group,{time=500, alpha=0, onComplete=nextboard})
	
	end
end

function menuset3(e)
	if e.phase == "ended" then 
	
		
		menubox:removeEventListener("touch", menuset)
		menuboxtwo:removeEventListener("touch", menuset2)
		--menuboxthree:removeEventListener("touch", menuset3)
		nextscene="options"
		transition.to(group,{time=500, alpha=0, onComplete=nextboard})
	
	end
end
function movebox(event)
	z=event.source

	a=a+0.04
	if a>360 then a =0; end
		
		background.rotation = a
		menubox.xScale=1+math.sin(a)*.1
		menubox.yScale=1+math.cos(a+180)*.1
		menubox.rotation=0+math.sin(a)*2

		menutext.xScale=1.4+math.sin(a-1)*.1
		menutext.yScale=1.4+math.cos(a+179)*.1
		menutext.rotation=0+math.sin(a-1)*2
		
		menuboxtwo.xScale=1+math.sin(a+90)*.1
		menuboxtwo.yScale=1+math.cos(a+270)*.1
		menuboxtwo.rotation=0+math.sin(a+180)*2

		menutext2.xScale=1.4+math.sin(a+89)*.1
		menutext2.yScale=1.4+math.cos(a+269)*.1
		menutext2.rotation=0+math.sin(a+179)*2

	--	menuboxthree.xScale=1+math.sin(a)*.1
	--	menuboxthree.yScale=1+math.cos(a+180)*.1
	--	menuboxthree.rotation=0+math.sin(a)*2

	--	menutext3.xScale=1.4+math.sin(a-1)*.1
	--	menutext3.yScale=1.4+math.cos(a+179)*.1
	--	menutext3.rotation=0+math.sin(a-1)*2
		

		titletext.xScale=1+math.sin(a+180)*.01
		titletext.yScale=1+math.sin(a+90)*.01
	--	highscoretext.xScale=1+math.cos(a+270)*.01
	--	highscoretext.yScale=1+math.sin(a+90)*.01
		
end

function makeparticles()
end


function scene:createScene(e)
	

	--bgmusic = audio.loadStream("menumusic.mp3")
	group = self.view
	
	part=false
	textboxcolor = {.6,.4,.9}

	background = display.newImage ("stars.png",0,0)
	--background:setReferencePoint (display.CenterReferencePoint)
	--background:setFillColor(g)
	
	

	menubox = display.newRoundedRect (RelX*50,RelY*50,RelX*45,RelY*10,10)
	menubox:setFillColor(unpack(textboxcolor))
	
	menutext=display.newText( menut, RelX*50, RelY*50,fontname2,textsize.Button)
	menutext.text="Play"

	menuboxtwo = display.newRoundedRect (RelX*70,RelY*70,RelX*20,RelY*5,10)
	menuboxtwo:setFillColor(unpack(textboxcolor))

	menutext2=display.newText( menut, RelX*70, RelY*70,fontname2,textsize.Button/2)
	menutext2.text="Stats"

--	menuboxthree = display.newRoundedRect (RelX*50,RelY*75,RelX*45,RelY*10,10)
--	menuboxthree:setFillColor(unpack(textboxcolor))

--	menutext3=display.newText( menut, RelX*50, RelY*75,fontname2,textsize.Button-5)
--	menutext3.text="Options"

	versiontext=display.newText (menut, RelX*50, RelY*20, fontname,textsize.Version)
	versiontext.text="Version "..version
	
	titletext= display.newText (menut,RelX*50,RelY*10,fontname2,textsize.Header)
	--titletext:setReferencePoint(display.TopCenterReferencePoint)


	titletext.text="Neon Sun"
	titletext:setFillColor(1,.3,0)
	menutext:setFillColor(0,0,0)
	menutext2:setFillColor(0,0,0)
--	menutext3:setFillColor(0,0,0)

	 

	group:insert(background)
	
	--group:insert(Particles.GetEmitter "E1")
	--group:insert(Particles.GetEmitter "E2")
	group:insert(menubox)
	
	--group:insert(highscoreB)
	group:insert(menutext)
	group:insert(menuboxtwo)
	
	
	group:insert(menutext2)
--	group:insert(menuboxthree)
	
--	group:insert(menutext3)
--	group:insert(titleb)
	group:insert(titletext)
	group:insert(versiontext)
	
	
	group:toFront()
	versiontext:setFillColor(255,255,255)
	group.alpha=0
	print "wtf"
	optionvalues={}
	gethigh()
	timer.performWithDelay (33,movebox,0)
end

function addboxes(e)
	menubox:addEventListener("touch", menuset)
	menuboxtwo:addEventListener("touch", menuset2)
--	menuboxthree:addEventListener("touch", menuset3)

end


function scene:enterScene(e)
	--[[local isPlaying = audio.isChannelPlaying( 1 )
	if isPlaying == false then 
		audio.play(bgmusic,{ channel=1, loops=-1, fadein=700})
	end
	]]
	
	
	--isactive = Particles.EmitterIsActive("E1")
	--makeparticles()
	prev=storyboard.getPrevious()
	
		
		if playparticles == true then 
			if isactive == false or isactive == nil then 
				makeparticles()
			end 
		end

		if playparticles == false then 
			if isactive == true then 
				print "stopping particles"
				Particles.StopAutoUpdate()
				Particles.CleanUp()
			end
		end
	


	if prev ~= "instructions" then
		if prev ~= "options" then 
	
		end 
	end

	group = self.view
	highscoretext=display.newText(menut,RelX*52,RelY*93,fontname,40)
	highscoretext.text="Highscore : "..math.floor(highscore/2)
	highscoretext:setFillColor(1,1,1)
	highscoretext.alpha=1
	group:insert(highscoretext)
	
	
	transition.to(group,{time=800, alpha=1, onComplete= addboxes})
	
end

function scene:exitScene(e)
	group = self.view
	timer.cancel(z)
	
	local sceneName = storyboard.getCurrentSceneName()
	timer.performWithDelay(10, function() 
		storyboard.removeScene(sceneName)
	end)

	--menugroup:removeSelf()
end

function scene:destroyScene(e)
	group = self.view
end


scene:addEventListener("createScene",scene)
scene:addEventListener("enterScene",scene)
scene:addEventListener("exitScene",scene)
scene:addEventListener("destroyScene",scene)

return scene
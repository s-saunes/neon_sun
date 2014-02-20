local storyboard = require "storyboard"
local scene = storyboard.newScene()



menut=" "
fontname = "Arcade"
RelX=display.contentWidth/100
RelY=display.contentHeight/100
g = graphics.newGradient({0,0,0}, {100,30,30}, "down")
h = graphics.newGradient({100,30,30}, {255,30,30}, "down")

function writeoptions()

l=0
	local path = system.pathForFile( "options.txt", system.DocumentsDirectory )
	fh = io.open( path, "w" )
   	
   	print ("SAVING------------")
   	print (o.sound)
   	print (o.music)
   	print (o.particles)
   	print ("------------------")



   	if o.sound == false then 
    fh:write( "0", "\n" )
  	end 
	if o.sound == true then 
    fh:write( "1", "\n" )
  	end 
  	if o.music == false then 
    fh:write( "0", "\n" )
  	end 
	if o.music == true then 
    fh:write( "1", "\n" )
  	end 
  	if o.particles == false then 
    fh:write( "0", "\n" )
  	end 
	if o.particles == true then 
    fh:write( "1", "\n" )
  	end 
  

   		--print ("writing end")
	io.close( fh ) 


end

function movebox(event)
	z=event.source

	a=a+.04
	if a>360 then a =0; end
		for n = 1,maxbox do
		box[n].xScale=1+math.sin(a+(n*90))*.05
		box[n].yScale=1+math.cos(a+(n*90))*.05
		box[n].rotation=0+math.sin(a+(n*90))*1
		text[n].xScale=1+math.sin(a+(n*90)-1)*.05
		text[n].yScale=1+math.cos(a+(n*90))*.05
		text[n].rotation=0+math.sin(a+(n*90)-1)*1
		end
end


function changeboard()
	storyboard.gotoScene("menu")
end

function resetscore()
local path = system.pathForFile( "save.txt", system.DocumentsDirectory )
		local file = io.open( path, "w" )
		
		file:write( 0 )
		io.close( file )
		file = nil		
		transition.to ( text[4], {rotation = 359})

end
function resetstats()
transition.to ( text[5], {rotation = 359})
end


function goback()
	group.alpha=1
	writeoptions()
	transition.to (group,{time=800, alpha=0, onComplete = changeboard})
	for n = 1,maxbox do
	box[n]:removeEventListener ("touch", onTouch)
	end
end

function loadoptions()
	local path = system.pathForFile( "options.txt", system.DocumentsDirectory )
	local file = io.open( path, "r" )
	if file == nil then 
		local path = system.pathForFile( "options.txt", system.DocumentsDirectory )
		fh = io.open( path, "w" )
   		fh:write( "1", "\n" )
   		fh:write( "1", "\n" )
   		fh:write( "1", "\n" )
   		options=false; 
   	end
	
	l=0
	if file~=nil then 
		options = true 
		for line in file:lines() do
    		l=l+1
    		optionvalues[l]=tonumber(line)
			print (tonumber(line))
		end
		io.close( file )
	end

	if options == false then 
		o.sound = true
		o.music = true
		o.particles = true
	end 

	for a = 1,3 do
		print (optionvalues[a])
	end

	if options == true  then 
		if optionvalues[1]==1 then 
			o.sound = true
		end 
		if optionvalues[1]==0 then 
			o.sound = false
		end

		if optionvalues[2]==1 then 
			o.music = true
		end
		if optionvalues[2]==0 then 
			o.music = false
		end

		if optionvalues[3]==1 then 
			o.particles = true
		end 
		if optionvalues[3]==0 then 
			o.particles = false
		end
	end 
	
	
	print ("---------LOADED---------")
	print (o.sound)
	print (o.music)
	print (o.particles)
	setbuttoncolor()
	print ("------------------------")
end

function onTouch(e)
	bpressed = e.target.button
	if e.phase == "ended" then 

	if bpressed == 1 then o.sound = not o.sound;end
	if bpressed == 2 then o.music = not o.music;end
	if bpressed == 3 then o.particles = true;end
	if bpressed == 4 then resetscore();end
	if bpressed == 5 then resetstats();end 
	if bpressed == 6 then goback();end

	setbuttoncolor()
	end

end

function setbuttoncolor()
	
	if o.sound == true then 
		box[1]:setFillColor (160,200,160)
	else 
		box[1]:setFillColor (200,160,160)
	end

	if o.music == true then 
		box[2]:setFillColor (160,200,160)
	else 
		box[2]:setFillColor (200,160,160)
	end

	if o.particles == true then 
		box[3]:setFillColor (160,200,160)
	else 
		box[3]:setFillColor (200,160,160)
	end

end


function scene:createScene(e)
	group=self.view
end

function scene:enterScene(e)
	group = self.view
	textboxcolor = {160,160,160}

--  Load options
	tmp = "Options"
	text={}
	box={}
	optionvalues={}
	o = {}
	
	


	background = display.newRect(0,0,RelX*100,RelY*100)
		background:setFillColor(g)
		group:insert(background)
			
	titletext = display.newText ( tmp,RelX*50, RelY*5,fontname,80) 
--		titletext:setReferencePoint (display.CenterReferencePoint)
		titletext.x = RelX*50
		titletext.y = RelY*10
		titletext:setTextColor ( h)
		group:insert(titletext)
			
	buttontext = { "Sound", "Music", "_____", "Reset Score", "Reset Stats","Back"}
	
	maxbox = #buttontext
	
		for n = 1,maxbox do
			box[n] = display.newRoundedRect (RelX*15,RelY*10+(12*(RelY*n)),RelX*70,RelY*10,15)
			text[n] = display.newText ( buttontext[n], 0,0,fontname,55)
			text[n].x = RelX*50
			text[n].y = RelY*15+(12*(RelY*n))
--			text[n]:setReferencePoint(display.CenterReferencePoint)
			box[n]:addEventListener ("touch", onTouch)
			box[n].button = n
			box[n]:setFillColor(unpack(textboxcolor))
			group:insert(box[n])
			group:insert(text[n])
			
		end

		loadoptions()	

	

		setbuttoncolor()
		
		group.alpha=0
		transition.to(group,{time=800, alpha=1})

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
	local group = self.view
	
end

timer.performWithDelay(33,movebox,0)
scene:addEventListener("createScene",scene)
scene:addEventListener("enterScene",scene)
scene:addEventListener("exitScene",scene)
scene:addEventListener("destroyScene",scene)

return scene
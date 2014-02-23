local storyboard 	= require "storyboard"
local tenflib 		= require "tenfLib"
--local pageScroller  = require "pageScroller"
storyboard.purgeOnSceneChange = true
local scene 		= storyboard.newScene()
local _W 			= display.contentWidth
local _H 			= display.contentHeight
local m 			= {}
local num 
local doc_path 		= system.pathForFile( system.ResourceDirectory )
local page 			= {}
local myGroup 		= display.newGroup()
local icon			= {}
local obj 			= {}
local pageScroller
local movescroll
local pageN = 0
local pageGroup = display.newGroup()
local listoflevelsplayed
local currentlevel = {}
local dialogGroup = display.newGroup()
local menucreated = false
local leveltext
local leveltext2
local leveltext3
local dialogueobj
local dialogButton1
local dialogButton2
function scene:createScene(e)
	local last = storyboard.getPrevious()
	


	backdrop = display.newImageRect("640.jpg",_W*3,_H)
	backdrop.x = _W/2
	backdrop.y = _H/2
	backdrop.alpha = .8
	
	topText = display.newText ( "Level Select",0,0,"Strenuous",60)
	topText.x = _W*.5
	topText.y = _H*.1


	if last then 
		print (last)
		storyboard.removeScene(last)
	end 
	
		function m.findLevels()
			local levelList 	= {}
			local lfs = require "lfs"
			num = 0
			success = true 
			local success = lfs.chdir( doc_path ) -- returns true on success
			local new_folder_path

			if success then
	    		print "lolsucess"
	    		--lfs.mkdir( "levels" )
	    		new_folder_path = lfs.currentdir() .. "/levels"
			end

			for file in lfs.dir(new_folder_path) do
	    		if file ~= "." then
	        		if file ~= ".." then 
	            		if file ~= ".DS_Store" then 
	                		if file ~= "bg.png" then  
	                    		num = num + 1
	                    		levelList[num] = file
	                    		print( "Found file: " .. file )
	                		end
	            		end
	        		end
	    		end
	    	end 

    		listoflevelsplayed = {}
    		return levelList
    		
		end 

	function m.cleanup(event)
		for i=1,#icon do 
			icon[i]:removeEventListener("tap",m.tapEvent)
			display.remove(icon[i])
			display.remove(icon[i].t)
		end 
		display.remove(obj)
	end 

	function m.startgame(level)
		print (level)
		params = {level = level}
		m.cleanup()
		timer.performWithDelay(2, function ()

			dialogButton1:removeEventListener("touch",playgame)
			dialogButton2:removeEventListener("touch",goback)
			pageScroller:removeEventListener('scrollMoved', movescroll)
			display.remove(dialogGroup)
			display.remove(pageScroller)
			display.remove(backdrop)
			display.remove(topText)
			pageScroller = nil 
			--häst

			display.remove(pageScroller)
			pageScroller = nil 
		end )
		
		storyboard.gotoScene("controller",{params = params})
	end 

	function playgame(level)
		transition.to (dialogGroup, {delay = 200,time = 200, x = -_W,transition = easing.inOutQuad, onComplete = function ()
					m.startgame(currentlevel.level)

			end })
		print "starting level"
	end 

	function goback()
		transition.to (dialogGroup, {delay = 200,time = 200, x = -_W,transition = easing.inOutQuad, onComplete = function ()
			transition.to (pageGroup, {delay = 200, time = 300, x = 0, transition = easing.inOutQuad})
			transition.to (topText, {time = 300, y = _H*.1, transition = easing.inOutQuad})
			transition.to (obj, {time = 300, x = _W*.5,transition = easing.inOutQuad})


			end})
		print "going back"
	end 


	function leveldialogue(level)
		
		local hardness = {"not used","child's play", "easy", "medium", "hard", "Emil"}
		

		if menucreated then 
			leveltext.text = currentlevel.name
			leveltext2.text = hardness[currentlevel.hard]
			leveltext3.text = "High Score : "..currentlevel.points
			leveltext4.text = "Min Steps : "..currentlevel.steps
			leveltext5.text = "Min Color : "..currentlevel.colors

		end 

		if not menucreated then
			
			dialogGroup:toFront()
			
			dialogueobj = display.newRoundedRect(dialogGroup,0, 0, _W*.80, _H*.60,5)
				--dialogueobj:setReferencePoint(display.CenterReferencePoint)
				dialogueobj.x = _W*.5
				dialogueobj.y = _H*.5
				dialogueobj.alpha = .1
				dialogueobj:setFillColor(200,255,255)

			
			leveltext = display.newText (dialogGroup,currentlevel.name,0,0,"Strenuous",50)
				leveltext.x = _W*.5
				leveltext.y = _H*.25
			leveltext2 = display.newText (dialogGroup,"penis",0,0,"Bronic",30)
				leveltext2.x = _W*.5
				leveltext2.y = _H*.30
			leveltext3 = display.newText (dialogGroup,"High Score : "..currentlevel.points,0,0,"Bronic",40)
				leveltext3.x = _W*.5
				leveltext3.y = _H*.40
			leveltext4 = display.newText (dialogGroup,"Min Steps : "..currentlevel.steps,0,0,"Bronic",40)
				leveltext4.x = _W*.5
				leveltext4.y = _H*.45
			leveltext5 = display.newText (dialogGroup,"Min Color : "..currentlevel.colors,0,0,"Bronic",40)
				leveltext5.x = _W*.5
				leveltext5.y = _H*.50
			


			dialogButton1 = display.newRoundedRect (dialogGroup,0,0,_W*.30,_H*.08,3)
			dialogButton2 = display.newRoundedRect (dialogGroup,0,0,_W*.30,_H*.08,3)
				dialogButton1.x = _W*.5 - _W*.2
				dialogButton2.x = _W*.5 + _W*.2
				dialogButton1.y = _H*.7
				dialogButton2.y = _H*.7
				dialogButton1.alpha = .2
				dialogButton2.alpha = .2
				dialogButton1.strokeWidth = 2
				dialogButton2.strokeWidth = 2


			local dialogtext1 = display.newText (dialogGroup,"Play",0,0,nil,20)
			local dialogtext2 = display.newText (dialogGroup,"Back",0,0,nil,20)


			

			dialogtext1.x, dialogtext1.y = dialogButton1.x, dialogButton1.y
			dialogtext2.x, dialogtext2.y = dialogButton2.x, dialogButton2.y

			dialogGroup.x = -_W*2
		end 
			transition.to (dialogGroup, {time = 300, x=0, transition = easing.inOutQuad, onComplete = function ()
				
				if not menucreated then 
					dialogButton1:addEventListener("touch",playgame)
					dialogButton2:addEventListener("touch",goback)
					menucreated = true 
				end 
			end} )


			
	end 


	function m.showlevel(event)
		local level = event
		--local list = gamelogic.loadstate()
		local gameboard= tenflib.jsonLoad( "levels/"..level, system.ResourceDirectory )
		local lististrue = false
		if list then 

			for i = 1,#list do 
				
				if list[i].name == level then 
					

					currentlevel.name 	= gameboard.Name
					currentlevel.type 	= gameboard.Type
					currentlevel.hard 	= gameboard.MarkerColorMaxSegments
					currentlevel.points = list[i].points
					currentlevel.steps 	= list[i].numberofmoves
					currentlevel.colors = list[i].pickedupcolors
					currentlevel.level 	= level 
					lististrue = true 
				else 
					
				end 

			end 
		end 

		if not lististrue then 
			currentlevel.name 	= "name"
			currentlevel.type 	= "type"
			currentlevel.hard 	= "diff"
			currentlevel.points = 0
			currentlevel.steps 	= 0
			currentlevel.colors = 0
			currentlevel.level 	= level 
		end 

		for k,v in pairs(currentlevel) do
			print(k,v)
		end

		
		leveldialogue(currentlevel)

	end 

	function m.tapEvent(event)
		local touched = event.target.level
		print (touched)
		transition.to (pageGroup, {time = 200, x = _W * 2, transition = easing.inOutQuad})
		transition.to (topText, {time = 200, y = -_H, transition = easing.inOutQuad, onComplete = function () m.showlevel(touched) end})
		transition.to (obj, {time = 300, x = _W*2,transition = easing.inOutQuad})

		
	end 



	function m.createPage(levelList)
		local amtPages = math.ceil(#levelList / 16)
		print (amtPages)


		local row,col = 0,0 
		
		obj = display.newRoundedRect(0, 0, _W*.80, _H*.60,5)
		--obj:setReferencePoint(display.CenterReferencePoint)
		obj.x = _W*.5
		obj.y = _H*.5
		obj.alpha = .1
		obj:setFillColor(.9,1,1)
		local pageoffset = _W
		local iNum = 0 
		--for p = 1, amtPages do 
		
		

			for i = 1, #levelList do 
				iNum = iNum + 1
				row = row + 1 
				
				if row>4 then 
					col = col + 1 
					row = 1 
				end 
				
				if col > 3 then 
					col = 0 
					row = 1
					pageN = pageN + 1
				end 
				
			

				icon[iNum] = display.newRoundedRect (pageGroup,0,0,70,70,5)
				icon[iNum].t = display.newText (pageGroup,i,0,0,"Bronic",40)

				--icon[iNum]:setReferencePoint (display.CenterReferencePoint)
				
				icon[iNum].level = levelList[i]
				icon[iNum].alpha = .4
				icon[iNum]:setFillColor (200,200,255)


				icon[iNum].x = row * 85 + 28 + (pageoffset*pageN)
				icon[iNum].y = col * 90 + 260
				icon[iNum].t.x = icon[i].x
				icon[iNum].t.y = icon[i].y
				
				
				icon[iNum]:addEventListener("tap",m.tapEvent)
				icon[iNum].strokeWidth = 8
				icon[iNum]:setStrokeColor(0,0,255)
				--icon[iNum].alpha = .9
			end 
		
			if listoflevelsplayed then 

				for i = 1, iNum do 
					for n = 1, #listoflevelsplayed do 
					
					
						if listoflevelsplayed[n].name == icon[i].level then 
							print ("found")
							icon[i]:setStrokeColor (0,255,0)
							icon[i]:setFillColor (200,255,200)
			
					
						end 
					end 
				end 
			end 


		
			function movescroll(e)
				print "yo"
				pageGroup.x = _W*(1-e.x)
			end
			print (amtPages)
			pageScroller = require('pageScroller')(0,0, _W, _H, _W*.80, _H, amtPages, 1, true)	
		
			pageScroller:addEventListener('scrollMoved', movescroll)

	end 

levelList = m.findLevels()

--makepages(amtLevels)

pg = m.createPage(levelList)

pageGroup:toFront()
pageGroup.x = _W * 2

topText.y = - _H 
obj.x = pageGroup.x

transition.to (pageGroup, {delay = 200, time = 300, x = 0, transition = easing.inOutQuad})
transition.to (topText, {time = 300, y = _H*.1, transition = easing.inOutQuad})
transition.to (obj, {time = 300, x = _W*.5,transition = easing.inOutQuad})


end 

function scene:enterScene(e)
	
end 

function scene:exitScene(e)


print "exiting scene, bitch"

end 

function scene:destroyScene(e)
end





scene:addEventListener("createScene",scene)
scene:addEventListener("enterScene",scene)
scene:addEventListener("exitScene",scene)
scene:addEventListener("destroyScene",scene)
return scene

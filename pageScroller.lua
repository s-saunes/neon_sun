------------------------------------------------------------------------------------------
--
-- Page Scroller av 10FINGERS AB
-- pageScroller.lua
--
-- Påbörjad: 2012-11-16 av Marcus Thunström
-- Uppdaterad: 2012-11-26 av Marcus Thunström
--
--[[--------------------------------------------------------------------------------------



API-beskrivning:

	pageScroller = require('modules.pageScroller')( [parent,] swipeAreaLeft, swipeAreaTop, swipeAreaWidth,
			swipeAreaHeight, pageWidth, pageHeight, horizontalPages, verticalPages, continousScrolling )
		- parent: vilken grupp swipearean ska läggas in i. (Default: nil)
		- swipeAreaLeft: vänstermarginal för swipearean.
		- swipeAreaTop: toppmarginal för swipearean.
		- swipeAreaWidth: swipeareans bredd.
		- swipeAreaHeight: swipeareans höjd.
		- pageWidth: sidbredd. (Fingrets x-position delas med detta tal vid swipe.)
		- pageHeight: sidbredd. (Fingrets y-position delas med detta tal vid swipe.)
		- horizontalPages: antal sidor i x-led. (Kan ändras med pageScroller:setPageAmountX().)
		- verticalPages: antal sidor i y-led. (Kan ändras med pageScroller:setPageAmountY().)

	pageScroller:getPageAmountX(  ) :: Returnerar antalet sidor på x-axeln.
	pageScroller:getPageAmountY(  ) :: Returnerar antalet sidor på y-axeln.
		> Returnerar: antalet sidor.

	pageScroller:setPageAmountX( pageAmount ) :: Sätter antalet sidor på x-axeln.
	pageScroller:setPageAmountY( pageAmount ) :: Sätter antalet sidor på y-axeln.
		- pageAmount: nya antalet sidor.



Event:

	scrollBegan
		Avfyras när en scrollning börjar.
		event.target är scroller-objektet.

	scrollEnded
		Avfyras när en scrollning slutar.
		event.target är scroller-objektet.
		event.x är var på vilken sida i x-led användaren tappat. Ex. 1 = första sidan, 2 = andra sidan, 1.5 = i mitten på första sidan
		event.y är var på vilken sida i y-led användaren tappat.

	scrollMoved
		Avfyras när scrollpositionen har ändrats.
		event.target är scroller-objektet.
		event.x är var på vilken sida i x-led användaren tappat. Ex. 1 = första sidan, 2 = andra sidan, 1.5 = i mitten på första sidan
		event.y är var på vilken sida i y-led användaren tappat.

	scrollTap
		Avfyras när användaren tappat på swipearean (utan att ha scrollat).
		event.target är scroller-objektet.
		event.x är var på vilken sida i x-led användaren tappat. Ex. 1 = första sidan, 2 = andra sidan, 1.5 = i mitten på första sidan
		event.y är var på vilken sida i y-led användaren tappat.
		event.touchX är fingrets x-position på skärmen vid tappning.
		event.touchY är fingrets y-position på skärmen vid tappning.



Exempel på användande:

	local width, height = display.contentWidth, display.contentHeight

	-- Lägg in tre sidor med varsin text i en grupp
	local pageGroup = display.newGroup()
	display.newText(pageGroup, '1', 0.5*width, height/2, system.nativeFont, 128)
	display.newText(pageGroup, '2', 1.5*width, height/2, system.nativeFont, 128)
	display.newText(pageGroup, '3', 2.5*width, height/2, system.nativeFont, 128)

	-- Skapa scrollerobjekt
	local pageScroller = require('modules.pageScroller')(0, 0, width, height, width, height, 3, 1, true)

	-- Lätt till event listeners
	pageScroller:addEventListener('scrollMoved', function(e)
		pageGroup.x = width*(1-e.x)
	end)
	pageScroller:addEventListener('scrollTap', function(e)
		print('Tap på sida: '..math.floor(e.x))
	end)



--]]--------------------------------------------------------------------------------------



local tenfLib            = require('tenfLib')

local outQuad            = easing.outQuad
local printObj           = tenfLib.printObj
local tableGetAttr       = tenfLib.tableGetAttr
local tableSum           = tenfLib.tableSum
local transitionTo       = transition.to

local deadZoneR          = 20
local initialSwipeSpeed  = 300
local releaseMultiplier  = 18
local snapDistance       = 0.004
local swipeMultiplier    = 400

local k                  = {}

local methods            = {}

local collectPosition
local focusBeganHandler, focusMovedHandler, focusEndedHandler
local _W = display.contentWidth
local _H = display.contentHeight







-- Funktioner
------------------------------------------------------------------------------------------



function collectPosition(scroller)
	local data = scroller[k]
	local positionHistory = data.positionHistory
	if #positionHistory > 10 then table.remove(positionHistory, 1) end
	positionHistory[#positionHistory+1] = {x=data.touchX, y=data.touchY}
end



function focusBeganHandler(e)
	print ("hello thar")
	local scroller = e.target
	local data = scroller[k]
	if data.movingStarted then
		if data.swipeTransition1 then transition.cancel(data.swipeTransition1) end
		if data.swipeTransition2 then transition.cancel(data.swipeTransition2) end
		data.swipeTransition1 = nil
		data.swipeTransition2 = nil
		data.touchStartX, data.touchStartY, data.positionHistory = e.x, e.y, nil
		focusMovedHandler(e)
	end
end



function focusMovedHandler(e)
	local scroller = e.target
	local data = scroller[k]
	if not data.movingStarted and tenfLib.pointDist(e.x, e.y, e.xStart, e.yStart) > deadZoneR then
		data.movingStarted, data.touchStartX, data.touchStartY = true, e.x, e.y
		scroller:dispatchEvent{name='scrollBegan', target=scroller}
	end
	if data.movingStarted then
		local x, y = 1, 1
		data.touchX, data.touchY = e.x, e.y
		if data.pageAmountX > 1 then x = data.x+(data.touchX-data.touchStartX)/data.pageWidth end
		if data.pageAmountY > 1 then y = data.y+(data.touchY-data.touchStartY)/data.pageHeight end
		local minX, minY = 2-data.pageAmountX, 2-data.pageAmountY
		if x > 1 then x = (x-1)/2+1 elseif x < minX then x = (x-minX)/2+minX end
		if y > 1 then y = (y-1)/2+1 elseif y < minY then y = (y-minY)/2+minY end
		scroller:dispatchEvent{name='scrollMoved', target=scroller, x=2-x, y=2-y}
		if not data.positionHistory then
			data.positionHistory = {x=data.touchX, y=data.touchY}
			Runtime:addEventListener('enterFrame', data.positionCollector)
		end
	end
end



function focusEndedHandler(e)
	local scroller = e.target
	local data = scroller[k]
	if data.movingStarted then

		if data.pageAmountX > 1 then data.x = data.x+(e.x-data.touchStartX)/data.pageWidth end
		if data.pageAmountY > 1 then data.y = data.y+(e.y-data.touchStartY)/data.pageHeight end

		local minX, minY = 2-data.pageAmountX, 2-data.pageAmountY
		if data.x > 1 then data.x = (data.x-1)/2+1 elseif data.x < minX then data.x = (data.x-minX)/2+minX end
		if data.y > 1 then data.y = (data.y-1)/2+1 elseif data.y < minY then data.y = (data.y-minY)/2+minY end

		Runtime:removeEventListener('enterFrame', data.positionCollector)

		local x = tableGetAttr(data.positionHistory, 'x')
		local y = tableGetAttr(data.positionHistory, 'y')
		data.positionHistory = nil

		data.xSpeed = data.pageAmountX > 1 and #x > 1 and (x[#x]-x[1])/(#x-1) or 0
		data.ySpeed = data.pageAmountY > 1 and #y > 1 and (y[#y]-y[1])/(#y-1) or 0

		local targetPointX = data.pageAmountX > 1 and data.x+data.xSpeed*releaseMultiplier/data.pageWidth  or data.x
		local targetPointY = data.pageAmountY > 1 and data.y+data.ySpeed*releaseMultiplier/data.pageHeight or data.y

		local targetX = tenfLib.clamp(math.round(targetPointX), minX, 1)
		local targetY = tenfLib.clamp(math.round(targetPointY), minY, 1)

		if not data.continousScrolling then
			targetX = tenfLib.clamp(targetX, math.floor(data.x), math.ceil(data.x))
			targetY = tenfLib.clamp(targetY, math.floor(data.y), math.ceil(data.y))
		end

		local largestDist = math.max(math.abs(targetX-data.x), math.abs(targetY-data.y))
		local time = largestDist > snapDistance and initialSwipeSpeed+swipeMultiplier*math.max(largestDist-1, 0) or 0
		--
		-- local xDist, yDist = math.abs(targetX-data.x), math.abs(targetY-data.y)
		-- local time
		-- if xDist > yDist then
		-- 	time = (300+400*math.max(xDist-1, 0))/(math.abs(data.xSpeed)/200+1)
		-- 	print(math.abs(data.xSpeed), time)
		-- else
		-- end
		--
		-- local xDist, yDist = math.abs(targetX-data.x), math.abs(targetY-data.y)
		-- local targetPointDistX = math.abs(targetPointX-data.x)
		-- local targetPointDistY = math.abs(targetPointY-data.y)
		-- local distDiffX, distDiffY = math.abs(xDist-targetPointDistX), math.abs(yDist-targetPointDistY)
		-- local timeDistX, timeDistY = xDist/(4*distDiffX+1), yDist/(4*distDiffY+1)
		-- local time = 100+500*math.max(timeDistX, timeDistY)

		data.swipeTransition1 = transition.to(data, {time=time, x=targetX, transition=outQuad})
		data.swipeTransition2 = transition.to(data, {time=time, y=targetY, transition=function(...)
			data.y = outQuad(...)
			scroller:dispatchEvent{name='scrollMoved', target=scroller, x=2-data.x, y=2-data.y}
			return data.y
		end, onComplete=function()
			data.swipeTransition1 = nil
			data.swipeTransition2 = nil
			data.movingStarted = false
			scroller:dispatchEvent{name='scrollMoved', target=scroller, x=2-data.x, y=2-data.y}
			scroller:dispatchEvent{name='scrollEnded', target=scroller}
		end})

	else
		local x = data.pageAmountX > 1 and 2-data.x+e.x/data.pageWidth  or 1
		local y = data.pageAmountY > 1 and 2-data.y+e.y/data.pageHeight or 1
		scroller:dispatchEvent{name='scrollTap', target=scroller, x=x, y=y, touchX=e.x, touchY=e.y}
	end
end







-- Metoder
------------------------------------------------------------------------------------------



function methods.getPageAmountX(scroller, amount) return scroller[k].pageAmountX end
function methods.setPageAmountX(scroller, amount) scroller[k].pageAmountX = amount end

function methods.getPageAmountY(scroller, amount) return scroller[k].pageAmountY end
function methods.setPageAmountY(scroller, amount) scroller[k].pageAmountY = amount end







-- Constructor
------------------------------------------------------------------------------------------



return function(parent, saLeft, saTop, saWidth, saHeight, pageWidth, pageHeight, hPages, vPages, continousScrolling)

	if type(parent) ~= 'table' then
		parent, saLeft, saTop,  saWidth, saHeight, pageWidth, pageHeight, hPages,     vPages, continousScrolling =
		nil,    parent, saLeft, saTop,   saWidth,  saHeight,  pageWidth,  pageHeight, hPages, vPages
	end



	local scroller
	if parent then
		scroller = display.newRect(parent, saLeft, saTop, saWidth, saHeight)
		scroller.anchorX = 0
		scroller.anchorY = 0
		--scroller.x = _W/2
		--scroller.y = _H/2
		
	else
		scroller = display.newRect(saLeft, saTop, saWidth, saHeight)
		scroller.anchorX = 0
		scroller.anchorY = 0
		--scroller.x = _W/2
		--scroller.y = _H/2
	end
	scroller.alpha = .01
	--tenfLib.setAttr(scroller, methods):setFillColor(0, 0)

	scroller[k] = {
		continousScrolling = continousScrolling,
		movingStarted = false,  movingSpeed = 0,
		pageAmountX = hPages,  pageAmountY = vPages,
		pageWidth = pageWidth,  pageHeight = pageHeight,
		positionCollector = function() collectPosition(scroller) end,
		positionHistory = nil,
		x = 1,  y = 1,
		xSpeed = 0,  ySpeed = 0,
	}

	tenfLib.enableFocusOnTouch(scroller)
	scroller:addEventListener('focusBegan', focusBeganHandler)
	scroller:addEventListener('focusMoved', focusMovedHandler)
	scroller:addEventListener('focusEnded', focusEndedHandler)



	return scroller

end



--[[             .,77$I88$?
        .?ZZ77Z:..,:ZZZOONZ$O8O$:
      ,ZOOMO8$,....:OOOOZODZ8OD8OZ.
  ,ZODO8$DDNI:,....,O8OZOODN$$OOO7
.OOO8888$NMN$+,....,Z8I+I$OD877OO.
?8OOO8ZOOMMN8O=,...,7OII$$?IMO$Z$
 $DOOZOONMN$ZZD?=,.,7$7$$DN?78O$.
  Z8OZ$ZMN$ZNN7O$+,.+8$I$NMD??                 ,:::::::,,,.
   $8OO.8DNMMNZZZ~,.,I$$$?Z$I=.             ,:,::::~~~:. .
    ZZ+ $ZODO888+::,,.,~$7$I?+            :~:,,,,:
        .ZOO88O8+~:,,,..,I?I+,          8NNDZ:,,
         7$ZOOZ?+:,~::,...+=:.        NMMMMNO.
          Z$$$+?+~I88D8O,..,        ZNMMMND.
          :?$O$++=8NN8N8:...       NMNNNN.
          :7I7+?+=?DNNND:,.,     :7NNNDI
          I7+7I?I++$ZOZ7=,:O=  .,,~888+
        .I77$$Z7?I$$$77I~:,.?DZ,,,,:8$
        7$$777Z$$7?I?++~:,,..=DD:,,.,?
       7$$$7I77$II++~:::,,...,8DD:,..,,
      ,7$$$7I777?I++~::,,.....=DDDZ,...,
      77$77$I$II??+=~~:,,,....,DDDDD,..,,
     .777III77$??+=:~~~:,,,,,.,=DD8D~...,,
     I777I??I$ZI?=~:~==:,,.,..,,8D$DZ....,
     III??++I7I?=~,,,~~~:,,....,IO=DZ....,.
     I?+==~=I??=~~,,.:~:,,....,,::+8:....,.
    .II?=++=I?+=~~::,,:::,,,..,,,,::,......
     +I?++=?=?+==~~:::::=:,,,,,,:,,,,.....,
      II+??????++~~==~=~~:,::,,::,,,.,...,,.
      7I?+?7?I??~:+=+++?==~,,,,::,..=:,,.,,,
     .I++?I++??++=~~~===+?~:,,,.    ,=~,...,
      I+===++++=+~====?=++~,,.,      :=:,.,,
      ?+~:~~= ,,~~~==~~=+~:,.,,       =~:,,.
      =+=~::~.       =~~+~,,,,,       ,~:,,.
       ++~:,,.       =~~+~::,,.       =~,,,
       +=~:,,,       =~~:,,,,,        ~:..,
       ~+~,,.,      .~:~:,....        =:.,,
       .+=,,..      ~:=:,,,,,         ~,..,
        ?+~,..,   .~::~:,,,,,         ~,..,
        +~:,.., ,:~:::~:,,..,         :,,.,
        +~,...,~~::~:~:,.....        .:,,,,
       .~,,....I7=+=:~:,,...         ::,=::,
      .,,,,,,.,     ,,,,....        ,+=,+:,~
     :=,:=,,~,,     :::::,,,.         ,::=~
    .?=,+:,,:,,    ~~~~~,,,,,
                   ..~7++=:~.
]]

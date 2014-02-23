local storyboard 	= require "storyboard"
local scene 		= storyboard.newScene()
local group
--local Particles 	= require("lib_particle_candy")
local physics 		= require("physics")
local lev = require ("level")
local files = require ("files")
--physics.setDrawMode("hybrid") 
local _W = display.contentWidth
local _H = display.contentHeight

-- Loading the highscore from file 
function loadHighscore() 

Highscore = files.loadscore()
optionvalues = files.loadoptions()    
filestats = files.readstats()

    if optionvalues[1]==1 then playsounds=true;		end
    if optionvalues[1]==0 then playsounds=false;	end
    if optionvalues[2]==1 then playmusic=true;		end
    if optionvalues[2]==0 then playmusic=false;		end
    if optionvalues[3]==1 then playparticles=true;	end
    if optionvalues[3]==0 then playparticles=false;	end
    playparticles = false
end


-- initializing values
function init()
    Lives               = 5
    level               = 1





    if debugflag then print "init";end
    
    -- Resetting the statistics
    filestats			= {}
    stats 				= {}
    stats.dead 			= 0
    stats.kill 			= 0
    stats.gameover 		= 0
    stats.poweruplost 	= 0
    stats.powerupcaught = 0
    stats.score 		= 0
    stats.extralife 	= 0
    stats.powerball 	= 0
    stats.rotate 		= 0
    stats.newton 		= 0
    stats.autopilot 	= 0
    stats.forcefield 	= 0
    stats.invisiball 	= 0
    stats.reverse 		= 0
    
   filestats = files.readstats()
    
    -- init lists
    hit                 = false
    rotation 			= {}
    enemypad 			= {}
    EnemyColors 		= {}
    enemypad2 			= {}
    colors  			= {}
    enemypaddle 		= {}
    RandX  				= {}
    RandY 				= {}
    mt 					= {}
    Boss 				= {}
    maxBallSpeed 		= {}
    maxenemyspeed 		= { x = 500, y = 500}
    -- Setting start values 
    freeze              = 0
    newlevelflag        = 0
    movepaddleflag      = 0
    debugflag 			= false
    combo 				= -1
    guns 				= false
    gunstarted 			= false
    transflag 			= 0
    bossisdead 			= true
    bossexist 			= false
    bosslife 			= 2500
    Boss.life 			= bosslife
    oldvx, oldvy 		= 0,0
    bomb 				= false
    pause  				= 0 
    btime  				= 0 
    maxpart 			= 0
    oldpart 			= 0
    resetballflag 		= 0
    hitflag 			= 0
    resetenemyflag 		= 0
    firsttouch 			= false
    startedPhysics 		= false
    
    
    barsvisible			= 1
    youaredead			= false
    noscale				= 0 
    gravflag			= 0
    multiplier 			= 1
    
    
    Score 				= 0
    bombparticle		=false
    wob 				=0
    wobbleflag 			=0
    gravT 				=0
    gravN 				=0
    powerupitem 		=nil
    powerupexist 		=false
    pilotN 				=0
    pilotflag 			=0
    reverseflag 		=0
    reverseN			=0
    forcefieldflag 		=0
    forcefieldN 		=0
    makefield 			=false
    time 				=0
    al 					=0
    invisiflag 			=0
    dance  				=0 
    
    for a=1, 20 do 
        mt[a]=""
    end
end


function makeobjects()
    a=0
    
    tmp 			= ""
    
    
    -- Setting fontsizes for the scoredisplay
    fontsize = {
	Top 	= 40, 
	Bottom 	= 30,
	Middle 	= 50,
    }
    
    -- setting background
    
    background = display.newRect(0,0,_W,_H)
        background:setFillColor (1,0,0)
        background.x, background.y = _W*.5, _H*.5
    leftwall = display.newRect(0,0,5,_H)
        leftwall.x = 0
        leftwall.y = _H*.5
        leftwall:setFillColor(1,1,1)
        leftwall.alpha=1
    leftbounds = display.newRect(0,0,50,_H)
        leftbounds:setFillColor(0,0,0)
        leftbounds.anchorX = 1
        leftbounds.anchorY = .5
        leftbounds.x = -1
        leftbounds.y = _H*.5
    rightwall = display.newRect(0,0,5,_H)
        rightwall.x = _W*1
        rightwall.y = _H*.5
        rightwall:setFillColor(1,1,1)
        rightwall.alpha = 1
    rightbounds = display.newRect(0,0,50,_H)
        rightbounds:setFillColor(0,0,0)
        rightbounds.anchorX = 0
        rightbounds.anchorY = .5
        rightbounds.x = _W+1
        rightbounds.y = _H*.5
    topwall = display.newRect(0,0,_W,5)
        topwall.x = _W/2
        topwall:setFillColor(1,1,1)
        topwall.alpha=1
    bottomwall = display.newRect(0,0,_W,5)
        bottomwall.x = _W/2
        bottomwall.y = _H
        bottomwall:setFillColor(1,1,1)
        bottomwall.type="die"
        bottomwall.alpha=1
    bottombounds = display.newRect(0,0,_W,50)
        bottombounds:setFillColor(0,0,0)
        bottombounds.anchorX = .5
        bottombounds.anchorY = 0
        bottombounds.x = _W/2
        bottombounds.y = _H+1
    
    paddle = display.newImage ("paddle.png",RelX*38,RelY*85)
        paddle:setFillColor(255,255,255)
        paddle.type="paddle"
        paddle.alpha = 1
        paddle.life = 1000
        paddle.xScale = 1

    paddleblend = display.newImage ("Ballmask.png",0,0)
        paddleblend:setFillColor(.5,.5,1)
        paddleblend.blendMode="add"
        paddleblend.xScale=4.5
        paddleblend.yScale=1.5
        paddleblend.alpha = .5
    
    ball = display.newCircle( 0, 0, 15 )
        ball:setFillColor(160,160,255)
        ball:setStrokeColor(100,100,255)
        ball.strokeWidth=3
        ball.type = "you"
        ball.x, ball.y = display.contentWidth / 2, RelY*15
        ball.type = "you"
        physics.addBody(ball, "dynamic", {density = .6, friction = 0, bounce = 1, isSensor = false, radius = 15})
        ball.isBullet = true
        ball:setLinearVelocity(math.random (200)-10, -1000)
        ball.alpha=0
    
    Ballimg = display.newImage("Ball.png", 0, 0)
        Ballimg.xScale=1.7
        Ballimg.yScale=1.7
        Ballimg.alpha = 1 
    
    Ballimgblend = display.newImage("Ballmask.png", 0, 0)
        Ballimgblend.xScale=1.8
        Ballimgblend.yScale=1.8
        Ballimgblend.alpha=.2
        Ballimgblend.blendMode="add"
    
    followline = display.newGroup()
    followlineB = display.newImage("Ballmask.png",0,-100)
        followlineB:setFillColor(250,250,250)
        followlineB.blendMode="add"
        followlineB.xScale=0.8
        followlineB.yScale=2.5
        followline:insert(followlineB)
        followline.alpha=0
    
    physics.addBody(topwall, 	"static", 		{density = 1.0, friction = 0.1, bounce = 0.08, 	isSensor = false})
    physics.addBody(bottomwall, "static", 		{density = 1.0, friction = 0.5, bounce = .98, 	isSensor = false})
    physics.addBody(leftwall, 	"static", 		{density = 1.0, friction = 0.5, bounce = .08, 	isSensor = false})
    physics.addBody(rightwall, "static", 		{density = 1.0, friction = 0.5, bounce = .08, 	isSensor = false})
    physics.addBody(paddle, 	"kinematic", 	{density = 1.0, friction = 0.1, bounce = 1.001, isSensor = false})
    
    scoretext = display.newText ( tmp, 0,0, fontname2, fontsize.Top)
        scoretext.x = _W*.5
        scoretext.y = _H*.5
        scoretext:setFillColor ( 255,255,255 )
        scoretext.blendMode="add"
    
    highscoretext = display.newText ( tmp, RelX*69,RelY*22,fontname2, fontsize.Top)
        highscoretext:setFillColor ( 255,255,255)
        highscoretext.blendMode="add"
    
    powertext = display.newText (tmp, 0,0,fontname,30)
    pointtext = display.newText (tmp, 0,0,fontname,30)
    lifetext = display.newText ( tmp, RelX*15, RelY*95, fontname2, fontsize.Bottom )
        lifetext.blendMode="add"
    leveltext = display.newText( tmp, RelX*50,RelY*50, fontname, 30)
        leveltext.blendMode="add"
    modtext = display.newText (tmp, RelX*100, RelY*2,fontname2,fontsize.Bottom)
        modtext.blendMode="add"
    multitext= display.newText (tmp, RelX*45,RelY*1, fontname2, 40)
        multitext.anchorX = .5
        multitext.anchorY = 0
        multitext.x = _W*.5
        multitext.y = _H*.01
        multitext.blendMode="add"
    
    group:insert(background)
    group:insert(followline)	
    group:insert(bottomwall)
    group:insert(leftwall)
    group:insert(rightwall)
    group:insert(topwall)
    group:insert(paddle)
    group:insert(paddleblend)
    group:insert(scoretext)
    group:insert(highscoretext)
    group:insert(powertext)
    group:insert(pointtext)
    group:insert(lifetext)
    group:insert(leveltext)
    group:insert(ball)
    group:insert(Ballimg)
    group:insert(Ballimgblend)
    group:insert(modtext)
    group:insert(multitext)
    
    scoretext.text = math.floor(Score/2)
    highscoretext.text = "High : "..math.floor(Highscore/2)
    lifetext.text = "Lives "..Lives	
    
end	

local function redolevel()
    if youaredead==false then 
        PosEnemy(level)
        --physics.pause()
        timer.performWithDelay(1, function()
            for i=1,maxenemy do
                if enemypaddle[i].isalive==true then 
                    enemypaddle[i].number=i
                    enemypaddle[i].x=RandX[i]
                    enemypaddle[i].y=RandY[i]
                     if enemypaddle[i].special ~= "invisible" then 
                        enemypaddle[i].rotation = math.random(20)-10
                        rotation[i] = enemypaddle[i].rotation 
                    end 

                   -- enemypaddle[i].rotation=0
                    enemypaddle[i]:setLinearVelocity(0,0)
                  
                end	
            end 
        end)
    end 
end

local function resetenemy()
    if debugflag then print "resetenemy";end
    if youaredead==false then 
	PosEnemy()
	--print (maxenemy)
	for i = 1, maxenemy do
            if enemypaddle[i].isalive == true then 
                enemypaddle[i]:removeEventListener("collision", onEnemy)
                enemypaddle[i]:removeSelf()
                enemypaddle[i].isalive = false
                
                if enemypaddle[i].special ~= "unbreakable" then 
                    if enemypaddle[i].special ~= "invisible" then 
			enemypad[i]:removeSelf()
			enemypad[i].isalive = false
                    end
                end 
                
                
		
            end 
	end
	timer.performWithDelay(1,createenemy())
    end
end

function leveltxt(e)
    if debugflag then print "leveltxt";end
    leveltext.alpha=1
    leveltext.xScale=1
    leveltext.yScale=1
    leveltext:setFillColor(0,255,0)
    printscore()
    if leveltext.text=="Dead" then 
        transition.to(leveltext,{time=1000,alpha=0, xScale=6, yScale=5})
    else
        transition.to(leveltext,{time=700,alpha=0, xScale=3, yScale=3})
    end
end

function newlevel()
    if debugflag then print "newlevel";end
    
    colors.bluegreen 	= {{0,150,80}, 		{0,180,100}, 	{20,200,130}} 		-- 1
    colors.purple 		= {{140,50,170}, 	{150,40,180}, 	{170,50,190}}		-- 2
    colors.green 		= {{0,150,20}, 		{0,180,20}, 	{20,200,20}}		-- 3
    colors.orange		= {{240,110,0}, 	{250,130,0}, 	{225,120,10}}		-- 4
    colors.red 			= {{240,20,30}, 	{240,30,40}, 	{250,30,50}}		-- 5
    colors.yellow 		= {{200,200,20}, 	{200,210,30}, 	{220,230,30}}		-- 6
    colors.blue 		= {{60,60,210}, 	{65,65,210}, 	{50,50,210}}		-- 7
    colors.pink 		= {{240,120,130}, 	{240,130,140}, 	{250,130,150}}		-- 8
    colors.cyan 		= {{24, 205,205}, 	{30, 210,210}, 	{14, 195,195}} 		-- 9
    colors.seafoam		= {{104, 240,187}, 	{104, 240,187}, {104, 240,187}} 	-- 10
    colors.indigo 		= {{68, 39,195}, 	{68,39,195}, 	{68, 39,195}}		-- 11
    colors.lightblue 	= {{150, 150,234}, 	{150, 150,234}, {150, 160,234}} 	-- 12
    colors.unbreakable 	= {{255,255,255}, 	{255,255,255}, 	{255,255,255}} 		-- 13
    colors.invisible 	= {{255,255,255}, 	{255,255,255}, 	{255,255,255}} 		-- 14
    colors.white 		= {{200,200,200},	{200,200,200},	{200,200,200}} 		-- 15
    colors.black 		= {{30,10,20},		{20,10,20},		{20,10,30}}			-- 16
    colors.darkred 		= {{140,0,0},		{150,10,10},	{155,10,5}}			-- 17
    colors.key 			= {{200,200,100},	{200,200,100},	{200,200,100}}      -- 19
    
    g = nil
    print (level)
    if level == 1 then 
        g = graphics.newGradient({0,0,0}, {.4,0,.4}, "up")
        --pcolor=Particles.GetEmitter("BG")
        --Particles.StopEmitter("BG")
        --pcolor.colorStart = {100,0,250}
        --pcolor.x = 240
        --pcolor.y = 450
        
        --Particles.StartEmitter("BG")
    end
    
    if level == 2 then 
        g = graphics.newGradient({30,0,70}, {0,60,20}, "down")
        
    end 
    
    if level == 3 then 
        g = graphics.newGradient({0,100,30}, {0,0,0}, "down")
        
    end 
    
    if level == 4 then 
        g = graphics.newGradient({0,0,0}, {100,60,30}, "down")
        
    end 
    
    if level == 5 then 
        g = graphics.newGradient({100,60,30}, {120,40,120}, "down")
        
    end 
    
    if level == 6 then 
        g = graphics.newGradient({0,0,0}, {120,30,30}, "down")
        
    end 
    
    if level == 7 then 
        g = graphics.newGradient({120,30,30}, {50,30,150}, "down")
        
    end 
    
    if level == 8 then 
        g = graphics.newGradient({0,0,0}, {0,60,50}, "down")
    end 
    
    if level == 9 then 
        g = graphics.newGradient({0,30,40}, {20,130,130}, "down")
    end 
    
    if level == 10 then 
        g = graphics.newGradient({0,0,0}, {150,0,0}, "down")
    end 
    
    if level == 11 then 
        bgcolor={{101,70,117},{37,0,22},"down"}
    end
    
    if level == 13 then 
       -- print "setting"
        g=graphics.newGradient({10,10,67},{37,0,22},"down")
    end
    background:setFillColor (g)
    background.alpha = .2
    killpowerup()
end

local function resetball()
    if debugflag then print "resetball";end
    
    if youaredead == false then 
	if resetballflag==1 then 
            timer.performWithDelay(2,function ()
                ball.x, ball.y = paddle.x, paddle.y - 40
            end)
            
            resetballflag=0
            ball:setLinearVelocity (math.random(300)-150, -1000)
            
	end
    end
    
end

function endscene()
    if debugflag then print "endscene";end
    if LB then 
	LB:removeSelf()
	PB:removeSelf()
	LB=nil
	PB=nil
	barsvisible=0
    end 
    display.remove(paddle)
    storyboard.gotoScene("menu")
end

function returntomenu(e)
    if debugflag then print "returntomenu";end
    timer.performWithDelay(100,physics.pause())
    transition.to(group,{time=1000,alpha=0, onComplete=endscene})
end


function CreateMod()
    if paddle.key == 1 then 
        mt[8]=" Key"
    end 
    if paddle.key == 0 then 
        mt[8]=""
    end 
    
    if powerball == true then 
        mt[1]=" Power"
    end 
    if powerball == false then 
        mt[1]=""
    end 
    
    if wobbleflag == 1 then 
        mt[2]=" Rotate"
    end 
    if wobbleflag==  0 then 
        mt[2]=""
    end 
    if pilotflag == 1 then 
        mt[3]=" Auto"
    end 
    if pilotflag== 0 then 
        mt[3]=""
    end 
    if invisiflag == 1 then 
        mt[4]=" Invisi"
    end 
    if invisiflag==0  then 
        mt[4]=""
    end 
    if reverseflag == 1 then 
        mt[5]=" Reverse"
    end 
    if reverseflag==0  then 
        mt[5]=""
    end 
    if  gravflag == 1 then 
        mt[6]=" Newton"
    end 
    if gravflag==0  then 
        mt[6]=""
    end 
    if forcefieldflag == 1 then 
        mt[7]=" Force"
    end 
    if forcefieldflag==0  then 
        mt[7]=""
    end 
    if pause==1 then 
        for a = 1,8 do 
            mt[a]=""
        end 
        
        mt[20]=" Pause"
    end
    if pause==0 then 
        mt[20]=""
    end
    
    
    modtext.text = (mt[1]..mt[2]..mt[3]..mt[4]..mt[5]..mt[6]..mt[7]..mt[8]..mt[20])
   -- modtext:setReferencePoint(display.BottomRightReferencePoint)
    modtext.anchorX = 1
    modtext.anchorY = 1
    
    modtext.x = _W*.97
    modtext.y = _H*.99
    
end



function printscore()
    if debugflag then print "printscore";end
    
    if youaredead==false then
        scoretext.text = math.floor(Score/2)
        highscoretext.text = "H: "..math.floor(highscore/2)
	
        scoretext.anchorX = 0 
        scoretext.anchorY = 0 
            
        scoretext.x= _W*.03
        scoretext.y= _H*.01
	
       -- highscoretext:setReferencePoint (display.TopRightReferencePoint)
        highscoretext.anchorX = 1 
        highscoretext.anchorY = 0 
        highscoretext.x= _W*.97
        highscoretext.y= _H*.01
	
        lifetext.text = "Lives "..math.floor(Lives)
        lifetext.anchorX = 0 
        lifetext.anchorY = 1 

      --  lifetext:setReferencePoint (display.BottomLeftReferencePoint)
        lifetext.x= _W*.03
        lifetext.y= _H*.99

    end
end 

function killpowerup()
   -- print "attempting to remove powerup"
    
    if powerupexist == false then 
    --    print "no powerup active, cannot remove"
    end 
    
    if powerupexist==true then 
    --    print "removing powerup"
        powerupitem:removeSelf()
        powerupitemB:removeSelf()
    end 
    
   -- print "nilling powerup"
    powerupitem=nil
    powerupexist=false
    powerupflag = 0
    chance = nil
    
end 

function newlife()
    if debugflag then print "newlife";end
    Lives=Lives-1; 
    --transition.to(paddle, {time = 100, x=fingerX})
    stats.dead = stats.dead + 1
    leveltext.text="Dead"
    forcefieldflag=1
    wobbleflag=0
    paddleblend.rotation = 0 
    gravflag=0
    guns=false
    physics.setGravity (0, 9.8)
   -- print ("reset rotation, gravity")
    multitext.text = ""
    timer.performWithDelay(1,function()paddle.rotation=0;end)
    pilotflag=0
    leveltxt()
    reverseflag=0
    paddle:setFillColor(250,250,255)
    
    killpowerup()
    setCountersToZero()
    
    if bossisdead == false then 
        if bossexist then 
            timer.performWithDelay (1, Boss:removeSelf())
            if LB then 
                LB:removeSelf()
                PB:removeSelf()
                PB=nil
                LB=nil
                barsvisible=0
            end;
            bossexist=false
            if bomb==true then 
                bombitem:removeSelf()
                bomb = false
            end 
        end 
        
    end
    resetballflag=1
    resetball()
    timer.performWithDelay(1,redolevel())
    Boss.life=oldlife
    paddle.life=1000
    
    if powerball then 
        powerball=false
        
    end
    ballpower=LevelBallpower
    Ballimg:setFillColor(255,255,255)
    Ballimgblend:setFillColor(1,1,1)

    multiplier = 1
    
    
    --newlevel()
    
    if Lives < 1 then youaredead=true end
    
   -- SFX=audio.play(SFXdie)
    ball:applyForce(0,0)
    if Score > highscore then highscore=Score; end
    
    if youaredead then 
        stats.gameover = stats.gameover+1
        stats.score = Score/2
        files.writestats(filestats)
        files.savescore(highscore)

        level=1
        score=0
        
        printscore()
        
        Lives=5.5
        enemyRemaining=maxenemy
	    --display.remove(paddle)

        timer.performWithDelay(1, returntomenu())
    end 
    resetballflag=1
    physics.pause()
    movepaddleflag=1
end 	


function resetScore(e)
    
    if debugflag then print "resetScore";end
    if e.phase == "ended" then 
	if e.other.type == "you" then 
            newlife()
	end 
    end 
end

function placetext (e)
    if debugflag then print "placetext";end
    powertext.alpha=1
    powertext.xScale=1
    powertext.yScale=1
    powertext.x=RelX*50
    powertext.y=powerupitem.y
    powertext:setFillColor(0,255,0)
    transition.to(powertext,{time=1500,alpha=0, xScale=5, yScale=5, x=RelX*50})
end 

function giefpowerup()
    chance = math.random (14)
    if chance == 14 then chance = 13
    end 
    --chance = 4
    
    if chance==1 then --give points
        Score=Score+2000*multiplier
        powertext.text = 1000*multiplier.." points"
        printscore()
    end
    
    -- powerball and multipliers
    if chance==2 then 
        if not powerball then 
            stats.powerball=stats.powerball+1
            ballpower = LevelBallpower*2
            Ballimg:setFillColor(1,0,0)
            Ballimgblend:setFillColor(1,0,0)
            powerball=true
            powertext.text = "Powerball"
            
        else 
            multiplier = multiplier + 1
            if multiplier > 10 then multiplier = 10;end
            powertext.text = "Multiplier X"..multiplier
        end 
    end
    
    if chance ==3 then 
        stats.extralife = stats.extralife+1
        Lives=Lives+1
        lifetext.text = "Lives "..math.floor(Lives)
        powertext.text= "Extra Life"
        powertext.alpha=1
    end
    
    if chance == 4 then 
        if wobbleflag==1 then 
            multiplier = multiplier + 1
            if multiplier > 5 then multiplier = 5;end
            powertext.text = "Multiplier X"..multiplier
        end
        
        if wobbleflag==0 then 
            stats.rotate=stats.rotate+1
            wobbleflag=1
            powertext.text="Rotate"
            powertext.alpha=1
            
        end
    end
    
    if chance == 5 then 
        if gravflag==0 then 
            stats.newton=stats.newton+1
            gravflag=1
            powertext.text="Newton"
            powertext.alpha=1
            
        else
            gravflag=0
            powertext.text="Gravity"
            powertext.alpha=1
            paddle:setFillColor(250,250,255)
            physics.setGravity(0,9.8)
          --  print "gravity reset"
        end
    end
    
    if chance == 6 then 
        if pilotflag==0 then 
            stats.autopilot = stats.autopilot+1
            powertext.text="AutoPilot"
            pilotflag=1
            
        else
            Score=Score+2000*multiplier
            powertext.text = 1000*multiplier.." points"
            printscore()
        end
    end
    
    if chance == 7 then 
        if reverseflag==0 then 
            stats.reverse=stats.reverse+1
            powertext.text="Reverse"
            reverseflag=1
            
        else
            Score=Score+2000*multiplier
            powertext.text = 1000*multiplier.." points"
            printscore()
        end
    end
    
    if chance == 8 then 
        multiplier = multiplier + 1
        if multiplier > 10 then multiplier = 10;end
        powertext.text = "Multiplier X"..multiplier
    end
    
    if chance == 9 then
        if multiplier> 5 then  
            multiplier = 1
            powertext.text = "Multi Reset"
        else
            multiplier = multiplier + 1
            if multiplier > 10 then multiplier = 10;end
            powertext.text = "Multiplier X"..multiplier
        end
    end
    
    if chance == 10 then 
        if forcefieldflag==0 then 
            stats.forcefield=stats.forcefield+1
            forcefieldflag=1
            powertext.text= "Force Field"
            
        else 
            Score=Score+2000*multiplier
            powertext.text = 1000*multiplier.." points"	
            printscore()
        end
    end
    
    if chance == 11 then 
        if invisiflag==0 then 
            stats.invisiball = stats.invisiball + 1
            invisiflag=1
            powertext.text = "InvisiBall"
            ball.alpha=0
            
        else 
            multiplier = multiplier + 1
            if multiplier > 10 then multiplier = 10;end
            powertext.text = "Multiplier X"..multiplier
        end
    end
            function normalpaddle()
                physics.removeBody(paddle)
                display.remove(paddle)
                paddle = display.newImage ("paddle.png",RelX*38,RelY*85)
                paddle:setFillColor(255,255,255)
                paddle.type="paddle"
                paddle.alpha = 1
                paddle.life = 1000
                paddle.xScale = 1
                paddle.x = tempX
                paddletype = 1
                physics.addBody(paddle,     "kinematic",    {density = 1.0, friction = 0.1, bounce = 1.001, isSensor = false})
                paddle:addEventListener("collision", onpaddleCollision)
                group:insert(paddle)

            end 
        

    if chance == 12 then 
        print (guns)
        if paddletype ~= 2 then 
        
                function bigpaddle()
                physics.removeBody(paddle)
                display.remove(paddle)
                paddle = display.newImage ("paddlebig.png",RelX*38,RelY*85)
                paddle:setFillColor(255,255,255)
                paddle.type="paddle"
                paddle.alpha = 1
                paddle.life = 1000
                paddle.xScale = 1
                paddle.x = tempX
                physics.addBody(paddle,     "kinematic",    {density = 1.0, friction = 0.1, bounce = 1.001, isSensor = false})
                paddle:addEventListener("collision", onpaddleCollision)
                group:insert(paddle)

            end 
                tempX = paddle.x
                if paddletype == 1 then 
                    transition.to(paddle, {time = 9, xScale = 2})
                end 
                if paddletype == 0 then 
                    transition.to(paddle, {time = 9, xScale = 3})
                end 
                paddletype = 2
                timer.performWithDelay(10, bigpaddle, 1)



            powertext.text = "Biiig!"
        else
                tempX = paddle.x
                
                if paddletype == 0 then 
                    transition.to(paddle, {time = 9, xScale = .25})
                end 
                if paddletype == 1 then 
                    transition.to(paddle, {time = 9, xScale = .5})
                end 
                paddletype = 1
                timer.performWithDelay(10, normalpaddle, 1)
                powertext.text = "Normal"
            
        end 	
    end

        if chance == 13 then 
        print (guns)
        if paddletype ~= 0 then 
        

                function smallpaddle()
                physics.removeBody(paddle)
                display.remove(paddle)
                paddle = display.newImage ("paddlesmall.png",RelX*38,RelY*85)
                paddle:setFillColor(255,255,255)
                paddle.type="paddle"
                paddle.alpha = 1
                paddle.life = 1000
                paddle.xScale = 1
                paddle.x = tempX
                physics.addBody(paddle,     "kinematic",    {density = 1.0, friction = 0.1, bounce = 1.001, isSensor = false})
                paddle:addEventListener("collision", onpaddleCollision)
                group:insert(paddle)
            end 
                tempX = paddle.x
                if paddletype == 1 then 
                    transition.to(paddle, {time = 9, xScale = .5})
                end 
                if paddletype == 2 then 
                    transition.to(paddle, {time = 9, xScale = .25})
                end 
                
                paddletype = 0
                timer.performWithDelay(10, smallpaddle, 1)



            powertext.text = "Tiny!"
        else
                tempX = paddle.x
                if paddletype == 1 then 
                    transition.to(paddle, {time = 9, xScale = 2})
                end 
                if paddletype == 2 then 
                    transition.to(paddle, {time = 9, xScale = 3})
                end 
                paddletype = 1 


                timer.performWithDelay(10, normalpaddle, 1)
                powertext.text = "Normal"

            powertext.text= "Normal"
            
        end     
    end


    
    if chance == 16 then 
        if explosive == false then 
            explosive = true 
            powertext.text = "Bada-boom"
        end 
    end 
    
    if multiplier>1 then multitext.text = ("X"..multiplier);end
    if multiplier<2 then multitext.text = "";end
    placetext()
    print ("chance "..chance)
end 


function onPowerupcollision(event)
    if debugflag then print "onPowerupcollision";end
    
    if event.other.type=="die" then 
        stats.poweruplost = stats.poweruplost + 1
        killpowerup()
    end
    
    if event.other.type == "you" then 
        if powerball==true then 
            stats.powerupcaught = stats.powerupcaught+1
            giefpowerup()
            killpowerup()
        end
    end 
    
    if event.other.type == "paddle" then 
        stats.powerupcaught = stats.powerupcaught+1
        giefpowerup()
        killpowerup()
        
        
        
    end
end

function PosEnemy(lvl)

    local info = lev.get(lvl)
    print "YO!"
    for k,v in pairs(info) do
        print(k,v)
    end

    xpos = info.xpos
    ypos = info.ypos
    brickcolor = info.brickcolor
    LevelBallpower = info.LevelBallpower
    maxBallSpeed= info.maxBallSpeed
        
    if debugflag then print "PosEnemy";end

    maxenemy = #xpos
    
    for nE = 1, maxenemy do
        RandX[nE] = RelX * xpos[nE]
        RandY[nE] = RelY * ypos[nE] 
    end 
    
    --if powerupexist== true then 
    --  powerupitem:removeSelf()
    --  powerupitem=nil
    --  powerupexist=false
    --  powerupitemB:removeSelf()
    --end
    ballpower = LevelBallpower
end




function onTouch(event)
    
    if debugflag then print "ontouch";end
    if event.phase=="began" then 
        if pause == 1 then 
            transition.to (followline, {time=200,alpha=0})
            physics.start()
            movepaddleflag=0
            
            
            if freeze == 1 then 
               -- Particles.WakeUp()
                freeze=0
            end 
            
            
            print "waking up"
            pause = 0 
            
        end
        touchflag=1
	
    end
end 
function onEnemy(e)
    
    if e.other.name=="bullet" then 
        if e.target.special == "normal" or e.target.special == "half" then 
            e.target.energy=e.target.energy - 20 
            Score=Score+30*(multiplier)
            pointtext.x=e.target.x
            pointtext.y=e.target.y
            pointtext.text=30*multiplier
            scoretextFX()
            
            printscore()
           -- local Emitter = Particles.GetEmitter("E1")
          --  Emitter.x 	 = e.target.x
          --  Emitter.y 	 = e.target.y
          --  Particles.StartEmitter("E1",true)
          --  timer.performWithDelay(10,stopParticles)
            
            print (e.target.energy)
            
            if e.target.bodyType == "static" then
                e.target.bodyType = "dynamic" 
                transition.to(e.target, {time = 400, alpha=1})
                identifier = e.target.number
                transition.to(enemypad[identifier], {time = 300, alpha=1})
            end
            
            if e.target.energy < 1 then 
                if e.target.isalive == true then 
                    stats.kill = stats.kill + 1
                    eventposX=e.target.x
                    eventposY=e.target.y
                    e.target.isalive = false
                    e.target:removeSelf()   
                    e.target.energy=-1
                    enemyRemaining=enemyRemaining -1
                    
                    Score=Score+1000*(multiplier*2)
                    
                    pointtext.x=e.target.x
                    pointtext.y=e.target.y
                    pointtext.text=1000*multiplier
                    scoretextFX()
                    printscore()
                end 
            end 
            e.other.alpha = 0
        end 
    end 	
    
    if debugflag then print "onEnemy";end
    hitflag=1
    t=e.target
end

function scoretextFX(e)
    if debugflag then print "scoretextFX";end
    tmpy = pointtext.y
    pointtext.alpha=1
    pointtext.xScale=1
    pointtext.yScale=1
    pointtext:setFillColor(0,255,0)
    transition.to(pointtext,{time=500,alpha=0, xScale=3, yScale=3, y=tmpy-100})
end

function createpowerup()
    if debugflag then print "createpowerup";end
    
    powerupitem=display.newImage("powerup.png",0,0)
    powerupitem.xScale=.7
    powerupitem.yScale=.7
    powerupitemB=display.newImage("Ballmask2.png", 0, 0)
    powerupitemB.blendMode="add"
    powerupitemB.alpha=.3
    powerupitemB.xScale=1.2
    powerupitemB.yScale=1.2
    
    powerupitem.x = eventposX
    powerupitem.y = eventposY
    powerupitemB.x = eventposX
    powerupitemB.y = eventposY
    
    powerupitem.type="powerup"
    
    physics.addBody(powerupitem, "dynamic", {density = 0.5, friction = 0.1, bounce = 1, isSensor = false})
    powerupitem:addEventListener("collision", onPowerupcollision)
    group:insert(powerupitem)
    group:insert(powerupitemB)
end

function createpowerup2()
    if debugflag then print "createpowerup2";end
    if not powerupexist then 
        powerupexist=true
        powerupitem=display.newRect(0,0,20,20)
        powerupitem.x = math.random(RelX*70)+RelX*15
        powerupitem.y = RelY*13
        physics.addBody(powerupitem, "dynamic", {density = 1.0, friction = 0.1, bounce = 1, isSensor = false})
        powerupitem.type="powerup"
        powerupitem:addEventListener("collision", onPowerupcollision)
        powerupitem:setFillColor(0,255,0)
        group:insert(powerupitem)
    end
end

local function powerup()
    if debugflag then print "powerup";end
    local chance=math.random(10)
    --print ("chance "..chance)
    if chance>4 then powerupflag=1 
        print ("powerup "..powerupflag)
        
    end
end

function throwbomb ()
    if debugflag then print "throwbomb";end
    hand = math.random(2)
    if bossisdead==false then 
	if youaredead == false then 
            if bomb == false then 
		bomb = true
		bombitem=display.newRect(0,0,20,20)
		bombitem.alpha=0
		if hand == 1 then 
                    bombitem.x = Boss.x + (RelX*15) 
                    bombitem.y = Bossbody.y + (RelY * 3)
		end 
                
		if hand == 2 then 
                    bombitem.x = Boss.x + (RelX*88) 
                    bombitem.y = Bossbody.y + (RelY * 3)
                    
		end 	
		physics.addBody(bombitem, "dynamic", {density = 1.0, friction = 0.1, bounce = 1, isSensor = false})
		bombitem :applyTorque(math.random(100)-50)
		bombitem.type="bomb"
		bombitem:addEventListener("collision", onBombcollision)
		bombitem:setFillColor(255,255,0)
		group:insert(bombitem) 
            end
	end
    end
end 

function resetLinearVelocity(event)
    if debugflag then print "resetLinearVelocity";end
    if youaredead==false then  
        if hitflag==1 then hitflag=0 end
        local thisX, thisY = ball:getLinearVelocity()
        if thisY == 0 then
            thisY = -ball.lastY
        end
        if thisX == 0 then
            thisX = -ball.lastX
        end
        ball:setLinearVelocity(thisX, thisY)
        ball.lastX, ball.lastY = thisX, thisY
    end
    resetball()
    
end
function stopParticles(e)
    if debugflag then print "stopParticles";end
    if playparticles == true then
	--Particles.StopEmitter("E1")
    end
end

function onCollision(event)
    
    function fadebackball()
        transition.to(Ballimgblend, {time=10, alpha=.5})
        --	print "blink"
    end
    
    transition.to(Ballimgblend, {time=50, alpha=1, onComplete=fadebackball})
    
    if debugflag then print "onCollision";end
    if ball then 
        timer.performWithDelay(1, resetLinearVelocity)
    end
    
    --SFX = audio.play (SFXding)
    
    
    
    if event.other.type == "boss" then 
        if enemyRemaining<1 then 
            timer.performWithDelay(30,throwbomb)
        end 
        
        if enemyRemaining<1 then 
            Boss.life = Boss.life - (ballpower/10)
        end
        --print (Boss.life)
        
        if Boss.life<0 then 
            bossisdead=true
            bossexist=false
            timer.performWithDelay (1, function() 
                stats.kill = stats.kill + 1
                
                if PB then 
                    PB:removeSelf()
                    LB:removeSelf()
                    PB=nil
                    LB=nil
                    barsvisible=0
                end 
                Boss:removeSelf() 
            end) 
        end
    end
    
    
    if event.other.special == "invisible" then 
        Score = Score + 1
        pointtext.x=event.other.x
        pointtext.y=event.other.y
        pointtext.text=1
        scoretextFX()
        printscore()
        if event.other.direction == "up" then 
            identifier = event.other.number
            vx, vy = ball:getLinearVelocity()
            --print (vy)
            if event.phase == "ended" then 
                
                if vy > 0 then 
                    ball:setLinearVelocity(vx,vy)
                end
                
                if vy < 0 then 
                    ball:setLinearVelocity(vx,vy-800)	
                    if scaling ~= true then 
                        scaling=true 
                            transition.to(enemypaddle[event.other.number], {time = 50, xScale=1.5,yScale=.8, onComplete = function () 
                                transition.to(enemypaddle[event.other.number], {time = 200, xScale=1, yScale=1})
                                scaling = false
                        end})
                    end 
                end 
		noscale=0
            end
        end 
        
        if event.other.direction == "down" then 
            identifier = event.other.number
            vx, vy = ball:getLinearVelocity()
            --print (vy)
            
            if event.phase == "ended" then 
                
                if vy < 0 then 
                    ball:setLinearVelocity(vx,vy)
                end
                
                if vy > 0 then 
                    ball:setLinearVelocity(vx,vy+800)	
                    if scaling ~= true then 
                        scaling=true 
                            transition.to(enemypaddle[event.other.number], {time = 50, xScale=1.5,yScale=.8, onComplete = function () 
                                transition.to(enemypaddle[event.other.number], {time = 200, xScale=1, yScale=1})
                                scaling = false
                        end})
                    end 
                end 
		noscale=0
            end 
        end 
        
        if event.other.direction == "left" then 
            identifier = event.other.number
            vx, vy = ball:getLinearVelocity()
            --print (vy)
            
            if event.phase == "ended" then 
                
                ball:setLinearVelocity(vx-400,vy-800)	
                if scaling ~= true then 
                    scaling=true 
                        transition.to(enemypaddle[event.other.number], {time = 50, xScale=1.5,yScale=.8, onComplete = function () 
                            transition.to(enemypaddle[event.other.number], {time = 200, xScale=1, yScale=1})
                            scaling = false
                    end})
                end 
                
		noscale=0
            end 
        end 
	
        if event.other.direction == "right" then 
            identifier = event.other.number
            vx, vy = ball:getLinearVelocity()
            --print (vy)
            
            if event.phase == "ended" then 
                
                ball:setLinearVelocity(vx+400,vy-800)	
                if scaling ~= true then 
                    scaling=true 
                        transition.to(enemypaddle[event.other.number], {time = 50, xScale=1.5,yScale=.8, onComplete = function () 
                            transition.to(enemypaddle[event.other.number], {time = 200, xScale=1, yScale=1})
                            scaling = false
                    end})
                end 
                
		noscale=0
            end 
        end 
        
        
        
    end 
    
    
    
    
    if event.other.special == "unbreakable" then 
        if event.other.direction=="keyhole" then 
            if paddle.key==1 then 
                paddle.key=0
                leveltext.text="Lock Open"
                leveltxt()
                event.other.isalive = false
                event.other:removeSelf() 
            end 
        end 
    end 
    
    if event.other.special=="key" then 
        paddle.key=1
        leveltext.text="Got A Key"
        leveltxt()
        event.other.isalive = false
        event.other:removeSelf() 
        enemyRemaining=enemyRemaining -1
    end 
    
    if event.other.type== "enemy" then 
        if event.other.special ~= "unbreakable" then 
            if event.other.special ~= "invisible" then 
                if powerball == true then
                    if event.other.isalive == true then 
                        stats.kill = stats.kill + 1
                        eventposX=event.other.x
                        eventposY=event.other.y
                        
                        event.other.isalive = false
                        event.other:removeSelf()   
                        event.other.energy=-1
                        enemyRemaining=enemyRemaining -1
                        Score=Score+900*(multiplier*2)+(combo*20)*(multiplier*2)
                        powerup()
                        pointtext.x=event.other.x
                        pointtext.y=event.other.y
                        pointtext.text=1000*multiplier+(combo*10)
                        scoretextFX()
                        printscore()
                    end 
                end
            end
        end
    end
    
    
    if event.other.type == "enemy" then 
        if event.other.isalive == true then 
            if event.other.bodyType == "static" then 
                timer.performWithDelay(1, function () 
                    if event.other.isalive == true then 
                        if event.other.special ~= "unbreakable" then 
                            if event.other.special ~= "invisible" then 
                                event.other.bodyType="dynamic"
                                transition.to(event.other, {time = 400, alpha=1})
                                identifier = event.other.number
                                transition.to(enemypad[identifier], {time = 300, alpha=1})
                            end 
                        end 
                    end
                end)
            end
        end
        
        if event.other.special ~= "unbreakable"  then 
            

            if event.other.special ~= "invisible"  then 
          		Score=Score+ 100*multiplier
        	 	pointtext.x=event.other.x
  		        pointtext.y=event.other.y
  		        pointtext.text=100*multiplier
  		        scoretextFX()
  		        printscore()
            end 
        end 
        
        if event.phase == "ended" then 
            
            if event.other.special ~= "unbreakable" then 
                if event.other.special ~= "invisible" then 
                    event.other.energy = event.other.energy - ballpower
                end 
            end 
            --color = event.other.energy
            --event.other:setStrokeColor(128,color/2,color/2)
            --event.other.alpha=(1/255*(color))+.2
            --print ("alpha "..1/255*(color))
                if event.other.energy < 1 then timer.performWithDelay (1, function() 
                    if event.other.isalive == true then 
                        stats.kill = stats.kill + 1
                        eventposX=event.other.x
                        eventposY=event.other.y
                        event.other.isalive = false
                        event.other:removeSelf() 
                        
                    end
                end) 
                
                powerup()
               -- SFX = audio.play (SFXboom)
                combo = combo + 1; print ("combo "..combo )
                enemyRemaining=enemyRemaining -1
                --print ("enemy "..enemyRemaining)
                Score=Score+900*(multiplier*2)+(combo*20)*(multiplier*2)
                pointtext.x=event.other.x
                pointtext.y=event.other.y
                pointtext.text=1000*multiplier+(combo*10)
                scoretextFX()
                printscore()
            end
	end
        
	
    end
    
    if enemyRemaining<1 then
        
        

        for i = 1, maxenemy do
            if enemypaddle[i].isalive == true then 
                enemypaddle[i]:removeEventListener("collision", onEnemy)
                enemypaddle[i].isalive = false
                enemypaddle[i]:removeSelf()
                
                
                if enemypad[i].isalive == true then 
                    enemypad[i]:removeSelf()
                    enemypad[i].isalive = false
                    
                end 
            end 
        end
        
        if bossisdead==true then 
            enemyRemaining=maxenemy
            print ("1244")
            level=level+1
            
            killpowerup()
            
            
            
            
            newlevel()
            leveltext.text="Level "..level
            leveltxt()
            --resetenemy()
            setCountersToZero()
            timer.performWithDelay(1,function()
                createenemy()
                resetballflag=1
                resetball()
                physics.pause()
                if freeze == 0 then 
                  --  Particles.Freeze()
                    freeze=1
                end 
                --pause = 1
                movepaddleflag=1
               -- print "setting newlevelflag to 1"
                newlevelflag = 1
            end)
        end 
        
    end
end


function onpaddleCollision(e)
    function fadeback()
        transition.to(paddleblend, {time = 50, alpha = .5})
    end
    
    if e.other.type == "you" then 
        combo = -1
        print ("combo reset "..combo )
        forcechange = paddleblend.x - e.other.x
        if forcechange > 8 or forcechange < -8 then 
            timer.performWithDelay(1, function()
                
                if hit == false then e.other:applyForce(-forcechange*6,0)
                    hit = true
                    timer.performWithDelay(1,function() 
                        hit = false 
                        end)
                end 
            end)
        end 
    end 
    
    if debugflag then print "onpaddleCollision";end
    transition.to(paddleblend, {time = 50, alpha = 1, onComplete = fadeback})
    resetenemyflag=1
end

function setCountersToZero()
    forcefieldN,gravT,gravN,reverseN,al,pilotN,wob=0,0,0,0,0,0,0
end 


function movepaddle(event)
    fingerX=event.x
   -- print ("newlevelflag"..newlevelflag)
    if event.phase == "ended" then 
        physics.pause()
        transition.to (followline, {time=200,alpha=.6})
        if youaredead == false then 
            if freeze == 0 then 
            --    Particles.Freeze()
                freeze=1
            end 
            
        end 
        print "freeze"
        pause = 1
	
    end 
    
    
    
    
    
    if debugflag then print "movepaddle";end
    if firsttouch==false then 
        
        forcefieldflag=1
        leveltext.text= "Level 1"
        leveltxt()
        firsttouch=true
    end
    
    if movepaddleflag==1 then 
        ball.x=paddle.x
        --ball.y=paddle.y-RelY*10
    end 
    
    if newlevelflag==1 then 
        ball.x=paddle.x
        --ball.y=paddle.y-RelY*10
    end 
    
    if pilotflag==0 then 
        if reverseflag==0 then 
            
            if pause == 0 then 
                paddle.x=event.x
            end 
            
            if paddle.x> RelX*90 then paddle.x=RelX*90;end
            if  paddle.x<RelX*10 then paddle.x=RelX*10;end
        end
    end
    
    if reverseflag==1 then 
        paddle.x = RelX*100-event.x
        if paddle.x> RelX*90 then paddle.x=RelX*90;end
        if paddle.x<RelX*10 then paddle.x=RelX*10;end
    end
    
    
    if event.phase=="ended" then 
        touchflag=0		
        newlevelflag=0
    end
    
end

function makeboss()
    if debugflag then print "makeboss";end
    
    
    bosslifebar = display.newRect (0, RelY*10, RelX*30,RelY*1)
    bosslifebar:setFillColor (255,30,30)
    bosslifebar2 = display.newRect (0, RelY*10, RelX*30,RelY*1)
    bosslifebar2:setFillColor (30,255,30)
  --  bosslifebar2:setReferencePoint (display.CenterLeftReferencePoint)
    LB = display.newGroup()
    LB:insert(bosslifebar)
    LB:insert(bosslifebar2)
    
    
    paddlelifebar = display.newRect (0,RelY*93, RelX*25,RelY*1)
    paddlelifebar:setFillColor (255,30,30)
    paddlelifebar2 = display.newRect (0,RelY*93, RelX*25,RelY*1)
    paddlelifebar2:setFillColor (30,255,30)
--    paddlelifebar2:setReferencePoint (display.CenterLeftReferencePoint)
    PB = display.newGroup()
    PB:insert(paddlelifebar)
    PB:insert(paddlelifebar2)
    group:insert (LB)
    group:insert (PB)
    
    
    Boss = display.newGroup()
    Bosseyes = display.newGroup()
    
    Bossbody = display.newRoundedRect (RelX*25, RelY*18, RelX*50,RelY*20, 20)
    Bossbody:setStrokeColor(180,180,180)
    Bossbody.strokeWidth=10
    
    Bossarm1 = display.newRoundedRect (RelX*13, RelY*25, RelX*10,RelY*3, 5)
    Bossarm2 = display.newRoundedRect (RelX*77, RelY*25, RelX*10,RelY*3, 5)
--    Bossarm1:setReferencePoint (display.CenterRightReferencePoint)
--    Bossarm2:setReferencePoint (display.CenterLeftReferencePoint)
    
    Bosseye1 = display.newRect (RelX* 35,RelY*25,30,10)
    Bosseye2 = display.newRect (RelX* 50,RelY*25,30,10)
    
    Bossmouth = display.newRect (RelX*37, RelY*32, RelX*25,RelY*2)
    
    Bosseye1:setFillColor (255,0,0)
    Bosseye2:setFillColor (255,0,0)
    Bossmouth:setFillColor (255,0,0)
    Bossarm1:setFillColor (180,180,180)
    Bossarm2:setFillColor (180,180,180)
    Bosseyes:insert(Bosseye1)
    Bosseyes:insert(Bosseye2)
    
    timer.performWithDelay(10,function()
	physics.addBody(Bossbody, "kinematic", {density = 1.0, friction = 0.1, bounce = 0.25, isSensor = false})
	physics.addBody(Bossarm1, "kinematic", {density = 1.0, friction = 0.1, bounce = 0.45, isSensor = false})
	physics.addBody(Bossarm2, "kinematic", {density = 1.0, friction = 0.1, bounce = 0.45, isSensor = false})
    end)
    Bossbody.type="boss"
    Boss:insert(Bossbody)
    Boss:insert(Bossarm1)
    Boss:insert(Bossarm2)
    Boss:insert(Bosseyes)
    Boss:insert(Bossmouth)
    Boss.life=oldlife
    
    --group:insert(Boss)
    
    bossexist = true 
end




local function bendenemy(e)
    if debugflag then print "bendenemy";end
    if hitflag==1 then
        
        --	randomPos(level)
        --	t.rotation = math.random(360)
	
	--SFX=audio.play("SFXding")
        hitflag=0
    end
end

function wobble()
    if youaredead==false then 
	if pause == 0 then 
            wob=wob+3
	end 
	if wob>360 then 
            wobbleflag=0
            wob=0
	end
	paddle.rotation = wob
    paddleblend.rotation = wob
	paddle:setFillColor(100,200,100)
	if wobbleflag==0 then 
            if youaredead==false then 
            paddle:setFillColor(250,250,255);end
            
	end
    end
end

function pilottimer()
    if pause == 0 then 
	print (fingerX)
	pilotN=pilotN + 1
	if pilotN == 300 then leveltext.text = "Auto Disengage"; leveltxt();end
	
    end 
    paddle:setFillColor(100,200,100) 
    
    if transflag==0 then 
        xposball=ball.x
        if xposball> RelX*85 then xposball=RelX*85;end
        if  xposball<RelX*15 then xposball=RelX*15;end
        
        transflag=1
        transition.to (paddle, {x=xposball, time = 100, onComplete= function () transflag=0; end})
        
    end 
    
    if pilotN>400 then 
        paddle:addEventListener ("touch", onTouch)
        
            transition.to(paddle, {time = 100, x=fingerX, onComplete = function ()
		pilotN=0
		pilotflag=0
		paddle:setFillColor(250,250,255)
        end })
    end
end

function invisibleball()
    if pause == 0 then 
	time = time + 1
    end 
    al=al+.1 
    if al>360 then al = 0;end 
    
    Ballimg.alpha = (math.sin(al)+1)/2
    Ballimgblend.alpha = ((math.sin(al)+1)/2)/2
    
    if time > 400 then 
        Ballimg.alpha=1
        Ballimgblend.alpha=.5
        time = 0
        invisiflag=0
        
    end 
end

function reversetimer()
    if pause == 0 then 
	reverseN=reverseN + 1
    end 
    paddle:setFillColor(100,200,100) 
    if reverseN == 300 then leveltext.text = "Reverse Disengage"; leveltxt();end
    
    if reverseN>400 then 
            transition.to(paddle, {time = 100, x=fingerX, onComplete = function ()
                
		reverseN=0
		reverseflag=0
		paddle:setFillColor(250,250,255)
        end })
    end
end

function grav()
    
    if youaredead == false then 
        if pause == 0 then 
            gravN=gravN+1
        end 
	paddle:setFillColor(100,200,100)
	
	if gravN>60 then 
            physics.setGravity(math.random(20)-10, -10)
            print "gravity fucked"
            gravT=gravT+1
            gravN=0
	end
	
	if gravN==59 then 
            if gravT == 4 then leveltext.text = "Grav 3"; leveltxt();end
            if gravT == 5 then leveltext.text = "Grav 2"; leveltxt();end
            if gravT == 6 then leveltext.text = "Grav 1"; leveltxt();end
            if gravT == 7 then leveltext.text = "Grav 0"; leveltxt();end
	end 
        
        
	if gravT > 7 then 
            paddle:setFillColor(250,250,255)
            gravT=0
            gravN=0
            physics.setGravity(0,9.8)
            print "gravity reset"
            gravflag=0
            
	end
    end
end

function forcefield()
    
    if makefield==false then 
        
        
        forcegroup=display.newGroup()
        field=display.newRect (RelX*3,RelY*98,RelX*94,RelY*5.2)
        field.x = _W * .5
        fieldblend = display.newImage("Ballmask.png",RelX*50,RelY*98)
        
        fieldblend.xScale = 15
        fieldblend.yScale = 3
        fieldblend.blendMode="add"
        field:setFillColor(1,0,1)
        fieldblend:setFillColor(1,0,1)
        field.alpha=0
        fieldblend.alpha=.7
        forcegroup:insert(field)
        forcegroup:insert(fieldblend)
        forcegroup.type ="force"
        group:insert(forcegroup)
        physics.addBody(field, "static", {density = 1.0, friction = 0.1, bounce = 1.01, isSensor = false})
        field.type ="force"
        --field.special ="invisible"
        makefield=true
--        if playparticles == true then 
--            local Emitter = Particles.GetEmitter("E2")
--            Particles.StartEmitter("E2",true)
--            Emitter.x 	 = field.x
--            Emitter.y 	 = field.y-RelY*1
       -- end	
        lifetext:toFront()
        
        
    end
    
    if pause == 0 then 
	forcefieldN=forcefieldN+1
    end 
    
    
    if forcefieldN == 500 then leveltext.text = "Force Disengage"; leveltxt();end
    
    fieldblend.yScale = (math.sin (forcefieldN)+3)*.5
    if forcefieldN> 600 then 
        
        forcegroup:removeSelf()
        if playparticles == true then
 --           Particles.StopEmitter("E2")
        end
        makefield = false
        forcefieldN=0
        forcefieldflag=0
        
    end
    
end

function fireguns()

end 

function explodingball()
    if explosive == true then 
        explosive = false
    end
end 

function onBombcollision(event)
    if debugflag then print "onBombcollision";end
--[[-if event.other.type=="die" then 
		--stats.poweruplost = stats.poweruplost + 1
		bombitem:removeEventListener("collision", onBombcollision)
		bombitem:removeSelf()
		bomb=false
	end
    ]]if event.other.type=="paddle" then 
        --stats.poweruplost = stats.poweruplost + 1
        bombitem:removeEventListener("collision", onBombcollision)
        bombitem:removeSelf()
        bomb=false
    end
    
    if event.other.type=="die" then 
        --stats.poweruplost = stats.poweruplost + 1
        paddle.life = paddle.life - (math.random(100)+200)
        if paddle.life<1 then 
            paddle.life=1000
            newlife()
        end
        
        --print ("liv "..paddle.life)
        bombitem:removeEventListener("collision", onBombcollision)
        bombitem:removeSelf()
        bomb=false
    end
    
end



function moveboss()
    if debugflag then print "moveboss";end
    if pause == 0 then 
	btime= btime + .04;
    end 
    if btime > 360 then btime = 1;end
    Boss.x = math.sin ( btime ) * 50 
    Boss.y = math.sin ( btime * 2) * 10 
    --Bossarm1.x = math.sin ( btime ) * 50 
    --Bossarm1.y = math.sin ( btime * 2) * 10 
    --Bossarm2.x = math.sin ( btime ) * 50 
    --Bossarm2.y = math.sin ( btime * 2) * 10 
    if enemyRemaining<1 then 
        Bossbody:setFillColor(240,200,200) 
        Bossbody:setStrokeColor(200,180,180)
    end 
    
    Bossarm2.rotation = math.sin(btime*3)*15
    Bossarm1.rotation = math.sin((btime+180)*3)*15
    Bossbody.rotation = math.cos(btime)*6
    Bosseyes.x = (math.sin(btime)*20)+RelX*3
    
    throw=math.random(500)
    
    if youaredead==false then 
	if enemyRemaining<1 then 
            if throw > 498 then throwbomb(); end
	end
	if throw < 2 then createpowerup2();end
        
	if bossexist then 
            bosslifebar2.xScale = Boss.life/2500
	end 
	
	if LB then 
            LB.x = Boss.x + RelX*35
            PB.x = paddle.x - RelX*12.8
            paddlelifebar2.xScale= paddle.life/1000
	end 
    end 
end

function adjustvelocity()
    if debugflag then print "adjustvelocity";end
    if youaredead == false then 
	if ball.y > RelY*70 then 	
            
            
            
            if vy<0 then 
                if vy<-100 then 
                    vy=vy-300
                    ball:setLinearVelocity(vx,vy)
                end
            end
            
	end
    end
end

function setold()
    if debugflag then print "setold";end
    if oldvy == vy then vydifference=0;end
    
    if oldvy>vy then 
	vydifference = oldvy - vy 
    end
    
    if oldvy<vy then 
	vydifference = vy - oldvy 
    end
    
    if vydifference == nil then vydifference=0; end
    --print ((vy.." "..oldvy.." "..vydifference))	
    
    oldvx, oldvy = vx, vy
    
end

function dancingbricks()
    dance=dance+.1; if dance > 360 then dance = 0;end
    --print (maxenemy)
    
    
    for xx = 1, maxenemy do 
        
        if enemypaddle[xx].isalive == true then 
            if enemypaddle[xx].bodyType=="static" then 
                if enemypaddle[xx].special ~= "unbreakable" then
                    if enemypaddle[xx].special ~= "invisible" then
                        
                        enemypaddle[xx].xScale = 1+(math.sin(dance))*.02
                        enemypaddle[xx].yScale = 1+(math.cos(dance))*.02
                        enemypaddle[xx].rotation=rotation[xx] + (math.cos(dance+(xx*5))*3)
                    end
                end 
            end
        end
    end
    
end

function velocityclamp()
    if youaredead==false then 
        vx, vy = ball:getLinearVelocity()
        
        if vy<-maxBallSpeed.y then vy=-maxBallSpeed.y;end
        if vy>maxBallSpeed.y then vy=maxBallSpeed.y;end
        if vx > maxBallSpeed.x then vx=maxBallSpeed.x-100;end
        if vx < -maxBallSpeed.x then vx=-maxBallSpeed.x+100;end
        ball:setLinearVelocity(vx,vy)
        
        if vx > 0 then 
            if vx < 40 then vx=150
                ball:setLinearVelocity(vx,vy)
            end
        end		
        
        if vx < 0 then  
            if vx > -40 then vx=-150
                ball:setLinearVelocity(vx,vy)
            end
        end		
        
        for z=1, maxenemy do
            if enemypaddle[z].isalive == true then 
                ex,ey = enemypaddle[z]:getLinearVelocity()
                --print (ex,ey)
                if ex > maxenemyspeed.x then ex = maxenemyspeed.x 	; print "limited x" ;end
                if ex < -maxenemyspeed.x then ex = -maxenemyspeed.x ; print "limited -x" ;end
                if ey > maxenemyspeed.x then ey = maxenemyspeed.x 	; print "limited y" ;end
                if ey < -maxenemyspeed.x then ey = -maxenemyspeed.x ; print "limited -y" ;end
                
                enemypaddle[z]:setLinearVelocity(ex,ey)
                
            end 
        end
    end
end

function bombstuff ()
    if bomb==true then 
	if youaredead==false then 
            if playparticles == true then
            --    local Emitter = Particles.GetEmitter("BOMB")
            --    Emitter.x 	 = bombitem.x
            --    Emitter.y 	 = bombitem.y
            end
            --print (Emitter.x, Emitter.y)
            if bombparticle==false then 
		if playparticles == true then
             --       print ("start")
             --       Particles.StartEmitter("BOMB", true)
                    bombparticle=true
		end 
            end
        end
    end
    
    if bomb == false then 
	if bombparticle == true then 
            if playparticles == true then
             --   Particles.StopEmitter("BOMB")
            end
            bombparticle = false
            --Emitter=nil
	end
    end
end

function MotionBlur(e)
    if debugflag then print "main";end
    CreateMod()
    
    z=e
    .source
    if youaredead == false then 
        if bosslevel == true then 
            oldlife=Boss.life
        end
    end 
    --print (bosslevel)
    
    velocityclamp()
    
    bombstuff()
    
    --print ("NLF "..newlevelflag)
    
    for i = 1, maxenemy do 
	if enemypaddle[i].isalive ~= true then
            if enemypad[i].isalive == true then 
                enemypad[i]:removeSelf() 
                enemypad[i].isalive = false 
            end 
	end 
        
	if enemypad[i].isalive == true then 
            if enemypaddle[i].isalive == true then 
                enemypad[i].x = enemypaddle[i].x
                enemypad[i].y = enemypaddle[i].y
                enemypad[i].rotation = enemypaddle[i].rotation
                enemypad[i].xScale= enemypaddle[i].xScale+1.7
                enemypad[i].yScale= enemypaddle[i].yScale+1
                
            end
	end 
    end 
    
    paddleblend.x = paddle.x
    paddleblend.y = paddle.y
    
    Ballimg.x=ball.x
    Ballimg.y=ball.y
    Ballimgblend.x=ball.x
    Ballimgblend.y=ball.y
    
    if powerupitem ~= nil then 
        powerupitemB.x = powerupitem.x
        powerupitemB.y = powerupitem.y
    end 
    
    
    followline.x = ball.x
    followline.y = ball.y
 --   followline:setReferencePoint (display.TopCenterReferencePoint)
     followline.anchorX = 0
     followline.anchorY = 0 
    

    ballspeedx, ballspeedy = ball:getLinearVelocity()
    
    velocityangle = (math.atan2(ballspeedx, -ballspeedy) / math.pi) * 180
    
    followline.rotation = velocityangle - 180
    
    
    if bossisdead==false then moveboss();end
    
    if firsttouch then 
	if startedPhysics == false then 
            physics.start()
            startedPhysics=true
	end
    end
    
    if youaredead==false then 
        
        
        if invisiflag==1 then invisibleball();end
        
	if not powerupexist then 
            if powerupflag==1 then 
                powerupexist=true
                timer.performWithDelay(1,createpowerup)
                powerupflag=0
            end 
	end
	
	--forcefieldflag=1
	explodingball()
	fireguns()
	if forcefieldflag==1 then forcefield();end
	if pilotflag==1 then pilottimer();end
	if reverseflag==1 then reversetimer();end
	if wobbleflag==1 then wobble();end
	if gravflag==1 then grav();end
	--bendenemy()
	--printscore()
        
	
        dancingbricks()
        
    end
end

function initenemy()
    for i = 1, 200 do 
        enemypaddle[i] = {}
        enemypad[i] = {}
        enemypaddle[i].isalive = false
        enemypad[i].isalive = false
    end
end

function createenemy()
    if debugflag then print "createenemy";end
    physics.pause()
    if youaredead==false then 	
        print ("level "..level)
        PosEnemy(level)
        if bosslevel == true then 
            makeboss() 
        end
        
        if bomb == true then 
            bombitem:removeEventListener("collision", onBombcollision)
            if playparticles == true then
             --   Particles.StopEmitter("BOMB")
            end 
            bombitem:removeSelf()
            bomb=false
            bombparticle=false
        end
        
        timer.performWithDelay(1, function ()
            
            unbreak = 0 
            
            for i = 1, 200 do 
                if enemypaddle[i].isalive == true then 
                    enemypaddle[i]:removeSelf()
                    print ("removing paddles")
                end
                
                if enemypad[i].isalive == true then 
                    enemypad[i]:removeSelf()
                    print ("removing glow")
                end 
            end 
            
            for i = 1, maxenemy do 
                col=math.random(3)
                
                enemypaddle[i] = display.newImage("brick.png",0,0)
                enemypaddle[i].isalive = true
                
                if brickcolor[i]==1 then 
                    EnemyColors[col] = colors.bluegreen[col]
                    enemypaddle[i].special = "normal"
                end 
                
                if brickcolor[i]==2 then 
                    EnemyColors[col] = colors.purple[col]
                    enemypaddle[i].special = "normal"
                end 
                
                if brickcolor[i]==3 then 
                    EnemyColors[col] = colors.green[col]
                    enemypaddle[i].special = "normal"
                end 
                
                if brickcolor[i]==4 then 
                    EnemyColors[col] = colors.orange[col]
                    enemypaddle[i].special = "normal"
                end 
                
                if brickcolor[i]==5 then 
                    EnemyColors[col] = colors.red[col]
                    enemypaddle[i].special = "normal"
                end 
                
                if brickcolor[i]==6 then 
                    EnemyColors[col] = colors.yellow[col]
                    enemypaddle[i].special = "normal"
                end 
                
                if brickcolor[i]==7 then 
                    EnemyColors[col] = colors.blue[col]
                    enemypaddle[i].special = "normal"
                end 
                
                if brickcolor[i]==8 then 
                    EnemyColors[col] = colors.pink[col] 
                    enemypaddle[i].special = "normal"
                end 
                
                if brickcolor[i]==9 then 
                    EnemyColors[col] = colors.cyan[col]
                    enemypaddle[i].special = "normal"
                end 
                
                if brickcolor[i]==10 then 
                    EnemyColors[col] = colors.seafoam[col]
                    enemypaddle[i].special = "normal"
                end 
                
                if brickcolor[i]==11 then 
                    EnemyColors[col] = colors.indigo[col]
                    enemypaddle[i].special = "normal"
                end 
                
                if brickcolor[i]==12 then 
                    EnemyColors[col] = colors.lightblue[col]
                    enemypaddle[i].special = "normal"
                end 
                
                if brickcolor[i]==13 then 
                    EnemyColors[col] = colors.unbreakable[col]
                    enemypaddle[i]:removeSelf()
                    enemypaddle[i]= nil
                    enemypaddle[i] = display.newImage("bricklocked.png",0,0)
                    enemypaddle[i].isalive = true
                    enemypaddle[i].special = "unbreakable"
                    enemypaddle[i].direction = "normal"
                    
                end 
                
                if brickcolor[i]==14 then 
                    EnemyColors[col] = colors.invisible[col]
                    enemypaddle[i]:removeSelf()
                    enemypaddle[i]= nil
                    enemypaddle[i] = display.newImage("brickUP.png",0,0)
                    enemypaddle[i].isalive = true
                    enemypaddle[i].special = "invisible"
                    enemypaddle[i].direction = "up"
                end 
                
                if brickcolor[i]==15 then 
                    EnemyColors[col] = colors.white[col]
                    enemypaddle[i].special = "normal"
                end 
                
                if brickcolor[i]==16 then 
                    EnemyColors[col] = colors.black[col]
                    enemypaddle[i].special = "normal"
                end 
                
                if brickcolor[i]==17 then 
                    EnemyColors[col] = colors.darkred[col]
                    enemypaddle[i].special = "normal"
                end 
                
                if brickcolor[i]==18 then 
                    EnemyColors[col] = colors.invisible[col]
                    enemypaddle[i]:removeSelf()
                    enemypaddle[i]= nil
                    enemypaddle[i] = display.newImage("brickDOWN.png",0,0)
                    enemypaddle[i].isalive = true
                    enemypaddle[i].special = "invisible"
                    enemypaddle[i].direction = "down"
                    
                end 
                
                if brickcolor[i]==19 then 
                    EnemyColors[col] = colors.invisible[col]
                    enemypaddle[i]:removeSelf()
                    enemypaddle[i]= nil
                    enemypaddle[i] = display.newImage("key.png",0,0)
                    enemypaddle[i].isalive = true
                    enemypaddle[i].special = "key"
                    
                    
                end 
                
                if brickcolor[i]==20 then 
                    EnemyColors[col] = colors.invisible[col]
                    enemypaddle[i]:removeSelf()
                    enemypaddle[i]= nil
                    enemypaddle[i] = display.newImage("brickkey.png",0,0)
                    enemypaddle[i].isalive = true
                    enemypaddle[i].special = "unbreakable"
                    enemypaddle[i].direction = "keyhole"
                end 
                
                if brickcolor[i]==21 then 
                    EnemyColors[col] = colors.unbreakable[col]
                    enemypaddle[i]:removeSelf()
                    enemypaddle[i]= nil
                    enemypaddle[i] = display.newImage("bricklocked2.png",0,0)
                  --  enemypaddle[i]:setReferencePoint(display.CenterReferencePoint)
                    enemypaddle[i].isalive = true
                    enemypaddle[i].special = "unbreakable"
                    enemypaddle[i].direction = "normal"
                end 
                
                
                if brickcolor[i]==22 then 
                    EnemyColors[col] = colors.invisible[col]
                    enemypaddle[i]:removeSelf()
                    enemypaddle[i]= nil
                    enemypaddle[i] = display.newImage("brickkeylong.png",0,0)
                    enemypaddle[i].isalive = true
                    enemypaddle[i].special = "unbreakable"
                    enemypaddle[i].direction = "keyhole"
                end 
                
                
                if brickcolor[i]==23 then 
                    EnemyColors[col] = colors.invisible[col]
                    enemypaddle[i]:removeSelf()
                    enemypaddle[i]= nil
                    enemypaddle[i] = display.newImage("bounceright.png",0,0)
                 --   enemypaddle[i]:setReferencePoint(display.CenterReferencePoint)
                    enemypaddle[i].isalive = true
                    enemypaddle[i].special = "invisible"
                    enemypaddle[i].direction = "right"
                end 
                
                if brickcolor[i]==24 then 
                    EnemyColors[col] = colors.invisible[col]
                    enemypaddle[i]:removeSelf()
                    enemypaddle[i]= nil
                    enemypaddle[i] = display.newImage("bounceleft.png",0,0)
                 --   enemypaddle[i]:setReferencePoint(display.CenterReferencePoint)
                    enemypaddle[i].isalive = true
                    enemypaddle[i].special = "invisible"
                    enemypaddle[i].direction = "left"
                end 
                
                
                if brickcolor[i]==51 then 
                    enemypaddle[i]:removeSelf()
                    enemypaddle[i]= nil
                    enemypaddle[i] = display.newImage("brickhalf.png",0,0)
                 --   enemypaddle[i]:setReferencePoint(display.CenterReferencePoint)
                    enemypaddle[i].isalive = true
                    EnemyColors[col] = colors.bluegreen[col]
                    enemypaddle[i].special = "half"
                    
                end 
                
                if brickcolor[i]==52 then 
                    enemypaddle[i]:removeSelf()
                    enemypaddle[i]= nil
                    enemypaddle[i] = display.newImage("brickhalf.png",0,0)
                 --   enemypaddle[i]:setReferencePoint(display.CenterReferencePoint)
                    enemypaddle[i].isalive = true
                    EnemyColors[col] = colors.purple[col]
                    enemypaddle[i].special = "half"
                end 
                
                if brickcolor[i]==53 then 
                    enemypaddle[i]:removeSelf()
                    enemypaddle[i]= nil
                    enemypaddle[i] = display.newImage("brickhalf.png",0,0)
                 --   enemypaddle[i]:setReferencePoint(display.CenterReferencePoint)
                    enemypaddle[i].isalive = true
                    EnemyColors[col] = colors.green[col]
                    enemypaddle[i].special = "half"
                end 
                
                if brickcolor[i]==54 then 
                    enemypaddle[i]:removeSelf()
                    enemypaddle[i]= nil
                    enemypaddle[i] = display.newImage("brickhalf.png",0,0)
                 --   enemypaddle[i]:setReferencePoint(display.CenterReferencePoint)
                    enemypaddle[i].isalive = true
                    EnemyColors[col] = colors.orange[col]
                    enemypaddle[i].special = "half"
                end 
                
                if brickcolor[i]==55 then 
                    enemypaddle[i]:removeSelf()
                    enemypaddle[i]= nil
                    enemypaddle[i] = display.newImage("brickhalf.png",0,0)
                 --   enemypaddle[i]:setReferencePoint(display.CenterReferencePoint)
                    enemypaddle[i].isalive = true
                    EnemyColors[col] = colors.red[col]
                    enemypaddle[i].special = "half"
                end 
                
                if brickcolor[i]==56 then 
                    enemypaddle[i]:removeSelf()
                    enemypaddle[i]= nil
                    enemypaddle[i] = display.newImage("brickhalf.png",0,0)
                 --   enemypaddle[i]:setReferencePoint(display.CenterReferencePoint)
                    enemypaddle[i].isalive = true
                    EnemyColors[col] = colors.yellow[col]
                    enemypaddle[i].special = "half"
                end 
                
                if brickcolor[i]==57 then 
                    enemypaddle[i]:removeSelf()
                    enemypaddle[i]= nil
                    enemypaddle[i] = display.newImage("brickhalf.png",0,0)
                --    enemypaddle[i]:setReferencePoint(display.CenterReferencePoint)
                    enemypaddle[i].isalive = true
                    EnemyColors[col] = colors.blue[col]
                    enemypaddle[i].special = "half"
                end 
                
                if brickcolor[i]==58 then 
                    enemypaddle[i]:removeSelf()
                    enemypaddle[i]= nil
                    enemypaddle[i] = display.newImage("brickhalf.png",0,0)
                --    enemypaddle[i]:setReferencePoint(display.CenterReferencePoint)
                    enemypaddle[i].isalive = true
                    EnemyColors[col] = colors.pink[col] 
                    enemypaddle[i].special = "half"
                end 
                
                if brickcolor[i]==59 then 
                    enemypaddle[i]:removeSelf()
                    enemypaddle[i]= nil
                    enemypaddle[i] = display.newImage("brickhalf.png",0,0)
                --    enemypaddle[i]:setReferencePoint(display.CenterReferencePoint)
                    enemypaddle[i].isalive = true
                    EnemyColors[col] = colors.cyan[col]
                    enemypaddle[i].special = "half"
                end 
                
                if brickcolor[i]==60 then 
                    enemypaddle[i]:removeSelf()
                    enemypaddle[i]= nil
                    enemypaddle[i] = display.newImage("brickhalf.png",0,0)
                --    enemypaddle[i]:setReferencePoint(display.CenterReferencePoint)
                    enemypaddle[i].isalive = true
                    EnemyColors[col] = colors.seafoam[col]
                    enemypaddle[i].special = "half"
                end 
                
                if brickcolor[i]==61 then 
                    enemypaddle[i]:removeSelf()
                    enemypaddle[i]= nil
                    enemypaddle[i] = display.newImage("brickhalf.png",0,0)
                --    enemypaddle[i]:setReferencePoint(display.CenterReferencePoint)
                    enemypaddle[i].isalive = true
                    EnemyColors[col] = colors.indigo[col]
                    enemypaddle[i].special = "half"
                end 
                
                if brickcolor[i]==62 then 
                    enemypaddle[i]:removeSelf()
                    enemypaddle[i]= nil
                    enemypaddle[i] = display.newImage("brickhalf.png",0,0)
                --    enemypaddle[i]:setReferencePoint(display.CenterReferencePoint)
                    enemypaddle[i].isalive = true
                    EnemyColors[col] = colors.lightblue[col]
                    enemypaddle[i].special = "half"
                end 
                
                if brickcolor[i]==65 then 
                    enemypaddle[i]:removeSelf()
                    enemypaddle[i]= nil
                    enemypaddle[i] = display.newImage("brickhalf.png",0,0)
                --    enemypaddle[i]:setReferencePoint(display.CenterReferencePoint)
                    enemypaddle[i].isalive = true
                    EnemyColors[col] = colors.white[col]
                    enemypaddle[i].special = "half"
                end 
                
                if brickcolor[i]==66 then 
                    enemypaddle[i]:removeSelf()
                    enemypaddle[i]= nil
                    enemypaddle[i] = display.newImage("brickhalf.png",0,0)
                 --   enemypaddle[i]:setReferencePoint(display.CenterReferencePoint)
                    enemypaddle[i].isalive = true
                    EnemyColors[col] = colors.black[col]
                    enemypaddle[i].special = "half"
                end 
                
                if brickcolor[i]==67 then 
                    enemypaddle[i]:removeSelf()
                    enemypaddle[i]= nil
                    enemypaddle[i] = display.newImage("brickhalf.png",0,0)
                 --   enemypaddle[i]:setReferencePoint(display.CenterReferencePoint)
                    enemypaddle[i].isalive = true
                    EnemyColors[col] = colors.darkred[col]
                    enemypaddle[i].special = "half"
                end 
                
                function toRGB(value)
                    local R
                    local G
                    local B
                    local r,g,b

                    R,G,B = unpack(value)
                    r = R/255
                    g = G/255
                    b = B/255

                    return r,g,b
                end


                col1,col2,col3 = toRGB(EnemyColors[col])
                print ("COLORRR "..col1,col2,col3) 
                
                enemypaddle[i]:setFillColor(col1,col2,col3)
                
                if enemypaddle[i].special == "unbreakable" then 
                    unbreak = unbreak + 1
                end 
                
                if enemypaddle[i].special == "invisible" then 
                    unbreak = unbreak + 1
                end 
                
                if enemypaddle[i].special ~= "unbreakable" then 
                    --if enemypaddle[i].special ~= "invisible" then 
                    enemypad[i] = display.newImage("Ballmask.png",0,0)
                    enemypad[i].isalive = true 
                    enemypad[i]:setFillColor(col1,col2,col3)
                    if enemypaddle[i].special ~= "half" then 
                        enemypad[i].xScale=3.1
                    end 
                    enemypad[i].yScale=1.1
                    enemypad[i].alpha=.2
                    enemypad[i].blendMode = "add"
                    --end
                end 
                
                if enemypaddle[i].special ~= "invisible" then 
                    enemypaddle[i].alpha = 1
                end 
                
                if enemypaddle[i].special == "invisible" then 
                    enemypaddle[i].alpha = 1
                    enemypad[i].alpha = .2
                end 
                
                if enemypaddle[i].special == "key" then 
                    enemypaddle[i].alpha = 1
                    enemypad[i].alpha = .2
                end 				
                
                if enemypaddle[i].special ~= "invisible" then 
                    physics.addBody(enemypaddle[i], "static", {density = 1, friction = 0, bounce = 1, isSensor = false})
                end 
                
                if enemypaddle[i].special == "invisible" then 
                    physics.addBody(enemypaddle[i], "static", {density = 1, friction = 0, bounce = 1, isSensor = false})
                end 
                
                enemypaddle[i]:addEventListener("collision", onEnemy)
                enemypaddle[i].type = "enemy"
                
                
                enemypaddle[i].energy=255
                
                if enemypaddle[i].special == "key" then 
                    enemypaddle[i].energy=10
                end 
                
                if enemypaddle[i].special == "half" then 
                    enemypaddle[i].energy = 1
                end 
                
                if enemypaddle[i].special == "unbreakable" then 
                    enemypaddle[i].energy=1000
                end 
                
                if enemypaddle[i].special == "invisible" then 
                    enemypaddle[i].energy=300
                end 
            end
            
            
            for i=1,maxenemy do
                enemypaddle[i].number=i
                enemypaddle[i].x=RandX[i]
                enemypaddle[i].y=RandY[i]
                
                if enemypaddle[i].special ~= "invisible" then 
                    enemypaddle[i].rotation = math.random(20)-10
                    rotation[i] = enemypaddle[i].rotation 
                    
                end 
                
                group:insert(enemypaddle[i])
                if enemypaddle[i].special ~= "unbreakable"  then 
                    --if enemypaddle[i].special ~= "invisible" then 
                    group:insert(enemypad[i])
                    --end 
                end 
            end 
            enemyRemaining=maxenemy-unbreak
            
            print ("remaining "..enemyRemaining.." unbreakable "..unbreak)
        end)
	physics.start()
    end 
end 

function goPhysics()
    if debugflag then print "goPhysics";end
    leveltext.text= "Touch"
    leveltxt()
    physics.setGravity(0, 9.8)
    print "gravity reset"
end

function fadein()
    if debugflag then print "fadein";end
    physics.pause()
    transition.to(group,{time=2000,alpha=1, onComplete=goPhysics})
end

function scene:createScene(event)
    if debugflag then print "createScene";end
    group = self.view
end

function scene:enterScene(event)
    if debugflag then print "enterScene";end
    group = self.view
    fontname ="Arcade"
    fontname2 ="Strenuous"
    
    physics.start()
    
    
    init()
    initenemy()
    oldlife=2500
    loadHighscore()
    makeobjects()

    
    printscore()
    ball.x, ball.y = paddle.x, paddle.y - 40
    newlevel()
    
    createenemy()

    vx, vy = ball:getLinearVelocity()
    group.alpha=0
    fadein()
    
    timer.performWithDelay(1000,adjustvelocity,0)
    Runtime:addEventListener("enterFrame",MotionBlur)
 
    
    ball:addEventListener("collision", onCollision)
    paddleblend:addEventListener ("touch", onTouch)
    paddle:addEventListener("collision", onpaddleCollision)
    Runtime:addEventListener ("touch", movepaddle)
    bottomwall:addEventListener("collision", resetScore)
end

function scene:exitScene (event)
    if debugflag then print "exitScene";end
    group=self.view
    Runtime:removeEventListener ("enterFrame", MotionBlur)
    ball:removeEventListener("collision", onCollision)
    paddle:removeEventListener ("touch", onTouch)
    paddle:removeEventListener("collision", onpaddleCollision)
    Runtime:removeEventListener ("touch", movepaddle)
    bottomwall:removeEventListener("collision", resetScore)
    
    print ("pause "..pause)	
    if pause == 1 then 
        pause = 0
        if freeze == 1 then 
           -- Particles.WakeUp()
            freeze=0
        end 
        
        
        
        print "waking up"
    end 
    
    if bomb == true then 
        bombitem:removeEventListener("collision", onBombcollision)
        if playparticles == true then
         --   Particles.StopEmitter("BOMB")
        end 
        bomb=false
        bombparticle=false
    end
    powerupexist 	= false
    enemypaddle 	= nil
    level			= nil
    ballpower 		= nil
    youaredead		= nil
    Startenemy 		= nil
    gravflag		= nil
    multiplier 		= nil
    Lives 			= nil
    --Score 			= nil
    movepaddleflag	=	0
    paddletype = 1
    maxenemy 		= nil
    enemyRemaining	= nil
    wob 			= nil
    wobbleflag		= nil
    gravT 			= nil
    gravN 			= nil
    pilotN 			= nil
    pilotflag 		= nil
    reverseflag 	= nil
    reverseN 		= nil
    forcefieldflag 	= nil
    forcefieldN		= nil 
    makefield		= nil
    if playparticles == true then
     --   Particles.StopAutoUpdate()
    end 
    Emitter=nil
    if playparticles == true then
      --  Particles.CleanUp()
    end 
    highscoretext=nil
    
    if bossisdead==false then 
        if bossexist==true then 
            Boss:removeSelf()
	end 
    end
    
    
   -- timer.cancel(z)
    
    local sceneName = storyboard.getCurrentSceneName()
    timer.performWithDelay(10, function() 
        storyboard.removeScene(sceneName)
    end)
end


function scene:destroyScene(event)
    if debugflag then print "destroyscene";end
    
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener("exitScene",scene)
scene:addEventListener("destroyScene",scene)

return scene
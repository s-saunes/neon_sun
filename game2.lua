local storyboard 	= require "storyboard"
local scene 		= storyboard.newScene()
local Particles 	= require("lib_particle_candy")
local physics 		= require("physics")
local group

---------------------------------------------------------------------------
---------------- Loading and Saving ---------------------------------------
---------------------------------------------------------------------------

function loadHighscore() 
    local path = system.pathForFile( "save.txt", system.DocumentsDirectory )
    local file = io.open( path, "r" )
    if file == nil then Highscore = 0; end
    if file ~=nil then 
        for line in file:lines() do
            Highscore=tonumber(line)
        end
        io.close( file )
    end 
   	local path = system.pathForFile( "options.txt", system.DocumentsDirectory )
    local file = io.open( path, "r" )
    if file == nil then options=false; end
    l=0
    if file~=nil then 
        options = true 
        for line in file:lines() do
            l=l+1
            optionvalues[l]=tonumber(line)
           -- print (tonumber(line))
        end
        io.close( file )
    end
    
    if optionvalues[1]==1 then playsounds=true;		end
    if optionvalues[1]==0 then playsounds=false;	end
    if optionvalues[2]==1 then playmusic=true;		end
    if optionvalues[2]==0 then playmusic=false;		end
    if optionvalues[3]==1 then playparticles=true;	end
    if optionvalues[3]==0 then playparticles=false;	end
    
end

function readstats()
    if debugflag then print "readstats";end
    l=0
    local path = system.pathForFile( "stats.txt", system.DocumentsDirectory )
    local file = io.open( path, "r" )
    if file == nil then 
        for l=0, 13 do
            filestats[l]=0
        end
        maxline = 14
    end
    if file~=nil then 
        for line in file:lines() do
            
            filestats[l] = tonumber(line)
            l=l+1
        end
        maxline=l	
        io.close( file )
    end 
end

function writestats()
    if debugflag then print "writestats";end
    
    l=0
    local path = system.pathForFile( "stats.txt", system.DocumentsDirectory )
    fh = io.open( path, "w" )
    for k,v in pairs( stats ) do 
        fh:write( v+filestats[l], "\n" )
        l=l+1
    end
    io.close( fh ) 
    
end

-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------

function init()
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
    
    readstats()
    
    -- init lists
    
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
    
    level				= 2
    
    barsvisible			= 1
    youaredead			= false
    noscale				= 0 
    gravflag			= 0
    multiplier 			= 1
    Lives 				= 5
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
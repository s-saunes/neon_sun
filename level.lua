local lev = {}
local json = require ("json")
local tenf = require ("tenfLib")

function lev.write(taable,name)
	tenf.jsonSave(name,taable)
	print "saved"
end        

function lev.load(name)
	local info = tenf.jsonLoad("levels/"..name,system.ResourceDirectory)
	print "loaded"
	return info 
end 


function lev.get(lvl)
   local info = {}
  	info.maxBallSpeed = {}
    print (lvl)
	info = lev.load("level"..lvl)
    return info
end     
    




return lev
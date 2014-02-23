local lev = {}
local json = require ("json")
local tenf = require ("tenfLib")

function lev.write(taable,name)
	tenf.jsonSave(name,taable)
	print "saved"
end        

function lev.load(name)

	if name < 10 then 
		print "lessthan10"
		newname = "00"..name
	end 

	if name > 9 and name < 100 then 
		print "lessthan100"
		newname = "0"..name
	end 

	if name > 100 then 
		print "morethan100"
		newname = name
	end 

	local info = tenf.jsonLoad("levels/"..newname,system.ResourceDirectory)
	print "loaded"
	return info 
end 


function lev.get(lvl)
   local info = {}
  	info.maxBallSpeed = {}
    print (lvl)
	info = lev.load(lvl)
    return info
end     
    




return lev
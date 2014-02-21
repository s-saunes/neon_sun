local files = {}

function files.loadscore()
	local path = system.pathForFile( "save.txt", system.DocumentsDirectory )
    local file = io.open( path, "r" )
    local Highscore

	if file == nil then Highscore = 0; end
    
    	if file ~=nil then 
       		for line in file:lines() do
            	Highscore=tonumber(line)
        	end
        io.close( file )
    end 
    
    return Highscore
end 

function files.savescore(highscore)
	local saveData = highscore
        local path = system.pathForFile( "save.txt", system.DocumentsDirectory )
        local file = io.open( path, "w" )
        
        file:write( saveData )
        io.close( file )
        file = nil		
end 



function files.loadoptions()

    local path = system.pathForFile( "options.txt", system.DocumentsDirectory )
    local file = io.open( path, "r" )
    local options 
    local optionvalues={}
    if file == nil then options=false; end
    local l=0
    
    if file~=nil then 
        options = true 
        for line in file:lines() do
            l=l+1
            optionvalues[l]=tonumber(line)
        end
        io.close( file )
    end
   return optionvalues
end

function files.writestats(filestats)
    
    local l=0
    local path = system.pathForFile( "stats.txt", system.DocumentsDirectory )
    local fh = io.open( path, "w" )
    for k,v in pairs( stats ) do 
        fh:write( v+filestats[l], "\n" )
        l=l+1
    end
    io.close( fh ) 
end



-- loading the statistics from file 
function files.readstats()
 
    local l=0
    local path = system.pathForFile( "stats.txt", system.DocumentsDirectory )
    local file = io.open( path, "r" )
    local filestats = {}

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
    return filestats

end 


return files


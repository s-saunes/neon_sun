local lfs = require "lfs"
local num = 0 

local fileListList = {}

-- get raw path to app's Temporary directory
local doc_path = system.pathForFile( "", system.DocumentsDirectory )

-- change current working directory
local success = lfs.chdir( doc_path ) -- returns true on success
local new_folder_path

if success then
    lfs.mkdir( "DLC" )
    new_folder_path = lfs.currentdir() .. "/DLC"
end


for file in lfs.dir(new_folder_path) do
    if file ~= "." then
        if file ~= ".." then 
            if file ~= ".DS_Store" then 
                num = num + 1
                fileList[num] = file
                print( "Found file: " .. file )
            end
        end
    end
  
end
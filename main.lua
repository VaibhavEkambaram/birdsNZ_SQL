-----------------------------------------------------------------------------------------
-- Vaibhav Ekambaram: New Zealand Birds App
-- main.lua -- Set up the app
-----------------------------------------------------------------------------------------
-- Required Libraries
-----------------------------------------------------------------------------------------
-- Include the widget library: used for buttons, and other UI elements
local widget = require "widget"
-- Require the composer library: used for scenes and transitions
local composer = require "composer"
-- Require the sql lite database: used for menu and bird database
require "sqlite3"
-----------------------------------------------------------------------------------------
-- SQL Database 
-- Copies database into app file directory if not already there
-- Otherwise reads from the database
-----------------------------------------------------------------------------------------
function copyFile( srcName, srcPath, dstName, dstPath, overwrite )
	local function doesFileExist( fname, path )
		local results = false
		-- File path
		local filePath = system.pathForFile( fname, path )
		if ( filePath ) then
			local file, errorString = io.open( filePath, "r" )
			if not file then
				print( "File not found: " .. errorString )
			else
				-- File is present
				print( "File found: " .. fname )
				results = true
				file:close()
			end
		end
		return results
	end
    local results = false
    local fileExists = doesFileExist( srcName, srcPath )
    if ( fileExists == false ) then
        return nil  -- nil = Source file not found
    end
    -- Check to see if destination file already exists
    if not ( overwrite ) then
        if ( fileLib.doesFileExist( dstName, dstPath ) ) then
            return 1  -- 1 = File already exists (don't overwrite)
        end
    end
    -- Copy the source file to the destination file
    local rFilePath = system.pathForFile( srcName, srcPath )
    local wFilePath = system.pathForFile( dstName, dstPath )
    local rfh = io.open( rFilePath, "rb" )
    local wfh, errorString = io.open( wFilePath, "wb" )
    if not ( wfh ) then
        -- Error occurred; output the cause
        print( "File error: " .. errorString )
        return false
    else
        -- Read the file and write to the destination directory
        local data = rfh:read( "*a" )
        if not ( data ) then
            print( "Read error!" )
            return false
        else
            if not ( wfh:write( data ) ) then
                print( "Write error!" )
                return false
            end
        end
    end
    results = 2  -- 2 = File copied successfully!
    -- Close file handles
    rfh:close()
    wfh:close()
    return results
end
copyFile( "data.db", nil, "data.db", system.DocumentsDirectory, true )
local path = system.pathForFile("data.db", system.DocumentsDirectory)
db = sqlite3.open( path )

-----------------------------------------------------------------------------------------
-- Corona Setup Parameters
-----------------------------------------------------------------------------------------
-- Set the status bar colour (Apple iOS only)
display.setStatusBar( display.DarkStatusBar ) 
display.setDefault("background",1,1,1,1)
-----------------------------------------------------------------------------------------
composer.gotoScene( "scenes.alphabetic" )
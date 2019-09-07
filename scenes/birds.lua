-----------------------------------------------------------------------------------------------------------------------
-- Vaibhav Ekambaram: New Zealand Birds Application
-- Birds.lua -- handles bird categorical view and search functionality
-----------------------------------------------------------------------------------------------------------------------
-- Required Libraries
-----------------------------------------------------------------------------------------------------------------------
-- Include the widget library: used for buttons, and other UI elements
local widget = require "widget"
-- Require the composer library: used for scenes and transitions
local composer = require "composer"
-----------------------------------------------------------------------------------------------------------------------
-- Corona Setup Parameters
-----------------------------------------------------------------------------------------------------------------------
-- Set application background colour (to light green)
-----------------------------------------------------------------------------------------------------------------------
-- Variables and Constants
-----------------------------------------------------------------------------------------------------------------------
-- Full width of screen
local fullWidth = display.contentWidth
-- Full height of screen
local fullHeight = display.contentHeight
-- X midpoint of screen
local midpointX = display.contentCenterX
-- Y midpoint of screen
local midpointY = display.contentCenterY
-----------------------------------------------------------------------------------------------------------------------
local scene = composer.newScene() 
function scene:create( event )
	local sceneGroup = self.view
-----------------------------------------------------------------------------------------------------------------------
	-- Parameters from previous scene	
-----------------------------------------------------------------------------------------------------------------------	
	local id = event.params.id
	local weight = event.params.weight
	local cat = event.params.cat
	local searchIsTrue = event.params.search
	local searchItem = event.params.searchItem
-----------------------------------------------------------------------------------------------------------------------
	-- Application Top Bar
-----------------------------------------------------------------------------------------------------------------------		
	-- top bar background
	-- Create a new rectangle
	local topBar = display.newRect((fullWidth*0.5),(fullHeight*0.0449),(fullWidth*1.036),(fullHeight*0.0899)) 
	topBar:setFillColor(1,1,1,1) -- Set the colour to white
	topBar.anchorX = 0.5 -- Set the x anchor point to the centre of the rectangle
	sceneGroup:insert(topBar) -- insert the object into the scene group
-----------------------------------------------------------------------------------------------------------------------	
	-- Create text function
-----------------------------------------------------------------------------------------------------------------------	
	-- As two very similar text objects are created, this process is made more efficient by using a function
	-- The parameters of the function are called with the specific values required for the two objects
-----------------------------------------------------------------------------------------------------------------------	
	-- Create a function with the following parameters:
		-- * objectName: the name that will be assigned to the object
		-- * text: the content of the text itself (eg. "Hello World")
		-- * xPosition -- the x co-ordinate location for the object
		-- * yPosition -- the y co-ordinate locaiton for the object
		-- * font -- font used for the text
		-- * fontSize -- size of the text displayed
-----------------------------------------------------------------------------------------------------------------------		
	local function createText(objectName,text,xPosition,yPosition,font,fontSize)
		local objectName = display.newText(text,xPosition,yPosition,font,fontSize)
		objectName:setFillColor(0,0,0,1) -- Set the colour of the text to black
		sceneGroup:insert(objectName) -- insert the object into the scene group
	end
-----------------------------------------------------------------------------------------------------------------------
	-- Search Validator 
	-- This checks to see if the birds lua is being used to display a search query, or whether it is originating
	-- from the taxonomic or weight lua. 
-----------------------------------------------------------------------------------------------------------------------
	-- Find the name of the previous scene
	local prevScene = composer.getSceneName( "previous" )
	-- If the search value is true then
	if searchIsTrue then
		-- Draw text saying search results - this is used as the heading of the scene
		createText(title,"Search Results", midpointX,(midpointY*0.11),native.systemFontBold, 32 )

		-- Draw the heading bar rectangle
		local headingBar = display.newRect((fullWidth*0.5),(fullHeight*0.1124),(fullWidth*1.033),(fullHeight*0.0449)) 
		headingBar.strokeWidth = 2 -- Set the stroke width to two (for black outline)
		headingBar:setFillColor(1,1,1,0.9) -- Set the fill colour to grey
		headingBar:setStrokeColor( 0,0,0,1) -- set the outline colour to black
		headingBar.anchorX = 0.5 -- Set the x anchor point to the centre of the rectangle
		sceneGroup:insert(headingBar) -- insert the object into the scene group. 

		local heading = display.newText("Showing search results for: "..searchItem,(fullWidth*0.02),(fullHeight*0.11), native.systemFont, 32)
		heading.anchorX = 0 -- set the anchor point to 0
		heading:setFillColor(0,0,0,1) -- Set the colour of the text to black
		sceneGroup:insert(heading) -- insert the object into the scene group
	else
		-- If the previous scene is taxonomic, then display the taxonomic heading
		if prevScene == "taxonomic" then
			createText(title,cat, midpointX,(midpointY*0.11),native.systemFontBold, 32 )
		-- If the previous scene is weight, then display the weight heading
		elseif prevScene == "weight" then
			createText(title,weight, midpointX,(midpointY*0.11),native.systemFontBold, 32 )
		end 
	end
-----------------------------------------------------------------------------------------------------------------------	
	-- Menu Row Touch
-----------------------------------------------------------------------------------------------------------------------
	-- Controls what happens when a menu object is clicked
	local function onRowTouch( event )   
        local row = event.row
        local id = row.id
		local params =  event.target.params	
		local parentScene = composer.getSceneName( "previous") -- Get the previous scene name and store it in a variable called parent scene
        if event.phase == "press" or event.phase == "tap" then -- if a menu object is clicked then
			local options = {
				effect = "slideLeft", -- use the slide left animation with a time of 500ms
				time = 500,	
				params = {
					id = params.id,
					birdName = params.birdName,
					birdImage = params.birdImage,
					birdDescription = params.birdDescription,
					scientificName = params.scientificName,
					status = params.status,
					parentScene = params.parentScene,
					search = false
				}			
			}
			-- Go to the bird scene with the above parameters
			composer.gotoScene( "scenes.bird", options ) 
        end
    end
-----------------------------------------------------------------------------------------------------------------------
	-- Row Render
-----------------------------------------------------------------------------------------------------------------------	
	local function onRowRender( event )
		local row = event.row
		local id = row.index
		local params = event.row.params
		local rowHeight = row.contentHeight
		local rowWidth = row.contentWidth
		-- Create a text object
		local rowText = display.newText( params.birdName,10,0,nil,32)
			rowText:setFillColor( 0,0,0,1 ) -- set the colour of the text to black
			row:insert(rowText) -- insert the row text into the row
			rowText.anchorY = 1 -- set the anchor point of the text object
			rowText.anchorX = 0
			rowText.x = (rowWidth*0.02) -- set the x and y position of the text within the text field
			rowText.y = (rowHeight*0.75)
	end	
-----------------------------------------------------------------------------------------------------------------------
	-- Table View Widget Object
-----------------------------------------------------------------------------------------------------------------------	
	local menuTable = widget.newTableView(
	{	
		left = 0,
		isBounceEnabled = true, -- bounce effect when reaching the top or bottom of the tableView
		top = (fullHeight*0.15),
		height = (fullHeight*0.6896),
		width = (fullWidth),
		onRowRender = onRowRender,
		onRowTouch = onRowTouch
	})
	sceneGroup:insert(menuTable) -- insert the table view into the scene group	
-----------------------------------------------------------------------------------------------------------------------
	-- SQL database set up
-----------------------------------------------------------------------------------------------------------------------		
	-- Find the name of the previous scene and store it in a variable named determine scene
	local determineScene = composer.getSceneName( "previous") 

	if searchIsTrue then
		-- Search through each column - name, description
		sql = "SELECT * FROM birds WHERE name like '%" .. searchItem .. "%' OR description like '%" .. searchItem .. "%' OR scientific like '%" .. searchItem .."%' OR status like '%" .. searchItem .. "%' ORDER BY id ASC"
	else
		if determineScene == "scenes.taxonomic" then
			sql = "SELECT * FROM birds WHERE tax_id = " .. id .. "  ORDER BY name ASC  "
		elseif determineScene == "scenes.weight" then
			sql = "SELECT * FROM birds WHERE weight = " .. id .. " ORDER BY name ASC "
		end
	end

	for row in db:nrows(sql) do 
		menuTable:insertRow{
		    rowHeight = (fullHeight*0.06),
			rowColor = { 1, 1, 1 }, -- Set the row colour to white
			lineColor = { 0, 0, 0 }, -- Set the line colour to black
			params = { 
				id = row.id, -- id of bird
				tax_id = row.tax_id, -- taxonomic id
				weight = row.weight, -- weight
				birdName = row.name, -- bird common name
				birdImage = row.image, -- image of bird
				birdDescription = row.description, -- description
				scientificName = row.scientific, -- scientific name
				status = row.status, -- introductory status
		}}	
	end
		
	-- Home Button Event Function
	local homeButtonEvent = function(event)
		-- Find the the previous scene 
		local prevScene = composer.getSceneName( "previous")
		-- If the button is pressed then
		if event.phase == "ended"  then 
			-- go to the previous scene with the following parameters 	
			composer.gotoScene( prevScene, { effect = "slideRight", time = 500});
		end
	end
	
	-- Home button widget object
	local homeButton = widget.newButton{
		id = "homeButton", -- set the id to homeButton
		defaultFile = "assets/ui/back.png", -- set the default image as a back button
		overFile = "assets/ui/back.png", -- set the over image as a back button
		onEvent = homeButtonEvent, -- use the home button event
	}
	homeButton.x = (fullWidth*0.037) -- set the x position of the button widget 
	homeButton.y = (midpointY*0.11) -- set the y position of the button widget
	sceneGroup:insert( homeButton ) -- insert the home button into the scene group
-----------------------------------------------------------------------------------------------------------------------
end
-----------------------------------------------------------------------------------------------------------------------
function scene:willEnter( event )
	local sceneGroup = self.view
end
function scene:didEnter( event )
	local sceneGroup = self.view
	local prevScene = composer.getSceneName( "previous" )
	if prevScene then
		composer.removeScene( prevScene, true ) 
	end
end
function scene:willExit( event )
	local sceneGroup = self.view
end
function scene:didExit( event )
	local sceneGroup = self.view
end
function scene:destroy( event )
	local sceneGroup = self.view
end
function scene:show( event )
	local sceneGroup 	= self.view
	local willDid 	= event.phase
	if( willDid == "will" ) then
		self:willEnter( event )
	elseif( willDid == "did" ) then
		self:didEnter( event )
	end
end
function scene:hide( event )
	local sceneGroup 	= self.view
	local willDid 	= event.phase
	if( willDid == "will" ) then
		self:willExit( event )
	elseif( willDid == "did" ) then
		self:didExit( event )
	end
end
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
return scene
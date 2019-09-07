-----------------------------------------------------------------------------------------------------------------------
-- Vaibhav Ekambaram: New Zealand Birds Application
-- Alphabetic.lua -- Alphabetic index tab
-----------------------------------------------------------------------------------------------------------------------
-- Required Libraries
-----------------------------------------------------------------------------------------------------------------------
-- Include the widget library: used for buttons, and other UI elements
local widget = require "widget"
-- Require the composer library: used for scenes and transitions
local composer = require "composer"
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
	-- Application Top Bar
-----------------------------------------------------------------------------------------------------------------------		
	-- top bar background
	-- Create a new rectangle
	local topBar = display.newRect((fullWidth*0.5),(fullHeight*0.0449),(fullWidth*1.036),(fullHeight*0.0899)) 
	topBar.anchorX = 0.5 -- Set the x anchor point to the centre of the rectangle
	topBar:setFillColor(1,1,1,1) -- Set the colour to white
	sceneGroup:insert(topBar) -- insert the object into the scene group
	
	-- heading bar
	local headingBar = display.newRect((fullWidth*0.5),(fullHeight*0.1124),(fullWidth*1.033),(fullHeight*0.0449)) 
	headingBar.strokeWidth = 2 -- Set the stroke width to two (for black outline)
	headingBar:setFillColor(1,1,1,0.9) -- Set the fill colour to grey
	headingBar:setStrokeColor( 0,0,0,1) -- set the outline colour to black
	headingBar.anchorX = 0.5 -- Set the x anchor point to the centre of the rectangle
	sceneGroup:insert(headingBar) -- insert the object into the scene group. 
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
		objectName:setFillColor(0,0.0,0,1) -- Set the colour of the text to black
		sceneGroup:insert(objectName) -- insert the object into the scene group
	end
-----------------------------------------------------------------------------------------------------------------------
	-- Function calls for text function
-----------------------------------------------------------------------------------------------------------------------
	-- Application top bar title: displays the name of the app
	createText(title,"New Zealand Birds", midpointX,(midpointY*0.11),native.systemFontBold, 40 )
	-- Heading/current menu
	createText(heading,"Alphabetic Index",(fullWidth*0.2),(fullHeight*0.11), native.systemFont, 32 )
-----------------------------------------------------------------------------------------------------------------------
	-- Search Bar
-----------------------------------------------------------------------------------------------------------------------	
	-- Search bar text field
	local searchTextField = native.newTextField((fullWidth*0.05), (fullHeight*0.173), (fullWidth*0.8), (fullHeight*0.045) )
	searchTextField.placeholder = "Search" -- text displayed in the field
	searchTextField.anchorX = 0 -- set anchor point of the text field (x-axis) to 0
	searchTextField.inputType = "default" 
	searchTextField:setReturnKey( "done" )
	sceneGroup:insert(searchTextField) -- insert the object into the scene goup

	-- Handle event for search bar validation button
	local function handleButtonEvent( event )
		if ( "ended" == event.phase ) then -- If the button has been pressed
			if searchTextField.text == nil or searchTextField.text == "" then -- if nothing is entered into the text box
				-- show an alert telling the user to enter a value into the text box before pressing the button
				local alert = native.showAlert( "Error", "Please enter a value into the search field", { "OK"})
			else
				local options = {
					effect = "slideLeft", -- slide left animation with 500ms time
					time = 500,	
					params = {
						-- contains the search string that the user entered
						searchItem = searchTextField.text,
						search = true
					}			
				}
				-- go to the birds scene showing the search results
				composer.gotoScene( "scenes.birds", options )

			end
		end
	end
----------------------------------------------------------------------------------------------------------------------- 
	-- Row Touch
----------------------------------------------------------------------------------------------------------------------- 	
	local function onRowTouch( event )
        local row = event.row
        local id = row.id
		local params =  event.target.params
		local parentScene = composer.getSceneName( "previous") 				
        if event.phase == "press" or event.phase == "tap" then     
			local options = {
				effect = "slideLeft", -- Slide left animation with a time of 500ms.
				time = 500,	
				params = {
					id = params.id, -- bird id
					birdName = params.birdName, -- bird english/maori name
					birdImage = params.birdImage, -- bird image file path
					birdDescription = params.birdDescription, -- bird description
					scientificName = params.scientificName, -- bird scientific name
					status = params.status, -- bird status
					parentScene = params.parentScene, -- parent scene (previous scene name)
					search = false -- search value set to false
				}			
			}
			-- Go to the bird scene with the above parameters
			composer.gotoScene( "scenes.bird", options ) 
        end
    end

    -- Search Button widget object
	local searchButton = widget.newButton(
    {
        label = "search", -- widget button label
        onEvent = handleButtonEvent, -- handler event
        shape = "Rect", -- shape
        width = (fullWidth*0.1), -- width
        height = (fullHeight*0.045), -- height
        fillColor = { default={0,0.5,1,1}, over={0,0.5,1,1} }, -- set colour to blue
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } }  -- set button to blue
	})
 
	searchButton.x = (fullWidth*0.95) -- set the x position of the search button
	searchButton.y = (fullHeight*0.1724) -- set the y position of the search button
 	searchButton.anchorX = 1 -- set x axis anchor point
	searchButton:setLabel( "🔍" ) -- set button label text
	searchButton._view._label.size = 42 -- set the size of the text
	sceneGroup:insert(searchButton)	-- Insert the search button object into the scene goup
-----------------------------------------------------------------------------------------------------------------------
	-- Row Render
-----------------------------------------------------------------------------------------------------------------------	
	local function onRowRender( event )
		local row = event.row
		local id = row.Index
		local params = event.row.params
		local rowHeight = row.contentHeight
		local rowWidth = row.contentWidth
		-- Row Text object
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
		top = (fullHeight*0.21), -- set top
		height = (fullHeight*0.6896), -- set height
		width = (fullWidth), -- set width
		onRowRender = onRowRender, -- render controller
		onRowTouch = onRowTouch, -- touch controller
	})
	sceneGroup:insert(menuTable) -- insert the table view into the scene group
----------------------------------------------------------------------------------------------------------------------- 
	 --Read from SQL database and create a for loop which populates the tableView
-----------------------------------------------------------------------------------------------------------------------	 
	-- select from birds table using name column, sort by ascending order (alphabetical)
	for row in db:nrows("SELECT * FROM birds ORDER BY name ASC") do 
		menuTable:insertRow{
		    rowHeight = (fullHeight*0.06),
			rowColor = { 1, 1, 1 }, -- Set the row colour to white
			lineColor = { 0, 0, 0 }, -- Set the line colour to black
			params = { 
				id = row.id, -- id of bird
				birdName = row.name, -- bird common name
				birdImage = row.image, -- bird image file path
				birdDescription = row.description, -- bird description
				scientificName = row.scientific, -- scientific name
				status = row.status, -- bird status
		}}	
	end
-----------------------------------------------------------------------------------------------------------------------
	-- Tab bar
-----------------------------------------------------------------------------------------------------------------------	
	-- If a tab bar button is pressed
	local function handleButtonEvent( event )
		-- Go to scene which is comprised of the id
		composer.gotoScene( event.target.id )
	end	
-----------------------------------------------------------------------------------------------------------------------	
	-- This table stores all necessary information for the tab bar
	local tabButtons = {
    {
        label = "Alphabetic",
        id = "scenes.alphabetic",
        selected = true,
        onPress=handleButtonEvent,
		size = 25,
		defaultFile="/assets/ui/alphabetic_dark.png" ,
		overFile="/assets/ui/alphabetic_dark_selected.png",
    },
    {
        label = "Taxonomic",
        id = "scenes.taxonomic",
        onPress=handleButtonEvent,
		size = 25,
		defaultFile="/assets/ui/taxonomic_dark.png" ,
		overFile="/assets/ui/taxonomic_dark_selected.png",

    },
	{
		label = "Weight",
		id = "scenes.weight",
		onPress = handleButtonEvent,
		size = 25,
		defaultFile="/assets/ui/weight_dark.png" ,
		overFile="/assets/ui/weight_dark_selected.png",
	},
	{
		label = "Visual",
		id = "scenes.visual",
		onPress = handleButtonEvent,
		size = 25,
		defaultFile="/assets/ui/visual_dark.png",
		overFile="/assets/ui/visual_dark_selected.png",
		
	},
    {
        label = "Settings",
        id = "scenes.settings",
        onPress = handleButtonEvent,
		size = 25,
		defaultFile="/assets/ui/settings_dark.png" ,
		overFile="/assets/ui/settings_dark_selected.png",
    }
	}
-----------------------------------------------------------------------------------------------------------------------	
 	-- Tab Bar Widget Object
----------------------------------------------------------------------------------------------------------------------- 	
	local tabBar = widget.newTabBar(
    {
        top = (fullHeight*0.92), -- Set top position
        width = display.contentWidth, -- set width
		height = (fullHeight*0.082), -- Set height
        buttons = tabButtons, -- table which contains tab bar information
    }
	)	
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
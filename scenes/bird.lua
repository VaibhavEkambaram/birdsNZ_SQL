-----------------------------------------------------------------------------------------------------------------------
-- Vaibhav Ekambaram: New Zealand Birds Application
-- Bird.lua 
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
	-- Top Bar
-----------------------------------------------------------------------------------------------------------------------
	local topBar = display.newRect((fullWidth*0.5),(fullHeight*0.0449),(fullWidth*1.036),(fullHeight*0.0899)) 
	topBar:setFillColor(1,1,1,1) -- Set the colour to white
	topBar.anchorX = 0.5 -- Set the x anchor point to the centre of the rectangle
	sceneGroup:insert(topBar) -- insert the object into the scene group
-----------------------------------------------------------------------------------------------------------------------
	-- Scroll View 
-----------------------------------------------------------------------------------------------------------------------	
	-- Scroll view object where information is put in
	local scrollView = widget.newScrollView(
    {
        top = (fullHeight*0.092), 
        left = 0, 
        width = fullWidth, -- width
        height = (fullHeight*0.8), -- height
        horizontalScrollDisabled = true, -- disable horizontal scrolling for the scroll view
        topPadding = (fullHeight*0.02), -- set the top padding of the scroll view
        bottomPadding = (fullHeight*0.01), -- set the bottom padding of the scroll view
        listener = scrollListener,

    }
	)
	sceneGroup:insert(scrollView) -- insert the scrollview into the scene group
-----------------------------------------------------------------------------------------------------------------------
	-- Bird Name
-----------------------------------------------------------------------------------------------------------------------	
	local birdName = event.params.birdName -- Get the name of the bird from the previous scene parameter
	local title = display.newText(birdName, midpointX,(midpointY*0.11),native.systemFontBold,40) -- create a text object
	title:setFillColor(0,0,0,1) -- Set the colour to black
	sceneGroup:insert(title) -- insert the text object into the scene group
-----------------------------------------------------------------------------------------------------------------------
	-- Bird Image
-----------------------------------------------------------------------------------------------------------------------	
	local birdImage = event.params.birdImage -- get the file name from the previous scene parameter
	picture = display.newImage(birdImage, midpointX, 300) -- image object
	scrollView:insert(picture) -- insert the object into the scroll view
	picture:scale( 0.8, 0.8 ) -- set the scale of the image
-----------------------------------------------------------------------------------------------------------------------
	-- Bird Scientific Name
-----------------------------------------------------------------------------------------------------------------------	
	local scientificName = event.params.scientificName -- get the scientific name from the previous scene parameter
	-- create a text object for the scientific name
	local scientific = display.newText(scientificName, 20,40,native.systemFontBold,32)
	scientific:setFillColor(0,0,0,1) -- Set the colour to black
	scientific.anchorX = 0 -- set the x anchor point
	scrollView:insert(scientific) -- insert the text object into the scroll view
-----------------------------------------------------------------------------------------------------------------------
	-- Bird Status
-----------------------------------------------------------------------------------------------------------------------
	-- Define parameter from previous scene as a local variable
	local status = event.params.status
	-- Create a new text object to show the status
	local statusText = display.newText("Status: "..status,(fullWidth*0.026),70,native.systemFontBold,32)
	-- Determine the colour of the status value
	if status == "ENDEMIC" then -- if the value for status is endemic
			statusText:setFillColor(1,0,0,1) -- set the colour to red
	elseif status == "NATIVE" then -- otherwise if the colour is native
			statusText:setFillColor(0,1,0,1) -- set the colour to green
	elseif status == "INTRODUCED" then -- otherwise if the colour is introduced
			statusText:setFillColor(0,0,1,1) -- set the colour to blue
	end
	-- Set the anchor point of the object to the left most position
	statusText.anchorX = 0 
	scrollView:insert(statusText) -- insert the text object into the scroll view
-----------------------------------------------------------------------------------------------------------------------
	-- Bird Description
-----------------------------------------------------------------------------------------------------------------------	
	-- Define parameter from previous scene as a local variable
	local birdDescription = event.params.birdDescription
	-- Create a new text object to show the bird description
	local description = display.newText(birdDescription, midpointX,(fullWidth*0.7),(fullHeight*0.52),0,native.systemFont,32)
	description:setFillColor(0,0,0,1) -- Set the colour to black
	description.anchorY = 0 -- set the y axis anchor point of the description text
	scrollView:insert(description) -- insert the description into the scene group
-----------------------------------------------------------------------------------------------------------------------
	-- Home Button
-----------------------------------------------------------------------------------------------------------------------	
	-- Home Button Handle Event Function
	local parentScene = event.params.parentScene
	local homeButtonEvent = function (event ) -- function event for home button		
		local prevScene = composer.getSceneName( "previous")
		-- if the button has been pressed then
		if event.phase == "ended"  then  	
			-- go to the alphabetic scene with a time delay of 500 ms. 
			if prevScene == "scenes.alphabetic" or prevScene == "scenes.visual" then
				composer.gotoScene( prevScene, { effect = "slideRight", time = 500});
			else 
				composer.gotoScene( "scenes.alphabetic", { effect = "slideRight", time = 500});
			end			
		end
	end

	-- Home Button Object
	local homeButton = widget.newButton{
		id = "homeButton", -- Set id as home button
		defaultFile = "assets/ui/back.png", -- Use the back png file as the default image
		overFile = "assets/ui/back.png", -- Use the back png file as the image when clicked
		onEvent = homeButtonEvent -- Link the button to the home button event
	}
	homeButton.x = (fullWidth*0.037) -- x location
	homeButton.y = (midpointY*0.11) -- y location
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
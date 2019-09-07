-----------------------------------------------------------------------------------------------------------------------
-- Vaibhav Ekambaram: New Zealand Birds Application
-- Settings.lua - Settings Menu
-----------------------------------------------------------------------------------------------------------------------
-- Required Libraries
-----------------------------------------------------------------------------------------------------------------------
-- Include the widget library: used for buttons, and other UI elements
local widget = require( "widget" )
-- Require the composer library: used for scenes and transitions
local composer = require( "composer" )
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

	-- Top Bar
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
	-- Function calls for text function
-----------------------------------------------------------------------------------------------------------------------
	-- Application top bar title: displays the name of the app
	createText(title,"Settings", midpointX,(midpointY*0.11),native.systemFontBold, 40 )
	-- Heading/current menu
-----------------------------------------------------------------------------------------------------------------------
	-- Reference text at the bottom of the screen
	local sourceText = display.newText( "Copyright free images sourced from Wikimedia Commons", midpointX,(fullHeight*0.22), native.systemFont, 28 ) 
	sourceText:setFillColor( 0, 0, 0 ) -- Set the colour to black
	sceneGroup:insert(sourceText)
	local sourceSecond = display.newText( "https://commons.wikimedia.org/", midpointX,(fullHeight*0.24), native.systemFont, 28 )
	sourceSecond:setFillColor( 0, 0, 0 ) -- Set the colour to black
	sceneGroup:insert(sourceSecond)
end
-----------------------------------------------------------------------------------------------------------------------
function scene:willEnter( event )
	local sceneGroup = self.view
end
-----------------------------------------------------------------------------------------------------------------------
function scene:didEnter( event )
	local sceneGroup = self.view
	local prevScene = composer.getSceneName( "previous" )
	if prevScene then
		composer.removeScene( prevScene, true ) 
	end
end
-----------------------------------------------------------------------------------------------------------------------
function scene:willExit( event )
	local sceneGroup = self.view
end
-----------------------------------------------------------------------------------------------------------------------
function scene:didExit( event )
	local sceneGroup = self.view
end
-----------------------------------------------------------------------------------------------------------------------
function scene:destroy( event )
	local sceneGroup = self.view
end
-----------------------------------------------------------------------------------------------------------------------
-- Function / Callback Definitions
-----------------------------------------------------------------------------------------------------------------------
-- Scene Dispatch Events, Etc. - Generally Do Not Touch Below This Line
-----------------------------------------------------------------------------------------------------------------------
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
-----------------------------------------------------------------------------------------------------------------------
return scene
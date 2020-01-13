local composer = require( "composer" )
local widget = require( "widget" )

local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local options =
{
    width = 188,
    height = 223,
    numFrames = 9
}
local sheet = graphics.newImageSheet( "Images/Planets.png", options )

local touchX = 0
local touchY = 0
local CURRPLANET
local PATCH = 330
local HEACH = 2
local SCORE = {}

local button = {}
local planetGroup = {}
local pauseGroup = {}
local background = {}

 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
planetGroup = display.newGroup()
pauseGroup = display.newGroup()
display.setStatusBar( display.HiddenStatusBar )

local function loadStats()

	local path1 = system.pathForFile( "savestat.txt" )
	local file1, errorString1 = io.open( path1, "r" )
			if not file1 then
			
			print( "File error: " .. errorString1 )
		else
    local i = 1
			for line in file1:lines() do
				
					SCORE[i] = line
					i = i + 1
			end
		io.close( file1 )
		end
end

 local function handleButtonEvent1( event )
 
	if ( "ended" == event.phase ) then
		print( "Button was pressed and released" )
			composer.gotoScene("menu")
	end
end


local function handleMove( event )
    if event.phase == "began" then
        touchX=event.x
			elseif(event.phase == "moved") then
				if(planetGroup.x-160>-450 and touchX - event.x>0)then
					planetGroup.x = planetGroup.x - 2
						print(CURRPLANET)
					
					elseif(planetGroup.x+160<450 and touchX - event.x<0) then
					planetGroup.x = planetGroup.x + 2

						
				end

			end
end

local function handleButtonEvent2( event )
    local options = {
    effect = "fade",
    time = 800,
	params = { PATH=PATCH }

				}
				print(CURRPLANET)	
    if event.phase == "began" then
	print(CURRPLANET)	
		if(CURRPLANET==1)then
		print("TRASH")
		else
		print(CURRPLANET,"trash")
		PATCH = 300
			composer.gotoScene("game",options)
			end
			end
end

local function handleButtonEvent3( event )
    if event.phase == "began" then
	if(CURRPLANET==2)then
	elseif(CURRPLANET==1)then
		PATCH = 300
	else
		PATCH = 500
		local options = {
			effect = "fade",
			time = 800,
			params = { PATH=PATCH }

					}
		composer.gotoScene("game",options)
	
		end
	end
	
end

local function handleButtonEvent4( event )

local options = {
    effect = "fade",
    time = 800,
	params = { PATH=PATCH }

				}
					
    if event.phase == "began" then
		if(CURRPLANET==3)then
		print("TRASH")
		elseif(CURRPLANET==1)then
		PATCH = 300
			print("TRASH")
			composer.gotoScene("game",options)
		elseif(CURRPLANET==2)then
		PATCH = 500
    	print("TRASH")
			composer.gotoScene("game",options)
	

			end
	end
end
			

Runtime:addEventListener( "touch", handleMove )
-- create()
function scene:create( event )
	CURRPLANET = event.params["CURRPLANE"]
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
			button[1] = widget.newButton(
			{
				left      = 100,
				top       = 20,
				id        = "button1",
				label     = "В меню",
				onEvent   = handleButtonEvent1,
				fillColor = { default={ 1, 1, 1, 1 }, over={ 1, 0.2, 0.5, 0 } }
			}
		)
		
					button[2] = widget.newButton(
			{
				x = display.contentCenterX,
				y = display.contentCenterY,
				id        = "Planet1",
				sheet = sheet,
				defaultFrame = 1,
				overFrame = 1,
				onEvent   = handleButtonEvent2,
			}
		)
		
		
					button[3] = widget.newButton(
			{
				x = display.contentCenterX*2,
				y = display.contentCenterY*0.3,
				id        = "Planet2",
				sheet = sheet,
				defaultFrame = 2,
				overFrame = 2,
				onEvent   = handleButtonEvent3,
			}
		)			
		
					button[4] = widget.newButton(
			{
				x = -display.contentCenterX,
				y = display.contentCenterY*1.3,
				id        = "Planet3",
				sheet = sheet,
				defaultFrame = 3,
				overFrame = 3,
				onEvent   = handleButtonEvent4,
			}
		)
		
		background[1] = display.newImageRect("Images/starback.jpg", display.contentWidth*1.3, display.contentHeight*1.1)
		background[1].x = display.contentCenterX
		background[1].y = display.contentCenterY
		planetGroup:insert(1,background[1])
		
			pauseGroup:insert(2,button[1])
			planetGroup:insert(2,button[2])
			planetGroup:insert(2,button[3])
			planetGroup:insert(2,button[4])

			

		background[2] = display.newImageRect("Images/starback.jpg", display.contentWidth*1.3, display.contentHeight*1.1)
		background[2].x = -display.contentCenterX
		background[2].y = display.contentCenterY
		planetGroup:insert(1,background[2])
		background[3] = display.newImageRect("Images/starback.jpg", display.contentWidth*1.3, display.contentHeight*1.1)
		background[3].x = display.contentCenterX*3
		background[3].y = display.contentCenterY
		planetGroup:insert(2,background[3])

		
		background[4] = display.newImageRect("Images/Mask.png", display.contentWidth*0.6, display.contentWidth*0.6)
		planetGroup:insert(4,background[4])

		background[4].x = button[2].x
		background[4].y = button[2].y-20

end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
	
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
		planetGroup.isVisible = true
		pauseGroup.isVisible = true
		
		loadStats()
		CURRPLANET = SCORE[3]
		
		
		print(CURRPLANET)
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen

    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
			planetGroup.isVisible = false
			pauseGroup.isVisible = false
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
 
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
 
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene
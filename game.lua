local composer = require( "composer" )
local widget = require( "widget" )
local physics = require("physics")
 
local scene = composer.newScene()
----------------------------------Переменные------------------------------------------
local WAS_SPEED = 2
local SPEED = 2
local PATCH = 300
local HEACH = 2
local FUEL = 1000
local WAS_PATCH = 300
local START_PATCH
local TMR = 5000
local SCORE = 0
local rand
local groupNum  = 0
local xCoord
local pathBarHeight
local procentBar

----------------------------------Обьекты---------------------------------------------
local options1 =
{
	width = 165,
	height = 170,
	numFrames = 7,
	sheetContentWidth = 1155,
	sheetContentHeight = 170
}

local rocks = graphics.newImageSheet("rocks.png", options1)
local gameGroup = {}
local pauseGroup = {}
local destroyGroup = {}
local object = {}
local background = {}
local callSpawn = {}
local button = {}
local pathBar = {}
local timerspawn
local timerevent
local timerdestroy
local destroyed
local scor
gameGroup       = display.newGroup()
pauseGroup      = display.newGroup()
destroyGroup	= display.newGroup()
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
physics.start()
physics.setGravity(0,0)
math.randomseed(os.time())

local function clearMap()


	
	for i = gameGroup.numChildren, 1, -1 do
		print(gameGroup[i].collType)
		if(gameGroup[i].collType=="box")then
		
				gameGroup[i]:removeSelf()
				
	
		end
	end
end

local function endGame(win)

	if(win==true)then
		pauseGroup.isVisible = true
		button[1].isVisible = false
		clearMap()
		timer.cancel(timerspawn)
		timer.cancel(timerevent)
		Runtime:removeEventListener( "touch", onTouch )
	else
		pauseGroup.isVisible = true
		button[1].isVisible = false
		clearMap()
		timer.cancel(timerspawn)
		timer.cancel(timerevent)
		Runtime:removeEventListener( "touch", onTouch )
	
	end

end

local function speedBuff(dd)

	for i = gameGroup.numChildren, 1, -1 do
		print(gameGroup[i].collType)
		if(gameGroup[i].collType=="box")then
			if dd == 1 then
			
				gameGroup[i]:setLinearVelocity(0,10*SPEED)
				
			elseif dd == 2 then
			
				gameGroup[i]:setLinearVelocity(0)

			end

		end
	end
	
end


local function removeFromDisplay(box)

	for i = 0, #destroyGroup do
		if(box==destroyGroup[i])then
			destroyGroup[i]:removeSelf()
		else
			box:removeSelf()
		end
	end	

end

local function addToGroup(box)
	groupNum = groupNum + 1
	destroyGroup:insert(box)
	box:scale(1.1,1.1)
	
	print(groupNum)
	
end

local function checkID(box)
	print("check",destroyGroup[1])
	if(destroyGroup[1].id==box.id)then
		return true
	end
	return false
end

local function removeFormGroup(box)

	for i = box.numChildren, 1, -1 do
		box[i]:scale(0.9,0.9)
		gameGroup:insert(3,box[i])
	end
end

local function checkGroup(box)

	for i = destroyGroup.numChildren, 1, -1 do
		if(box==destroyGroup[i]) then
			return false
		end
	end
		
return true
end

local function tapListener( event )
 if(event.target.id==1 or event.target.id==6)then
		if(event.target.heach<=1) then
			event.target:removeSelf()
			SCORE = SCORE + 2
			scor.text = SCORE
		else
			event.target.heach = event.target.heach - 1
		end
	end		
end
 



local function onObjectTouch( event )
   if event.phase == "began" then
		if(event.target.id~=1)then
			addToGroup(event.target)
		end	
	elseif(event.phase == "moved") then
		if(event.target.id~=1 and event.target.id~=6)then
		
		if(groupNum>0 and event.target~=nil) then
			if(checkID(event.target)==true)then
				if(checkGroup(event.target)) then
					addToGroup(event.target)
				end
			else
				if(groupNum>1)then
					removeFormGroup(destroyGroup)
					groupNum=0
					print(groupNum)
				else
					print("removeazaza")
					destroyGroup[1]:scale(0.9,0.9)
					gameGroup:insert(5,destroyGroup[1])
					groupNum=0
				end
			end
		elseif(groupNum==0) then
			addToGroup(event.target)
		end
		end
        elseif(event.phase == "ended"  or event.phase=="cancelled") then

			if (groupNum>1) then
				for i = destroyGroup.numChildren, 1, -1 do
					if(destroyGroup[i].id == 1 and destroyGroup[i].heach == 2)then
						destroyGroup[i].heach = 1
					else
						destroyGroup[i]:removeSelf()
						SCORE = SCORE + groupNum * 2
						scor.text = SCORE
					end
				
				
				end
			elseif(groupNum==1 and destroyGroup[1]~=nil)	then

					destroyGroup[1]:scale(0.9,0.9)
					gameGroup:insert(5,destroyGroup[1])
			end
		groupNum = 0

	end
	

end

 


local function spawn()
local q = 0
	for i = 1, 6 do
	if(START_PATCH/2 > PATCH)then
		rand = math.random(1,7)
		else
		rand = math.random(1,6)
	end
			if(rand==2 or rand == 3)then
				i = i + 1
			elseif(q==1 and rand == 1)then
				
			elseif(q==2 and rand == 6)then
			
			elseif(q==3 and rand == 7)then
			else
				object[i] = display.newImageRect(rocks, rand, 53, 53)
				object[i].id = rand
				object[i].x = 53*i-20
				object[i].y = -26
				object[i].xScale = math.random(-1,1)
				object[i].collType = "box"
				physics.addBody(object[i], "dynamic", {density=0, friction=0, bounce=0, hasCollided = false})
				object[i]:setLinearVelocity(0,10*SPEED)
				object[i].isFixedRotation = true
				gameGroup:insert(4,object[i])
				object[i]:addEventListener( "touch", onObjectTouch )
				object[i]:addEventListener( "tap", tapListener ) 
					if(object[i].id==1)then
						object[i].heach = 2
						q=1
					end
					if(object[i].id==6)then
						object[i].heach = 1
						q=2
					end
					if(object[i].id==7)then
						object[i].heach = 1
						q=3
					end
			end
	end
		print(PATCH, "path")
		print(WAS_PATCH, "pathwas")
		print(FUEL, "fuel")
		print(SPEED,"speed")
end

local function onTouch( event )

	if(event.phase == "ended"  or event.phase=="cancelled") then

			if (groupNum>1) then
				for i = destroyGroup.numChildren, 1, -1 do
					if(destroyGroup[i].id == 1 and destroyGroup[i].heach == 2)then
						destroyGroup[i].heach = 1
					else
						destroyGroup[i]:removeSelf()
						SCORE = SCORE + groupNum * 2
						scor.text = SCORE
					end
				
				
				end
			elseif(groupNum==1 and destroyGroup[1]~=nil)	then

					destroyGroup[1]:scale(0.9,0.9)
					gameGroup:insert(5,destroyGroup[1])
			end
		groupNum = 0

	end

end

local function listenerSpawn( event )
    spawn()
end

local function listenerEvent( event )
    background[1].y = background[1].y + SPEED*0.1
	background[2].y = background[2].y + SPEED*0.1
	
	if(background[1].y>display.contentCenterY*3)then
		background[1].y = -display.contentCenterY
	end
	if(background[2].y>display.contentCenterY*3)then
		background[2].y = -display.contentCenterY
	end
	
	if(WAS_PATCH-PATCH>30)then
		WAS_PATCH = PATCH
			if(SPEED<5)then
				SPEED=SPEED+1.3
			end
	else
		PATCH = PATCH - 0.01*SPEED
		FUEL = FUEL - 0.01*SPEED
	end
	
	if(SPEED-WAS_SPEED>0.4)then
		WAS_SPEED = SPEED
		TMR = TMR - 1200
		speedBuff(1)
		timer.cancel(timerspawn)
		timerspawn = timer.performWithDelay( TMR, listenerSpawn, -1 )
		print("speedbuff")
	end
	
	pathBar[1].height = pathBar[1].height + (procentBar*SPEED)/100
	pathBar[1].y = pathBar[1].y - (procentBar*SPEED)/200
	
	if(PATCH<1)then
		endGame(true)
	end
end
  
timerevent = timer.performWithDelay( 1, listenerEvent, -1 )





local function onLocalCollision( self, event )
 
    if ( event.phase == "began" ) then
		removeFromDisplay(event.other)
		if(event.other.id==1 or event.other.id==6)then
			HEACH = HEACH - 2
		elseif(event.other.id==7)then
			FUEL = FUEL + 50
		else
			HEACH = HEACH - 1
		end
			if(HEACH<1)then
				endGame(false)
			
			end
    end
end
 
Runtime:addEventListener( "touch", onTouch )

----------------------------------Кнопки----------------------------------------------

			local function handleButtonEvent1( event )
 
				if ( "ended" == event.phase ) then
					print( "Button was pressed and released" )
						pauseGroup.isVisible = true
						button[1].isVisible = false
						speedBuff(2)
						timer.pause(timerspawn)
						timer.pause(timerevent)
						Runtime:removeEventListener( "touch", onTouch )
				end
			end

			local function handleButtonEvent2( event )
 
				if ( "ended" == event.phase ) then
					print( "Button was pressed and released" )
			
						pauseGroup.isVisible = false
						button[1].isVisible = true
						speedBuff(1)
						timer.resume(timerspawn)
						timer.resume(timerevent)
						Runtime:addEventListener( "touch", onTouch )
				end
			end
			

--------------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
	

			background[1] = display.newImageRect("Images/starback.jpg", display.contentWidth*1.3, display.contentHeight*1.1)
			gameGroup:insert(1,background[1])
			background[2] = display.newImageRect("Images/starback.jpg", display.contentWidth*1.3, display.contentHeight*1.1)
			gameGroup:insert(2,background[2])
			
			background[3] = display.newImageRect("Images/Spaceship2.png", display.contentWidth, display.contentHeight*0.5)
			gameGroup:insert(3,background[3])
			background[4] = display.newImageRect("Images/Spaceship2.png", display.contentWidth*0.5, display.contentHeight*0.25)
			gameGroup:insert(4,background[3])
			
			background[5] = display.newImageRect("Images/MenuBack.png", display.contentWidth, display.contentHeight)
			pauseGroup:insert(1,background[5])
			
			pathBar[1] = display.newRect(0,display.contentCenterY+275, 10, 1)
			pathBar[1]:setFillColor(0.4,0.2,0.6)
	
			pathBar[2] = display.newRect(0,display.contentCenterY, 15, display.contentHeight*0.8)
			gameGroup:insert(5,pathBar[1])
			gameGroup:insert(4,pathBar[2])
		
			background[6] = display.newImageRect("Images/BlipG.png", 35, 15)
			background[6].x, background[6].y = 0, display.contentCenterY*0.1
			gameGroup:insert(6,background[6])
			background[7] = display.newImageRect("Images/BlipG.png", 35, 15)
			background[7].x, background[7].y = 0, display.contentCenterY*0.15
			gameGroup:insert(6,background[7])
			
			
			
			-- Create the widget
			button[1] = widget.newButton(
				{
					x = display.contentCenterX*1.7,
					y = 15,
					height = 40,
					width = 80,
					id = "button1",
					defaultFile = "Images/Butt.png",
					overFile = "Images/Butt.png",
					label = "MENU",
					onEvent = handleButtonEvent1
				}
			)
			gameGroup:insert(5,button[1])

-- Create the widget
			button[2] = widget.newButton(
				{
					x = display.contentCenterX,
					y = display.contentCenterY,
					id = "button2",
					label = "PLAY",
					onEvent = handleButtonEvent2
				}
			)
			pauseGroup:insert(3,button[2])
			
			scor = display.newText( SCORE, 30, 10, native.systemFont, 25 )
			scor:setFillColor( 1, 0, 0 )
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
	
	gameGroup.isVisible = true	
	pauseGroup.isVisible = false	
	
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
		PATCH = event.params["PATH"]
		WAS_PATCH = PATCH
		background[1].x = display.contentCenterX
		background[1].y = display.contentCenterY
		background[2].x = display.contentCenterX
		background[2].y = -display.contentCenterY
		background[3].x = display.contentCenterX
		background[3].y = display.contentCenterY
		background[3].xScale = 1
		background[3].yScale = 1
		background[4].x = display.contentCenterX*4
		background[4].y = display.contentCenterY
		
		background[5].x = display.contentCenterX
		background[5].y = display.contentCenterY
		
		pathBarHeight = display.contentHeight*0.8
		procentBar = pathBarHeight/PATCH
		START_PATCH = PATCH
		local function onTouchSh(event)
			
			local can = true
				if ( event.phase == "began" ) then
					xCoord = event.x
					
						elseif(event.phase == "moved")then
							if(xCoord<event.x and can == true )then
								background[4].x = display.contentCenterX*1.5
								can=false
								print("left", xCoord)
							elseif(xCoord>event.x and can == true )then
								background[4].x = display.contentCenterX*0.5
								can=false
								print("right", xCoord)
							end
						elseif ( event.phase == "ended" ) then
							can = true
							
				end	
		end		
		
		function listener1(event)

			timerspawn = timer.performWithDelay( 3500, listenerSpawn, -1 )
			background[3]:removeSelf()
			background[4].x = display.contentCenterX
		    background[4].y = display.contentCenterY*2
			physics.addBody(background[4], "static", {density=0, friction=0, bounce=0, hasCollided = false})
			background[4].collision = onLocalCollision
			background[4]:addEventListener( "collision" )
			background[4]:addEventListener( "touch", onTouchSh)
		end
		


		transition.to( background[3], { time=1500, y=display.contentCenterY*2, xScale = 0.5, yScale = 0.5, onComplete=listener1} )

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
			gameGroup.isVisible = false	
			pauseGroup.isVisible = false
			timer.cancel(timerspawn)
			timer.cancel(timerevent)
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
----------------Инициализация------------------------------------------------------------
local composer = require( "composer" )
local widget = require( "widget" )

----------------Переменные---------------------------------------------------------------
local SCORE = {}
local scoreGroup = {}
local background = {}
local scores = {}



scoreGroup = display.newGroup()

local scene = composer.newScene()
local path = system.pathForFile( "savescore.txt" )
local path1 = system.pathForFile( "savestat.txt" )
display.setStatusBar( display.HiddenStatusBar )

local function handleButtonEvent2( event )
 

end

local function handleButtonEvent1( event )
 
	if ( "ended" == event.phase ) then
		print( "Button was pressed and released" )
			composer.gotoScene("menu")
	end
	
	
end

local function listenerEvent( event )
    background[1].y = background[1].y + 0.2
	background[8].y = background[8].y + 0.2
	
	if(background[1].y>display.contentCenterY*3)then
		background[1].y = -display.contentCenterY
	end
	if(background[8].y>display.contentCenterY*3)then
		background[8].y = -display.contentCenterY
	end
	
end

timerevent = timer.performWithDelay( 1, listenerEvent, -1 )

-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
	
			background[1] = display.newImageRect("Images/starback.jpg", display.contentWidth*1.3, display.contentHeight*1.1)
			background[1].x, background[1].y = display.contentCenterX, display.contentCenterY
			sceneGroup:insert(1,background[1])
			

	button1 = widget.newButton(
		{
			left      = 75,
			top       = 300,
			id        = "button1",
			label     = "В меню",
			onEvent   = handleButtonEvent1,
			fillColor = { default={ 1, 1, 1, 1 }, over={ 1, 0.2, 0.5, 0 } }
		}
	)
	sceneGroup:insert(2,button1)
	
		button2 = widget.newButton(
		{
			left      = 75,
			top       = 200,
			id        = "button1",
			label     = "Загрузить",
			onEvent   = handleButtonEvent2,
			fillColor = { default={ 1, 1, 1, 1 }, over={ 1, 0.2, 0.5, 0 } }
		}
	)
	sceneGroup:insert(2,button2)
	
		
	scores[1] = display.newText("Общий счет: " , display.contentCenterX, display.contentCenterY + 225, native.systemFont, 14)
	scores[2] = display.newText("Счет последнего путеществия: ", display.contentCenterX, display.contentCenterY + 200, native.systemFont, 14)
	scores[3] = display.newText("Все топлива потрачено: "
    , display.contentCenterX, display.contentCenterY + 175, native.systemFont, 14)
	scores[4] = display.newText("Всего пути пройдено: "
    , display.contentCenterX, display.contentCenterY + 150, native.systemFont, 14)
	scores[5] = display.newText("Длинна последнего полета: "
    , display.contentCenterX, display.contentCenterY + 125, native.systemFont, 14)
	scores[6] = display.newText("Максимальная прочность: "
    , display.contentCenterX, display.contentCenterY + 100, native.systemFont, 14)
	scores[7] = display.newText("Вместимость топливного бака: "
    , display.contentCenterX, display.contentCenterY + 75, native.systemFont, 14)
	sceneGroup:insert(3,scores[1])
	sceneGroup:insert(3,scores[2])
	sceneGroup:insert(3,scores[3])
	sceneGroup:insert(3,scores[4])
	sceneGroup:insert(3,scores[5])
	sceneGroup:insert(3,scores[6])
	sceneGroup:insert(3,scores[7])
			
			background[2] = display.newImageRect("Images/Spaceship2.png", display.contentWidth*0.5, display.contentHeight*0.25)
			background[2].x, background[2].y = display.contentCenterX, display.contentCenterY*1.8
			sceneGroup:insert(4,background[2])
			
			background[2] = display.newImageRect("Images/BlipG.png", 50, 25)
			background[2].x, background[2].y = display.contentCenterX*0.3, display.contentCenterY*1.8
			sceneGroup:insert(4,background[2])
			background[3] = display.newImageRect("Images/BlipZ.png", 50, 25)
			background[3].x, background[3].y = display.contentCenterX*0.3, display.contentCenterY*1.7
			sceneGroup:insert(4,background[3])
			background[4] = display.newImageRect("Images/Boost.png", 30, 30)
			background[4].x, background[4].y = display.contentCenterX*0.3, display.contentCenterY*1.6
			sceneGroup:insert(4,background[4])
			
			background[5] = display.newImageRect("Images/BlipG.png", 50, 25)
			background[5].x, background[5].y = display.contentCenterX*1.7, display.contentCenterY*1.8
			sceneGroup:insert(4,background[5])
			background[6] = display.newImageRect("Images/BlipZ.png", 50, 25)
			background[6].x, background[6].y = display.contentCenterX*1.7, display.contentCenterY*1.7
			sceneGroup:insert(4,background[6])
			background[7] = display.newImageRect("Images/Boost.png", 30, 30)
			background[7].x, background[7].y = display.contentCenterX*1.7, display.contentCenterY*1.6
			sceneGroup:insert(4,background[7])
			
			background[8] = display.newImageRect("Images/starback.jpg", display.contentWidth*1.3, display.contentHeight*1.1)
			sceneGroup:insert(1,background[8])
			background[8].x, background[8].y = display.contentCenterX, 0-display.contentCenterY
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
		sceneGroup.isVisible = true
		
		local file, errorString = io.open( path, "r" )
		
		if not file then
			
			print( "File error: " .. errorString )
		else
    local i = 1
			for line in file:lines() do
				
					SCORE[i] = line
					i = i + 1
			end
			
			
			
   
		io.close( file )
		end
		
		local file1, errorString1 = io.open( path1, "r" )
		
		if not file1 then
			
			print( "File error: " .. errorString1 )
		else
    local i = 6
			for line in file1:lines() do
				
					SCORE[i] = line
					i = i + 1
			end
			
			
		io.close( file1 )
		end
		
		
			scores[1].text = ("GLOBALSCORE:"..SCORE[1])
			scores[2].text = ("LASTSCORE:"..SCORE[2])
			scores[3].text = ("TOTALFUEL:"..SCORE[3])
			scores[4].text = ("GLOBALPATH:"..SCORE[4])
			scores[5].text = ("LASTPATH:"..SCORE[5])
			scores[6].text = ("Максимальная прочность:"..SCORE[6])
			scores[7].text = ("Вместимость топливного бака:"..SCORE[7])
		
		
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
		sceneGroup.isVisible = false
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
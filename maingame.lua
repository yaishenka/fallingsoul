local composer = require("composer")
local physics = require("physics")
	physics.start()
	physics.setGravity(0,0)
local data = require("my_Data")
local scene = composer.newScene()
display.setDefault( "textureWrapX", "repeat" )
display.setDefault( "textureWrapY", "repeat" )
--Переменные, не требующие предзагрузки-------------------------------------
----------------------------------------------------------------------------
local w = display.contentWidth
local h = display.contentHeight
local NumberofBeams=0 ----stage 1
local FirstClickInTheFuckingGame = false
local beamstimer
local beam1 = {}
local beam2 = {}
local trackFromMe = {}
local numberBeams = 1
local satantimer
local beams_timer
local timerForTrack
local numberBeams1ForDelete = 1
local numberBeams2ForDelete = 1
local click
local SatanPower=false
local colorR = 0.7
local colorG = 0.7
local colorB = 0.7
local iR = 1
local iG = 1
local iB = 1
local t=850
local numberBat1ForDelete = 1
local numberBat2ForDelete = 1
local bat1 = {}
local bat2 = {}
local BGtransition={}
	BGtransition[1]="background.jpg"
	BGtransition[2]="background1.jpg"
	BGtransition[3]="background2.jpg"

local paintStone = {
    type = "image",
    filename = "wll4.png"
}


local BatsheetOptions =
{
    width = 32,
    height = 32,
    numFrames = 16
}
local sequences_bat = 
    
    {
        name = "normalflight",
        frames = { 2,3,4 },
        time = 400,
        loopCount = 0,
        loopDirection = "forward"
    }

 
local sheet_bat = graphics.newImageSheet( "32x32-bat-sprite.png", BatsheetOptions )

--Объекты-------------------------------------------------------------------
local bg1,bg2,me,Scores
----------------------------------------------------------------------------
local start_text,text_gameOver,text_score,text_highScore,sadSatan1,sadSatan2,upArrow1,upArrow2,bg1f,bg2f
local fakeGameOver = display.newGroup()

------------------------когда очков больше или равно чем установленная--
----------------------- норма счетчик мигает красным (666)--------------
	
local function SatanPowerFunction(event)
		
	
satantimer= timer.performWithDelay (205,function ()
	Scores.text = " Satan666 "
	Scores:setFillColor(1,0,0)
	transition.to (Scores, {time=100,xScale=0.99, yScale=0.99, alpha=0.8, onComplete=function ()
		Scores.text = NumberofBeams
		Scores:setFillColor(0.6,0.6,0.6,1)
		transition.to (Scores, {time=100,xScale=1,yScale=1,alpha=1})
	end})
end,4)
timer.pause (satantimer)
end


local function procent(var)
	local i = math.random(0,100)
	if i<=var then
		return true
	else
		return false
	end
end

--Функции, не требующие предзагрузку	------------------------------------
----------------------------------------------------------------------------
function enterFrame_function( event )
----------------------------------------------------------------------------
----------------------------------------------------------------------------

---увеличение скорости

	t=t-0.1

----скрол заднего фона	
	bg1.y = bg1.y - bg1.vel
	bg2.y = bg2.y - bg2.vel
	bg3.y = bg3.y - bg3.vel

	if bg1.y + bg1.height/2 <=0 then
		bg1.y = bg3.y + h/2
	end

	if bg2.y + bg2.height/2 <=0 then
		bg2.y = bg1.y+h/2
	end

	if bg3.y + bg3.height/2 <=0 then
		bg3.y = bg2.y+h/2
	end		
	bg1:toBack()
	bg2:toBack()
	bg3:toBack()

----------------------------------------------------------------------------
----------------------------------------------------------------------------
----------движение шарика за счет тапа по экрану
	

	me.y = h/3	

	if me.x ~= click then
		me.x = me.x - (me.x - click)/10
	end


	colorR = colorR + iR*1/200
	colorG = colorG + iG*1/200
	colorB = colorB + iB*1/200

	if colorR>=1 or colorR<=0 then
		iR = iR * (-1)
	end
	if colorG>=1 or colorG<=0 then
		iG = iG * (-1)
	end
	if colorB>=1 or colorB<=0 then
		iB = iB * (-1)
	end

	if math.abs(colorR-colorB) < 0.02 and math.abs(colorR - colorG)<0.02 and math.abs(colorB - colorG)<0.02 then
		colorR = colorR + 0.01*iR
		colorB = colorB + 0.01*iB
		colorG = colorG + 0.01*iG
		
	end


	me:setFillColor(colorR,colorG,colorB)
	Scores:setFillColor(colorB,colorR,colorG)

----------------------------------------------------------------------------
----------------------------------------------------------------------------
-----------------чтобы не заходил за края


	if me.x+me.width/2 > w then

		me.x = w - me.width/2

		me.vel = -0.5 * me.vel

	elseif me.x - me.width/2 < 0 then

		me.x = me.width/2

		me.vel = -0.5 * me.vel

	end		

	if (procent(1) == true) then
		iR = iR * (-1)
		
	end
	if (procent(1) == true) then
		iG = iG * (-1)
		
	end
	if (procent(1) == true) then
		iB = iB * (-1)
		
	end

---------------------------------------------------------------------------
---------------------------когда очков больше или равно чем установленная--
-------------------------- норма счетчик мигает красным (666)--------------


	if NumberofBeams>=13 and SatanPower==false then 
		
		SatanPowerFunction()

		SatanPower=true

		timer.resume (satantimer)

	end


----------------------------------------------------------------------------
----------------------------------------------------------------------------
end

----------------------------------------------------------------------------
----------------------------------------------------------------------------
--фокус--
local function Focus( target )
    display.getCurrentStage():setFocus( target )
    target.isFocus = true
end
--
--расфокус--
local function unFocus( target )
    display.getCurrentStage():setFocus( nil )
    target.isFocus = false
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




function scene:create( event )
	
	local sceneGroup = self.view
	--------------------------принтит название сцены------------------------
	------------------------------------------------------------------------
	
	print("Name: "..composer.getSceneName("current"))
	
	------------------------------------------------------------------------
	------------------------------------------------------------------------
	
	
	--Переменные------------------------------------------------------------
	------------------------------------------------------------------------

	

	--Объекты---------------------------------------------------------------
	------------------------------------------------------------------------

	--Задние фоны с 1 по 3--------------------------------------------------
	--(без 1 - красный 1 - фиолетовый  2 - синий----------------------------

	bg1=display.newImage (BGtransition[event.params.bgrandom],w/2,h/4)        
		bg1.width=w
		bg1.height=h/2
		bg1.vel=h/150		
		sceneGroup:insert(bg1)
	bg2=display.newImage (BGtransition[event.params.bgrandom],w/2,h/4+h/2)
		bg2.width=w
		bg2.height=h/2
		bg2.vel=h/150
		sceneGroup:insert(bg2)
	bg3=display.newImage (BGtransition[event.params.bgrandom],w/2,h/4+h)	
		bg3.width=w
		bg3.height=h/2
		bg3.vel=h/150		
		sceneGroup:insert(bg3)
	------------------------------------------------------------------------
	------------------------------------------------------------------------

	
	--главный герой---------------------------------------------------------
	------------------------------------------------------------------------

	me = display.newCircle(w/2,h/3,w/10)   
		me.vel = 0 ---------------------скорость
		me:setFillColor(0.7,0.7,0.7,1)
		--me.strokeWidth = w/400
		--me:setStrokeColor(0.9,0.9,0.9,1)
		physics.addBody(me, "dynamic", {density=100000, bounce=100000, friction=200000, radius = me.width/2.5})
		me.collided = "false" ---------параметр столкновения
		sceneGroup:insert(me)	
	
	------------------------------------------------------------------------
	------------------------------------------------------------------------

	--очки------------------------------------------------------------------
	------------------------------------------------------------------------

	Scores = display.newText({text=""..NumberofBeams.."",x=w/2,y=h/3-me.width*me.xScale*2, font="fonts/desonanz.ttf",fontSize=w/4})
		sceneGroup:insert(Scores)
		Scores:setFillColor(0.6,0.6,0.6,1)	
	
	
	--Объекты для fake_gameover---------------------------------------------
	------------------------------------------------------------------------
	bgf=math.random(1,3)
    bg1f=display.newImage (BGtransition[bgf],w/2,h/4)	 
		bg1f.width=w 									         
		bg1f.height=h/2		
	bg2f=display.newImage (BGtransition[bgf],w/2,h/4+h/2)
		bg2f.width=w
		bg2f.height=h/2
    		
		
    text_gameOver = display.newText({text="Game Over",x=w/2,y=h/15, font="fonts/desonanz.ttf",fontSize=w/7})
		text_gameOver:setFillColor(0.7,0.7,0.7)

    text_score = display.newText({text = "Score = "..NumberofBeams,x =w/2, y = h/2.5, fontSize = w/10, font = "fonts/desonanz.ttf"})
    	text_score:setFillColor(0.7,0.7,0.7)
    text_highScore =  display.newText({text = "HighScore = ",x =w/2, y = h/2.5-text_score.height/2-w/10, fontSize = w/10, font = "fonts/desonanz"})
		text_highScore.text = "HighScore = "..(tonumber(data.loadData("highScore")) or NumberofBeams)
		text_highScore:setFillColor(0.7,0.7,0.7)
	sadSatan1 = display.newImage  ("sadsatan.png",1,1)
		sadSatan1.xScale=0.075
		sadSatan1.yScale=0.075
		sadSatan1.x=text_gameOver.x-(text_gameOver.width*text_gameOver.xScale/2)-sadSatan1.width*sadSatan1.xScale/2
		sadSatan1.y=text_gameOver.y	    	
	sadSatan2 = display.newImage  ("sadsatan.png",1,1)
		sadSatan2.xScale=0.075
		sadSatan2.yScale=0.075
		sadSatan2.x=text_gameOver.x+(text_gameOver.width*text_gameOver.xScale/2)+sadSatan2.width*sadSatan2.xScale/2
		sadSatan2.y=text_gameOver.y
	upArrow1=display.newImage ("uparrow.png",1,1)
		upArrow1.xScale=0.35
		upArrow1.yScale=0.35
		upArrow1.x=upArrow1.width*upArrow1.xScale/2
		upArrow1.y=h-upArrow1.height*upArrow1.yScale/2
		upArrow1.alpha=0.7
	upArrow2=display.newImage ("uparrow.png",1,1)
		upArrow2.xScale=0.35
		upArrow2.yScale=0.35
		upArrow2.x=w-upArrow2.width*upArrow2.xScale/2
		upArrow2.y=h-upArrow2.height*upArrow2.yScale/2
		upArrow2.alpha=0.7
	start_text = display.newText ({text = "Let`s fall ",x =w/2, y = h/8, fontSize = w/7, font = "fonts/desonanz"})
	    start_text.y=upArrow1.y
	    start_text.x=w/2
	    start_text:setFillColor(0.7,0.7,0.7)
	fakeGameOver:insert(bg1f)
    fakeGameOver:insert(bg2f)
    fakeGameOver:insert(text_score)
    fakeGameOver:insert(text_highScore)
    fakeGameOver:insert(text_gameOver)
    fakeGameOver:insert(sadSatan1)
    fakeGameOver:insert(sadSatan2)
    fakeGameOver:insert(upArrow1)
    fakeGameOver:insert(upArrow2)
    fakeGameOver:insert(start_text)
    fakeGameOver.alpha=0
    fakeGameOver.y = fakeGameOver.y - h
	--Функции---------------------------------------------------------------
	------------------------------------------------------------------------

	

	
	

	------------------------------------------------------------------------
	------------------------------------------------------------------------
	

	--палки-----------------------------------------------------------------
	------------------------------------------------------------------------

	
	local function beams( )

		local width = w/(math.random(17,45)/10) ------случайная ширина палки

		beam1[numberBeams] = display.newRoundedRect(width/2,h+w/40,width,w/20,w/50)
			
			beam1[numberBeams].fill = paintStone
			beam1[numberBeams].fill.scaleX = 128/beam1[numberBeams].width
			beam1[numberBeams].fill.scaleY = 1
			physics.addBody(beam1[numberBeams],"static",{friction=0.5, bounce=0.3, density = 3.0})			
			transition.to(beam1[numberBeams],{time = ((2*h)/3+w/40)/((h+w/20)/(t+450)), y = h/3,onComplete = function() 
					NumberofBeams = NumberofBeams + 1
					Scores.text = NumberofBeams
					transition.to(beam1[numberBeams1ForDelete],{time = (h/3+w/40)/((h+w/20)/(t+450)), y = -w/40,onComplete = function() 
						display.remove(beam1[numberBeams1ForDelete]) 
						numberBeams1ForDelete = numberBeams1ForDelete + 1 end})
				end})

		

		beam2[numberBeams] = display.newRoundedRect(0,h+w/40,w-width-w/3.3,w/20,w/50)
			beam2[numberBeams].fill = paintStone
			beam2[numberBeams].fill.scaleX = 128/beam2[numberBeams].width
			beam2[numberBeams].fill.scaleY = 1
			beam2[numberBeams].x = w - beam2[numberBeams].width/2			
			physics.addBody(beam2[numberBeams],"static",{friction=0.5, bounce=0.3, density = 3.0})
			transition.to(beam2[numberBeams],{time = t+450, y = -w/40, onComplete = function() 
					display.remove(beam2[numberBeams2ForDelete])
					numberBeams2ForDelete = numberBeams2ForDelete + 1 
				end})

		
		sceneGroup:insert(beam1[numberBeams])
		sceneGroup:insert(beam2[numberBeams])


		bat1[numberBeams] = display.newSprite( sheet_bat, sequences_bat )
			bat1[numberBeams].yScale=5
			bat1[numberBeams].xScale=5
			physics.addBody(bat1[numberBeams],"static",{friction=0.5, bounce=0.3, density = 3.0})
			bat1[numberBeams].y = beam1[numberBeams].y-bat1[numberBeams].height*bat1[numberBeams].yScale/2		
			bat1[numberBeams].x=beam1[numberBeams].x - (bat1[numberBeams].width*bat1[numberBeams].xScale/2) + beam1[numberBeams].width*beam1[numberBeams].xScale/2	
			bat1[numberBeams]:setSequence( "normalflight" ) 
			bat1[numberBeams]:play()
		transition.to(bat1[numberBeams],{time = t+400, y = -w/40, onComplete = function() 
					bat1[numberBat1ForDelete]:pause()
					display.remove(bat1[numberBat1ForDelete])
					numberBat1ForDelete = numberBat1ForDelete + 1 
				end})

		bat2[numberBeams] = display.newSprite( sheet_bat, sequences_bat )
			bat2[numberBeams].yScale=5
			bat2[numberBeams].xScale=5
			physics.addBody(bat2[numberBeams],"static",{friction=0.5, bounce=0.3, density = 3.0})
			bat2[numberBeams].y = beam1[numberBeams].y-bat2[numberBeams].height*bat2[numberBeams].yScale/2	
			bat2[numberBeams].x=beam2[numberBeams].x + (bat2[numberBeams].width*bat2[numberBeams].xScale/2) - beam2[numberBeams].width*beam2[numberBeams].xScale/2			
			bat2[numberBeams]:setSequence( "normalflight" ) 
			bat2[numberBeams]:play()
		transition.to(bat2[numberBeams],{time = t+400, y = -w/40, onComplete = function() 
					bat2[numberBat2ForDelete]:pause()
					display.remove(bat2[numberBat2ForDelete])
					numberBat2ForDelete = numberBat2ForDelete + 1 
				end})
		sceneGroup:insert(bat1[numberBeams])
		sceneGroup:insert(bat2[numberBeams])
			
		
		numberBeams = numberBeams + 1 

	end
	

	beams_timer = timer.performWithDelay(750,beams,-1)
	timer.pause(beams_timer)
	

	------------------------------------------------------------------------
	------------------------------------------------------------------------
	------------------------------------------------------------------------
	------------------------------------------------------------------------

	

	--столкновение----------------------------------------------------------
	------------------------------------------------------------------------

	
	local function onLocalCollision( event )
 
    	if ( event.phase == "began" ) then  		    		
    		
    		transition.cancel()
    		fakeGameOver.alpha=1
    		Runtime:removeEventListener("enterFrame",enterFrame_function)
    		Runtime:removeEventListener("touch",touch_function)

    		
    		timer.pause(beams_timer)
    		timer.pause(timerForTrack) 		
    		
    		transition.to(fakeGameOver,{time = 300, y = 0, onComplete = function()     				
    		display.remove(bg1nf)
    		display.remove(bg2nf)
    		display.remove(text_score)
    		display.remove(text_gameOver)
    		display.remove(text_highScore)
    		display.remove(sadSatan1)
    		display.remove(sadSatan2)
    		display.remove(upArrow1)
    		display.remove(upArrow2)
    		display.remove(start_text)
    		display.remove(fakeGameOver)

    		me:removeEventListener("collision",onLocalCollision)
 			composer.gotoScene("gameover",{params = {score = NumberofBeams,BGrandom=bgf}})

    		end})
    	
    	--------------------------------------------------------------------
		-------------------------------------------------------------------- 			

    	elseif ( event.phase == "ended") then				
  		
  		end
	end
	

	------------------------------------------------------------------------
	------------------------------------------------------------------------
	------------------------------------------------------------------------
	------------------------------------------------------------------------




	--функция нажатия-------------------------------------------------------
	------------------------------------------------------------------------

	
	function touch_function(event)
		if event.phase == "began" then

			if FirstClickInTheFuckingGame == false then

				

				FirstClickInTheFuckingGame=true
		
				Runtime:addEventListener("enterFrame",enterFrame_function)

				me:addEventListener("collision",onLocalCollision)
				
				timer.resume(beams_timer)
				timer.resume(timerForTrack)

			end

			click = event.x

		elseif event.phase == "moved" then

			click = event.x

		elseif event.phase == "ended" then

			click = me.x

		end
	end
	Runtime:addEventListener("touch",touch_function)
	

	------------------------------------------------------------------------
	------------------------------------------------------------------------
	------------------------------------------------------------------------
	------------------------------------------------------------------------



	--след------------------------------------------------------------------
	------------------------------------------------------------------------


	--[[timerForTrack = timer.performWithDelay(1000/60,function()
		for i = 1,1 do
			local trackFromMe = display.newCircle(me.x,me.y,w/10)
				sceneGroup:insert(trackFromMe)
				trackFromMe:setFillColor(0.8,0.8,0.8,0.1)
				trackFromMe:toBack()
				Scores:toFront()
				me:toFront()

				transition.to(trackFromMe,{time = 2000, y = -h,x = math.random(0,w),xScale = 0.01, yScale = 0.01,alpha = 0,onComplete = function() 
					display.remove(trackFromMe) end})				
		end
	
	end,-1)]]--

	local function func(slide)
		slide:setFillColor(colorR,colorG,colorB)
	end

	timerForTrack=timer.performWithDelay(1000/60,function ()
		local slide = display.newCircle(me.x,h/3,w/10)
		sceneGroup:insert(slide)
		slide:toBack()
		slide:setFillColor(colorR,colorG,colorB)
		transition.to(slide,{time = t, y = 0-w/5, xScale = 0.1, yScale = 0.1, onComplete = function() display.remove(slide) end})
	end,-1)
	
	timer.pause(timerForTrack)
	

	------------------------------------------------------------------------
	------------------------------------------------------------------------
	------------------------------------------------------------------------
	------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------








end

function scene:show( event )
	
	local sceneGroup = self.view

	

	if event.phase == "will" then

		composer.removeScene("menu") 
		composer.removeScene("gameover") 	

	elseif event.phase == "did" then	
	
	end

end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function scene:hide( event )
	
	local sceneGroup = self.view

	if event.phase == "will" then
		Runtime:removeEventListener("enterFrame",enterFrame_function)
		Runtime:removeEventListener("touch",touch_function)

		FirstClickInTheFuckingGame = false

	elseif event.phase == "did" then

	end

end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function scene:destroy( event )
	
	local sceneGroup = self.view

end

scene:addEventListener("create",scene)
scene:addEventListener("show",scene)
scene:addEventListener("hide",scene)
scene:addEventListener("destroy",scene)

return scene
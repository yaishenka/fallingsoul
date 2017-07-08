local composer = require("composer")
local data = require("my_Data")

local scene = composer.newScene()

--Переменные, не требующие предзагрузки-------------------------------------
----------------------------------------------------------------------------

local w = display.contentWidth
local h = display.contentHeight
local highScore = tonumber(data.loadData("highScore")) or 0
local text_score,text_highScore,GameOver_text,bg1nf,bg2nf,bg,bg1,bg2,me,scores,sadSatan1,sadSatan2,upArrow1,upArrow2,start_text
local time = 0
local time_timer=50
local timerForAnim
local colorR = 0.7
local colorG = 0.7
local colorB = 0.7
local iR = 1
local iG = 1
local iB = 1

local sadSatanTimer
local BGtransition={}
	BGtransition[1]="background.jpg"
	BGtransition[2]="background1.jpg"
	BGtransition[3]="background2.jpg"



--объекты-------------------------------------------------------------------
----------------------------------------------------------------------------

local bg1,bg2,bg1nf,bg2nf,me,Scores
local fakeGame = display.newGroup()

----------------------------------------------------------------------------
----------------------------------------------------------------------------


--Функции, не требующие предзагрузку	------------------------------------
----------------------------------------------------------------------------




local function procent(var)
	local i = math.random(0,100)
	if i<=var then
		return true
	else
		return false
	end
end
function enterFrame_function( event )
	



	colorR = colorR + iR*1/200
	GameOver_text:setFillColor (colorR,colorG,colorB)
	text_highScore:setFillColor (colorR,colorG,colorB)
	text_score:setFillColor (colorR,colorG,colorB)
	start_text:setFillColor (colorR,colorG,colorB)
	if colorR>=1 or colorR<=0 then
		iR = iR * (-1)
	end
	if colorG>=1 or colorR<=0 then
		iG = iG * (-1)
	end
	if colorB>=1 or colorR<=0 then
		iB = iB * (-1)
	end
	colorG = colorG + iG*1/200
	colorB = colorB + iB*1/200
	if (procent(1) == true) then
		iR = iR * (-1)
	end
	if (procent(1) == true) then
		iG = iG * (-1)
	end
	if (procent(1) == true) then
		iB = iB * (-1)
	end
	if math.abs(colorR-colorB) < 0.02 and math.abs(colorR - colorG)<0.02 and math.abs(colorB - colorG)<0.02 then
		colorR = colorR + 0.01*iR
		colorB = colorB + 0.01*iB
		colorG = colorG + 0.01*iG
		
	end
end
----------------------------------------------------------------------------
----------------------------------------------------------------------------

timerForAnim = timer.performWithDelay(1000/60, function() 
	time = time + 1000/60 end,-1)
timer.pause(timerForAnim)

----------------------------------------------------------------------------
----------------------------------------------------------------------------



-----------------Смахивание шторки------------------------------------------
----------------------------------------------------------------------------

local function bgTouchFunction(event)
	if event.phase == "began" then

		Runtime:removeEventListener("enterFrame",enterFrame_function)
		timer.pause(sadSatanTimer)
		timer.pause(arrowTimer)
		transition.cancel()

		event.target.parametr = true

		event.target.beganY = event.target.y

		event.target.velocity = 0

		timer.resume(timerForAnim)

	elseif event.phase == ("ended" or "cancelled") and event.target.parametr == true then

		event.target.parametr = false

		timer.pause(timerForAnim)
		event.target.velocity = math.abs(event.target.beganY - event.target.y)/time
		time = 0

		if event.target.velocity >= w/100 then 

			composer.removeScene("maingame")

			transition.to(event.target,{time = (h)/event.target.velocity, y = event.target.y - h,onComplete = function()  
				
				display.remove (bg1nf)
				display.remove (bg2nf)

				display.remove (text_score)
				display.remove (text_highScore)
				display.remove (GameOver_text)				
				display.remove (sadSatan1)
				display.remove (sadSatan2)
				display.remove (upArrow1)
				display.remove (upArrow2)
				display.remove (start_text)
				display.remove (sceneGroup)

				composer.gotoScene("maingame",{params={bgrandom = bg}}) end})			

		else

			
			transition.to(event.target,{time = 450, y = 0, transition = easing.inQuart})
			Runtime:addEventListener("enterFrame",enterFrame_function)
			timer.resume(sadSatanTimer)
			timer.resume(arrowTimer)
		end	

	elseif event.phase == "moved" and event.target.parametr == true then

		event.target.y = event.y - event.yStart + event.target.beganY

		if event.target.y >= 0 then
			
			event.target.y = 0
		
		end

	end
end

----------------------------------------------------------------------------
----------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function scene:create( event )
	
	local sceneGroup = self.view
	--Объекты-----------------------------------------------------------
		--------------------------------------------------------------------

		--------------nf-not fake-------------------------------------------
	    --------------------------------------------------------------------

		bg1nf=display.newImage (BGtransition[event.params.BGrandom],w/2,h/4)		-----два фона--
			bg1nf.width=w 									 						-----чтобы не--
			bg1nf.height=h/2							     						--растягивать--
								         					 						-----картинку--
		
		bg2nf=display.newImage (BGtransition[event.params.BGrandom],w/2,h/4+h/2)
			bg2nf.width=w
			bg2nf.height=h/2
		--------------------------------------------------------------------
	    --------------------------------------------------------------------

		text_score = display.newText({text = "Score = "..event.params.score,x =w/2, y = h/2.5, fontSize = w/10, font = "fonts/desonanz.ttf"})
			

		--------------------------------------------------------------------
	    --------------------------------------------------------------------

		text_highScore = display.newText({text = "HighScore = ",x =w/2, y = h/2.5-text_score.height/2-w/10, fontSize = w/10, font = "fonts/desonanz"})
			
			--------------------------------------------------------------------
	    --HighScore---------------------------------------------------------
		if event.params.score > highScore then
			
			highScore = event.params.score		
			data.saveData("highScore",highScore)
		
		end
		--------------------------------------------------------------------
	    --------------------------------------------------------------------

		--Изменение текста--------------------------------------------------
		text_highScore.text = text_highScore.text..highScore
		--------------------------------------------------------------------
	    --------------------------------------------------------------------

		--------------------------------------------------------------------
	    --------------------------------------------------------------------
		
		GameOver_text = display.newText({text="Game Over",x=w/2,y=h/15, font="fonts/desonanz.ttf",fontSize=w/7})
			
			GameOver_text:setFillColor(0.4,0,0)
			

		--------------------------------------------------------------------
	    --------------------------------------------------------------------
	    sadSatan1 = display.newImage  ("sadsatan.png",1,1)
	    	sadSatan1.xScale=0.075
	    	sadSatan1.yScale=0.075	    	
	    	sadSatan1.x=GameOver_text.x-(GameOver_text.width*GameOver_text.xScale/2)-sadSatan1.width*sadSatan1.xScale/2
	    	sadSatan1.y=GameOver_text.y
	    	
	    sadSatan2 = display.newImage  ("sadsatan.png",1,1)
	    	sadSatan2.xScale=0.075
	    	sadSatan2.yScale=0.075
	    	sadSatan2.x=GameOver_text.x+(GameOver_text.width*GameOver_text.xScale/2)+sadSatan2.width*sadSatan2.xScale/2
	    	sadSatan2.y=GameOver_text.y	
	    
	    upArrow1=display.newImage ("uparrow.png",1,1)
	    	upArrow1.xScale=0.35
	    	upArrow1.yScale=0.35
	    	upArrow1.x=upArrow1.width*upArrow1.xScale/2
	    	upArrow1.y=h-upArrow1.height*upArrow1.yScale/2    	
	    	upArrow1.alpha=0.7
	    upArrow2=display.newImage ("uparrow.png",1,1)
	    	upArrow2.xScale=0.35
	    	upArrow2.yScale=0.35
	    	upArrow2.y=h-upArrow2.height*upArrow2.yScale/2
	    	upArrow2.x=w-upArrow2.width*upArrow2.xScale/2	    	
	    	upArrow2.alpha=0.7    

	    
	    start_text = display.newText ({text = "Let`s fall ",x =w/2, y = h/8, fontSize = w/7, font = "fonts/desonanz"})
	    	start_text.y=upArrow1.y
	    	start_text.x=w/2
		-----------------------------------мерцание стрелок-----------------
	    --------------------------------------------------------------------



	    arrowTimer=timer.performWithDelay (1000,function ( )		
			
			transition.to (upArrow1, {time=500,alpha=0.3, onComplete=function () 
				transition.to (upArrow1,{time=500, alpha=0.7})
			end})
			transition.to (upArrow2, {time=500,alpha=0.3, onComplete=function () 
				transition.to (upArrow2,{time=500, alpha=0.7})
			end})				
		end,-1)

	    
		--------------------------------------------------------------------
		
	    ------------мерцание дьяволов---------------------------------------
	    --------------------------------------------------------------------	    
	    sadSatanTimer=timer.performWithDelay (1000,function ( )		
			
			transition.to (sadSatan1, {time=500,alpha=0.5, onComplete=function () 
				transition.to (sadSatan1,{time=500, alpha=1})
			end})
			transition.to (sadSatan2, {time=500,alpha=0.5, onComplete=function () 
				transition.to (sadSatan2,{time=500, alpha=1})
			end})				
		end,-1)

	    --------------------------------------------------------------------
	    --------------------------------------------------------------------

	    
	    

	    
		
		--------------------------------------------------------------------
	    -------------------------------------------------------------------

		--Добавление в сценгруппу-------------------------------------------

		sceneGroup:insert(bg1nf)
		sceneGroup:insert(bg2nf)
		sceneGroup:insert(text_score)
		sceneGroup:insert(text_highScore)
		sceneGroup:insert(GameOver_text)
		sceneGroup:insert(sadSatan1)
		sceneGroup:insert(sadSatan2)
		sceneGroup:insert(upArrow1)
		sceneGroup:insert(upArrow2)
		sceneGroup:insert(start_text)
		--------------------------------------------------------------------
	    --------------------------------------------------------------------

end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function scene:show( event )
	
	local sceneGroup = self.view

	if event.phase == "will" then
		sceneGroup:toFront()
	
		

		--------------------------------------------------------------------
	    --------------------------------------------------------------------
	    
	    
	   
	    
	    

		---------------Объекты для fake game--------------------------------
	    --------------------------------------------------------------------

	    bg=math.random(1,3)
	    
	    bg1=display.newImage (BGtransition[bg],w/2,h/4)	     -----два фона--
			bg1.width=w 									 -----чтобы не--
			bg1.height=h/2									 --растягивать--
			fakeGame:insert(bg1)					         -----картинку--
		
		bg2=display.newImage (BGtransition[bg],w/2,h/4+h/2)
			bg2.width=w
			bg2.height=h/2
			fakeGame:insert(bg2)
		

		me = display.newCircle(w/2,h/3,w/10)   ------шарик------------------
			me:setFillColor(0.7,0.7,0.7,1)			
			fakeGame:insert(me)

		Scores = display.newText({text="0",x=w/2,y=h/3-me.width*me.xScale*2, font="fonts/desonanz.ttf",fontSize=w/4})
			fakeGame:insert(Scores)
			Scores:setFillColor(0.6,0.6,0.6,1)

		fakeGame:toBack()
        
		

		
		--------------------------------------------------------------------
	    --------------------------------------------------------------------
	
	elseif event.phase == "did" then
		--Добавление листенера----------------------------------------------
		Runtime:addEventListener("enterFrame",enterFrame_function)
		sceneGroup:addEventListener("touch",bgTouchFunction)	
		--------------------------------------------------------------------	
	end

end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function scene:hide( event )
	
	local sceneGroup = self.view

	if event.phase == "will" then
	--------------------------------------------------------------------
	--------------------------------------------------------------------	
		
		sceneGroup:removeEventListener("touch",bgTouchFunction)	
		Runtime:removeEventListener("enterFrame",enterFrame_function)
		timer.pause(sadSatanTimer)
		timer.pause(arrowTimer)		
		
		display.remove(me)
		display.remove(bg1)
		display.remove(bg2)
		display.remove(Scores)

	

	--------------------------------------------------------------------
	--------------------------------------------------------------------
	


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
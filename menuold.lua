





local composer = require("composer")
local data = require("my_Data")
local scene = composer.newScene()

--Переменные, не требующие предзагрузки-------------------------------------
----------------------------------------------------------------------------
local w = display.contentWidth
local h = display.contentHeight
local HighScore = tonumber(data.loadData("highScore")) or 0
local time = 0
local BGtransition={}
	BGtransition[1]="background.jpg"
	BGtransition[2]="background1.jpg"
	BGtransition[3]="background2.jpg"
local BGrandom

--объекты-------------------------------------------------------------------
----------------------------------------------------------------------------
local bg1M,bg2M,b1G,bg2G, highScore_text, start_text,me,Scores,start_back,highScore_back,timerForAnim
local fakeGame = display.newGroup()


--Функции, не требующие предзагрузку	------------------------------------
----------------------------------------------------------------------------


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

	--Переменные------------------------------------------------------------
	------------------------------------------------------------------------

	

	--Объекты---------------------------------------------------------------
	------------------------------------------------------------------------
	

	--Задние фоны-----------------------------------------------------------
	--(без 1 - красный 1 - фиолетовый  2 - синий----------------------------

	BGrandom=math.random (1,3)
	bg1M=display.newImage (BGtransition[BGrandom],w/2,h/4)
		bg1M.width = w
		bg1M.height = h/2
		sceneGroup:insert (bg1M)
	bg2M=display.newImage (BGtransition[BGrandom],w/2,h/4+h/2)
		bg2M.width = w
		bg2M.height = h/2
		sceneGroup:insert (bg2M)

	------------------------------------------------------------------------
	------------------------------------------------------------------------

	highScore_back = display.newRect(w/2,h/3,w/1.1,h/10)
	highScore_back:setFillColor(0.4,0.5,0.9)
	highScore_back.strokeWidth = w/100
	highScore_back:setStrokeColor(0.2,0.3,0.7)
	sceneGroup:insert(highScore_back)

	highScore_text =  display.newText({text = "HighScore = ",x =w/2, y = h/3, fontSize = w/10, font = "fonts/desonanz"})
		highScore_text.text = "HighScore = "..HighScore
		highScore_text:setFillColor(0.2,0.1,0.9)
		sceneGroup:insert (highScore_text)

	------------------------------------------------------------------------
	------------------------------------------------------------------------

	start_back = display.newRect(w/2,h-h/6,w/1.5,h/4)
	start_back:setFillColor(199/255,96/255,225/255)
	start_back.strokeWidth = w/100
	start_back:setStrokeColor(144/255,30/255,172/255)
	sceneGroup:insert(start_back)

	start_text = display.newText({text = " Let`s fall ",x =w/2, y = h-h/6, fontSize = w/8, font = "fonts/desonanz"})
		start_text:setFillColor(205/255,0/255,255/255)	

		sceneGroup:insert (start_text)
				
	



	

	--Функции---------------------------------------------------------------
	------------------------------------------------------------------------
	timerForAnim = timer.performWithDelay(1000/60, function () time = time + 1000/60 end,-1)
	timer.pause(timerForAnim)
	
	------------------------------------------------------------------------
	------------------------------------------------------------------------
				
	
	start_back:addEventListener("touch",function(event)
			if event.phase == "began" then

				Focus(event.target)

				start_text:setFillColor(190/255,1/255,240/255)	

				sceneGroup.beganY = sceneGroup.y

				transition.cancel()

				event.target.parametr = true

				event.target.velocity = 0

				timer.resume(timerForAnim)

			elseif event.phase == ("ended" or "cancelled") and event.target.parametr == true then

				start_text:setFillColor(205/255,0/255,225/255)

				unFocus(event.target)

				event.target.parametr = false

				timer.pause(timerForAnim)

				event.target.velocity = math.abs(sceneGroup.beganY - sceneGroup.y)/time

				time = 0

				if event.target.velocity >= (w/5)/30 then 

					transition.to(sceneGroup,{time = (h-math.abs(sceneGroup.beganY - sceneGroup.y))/event.target.velocity, y = -h,onComplete = function()  
						composer.gotoScene("maingame",{params={bgrandom = BGrandom}}) end})			

				else

					transition.to(sceneGroup,{time = 450, y = 0, transition = easing.inQuart})
		
				end	

			elseif event.phase == "moved" and event.target.parametr == true then

				sceneGroup.y = event.y - event.yStart + sceneGroup.beganY

				if sceneGroup.y >= 0 then
			
					sceneGroup.y = 0
		
				end

			end
		end)

	------------------------------------------------------------------------
	------------------------------------------------------------------------


end

function scene:show( event )
	
	local sceneGroup = self.view

	if event.phase == "will" then

	elseif event.phase == "did" then
	---------------Объекты для fake game--------------------------------
	--------------------------------------------------------------------

	BGrandom= math.random (1,3) 
	bg1G=display.newImage (BGtransition[BGrandom],w/2,h/4)-----два фона-
		bg1G.width=w 									 -----чтобы не--
		bg1G.height=h/2									 --растягивать--
		fakeGame:insert(bg1G)					         -----картинку--
		
	bg2G=display.newImage (BGtransition[BGrandom],w/2,h/4+h/2)
		bg2G.width=w
		bg2G.height=h/2
		fakeGame:insert(bg2G)
		

	me = display.newCircle(w/2,h/3,w/10)   ------шарик------------------
		me.vel = 0
		me:setFillColor(0.8,0.8,0.8)
		me.strokeWidth = w/400
		me:setStrokeColor(0.9,0.9,0.9)
		fakeGame:insert(me)

	Scores = display.newText({text="0",x=w/2,y=h/3-me.width*me.xScale*2, font="fonts/desonanz.ttf",fontSize=w/4})
		fakeGame:insert(Scores)
		Scores:setFillColor(0.6,0.6,0.6,1)

	fakeGame:toBack()	
	end

end

function scene:hide( event )
	
	local sceneGroup = self.view

	if event.phase == "will" then
		display.remove (bg1M)
		display.remove (bg2M)
		display.remove (bg1G)
		display.remove (bg2G)
		display.remove (start_text)
		display.remove (highScore_text)
	elseif event.phase == "did" then

	end

end

function scene:destroy( event )
	
	local sceneGroup = self.view

end

scene:addEventListener("create",scene)
scene:addEventListener("show",scene)
scene:addEventListener("hide",scene)
scene:addEventListener("destroy",scene)

return scene
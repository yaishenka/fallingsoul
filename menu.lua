





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
local BGrandom=math.random (1,3)
local colorR = 0.7
local colorG = 0.7
local colorB = 0.7
local iR = 1
local iG = 1
local iB = 1

--объекты-------------------------------------------------------------------
----------------------------------------------------------------------------
local bg1M,bg2M,b1G,bg2G, highScore_text, start_text,me,Scores,start_back,highScore_back,timerForAnim
local fakeGame = display.newGroup()


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
	highScore_text:setFillColor (colorR,colorG,colorB)
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
	satan=display.newImage ("satan.png",w/2,h/2)
		satan.xScale=satan.xScale*2
		satan.yScale=satan.yScale*2
		satan.y=h+satan.height*satan.yScale/2
		sceneGroup:insert (satan)
		satan.alpha=0

	

	highScore_text =  display.newText({text = "HighScore = ",x =w/2, y = h/8, fontSize = w/7, font = "fonts/desonanz"})
		highScore_text.text = "HighScore = "..HighScore
		highScore_text:setFillColor(1,0,0)
		highScore_text.y=-highScore_text.height/2
		sceneGroup:insert (highScore_text)
		alpha=0
	jesus=display.newImage ("jesus2.png",w/2,h/2)
		jesus.y=highScore_text.y+jesus.height/2
		jesus.x=highScore_text.x+highScore_text.width/2.4		
		sceneGroup:insert (jesus)
		jesus.alpha=0
	start_text = display.newText ({text = "Let`s fall ",x =w/2, y = h/8, fontSize = w/7, font = "fonts/desonanz"})	
		start_text.y=h-start_text.height+satan.height*satan.yScale/2
		start_text.x=satan.x
		start_text:setFillColor(1,0,0)
		sceneGroup:insert (start_text)
		start_text.alpha=0



	------------------------------------------------------------------------
	------------------------------------------------------------------------

	

	

	------------------------------------------------------------------------
	------------------------------------------------------------------------

	
				
	



	

	--Функции---------------------------------------------------------------
	------------------------------------------------------------------------
	function touchfunction( event)
	 	
	  
		if event.phase == "began" then
			
			
			transition.to (sceneGroup, {time=400,y=-h, onComplete = function()  
						composer.gotoScene("maingame",{params={bgrandom = BGrandom}}) end})	
		end
	end
	satan:addEventListener("touch",touchfunction)
	
	------------------------------------------------------------------------
	------------------------------------------------------------------------
				
	
	

	------------------------------------------------------------------------
	------------------------------------------------------------------------


end

function scene:show( event )
	
	local sceneGroup = self.view

	if event.phase == "will" then

	elseif event.phase == "did" then
		transition.to (highScore_text, {time=300,alpha=1,y=h/8})
		transition.to (satan, {time=300,alpha=1,y=h-satan.height*satan.yScale/2})
		transition.to (jesus, {time=300,alpha=1,y=h/8+jesus.height/1.5})
		transition.to (start_text, {time=300,alpha=1,y=h-satan.height*satan.yScale})
		Runtime:addEventListener("enterFrame",enterFrame_function)


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
		me:setFillColor(0.7,0.7,0.7)
		--me.strokeWidth = w/400
		--me:setStrokeColor(0.9,0.9,0.9)
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
		Runtime:removeEventListener("enterFrame",enterFrame_function)
		satan:removeEventListener("touch",touchfunction)
		display.remove (bg1M)
		display.remove (bg2M)
		display.remove (bg1G)
		display.remove (bg2G)
		display.remove (start_text)
		display.remove (highScore_text)
		display.remove (satan)
		display.remove (jesus)
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
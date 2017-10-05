cursor={
	x=0,
	y=0
}

coordX = {}
coordY = {}

for i=1, 10000 do
	coordX[i] = 0
	coordY[i] = 0
end

numCoord = 0


function love.load()
	strebelle = love.graphics.newImage("images/Strebelle_B&W_250x250.bmp")
	love.window.setMode(250, 250)
end


function love.update(dt)
	cursor.x = love.mouse.getX()
	cursor.y = love.mouse.getY()
end


function love.draw()
	love.graphics.setColor(255,255,255) 
	love.graphics.draw(strebelle, 0,0)
	
	love.graphics.setColor(255,0,0)
	love.graphics.circle("fill", cursor.x, cursor.y, 15, 100)
	
  if (isCircle) then
		numCoord = numCoord + 1;
		coordX[numCoord] = cursor.x;
   		coordY[numCoord] = cursor.y;
   		isCircle = false
   	end
	print(numCoord)
  
	for i=1, numCoord do
		love.graphics.circle("fill", coordX[i], coordY[i], 15, 100)
	end
   	
end

function love.mousepressed(x, y, button)
   if button == 1 then -- Versions prior to 0.10.0 use the MouseConstant 'l'
    isCircle = true
		--love.graphics.setColor(255, 0,0);
		--love.graphics.circle("fill", x, y, 50, 1000)
   end
end

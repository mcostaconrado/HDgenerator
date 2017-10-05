cursor={
	x=0,
	y=0
}

radius = 5
coordX = {}
coordY = {} 

for i=1, 10000 do
	coordX[i] = 0
	coordY[i] = 0
end

numCoord = 0
window_Size = 1000

function love.load()
	strebelle = love.graphics.newImage("images/Strebelle_B_W_250x250.jpg")
	love.window.setMode(window_Size, window_Size)

end

function love.update(dt)
	cursor.x = love.mouse.getX()
	cursor.y = love.mouse.getY()
end


function love.draw()
	love.graphics.setColor(255,255,255) 
	love.graphics.draw(strebelle, 0,0)
  
	
	love.graphics.setColor(255,0,0)
	love.graphics.circle("fill", cursor.x, cursor.y, radius, 100)
	
  if (isCircle) then
    numCoord = numCoord + 1;
    coordX[numCoord] = cursor.x;
    coordY[numCoord] = cursor.y;
    isCircle = false
  end
  
	for i=1, numCoord do
		love.graphics.circle("fill", coordX[i], coordY[i], radius, 100)
	end	
   	
end

function love.mousepressed(x, y, button)
   if button == "l" or button == 1 then -- Versions prior to 0.10.0 use the MouseConstant 'l'
   		isCircle = true
		--love.graphics.setColor(255, 0,0);
		--love.graphics.circle("fill", x, y, 50, 1000)
   end
end

function love.keypressed(escape)
  love.event.quit()
end

function love.quit()
  local file = io.open("HDLIST.txt", "w")
  for i=1, numCoord do
    file:write(coordX[i].." "..coordY[i].." 0".."\n")
  end
  file:close()
end


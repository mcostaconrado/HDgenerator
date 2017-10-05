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

HD = {
	radius;
	numPoints = 0;
}

strebelle = {
	image,
	size={
		x,
		y
	};
}

function love.load()

	data = love.filesystem.newFile("data.txt")
	data:open("w")
	
	local i = 1
	local parameters = {}
	
	for word in love.filesystem.lines("file.txt", " ") do
		parameters[i] = word
		i = i + 1
	end
	
	strebelle.size.x = parameters[1]
	strebelle.size.y = parameters[2]
	HD.radius = parameters[3]
	
	strebelle.image = love.graphics.newImage("images/Strebelle_B&W_" .. strebelle.size.x .. "x" .. strebelle.size.y .. ".bmp")
	love.window.setMode(strebelle.size.x, strebelle.size.y)
	
	data:close()
end


function love.update(dt)
	cursor.x = love.mouse.getX()
	cursor.y = love.mouse.getY()
	
	if (isCircle) then
		coordX[HD.numPoints] = cursor.x;
   		coordY[HD.numPoints] = cursor.y;
   		isCircle = false
   	end
end


function love.draw()
	love.graphics.setColor(255,255,255) 
	love.graphics.draw(strebelle.image, 0,0)
	
	love.graphics.setColor(255,0,0)
	love.graphics.circle("fill", cursor.x, cursor.y, HD.radius, 100)
	
	for i=1, HD.numPoints do
		love.graphics.circle("fill", coordX[i], coordY[i], HD.radius, 100)
	end	   	
end

function love.mousereleased(x, y, button)
	if button == "l" or button == 1 then -- Versions prior to 0.10.0 use the MouseConstant 'l'
   		isCircle = true
   		HD.numPoints = HD.numPoints + 1
   end
end

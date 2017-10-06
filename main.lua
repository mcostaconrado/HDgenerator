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
	sgems,
	matrix = {}
}

function square(x)
	return x*x
end

function love.load()

	data = love.filesystem.newFile("data.txt")
	data:open("r")
	
	local i = 1
	local parameters = {}
	
	for word in love.filesystem.lines("file.txt", " ") do
		parameters[i] = word
		i = i + 1
	end
	
	strebelle.size.x = tonumber(parameters[1])
	strebelle.size.y = tonumber(parameters[2])
	HD.radius = tonumber(parameters[3])
	
	strebelle.image = love.graphics.newImage("images/Strebelle_B&W_" .. strebelle.size.x .. "x" .. strebelle.size.y .. ".bmp")
	--strebelle.image = love.graphics.newImage("images/Strebelle_B&W_250x250.bmp")
	love.window.setMode(strebelle.size.x, strebelle.size.y)
	
	data:close()
end

function love.update(dt)
	cursor.x = love.mouse.getX()
	cursor.y = love.mouse.getY()
	
	if (cursor.x - HD.radius < 0) then
		cursor.x = HD.radius
	end	
	
	if (cursor.x + HD.radius > strebelle.size.x) then
		cursor.x = strebelle.size.x - HD.radius
	end	
	
	if (cursor.y - HD.radius < 0) then
		cursor.y = HD.radius
	end	
	
	if (cursor.y + HD.radius > strebelle.size.y) then
		cursor.y = strebelle.size.x - HD.radius
	end	
	
	
	
	if (isCircle) then			-- ESTE BLOCO NAO PERMITE QUE UM CÍRCULO SOBREESCREVA OUTRO
		for i=1, HD.numPoints do
			if((math.abs(coordX[i] - cursor.x)) <= HD.radius and (math.abs(coordY[i] - cursor.y)) <= HD.radius) then
				isCircle = false
			end			
		end
	   	
	   	if (isCircle) then
			HD.numPoints = HD.numPoints + 1
			coordX[HD.numPoints] = cursor.x;
			coordY[HD.numPoints] = cursor.y;
			isCircle = false
		end   	
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
	end
end

function love.keypressed(escape)
	love.event.quit()
end

function love.quit()
	--[[strebelle.sgems = love.filesystem.newFile("Strebelle" .. strebelle.size.x .. "x" .. strebelle.size.y .. ".txt")
	strebelle.sgems:open("r")
	
	local aux = {}
	
	for i=1, square(strebelle.size.x) do
		aux[i] = love.filesystem.read(strebelle.sgems, 1)
	end
	
	print(aux)]]--
	
	local file = io.open("Strebelle" .. strebelle.size.x .. "x" .. strebelle.size.y .. ".txt")
	local tbllines = {}
	for j = 1, strebelle.size.y do
		tbllines[j] = {}
		for i = 1, strebelle.size.x do
			tbllines[j][i] = 0
		end
	end
	local i = 1
	local j = 1
	if file then
    	for line in file:lines() do
    		for word in line:gmatch("%w+") do
     			tbllines[i][j] = tonumber(word)
     			i = i + 1
     		end
     		j = j+1
    	end
    	file:close()	
	else
   		error('file not found')
	end	
	
	
	for j=1, strebelle.size.y do
		for i = 1, strebelle.size.x do
			print(tbllines[i][j])
		end
		print("\n")
	end
	
	local file = io.open("HDLIST.txt", "w")
	for current=1, HD.numPoints do
	print(coordX[current], coordY[current])
		for j = coordY[current] - HD.radius, coordY[current] + HD.radius do
			for i = coordX[current] - HD.radius, coordX[current] + HD.radius do 
	  			if (math.sqrt(square(coordX[current] - i) + square(coordY[current] - j)) <= HD.radius) then
					file:write(i-1 .." "..strebelle.size.y - j - 1 .. " 0" .. " " .. tbllines[i][j] .. "\n")
				end
			end
		end
	end
  file:close()
end


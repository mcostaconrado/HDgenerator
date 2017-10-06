-- Program for building simple Hard Data

cursor = {x=0, y=0}
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
  love.filesystem.setIdentity("HardDatas")
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
	
	strebelle.image = love.graphics.newImage("images/Strebelle_B_W_" .. strebelle.size.x .. "x" .. strebelle.size.y .. ".jpg")
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

function love.keypressed(enter)
	love.event.quit()
end

function love.quit()

  -- open Strebelle which will be used to make the matrix
	local f = io.open("images/Strebelle" .. strebelle.size.x .. "x" .. strebelle.size.y .. ".csv", "r")
  --local f = io.open("images/Strebelle_Pixelled.txt", "r")
  -- Inicialize Matrix
	local tbllines = {}
	for i = 1, strebelle.size.x do
		tbllines[i] = {}
		for j = 1, strebelle.size.y do
			tbllines[i][j] = 0
		end
	end
  
  -- read values from the Strebelle_Pixelled
	local i = 0
	local j = 0
  while j < 250 do
    j =j + 1
    n1 = 0
    for i = 1, strebelle.size.x do
      n1 = f:read(1)
      
      if n1 == nil then 
        break 
      end
      if n1 == "," then
        n1 = f:read(1)
      end
      if n1 == "\n" then
        n1 = f:read(1)
      end
      if n1 == "1" or n1 == "2" then
        tbllines[i][j] = n1
        print("<"..i..","..j..">".." - ".. tbllines[i][j])
      end   
    end   
  end
  f:close()
  local count = 0
  for current=1, HD.numPoints do
		for j = coordY[current] - HD.radius, coordY[current] + HD.radius do
			for i = coordX[current] - HD.radius, coordX[current] + HD.radius do 
        if (math.sqrt(square(coordX[current] - i) + square(coordY[current] - j)) <= HD.radius) then
          count = count + 1
        end
			end
		end
	end
  
  
 
  
  -- print HD points in file txt
	local file = io.open("HardDatas/HD"..count.."_"..os.time()..".txt", "w")
	for current=1, HD.numPoints do
    print(coordX[current], coordY[current])
		for j = coordY[current] - HD.radius, coordY[current] + HD.radius do
			for i = coordX[current] - HD.radius, coordX[current] + HD.radius do 
        if (math.sqrt(square(coordX[current] - i) + square(coordY[current] - j)) <= HD.radius) then
          file:write(i-1 .." "..(j - 1).." 0 ".. tbllines[i][j].."\n")
        end
			end
		end
	end
  file:close()
 
  local screenshot = love.graphics.newScreenshot()
  screenshot:encode("png", "HD"..count..".png")
  
end


local tArgs = { ... }
if #tArgs ~= 1 then
	term.clear()
	print("Akira's excavation manager 1.0")
	print("")
	print("Enter size to excavate")
	print("")
	repeat
		print("How far ? :")
		excavationFar = tonumber(read())
	until excavationFar > 0
	repeat
		print("How wide ? :")
		excavationWide = tonumber(read())
	until excavationWide > 0
	--repeat
	--	print("How deep ? :")
	--	excavationDeep = tonumber(read())
	--until excavationWide > 0
	repeat
		print("Number of Chests ?( 0 to ...) :")
		numberChests = tonumber(read())
	until numberChests >= 0 
else
	local size = tonumber( tArgs[1] )
	if size < 1 then
		print( "Excavate diameter must be positive" )
		return
	else
		excavationFar = size
		excavationWide = size
	end
end



-- Mine in a quarry pattern until we hit something we can't dig
	
local depth = 0
local unloaded = 0
local collected = 0

local xPos,zPos = 0,0
local xDir,zDir = 0,1

local goTo -- Filled in further down
goToMode = false -- when true does does dig up and down in tryForward()
local refuel -- Filled in further down

-- local function unload()
	-- print( "Unloading items..." )
	-- for n=1,16 do
		-- unloaded = unloaded + turtle.getItemCount(n)
		-- turtle.select(n)
		-- turtle.drop()
	-- end
	-- collected = 0
	-- turtle.select(1)
-- end

local function unload(nChests)
	if nChest == "0" then return end

        print( "Unloading items..." )
        turtle.up()
        turtle.up()
        turtle.turnRight()
        turtle.turnRight()
        turtle.forward()

        for blockType=1, nChests-1 do -- Cobble, dirt, gravel etc
                for n=1,16 do
                        turtle.select(n)
                        if turtle.compareDown() then
                                while not turtle.drop() do
                                        print("ERROR: Chest is full!")
                                        print("Hit a key to try again")
                                        read()
                                end
                                unloaded = unloaded + turtle.getItemCount(n)
                        end
                end
                turtle.turnRight()
                turtle.forward()
                turtle.forward()
                turtle.turnLeft()
               
        end    
        for n=1,16 do -- everything else
                turtle.select(n)
                if turtle.getItemCount(n) > 0 then
                        while not turtle.drop() do
                                print("ERROR: Chest is full!")
                                print("Hit ENTER to try again")
                                read()
                        end
                        unloaded = unloaded + turtle.getItemCount(n)
                end
        end
        turtle.turnLeft()
	for o=1, nChests-1 do
        	turtle.forward()
      		turtle.forward()
	end
        turtle.turnLeft()
        turtle.forward()
        turtle.down()
        turtle.down()
	--print("depth before is : "..depth)
	goTo( 0,0,0,0,-1 )
	--print("depth after is : "..depth)
	--sleep(2)
        collected = 0
        turtle.select(1)
end

local function returnSupplies(nChests)
	if nChests == 0 then return end

	local x,y,z,xd,zd = xPos,depth,zPos,xDir,zDir
	print( "Returning to surface..." )
	goTo( 0,1,0,0,-1 ) -- Do not dig quarry cap
	goTo( 0,0,0,0,-1 ) 
	local fuelNeeded = x+y+z + x+y+z + 1
	if not refuel( fuelNeeded ) then
		unload(nChests)
		print( "Waiting for fuel" )
		while not refuel( fuelNeeded ) do
			sleep(1)
		end
	else
		unload(nChests)	
	end
	
	print( "Resuming mining..." )
	goTo( 0,1,0,0,-1 ) -- Do not dig quarry cap
	goTo( x,y,z,xd,zd )
end

local function collect()	
	local bFull = true
	local nTotalItems = 0
	for n=1,16 do
		local nCount = turtle.getItemCount(n)
		if nCount == 0 then
			bFull = false
		end
		nTotalItems = nTotalItems + nCount
	end
	
	if nTotalItems > collected then
		collected = nTotalItems
		if math.fmod(collected + unloaded, 50) == 0 then
			print( "Mined "..(collected + unloaded).." items." )
		end
	end
	
	if bFull then
		print( "No empty slots left." )
		return false
	end
	return true
end

function refuel( ammount )
	local fuelLevel = turtle.getFuelLevel()
	if fuelLevel == "unlimited" then
		return true
	end
	
	local needed = ammount or (xPos + zPos + depth + 1)
	if turtle.getFuelLevel() < needed then
		local fueled = false
		for n=1,16 do
			if turtle.getItemCount(n) > 0 then
				turtle.select(n)
				if turtle.refuel(1) then
					while turtle.getItemCount(n) > 0 and turtle.getFuelLevel() < needed do
						turtle.refuel(1)
					end
					if turtle.getFuelLevel() >= needed then
						turtle.select(1)
						return true
					end
				end
			end
		end
		turtle.select(1)
		return false
	end
	
	return true
end

-- local function tryForwards()
	-- if not refuel() then
		-- print( "Not enough Fuel" )
		-- returnSupplies()
	-- end
	
	-- while not turtle.forward() do
		-- if turtle.detect() then
			-- if turtle.dig() then
				-- if not collect() then
					-- returnSupplies()
				-- end
			-- else
				-- return false
			-- end
		-- elseif turtle.attack() then
			-- if not collect() then
				-- returnSupplies()
			-- end
		-- else
			-- sleep( 0.5 )
		-- end
	-- end
	
	-- xPos = xPos + xDir
	-- zPos = zPos + zDir
	-- return true
-- end

local function tryForwards()
	if not refuel() then
		print( "Not enough Fuel" )
		returnSupplies(numberChests)
	end
	
	while not turtle.forward() do
		if turtle.detect() then
			if turtle.dig() then
				if not collect() then
					returnSupplies(numberChests)
				end
			else
				return false
			end
		elseif turtle.attack() then
			if not collect() then
				returnSupplies(numberChests)
			end
		else
			sleep( 0.5 )
		end
	end
	xPos = xPos + xDir
	zPos = zPos + zDir
	if not goToMode then
		if turtle.digUp() then
			if not collect() then
				returnSupplies(numberChests)
			end
		end
		if turtle.digDown() then
			if not collect() then
				returnSupplies(numberChests)
			end
		end
	end
	return true
end

function tryDown()
	if not refuel() then
		print( "Not enough Fuel" )
		returnSupplies(numberChests)
	end
	while not turtle.down() do
		if turtle.detectDown() then
			if turtle.digDown() then
				if not collect() then
					returnSupplies(numberChests)
				end
			else
				return false
			end
		elseif turtle.attackDown() then
			if not collect() then
				returnSupplies(numberChests)
			end
		else
			sleep( 0.5 )
		end
	end
	depth = depth + 1
	--if math.fmod( depth, 10 ) == 0 then
		print( "Descended "..depth.." metres." )
	--end

	return true
end

local function turnLeft()
	turtle.turnLeft()
	xDir, zDir = -zDir, xDir
end

local function turnRight()
	turtle.turnRight()
	xDir, zDir = zDir, -xDir
end

function goTo( x, y, z, xd, zd )
	goToMode = true
	while depth > y do
		if turtle.up() then
			depth = depth - 1
		elseif turtle.digUp() or turtle.attackUp() then
			collect()
		else
			sleep( 0.5 )
		end
	end

	if xPos > x then
		while xDir ~= -1 do
			turnLeft()
		end
		while xPos > x do
			if turtle.forward() then
				xPos = xPos - 1
			elseif turtle.dig() or turtle.attack() then
				collect()
			else
				sleep( 0.5 )
			end
		end
	elseif xPos < x then
		while xDir ~= 1 do
			turnLeft()
		end
		while xPos < x do
			if turtle.forward() then
				xPos = xPos + 1
			elseif turtle.dig() or turtle.attack() then
				collect()
			else
				sleep( 0.5 )
			end
		end
	end
	
	if zPos > z then
		while zDir ~= -1 do
			turnLeft()
		end
		while zPos > z do
			if turtle.forward() then
				zPos = zPos - 1
			elseif turtle.dig() or turtle.attack() then
				collect()
			else
				sleep( 0.5 )
			end
		end
	elseif zPos < z then
		while zDir ~= 1 do
			turnLeft()
		end
		while zPos < z do
			if turtle.forward() then
				zPos = zPos + 1
			elseif turtle.dig() or turtle.attack() then
				collect()
			else
				sleep( 0.5 )
			end
		end	
	end
	
	while depth < y do
		if turtle.down() then
			depth = depth + 1
		elseif turtle.digDown() or turtle.attackDown() then
			collect()
		else
			sleep( 0.5 )
		end
	end
	
	while zDir ~= zd or xDir ~= xd do
		turnLeft()
	end
	goToMode = false
end

if not refuel() then
	print( "Out of Fuel" )
	return
end

print( "Excavating..." )

local reseal = false
turtle.select(1)
--if turtle.digDown() then
if turtle.digDown() then
	reseal = true
end

local alternate = 0
local done = false
tryDown() -- must go down 2 blocks to let cap on carry
tryDown()
--tryDown()
--tryUp()
turtle.digDown()
while not done do
	for n=1,excavationWide do
		for m=1,excavationFar-1 do
			if not tryForwards() then
				done = true
				break
			end
		end
		if done then
			break
		end
		if n<excavationWide then
			if math.fmod(n + alternate,2) == 0 then
				turnLeft()
				if not tryForwards() then
					done = true
					break
				end
				turnLeft()
			else
				turnRight()
				if not tryForwards() then
					done = true
					break
				end
				turnRight()
			end
		end
	end
	if done then
		break
	end

	if excavationWide > 1 then
		if math.fmod(excavationWide,2) == 0 then

			turnRight()
			tempFar = excavationFar -- alternating sides x*z become z*y for next layer
			tempWide = excavationWide
			excavationWide = tempFar
			excavationFar = tempWide
			alternate = 0
		else
			--if alternate == 0 then
			--	turnLeft()
			--else
			--	turnRight()
			--end
			--alternate = 1 - alternate
			turnRight()
			turnRight()
			alternate = 0
		end
	end




	tryDown()	-- this block should have been dug
	if not tryDown() then -- false means bottom
		done = true
		break
	end	
	tryDown()
	turtle.digDown()
end

print( "Returning to surface..." )

-- Return to where we started
goTo( 0,1,0,0,-1 ) -- do not dig quarry cap
goTo( 0,0,0,0,-1 )
unload(numberChests)
goTo( 0,0,0,0,1 )

-- Seal the hole
if reseal then
	turtle.placeDown()
end

print( "Mined "..(collected + unloaded).." items total." )
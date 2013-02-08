-- Advanced Ore Finder by Henness
-- Version 2.0 12/16/2012

-- APIs
os.loadAPI('cc-scripts/apis/ccstatus')

-- Config
local version = "v2.0"
local author = "[by Henness]"

-- Functions
function version()
	return Version
end



local function report(s)

	local reportX = ofsave["currentPos"]["x"]
	local reportY = ofsave["currentPos"]["y"]
	local reportZ = ofsave["currentPos"]["z"]

  ccstatus.report("("..reportX..", "..reportY..", "..reportZ..") "..s)
end

function skip()
	while true do
		local id, key = os.pullEvent("key")
		if key == 57 then
			break
		end
	end
end

function saveTable(table,name)
	local file = fs.open(name,"w")
	file.write(textutils.serialize(table))
	file.close()
end

function loadTable(name)
	local file = fs.open(name,"r")
	local data = file.readAll()
	file.close()
	return textutils.unserialize(data)
end

function save()
	ofsave["currentPos"]["x"] = x
	ofsave["currentPos"]["y"] = y
	ofsave["currentPos"]["z"] = z
	ofsave["currentPos"]["face"] = face
	if fs.exists("ofsave") then
		fs.delete("ofsave")
	end
	saveTable(ofsave, "ofsave")
end

function turnLeft(a)
	if not a then
		a = 1
	end
	for i=1,math.abs(a),1 do
		turtle.turnLeft()
		if face==0 then
			face=3
		else
			face=face-1
		end
	end
	return true
end

function turnRight(a)
	if not a then
		a = 1
	end
	for i=1,math.abs(a),1 do
		turtle.turnRight()
		if face==3 then
			face=0
		else
			face=face+1
		end
	end
	return true
end

function setFace(a)
	local turn = face-a
	local done = false
	if face == a then
		done = true
	elseif turn == -1 or turn == 3 then
		turnRight()
		done = true
	elseif turn == 1 or turn == -3 then
		turnLeft()
		done = true
	elseif math.abs(turn) == 2 then
		turnRight(2)
		done = true
	end
	return done
end

function up(n) -- Moves the turtle up "n" distance
	local moved
	if not n then
		n=1
	end
	if y<255 then
		for k=1,n,1 do
			moved = turtle.up()
			if moved then
				y=y+1
				save()
			else
				break
			end
		end
	end
	return moved
end

function down(n) -- Moves the turtle down "n" distance
	local moved
	if not n then
		n=1
	end
--	if y>1 then
		for k=1,n,1 do
			moved = turtle.down()
			if moved then
				y=y-1
				save()
			else
				break
			end
		end
--	end
	return moved
end

function forward(n) -- Moves the turtle forward "n" distance
	local moved
	if not n then
		n=1
	end
	if face==0 then
		for k=1,n,1 do
			moved=turtle.forward()
			if moved then
				z=z+1
				save()
			else
				break
			end
		end
	elseif face==1 then
		for k=1,n,1 do
			moved=turtle.forward()
			if moved then
				x=x-1
				save()
			else
				break
			end
		end
	elseif face==2 then
		for k=1,n,1 do
			moved=turtle.forward()
			if moved then
				z=z-1
				save()
			else
				break
			end
		end
	elseif face==3 then
		for k=1,n,1 do
			moved=turtle.forward()
			if moved then
				x=x+1
				save()
			else
				break
			end
		end
	end
	return moved
end

function dig()
	return turtle.dig()
end

function digDown()
	return turtle.digDown()
end

function digUp()
	return turtle.digUp()
end

function compareForward(startSlot, endSlot)
	if not startSlot then
		startSlot = 2
	end
	if not endSlot then
		endSlot = ofsave["ignore"] + 1
	end
	Ore = true
	for i=startSlot,endSlot do
		turtle.select(i)
		if turtle.compare() then
			Ore = false
			break
		end				
	end
	if Ore then
		dig()
	end
end

function findDown(n) -- Finds all ores below the turtle for "n" distance

  report("Going down...")

	if not n then
		n=256--y-1
	end
	for i=1,n,1 do
		local moved = down()
		
    if not moved and turtle.detectDown() then
			
      digDown()
			if not down() then
				break
			end
      
		elseif not moved and not turtle.detectDown() then
			repeat turtle.attackDown() until down()
		end
    
    ofsave["returnPos"]["y"] = y
    checkReturn()
    
		for j=1,4 do
			compareForward()
			turnRight()
		end
	end

  ofsave["returnPos"]["y"] = 0

end

function returnLast()
	local returnPosx = ofsave["returnPos"]["x"]
	local returnPosy = ofsave["returnPos"]["y"]
	local returnPosz = ofsave["returnPos"]["z"]
	local returnPosface = ofsave["returnPos"]["face"]

  report("Returning to last...")

	moveToPos(returnPosx, returnPosy, returnPosz, returnPosface)
end

function returnStart()
	local startPosx = ofsave["startPos"]["x"]
	local startPosy = ofsave["startPos"]["y"]
	local startPosz = ofsave["startPos"]["z"]

  report("Returning to start...")

	moveToPos(startPosx, startPosy, startPosz, faceB)
end

function moveToPos(A, B, C, Face)
	a=A-x
	b=B-y
	c=C-z
	if b>0 then
		for i=1,math.abs(b) do
			local moved = up()
			if not moved and turtle.detectUp() then
				repeat digUp() until up()
				local moved = true
			elseif not moved and not turtle.detectUp() then
				repeat turtle.attackUp() until up()
			end
		end
	end
	if a<0 then
		setFace(1)
	elseif a>0 then
		setFace(3)
	end
	if a ~= 0 then
		for i=1,math.abs(a) do
			local moved = forward()
			if not moved and turtle.detect() then
				repeat dig() until forward()
				local moved = true
			elseif not moved and not turtle.detect() then
				repeat turtle.attack() until forward()
			end
		end
	end
	if c<0 then
		setFace(2)
	elseif c>0 then
		setFace(0)
	end
	if c ~= 0 then
		for i=1,math.abs(c) do
			local moved = forward()
			if not moved and turtle.detect() then
				repeat dig() until forward()
				local moved = true
			elseif not moved and not turtle.detect() then
				repeat turtle.attack() until forward()
			end
		end
	end
	if b<0 then
		for i=1,math.abs(b) do
			local moved = down()
			if not moved and turtle.detectDown() then
				repeat digDown() until down()
				local moved = true
			elseif not moved and not turtle.detectDown() then
				repeat turtle.attackDown() until down()
			end
		end
	end
	setFace(Face)
end

function unload()
		for i = 2, ofsave["ignore"]+1 do -- skipping 1st slot (cap). Up to Ignore +1(cap).
			turtle.select(i)
			turtle.drop(turtle.getItemCount(i)-1)
		end
		for i = ofsave["ignore"]+2, 16 do -- from slot 1 + ignore + cap (ignore +2).
      emptySlot(i)
		end
end

function checkReturn()
	if turtle.getItemCount(16) > 0 then
		returnStart()
    
    unload()
		turtle.select(1)
		
    returnLast()
	end
end

function emptySlot(n)
	turtle.select(n)
	turtle.drop()

  -- Drop until it really dropped. Wait for chest to empty itself.
  while turtle.getItemCount(n) > 0 do
    report("Drop chest seems full. Retrying in 30 sec...")
    sleep(30)

    turtle.select(n)
		turtle.drop()
  end
end

function oreFinder()

  -- move right until block is
  report("Seeking farthest column...")
  turnRight()
  while forward() and ofsave["w"] <= ofsave["width"] do

 		local seekingW = ofsave["w"] + 1
		ofsave["w"] = seekingW

  end
  turnLeft()
  report("Resuming at column "..ofsave["w"])

	while ofsave["w"] <= ofsave["width"] do
		while ofsave["l"] <= ofsave["length"] do
			checkReturn()
			if math.fmod((ofsave["returnPos"]["x"]+4)-2*(ofsave["returnPos"]["z"]-1), 5) == 0 then
				findDown()
				returnLast()
				turtle.select(1)
				turtle.placeDown()
			end
			if ofsave["l"] == ofsave["length"] then
				if face == faceF then
					turnRight()
					ofsave["right"] = true
				elseif face == faceB then 
					turnLeft()
					ofsave["left"] = true
				end
				ofsave["returnPos"]["x"] = x
				ofsave["returnPos"]["z"] = z
				ofsave["returnPos"]["face"] = face
				if fs.exists("ofsave") then
					fs.delete("ofsave")
				end
				saveTable(ofsave, "ofsave")
			end
			if not ofsave["forward"] then
				local moved = forward()
				if not moved and turtle.detect() then
					repeat dig() until forward()
					local moved = true
				elseif not moved and not turtle.detect() then
					repeat turtle.attack() until forward()
				end
				digUp()
				ofsave["returnPos"]["x"] = x
				ofsave["returnPos"]["z"] = z
				ofsave["returnPos"]["face"] = face
				ofsave["forward"] = true
				if fs.exists("ofsave") then
					fs.delete("ofsave")
				end
				saveTable(ofsave, "ofsave")
			end
			if ofsave["right"] then
				turnRight()
				ofsave["right"] = false
			elseif ofsave["left"] then
				turnLeft()
				ofsave["left"] = false
			end
			local l = ofsave["l"] + 1
			ofsave["l"] = l
			ofsave["returnPos"]["x"] = x
			ofsave["returnPos"]["z"] = z
			ofsave["returnPos"]["face"] = face
			ofsave["forward"] = false
			if fs.exists("ofsave") then
				fs.delete("ofsave")
			end
			saveTable(ofsave, "ofsave")
		end
		local w = ofsave["w"] + 1
		ofsave["w"] = w
		ofsave["l"] = 1
		if fs.exists("ofsave") then
			fs.delete("ofsave")
		end
		saveTable(ofsave, "ofsave")
	end
	returnStart()

	for i = 1, 16 do
    emptySlot(i)
  end
  
	setFace(faceF)
	fs.delete("ofsave")
end

function runOreFinder(width, length, ignore)
  x, y, z, face = 0,0,0,0

  print("Starting a new excavation,", 4)
  print("press space at any time to pause.", 5)
  ofsave = {
    ["startPos"] = {
      ["x"] = x, ["y"] = y, ["z"] = z, ["face"] = face
    },
    ["currentPos"] = {
      ["x"] = x, ["y"] = y, ["z"] = z, ["face"] = face
    },
    ["returnPos"] = {
      ["x"] = x, ["y"] = y, ["z"] = z, ["face"] = face
    },
    ["ignore"] = ignore,
    ["forward"] = false,
    ["left"] = false,
    ["right"] = false,
    ["length"] = length,
    ["width"] = width,
    ["l"] = 1,
    ["w"] = 1
  }
  if fs.exists("ofsave") then
    fs.delete("ofsave")
  end
  saveTable(ofsave, "ofsave")

	faceF = ofsave["startPos"]["face"]
	if faceF<=1 then
		faceB = faceF+2
	else 
		faceB = faceF-2
	end
  
  
	parallel.waitForAny(oreFinder, skip)
  report("Advanced Ore Finder Completed.")
end

local tArgs = { ... }

function main()
  if #tArgs == 3 then
    width = tonumber(tArgs[1])
    length = tonumber(tArgs[2])
    ignore = tonumber(tArgs[3])
    runOreFinder(width, length, ignore)
  else
    print("Usage: " .. shell.getRunningProgram() .. " <width> <length> <ignore>")
    print("Slots: Cap - Ignore1 - Ignore2 - ...")
  end
end

local ok, err = pcall(main)
if not ok then
  ccstatus.report(err)
end
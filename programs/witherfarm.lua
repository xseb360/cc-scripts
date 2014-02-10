--os.loadAPI('cc-scripts/apis/ccstatus')
--os.loadAPI('cc-scripts/apis/inv')
--os.loadAPI('cc-scripts/apis/bt')


wSF=1
witherCount = 1

killTimer = 50
rechargeTimer = 60
resupplyTimer = 30

minSoulsand = 5
minWitherSkull = 3
minFuel = 3000

soulsandSlot = 1
witherSkullSlot = 2
coalSlot = 3


local ok, err = pcall(main)
if not ok then
	report(err)
end


function main()
 	--parallel.waitForAny(keepFarmingWither(), skip)
	keepFarmingWither()
end

function skip()
	while true do
		local id, key = os.pullEvent("key")
		if key == 57 then
			break
		end
	end
end

function keepFarmingWither()
	for i=1, witherCount do
		report('Farming wither...'..i..' of '..witherCount)
		farmOneWither()
		if i ~= witherCount then
			countDown(rechargeTimer, 'Recharging')
		end
	end
end

function farmOneWither()

	checkInv()
	
	while wSF ~= 1 do
		countDown(resupplyTimer, 'Waiting for resupply')
		checkInv()
	end
	
	if wSF==1 then
		buildWither()
		switchRedstone(true)
		countDown(killTimer, 'Killing')
		switchRedstone(false)
	end
end

function countDown(cnt, sleepingReason)
	report(sleepingReason..' '..cnt..'secs')
	
	for i=1, cnt/5 do
		sleepLen = 5
		if i*5 > cnt then
			sleepLen = (i*5) - cnt
		end
		sleep(sleepLen)
		report(((i-1)*5)+sleepLen..'/'..cnt)
	end
end

function switchRedstone(status)
	redstone.setOutput("back", status)
	redstone.setOutput("bottom", status)
end
 
function checkInv()
  if turtle.getItemCount(1)<minSoulsand then -- Soul Sands
    turtle.select(soulsandSlot)
    turtle.turnLeft()
    turtle.suck()
    turtle.turnRight()
  end
  if turtle.getItemCount(2)<minWitherSkull then -- Wither Skulls
    turtle.select(witherSkullSlot)
    turtle.turnRight()
    turtle.suck()
    turtle.turnLeft()
    turtle.select(soulsandSlot)
  end
  if turtle.getFuelLevel()<minFuel then
    turtle.select(coalSlot)
    turtle.suckUp()
    turtle.refuel()
    turtle.select(soulsandSlot)
  end
  
  wSF = 1 -- assuming every supply is full
  
  if turtle.getItemCount(1)<minSoulsand then -- Soul Sands
	report('Missing Soul Sands')
    wSF=0
  end
  if turtle.getItemCount(2)<minWitherSkull then -- Wither Skulls
	report('Missing Wither Skulls')
    wSF=0
  end
  if turtle.getFuelLevel()<minFuel then
	report('Missing Fuel')
    wSF=0
  end
end
	
function buildWither()

--[[
LEGEND:
	(C)oal Chest
	(S)oulsand Chest
	(W)ither skull Chest
	(P)rojector
	(T)urtle
	(I)nterdiction Matrix
	(V)acuum
	(B)ase Block
	(754): placed wither skulls
	(6321): placed Soul sand
	*: Force Field
	
	note: 7462 share places with the force field. As soon as the wither spawns, it only takes a 1x1x3 and the forcefield can materialise in place. 

Side view:
			 ***
	top		C* *
	2nd	   PT754
	3rd		I632
	4th		V*1*
	5th		 *B*
	6th		 ***

Top View:
	
	1st layer:
		 ***
	     ***
		 ***
	2nd layer:
         ***
        C* *
         ***
	3rd layer:
	    S***
	   PT754
		W***
		  
	4th layer:
	     ***
		I632
		 ***
	5th layer:
	     ***
	    V*1*
		 ***
	6th layer:
	     ***
	     *B*
		 *** 
	7th layer:
		 ***
		 ***
		 ***

Force Field:

	CUBE MODE

	UP: Scale 6
	LEFT: Scale 1
	RIGHT: Scale 1
	FRONT: Scale 1
	BACK: Scale 1
	
	DOWN: Translation 4
	LEFT: Translation 3

	Side		Top1	Top2	Top3	Top4	Top5	Top6	Top7
	***			***		***		***		***		***		***		***
	* *			***		* *		* *		* *		* *		* *		***
	* *			***		***		***		***		***		***		***
	* *
	* *
	* *
	***
]]

	--turtle.forward() -- include to place the wither 1 block farther away
	
	turtle.forward()
	turtle.forward()
	turtle.down()

	-- Add the bottom block
	turtle.down()
	turtle.select(soulsandSlot)
	turtle.placeDown() -- B (base block. for the wither to stand on)
	turtle.up()
	
	
	turtle.select(soulsandSlot)
	turtle.placeDown() -- 1
	turtle.place() -- 2
	
	turtle.up()
	turtle.placeDown() -- 3
	
	turtle.select(witherSkullSlot)
	turtle.place() -- 4
	turtle.back()
	turtle.place() -- 5

	turtle.select(soulsandSlot)
	turtle.placeDown() -- 6
	
	turtle.back()

	turtle.select(witherSkullSlot)
	--DO NOT COMPLETE turtle.place()

	--turtle.back() -- include if the wither was built 1 block farther away
end

function report(s)
  --ccstatus.report(s)
  print(s)
end



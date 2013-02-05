-- Better Ore Finder

if not turtle.position then
  os.loadAPI('cc-scripts/apis/turtletracker')
  os.loadAPI('cc-scripts/apis/inv')
end


-- Finds the first hole to dig for each column. Each hole is staggered x1, 2z to optimize coverage.
-- (0,4), (1,1), (2,3), (3,0), (4,2)
-- 4, 1, 3, 0, 2
--    |a
-- 4 a|A a c
-- 3  |a c C c e
-- 2  |  b c e E e
-- 1  |b B b d e
-- 0  |  b d D d
----------------------
--           d
--     0 1 2 3 4
function getStaggeredStartZ(x)
	if		math.fmod(x, 5) == 0 then return 4
    elseif	math.fmod(x, 5) == 1 then return 1
    elseif	math.fmod(x, 5) == 2 then return 3
    elseif	math.fmod(x, 5) == 3 then return 0
    elseif	math.fmod(x, 5) == 4 then return 2
end


function getNextDig(currentDig, area)
	
	local nextDig = currentDig
	
	nextDig.Z = currentDig.Z + 5

	if nextDig.Z > area.Z
		nextDig.X = currentDig.X + 1
		if nextDig.X > area.X
			return false -- Area completed
		end
		
		nextDig.Z = getStaggeredStartZ(nextDig.X)
	end
	
	return true, nextDig
end

function gotoNextDigLocation(area)
	
	local nextDigFound, nextDigLoc = getNextDig(turtle.position, area)
	
	if not nextDigFound then 
		return false 
	end
	
	gotoDigLoc(nextDigLoc)
	return true
end

function gotoDigLoc(digLoc)
	turtle.digTo(digLoc)
end


function forceDown()
  while not turtle.down() do
    turtle.digDown()
    --InventoryCheck
    sleep(0.2)
  end
end

function forceUp()
  while not turtle.up() do
    turtle.digUp()
    sleep(0.2)
  end
end

function tryDown()
  if turtle.down() do
    return true
  end
  
  turtle.digDown()
  return turtle.down()
end

function dig()
	
	while digOne do
	end
	
end

function undig()

	while  do
    undigOne()
	end

end


function undigOne()
 
  forceUp()
  
  if not inv.selectSimilarBlock(1) then 
    if not inv.selectSimilarBlock(2) then 
      print('out of filling materials');
      return false
    end
  end
  
  turtle.placeDown()
 
end

function digOne()
	
	if not tryDown() then return false end
	
	-- look for ore around
	
	return true
	
end

function main()

	startingDig = vector.new(0,0,getStaggeredStartZ(0))
	gotoDigLoc(currentDig)
	
	repeat
		dig()
		undig()
	until not gotoNextDigLocation(currentDig, area)

	turtle.goto(0,0,0)
end




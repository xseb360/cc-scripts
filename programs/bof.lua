-- Better Ore Finder

if not turtle.position then
  os.loadAPI('cc-scripts/apis/betterapi.lua')
  os.loadAPI('turtletracker.lua')
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


function getNextDig(currentLoc, area)
	
	nextLoc = currentLoc
	
	nextLoc.Z = currentLoc.Z + 5

	if nextLoc.Z > area.Z
		nextLoc.X = currentLoc.X + 1
		if nextLoc.X > area.X
			return false -- Area completed
		end
		
		nextLoc.Z = getStaggeredStartZ(nextLoc.X)
	end
	
	return true, nextLoc
end







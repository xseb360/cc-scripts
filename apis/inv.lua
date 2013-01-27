


function selectSimilarBlock(slot)
	
	-- Select the slot to compare to
	turtle.select(slot)

	-- Attempt to find similar blocks in other slots
	for i = 1, 16 do
		if i ~= slot and turtle.compareTo(i) then
			select(i)
			return true
		end
	end

	-- Place excess blocks from slot 1
	-- after using all other slots
	if turtle.getItemCount(1) > 1 then
		select(i)
		return true
	end

	
	-- If we've gotten this far, we're out of blocks
	return false
end


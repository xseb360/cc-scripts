


function waitForSelectSimilarBlock(slot, blockName)

    while not inv.selectSimilarBlock(slot) do    
      ccstatus.report("Out of "..blockName..". Retrying in 10 secs...")
      sleep(10)
    end

end


function selectSimilarBlock(slot)
	
	-- Select the slot to compare to
	turtle.select(slot)

	-- Attempt to find similar blocks in other slots
	for i = 1, 16 do
		if i ~= slot and turtle.compareTo(i) then
			turtle.select(i)
			return true
		end
	end

	-- Place excess blocks from slot 1
	-- after using all other slots
	if turtle.getItemCount(slot) > 1 then
		turtle.select(slot)
		return true
	end

	
	-- If we've gotten this far, we're out of blocks
	return false
end


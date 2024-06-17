-- spirit.lua

local std = require ('spirit.std')

local Spirit = {}


function Spirit:plot (i_uniqueIdOrName, i_coordinates, i_optionalAxisLabel, i_optionIndex)
	i_optionalAxisLabel = i_optionalAxisLabel or ''
	i_optionIndex = i_optionIndex or 0

	for i = 1,#i_coordinates do
	
		if (type (i_coordinates [i]) == 'table') then
			i_coordinates [i] = std:cArrayFromTable (i_coordinates [i])
		end

		-- print (type (i_coordinates [i]))
	end
	

	print ("adding plot: " .. i_uniqueIdOrName)


--	print (type (i_coordinates))

--	sluggo_plot (i_uniqueIdOrName, i_coordinates, i_optionalAxisLabel, i_optionIndex)

end

return Spirit
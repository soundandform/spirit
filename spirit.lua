-- spirit.lua

local std = require ('spirit.std')

local Spirit = 
{

}


function Spirit:GetSourceInfo ()
	local level = 3

--	while true do
		local info = debug.getinfo(level, "Sln")
--		if not info then break end
--		if info.what == "C" then   -- is a C function?
	--	print (level, "C function")
--		else   -- a Lua function
--		print (string.format("%s [%s] :%d", info.name, info.source, info.currentline))
--		end
--	level = level + 1
--	end

	return { info.source, info.name, info.currentline }
end




function Spirit:plot (i_uniqueIdOrName, i_coordinates, i_axesOptions, i_optionalIndex)

	sluggo_plot (i_uniqueIdOrName, i_coordinates, i_axesOptions, i_optionalIndex)

end


function Spirit:ir (i_uniqueIdOrName, i_function, i_args, i_optionalIndex)

	local array = std:array (100)

	for i = 1,#array do
		array [i] = i
	end

	local ca = std:cArrayFromTable (array)

	sluggo_array (ca)

--		sluggo_lab (func, 'sweep', i_args or {}, i_uniqueIdOrName)
end

return Spirit
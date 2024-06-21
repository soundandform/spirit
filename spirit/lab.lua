-- lab.lua

local std = require ('spirit.std')
local convert = require ('spirit.util.convert')

local Lab = 
{
}


function Lab:GetSourceInfo ()
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




function Lab:plot (i_uniqueIdOrName, i_coordinates, i_axesOptions, i_optionalIndex)

	sluggo_plot (i_uniqueIdOrName, i_coordinates, i_axesOptions, i_optionalIndex)

end


function Lab:ir (i_uniqueIdOrName, i_function, i_args, i_optionalIndex)

	local array = std:array (100)

	for i = 1,#array do
		array [i] = i
	end

	local ca = std:cArrayFromTable (array)

	sluggo_array (ca)

--		sluggo_lab (func, 'sweep', i_args or {}, i_uniqueIdOrName)
end



--[[ irsweep ()  displays the magnitude & phase response of 'i_function' by transforming its impulse response into the frequency domain using an FFT ]]--

function Lab:irsweep (i_uniqueIdOrName, i_function, i_args, i_optionalIndex)
	
end



function Lab:_tf (i_function, i_dBStart, i_dBEnd, i_dBStep, i_sign)

	local x,y = {}, {}

	local dB = i_dBStart

	while (dB < i_dBEnd) do
		local gain = convert:dBToGain (dB)

		x [#x+1] = dB
		y [#y+1] = convert:gainTodB (math.abs (i_function (gain * i_sign)))

		dB = dB + i_dBStep
	end

	return x,y
end




function reverse (i_array)

	local endi = #i_array + 1

	for i = 1, math.floor (#i_array/2) do
		local tmp = i_array [i]
		i_array [i] = i_array [endi - i]
		i_array [endi - i] = tmp
	end
	
end



function Lab:tf (i_uniqueIdOrName, i_function, i_args)

	local dBStart = i_args ['dBMin'] or -44
	local dBEnd   = i_args ['dBMax'] or .01
	local dBStep = .1

	dBStart = -math.abs (dBStart)


	x,y = self:_tf (i_function, dBStart, dBEnd, dBStep, 1)

	if (i_args ['fullwave'] == true) then

		local xp = x
		local yp = y

		xn,yn = self:_tf (i_function, dBStart, dBEnd, dBStep, -1)

		reverse (yn)

		local range = dBStart - dBEnd;


		for i = 1, #yn do
			xp [i] = xp [i] - dBStart
			yp [i] = yp [i] - dBStart

			xn [i] = xn [i] - dBEnd
			yn [i] = dBStart - yn [i]
		end

	
		for i = 1, #xp do
			xn [#xn + 1] = xp [i]
			yn [#yn + 1] = yp [i]
		end

		x,y = xn,yn

		i_args ['x'] = { range, -range }
		i_args ['y'] = { range, -range }

		print (#yn)
	else
		
		i_args ['x'] = { dBStart, dBEnd }
		i_args ['y'] = { dBStart, dBEnd }
	end

	sluggo_plot (i_uniqueIdOrName, {x,y}, i_args, optionalIndex)	
	
end


return Lab
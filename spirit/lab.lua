-- lab.lua

local std = require ('spirit.std')
local convert = require ('spirit.util.convert')
require 'spirit.math.complex'

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








function  Lab:waveform  (i_uniqueIdOrName, i_source, i_layer)

	sluggo_waveform (i_uniqueIdOrName, i_source, i_layer)

end


function Lab._generateXCoordinates (i_axesOptions)

	local numPoints = i_axesOptions.numPoints or 2000

	local log = false
	local x1, x2 = nil,nil

	local xaxis = i_axesOptions ['x']
		
	for _,value in ipairs (xaxis) do
		if (value == 'log') then log = true 
		elseif (value == 'lin') then log = false
		elseif (type (value) == 'number') then
			if (not x1) then x1 = value 
			elseif (not x2) then x2 = value
			end
		end
	end

	if (not x1) then error ("no start x value provided") end
	if (not x2) then error ("no end x value provided") end
	
	--print ("log: " .. tostring (log) .. " x1: " .. x1 .. "  x2: " .. x2)

	local xx = {}
		
	for n=1,numPoints do

		local x

		if (log == true) then
			x = convert:linearToLog (n-1, 0, numPoints - 1, x1, x2)
		else
			x = x1 + (x2 - x1) * (n - 1)/(numPoints - 1)
		end

		xx [#xx + 1] = x
	end

	return xx

end


function Lab:plotj (i_function, i_sampleRate, i_axesOptions, i_optionalIndex)

	if (type (i_function) == 'function') then

		local xx = self._generateXCoordinates (i_axesOptions)



		local yy = {}

		for _,x in ipairs (xx) do
			local w = x/i_sampleRate * math.pi * 2
			
			local y = i_function (w);

			yy [#yy + 1] = convert:gainTodB (y)
		
		end

		i_function = { xx, yy }
	end

	sluggo_plot (i_function, i_axesOptions, i_optionalIndex)
end




function Lab:plot (i_coordinates, i_axesOptions, i_optionalIndex)

	i_optionalIndex = i_optionalIndex or self.index
	i_optionalIndex = i_optionalIndex or 0

	-- TODO: convert CArray i_coordinates to Tables

	if (type (i_coordinates) == 'function') then

		local numPoints = 2000

		local log = false
		local x1, x2 = nil,nil

		local xaxis = i_axesOptions ['x']
		
		for _,value in ipairs (xaxis) do
			if (value == 'log') then log = true 
			elseif (value == 'lin') then log = false
			elseif (type (value) == 'number') then
				if (not x1) then x1 = value
				elseif (not x2) then x2 = value
				end
			end
		end

		if (not x1) then error ("no start x value provided") end
		if (not x2) then error ("no end x value provided") end
	
		--print ("log: " .. tostring (log) .. " x1: " .. x1 .. "  x2: " .. x2)

		local xx, yy = {}, {}
		
		for n=1,numPoints do

			local x

			if (log == true) then
				x = convert:linearToLog (n-1, 0, numPoints - 1, x1, x2)
			else
				x = x1 + (x2 - x1) * (n - 1)/(numPoints - 1)
			end

			xx [#xx + 1] = x
			yy [#yy + 1] = i_coordinates (x)

--			print (x)
		end

		i_coordinates = { xx, yy }
	end


	local p = { plot= self.plot2; index = i_optionalIndex + 1 }

	sluggo_plot (i_coordinates, i_axesOptions, i_optionalIndex)

	return p

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



function Lab:tf (i_function, i_args)

	i_args = i_args or {}

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

		--print (#yn)
	else
		
		i_args ['x'] = { dBStart, dBEnd }
		i_args ['y'] = { dBStart, dBEnd }
	end

	sluggo_plot ({x,y}, i_args, optionalIndex)	
	
end


return Lab
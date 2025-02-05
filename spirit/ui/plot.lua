-- plot.lua

local convert 		= require 'spirit.util.convert'


Plot = {}

function Plot:new (i_source, i_lineNum)
-----------------------------------------------------------------------------------------
	local o = { source= i_source, line = i_lineNum }

	setmetatable (o, self); self.__index = self
	return o
end


function Plot:addRegion (...)
	sluggo_plot (self.line, ...)
end


function Plot:setBounds (...)
	sluggo_plot (self.line, "bounds", ...)
end


function Plot:plot (i_coordinates, i_axesOptions, i_optionalIndex)

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

	sluggo_plot (self.source, self.line, i_coordinates, i_axesOptions, i_optionalIndex)

	return p

end




function Plot._generateXCoordinates (i_axesOptions)

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


function Plot:plotj (i_function, i_sampleRate, i_axesOptions, i_optionalIndex)

	i_optionalIndex = i_optionalIndex or self.index
	i_optionalIndex = i_optionalIndex or 0

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

	local p = { 
		plotj= self.plotj; index = i_optionalIndex + 1,
		_generateXCoordinates = self._generateXCoordinates
	}

	sluggo_plot (self.source, self.line, i_function, i_axesOptions, i_optionalIndex)

	return p
end



return Plot
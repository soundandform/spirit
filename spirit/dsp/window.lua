-- window.lua

local Array 	= require 'spirit.array'

local Window = {}


function Window:normalize (io_array, i_scaler)

	i_scaler = i_scaler or 1

	local sum = 0.

	for i = 1,#io_array do
		sum = sum + io_array [i]
	end

	local normalizer = i_scaler / sum

--	print (normalizer)

	for i = 1,#io_array do
		io_array [i] = io_array [i] * normalizer
	end
	
end



function Window:maximize (i_array, i_scaler)

	i_scaler = i_scaler or 1

	local max = 0

	for i = 1,#i_array do
		max = math.max (max, math.abs (i_array [i]))
	end

--	print ("max :", max)

	local normal = i_scaler / max

	for i = 1,#i_array do
		i_array [i] = i_array [i] * normal
	end


end



function Window:BlackmanHarris (i_length)

	local array = Array:new (i_length)

	for i=1,i_length do
		local y = (i-1) * 2. * math.pi / (i_length - 1)
		local w = .35875 - .48829 * math.cos (y) + .14128 * math.cos (2. * y) - .01168 * math.cos (3. * y)
		array [i] = w
	end

	self:normalize (array)

	return array
end


function Window:Apply (io_array, i_window)

	for i=1,#i_window do
		io_array [i] = io_array [i] * i_window [i]
	end
end


return Window
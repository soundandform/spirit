-- window.lua

local Array 	= require 'spirit.array'

local Window = {}


function Window:Normalize (i_array)

	local sum = 0.

	for i = 1,#i_array do
		sum = sum + i_array [i]
	end

	local normalizer = 1. / sum

	for i = 1,#i_array do
		sum = sum * normalizer
	end
	

end



function Window:BlackmanHarris (i_length)

	local array = Array:new (i_length)

	for i=1,i_length do
		local y = (i-1) * 2. * math.pi / (i_length - 1)
		local w = .35875 - .48829 * math.cos (y) + .14128 * math.cos (2. * y) - .01168 * math.cos (3. * y)
		array [i] = w
	end

	self:Normalize (array)

	return array
end


return Window
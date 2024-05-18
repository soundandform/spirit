-- Array

local Array = {}

function Array:new (length)

	array = {}

	length = length or 0
	for i = 1,length do
		array [i] = 0
	end

	return array
end

return Array 

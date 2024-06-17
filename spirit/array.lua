-- Array

local Array = {}

Array.array = function (length)

	array = {}

	length = length or 0
	for i = 1,length do
		array [i] = 0
	end

	return array
end


Array.array = function c_array (type, length)

	local samples = ffi.new ('double [?]', bufferSize * channels)
	return samples
end

return Array 

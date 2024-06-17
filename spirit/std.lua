-- std.lua

local ffi = require ("ffi")

local Array = {}

function  Array:array  (length)

	array = {}

	length = length or 0
	for i = 1,length do
		array [i] = 0
	end

	return array
end


function  Array:cArray  (type, i_length)

	if (type == "f64") then type = "double" end
	if (type == "f32") then type = "float" end

	local samples = ffi.new (type .. '[?]', i_length)
	return samples
end


function Array:cArrayFromTable (i_table)

	local array = self:cArray ('f64', #i_table)
	for i = 1,#i_table do
		array [i-1] = i_table [i]
	end

	return array
end

return Array 

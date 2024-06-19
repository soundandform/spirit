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


function  Array:cArray  (i_length, i_type)

	i_type = i_type or 'f64'

	if (i_type == "f64") then i_type = "double" end
	if (i_type == "f32") then i_type = "float" end

	local samples = ffi.new (i_type .. '[?]', i_length)
	return samples
end


function Array:cArrayFromTable (i_table, i_type)

	i_type = i_type or 'f64'

	local array = self:cArray (#i_table, i_type)
	for i = 1,#i_table do
		array [i-1] = i_table [i]
	end

	return array
end


function Array:cArrayToTable (i_array, i_length)

	local table = {}
	for i = 1,i_length do
		table [i] = i_array [i-1]
	end

	return table
end



return Array 

-- Circular Buffer 

local Fifo = {}

function Fifo:new (i_length)

	obj = { [0] = 1 }				-- doesn't get included in #self length!?

	setmetatable (obj, self)
	self.__index = self

	i_length = i_length * 2 or 0
	for i = 1,i_length do
		obj [i] = 0
	end

	return obj
end


function Fifo:insert (i_value)

	local index = self [0]
	local out = self [index]

	local half = #self / 2

	self [index] = i_value 
	self [index + half] = i_value 

	index = index + 1 

	if index > half then
		index = 1
	end

	self [0] = index

	return out
end


function Fifo:fir (i_array)
										-- assert (#i_array <= #self / 2)
	local sum = 0

	local index = self [0] - 1 

	for i = 1,#i_array do
		sum = sum + self [index + i] * i_array [i]
	end

	return sum
end


return Fifo 

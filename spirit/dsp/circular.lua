-- Circular Buffer 

local CArray 	= require 'spirit.carray'


local Fifo = {}

function Fifo:new (i_length)

	i_length = i_length * 2

	local array = CArray:new (i_length)

	local obj = { index= 1, [0]= array }

	obj.insert = self.insert
	obj.toCArray = self.toCArray

	setmetatable (obj, self)

	return obj
end



function Fifo:insert (i_value)

	local index = self.index


	local buffer = self [0];
	
	local out = buffer [index]

	local half = #buffer / 2

--	print ("insrt: "..i_value .. " at " .. index + half)

	buffer [index] = i_value 
	buffer [index + half] = i_value 

	index = index + 1 

	if index > half then
		index = 1
	end

	self.index = index

	return out
end


function  Fifo:__len  ()
	return #self [0] / 2
end


function  Fifo:__index  (i_index)

	local index = self.index
	
--	print (index .. "  i : " .. i_index)


	return self [0] [index + i_index - 1]
end



function Fifo:toCArray ()

	return self [0]:slice (self.index, #self)

end


function Fifo:fir (i_array)
										-- assert (#i_array <= #self / 2)
	local sum = 0

	local index = self [0] - 1			-- -1 'cause i below starts at 1

	for i = 1,#i_array do
		sum = sum + self [index + i] * i_array [i]
	end

	return sum
end


return Fifo 

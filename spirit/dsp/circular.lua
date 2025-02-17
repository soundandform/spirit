-- Contiguous Circular Buffer 

local Array 	= require 'spirit.array'

-- this is a 2x sized mirrored/concatenated (how to describe this?) FIFO, such that FIRs 
-- and other operations on the buffer can be executed in one contiguous pass

local Circular = {}

function Circular:new (i_length)

	local array = Array:new (i_length * 2)

	local obj = { index= 1, [0]= array }

	obj.insert = self.insert
	obj.toArray = self.toArray
	obj.fir = self.fir

	setmetatable (obj, self)

	return obj
end



function Circular:insert (i_value)

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


function  Circular:__len  ()
	return #self [0] / 2
end


function  Circular:__index  (i_index)

	local index = self.index
	

	return self [0] [index + i_index - 1]
end



function Circular:toArray ()

	return self [0]:sliceCopy (self.index, #self [0] / 2) --#self)

end


function Circular:fir (i_array)
										-- assert (#i_array <= #self / 2)
	local sum = 0

--	local index = self.index			-- -1 'cause i below starts at 1

	for i = 1,#i_array do
		sum = sum + self [i] * i_array [i]
	end

	return sum
end


return Circular 

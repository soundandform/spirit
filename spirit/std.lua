-- std.lua

local Array 	= require 'spirit.array'


local Std = {}

function  Std:array  (length)

	array = {}

	length = length or 0
	for i = 1,length do
		array [i] = 0
	end

	return array
end



function Std.checkVar (i_var, i_func)

	local t = type (i_var)

	if (t == 'number') then
		return i_func (i_var)
	elseif (t == 'userdata') then

		for i=1,#i_var do
			if (i_func (i_var [i])) then
				return true
			end
 		end

	elseif (t == 'table') then

		for _,value in ipairs (i_var) do
			if (i_func (i_var [i])) then
				return true
			end
		end

	end

	return false

end

function Std._isNaN (i_var)
	return type (i_var) == 'number' and i_var ~= i_var
end

function Std._isInf (i_var)
	return type (i_var) == 'number' and (i_var == math.huge or i_var == -math.huge)
end



function Std:hasNaN (i_var)
	return self.checkVar (i_var, self._isNaN)
end


function Std:hasInf (i_var)
	return self.checkVar (i_var, self._isInf)
end



function Std:isNaN (i_var)
	return self._isNan (i_var)
end


function Std:nanInfCheck (i_var)
	if (self:hasNaN (i_var)) then error ("has NaN") end
	if (self:hasInf (i_var)) then error ("has infinity") end
end


function Std:getType (i_thingy)

	local t = type (i_thingy)

	if (type (i_thingy) == "userdata") then
		t = getmetatable (i_thingy).__name
	end


	return t

end


function Std:isArray (i_thing)
	local t = self:getType (i_thing)
	local i = string.find (t, "Array <")

	return (i == 1)
end


function Std:reverse (i_array)

	local r

	if (self:isArray (i_array)) then 
		r = i_array:copy ()						-- could do Array:new (i_array:type (), #i_array) if type() implemented
	elseif (type (i_array) == 'table') then
		r = {}
	else
		error "can't reverse this data type"
	end

	for i = 1,#i_array do
		r [i] = i_array [#i_array + 1 - i]
	end

	return r
	
end




function Std:sleep (i_seconds)
	sluggo_sleep (i_seconds)
end



function Std:zero (i_signal)
	
	if (self:isArray (i_signal)) then
		return i_signal:zeroCopy ()
	end

end


function Std:apply (i_signal, i_operator)

	local out = self:zero (i_signal)

	for i = 1, #i_signal do
		out [i] = i_operator (i_signal [i])
	end


	return out
end



return Std 

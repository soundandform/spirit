-- std.lua


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



return Std 

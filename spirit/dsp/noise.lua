-- noise.lua


local Noise = {} -- { 0x67452301, 0xefcdab89, scaler= 1. / 0xffffffff }


function Noise:new ()
------------------------------------------------------------------------
	o = { 0x67452301, 0xefcdab89, scaler= 1. / 0xffffffff }

	setmetatable (o, self); self.__index = self
	return o
end


function Noise:Render ()
------------------------------------------------------------------------
	local noise = self [2] * self.scaler

	self [1] = bit.bxor (self [1], self [2])
	self [2] = bit.tobit (self [2] + self [1])

	return noise
end


return Noise

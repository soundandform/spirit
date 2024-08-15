-- resonator.lua

local Resonator = {}


function Resonator:new ()

	local obj = {}

	setmetatable (obj, self)
	self.__index = self

	obj:Reset ()

	return obj
end


function  Resonator:GetCoeffs  (i_sampleRate, i_freq, i_damping)

	local coeffs = {}

	coeffs [0] = 2. * i_damping * math.cos (2. * math.pi * i_freq / i_sampleRate);
	coeffs [1] = -(i_damping * i_damping);

	return coeffs
end


function Resonator:Reset ()
	self.y0 = 0
	self.y1 = 0
end


function  Resonator:Render  (i_coeffs, i_input)

	local y = i_coeffs [0] * self.y0 + i_coeffs [1] * self.y1 + i_input;
		
	self.y1 = self.y0;
	self.y0 = y;
		
	return y;
end


return Resonator 
-- lowpass.lua


LowPass = {}

function LowPass:new ()
-----------------------------------------------------------------------------------------
	local o = { 0 }

	setmetatable (o, self); self.__index = self
	return o
end


function LowPass:GetCoeffs (i_sampleRate, i_frequency)
-----------------------------------------------------------------------------------------
	local x = 2. * math.pi * i_frequency / i_sampleRate
	local c = (2. - math.cos (x)) - math.sqrt (math.pow (2. - math.cos (x), 2.) - 1.)

	return { c, 1. - c }
end


function LowPass:Render (i_coeffs, i)
-----------------------------------------------------------------------------------------
	self [1] = self [1] * i_coeffs [1] + i * i_coeffs [2]
	return self [1]
end


return LowPass;
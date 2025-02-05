-- lowpass.lua
-- first-order low pass

LowPass = {}

function LowPass:new ()
-----------------------------------------------------------------------------------------
	local o = { 0 }

	setmetatable (o, self); self.__index = self
	return o
end


function LowPass:Reset ()
	self [1] = 0
end


function LowPass:_GetGainAtFrequency (i_frequency)
	local a = self [1]

	local w = i_frequency/self.sampleRate * math.pi * 2

	return (1-a) / math.sqrt (1 - 2 * a * math.cos (w) + a*a)
end


function LowPass:GetCoeffs (i_sampleRate, i_frequency)
-----------------------------------------------------------------------------------------
	local x = 2. * math.pi * i_frequency / i_sampleRate
	local c = (2. - math.cos (x)) - math.sqrt (math.pow (2. - math.cos (x), 2.) - 1.)

	local coeffs = { c, 1. - c, sampleRate = i_sampleRate }

	coeffs.GetGainAtFrequency = self._GetGainAtFrequency

	return coeffs
end


function LowPass:Render (i_coeffs, i)
-----------------------------------------------------------------------------------------
	self [1] = self [1] * i_coeffs [1] + i * i_coeffs [2]
	return self [1]
end


return LowPass;
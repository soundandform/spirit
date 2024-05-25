-- lowpass.lua

	LowPass = {}


function LowPass:new (o)
-----------------------------------------------------------------------------------------
	local o = { s = 0; c = 0; _1c = 0; }

	setmetatable (o, self); self.__index = self
	return o
end

function LowPass:Set (i_sampleRate, i_frequency)
-----------------------------------------------------------------------------------------
	local x = 2. * math.pi * i_frequency/i_sampleRate;
	local c = (2. - math.cos(x)) - math.sqrt (math.pow (2. - math.cos(x), 2.) - 1.)

	self.c = c	
	self._1c = 1. - c
end


function LowPass:Render (i)
-----------------------------------------------------------------------------------------
	self.s = self.s * self.c + i * self._1c;
	return self.s
end


return LowPass;
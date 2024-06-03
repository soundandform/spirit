-- svf.lua
-- License

local SVF = {}


function SVF:new ()

	local obj = { low = 0.; mid = 0.; high = 0. }

	setmetatable (obj, self)
	self.__index = self

	return obj
end


function  SVF:GetCoeffs  (i_sampleRate, i_frequency, i_q)

    local coeffs = {}

    coeffs.f = 2. * math.sin (math.pi * i_frequency / i_sampleRate)
    coeffs.nfq = -1. * coeffs.f * i_q;
	coeffs.oneOverQ = 1. / i_q;

    return coeffs;
end


function  SVF:Render  (i_coeffs, i_input)

    self.mid = (i_coeffs.nfq * self.high);							
	self.low = (i_coeffs.f * self.mid);								
	self.high = self.low * i_coeffs.oneOverQ + self.mid - i_input;

	return self
end


return SVF


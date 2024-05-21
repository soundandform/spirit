-- svf.lua

local SVF = {}


function SVF:new ()

	local obj = { low = 0.; mid = 0.; high = 0. }

	setmetatable (obj, self)
	self.__index = self

	return obj
end


function  SVF:GenerateCoeffs  (i_sampleRate, i_frequency, i_q)
    local coeffs = {}

    coeffs.f = 2. * math.sin (math.pi * i_frequency / i_sampleRate)
    coeffs.nfq = -1. * coeffs.f * i_q;
	coeffs.oneOverQ = 1. / i_q;

    return coeffs;
end


function  SVF:Render  (i_coeffs, i_input)

    m_band [1] = (i_coeffs.nfq * m_band [2]);							
	m_band [0] = (i_coeffs.f * m_band [1]);								
	m_band [2] = m_band [0] * i_coeffs.oneOverQ + m_band [1] - i_input;

end


return SVF


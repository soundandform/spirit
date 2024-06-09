-- biquad.lua



local Biquad = {}


function Biquad:new ()

	local obj = { y1= 0, y2= 0, x1= 0, x2= 0 }

	setmetatable (obj, self)
	self.__index = self

	return obj
end


function NormalizeCoefficients (b0,b1,b2,a0,a1,a2)

	local coeffs =  {}
	coeffs.c0 = b0 / a0
	coeffs.c1 = b1 / a0
	coeffs.c2 = b2 / a0
	coeffs.c3 = a1 / a0
	coeffs.c4 = a2 / a0

	return coeffs
end


function  Biquad:GetCoeffs_LowPass  (i_sampleRate, i_frequency, i_q)

	local w0 = 2. * math.pi * i_frequency / i_sampleRate
	local cosine = math.cos (w0)
	local alpha = math.sin (w0) / (2. * i_q)

	local b0, b1, b2, a0, a1, a2

	b0 =  (1. - cosine) / 2.
	b1 =   1. - cosine
	b2 =  (1. - cosine) / 2.
	a0 =   1. + alpha
	a1 =  -2. * cosine
	a2 =   1. - alpha

	return NormalizeCoefficients (b0, b1, b2, a0, a1, a2)
end


function  Biquad:Render  (i_coeffs, i_input)

	local out = i_input * i_coeffs.c0

	out = out + (i_coeffs.c1 * self.x1)
	out = out + (i_coeffs.c2 * self.x2)
	out = out - (i_coeffs.c3 * self.y1)
	out = out - (i_coeffs.c4 * self.y2)

	self.y2 = self.y1
	self.y1 = out

	self.x2 = self.x1
	self.x1 = i_input

	return out
end


return Biquad


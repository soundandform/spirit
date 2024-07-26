-- biquad.lua
local Biquad = {  }

function Biquad:new ()

	local obj = {}

	setmetatable (obj, self)
	self.__index = self

	obj:Reset ()

	return obj
end


function Biquad:Reset ()
	self.y1= 0
 	self.y2= 0
 	self.x1= 0
 	self.x2= 0
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


function Sine (i_sampleRate, i_frequency)
	local w0 = 2. * math.pi * i_frequency / i_sampleRate
	return math.sin (w0)
end

function Cosine (i_sampleRate, i_frequency)
	local w0 = 2. * math.pi * i_frequency / i_sampleRate
	return math.cos (w0)
end


function Alpha (i_sampleRate, i_frequency, i_q)
	return Sine (i_sampleRate, i_frequency) / (2. * i_q)
end


function   Biquad:GetCoeffs_HighPass  (i_sampleRate, i_frequency, i_q)

	local cosine = Cosine (i_sampleRate, i_frequency)
	local alpha = Alpha (i_sampleRate, i_frequency, i_q)
		
	local b0, b1, b2, a0, a1, a2

	b0 =  (1. + cosine) / 2.;
	b1 = -(1. + cosine);
	b2 =  (1. + cosine) / 2.;
	a0 =   1. + alpha;
	a1 =  -2. * cosine;
	a2 =   1. - alpha;
		
	return NormalizeCoefficients(b0, b1, b2, a0, a1, a2);
end


function  Biquad:GetCoeffs_LowPass  (i_sampleRate, i_frequency, i_q)

	local cosine = Cosine (i_sampleRate, i_frequency)
	local alpha = Alpha (i_sampleRate, i_frequency, i_q)

	local b0, b1, b2, a0, a1, a2

	b0 =  (1. - cosine) / 2.
	b1 =   1. - cosine
	b2 =  (1. - cosine) / 2.
	a0 =   1. + alpha
	a1 =  -2. * cosine
	a2 =   1. - alpha

	return NormalizeCoefficients (b0, b1, b2, a0, a1, a2)
end


function  Biquad:GetCoeffs_Peaking  (i_sampleRate, i_frequency, i_q, i_gain)

	local cosine = Cosine (i_sampleRate, i_frequency)
	local alpha = Alpha (i_sampleRate, i_frequency, i_q)
	local A = math.sqrt (i_gain);
		
	local b0, b1, b2, a0, a1, a2;

	b0 =  1. + alpha * A;
	b1 = -2. * cosine;
	b2 =  1. - alpha * A;
	a0 =  1. + alpha / A;
	a1 = -2. * cosine;
	a2 =  1. - alpha / A;

	return NormalizeCoefficients (b0, b1, b2, a0, a1, a2)
end


function  Biquad:GetCoeffs_HighShelf (i_sampleRate, i_frequency, i_q, i_gain)

	local cosine = Cosine (i_sampleRate, i_frequency)
	local alpha = Alpha (i_sampleRate, i_frequency, i_q)

	local A = math.sqrt (i_gain);
	local sqrtA = math.sqrt (A);
		
	local b0, b1, b2, a0, a1, a2;
		
	b0 =      A*( (A+1.0) + (A-1.0)*cosine + 2.0*sqrtA*alpha );
	b1 = -2.0*A*( (A-1.0) + (A+1.0)*cosine                   );
	b2 =      A*( (A+1.0) + (A-1.0)*cosine - 2.0*sqrtA*alpha );
	a0 =          (A+1.0) - (A-1.0)*cosine + 2.0*sqrtA*alpha  ;
	a1 =    2.0*( (A-1.0) - (A+1.0)*cosine                   );
	a2 =          (A+1.0) - (A-1.0)*cosine - 2.0*sqrtA*alpha  ;
		
	return NormalizeCoefficients (b0, b1, b2, a0, a1, a2)
end


function  Biquad:GetCoeffs_Notch  (i_sampleRate, i_frequency, i_q, i_gain)

	local cosine = Cosine (i_sampleRate, i_frequency)
	local alpha = Alpha (i_sampleRate, i_frequency, i_q)
		
	local b0, b1, b2, a0, a1, a2;

	b0 =  1.;
	b1 = -2. * cosine;
	b2 =  1.;
	a0 =  1. + alpha;
	a1 = -2. * cosine;
	a2 =  1. - alpha;

	return NormalizeCoefficients (b0, b1, b2, a0, a1, a2)
end

----------------------------------------------------------------------------------------------------------------------------------------

function  Biquad:RenderDFI  (i_coeffs, i_input) -- direct form I

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


function  Biquad:Render  (i_coeffs, i_input)	-- transposed direct form II (https://www.earlevel.com/main/2003/02/28/biquads/)

	local out = i_input * i_coeffs.c0 + self.y2

	self.y2 = self.y1 + i_coeffs.c1 * i_input - i_coeffs.c3 * out
	self.y1 = i_coeffs.c2 * i_input - i_coeffs.c4 * out

	return out
end

return Biquad


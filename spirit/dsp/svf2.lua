-- svf2.lua  
--https://cytomic.com/files/dsp/SvfLinearTrapOptimised2.pdf

local SVF2 = {}		

function SVF2:new ()
	local obj = {}

	setmetatable (obj, self)
	self.__index = self

	obj:Reset ()

	return obj;
end


function  SVF2:Reset  ()

	self.ic1 = 0.;
	self.ic2 = 0.;
	self.low = 0.;
 	self.mid = 0.;
 	self.high = 0.;

end



function  SVF2:GetCoeffs  (i_sampleRate, i_frequency, i_q)

	local c = {}

	local q = i_q  * math.cos (math.pi * i_frequency / i_sampleRate);

	c.g  = math.tan (math.pi * i_frequency / i_sampleRate)
	c.k  = 1. / q
	c.a1 = 1. / (1. + c.g * (c.g + c.k));
	c.a2 = c.g * c.a1;

	return c
end


function  SVF2:Render  (i_coeffs, i_input)

		self.mid = (i_coeffs.a1) * self.ic1 + (i_coeffs.a2) * (i_input - self.ic2);
		self.low = self.ic2 + i_coeffs.g * self.mid
		
		self.ic1 = 2. * self.mid - self.ic1;
		self.ic2 = 2. * self.low - self.ic2;

	 	self.mid = self.mid * i_coeffs.k;
		
		self.high = i_input - (self.low + self.mid);
	return self
end

return SVF2
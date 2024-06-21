-- ratpoly.lua


local RatPoly = {}


function RatPoly:new (i_numerator, i_denominator)

	local obj = { n= i_numerator, d= i_denominator }

	setmetatable (obj, self)
	self.__index = self

	return obj
end




function RatPoly:Render (i_x, i_coeffs)

	i_coeffs = i_coeffs or self

	local numerator, denominator = 0, 0;

	local x = i_x

	local s = #self.n
	for i = 1,s do
		numerator = numerator + x * i_coeffs.n [s + 1 - i]
		x = x * i_x
	end

	x = i_x
	s = #self.d
	for i = 1,s do
		denominator = denominator + x * i_coeffs.d [s + 1 - i]
		x = x * i_x
	end

	return numerator / denominator

end



return RatPoly
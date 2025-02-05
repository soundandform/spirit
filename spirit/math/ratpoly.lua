-- ratpoly.lua

-- local RatPoly				= require 'spirit.math.ratpoly'



local RatPoly = {}


function RatPoly:new (i_numerator, i_denominator)

	local obj = { n= i_numerator, d= i_denominator }

	setmetatable (obj, self)
	self.__index = self

	return obj
end





function RatPoly:Render (i_x, i_coeffs)

	i_coeffs = i_coeffs or self


	local s = #i_coeffs.n
	local numerator = i_coeffs.n [s]
	local x = i_x

	for i = 1,s-1 do
		numerator = numerator + x * i_coeffs.n [s - i]
		x = x * i_x
	end

	s = #i_coeffs.d
	local denominator = i_coeffs.d [s]
	x = i_x

	for i = 1,s-1 do
		denominator = denominator + x * i_coeffs.d [s - i]
		x = x * i_x
	end

	return numerator / denominator

end




return RatPoly
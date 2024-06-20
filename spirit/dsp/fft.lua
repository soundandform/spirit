-- fft.lua

-- Using https://github.com/malfet/pocketfft
-- TODO: add complex FFT

local ffi = require ("ffi")
local std = require ("spirit.std")

ffi.cdef 
[[

typedef struct rfft_plan_i * rfft_plan;

rfft_plan 	make_rfft_plan 		(size_t length);
void 		destroy_rfft_plan 	(rfft_plan plan);

int 		rfft_backward		(rfft_plan plan, double c[], double fct);
int			rfft_forward		(rfft_plan plan, double c[], double fct);

size_t 		rfft_length 		(rfft_plan plan);

]]



local FFT = {}

function  FFT:real  (i_size)

	local obj = nil

	if (type (i_size) == "number") then
		
		if (i_size > 0) then
			local plan = ffi.C.make_rfft_plan (i_size)
			print (i_size)

			ffi.gc (plan, function (i_plan) ffi.C.destroy_rfft_plan (i_plan) end)

			obj = { fft= plan }

			setmetatable (obj, self)
			self.__index = self
		end
	end


	return obj
end


function  FFT:forward  (i_values, i_scale)

	if i_values then
	
		if (type (i_values) == 'table') then
			i_values = std:cArrayFromTable (i_values)
		end

		ffi.C.rfft_forward (self.fft, i_values, i_scale or 1)

		return std:cArrayToTable (i_values, self:size ())
	end
end


function  FFT:inverse  (i_values, i_scale)

	i_scale = i_scale or 1. / ffi.C.rfft_length (self.fft)

	ffi.C.rfft_backward (self.fft, i_values, i_scale)
end


function  FFT:size  ()
	return tonumber( ffi.C.rfft_length (self.fft))
end


return FFT

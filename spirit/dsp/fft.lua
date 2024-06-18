-- fft.lua

local ffi = require ("ffi")

ffi.cdef 
[[

typedef struct rfft_plan_i * rfft_plan;

rfft_plan make_rfft_plan (size_t length);
void destroy_rfft_plan (rfft_plan plan);
int rfft_backward(rfft_plan plan, double c[], double fct);
int rfft_forward(rfft_plan plan, double c[], double fct);

size_t rfft_length (rfft_plan plan);

]]



local FFT = {}

function FFT:real (i_size)

	local obj = nil

	if (type (i_size) == "number") then
		local plan = ffi.C.make_rfft_plan (i_size)

		ffi.gc (plan, function (i_plan) ffi.C.destroy_rfft_plan (i_plan) end)

		obj = { fft= plan }

		setmetatable (obj, self)
		self.__index = self
	end
	return obj
end




return FFT

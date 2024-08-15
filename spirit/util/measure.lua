-- measure.lua

local FFT 		= require 'spirit.dsp.fft'
local convert	= require 'spirit.util.convert'
local Array 	= require 'spirit.array'


local Measure = {}


function  Measure:ImpulseResponse  (i_function, i_sampleRate, i_timeInSeconds)

	local numSamples = i_timeInSeconds * i_sampleRate

	local ir = Array:new (numSamples)

	local i = 1

	for n = 1, numSamples do
		ir [n] = i_function (i)
		i = 0
	end

	return ir

end




function Measure:FFTMagPhase (i_samples, i_sampleRate, i_options)

	i_options = i_options or {}
	---------------------------------------------------------------------------------------------------------------------
	local numPoints = i_options ['numPoints'] or 2000
	local f1 		= i_options ['f1'] or 20
	local f2 		= i_options ['f2'] or 22000
	---------------------------------------------------------------------------------------------------------------------

	local f = {}	-- freqs
	local m = {}	-- magnitude in dB
	local p = {}	-- phase in radians or degrees

	local fft = FFT:real (#i_samples)

	local copy = i_samples:copy ()

	fft:forward (copy)

	local ri = copy

	local halfFFTSize = #i_samples * .5;
	local fstep = i_sampleRate * .5 / halfFFTSize;
	local previ = -1


	f2 = math.min (i_sampleRate * .5, f2)

	if (f2 > f1) then
		for p = 0, numPoints-1 do

			local nextFreq = convert:linearToLog (p, 0, numPoints - 1, f1, f2)

			local i = math.floor (nextFreq / fstep)									--	print (i)

			if (i ~= previ and i > 0) then

				-- i = 1 refers to first fft bin which starts at ri [2] (r[1] is DC)
				local real,imag = ri [1 + i*2], ri [1 + i*2+1]

				f [#f+1] = fstep * i
				m [#m+1] = convert:gainTodB (math.sqrt (real * real + imag * imag))

				previ = i
			end

		end
	end

	return f, m, p

end



return Measure
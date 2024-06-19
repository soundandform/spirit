-- convert.lua

function gainTodB (i_gain)

	i_gain = math.abs (i_gain) + 1e-300;

	return 20. * math.log10 (i_gain);
	
end


function dBToGain (i_dB)
	return math.pow (10., i_dB / 20.); 
end 
-- convert.lua

local Conversions = {}


function Conversions:gainTodB (i_gain)

	i_gain = math.abs (i_gain) + 1e-300;

	return 20. * math.log10 (i_gain);
	
end


function Conversions:dBToGain (i_dB)
	return math.pow (10., i_dB / 20.); 
end 


function Conversions:linearToLog (i_value, i_minLinear, i_maxLinear, i_minLog, i_maxLog)

	local power = math.log10 (i_maxLog / i_minLog)
	local normalized = self:normalizeRange (i_value, i_minLinear, i_maxLinear)
	
	return i_minLog * math.pow (10., normalized * power)
end



function  Conversions:normalizeRange  (i_value, i_min, i_max)

	i_value = math.max (i_min, i_value)
	i_value = math.min (i_max, i_value)
	
	return (i_value - i_min) / (i_max - i_min)
end

return Conversions
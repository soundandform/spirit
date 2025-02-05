-- waveform.lua

Waveform = {}

function Waveform:new (i_source, i_lineNum)
-----------------------------------------------------------------------------------------
	local o = { source= i_source, line = i_lineNum }

	setmetatable (o, self); self.__index = self

	return o
end


function Waveform:addRegion (...)

	
	sluggo_waveform (self.source, self.line, ...)
end


function Waveform:setBounds (...)
	sluggo_waveform (self.source, self.line, "bounds", ...)
end


return Waveform
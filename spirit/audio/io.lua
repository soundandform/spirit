-- io.lua

local std 					= require 'spirit.std'
local Streams				= require 'spirit.streams'
local debug 				= require 'spirit.debug.table'


local IO = {}

function IO:new ()
------------------------------------------------------------------------
	o = {}

	o.outStream = Streams:new ()

	setmetatable (o, self); self.__index = self
	return o
end



function IO:output (i_channels, i_source)

	if std:isNumber (i_channels) then
		i_channels = { i_channels }
	end

	if (std:isArray (i_source) or std:isFunction (i_source)) then
		self.outputs = i_channels
		self.source = i_source

--		if (std:isArray (i_source) then
--			self.duration =
--		end
	else
		error ("expected Array <f64> or reader() source")
	end
	
end


function IO:capturePackets (i_finalizer)
	
	local array = Array:new ()
	
	local handler = function (i_packet)

		for i = 1, #i_packet do
			array [#array + 1] = i_packet [i]
		end

		if (i_packet:isFinal ()) then
			i_finalizer (array, self)
		end
	end

end


--fuction IO:setDurationInSamples


function IO:start (i_durationInSamplesOrSeconds)

	-- if duration < 100 then seconds else numSamples

--	self.duration = self.duration or i_durationInSamplesOrSeconds

	self.outStream:send (self.source)

--	debug:dump (self)

	sluggo_StartIOTask (self)

end



return IO
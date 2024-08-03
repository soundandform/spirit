-- libsndfile.lua

local LibSndFile = {}

local Array 	= require 'spirit.array'
local Libsndfile = require 'spirit.lib.sndfile'

--print ("libsndfile:", Libsndfile:version ())

local bufferSize = 4096


function LibSndFile:read (i_path)

	i_path = i_path or ""


	local stream = {}


	function stream:getReader (i_startIndex)

		local start = i_startIndex or 0

		start = self.sf:seek (start)
		if (start == -1) then error ("error seeking sound file") end

		local n = self:numFrames () - start

		local channels = self:numChannels ()
		local samples = Array:new (bufferSize * channels)

		local i = 0
		self.sf:read (samples)

		local reader = function (index)

			if (type (index) == 'number') then
				--print ("sf seeking: ", index)
				index = self.sf:seek (index)
				if (index == -1) then error ("error seeking sound file") end
				n = self:numFrames () - index
			end
			

			local v = nil

			if (n > 0) then

				v = samples [1 + i * channels]		-- pick off the first channel

				i = i + 1
				n = n - 1

				if (i == bufferSize) then
					self.sf:read (samples)
					i = 0
				end

--			elseif (n == 0) then
--				n = -1
			end

			return v
		end

		return reader

	end

	function stream:getSampleRate ()
		return self.sf:getInfo () ['samplerate']
	end


	function stream:numChannels ()
		return self.sf:getInfo () ['channels']
	end

	function stream:numFrames ()
		return self.sf:getInfo () ['frames']
	end

	function stream:bounds ()
		return 0, self:numFrames ()
	end

	function stream:toArray ()

		local array = Array:new (self:numFrames ())
			
		self.sf:seek (0)
		self.sf:read (array)

		return array
	end

	function stream:close ()
		local r,msg = self.sf:close ()
		self.sf = nil

		return r,msg
	end


	stream.sf = Libsndfile:open (i_path);

	return stream

end



return LibSndFile

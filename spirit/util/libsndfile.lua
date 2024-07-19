-- libsndfile.lua

local LibSndFile = {}

local ffi 		= require "ffi"
local Array 	= require 'spirit.array'

ffi.cdef [[

typedef int64_t sf_count_t;

typedef struct 
{	
	sf_count_t	frames;
	int			samplerate;
	int			channels;
	int			format;
	int			sections;
	int			seekable;
} 
SF_INFO;

enum EMode
{
	SFM_READ	= 0x10,
	SFM_WRITE	= 0x20,
	SFM_RDWR	= 0x30
};

typedef void SNDFILE;

const char * 	sf_version_string 	(void) ;
void * 			sf_open				(const char * path, enum EMode mode, SF_INFO * sfinfo) ;
int				sf_close			(SNDFILE * sndfile);

sf_count_t		sf_readf_double		(SNDFILE * sndfile, double * ptr, sf_count_t frames) ;

sf_count_t  	sf_seek         	(SNDFILE *sndfile, sf_count_t frames, int whence);

]]

local bufferSize = 1024


--local info = ffi.new "SF_INFO"




function LibSndFile:read (i_path)

	i_path = i_path or ""


	local stream = 
	{
		info = ffi.new "SF_INFO"
	}


	function stream:getReader (i_startIndex)

		local start = i_startIndex or 0

		ffi.C.sf_seek (self.sf, start, 0)

		local n = self:numFrames ()
		local channels = self:numChannels ()
		local samples = ffi.new ('double [?]', bufferSize * channels)

		local i = 0
		ffi.C.sf_readf_double (self.sf, samples, bufferSize)

		local reader = function ()

			local v = nil

			if (n > 0) then

				v = samples [i * channels]		-- pick off the first channel

				i = i + 1
				n = n - 1

				if (i == bufferSize) then
					ffi.C.sf_readf_double (self.sf, samples, bufferSize)
					i = 0
				end

			elseif (n == 0) then
		--		ffi.C.sf_close (self.sf)
		--		self.sf = nil
				n = -1
			end

			return v
		end

		return reader

	end

	function stream:sampleRate ()
		return tonumber (self.info.samplerate)
	end


	function stream:numChannels ()
		return tonumber (self.info.channels)
	end

	function stream:numFrames ()
		return tonumber (self.info.frames)
	end

	function stream:bounds ()
		return 0, self:numFrames ()
	end

	function stream:toArray ()
		local array = Array:new (self:numFrames ())
		local reader = self:getReader ()

		for i = 1, #array do
			array [i] = reader ()
		end

		return array
	end

--	function stream:close ()
--		ffi.C.sf_close (self.sf)
--		self.sf = nil
--	end

	local sndfile = ffi.C.sf_open (i_path, 'SFM_READ', stream.info)

	ffi.gc (sndfile, function (i_sndfile) ffi.C.sf_close (i_sndfile) end)

	stream.sf = sndfile;

	return stream

end



return LibSndFile

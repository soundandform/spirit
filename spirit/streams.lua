-- streams.lua

--sluggo:bind ('streams')

local ffi = require ("ffi")

ffi.cdef 
[[
	typedef struct SgStream;
	typedef double f64;
	typedef int64_t i64;

	void * 	sluggo_AcquireStream (void * i_sequence, const char * i_identifier);
	void 	sluggo_StreamSend			(void * i_stream, i64 i_index, f64 i_value);
	void 	sluggo_StreamEndSend		(void * i_stream, i64 i_index);
	f64 	sluggo_StreamReceive		(void * i_stream);

]]



local Streams = {}


function Streams:new (i_identifier, i_numChannelsOrHandler, i_handler)

--	print ("seq : ", sluggo.sequence)

	if (type (i_numChannelsOrHandler) == 'function') then
		i_handler = i_numChannelsOrHandler
		i_numChannelsOrHandler = 1
	end

	local stream = ffi.C.sluggo_AcquireStream (sluggo.sequence, i_identifier)

	print ("isRender", sluggo_isRenderThread, "stream= ", stream)


	local obj = { stream= stream, handler= i_handler }


	setmetatable (obj, self)
	self.__index = self

--	obj:Reset ()

	return obj;
end


function Streams:send (i_readerFunctionOrSampleArray)

	if (type (i_readerFunctionOrSampleArray) == 'function') then
		self.reader = i_readerFunctionOrSampleArray

		local reader = i_readerFunctionOrSampleArray
		local index = 0

		while true do
			local v = reader ()
			if (v == nil) then break end

			ffi.C.sluggo_StreamSend (self.stream, index, v)
			index = index + 1
		end
		
		ffi.C.sluggo_StreamEndSend (self.stream, index)
	else
		
	end
end


function Streams:receive ()
--	print (self.stream)
	return ffi.C.sluggo_StreamReceive (self.stream)
end


return Streams
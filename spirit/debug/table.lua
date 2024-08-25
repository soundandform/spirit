-- table.lua


local TablePrinter = {}

function TablePrinter:tprint (tbl, indent)

	if (self.printed [tbl]) then 
		return "{ ... }";
	else
		self.printed [tbl] = true
	end

	indent = indent or 0

	if (indent > 100) then return "* stack overflow\n" end

	if next (tbl) == nil then
		return "{}";
	end
	

--  local toprint = string.rep(" ", indent) .. "{\r\n"
  local toprint = "{\r\n"

  indent = indent + 2
 
   for k, v in pairs(tbl) do
    toprint = toprint .. string.rep(" ", indent)

    if (type(k) == "number") then
      toprint = toprint .. "[" .. k .. "] = "
    elseif (type(k) == "string") then
      toprint = toprint  .. k ..  "= "
  	else
		toprint = toprint .. tostring (k) .. "= "
    end

    if (type(v) == "number") then
      toprint = toprint .. v .. ",\r\n"
    elseif (type(v) == "string") then
      toprint = toprint .. "\"" .. v .. "\",\r\n"
    elseif (type(v) == "boolean") then
      toprint = toprint .. tostring (v) .. ",\r\n"
    elseif (type(v) == "table") then
      toprint = toprint .. self:tprint(v, indent + 2) .. ",\r\n"
    else
      toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n"
    end
  end

  toprint = toprint .. string.rep(" ", indent-4) .. "}"
  return toprint

end

function TablePrinter:dump_table (table)

	self.printed = {}


	print ("------------------------------------------------")
	print (self:tprint (table))

end

return TablePrinter
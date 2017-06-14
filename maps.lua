local json = require 'json'

local Map = {}

function Map:new(o)
	o = o or {}

	if o.title == nil then o.title = "New Map" end
	if o.data == nil then o.data = {} end

	setmetatable(o, self)
	self.__index = self
	return o
end

function Map:load(file_name)

	content = love.filesystem.read(file_name)

	o = json.decode(content)
	return Map:new(o)

end


function Map:encode()
	return json.encode({title = self.title, data = self.data})
end

function Map:save()
	
	print(love.filesystem.getIdentity())
	print(self:encode())
	if not love.filesystem.exists("maps.map") then
		love.filesystem.write("maps.map", "\n")
	end
	success = love.filesystem.write("maps.map", self:encode())
	print("success: "..tostring(success))
end

return Map

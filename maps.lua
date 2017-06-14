local json = require 'json'

local Map = {}

function Map:new(o)
	o = o or {}

	if o.title == nil then o.title = "New Map" end
	if o.data == nil then 
    o.data = {}
    o.size = 512
    for y=1,o.size do
      o.data[y] = {} 
      for x=1,o.size do
        o.data[y][x] = 0
      end
    end

  else
    o.size = #o.data
  end

	setmetatable(o, self)
	self.__index = self
	return o
end

function Map:load(file_name)

	content = love.filesystem.read(file_name)

  
  if content == nil then return nil end

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

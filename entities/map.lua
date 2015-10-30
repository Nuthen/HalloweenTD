Map = class('Map')

function Map:initialize(width, height, nodeCount)
	self.tileWidth = love.graphics.getWidth()/width
	self.tileHeight = love.graphics.getHeight()/height
	
	self.width = width
	self.height = height

	self.tiles = {}
	
	for iy = 1, height do
		self.tiles[iy] = {}
		for ix = 1, width do
			self.tiles[iy][ix] = Tile:new(ix, iy, self.tileWidth, self.tileHeight)
		end
	end
	
	self.t = 0
	
	self:generatePath(width, height, nodeCount)
end

function Map:generatePath(width, height, nodeCount)
	self.nodes = {}
	
	self.i = 1
	self.startX, self.startY = math.random(1, width), math.random(1, height)
	table.insert(self.nodes, {self.startX, self.startY})
	self.tiles[self.startY][self.startX].nodeNumber = self.i
	
	self.i = self.i+1
	
	self.runGen = false
	self.nodeCount = nodeCount
	self.lastDir = 0
	
	
end

function Map:update(dt)
	self.t = self.t + dt
	
	if self.t > .3 then
		self.t = 0

		if self.i <= self.nodeCount then
			local dir = math.random(1, 4)
			local dist = math.random(2, 7)
			
			local dx, dy = 0, 0
			if dir == 1 then
				dx = 1
			elseif dir == 2 then
				dy = 1
			elseif dir == 3 then
				dx = -1
			elseif dir == 4 then
				dy = -1
			end
			
			if dir == self.lastDir + 2 or dir == self.lastDir - 2 then
				self.i = self.i - 1
			else
				local doAgain = true
				repeat -- reduces the dist value as long as it is more than 1
					if dist > 1 then 
						local newX = self.startX + dist*dx 
						local newY = self.startY + dist*dy
						if newX < 1 or newX > self.width or newY < 1 or newY > self.height then
							dist = dist - 1
						elseif self:checkAround(newX, newY) then -- successfully found a new node spot
							if dy ~= 0 then
								local minY = math.min(self.startY, newY)
								local maxY = math.max(self.startY, newY)
								for iy = minY, maxY do
									self.tiles[iy][newX]:changeBlock(2)
								end
								
							elseif dx ~= 0 then
								local minX = math.min(self.startX, newX)
								local maxX = math.max(self.startX, newX)
								for ix = minX, maxX do
									self.tiles[newY][ix]:changeBlock(2)
								end
							end
						
							table.insert(self.nodes, {newX, newY})
							self.tiles[newY][newX].nodeNumber = self.i
							self.startX, self.startY = newX, newY
							doAgain = false
							self.lastDir = dir -- only change lastDir when a new node is placed
						else
							dist = dist - 1
						end
					else
						doAgain = false
						self.i = self.i - 1
					end
				until (not doAgain)
			end
			
			self.i = self.i + 1
		end
	end
end

function Map:checkAround(x, y)
	for iy = y-1, y+1 do
		for ix = x -1, x+1 do
			if ix < 1 or ix > self.width or iy < 1 or iy > self.height then
			elseif self.tiles[iy][ix].block ~= 1 then
				return false
			end
		end
	end
	
	return true
end

function Map:draw()
	for iy = 1, #self.tiles do
		for ix = 1, #self.tiles[iy] do
			self.tiles[iy][ix]:draw()
		end
	end
end
Tile = class('Tile')

function Tile:initialize(x, y, width, height)
	self.tileX = x
	self.tileY = y
	
	self.screenX = (x-1)*width
	self.screenY = (y-1)*height
	
	self.img = love.graphics.newImage('img/dirt.png')
	self.sx = width/self.img:getWidth()
	self.sy = height/self.img:getHeight()

	self.block = 1
	self.tower = false
	self.nodeNumber = 0
end

function Tile:changeBlock(newBlock)
	self.block = newBlock

	if newBlock == 2 then
		self.img = love.graphics.newImage('img/Stone Wall.png')
	end
end

function Tile:draw()
	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(self.img, self.screenX, self.screenY, 0, self.sx, self.sy)
	
	if self.nodeNumber > 0 then
		love.graphics.print(self.nodeNumber, self.screenX, self.screenY)
	end
end
game = {}

function game:enter()
    self.map = Map:new(25, 20,  30)
end

function game:update(dt)
	self.map:update(dt)
end

function game:keypressed(key, isrepeat)
	if key == 'f5' then
		state.switch(game)
	end
end

function game:mousepressed(x, y, mbutton)

end

function game:draw()
--[[
    love.graphics.setColor(255, 255, 255)
    local text = "This is the game"
    local x = love.window.getWidth()/2 - font[48]:getWidth(text)/2
    local y = love.window.getHeight()/2
    love.graphics.setFont(font[48])
    love.graphics.print(text, x, y)
	]]
	
	self.map:draw()
end
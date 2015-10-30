options = {}
-- this is out here because it needs to be accessible before options:init() is called
options.file = 'config.txt'

function options:init()
	self.leftAlign = 75
	self.elements = {}
end

function options:add(obj)
	table.insert(self.elements, obj)
	return obj
end

function options:enter()
	self.elements = {}
	
	local config = nil
	if not love.filesystem.exists(self.file) then
		config = self:getDefaultConfig()
	else
		config = self:getConfig()
	end
	
    self.vsync = self:add(Checkbox:new('VERTICAL SYNC', self.leftAlign, 150+175))
	self.vsync.selected = config.display.flags.vsync
	
	self.fullscreen = self:add(Checkbox:new('FULLSCREEN', self.leftAlign, 190+175))
	self.fullscreen.selected = config.display.flags.fullscreen
	
	self.borderless = self:add(Checkbox:new('BORDERLESS', self.leftAlign, 230+175))
	self.borderless.selected = config.display.flags.borderless
	
	-- Takes all available resolutions
	local resTable = love.window.getFullscreenModes(1)
	local resolutions = {}
	for k, res in pairs(resTable) do
		if res.width > 800 then -- cuts off any resolutions with a width under 800
			table.insert(resolutions, {res.width, res.height})
		end
	end

	-- sort resolutions from smallest to biggest
	table.sort(resolutions, function(a, b) return a[1]*a[2] < b[1]*b[2] end)
	
	self.resolution = self:add(List:new('RESOLUTION: ', resolutions, self.leftAlign, 50+175, 400))
	self.resolution.listType = 'resolution'
	self.resolution:selectTable({config.display.width, config.display.height})
	self.resolution:setText('{1}x{2}')
	
	local fsaaOptions = {0, 2, 4, 8, 16}
	self.fsaa = self:add(List:new('ANTIALIASING: ', fsaaOptions, self.leftAlign, 90+175, 400))
	self.fsaa:selectValue(config.display.flags.fsaa)
	self.fsaa:setText('{}x')
	
	self.back = self:add(Button:new("< BACK", self.leftAlign, love.window.getHeight()-80))
	self.back.activated = function()
		state.switch(menu)
	end

	self.apply = self:add(Button:new('APPLY CHANGES', self.leftAlign+170, love.window.getHeight()-80))
	self.apply.activated = function ()
		self:applyChanges()
		self.back.y = love.window.getHeight()-80
		self.apply.y = love.window.getHeight()-80
	end
end

-- this is not a callback
function options:quit()
	state.switch(menu)
end

function options:applyChanges()
    self:save()
    self:load()

	return true
end

function options:mousepressed(x, y, button)
	for i, element in ipairs(self.elements) do
		element:mousepressed(x, y, button)
	end
end

function options:keypressed(key)
	if key == "escape" then
		self:quit()
	end
end

function options:draw()
	love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), 120+55)

    love.graphics.setFont(fontBold[72])
    love.graphics.setColor(0, 0, 0)
    love.graphics.print('OPTIONS', 75, 70)

    for i, element in ipairs(self.elements) do
		element:draw()
	end
end

function options:getDefaultConfig()
	local o = {
		display = {
			width = 1280,
			height = 720,

			-- these are the standard flags for love.window.setMode
			flags = {
				vsync = false,
				fullscreen = false,
				borderless = false,
				fsaa = 0,
			},
		},
		graphics = {

		},
	}
	return o
end

function options:save(conf)
	if conf == nil then
		 conf = {
			display = {
				width = self.resolution.options[self.resolution.selected][1],
				height = self.resolution.options[self.resolution.selected][2],

				-- these are the standard flags for love.window.setMode
				flags = {
					vsync = self.vsync.selected,
					fullscreen = self.fullscreen.selected,
					borderless = self.borderless.selected,
					fsaa = self.fsaa.options[self.fsaa.selected],
				},
			},
			graphics = {

			},
		}
	end
	love.filesystem.write(self.file, serialize(conf))
end

function options:load()
	local config = self:getConfig()
	
	love.window.setMode(config.display.width, config.display.height, config.display.flags)

	return true
end

function options:getConfig()
	assert(love.filesystem.exists(self.file), 'Tried to load config file, but it does not exist.')
	return love.filesystem.load(self.file)()
end
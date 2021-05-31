require("lib.batteries"):export()

if table.contains({}, love.system.getOS()) then
	--we'd normally have set this up properly in the app manifest but instead, set mode here
	love.window.setMode(1, 2)
else
	--emulate phone
	love.window.setMode(540, 960)
end

function love.resize(w, h) 
	sw, sh = w, h
	font_size = math.floor(math.min(sw, sh) / 20)
	love.graphics.setFont(love.graphics.newFont(font_size))
	love.keyboard.setKeyRepeat(true)
end

function love.load()
	love.resize(love.graphics.getDimensions())
end

function love.touchpressed()
	--touched the screen? open the keyboard
	love.keyboard.setTextInput(true)
end

local prompt_test = "lets enter some text"
local response_text = ""
local response_limit = 30
local caret_period = 1.3

function execute()
	--handle response here
	if response_text == "exit" then
		love.event.quit()
	elseif response_text == "win" then
		prompt_test = "great job"
	end
	response_text = ""
end

local utf8 = require("utf8")

function love.textinput(t)
	response_text = response_text .. t
	while utf8.len(response_text) > response_limit do
		response_text = response_text:sub(1, utf8.offset(response_text, response_limit + 1) - 1)
	end
	if t:find("\n") ~= nil then
		execute()
	end
end

function love.keypressed(k)
	if k == "backspace" and #response_text > 0 then
		response_text = response_text:sub(1, utf8.offset(response_text, -1) - 1)
	end

	if k == "return" then
		execute()
	end

	--dev conveniences
	if k == "escape" then
		love.event.quit()
	end
	if love.keyboard.isDown("lctrl", "rctrl") then
		if k == "q" then
			love.event.quit()
		elseif k == "r" then
			love.event.quit("restart")
		end
	end
end

function love.draw()
	love.graphics.clear(
		colour.hsl_to_rgb(
			love.timer.getTime() / 10,
			0.4,
			0.65
		)
	)
	love.graphics.translate(
		sw / 2,
		sh / 4
	)
	local caret = (math.wrap(love.timer.getTime(), 0, caret_period) < caret_period * 0.5 and "" or "|")
	--wiggle
	love.graphics.push()
	love.graphics.rotate(math.sin(love.timer.getTime() * 0.6 * math.tau) * 0.01)
	for i, v in ipairs({
		prompt_test,
		"> " ..response_text .. caret
	}) do
		love.graphics.print(
			v,
			-sw / 3,
			(i - 2) * font_size * 1.5
		)
	end
	love.graphics.pop()

	--draw some shape thing
	love.graphics.translate(0, sh / 4)
	local ngons = {3, 4, 5}
	local ngon_size = 30
	local ngon_scale = 3
	love.graphics.push()
	love.graphics.scale(ngon_scale)
	for i, ngon_sides in ipairs(ngons) do
		love.graphics.push()
		love.graphics.translate((i - #ngons / 2 - 0.5) * 1.5 * ngon_size, 0)
		love.graphics.rotate(love.timer.getTime() * 0.13 * math.tau)
		local p = vec2(ngon_size/2, 0)
		local s = sequence{p.x, p.y}
		for _ = 1, ngon_sides do
			p:rotatei(math.tau / ngon_sides)
			s:push(p.x)
			s:push(p.y)
		end
		love.graphics.line(unpack(s))
		love.graphics.pop()
	end
	love.graphics.pop()
end
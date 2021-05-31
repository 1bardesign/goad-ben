require("lib.batteries"):export()

if table.contains({"Android", "iOS"}, love.system.getOS()) then
	--(request portrait mode)
	love.window.setMode(1, 2)
else
	--(just fullscreen)
	love.window.setMode(0, 0, {
		fullscreen = "desktop"
	})
end

local sw, sh = love.graphics.getDimensions()
local font_size = math.floor(math.min(sw, sh) / 10)
love.graphics.setFont(love.graphics.newFont(font_size))
love.keyboard.setKeyRepeat(true)

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
	love.graphics.translate(
		sw / 2,
		sh / 2
	)
	local caret = (math.wrap(love.timer.getTime(), 0, caret_period) < caret_period * 0.5 and "" or "|")
	--wiggle
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
end

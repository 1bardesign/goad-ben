require("lib.batteries"):export()

love.window.setMode(1,2)

function love.touchpressed()
	love.keyboard.setTextInput(true)
end

local draw_text = "test text"

function love.textinput(t)
	draw_text = table.concat({draw_text, t}, "")
end

function love.draw()
	love.graphics.print(draw_text,10,10)
end

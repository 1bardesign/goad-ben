function love.conf(t)
	--(request mode on mobile)
	t.window.w = 1
	t.window.h = 2
	--(use desktop dimensions on desktop)
	t.window.fullscreen = "desktop"
end

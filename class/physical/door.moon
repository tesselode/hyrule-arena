export class Door extends Wall
	new: (...) =>
		super ...

		@isOpen = true
		@opacity = 0

	update: (dt) =>
		@tween\update dt

	open: =>
		with @tween\to self, 0.3, opacity: 0
			\oncomplete -> @isOpen = true

	close: =>
		with @tween\to self, 0.3, opacity: 1
			\oncomplete -> @isOpen = false

	draw: =>
		love.graphics.setColor 255, 255, 255, 255 * @opacity
		love.graphics.rectangle 'fill', @state.world\getRect self

export class Door extends Wall

	new: (...) =>
		super ...

		@isOpen = true
		@opacity = 0

	update: (dt) =>
		@tween\update dt

	open: =>
		@isOpen = true
		@tween\to self, 0.3, opacity: 0

	close: =>
		@isOpen = false
		@tween\to self, 0.3, opacity: 1

	draw: =>
		love.graphics.setColor 255, 255, 255, 255 * @opacity
		--love.graphics.rectangle 'fill', @state.world\getRect self

		super!

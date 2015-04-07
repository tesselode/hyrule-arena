export class Door extends Wall
	new: (...) =>
		super ...

		@open = false
		@opacity = 1

	update: (dt) =>
		@tween\update dt

	open: =>
		with @tween\to self, 0.3, opacity: 0
			\oncomplete -> @open = true

	close: =>
		with @tween\to self, 0.3, opacity: 1
			\oncomplete -> @open = false

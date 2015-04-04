-- util.lua, by Kingdaro
-- random functions i use sometimes in my games

local util = {}

function util.multiple(n, mult)
	if mult then
		return util.multiple(n / mult) * mult
	end
	return math.floor(n + 0.5)
end

function util.clamp(min, n, max)
	return n < min and min or n > max and max or n
end

function util.interpolate(value, target, delta)
	return value + (target - value) * util.clamp(0, delta, 1)
end

function util.map(items, func, ...)
	if type(func) == 'string' then
		for i=1, #items do
			items[i][func](items[i], ...)
		end
	elseif type(func) == 'function' then
		for i=1, #items do
			func(items[i], ...)
		end
	end
end

function util.intersects(a, b)
	return a.x < b.x + b.width
	and b.x < a.x + a.width
	and a.y < b.y + b.height
	and b.y < a.y + a.height
end

function util.shuffle(array)
	for i=1, #array do
		local j = love.math.random(i)
		array[i], array[j] = array[j], array[i]
	end
end

function util.trandom(array)
	return array[love.math.random(#array)]
end

function util.sign(n)
	return n > 0 and 1 or n < 0 and -1 or 0
end

function util.rsign()
	return love.math.random() > 0.5 and -1 or 1
end

function util.prandom(min, max)
	return love.math.random() * (max - min) + min
end

function util.distance(x1, y1, x2, y2)
	return ((x2 - x1)^2 + (y2 - y1)^2)^0.5
end

return util

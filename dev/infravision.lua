-- Handle infravision/heightened_senses which allow to see outside of lite radius but with LOS
		if self:attr("infravision") or self:attr("heightened_senses") then
			local radius = math.max((self.heightened_senses or 0), (self.infravision or 0))
			radius = math.min(radius + bonus, self.sight)
			local rad2 = math.max(1, math.floor(radius / 4))
			self:computeFOV(radius, "block_sight", function(x, y, dx, dy, sqdist) if game.level.map(x, y, game.level.map.ACTOR) then game.level.map.seens(x, y, fovdist[sqdist]) end end, true, true, true)
			self:computeFOV(rad2, "block_sight", function(x, y, dx, dy, sqdist) game.level.map:applyLite(x, y, fovdist[sqdist]) end, true, true, true)
		end

		-- Compute both the normal and the lite FOV, using cache
		-- Do it last so it overrides others
		self:computeFOV(self.sight or 10, "block_sight", function(x, y, dx, dy, sqdist)
			game.level.map:apply(x, y, fovdist[sqdist])
		end, true, false, true)
		if self.lite <= 0 then game.level.map:applyLite(self.x, self.y)
		else self:computeFOV(self.lite + bonus, "block_sight", function(x, y, dx, dy, sqdist) game.level.map:applyLite(x, y) end, true, true, true) end

		-- For each entity, generate lite
		local uid, e = next(game.level.entities)
		while uid do
			if e ~= self and e.lite and e.lite > 0 and e.computeFOV then
				e:computeFOV(e.lite, "block_sight", function(x, y, dx, dy, sqdist) game.level.map:applyExtraLite(x, y, fovdist[sqdist]) end, true, true)
			end
			uid, e = next(game.level.entities, uid)
		end
-- Veins of the Earth
-- Zireael
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
--
-- Nicolas Casalini "DarkGod"
-- darkgod@te4.org

newEntity{
	define_as = "UP",
	name = "previous level",
	display = '<', color_r=255, color_g=255, color_b=0, back_color=colors.DARK_GREY,
	notice = true,
	always_remember = true,
	change_level = -1,
}

newEntity{
	define_as = "DOWN",
	name = "next level",
	display = '>', color_r=255, color_g=255, color_b=0, back_color=colors.DARK_GREY,
	notice = true,
	always_remember = true,
	change_level = 1,
}

newEntity{
	define_as = "SHAFT_UP",
	name = "previous level",
	display = '<', color_r=210, color_g=105, color_b=30, back_color=colors.DARK_GREY,
	notice = true,
	always_remember = true,
	change_level = -2,
}

newEntity{
	define_as = "SHAFT_DOWN",
	name = "next level",
	display = '>', color_r=210, color_g=105, color_b=30, back_color=colors.DARK_GREY,
	notice = true,
	always_remember = true,
	change_level = 2,
}


newEntity{
	define_as = "FLOOR",
	name = "floor", image = "terrain/marble_floor.png",
	display = ' ', color_r=255, color_g=255, color_b=255, back_color=colors.DARK_GREY,
}

newEntity{
	define_as = "WALL",
	name = "wall", image = "terrain/granite_wall1.png",
	display = '#', color=colors.BLACK, back_color={r=30, g=30, b=60},
	always_remember = true,
	does_block_move = true,
	can_pass = {pass_wall=1},
	block_sight = true,
	air_level = -20,
	dig = "FLOOR",
}

newEntity{
	define_as = "DOOR",
	name = "door", image = "terrain/granite_door1.png",
	display = '+', color_r=238, color_g=154, color_b=77, back_color=colors.DARK_UMBER,
	notice = true,
	always_remember = true,
	block_sight = true,
	door_opened = "DOOR_OPEN",
	dig = "DOOR_OPEN",
}

newEntity{
	define_as = "DOOR_OPEN",
	name = "open door", image = "terrain/granite_door1_open.png",
	display = "'", color_r=238, color_g=154, color_b=77, back_color=colors.DARK_GREY,
	always_remember = true,
	door_closed = "DOOR",
}

-- Special stuff

newEntity{
	define_as = "MOSS",
	type = "floor", subtype = "vegetation",
	name = "luminescent moss",
	display = '¤', color_r=52, color_g=222, color_b=137, back_color=colors.GREY,
}

newEntity{
	define_as = "WATER",
	type = "floor", subtype = "water",
	name = "water", image = "terrain/marble_floor.png",
	display = '~', color=colors.BLUE, back_color=colors.LIGHT_BLUE,
	always_remember = true,
	mindam = 1,
	maxdam = 4,
	on_stand = function(self, x, y, who)
		local save = who:skillCheck("swim", 10)
		if not save then
			local DT = engine.DamageType
			local dam = DT:get(DT.WATER).projector(self, x, y, DT.WATER, rng.dice(self.mindam, self.maxdam))
		 	if dam > 0 then game.logPlayer(who, "You start drowning!") end
		end
	end,
}

newEntity{
	define_as = "DEEP_WATER",
	type = "floor", subtype = "water",
	name = "deep water", 
	display = '~', color=colors.BLUE, back_color=colors.DARK_BLUE,
	always_remember = true,
	mindam = 2,
	maxdam = 6,
	on_stand = function(self, x, y, who)
		local save = who:skillCheck("swim", 15)
		if not save then
			local DT = engine.DamageType
			local dam = DT:get(DT.WATER).projector(self, x, y, DT.WATER, rng.dice(self.mindam, self.maxdam))
		 	if dam > 0 then game.logPlayer(who, "You start drowning!") end end
	end
}


newEntity{
	define_as = "LAVA",
	type = "floor", subtype = "lava",
	name = "lava",
	display = '~', color=colors.RED, back_color=DARK_GREY,
	always_remember = true,
	mindam = 2,
	maxdam = 6,
	on_stand = function(self, x, y, who)
		local DT = engine.DamageType
		local dam = DT:get(DT.LAVA).projector(self, x, y, DT.LAVA, rng.dice(self.mindam, self.maxdam))
		if dam > 0 then game.logPlayer(who, "The lava burns you!") end
	end
}

newEntity{
	define_as = "CHASM",
	type = "floor", subtype = "chasm",
	name = "floor", 
	display = '~', color_r=43, color_g=43, color_b=43, back_color=DARK_GREY,
	on_stand = function(self, x, y, who)
		if who == game.player then
	game:changeLevel(game.level.level + rng.dice(1,6)) end
	end
}

newEntity{
	define_as = "WEB",
	type = "floor", subtype = "web",
	name = "webbing", 
	display = '#', color=colors.DARK_GREY, back_color=colors.GREY,
	always_remember = true,
}

newEntity{
	define_as = "ICE",
	type = "floor", subtype = "ice",
	name = "ice floor", 
	display = ' ', color=colors.STEEL_BLUE, back_color=colors.STEEL_BLUE,
	always_remember = true,
	on_stand = function(self, x, y, who)
		local save = who:skillCheck("balance", 15)
		if not save then who:setEffect(who.EFF_FELL, 1, {}) end 
	end
}

newEntity{
	define_as = "FUNGI",
	type = "floor", subtype = "fungi",
	name = "underground fungi", 
	display = '#', color=colors.CHOCOLATE, back_color=colors.DARK_GREY,
	always_remember = true,
}

newEntity{
	define_as = "SAND",
	type = "floor", subtype = "sand",
	name = "sand", 
	display = ' ', color=colors.YELLOW, back_color=colors.GREY,
	always_remember = true,
}

newEntity{
	define_as = "SWAMP",
	type = "floor", subtype = "swamp",
	name = "sand", 
	display = ' ', color=colors.UMBER, back_color=colors.DARK_GREEN,
	always_remember = true,
}
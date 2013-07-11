newTalentType{ type="special/special", name = "special", description = "Special" }

newTalent{
	name = "Show Spellbook", image = "talents/spellbook.png",
	type = {"special/special",1},
	mode = "activated",
	points = 1,
	cooldown = 0,
	range = 0,
	action = function(self, t)
		local book = require("mod.dialogs.SpellBook").new(self)
		game:registerDialog(book)
		return nil
	end,
	info = function(self, t )
		return "Shows your spellbook"
	end,
}

-- Default archery attack
newTalent{	
	name = "Shoot",
	type = {"special/special", 1},
	mode = 'activated',
	--require = ,
	points = 1,
	cooldown = 8,
	tactical = { ATTACK = 1 },
	requires_target = true,
	on_pre_use = function(self, t, silent) if not self:hasArcheryWeapon() then if not silent then game.logPlayer(self, "You require a rangede weapon to shoot") end return false end return true end,
	range = function (self, t) return self.range or 0 end,
	target = function(self, t) return  {type="bolt", range=self.weapon.range, talent=t} end,
	action = function(self, t) 		
		local x, y = self:getTarget(tg)
		local _ _, _, _, x, y = self:canProject(tg, x, y)
		if not x or not y then return nil end

 		local weapon = self.weapon
 		local damage = rng.dice(weapon.combat.dam[1],weapon.combat.dam[2])

		self:projectile(tg, x, y, DamageType.PHYSICAL, damage)
		return true
	end,
	info = function(self, t)
		--local dam = damDesc(self, DamageType.ICE, t.getDamage(self, t))
		return ([[You shoot at the target.]])
	end,
}
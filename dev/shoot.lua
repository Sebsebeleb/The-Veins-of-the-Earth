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

	action = function(self, t)
		local weapon = self:getInven("MAIN_HAND")[1]
		local wep_range = weapon.combat.range
		local tg = {type="bolt", range=wep_range, talent=t}
		local x, y = self:getTarget(tg)
		local _ _, _, _, x, y = self:canProject(tg, x, y)
		if not self:getInven("MAIN_HAND")  then return end
		if not x or not y then return nil end
		if not wep_range then 
			game.log(("You can't shoot a melee weapon!"))
			return nil end

		local damage = weapon.combat.dam

		self:projectile(tg, x, y, DamageType.PHYSICAL, damage)
		return true
	end,
	info = function(self, t)
		--local dam = damDesc(self, DamageType.ICE, t.getDamage(self, t))
		return ([[You shoot at the target.]])
	end,
}
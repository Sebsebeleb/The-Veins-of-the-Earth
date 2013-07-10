-- Default archery attack
newTalent{
	name = "Shoot",
	type = {"special/special", 1},
	no_energy = "fake",
	hide = true,
	innate = true,
	points = 1,
	range = archery_range,
	message = "@Source@ shoots!",
	requires_target = true,
	tactical = { ATTACK = { weapon = 1 } },
	on_pre_use = function(self, t, silent) if not self:hasArcheryWeapon() then if not silent then game.logPlayer(self, "You require a bow or sling for this talent.") end return false end return true end,
	no_unlearn_last = true,
	action = function(self, t)
		local targets = self:archeryAcquireTargets(nil, {one_shot=true})
		if not targets then return end
		self:archeryShoot(targets, t, nil)
		return true
	end,
	info = function(self, t)
		return ([[Shoot your bow or sling!]])
	end,
}
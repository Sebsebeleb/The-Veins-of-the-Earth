--Goes in game.lua, on changelevel
-- Level feeling
	local feeling
	if self.level.special_feeling then
		feeling = self.level.special_feeling
	else
		local lev = self.zone.base_level + self.level.level - 1
		if self.zone.level_adjust_level then lev = self.zone:level_adjust_level(self.level) end
		local diff = lev - self.player.level
		if diff >= 5 then feeling = "You feel a thrill of terror and your heart begins to pound in your chest. You feel terribly threatened upon entering this area."
		elseif diff >= 2 then feeling = "You feel mildly anxious, and walk with caution."
		elseif diff >= -2 then feeling = nil
		elseif diff >= -5 then feeling = "You feel very confident walking into this place."
		else feeling = "You stride into this area without a second thought, while stifling a yawn. You feel your time might be better spent elsewhere."
		end
	end
	if feeling then self.log("#TEAL#%s", feeling) end
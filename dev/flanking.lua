

    function _M:isFlanking(target)
            local x = target.x*2 - self.x
            local y = target.y*2 - self.y
            local z = game.level.map (x, y, MAP.ACTOR)
            if (z and self:reactionToward(z) < 0) then --- should also check if z is 'threatening'
                    return true    
            else
                    return false
            end
    end

-- cleave second attack
    if self:isTalentActive(self.T_CLEAVE) then
        local t = self:getTalentFromId(self.T_CLEAVE)
        t.on_attackTarget(self, t, target)
    end

if crit then game.logSeen(self, "#{bold}#%s performs a critical strike!#{normal}#", self.name:capitalize()) end

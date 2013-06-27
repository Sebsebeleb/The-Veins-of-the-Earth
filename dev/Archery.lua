-- Underdark
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

require "engine.class"
local DamageType = require "engine.DamageType"
local Map = require "engine.Map"
local Chat = require "engine.Chat"
local Target = require "engine.Target"
local Talents = require "engine.interface.ActorTalents"

--- Interface to add ToME archery combat system
module(..., package.seeall, class.make)

--- Look for possible archery targets
-- Take care of removing enough ammo
function _M:archeryAcquireTargets(tg, params)
	local weapon, ammo, offweapon = self:hasArcheryWeapon()
	if not weapon then
		game.logPlayer(self, "You must wield a bow or a sling (%s)!", ammo)
		return nil
	end
	if not ammo or (ammo.combat.shots_left <= 0 and not ammo.infinite) then
		game.logPlayer(self, "You do not have enough ammo left!")
		return nil
	end
	params = params or {}

	print("[ARCHERY ACQUIRE TARGETS WITH]", weapon.name, ammo.name)
	local realweapon = weapon
	weapon = weapon.combat

	local tg = tg or {}
	tg.type = tg.type or weapon.tg_type or ammo.combat.tg_type or tg.type or "bolt"

	if not tg.range then tg.range=math.min(weapon.range or 6, offweapon and offweapon.range or 40) end
	tg.display = tg.display or {display='/'}
	local wtravel_speed = weapon.travel_speed
	if offweapon then wtravel_speed = math.ceil(((weapon.travel_speed or 0) + (offweapon.travel_speed or 0)) / 2) end
	tg.speed = (tg.speed or 10) + (ammo.combat.travel_speed or 0) + (wtravel_speed or 0) + (self.travel_speed or 0)
	print("[PROJECTILE SPEED] ::", tg.speed)

	self:triggerHook{"Combat:archeryTargetKind", tg=tg, params=params, mode="target"}

	local x, y = params.x, params.y
	if not x or not y then x, y = self:getTarget(tg) end
	if not x or not y then return nil end

	-- Find targets to know how many ammo we use
	local targets = {}

	local runfire = function(weapon, targets)
		if params.one_shot then
			local a = ammo
			if not ammo.infinite and ammo.combat.shots_left > 0 then
				ammo.combat.shots_left = ammo.combat.shots_left - 1
			end
			if a then
				local hd = {"Combat:archeryAcquire", tg=tg, params=params, weapon=weapon, ammo=a}
				if self:triggerHook(hd) then hitted = hd.hitted end
targets[#targets+1] = {x=x, y=y, ammo=a.combat}
			end
		else
			local limit_shots = params.limit_shots

			self:project(tg, x, y, function(tx, ty)
				local target = game.level.map(tx, ty, game.level.map.ACTOR)
				if not target then return end
				if tx == self.x and ty == self.y then return end

				if limit_shots then
					if limit_shots <= 0 then return end
					limit_shots = limit_shots - 1
				end

				for i = 1, params.multishots or 1 do
					local a = ammo
					if not ammo.infinite then
						if ammo.combat.shots_left > 0 then ammo.combat.shots_left = ammo.combat.shots_left - 1
						else break
						end
					end
					if a then 
						local hd = {"Combat:archeryAcquire", tg=tg, params=params, weapon=weapon, ammo=a}
						if self:triggerHook(hd) then hitted = hd.hitted end

						targets[#targets+1] = {x=tx, y=ty, ammo=a.combat}


--- Shoot at one target
function _M:archeryShoot(targets, talent, tg, params)
	local weapon, ammo, offweapon = self:hasArcheryWeapon()
	if not weapon then
		game.logPlayer(self, "You must wield a bow or a sling (%s)!", ammo)
		return nil
	end
	end
	print("[SHOOT WITH]", weapon.name, ammo.name)
	local realweapon = weapon
	weapon = weapon.combat

	local tg = tg or {}
	tg.type = tg.type or weapon.tg_type or ammo.combat.tg_type or tg.type or "bolt"
	tg.talent = tg.talent or talent

	params = params or {}
	self:triggerHook{"Combat:archeryTargetKind", tg=tg, params=params, mode="fire"}

	local dofire = function(weapon, targets)
		if not tg.range then tg.range=weapon.range or 6 end
		tg.display = tg.display or self:archeryDefaultProjectileVisual(realweapon, ammo)
		tg.speed = (tg.speed or 10) + (ammo.combat.travel_speed or 0) + (weapon.travel_speed or 0) + (self.travel_speed or 0)
		tg.archery = params or {}
		tg.archery.weapon = weapon
		for i = 1, #targets do
			local tg = table.clone(tg)
			tg.archery.ammo = targets[i].ammo
			self:projectile(tg, targets[i].x, targets[i].y, archery_projectile)
		end
	end
end

--- Check if the actor has a bow or sling and corresponding ammo
function _M:hasArcheryWeapon(type)
	if not self:getInven("MAINHAND") then return nil, "no shooter" end
	if not self:getInven("QUIVER") then return nil, "no ammo" end
	local weapon = self:getInven("MAINHAND")[1]
	local offweapon = self:getInven("OFFHAND") and self:getInven("OFFHAND")[1]
	local ammo = self:getInven("QUIVER")[1]
	if offweapon and not offweapon.archery then offweapon = nil end
	if not weapon or not weapon.archery then
		return nil, "no shooter"
	end
	if not ammo then
		return nil, "no ammo"
	end
	return weapon, ammo, offweapon
end


function _M:archeryDefaultProjectileVisual(weapon, ammo)
	if (ammo and ammo.proj_image) or (weapon and weapon.proj_image) then
		return {display=' ', particle="arrow", particle_args={tile="shockbolt/"..(ammo.proj_image or weapon.proj_image):gsub("%.png$", "")}}
	else
		return {display='/'}
	end
end

--- Check if the actor has a bow or sling and corresponding ammo
function _M:hasAmmo(type)
	if not self:getInven("QUIVER") then return nil, "no ammo" end
	local ammo = self:getInven("QUIVER")[1]

	if not ammo then return nil, "no ammo" end
	if not ammo.archery_ammo then return nil, "bad ammo" end
	if not ammo.combat then return nil, "bad ammo" end
	if not ammo.combat.capacity then return nil, "bad ammo" end
	if type and ammo.archery_ammo ~= type then return nil, "bad type" end
	return ammo
end
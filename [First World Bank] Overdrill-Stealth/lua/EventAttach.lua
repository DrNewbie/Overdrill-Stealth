core:module("CoreElementCounter")
core:import("CoreMissionScriptElement")
core:import("CoreClass")
ElementCounter = ElementCounter or class(CoreMissionScriptElement.MissionScriptElement)

local ThisModPath = ModPath

local function __Name(__text)
	return "ODS_"..Idstring(tostring(__text)..ThisModPath):key()
end

if not Global.game_settings or not Global.game_settings.single_player or not Global.game_settings.level_id or not Global.game_settings.level_id == "red2" then
	return
end

if _G[__Name(0)] then return end
_G[__Name(0)] = true

local PainfullOverdrill = {}

Hooks:PreHook(ElementCounter, "on_executed", __Name("pre"), function(self, ...)
	local __id = tostring(self._id)
	if __id == "132053" or __id == "132056" or __id == "132058" or __id == "132059" or __id == "132061" then
		if PainfullOverdrill['Ready2CloseVent'] and not PainfullOverdrill[__id] then
			PainfullOverdrill[__id] = 1
			PainfullOverdrill['Ready2CloseVent'] = 2
			self._values.counter_target = 1
		end
	end
	if PainfullOverdrill['Ready2CloseVent'] == 3 and PainfullOverdrill[__id] == 1 then
		PainfullOverdrill[__id] = 2
	end
	if __id == "106692" or __id == "106946" or __id == "106947" or __id == "101024" then
		self._values.counter_target = 1
		PainfullOverdrill['Ready2CloseVent'] = 1
	end
	if not PainfullOverdrill['MoreLoot'] and managers and managers.loot and managers.hud and managers.loot:get_mandatory_bags_data().amount < 84 then
		PainfullOverdrill['MoreLoot'] = true
		managers.loot:get_mandatory_bags_data().amount = 84
	end
end)

Hooks:PostHook(ElementCounter, "on_executed", __Name("post"), function(self, ...)
	local __id = tostring(self._id)
	if PainfullOverdrill[__id] and PainfullOverdrill['Ready2CloseVent'] == 2 and self._values.counter_target <= 0 then
		PainfullOverdrill['Ready2CloseVent'] = 3
		local _door_unit_name = Idstring("units/payday2/equipment/gen_interactable_door_reinforced/gen_interactable_door_reinforced")
		World:spawn_unit(_door_unit_name, Vector3(2880, 550, 106), Rotation(180, 0, 0))
		World:spawn_unit(_door_unit_name, Vector3(2910, 550, 106), Rotation(180, 0, 0))
		World:spawn_unit(_door_unit_name, Vector3(2940, 550, 106), Rotation(180, 0, 0))
		World:spawn_unit(_door_unit_name, Vector3(2970, 550, 106), Rotation(180, 0, 0))
		local _run = {
			'103974',
			'104136',
			'104194',
			'104181',
			'104193',
			'104303'
		}
		local _runE = {
		}
		for _, script in pairs(managers.mission:scripts()) do
			for idx, element in pairs(script:elements()) do
				idx = tostring(idx)
				if table.contains(_run, idx) then
					if element then
						table.insert(_runE, element)
					end
				end
			end
		end
		for _, element in pairs(_runE) do
			element:on_executed()
		end
	end
end)
local DB = AkiAB.DB
local frame = AkiAB.frame
local abilityBar = AkiAB.abilityBar
local ignoredAbilities = AkiAB.ignoredAbilities

-- 事件处理统一模版
frame:SetScript('OnEvent', function(self, event, ...)
	local a = self[event]
	if a then
		a(self, ...)
	end
end)

-- 插件加载
frame:RegisterEvent('ADDON_LOADED')
function frame:ADDON_LOADED(name)
	if name ~= 'AkiTools_AbilityBar' then return end
	self:UnregisterEvent('ADDON_LOADED')
	if not AkiABDB then AkiABDB = {} end
	AkiAB:UpdateDB(DB, AkiABDB)
end

-- 玩家登出
frame:RegisterEvent('PLAYER_LOGOUT')
function frame:PLAYER_LOGOUT()
	AkiAB:UpdateDB(AkiABDB, DB)
end

-- 战斗日志
frame:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
function frame:COMBAT_LOG_EVENT_UNFILTERED( ...) 
	
	-- 读取事件返回值
	local timestamp, eventType, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = CombatLogGetCurrentEventInfo()
	local prefix, suffix = eventType:match('^(%u*)_(%S*)$')
	
	-- 怪物技能监控
	if prefix == 'SPELL' then
		local spellId, spellName, spellSchool = select(12, CombatLogGetCurrentEventInfo())
		if not ignoredAbilities[spellId] and AkiAB:IsNPC(sourceGUID) and type(spellId) == 'number' then
			local where = AkiAB:WhereAmI()
			DB.zone[where] = DB.zone[where] or {}
			DB.zone[where][sourceName] = DB.zone[where][sourceName] or {}
			DB.zone[where][sourceName][spellId] = true
		end
	end
end

-- 玩家目标改变
frame:RegisterEvent('PLAYER_TARGET_CHANGED')
function frame:PLAYER_TARGET_CHANGED(...)
	local name = UnitName("target")
	local where = AkiAB:WhereAmI()
	if not name then
		abilityBar:Clear()
		return
	end
	abilityBar:Initialize(where, name)
end
local DB = AkiAB.DB

function AkiAB:UpdateDB(dst, src)
	for k, v in pairs(src) do
		if type(v) == 'table' then
			if type(dst[k]) == 'table' then
				self:UpdateDB(dst[k], v)
			else
				dst[k] = self:UpdateDB({}, v)
			end
		elseif type(dst[k]) ~= 'table' then
			dst[k] = v
		end
	end
	return dst
end

-- 获取地点
function AkiAB:WhereAmI()
	local where = GetRealZoneText()
	local difficultyID = select(3, GetInstanceInfo())
	if difficultyID==1 then where = where..'(N)'
	elseif difficultyID==2 then where = where..'(H)'
	elseif difficultyID==3 then where = where..'(10)'
	elseif difficultyID==4 then where = where..'(25)'
	elseif difficultyID==5 then where = where..'(10H)'
	elseif difficultyID==6 then where = where..'(25H)'
	elseif difficultyID==7 then where = where..'(LFRLegacy)'
	elseif difficultyID==8 then where = where..'(MK)'
	elseif difficultyID==9 then where = where..'(40)'
	elseif difficultyID==11 then where = where..'(HSS)'
	elseif difficultyID==12 then where = where..'(NSS)'
	elseif difficultyID==14 then where = where..'(R)'
	elseif difficultyID==15 then where = where..'(HR)'
	elseif difficultyID==16 then where = where..'(MR)'
	elseif difficultyID==17 then where = where..'(LFR)'
	elseif difficultyID==18 then where = where..'(ER)'
	elseif difficultyID==19 then where = where..'(EP)'
	elseif difficultyID==20 then where = where..'(ESS)'
	elseif difficultyID==23 then where = where..'(M)'
	elseif difficultyID==24 then where = where..'(T)'
	elseif difficultyID==30 then where = where..'(ES)'
	elseif difficultyID==33 then where = where..'(TR)'
	elseif difficultyID==38 then where = where..'(NS)'
	elseif difficultyID==33 then where = where..'(HS)'
	elseif difficultyID==33 then where = where..'(MS)'
	end
	return where or 'none'
end

-- 根据GUID判断是否为NPC
function AkiAB:IsNPC(GUID)
	if not GUID then return false end
	local unitType = GUID:match('^(%w*)%-')
	if unitType == 'Creature' then
		return true
	elseif unitType == 'Player' then
		return false
	else
		return false
	end
end

-- 获取怪物技能
function AkiAB:GetMobSpells(where, name)
	if not DB.zone[where] then return end
	if not DB.zone[where][name] then return end
	return DB.zone[where][name]
end
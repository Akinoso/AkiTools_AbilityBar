local abilityBar = AkiAB.abilityBar
local ignoredAbilities = AkiAB.ignoredAbilities

--创建唯一命名函数
local UniqueName
do
	local controlID = 1

	function UniqueName(name)
		controlID = controlID + 1
		return string.format('AkiAbilityBar_%s_%02d', name, controlID)
	end
end

-- 创建技能图标
function abilityBar:CreateSpellFrame(spellId, size)
	local button = CreateFrame('Button', UniqueName('Button'), self)
	
	-- 图标
	button.spellImage = button:CreateTexture(nil, 'ARTWORK')
	button.spellImage:SetAllPoints(button)
	
	-- 鼠标事件
	button:EnableMouse(true)
	button:SetScript('OnMouseDown', function(this)
		if IsShiftKeyDown() and ChatFrame1EditBox:IsVisible() then
			ChatFrame1EditBox:Insert(this.link)
		end
	end)
	button:SetScript('OnEnter', function(this)
		GameTooltip_SetDefaultAnchor(GameTooltip, this)
		GameTooltip:SetHyperlink(this.link)
		GameTooltip:Show()
	end)
	button:SetScript('OnLeave', function(this)
		GameTooltip:FadeOut()
	end)

	-- 设置大小
	button:SetWidth(size)
	button:SetHeight(size)
	
	-- 设置图标
	local _, _, image = GetSpellInfo(spellId)
	button.spellImage:SetTexture(image)
	
	-- 设置链接
	button.spellId = spellId
	button.link = GetSpellLink(spellId)
	
	-- 返回按钮对象
	return button
end

-- 读取技能
function abilityBar:LoadSpells(where, name)
	local spells = AkiAB:GetMobSpells(where, name)
	if not spells then return end
	
	for k, v in pairs(spells) do
		if not ignoredAbilities[k] then
			self.spellCount = self.spellCount + 1
			self.spellFrames[self.spellCount] = self:CreateSpellFrame(k, self.size)
		end
	end
end

-- 显示技能
function abilityBar:LayoutSpells()
	local curX = 0
	local curY = 0
	local curCol = 1
	local curRow = 1

	for i = 1, self.spellCount do
		local v = self.spellFrames[i]
		curX = (curCol - 1) * self.size
		curY = (curRow - 1) * self.size
		v:SetPoint("TOPLEFT", self, "TOPLEFT", curX, -curY)
		v.spellImage:SetAllPoints(v)
		v:SetSize(self.size, self.size)
		v:Show()
		curCol = curCol + 1
		if curCol > 10 then
			curCol = 1
			curRow = curRow + 1
		end
	end
end

-- 清除显示
function abilityBar:Clear()
	if not self.spellCount then return end
	for i = 1, self.spellCount do
		self.spellFrames[i]:Hide()
	end
	self:Hide()
end

-- 怪物技能条初始化
function abilityBar:Initialize(where, name)
	self:Clear()
	self.size = 24
	self.spellCount = 0
	self.spellFrames = {}
	self:SetWidth(10 * self.size)
	self:SetHeight(2 * self.size)
	self:LoadSpells(where, name)
	self:LayoutSpells()
	self:SetPoint("CENTER", UIParent, "CENTER", 500, -200)
	self:Show()
end


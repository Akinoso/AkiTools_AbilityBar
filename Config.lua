local DB = AkiAB.DB
local panel = AkiAB.panel
local scrollFrame = AkiAB.scrollFrame
--设置面板初始化
panel:SetSize(500, 1000)
scrollFrame.ScrollBar:ClearAllPoints()
scrollFrame.ScrollBar:SetPoint("TOPLEFT", scrollFrame, "TOPRIGHT", -20, -20)
scrollFrame.ScrollBar:SetPoint("BOTTOMLEFT", scrollFrame, "BOTTOMRIGHT", -20, 20)
scrollFrame:SetScrollChild(panel)
scrollFrame.name = 'AkiTools_AB'
InterfaceOptions_AddCategory(scrollFrame)
--标题
local title = panel:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLargeLeft')
title:SetPoint('TOPLEFT', 16, -16)
title:SetText('AkiTools_AbilityBar v'..AkiAB.version)
--所有组件表
panel.controls = {}
--创建唯一命名函数
local UniqueName
do
	local controlID = 1

	function UniqueName(name)
		controlID = controlID + 1
		return string.format('AkiTools_%s_%02d', name, controlID)
	end
end
--设置面板确定函数
function scrollFrame:ConfigOkay()
	for _, control in pairs(panel.controls) do
		control.SaveValue(control.currentValue)
	end
end
--设置面板回到默认设置函数
function scrollFrame:ConfigDefault()
	for _, control in pairs(panel.controls) do
		control.currentValue = control.defaultValue
		control.SaveValue(control.currentValue)
	end
end
--设置面板刷新函数
function scrollFrame:ConfigRefresh()
	for _, control in pairs(panel.controls) do
		control.currentValue = control.LoadValue()
		control:UpdateValue()
	end
end
--创建标题函数
function panel:CreateHeading(text)
	local title = self:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLeft')
	title:SetText(text)
	return title
end
--创建文本函数
function panel:CreateText(text)
	local blob = self:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightSmallLeft')
	blob:SetText(text)
	return blob
end
--创建选择框函数
function panel:CreateCheckBox(text, LoadValue, SaveValue, defaultValue)
	local checkBox = CreateFrame('CheckButton', UniqueName('CheckButton'), self, 'InterfaceOptionsCheckButtonTemplate')

	checkBox.LoadValue = LoadValue
	checkBox.SaveValue = SaveValue
	checkBox.defaultValue = defaultValue
	checkBox.UpdateValue = function(self) self:SetChecked(self.currentValue) end
	getglobal(checkBox:GetName() .. 'Text'):SetText(text)
	checkBox:SetScript('OnClick', function(self) self.currentValue = self:GetChecked() end)

	self.controls[checkBox:GetName()] = checkBox
	return checkBox
end
--下拉菜单点击函数
local function DropDownOnClick(_, dropDown, selectedValue)
	dropDown.currentValue = selectedValue
	UIDropDownMenu_SetText(dropDown, dropDown.valueTexts[selectedValue])
	if type(selectedValue) == 'number' then
		PlaySoundFile(selectedValue, 'MASTER')
	end
end
--下拉菜单初始化函数
local function DropDownInitialize(frame)
	local info = UIDropDownMenu_CreateInfo()

	for i=1,#frame.valueList,2 do
		local k, v = frame.valueList[i], frame.valueList[i + 1]
		info.text = v
		info.value = k
		info.checked = frame.currentValue == k
		info.func = DropDownOnClick
		info.arg1, info.arg2 = frame, k
		UIDropDownMenu_AddButton(info)
	end
end
--创建下拉菜单函数
function panel:CreateDropDown(text, valueList, LoadValue, SaveValue, defaultValue)
	local title = self:CreateFontString(nil, 'ARTWORK', 'GameFontNormalSmallLeft')
	title:SetText(text)
	local dropDown = CreateFrame('Frame', UniqueName('DropDown'), self, 'UIDropDownMenuTemplate')
	dropDown:SetPoint('CENTER', title, 'CENTER', 120, 0)

	dropDown.LoadValue = LoadValue
	dropDown.SaveValue = SaveValue
	dropDown.defaultValue = defaultValue
	dropDown.UpdateValue = function(self)
		UIDropDownMenu_SetText(self, self.valueTexts[self.currentValue])
	end

	dropDown.valueList = valueList
	dropDown.valueTexts = {}
	for i=1,#valueList,2 do
		local k, v = valueList[i], valueList[i + 1]
		dropDown.valueTexts[k] = v
	end

	dropDown:SetScript('OnShow', function(self)
		UIDropDownMenu_Initialize(self, DropDownInitialize)
	end)

	UIDropDownMenu_JustifyText(dropDown, 'LEFT')
	UIDropDownMenu_SetWidth(dropDown, 120)
	UIDropDownMenu_SetButtonWidth(dropDown, 144)

	self.controls[dropDown:GetName()] = dropDown
	return title
end

--- 设置面板初始化 ---
function panel:Initialize()
-- 是否开启插件
	local enabled = self:CreateCheckBox(
		'启用怪物技能信息条',
		function() return DB.enable end,
		function(v) DB.enable = v end,
		true)
	enabled:SetPoint('TOPLEFT', title, 'BOTTOMLEFT', 0, -20)
end

--面板初始化
panel:Initialize()
panel:Show()
scrollFrame.okay = scrollFrame.ConfigOkay
scrollFrame.default = scrollFrame.ConfigDefault
scrollFrame.refresh = scrollFrame.ConfigRefresh
scrollFrame:ConfigRefresh()
scrollFrame:Show()






AkiAB = {}

AkiAB.version = GetAddOnMetadata('AkiTools_AbilityBar', 'Version')

AkiAB.frame = CreateFrame('Frame', 'AkiABFrame')
AkiAB.frame:Hide()
AkiAB.abilityBar = CreateFrame('Frame', 'AkiAbilityBarFrame')
AkiAB.abilityBar:Hide()
AkiAB.panel = CreateFrame('Frame', 'AkiABPanel')
AkiAB.panel:Hide()
AkiAB.scrollFrame = CreateFrame("ScrollFrame", nil, UIParent, "UIPanelScrollFrameTemplate")
AkiAB.scrollFrame:Hide()
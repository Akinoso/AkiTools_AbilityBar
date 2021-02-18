local DB = AkiAB.DB

SLASH_AKIAB1 = '/akiab'
SLASH_AKIAB2 = '/AKIAB'
SlashCmdList['AKIAB'] = function(msg)
    local command, rest = msg:lower():match('^(%S*)%s*(.-)$')

	if command=="test" then
		print('test')
	else
		InterfaceOptionsFrame_OpenToCategory('AkiTools_AB')
		InterfaceOptionsFrame_OpenToCategory('AkiTools_AB')

	end
end
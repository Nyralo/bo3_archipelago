require("ui.t6.lobby.lobbymenubuttons_og")
require("ui.archipelago.frontend.ArchipelagoSettings")
-- --Temp
-- require("ui.util.T7Overcharged")
-- --

-- InitializeT7Overcharged({
-- 	modname  = "bo3_archipelago",
-- 	filespath = [[.\mods\bo3_archipelago\]],
-- 	workshopid = nil,
-- 	discordAppId = nil,
-- 	showExternalConsole = true
-- })
-- --

CoD.LobbyButtons.ZM_AP_BUTTON =
{
	stringRef = "ARCHIPELAGO",
	action =
	function(arg0, arg1, arg2, arg3, arg4)
		CoD.LobbyBase.SetLeaderActivity(arg2, CoD.LobbyBase.LeaderActivity.EDITING_GAME_RULES)
		LUI.OverrideFunction_CallOriginalFirst(OpenOverlay(arg0, "ArchipelagoSettings", arg2), "close",
		function()
			CoD.LobbyBase.ResetLeaderActivity(arg2)
		end)
	end,
	customId = "btnArchipelago",
	starterPack = CoD.LobbyButtons.STARTERPACK_UPGRADE
}
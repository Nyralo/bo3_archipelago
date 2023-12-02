require( "ui.uieditor.widgets.StartMenu.StartMenu_Background" )
require( "ui.uieditor.widgets.Lobby.Common.FE_ButtonPanelShaderContainer" )
require( "ui.uieditor.widgets.BackgroundFrames.GenericMenuFrame" )
require( "ui.uieditor.widgets.Groups.GroupsSubTitle" )
require( "ui.uieditor.widgets.Groups.GroupsInputButtonScroll" )

require("ui.util.T7OverchargedUtil")

EnableGlobals();

local ConnectArchi = function()
	local server = Engine.DvarString(nil,"ARCHIPELAGO_SERVER")
	local port = Engine.DvarString(nil,"ARCHIPELAGO_PORT")
	local slot = Engine.DvarString(nil,"ARCHIPELAGO_SLOT")
	if Archipelago then return false end
	
	local modname = bo3_archipelago
	local filespath = [[.\mods\bo3_archipelago\]]
	local workshopid = nil
	local dllPath = filespath .. [[zone\]] or [[..\..\workshop\content\311210\]] .. workshopid .. "\\"
	local dll = "Archi-T7Overcharged.dll"

	SafeCall(function()
		EnableGlobals()
		local dllInit = require("package").loadlib(dllPath..dll, "init")
	
		--Check if the dll was properly loaded
		if not dllInit then
			Engine.ComError( Enum.errorCode.ERROR_UI, "Unable to initialize "..dll )
			return
		end
		dllInit()

		end)
	    local server = Engine.DvarString(nil,"ARCHIPELAGO_SERVER")
    	local port = Engine.DvarString(nil,"ARCHIPELAGO_PORT")
    	local slot = Engine.DvarString(nil,"ARCHIPELAGO_SLOT")

		Archipelago.CheckConnection(server..":"..port,slot,".\\mods\\bo3_archipelago\\zone\\")
		--
	
end

local PostLoadFunc = function ( menu, controller )
	local apModel = Engine.GetModel( Engine.GetGlobalModel(), "archipelago" )
	menu.serverInput.subscription = menu.serverInput:subscribeToModel( Engine.GetModel( apModel, "serverName" ), function ( model )
		local modelValue = Engine.GetModelValue( model )
		if modelValue then
			menu.serverInput.verticalScrollingTextBox.textBox:setText( modelValue )
			Engine.SetDvar( "ARCHIPELAGO_SERVER", modelValue)
		end
	end )
	menu.portInput.subscription = menu.portInput:subscribeToModel( Engine.GetModel( apModel, "port" ), function ( model )
		local modelValue = Engine.GetModelValue( model )
		if modelValue then
			menu.portInput.verticalScrollingTextBox.textBox:setText( modelValue )
			Engine.SetDvar( "ARCHIPELAGO_PORT", modelValue )
		end
	end )
	menu.slotInput.subscription = menu.slotInput:subscribeToModel( Engine.GetModel( apModel, "slotName" ), function ( model )
		local modelValue = Engine.GetModelValue( model )
		if modelValue then
			menu.slotInput.verticalScrollingTextBox.textBox:setText( modelValue )
			Engine.SetDvar( "ARCHIPELAGO_SLOT", modelValue )
		end
	end )
end

local PreLoadFunc = function ( self, controller )
	local apModel = Engine.CreateModel( Engine.GetGlobalModel(), "archipelago" )
	Engine.SetModelValue( Engine.CreateModel( apModel, "serverName" ), Engine.DvarString(nil,"ARCHIPELAGO_SERVER"))
	Engine.SetModelValue( Engine.CreateModel( apModel, "port" ), Engine.DvarString(nil,"ARCHIPELAGO_PORT") )
	Engine.SetModelValue( Engine.CreateModel( apModel, "slotName" ), Engine.DvarString(nil,"ARCHIPELAGO_SLOT"))
end

APActiveField = 1

LUI.createMenu.ArchipelagoSettings = function ( controller )
    local self = CoD.Menu.NewForUIEditor( "ArchipelagoSettings" )
	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end
    self.soundSet = "default"
	self:setOwner( controller )
	self:setLeftRight( true, true, 0, 0 )
	self:setTopBottom( true, true, 0, 0 )
	self:playSound( "menu_open", controller )
	self.buttonModel = Engine.CreateModel( Engine.GetModelForController( controller ), "ArchipelagoSettings.buttonPrompts" )
	local Menu = self
	self.anyChildUsesUpdateState = true

    local StartMenuBackground0 = CoD.StartMenu_Background.new( Menu, controller )
	StartMenuBackground0:setLeftRight( true, true, 0, 0 )
	StartMenuBackground0:setTopBottom( true, true, 0, 0 )
	self:addElement( StartMenuBackground0 )
	self.StartMenuBackground0 = StartMenuBackground0

    local FEButtonPanelShaderContainer0 = CoD.FE_ButtonPanelShaderContainer.new( Menu, controller )
	FEButtonPanelShaderContainer0:setLeftRight( true, true, 0, 0 )
	FEButtonPanelShaderContainer0:setTopBottom( true, true, 0, 0 )
	FEButtonPanelShaderContainer0:setRGB( 0.31, 0.31, 0.31 )
	self:addElement( FEButtonPanelShaderContainer0 )
	self.FEButtonPanelShaderContainer0 = FEButtonPanelShaderContainer0
    
    local MenuFrame = CoD.GenericMenuFrame.new( Menu, controller )
	MenuFrame:setLeftRight( true, true, 0, 0 )
	MenuFrame:setTopBottom( true, true, 0, 0 )
	MenuFrame.titleLabel:setText( "ARCHIPELAGO SETTINGS" )
	MenuFrame.cac3dTitleIntermediary0.FE3dTitleContainer0.MenuTitle.TextBox1.Label0:setText( "ARCHIPELAGO SETTINGS" )
	self:addElement( MenuFrame )
	self.MenuFrame = MenuFrame

    local serverTitle = CoD.GroupsSubTitle.new( Menu, controller )
	serverTitle:setLeftRight( true, false, 93, 261 )
	serverTitle:setTopBottom( true, false, 112, 144 )
	serverTitle.weaponNameLabel:setText( "Server Name" )
	self:addElement( serverTitle )
	self.serverTitle = serverTitle

    local serverInput = CoD.GroupsInputButtonScroll.new( Menu, controller )
	serverInput:setLeftRight( true, false, 93, 478 )
	serverInput:setTopBottom( true, false, 150, 212.5 )
	serverInput.verticalScrollingTextBox.textBox:setText( Engine.Localize( "" ) )
	serverInput.verticalScrollingTextBox.textBox:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
    serverInput:registerEventHandler( "gain_focus", function ( element, event )
		local f7_local0 = nil
		--
		EnableGlobals()
		APActiveField = 1
		--
		if element.gainFocus then
			f7_local0 = element:gainFocus( event )
		elseif element.super.gainFocus then
			f7_local0 = element.super:gainFocus( event )
		end
		CoD.Menu.UpdateButtonShownState( element, Menu, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS )
		return f7_local0
	end )
    serverInput:registerEventHandler( "lose_focus", function ( element, event )
		local f8_local0 = nil
		if element.loseFocus then
			f8_local0 = element:loseFocus( event )
		elseif element.super.loseFocus then
			f8_local0 = element.super:loseFocus( event )
		end
		return f8_local0
	end )
	Menu:AddButtonCallbackFunction( serverInput, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "ENTER", function ( f9_arg0, f9_arg1, f9_arg2, f9_arg3 )
		Engine.Exec(0, "ui_keyboard_new 17 \"Enter Server Name\" \"localhost\" 128"); 
		return true
	end, function ( f10_arg0, f10_arg1, f10_arg2 )
		CoD.Menu.SetButtonLabel( f10_arg1, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "MENU_SELECT" )
		return true
	end, false )
	self:addElement( serverInput )
	self.serverInput = serverInput

    local portTitle = CoD.GroupsSubTitle.new( Menu, controller )
	portTitle:setLeftRight( true, false, 93, 261 )
	portTitle:setTopBottom( true, false, 233.43, 265.43 )
	portTitle.weaponNameLabel:setText( "Port" )
	self:addElement( portTitle )
	self.portTitle = portTitle

    local portInput = CoD.GroupsInputButtonScroll.new( Menu, controller )
	portInput:setLeftRight( true, false, 93, 478 )
	portInput:setTopBottom( true, false, 274, 384 )
	portInput.verticalScrollingTextBox.textBox:setText( Engine.Localize( "" ) )
	portInput.verticalScrollingTextBox.textBox:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	portInput:registerEventHandler( "gain_focus", function ( element, event )
		local f11_local0 = nil
		--
		EnableGlobals()
		APActiveField = 2
		--
		if element.gainFocus then
			f11_local0 = element:gainFocus( event )
		elseif element.super.gainFocus then
			f11_local0 = element.super:gainFocus( event )
		end
		CoD.Menu.UpdateButtonShownState( element, Menu, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS )
		return f11_local0
	end )
	portInput:registerEventHandler( "lose_focus", function ( element, event )
		local f12_local0 = nil
		if element.loseFocus then
			f12_local0 = element:loseFocus( event )
		elseif element.super.loseFocus then
			f12_local0 = element.super:loseFocus( event )
		end
		return f12_local0
	end )
	Menu:AddButtonCallbackFunction( portInput, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "ENTER", function ( f13_arg0, f13_arg1, f13_arg2, f13_arg3 )
		Engine.Exec(0, "ui_keyboard_new 17 \"Enter Server Port\" \"38281\" 128"); 
		return true
	end, function ( f14_arg0, f14_arg1, f14_arg2 )
		CoD.Menu.SetButtonLabel( f14_arg1, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "MENU_SELECT" )
		return true
	end, false )
	self:addElement( portInput )
	self.portInput = portInput

    local slotTitle = CoD.GroupsSubTitle.new( Menu, controller )
	slotTitle:setLeftRight( true, false, 93, 261 )
	slotTitle:setTopBottom( true, false, 403, 435 )
	slotTitle.weaponNameLabel:setText("Slot Name")
	self:addElement( slotTitle )
	self.slotTitle = slotTitle
	
	local slotInput = CoD.GroupsInputButtonScroll.new( Menu, controller )
	slotInput:setLeftRight( true, false, 93, 478 )
	slotInput:setTopBottom( true, false, 443, 474.5 )
	slotInput.verticalScrollingTextBox.textBox:setText( Engine.Localize( "" ) )
	slotInput.verticalScrollingTextBox.textBox:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	slotInput:registerEventHandler( "gain_focus", function ( element, event )
		local f15_local0 = nil
		--
		EnableGlobals()
		APActiveField = 3
		--
		if element.gainFocus then
			f15_local0 = element:gainFocus( event )
		elseif element.super.gainFocus then
			f15_local0 = element.super:gainFocus( event )
		end
		CoD.Menu.UpdateButtonShownState( element, Menu, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS )
		return f15_local0
	end )
	slotInput:registerEventHandler( "lose_focus", function ( element, event )
		local f16_local0 = nil
		if element.loseFocus then
			f16_local0 = element:loseFocus( event )
		elseif element.super.loseFocus then
			f16_local0 = element.super:loseFocus( event )
		end
		return f16_local0
	end )
	Menu:AddButtonCallbackFunction( slotInput, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "ENTER", function ( f17_arg0, f17_arg1, f17_arg2, f17_arg3 )
		Engine.Exec(0, "ui_keyboard_new 17 \"Enter Slot Name\" \"Player\" 128"); 
		return true
	end, function ( f18_arg0, f18_arg1, f18_arg2 )
		CoD.Menu.SetButtonLabel( f18_arg1, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "MENU_SELECT" )
		return true
	end, false )
	self:addElement( slotInput )
	self.slotInput = slotInput


    serverInput.navigation = {
		down = portInput
	}
	portInput.navigation = {
		up = serverInput,
		down = slotInput
	}
	slotInput.navigation = {
		up = portInput
	}

    CoD.Menu.AddNavigationHandler( Menu, self, controller )
	self:registerEventHandler( "ui_keyboard_input", function ( element, event )
		EnableGlobals()
		if event.type ~= 17 then return end
			local apModel = Engine.GetModel( Engine.GetGlobalModel(), "archipelago" )
		if APActiveField == 1 then
			Engine.SetModelValue( Engine.GetModel( apModel, "serverName" ), event.input )
		elseif APActiveField == 2 then
			Engine.SetModelValue( Engine.GetModel( apModel, "port" ), event.input )
		elseif APActiveField == 3 then
			Engine.SetModelValue( Engine.GetModel( apModel, "slotName" ), event.input )
		end
	end )
    Menu:AddButtonCallbackFunction( self, controller, Enum.LUIButton.LUI_KEY_XBB_PSCIRCLE, nil, function ( f20_arg0, f20_arg1, f20_arg2, f20_arg3 )
		GoBack( self, f20_arg2 )
		return true
	end, function ( f21_arg0, f21_arg1, f21_arg2 )
		CoD.Menu.SetButtonLabel( f21_arg1, Enum.LUIButton.LUI_KEY_XBB_PSCIRCLE, "MP_BACK" )
		return true
	end, false )

    Menu:AddButtonCallbackFunction( self, controller, Enum.LUIButton.LUI_KEY_XBY_PSTRIANGLE, nil, function ( f20_arg0, f20_arg1, f20_arg2, f20_arg3 )
		ConnectArchi()
		return true
	end, function ( f21_arg0, f21_arg1, f21_arg2 )
		CoD.Menu.SetButtonLabel( f21_arg1, Enum.LUIButton.LUI_KEY_XBY_PSTRIANGLE, "Connect" )
		return true
	end, false )

    MenuFrame:setModel( self.buttonModel, controller )
	serverInput.id = "serverInput"
	portInput.id = "portInput"
	slotInput.id = "slotInput"
	self:processEvent( {
		name = "menu_loaded",
		controller = controller
	} )
	self:processEvent( {
		name = "update_state",
		menu = Menu
	} )
	if not self:restoreState() then
		self.serverInput:processEvent( {
			name = "gain_focus",
			controller = controller
		} )
	end
    LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.StartMenuBackground0:close()
		element.FEButtonPanelShaderContainer0:close()
		element.MenuFrame:close()
		element.serverTitle:close()
		element.serverInput:close()
		element.portTitle:close()
		element.portInput:close()
		element.slotTitle:close()
		element.slotInput:close()
		Engine.UnsubscribeAndFreeModel( Engine.GetModel( Engine.GetModelForController( controller ), "ArchipelagoSettings.buttonPrompts" ) )

	end )
	if PostLoadFunc then
		PostLoadFunc( self, controller )
	end
	
	return self
end
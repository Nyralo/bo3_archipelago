require( "ui.uieditor.widgets.BubbleGumBuffs.BubbleGumPack" )
require( "ui.uieditor.widgets.BubbleGumBuffs.BubbleGumBuffInGame" )
require( "ui.archipelago.ingame.widgets.ArchipelagoDisplay")
require( "ui.archipelago.ingame.widgets.ArchipelagoDisplayClient")
require( "ui.archipelago.ingame.widgets.ArchipelagoTracker")
require( "ui.archipelago.ingame.widgets.ArchipelagoMessageContainer")

CoD.BubbleGumPackInGame = InheritFrom( LUI.UIElement )
CoD.BubbleGumPackInGame.new = function ( menu, controller )

	local self = LUI.UIElement.new()
	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end
	self:setUseStencil( false )
	self:setClass( CoD.BubbleGumPackInGame )
	self.id = "BubbleGumPackInGame"
	self.soundSet = "default"
	self:setLeftRight( false, false, 0, 0 )
	self:setTopBottom( false, false, 0, 0 )
	self.anyChildUsesUpdateState = true

    --Archipelago Display
	local ArchiDisp 

    if CoD.isHost() then
		ArchiDisp = CoD.ArchipelagoDisplay.new(menu,controller)
	else
		ArchiDisp = CoD.ArchipelagoDisplayClient.new(menu,controller)
	end
    self:addElement(ArchiDisp)
    self.ArchiDisp = ArchiDisp
    --
	--Archipelago Tracker
	local ArchiTracker = CoD.ArchipelagoTracker.new(menu,controller)
	self:addElement(ArchiTracker)
    self.ArchiTracker = ArchiTracker
	--
	--MessageContainer
	local ArchiMessages = CoD.ArchipelagoMessageContainer.new(menu,controller)
	self:addElement(ArchiMessages)
	self.ArchiMessages = ArchiMessages
	--

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
        element.ArchiDisp:close()
		element.ArchiTracker:close()
		element.ArchiMessages:close()
	end )
	
	if PostLoadFunc then
		PostLoadFunc( self, controller, menu )
	end
	
	
	return self
end

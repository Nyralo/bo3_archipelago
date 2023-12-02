require("Archipelago.Utils")

CoD.ArchipelagoMessageContainer = InheritFrom( LUI.UIElement )
CoD.ArchipelagoMessageContainer.MessagesQueue = List.new()
CoD.ArchipelagoMessageContainer.new = function (menu, controller)

    local self = LUI.UIElement.new()


    self:setClass(CoD.ArchipelagoMessageContainer)
    self.id = "ArchipelagoMessageContainer"
    self.soundSet = "default"

    --AP Get Image
    
    local ApGetImage = LUI.UIImage.new()
    ApGetImage:setLeftRight(true, false,-600,-560)
    ApGetImage:setTopBottom(true, false,-90,-50)
    ApGetImage:setImage(RegisterImage("archipelago_logo_down"))
    ApGetImage:setAlpha(0)
    self:addElement(ApGetImage)
    self.ApGetImage = ApGetImage

    --AP Send Image
    
    local ApSendImage = LUI.UIImage.new()
    ApSendImage:setLeftRight(true, false,-600,-560)
    ApSendImage:setTopBottom(true, false,-40,0)
    ApSendImage:setImage(RegisterImage("archipelago_logo_up"))
    ApSendImage:setAlpha(0)
    self:addElement(ApSendImage)
    self.ApSendImage = ApSendImage


    local FlashNotif = function(Element,Event)
      Element:setAlpha(0)
      Element:beginAnimation("keyframe", 1000, false, false, CoD.TweenType.Linear)
      Element:setAlpha(1)
      Element:beginAnimation("keyframe", 1000, false, false, CoD.TweenType.Linear)
      Element:setAlpha(0)
      Element:registerEventHandler("transition_complete_keyframe", nil)
    end

    self:subscribeToGlobalModel(controller, "PerController", "scriptNotify", function( model )
        if IsParamModelEqualToString(model, "ap_ui_get") then
          FlashNotif(self.ApGetImage,{})
        elseif IsParamModelEqualToString(model, "ap_ui_send") then
          FlashNotif(self.ApSendImage,{})
        end
    end )
    

    --Close callback (Close all the children stuff)
    LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
        element.ApGetImage:close()
        element.ApSendImage:close()
	  end )

    return self
end


local APItemList = {
    [1] ={[1] = "ap_item_power_on",[2] = "archipelago_power_switch_perk"},
    [2] ={[1] = "ap_item_wallbuys" ,[2] ="archipelago_wallbuys_perk"},
    [3] ={[1] = "ap_item_quick_revive" ,[2] = "specialty_giant_quickrevive_zombies"},
    [4] ={[1] = "ap_item_juggernog" , [2] ="specialty_giant_juggernaut_zombies"},
    [5] ={[1] = "ap_item_double_tap" ,[2] = "specialty_giant_doubletap_zombies"},
    [6] ={[1] = "ap_item_speed_cola" ,[2] ="specialty_giant_fastreload_zombies"},
    [7] ={[1] = "ap_item_mule_kick" , [2] ="specialty_giant_three_guns_zombies"},
    --ap_item_stamin_up = "specialty_giant_marathon_zombies",
    --ap_item_dead_shot = "specialty_giant_ads_zombies",
    --ap_item_wunderfizz = ""
    --ap_item_phd_flopper = "specialty_giant_divetonuke_zombies",
	--ap_item_tombstone = "specialty_giant_tombstone_zombies",
	--ap_item_widows_wine = "specialty_giant_widows_wine_zombies"
}

CoD.ArchipelagoTracker = InheritFrom( LUI.UIElement )
CoD.ArchipelagoTracker.new = function (menu, controller)

    local self = LUI.UIElement.new()

    self:setClass(CoD.ArchipelagoTracker)
    self.id = "ArchipelagoTracker"
    self.soundSet = "default"


    --Background Image
    local bkgImg = LUI.UIImage.new()
    bkgImg:setLeftRight(true, false,-400,350)
    bkgImg:setTopBottom(true, false,-90,100)
    bkgImg:setRGB( 0, 0, 0 )
    bkgImg:setAlpha(0.5)
    self:addElement(bkgImg)
    self.bkgImg = bkgImg

    --Item List
    local itemHeight = 80
    local itemWidth = 80
    local startLeft = -360
    local startTop = -80
    local padding = 20
    local imageCount = 1
    self.itemImages = {}
    for _,v in ipairs(APItemList) do
        local imageFile = v[2]
        local clientFieldName = v[1]
        local itemImage = LUI.UIImage.new()
        local leftPos = startLeft + ((imageCount-1)*(itemWidth+padding))
        local rightPos = leftPos + itemWidth
        local topPos = startTop
        local bottomPos = topPos+itemHeight
        itemImage:setLeftRight(true, false,leftPos,rightPos)
        itemImage:setTopBottom(true, false,topPos,bottomPos)
        itemImage:setImage(RegisterImage(imageFile))
        itemImage:setAlpha(.5)

        itemImage:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "zmInventory."..clientFieldName ), function( modelRef  )
            local val = Engine.GetModelValue( modelRef )
            if val then
                if val == 1 then
                    itemImage:setAlpha(1)
                else
                    itemImage:setAlpha(0.5)
                end
            end
        end )
        self:addElement(itemImage)
        table.insert(self.itemImages,itemImage)
        imageCount = imageCount +1
        if imageCount >8 then
            imageCount = 1
            startTop = startTop + itemHeight + padding
        end
    end
    self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setAlpha( 0 )
			end
		},
		Visible = {
			DefaultClip = function ()
				self:setAlpha( 1 )
			end
		}
	}
    self:mergeStateConditions( {
		{
			stateName = "Visible",
			condition = function ( menu, element, event )
				return Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN )
			end
		}
	} )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN ), function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN
		} )
	end )
	
    --Close callback (Close all the children stuff)
    LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
        element.bkgImg:close()
        for i,v in ipairs(element.itemImages) do
            v:close()
        end
	end )
    return self
end
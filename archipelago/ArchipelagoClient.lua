EnableGlobals();

require("ui.util.T7OverchargedUtil")
require("Archipelago.Utils")

--
ItemQueue = List.new()
LogQueue = List.new()
Archi = {}
Archi.Debug = true
--
Archi.FromGSC = function (model)
  if IsParamModelEqualToString(model, "ap_notification") then
    --local notifyData = CoD.GetScriptNotifyData(model)
    --TODO add a type to this notification, for now its all loc checks
    local location = Engine.DvarString(nil,"ARCHIPELAGO_LOCATION_SEND")
    if location ~= "NONE" then
      Archipelago.CheckLocation(location)
      Engine.SetDvar( "ARCHIPELAGO_LOCATION_SEND", "NONE" )
    end
  end
end

Archi.ItemGetEvent = function (name)
  List.pushright(ItemQueue,name)
end

Archi.LogMessage = function (message)
  if message then
    List.pushright(LogQueue,message)
  end
end

Archi.LogDebugMessage = function (message)
  if Archi.Debug and message then
    List.pushright(LogQueue,"Debug: "..message)
  end
end


Archi.GiveItemsLoop = function()
  local UIRootFull = LUI.roots.UIRootFull;
	UIRootFull.HUDRefreshTimer = LUI.UITimer.newElementTimer(1000, false, function()
    local item = Engine.DvarString(nil,"ARCHIPELAGO_ITEM_GET")
    if (not List.isEmpty(ItemQueue)) and (item == "NONE") then --if we are free to give an item, and there is one to give
      local toSend = List.popleft(ItemQueue)
      Engine.SetDvar( "ARCHIPELAGO_ITEM_GET", toSend )
    end
	end);
	UIRootFull:addElement(UIRootFull.HUDRefreshTimer);
end


Archi.LogMessageLoop = function()
  local UIRootFull = LUI.roots.UIRootFull;
	UIRootFull.HUDRefreshTimer = LUI.UITimer.newElementTimer(1000, false, function()
    local item = Engine.DvarString(nil,"ARCHIPELAGO_LOG_MESSAGE")
    if (not List.isEmpty(LogQueue)) and (item == "NONE") then --if we are free to give an item, and there is one to give
      local toSend = List.popleft(LogQueue)
      Engine.SetDvar( "ARCHIPELAGO_LOG_MESSAGE", toSend )
    end
	end);
	UIRootFull:addElement(UIRootFull.HUDRefreshTimer);
end


Archi.KeepConnected = function ()
  
  if Archipelago then
    --TODO: set these with DVARS
    local server = "localhost"
    local port = "38281"
    local slot = "Nyralo"
    -- local server = Engine.DvarString(nil,"ARCHIPELAGO_SERVER")
    -- local port = Engine.DvarString(nil,"ARCHIPELAGO_PORT")
    -- local slot = Engine.DvarString(nil,"ARCHIPELAGO_SLOT")
    --TODO: error out if any of these are null

    --TODO: change the \zone (base path)
    Archipelago.Connect(server..":"..port,slot,"zone\\")
    --TODO: only do this on an actual connect
    Engine.SetDvar( "ARCHIPELAGO_CONNECTED", "TRUE" )
  end
  --TODO recheck login logic
end


function InitializeArchipelago(options)
    if Archipelago then 
      Console.Print("AP Alredy Initiated")
      return false 
    end

    --Load DLL?
    local dllPath = options.filespath .. [[zone\]] or [[..\..\workshop\content\311210\]] .. options.workshopid .. "\\"
    local dll = "Archi-T7Overcharged.dll"

    SafeCall(function()
        EnableGlobals()
        --Console.Print("Attempting to Load: "..dllPath..dll)
        local dllInit = require("package").loadlib(dllPath..dll, "init")
  
        --Check if the dll was properly loaded
        if not dllInit then
          --Console.Print("Failed to load "..dll)
          Engine.ComError( Enum.errorCode.ERROR_UI, "Unable to initialize "..dll )
          return
        end
        --Console.Print("Loaded "..dll)
        -- Execute the dll
        dllInit()
    
      end)

      --Make sure we are connected to Archipelago
      --Turning off for now
      Archi.KeepConnected()

      --Start Polling
      local UIRootFull = LUI.roots.UIRootFull;
			UIRootFull.HUDRefreshTimer = LUI.UITimer.newElementTimer(1000, false, function()
        Archipelago.Poll();
      end);
      UIRootFull:addElement(UIRootFull.HUDRefreshTimer);
      --

      --When we recieve an Item, give it to the GSC
      Archi.GiveItemsLoop()

      --Send Log messages to GSC
      Archi.LogMessageLoop()

end
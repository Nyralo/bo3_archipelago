#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\array_shared;
#using scripts\shared\util_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\hud_message_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\clientfield_shared;
#using scripts\zm\_zm_score;

#using scripts\zm\archi_items;

#insert scripts\zm\_zm_perks.gsh;
#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#insert scripts\zm\archi_core.gsh;


#namespace archi_core;

#precache( "eventstring", "ap_notification" );
#precache( "eventstring", "ap_ui_get" );
#precache( "eventstring", "ap_ui_send" );

REGISTER_SYSTEM_EX("archipelago_core", &__init__, &__main__, undefined)

function __init__()
{


    SetDvar( "MOD_VERSION", MOD_VERSION );
    //
    //Message Passing Dvars
    SetDvar("ARCHIPELAGO_ITEM_GET", "NONE");
    SetDvar("ARCHIPELAGO_LOCATION_SEND", "NONE");
    //Lua Log Passing Dvars
    SetDvar("ARCHIPELAGO_LOG_MESSAGE", "NONE");


	callback::on_start_gametype( &game_start );
	callback::on_connect( &on_player_connect );
	callback::on_spawned( &on_player_spawned ); 


    //Clientfields (Mostly Tracker stuff)
    //TODO Put this in a library?
    clientfield::register("world", "ap_item_juggernog", VERSION_SHIP, 2, "int");
    clientfield::register("world", "ap_item_double_tap", VERSION_SHIP, 2, "int");
    clientfield::register("world", "ap_item_quick_revive", VERSION_SHIP, 2, "int");
    clientfield::register("world", "ap_item_speed_cola", VERSION_SHIP, 2, "int");
    clientfield::register("world", "ap_item_mule_kick", VERSION_SHIP, 2, "int");
    clientfield::register("world", "ap_item_power_on", VERSION_SHIP, 2, "int");
    clientfield::register("world", "ap_item_wallbuys", VERSION_SHIP, 2, "int");

}

function __main__()
{


    level thread round_start_location();
    level thread round_end_noti();

    
}

function on_archi_connect_settings()
{

    //Handle Perk via AP instead of normal logic

    // level.archi.settings[PERK_QUICK_REVIVE] = true;
    // level.archi.settings[PERK_JUGGERNOG] = true;
    // level.archi.settings[PERK_DOUBLETAP2] = true;
    // level.archi.settings[PERK_ADDITIONAL_PRIMARY_WEAPON] = true;
    // level.archi.settings[PERK_SLEIGHT_OF_HAND] = true;
    // level.archi.settings[PERK_STAMINUP] = true;
    // level.archi.settings[PERK_WIDOWS_WINE] = true;

    // level.archi.settings["PERK_RANDOM"] = true;
    // level.archi.settings["PAP_MACHINE"] = true;
    // level.archi.settings["WALLBUYS_ITEM"] = true;

    //Turn off quick revive by default
    level.initial_quick_revive_power_off = true;

    //TODO do this to set wallbuy text?
    // foreach( s_wallbuy in level._spawned_wallbuys )
	// {
            //new_stub = s_wallbuy.trigger_stub
            //zm_unitrigger::unregister_unitrigger(s_wallbuy.trigger_stub);
            //alter new_stub
            //zm_unitrigger::register_dynamic_unitrigger(new_stub);
            //
	// }
    //

    //TODO: Check ALL Option in DVARS/archi settings
    level.next_dog_round 				= 9999;

    // level.n_next_raps_round 			= 9999;
    // level.n_next_spider_round 			= 9999;
    // level.n_next_sentinel_round 		= 9999;
    // level.next_wasp_round 				= 9999;
    
    // level.next_monkey_round 			= 9999;

    //Turn off/Hide Gobblebum Machines

    // if (isdefined(level.bgb_machines))
    // {
    //    for(i = 0; i < level.bgb_machines.size; i++)
    //     {
    //         //
    //         iPrintln("Turning off GB Machine");
    //         //
    //         level.bgb_machines[i] thread hide_bgb_machine();
    //         break;
    //     }
    // }

	
}

function game_start()
{
    if (!isdefined(level.archi))
    {
        //Hold server-wide Archipelago Information
        level.archi = SpawnStruct();

        //Get Map Name String
        mapName = GetDvarString( "mapname" );

        //DEBUG
        if (mapName == "zm_testbed")
        {
            mapName = "zm_factory";
        }
        

        if (mapName == "zm_factory")
        {
            level.archi.mapString = "(The Giant)";
            archi_items::RegisterItem("(The Giant) Power",&archi_items::give_TheGiantPowerOn,"ap_item_power_on");
            archi_items::RegisterItem("(The Giant) Juggernog",&archi_items::give_Juggernog,"ap_item_juggernog");
            archi_items::RegisterItem("(The Giant) Quick Revive",&archi_items::give_QuickRevive,"ap_item_quick_revive");
            archi_items::RegisterItem("(The Giant) Speed Cola",&archi_items::give_SpeedCola,"ap_item_speed_cola");
            archi_items::RegisterItem("(The Giant) Double Tap",&archi_items::give_DoubleTap,"ap_item_double_tap");
            archi_items::RegisterItem("(The Giant) Mule Kick",&archi_items::give_MuleKick,"ap_item_mule_kick");
            archi_items::RegisterItem("(The Giant) Pack A Punch",&archi_items::give_PackAPunch,undefined);
            archi_items::RegisterItem("(The Giant) Wallbuys",&archi_items::give_Wallbuys,"ap_item_wallbuys");
            archi_items::RegisterItem("(The Giant) Victory",&archi_items::give_Victory,undefined);
        }
        //TODO: Error if map doesnt exist
        archi_items::RegisterItem("50 Points",&archi_items::give_50Points);
        archi_items::RegisterItem("500 Points",&archi_items::give_500Points);
        

        //Server-wide thread to get items from the Lua/LUI
        level thread item_get_from_lua();

        //Server-wide thread to print Log messages from Lua/LUI
        level thread log_from_lua();

        //Collection of Locations that are checked, 
        level.archi.locationQueue = array();


        //setting to turn on/off wallbuys
        level.archi.wallbuys_on = false;
        //Do this with existing values, should be set in menu during initial Room Connection
        on_archi_connect_settings();

    }
    //Setup default map changes
    default_map_changes();
}

function default_map_changes()
{
    //Yeet the Power Switch Trigger into the sun
    //TODO: Capture this for later
    //TODO: Check this name on other maps
    if (level.archi.mapString == "(The Giant)")
    {
        //getent("use_power_switch", "targetname").origin = (10000, 10000, 10000);
    }
    //
    //Put this on a fake trigger?
    //level thread scene::play("power_switch", "targetname");
}

function on_player_connect()
{
    if (self IsHost())
    {
        self thread location_check_to_lua();
    }
}

function on_player_spawned()
{
	level waittill( "initial_blackscreen_passed" );

    //DEBUG - give some points
    //self zm_score::add_to_player_score(50000);
	//
    //wait 20;
    //SetDvar("ARCHIPELAGO_ITEM_GET","(The Giant) Wallbuys");

}

function round_start_location()
{
    
    level endon("end_game");
	level endon("end_round_think");
    while (true)
    {
        
        level waittill("start_of_round");
        //iPrintln("Round "+level.round_number+" Started");

        //Round 1 Location Check
        if (level.round_number == 1)
        {
            //TODO Check/change Map name
            array::add(level.archi.locationQueue, level.archi.mapString + " Round 01");
        }
    }
}

//Helpful, maybe actually put round start check here?
function round_end_noti()
{
    level endon("end_game");
	level endon("end_round_think");
    while (true)
    {
        
        level waittill("end_of_round");

        //Round 2+ Location Check
        round = level.round_number+1;
        //TODO map check/change
        loc_str = level.archi.mapString + " Round ";
        if (round<10)
        {
            loc_str += "0"+round;
        }
        else
        {
            loc_str += round;
        }
        array::add(level.archi.locationQueue,loc_str);

    }
}

//Recieved commands from the Archipelago Lua Coponent
function item_get_from_lua()
{
    level waittill( "initial_blackscreen_passed" );
    wait 5; // Wait for log to clear on game startup
    level endon("end_game");
	level endon("end_round_think");
    while(true)
    {
        item = GetDvarString("ARCHIPELAGO_ITEM_GET");
        if ( item != "NONE" )
        {
            if (isdefined(level.archi.items[item]))
            {

                self [[level.archi.items[item].getFunc]]();

                if (isdefined(level.archi.items[item].clientField))
                {
                    //TODO: make this safe, so it checks if the clientfield exists first
                    level clientfield::set(level.archi.items[item].clientField, 1);
                }
                LUINotifyEvent(&"ap_ui_get", 0);
            }

            SetDvar("ARCHIPELAGO_ITEM_GET","NONE");
            
        }
        wait .5;
    }
    
}

function log_from_lua()
{
    level waittill( "initial_blackscreen_passed" );

    level endon("end_game");
	level endon("end_round_think");
    while(true)
    {
        message = GetDvarString("ARCHIPELAGO_LOG_MESSAGE");
        if ( message != "NONE" )
        {
            
            iPrintln(message);
            SetDvar("ARCHIPELAGO_LOG_MESSAGE","NONE");
            
        }
        wait .5;
    }
}

//When we trip a Location, give to Lua
function location_check_to_lua()
{
    
    level waittill( "initial_blackscreen_passed" );
    //TODO tune this wait till it feels good vs archipelago log messages
    wait 3;
    self endon( "disconnect" );
    while(true)
    {
        if (level.archi.locationQueue.size > 0)
        {
            location = array::pop(level.archi.locationQueue);
            SetDvar("ARCHIPELAGO_LOCATION_SEND",location);
            LUINotifyEvent(&"ap_notification", 0);

            //Send notification for Send UI Image
            LUINotifyEvent(&"ap_ui_send", 0);
        }
        wait .5;
    }
}


#using scripts\codescripts\struct;
#using scripts\shared\system_shared;
#using scripts\shared\array_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_score;

#insert scripts\shared\shared.gsh;

#namespace archi_items;

function RegisterItem(itemName, getFunc,clientField) {
    item = SpawnStruct();
    item.name = itemName;
    item.getFunc = getFunc;
    item.clientfield = clientField;

    level.archi.items[itemName] = item;
}

//General/Universal gives
function give_500Points()
{
        foreach (player in getPlayers())
    {
        player zm_score::add_to_player_score(500);
    }
}

function give_50Points()
{
    foreach (player in getPlayers())
    {
        player zm_score::add_to_player_score(50);
    }
}

function give_Victory()
{
    iPrintln("Giving Victory");
    //if in game, end game
    level notify("end_game");
}

function give_Wallbuys()
{
    level.archi.wallbuys_on = true;
}

//Map-Specific Give Functions
function give_TheGiantPowerOn()
{
    getent("use_power_switch", "targetname") notify("trigger", level.players[0]);
}

//Simple Give Functions notifies
function give_SpeedCola()
{
    level notify( "ap_sleight_on" );
    util::wait_network_frame();
}
function give_QuickRevive()
{
    level notify( "ap_revive_on" );
    util::wait_network_frame();
}
function give_DoubleTap()
{
    level notify( "ap_doubletap_on" );
    util::wait_network_frame();
}
function give_Juggernog()
{
    level notify ("ap_juggernog_on");
    util::wait_network_frame();
}
function give_MuleKick()
{
    level notify ("ap_additionalprimaryweapon_on");
    util::wait_network_frame();
}


function give_PackAPunch()
{
    level notify ("ap_Pack_A_Punch_on");
    util::wait_network_frame();
}
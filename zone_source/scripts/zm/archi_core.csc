#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\array_shared;
#using scripts\shared\util_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\zm\_zm_utility;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#using scripts\shared\lui_shared;
#using scripts\zm\_zm_score;


#namespace archi_core;


REGISTER_SYSTEM("archipelago_core", &__init__, &__main__)

function __init__()
{

    //Clientfields (Mostly Tracker stuff)
    //TODO Put this in a library?

    clientfield::register("world", "ap_item_juggernog", VERSION_SHIP, 2, "int", &zm_utility::setSharedInventoryUIModels, false, true);
    clientfield::register("world", "ap_item_double_tap", VERSION_SHIP, 2, "int", &zm_utility::setSharedInventoryUIModels, false, true);
    clientfield::register("world", "ap_item_quick_revive", VERSION_SHIP, 2, "int", &zm_utility::setSharedInventoryUIModels, false, true);
    clientfield::register("world", "ap_item_speed_cola", VERSION_SHIP, 2, "int", &zm_utility::setSharedInventoryUIModels, false, true);
    clientfield::register("world", "ap_item_mule_kick", VERSION_SHIP, 2, "int", &zm_utility::setSharedInventoryUIModels, false, true);
    clientfield::register("world", "ap_item_power_on", VERSION_SHIP, 2, "int", &zm_utility::setSharedInventoryUIModels, false, true);
    clientfield::register("world", "ap_item_wallbuys", VERSION_SHIP, 2, "int", &zm_utility::setSharedInventoryUIModels, false, true);
}

function __main__()
{
    
}
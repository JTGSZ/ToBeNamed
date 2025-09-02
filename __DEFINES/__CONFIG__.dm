/*
	A define based configuration file because its the laziest thing you can possibly do.
*/

//Server Config options
#define CONFIG_SERVER_MIN_BYOND_VERSION 514 // Min Byond Version, don't set it low enough for guys to just crash if you usin new byond features
#define CONFIG_SERVER_GUESTS_ENABLED 	TRUE //Whether guests can join or not
#define CONFIG_SERVER_LOCALHOST_AUTOADMIN TRUE //Whether Localhost autoadmins you or not
#define CONFIG_SERVER_ALLOW_NON_SEEKER_CONNECTIONS FALSE // Whether we allow all the random shit like telnet, or the 3d webclient to connect

//If this is set to a url, the user will attempt to download resources from it
//There are a bunch of options avaliable, but 1 is just standard grab shit from server
// See: https://www.byond.com/docs/ref/#/client/var/preload_rsc
#define CONFIG_SERVER_RSC_URL 1

// When the server starts up it randomly picks a single song and then that becomes the lobby music. If its just random from the folder people won't really talk much
// Set this to false If you want no music at all
#define CONFIG_SERVER_TITLESCREEN_MUSIC_FOLDER "zAssets/Sounds/Audio_Error_Sound/" 

//World config options
#define CONFIG_WORLD_FPS 40 //Basically how fast we processin shit on the world's end
#define CONFIG_WORLD_ICON_SIZE 32 //Size of the default icon, effects a buncha shit idc to figure out
#define CONFIG_WORLD_VIEW 8 //Default viewport range, aka how many squares your player sees, this is outwards from the center so 8 radius would be 16x16 diameter
#define CONFIG_WORLD_SLEEP_OFFLINE FALSE //If its set to true, the world just stops doing shit if nobody is on.

//Persistence Config options
#define CONFIG_PERSIST_BASEFOLDER "Persistence_Data/" //Basefolder for all persistence shit
#define CONFIG_PERSIST_ADMINROSTER_FOLDER "[CONFIG_PERSIST_BASEFOLDER]Admin_Data/" //Directory we targeting for files named after admin_ckeys
#define CONFIG_PERSIST_PLAYERDATA_FOLDER "[CONFIG_PERSIST_BASEFOLDER]Player_Data/" //Directory we are targeting for playerdata
#define CONFIG_PERSIST_ADMIN_DATUM_VERSION 1 //Version number saved into json for admin datums, DO NOT MOVE IT UP UNLESS YOU MAKE A BREAKING CHANGE TO PREV DATA AND NEED TO UPDATE IT
#define CONFIG_PERSIST_PLAYER_DATA_VERSION 0 //Version number saved into json for player data. DO NOT MOVE IT UP UNLESS YOU MAKE A BREAKING CHANGE TO PREV DATA AND NEED TO UPDATE IT

//Pref Config options
#define CONFIG_PREF_RECC_CLIENT_FPS 50 //If they set their fps to -1 you give them this value automatically
#define CONFIG_PREF_DEFAULT_GAME_VOLUME 70 // 0 is nothing, and 100 is your eardrums playing russian roulette with random sfx

//Gameplay config options

//Debug options
#define CONFIG_DEBUG_BYPASS_INITIAL_JOIN_MENUS TRUE // Just automatically sticks you into a body and avoids any initial join menus
#define CONFIG_DEBUG_TRACE_PROCCALL_STACK_ON_ERROR TRUE // Will give you a entire proc call traced stack if a error occurs

#define CONFIG_DEBUG_VV_LIST_DISPLAY_MAX 7 // How many things we display from a list on VV before we just offer the list viewer to stop the menu from getting spammed
#define CONFIG_DEBUG_MAP_CHUNK_SIZE 8 // This basically is just how many turfs constitutes one map chunk mathematically for the map chunking datum

// Garbage handling config options - you want to uncomment some of these it causes the def to insert code
//#define CONFIG_GARBAGE_STOP_DEL_TURN_ON_REF_FIND // Will stop things from being del called in DeletionHandler when they are holding a hanging ref, and tries to track it
//#define CONFIG_GARBAGE_QDEL_HARDREF_INFORM_MSG // Gives you a dumb little message If something can't be garbage collected
#define CONFIG_GARBAGE_QDEL_QUEUE_DELAY_IN_SECONDS 2 // How many seconds before the deletionhandler will just call del on something being tracked
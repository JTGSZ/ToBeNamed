

//Absolute code Minimum for sound channels
#define SOUND_CHANNEL_MIN 1

//Absolute code Maximum for sound channels
#define SOUND_CHANNEL_MAX 1024

// The limit we give the client on what channels they can freely allocate
// Currently we got no reason to actually reserve channels thanks to the audio data tracking system
// But perhaps later...
#define SOUND_CHANNEL_CLIENT_MAX 1024

// The ID for the titlescreen in the client tracking
#define SOUND_ID_TITLESCREEN "TITLESCREEN"
#define SOUND_ID_SOUNDENV  "SOUNDENV"

/*
	macro for the only two vol switches we gonna be doin for sound updates rn
*/
#define SOUND_CL_ONSCREEN		"ONSCREEN"
#define SOUND_CL_OFFSCREEN		"OFFSCREEN"

// The soundvol percentage change for the emissive tracker sounds onscreen and offscreen
#define SOUND_VOL_ONSCREEN_PERCENT		70
#define SOUND_VOL_OFFSCREEN_PERCENT		40





//If you put this in the sending range on play_sound, it plays to all clients in the world
#define SOUND_TO_WORLD "sound_to_world"



/*
	So you can get autocomplete when dealing with the sound cache rng sound picking
*/
#define SFX_SOUND_ERROR "SOUND_ERROR"
#define SFX_MECH_SWITCH_EXAMPLE "SOUND_SWITCH"







/*
	list of default sound environments
	See: https://www.byond.com/docs/ref/index.html#/sound/var/environment
	Environment starts at -1 by default
*/
#define SOUND_ENVIRONMENT_OFF_DEFAULT 		-1 // You cannot set it to this and have it do shit lmao
#define SOUND_ENVIRONMENT_GENERIC 			0
#define SOUND_ENVIRONMENT_PADDED_CELL 		1
#define SOUND_ENVIRONMENT_ROOM 				2
#define SOUND_ENVIRONMENT_BATHROOM 			3
#define SOUND_ENVIRONMENT_LIVINGROOM 		4
#define SOUND_ENVIRONMENT_STONEROOM 		5
#define SOUND_ENVIRONMENT_AUDITORIUM 		6
#define SOUND_ENVIRONMENT_CONCERT_HALL 		7
#define SOUND_ENVIRONMENT_CAVE 				8
#define SOUND_ENVIRONMENT_ARENA 			9
#define SOUND_ENVIRONMENT_HANGAR 			10
#define SOUND_ENVIRONMENT_CARPETED_HALLWAY 	11
#define SOUND_ENVIRONMENT_HALLWAY 			12
#define SOUND_ENVIRONMENT_STONE_CORRIDOR 	13
#define SOUND_ENVIRONMENT_ALLEY 			14
#define SOUND_ENVIRONMENT_FOREST 			15
#define SOUND_ENVIRONMENT_CITY 				16
#define SOUND_ENVIRONMENT_MOUNTAINS 		17
#define SOUND_ENVIRONMENT_QUARRY 			18
#define SOUND_ENVIRONMENT_PLAIN 			19
#define SOUND_ENVIRONMENT_PARKING_LOT 		20
#define SOUND_ENVIRONMENT_SEWER_PIPE 		21
#define SOUND_ENVIRONMENT_UNDERWATER 		22
#define SOUND_ENVIRONMENT_DRUGGED 			23
#define SOUND_ENVIRONMENT_DIZZY 			24
#define SOUND_ENVIRONMENT_PSYCHOTIC 		25
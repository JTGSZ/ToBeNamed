// Song is picked from the titlescreen_music folder when the world starts up
// Its same song for everyone so they can at least talk about it
// also just admire this shitty one-liner
GLOB_VAR(titlescreen_music) = file("[CONFIG_SERVER_TITLESCREEN_MUSIC_FOLDER][pick(flist(CONFIG_SERVER_TITLESCREEN_MUSIC_FOLDER))]")

// just a cache of sound lengths to save on external lib calls
GLOB_ALIST(sound_length_cache) = alist()

/*
	Soundcache
	basically its just a proc that returns one random file path from a set
	p simple
	you put in the string and you get a filepath
	you got defines too so it autocompletes
*/

/proc/soundcache_check(given_sound_data)	
	switch(given_sound_data)
		if(SFX_MECH_SWITCH_EXAMPLE)
			return pick('zAssets/Sounds/mechanical_switch1.wav') // You just add more string defs/pick lists or regular paths here
		else
			// We were given a filepath and it passed the check so onwards u go
			if(isfile(given_sound_data))
				return given_sound_data
			else //SFX_SOUND_ERROR - i hope you learn the errors of your ways when these play
				return pick('zAssets/Sounds/Audio_Error_Sound/error_1.ogg', 
							'zAssets/Sounds/Audio_Error_Sound/error_2.ogg', 
							'zAssets/Sounds/Audio_Error_Sound/error_3.ogg', 
							'zAssets/Sounds/Audio_Error_Sound/error_4.ogg',
							'zAssets/Sounds/Audio_Error_Sound/error_5.ogg',
							'zAssets/Sounds/Audio_Error_Sound/error_6.ogg', 
							'zAssets/Sounds/Audio_Error_Sound/error_7.ogg')
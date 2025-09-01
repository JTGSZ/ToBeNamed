/client/verb/change_fps()
	set name = ".change_fps"
	set hidden = 1

	var/desiredfps = input(usr, "Choose your desired fps.\n-1 means recommended value (currently:[CONFIG_PREF_RECC_CLIENT_FPS])\n0 means world fps (currently:[world.fps])", "FPS", fps)  as null|num
	if(desiredfps)
		fps = desiredfps

		var/datum/player_persistence_data/found_data = Persistence_Controller.get_player_data(ckey)
		found_data.client_fps = desiredfps

/client/verb/change_game_volume()
	set name = ".change_game_volume"
	set hidden = 1

	var/datum/player_persistence_data/found_data = Persistence_Controller.get_player_data(ckey)
	var/desired_vol = input(usr, "Choose your new game volume. \n1-100 (currently: [found_data.client_game_volume]%)", "Game Volume", found_data.client_game_volume) as null|num
	desired_vol = clamp(desired_vol,0 ,100)
	if(desired_vol)
		found_data.client_game_volume = desired_vol
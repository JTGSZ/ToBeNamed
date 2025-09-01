/*
	Basically a mob for people who just join.
	It don't really do much, and really shouldn't either since they need to load up/make a character.
	they get transferred into a soul from here and deleted, and the soul gets slammed into a body.
*/

/mob/new_player
	name = "new player"
	desc = "Some dumb shit chillin until they get given a body."
	icon_state = "gear"
	density = FALSE

	see_invisible = INVISIBILITY_MAXIMUM

	var/making_character = FALSE


/mob/new_player/New()
	..()

/mob/new_player/Initialize()
	..()
		
/mob/new_player/Destroy()
	..()

/mob/new_player/Login()

	if(length(GLOB.map_mark_list?[MAPMARK_NEWPLAYERSTART]))
		var/obj/map_mark/chosen_mark = pick(GLOB.map_mark_list[MAPMARK_NEWPLAYERSTART])
		loc = chosen_mark.loc
	else
		loc = locate(2,2,1)

	spawn(1 SECONDS) // The player's actual byond client needs in and ready to go before it can receive sound
		if(CONFIG_DEBUG_BYPASS_INITIAL_JOIN_MENUS) // We just bypass the initial join menus cause we r in a rush to do shit
			transfer_into_soul()
			return

		var/client/C = src.client
		if(C)
			if(GLOB.titlescreen_roamers)
				var/mob/titlescreen_roamer/TR = pick(GLOB.titlescreen_roamers)
				force_into_contents(TR)
				src.client.eye = TR

			C.play_titlescreen_music()
			spawn_mainmenu()

		var/mob/comms_listener/CL = new()
		CL.data_link_to_target(src)
		CL.movement_link_to_target(src)
		CL.toggle_flag(COMMS_FLAG_AUDIO)


/mob/new_player/Logout()
	..()


/mob/new_player/proc/spawn_mainmenu()
	var/datum/screen_object_group/mainmenu/our_mainmenu = new()
	our_mainmenu.apply_screenobjects_to_client(client)


//This proc name sucks
//But its basically us cramming this cunt into another mob.
/mob/new_player/proc/transfer_into_soul()
	var/mob/player_soul/new_soul = new(src.loc)
	new_soul.ckey = ckey
	qdel(src)
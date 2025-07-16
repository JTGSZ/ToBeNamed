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
	give_comms_listener = TRUE
	see_invisible = INVISIBILITY_MAXIMUM


/mob/new_player/New()


	..()

/mob/new_player/Destroy()
	. = ..()

/mob/new_player/Login()

	if(GLOB.map_mark_list[MAPMARK_NEWPLAYERSTART] && islist(GLOB.map_mark_list[MAPMARK_NEWPLAYERSTART]))
		if(GLOB.map_mark_list[MAPMARK_NEWPLAYERSTART].len)
			var/obj/map_mark/chosen_mark = pick(GLOB.map_mark_list[MAPMARK_NEWPLAYERSTART])
			loc = chosen_mark.loc
	else
		loc = locate(2,2,1)

	if(CONFIG_DEBUG_BYPASS_INITIAL_JOIN_MENUS) // We just bypass the initial join menus cause we r in a rush to do shit
		transfer_into_soul()
	else
		var/datum/screen_object_group/mainmenu/our_mainmenu = new()
		our_mainmenu.apply_screenobjects_to_client(client)
		// Placeholder UI Menu

/mob/new_player/Logout()
	..()

//This proc name sucks
//But its basically us cramming this cunt into another mob.
/mob/new_player/proc/transfer_into_soul()
	var/mob/player_soul/new_soul = new(src.loc)
	new_soul.ckey = src.ckey
	qdel(src)





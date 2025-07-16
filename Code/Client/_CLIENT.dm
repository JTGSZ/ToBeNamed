/* 
	Parent of client shit.... although client can't handle children neways afaik.
	So this is just a place for the shit we define on it so far
*/
//global list of clients
GLOB_LIST(clients) = list()

/client
	control_freak = CONTROL_FREAK_MACROS

	var/datum/admin_data/admin_data //You could potentially have a admin datum INSIDE OF YOU(r client)
	var/datum/browser_chat/browser_chat_instance //Our very own browser chat instance
	var/datum/player_persistence_data/persist_data // A ref to our client's data on player_persistence_data, unneeded but here you go.

	//Input Related
	var/list/input_keymap = list() // the input map for keys on the client, the input map on persist data is the one thats saved/loaded though.
	var/list/movement_keymap = list() //The list of movement keys, mostly to allow movement while other shit is going on
	var/list/held_keymap = list() // List of currently held down keys

/*
	The whole chain is weird
	Basically it firsts calls world/isBanned()
	Then this gets called
	Then mob/login() gets called if theres a key on one it finds

	If null is also returned on this, we jus disconnect the person too
*/
/client/New()
	if(connection != "seeker" && !(CONFIG_SERVER_ALLOW_NON_SEEKER_CONNECTIONS)) //Theres always the 3d client on web if someone sets it up.. or shit like telnet i guess
		del(src)

	if(byond_version < CONFIG_SERVER_MIN_BYOND_VERSION)	//Out of date client.
		alert(src,"Your BYOND client is out of date. Please make sure you have have at least version [world.byond_version] installed. Check for a beta update if necessary.", "Update Yo'Self", "OK")
		spawn(5 SECONDS)
			del(src)

	if(!CONFIG_SERVER_GUESTS_ENABLED && IsGuestKey(key)) // Whether you want guests to be able to join or not
		alert(src,"This server doesn't allow guest accounts to play. Please go to http://www.byond.com/ and register for a key.","Guest","OK")
		del(src)
		return

	..()	//calls mob.Login()

	//Enter us into the clients global list.
	GLOB.clients += src

	src << browse_rsc('zHTML/stylesheets/__universal_stylesheet.css')

	//Time to retrieve our persistence data bro, we probably got a bunch of shit that could use it past this point.
	persist_data = Persistence_Controller.handle_player_data(src) // You are getting something here whether you like it or not
	sync_input_keymaps() //Sync the input keymaps.

	//Should we even attempt to startup browser ui if they cannot even join the server beforehand? It'd just look nice to a guy being ejected automatically for a second.
	browser_chat_instance = new /datum/browser_chat(src)
	browser_chat_instance.Load_Browser_Chat()
	
	// If you have another place for people to download the rsc
	preload_rsc = CONFIG_SERVER_RSC_URL

	// So the user doesn't complain if they see stuff slowly loading in as they download the rsc, in the off-chance we have it set to download while client is ingame.
	if(preload_rsc == 0)
		src_msg("If the title screen is black, resources are still downloading. Please be patient until the title screen appears.")

	//Give our dear client some browser options, such as zooming, finding, and refresh, the debug rights give you inspect, and I don't think we need byondstorage right now.
	winset(src, null, "browser-options=zoom,find,refresh")

	//Admin Authorisation
	var/static/list/localhost_addresses = list("127.0.0.1","::1")
	if(CONFIG_SERVER_LOCALHOST_AUTOADMIN && (!address && !world.port) || (address in localhost_addresses))
		var/datum/admin_data/new_data = new("Localhost", ADMIN_RIGHTS_HOST, src.ckey)
		GLOB.admin_datums[src.ckey] = new_data
		new_data.link_to_client(src)
	else
		//If we have our ckey as a assc id in the admin_datums list, we run the refs both directions between it and this client.
		if(GLOB.admin_datums[src.ckey])
			var/datum/admin_data/target_data = GLOB.admin_datums[src.ckey]
			target_data.link_to_client(src)

	//change client fps sometime, it will help their shit out
	fps = (persist_data.client_fps < 0) ? CONFIG_PREF_RECC_CLIENT_FPS : persist_data.client_fps


	
/*
	Same deal here, we are apparently calling Logout() on a mob we are leaving
*/
/client/Del()
	if(admin_data)
		admin_data.linked_client = null
	GLOB.clients -= src

	return ..()


/*
	Why yes, the client does have a move proc
	The built in client proc only got these two things
*/
/client/Move(loc, dir) 
	if(!isturf(mob.loc))
		var/atom/movable/vore_mommy = mob.loc // we don't really need areas and turfs involved in our fuckery
		vore_mommy.relayMove(src, dir)
	else
		step(mob, dir)
	//. = ..()
	
//And heres send_message's dumbass companion,
//To note we are going to actually display this message in the client's chatbox from here, so might as well let things be different per client from client potentially
/client/proc/receive_message(datum/message_data/msg_data)
	var/parsed_data = "[msg_data.message]"
	to_client_chat(src, parsed_data)


/client/proc/get_body()
	var/mob/player_soul/our_soul = mob
	if(our_soul)
		return our_soul.the_body
	else
		return mob
	


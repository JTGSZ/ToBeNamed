
/* 
	FOR DEBUGGING PURPOSES
*/
/atom/proc/has_enhanced_hearing()
	return FALSE


/*
	Delivers message data to all comms listeners visible from the turf we are at
*/
/proc/route_message_hearers(datum/message_data/msg_data)
	//Now we perform the local check for shit, aka what we can see
	for(var/mob/comms_listener/CL in hearers(msg_data.sending_range, get_turf(msg_data.sender)))
		CL.receive_message(msg_data)

/*
	Delivers message data to all comms listeners within a certain distance from the turf we are at
*/
/proc/route_message_distance(datum/message_data/msg_data)
	for(var/mob/comms_listener/CL in GLOB.comms_listeners)
		// One must remember, the comms listeners can be anywhere, but are everywhere someone can receive message data
		// Also when a mob enters the contents of anything their z is set to 0 lmao, so if you were going to do a coord check you want to compare it to their get_turf
		if(msg_data.sending_range >= get_dist(msg_data.sender, CL) && CL.z == msg_data.sender.z)
			CL.receive_message(msg_data)


/*
	Delivers message data to all clients in the world
*/
/proc/route_message_all_clients(datum/message_data/msg_data)
	for(var/client/C in GLOB.clients)
		C.receive_message(msg_data)

/*
	Single client
*/
/proc/route_message_single_client(client/target_client, datum/message_data/msg_data)
	target_client.receive_message(msg_data)

/*
	Single listener lol
*/
/proc/route_message_single_listener(mob/comms_listener/CL, datum/message_data/msg_data)
	CL.receive_message(msg_data)


/*
	List of listeners
*/
/proc/route_message_list_of_listeners(list/listener_list, datum/message_data/msg_data)
	for(var/mob/comms_listener/CL as anything in listener_list)
		CL.receive_message(msg_data)
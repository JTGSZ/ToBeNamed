/*
	Basically you got a choice of slamming in 1 billion params
	sending a list over
	Or just making this cunt and transferring a ref with all of the relevant data
	Lets try this first
	I wouldn't use this for mechanical messages (Just output those directly), this is just meant for ic/ooc communication
	Also none of this is final, a lot will prob be removed/added really
*/

/datum/message_data
//A ref to our sender
	var/atom/sender = null
//The message we are storing here.
	var/message = FALSE
//IC Vars
// PLACEHOLDER FOR NOW, IF I PUT IN DEFINES HOW WILL WE HAVE MODULAR CONTENT FOR IT
	var/language = FALSE 
// The range in which we are attempting to send it
	var/sending_range = FALSE
// Z levels we may be sending the message to if we are checking based on distance
	var/list/target_z_levels
// Some criteria to help the listeners handle some more detailed logic states
	var/list/comms_flags = list(COMMS_FLAG_NORMAL)
//in case you want to tack sound onto the message data
	var/sound/sound_data/sound_data

//Idk you probably only really need these three anyways.
/datum/message_data/New(given_sender, given_message, given_sending_range, flags)
	..()
	if(given_sender)
		sender = given_sender
	if(given_message)
		message = given_message
	if(given_sending_range)
		sending_range = given_sending_range
	if(flags) //If I remember correctly, if you provide a list it will merge all the crap in anyways
		comms_flags += flags

/datum/message_data/Destroy()
	sender = null
	sound_data = null
	..()
	
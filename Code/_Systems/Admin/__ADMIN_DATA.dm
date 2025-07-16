
/*
	Assc list of loaded admin datums
	GLOB.admin_datums["ckey"] = datum
	see: admin_holder.dm
*/

GLOB_LIST(admin_datums) = list()

/datum/admin_data
	var/ckey_of_owner = "ERROR" //Their ckey
	var/cosmetic_rank = "Gaydmin" // This is just a cosmetic rank
	var/client/linked_client = null // The client that is actively linked to this
	var/list/admin_rights = list() // Why have admin data at all if the motherfucker isn't an admin?

/*
	In new we just setup the relevant information into the admin datum
	We have to associate it to a live client
	You may ask why? Its because we load ALL the datums in on world init
*/
/datum/admin_data/New(initial_cosmetic_rank = "Gaydmin", initial_admin_rights, given_ckey)
	if(!given_ckey)
		world_msg("Admin datum created without a ckey argument. Datum has been deleted. Fuck you")
		qdel(src)
		return
	ckey_of_owner = given_ckey
	cosmetic_rank = initial_cosmetic_rank
	add_admin_rights(initial_admin_rights)

/* 
	We link the data to a active client
	Aka this just links refs and verbs
*/
/datum/admin_data/proc/link_to_client(client/C)
	if(C && C.ckey == ckey_of_owner)
		linked_client = C
		linked_client.admin_data = src

		//Give debug rights ability to inspect the browser windows
		if(ADMIN_RIGHTS_DEBUG in admin_rights)
			winset(C, null, list("browser-options"="+devtools"))

		add_admin_verbs_to_client()

/*
	We unlink the data from a client
	And just cleanup refs
*/
/datum/admin_data/proc/unlink_from_client()
	if(linked_client)
		winset(linked_client, null, list("browser-options"="-devtools"))
		remove_admin_verbs_from_client()
		linked_client.admin_data = null
		linked_client = null

/*
	Damn... time for some ez helpers
*/

/datum/admin_data/proc/add_admin_rights(admin_right_to_add)
	if(islist(admin_right_to_add))
		admin_rights |= admin_right_to_add
	else if(istext(admin_right_to_add))
		admin_rights += admin_right_to_add
	else
		ERROR_MSG("Something is calling add_admin_rights with no params")

/datum/admin_data/proc/remove_admin_rights(admin_right_to_remove)
	if(islist(admin_right_to_remove))
		admin_rights = admin_rights & admin_right_to_remove
	else if((istext(admin_right_to_remove)) && (admin_right_to_remove in admin_rights))
		admin_rights -= admin_right_to_remove
	else
		ERROR_MSG("Something is calling remove_admin_rights with no params")

/*
	Rights are strings
	You can pass in a list or just the string
	The defines are located in _ADMIN_admin_right.dm
*/
/proc/check_admin_rights(admin_right_required)
	var/check_status = TRUE
	var/warning_message

	if(!admin_right_required) // Might as well just return false so they find out they called this for no reason
		check_status = FALSE
		warning_message = "ERROR: admin_right Check called with no permission requirement."

	if(usr && usr.client)
		var/client/C = usr.client

		if(!C.admin_data)
			check_status = FALSE
			warning_message = "ERROR: You have no admin data."

		if(islist(admin_right_required))
			for(var/our_rights in C.admin_data.admin_rights)
				if(!(our_rights in admin_right_required))
					check_status = FALSE
					warning_message = "ERROR: You lack admin_right to do this."
					break

		else if(istext(admin_right_required))
			if(!(admin_right_required in C.admin_data.admin_rights))
				check_status = FALSE
				warning_message = "ERROR: You lack admin_right to do this."

	if(warning_message)
		ERROR_MSG(warning_message)

	return check_status


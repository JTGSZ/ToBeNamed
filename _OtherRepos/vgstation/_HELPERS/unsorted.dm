// How many times to retry winset()ing window parameters before giving up
#define WINSET_MAX_ATTEMPTS 10
/proc/onclose(mob/user, windowid, var/atom/ref=null)
	set waitfor = FALSE // winexists sleeps
	for(var/i in 1 to WINSET_MAX_ATTEMPTS)
		if(user && winexists(user, windowid))
			var/param = ref ? "\ref[ref]" : "null"
			winset(user, windowid, "on-close=\".windowclose [param]\"")
			break

/proc/time_stamp()
	return time2text(world.timeofday, "hh:mm:ss")


/proc/datum_info_line(var/datum/D)
	if (!istype(D))
		return

	if (!istype(D, /mob))
		return "[D] ([D.type])"

	var/mob/M = D
	return "[M] ([M.ckey]) ([M.type])"

/proc/atom_loc_line(var/atom/A)
	if (!istype(A))
		return

	var/turf/T = get_turf(A)
	if (isturf(T))
		return "[T] ([T.x], [T.y], [T.z]) ([T.type])"

	else if (A.loc)
		return "[A.loc] (nullspace) ([A.loc.type])"

	else
		return "(nullspace)"

//Returns whether or not a player is a guest using their ckey as an input
/proc/IsGuestKey(key)
	if (findtext(key, "Guest-", 1, 7) != 1) //was findtextEx
		return 0

	var/i, ch, len = length(key)

	for (i = 7, i <= len, ++i)
		ch = text2ascii(key, i)
		if (ch < 48 || ch > 57)
			return 0
	return 1

//Converts a rights bitfield into a string for display purposes
/proc/rights2text(rights,seperator="")
	if(rights & R_ADMIN)
		. += "[seperator]+ADMIN"
	if(rights & R_DEBUG)
		. += "[seperator]+DEBUG"
	if(rights & R_PERMISSIONS)
		. += "[seperator]+PERMISSIONS"
	return .
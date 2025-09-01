/*
	Datum Parent
		These gonna be used for too many abstract purposes for me to really keep a track on in one folder
		This basically the parent of everything other than like client world and apparently list
		So you pretty gucci to stick overreaching procs here
*/

/datum

	// alist that gets made when our boy gets his first hook added onto him
	var/alist/proc_callhooks

	// The status of the datum in the deletion tracker
	var/gcDestroyed

// Called when you use qdel()
/datum/proc/Destroy()
	gcDestroyed = "Bye, world!"
	tag = null

/datum/proc/Initialize()
	return TRUE

/datum/proc/Process()


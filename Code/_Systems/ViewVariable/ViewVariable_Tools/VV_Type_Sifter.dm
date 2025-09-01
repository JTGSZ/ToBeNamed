/*
	Meant to figure out what type you are dealing with and return a proper html line for the uis
*/
/datum/ui/view_variable/proc/VV_sift_type(received_data)
	if(islist(received_data))
		. = "<a href='byond://?src=\ref[src];ViewList=\ref[received_data]'>/list([length(received_data)])</a>"
		return
	if(isnull(received_data))
		. = "NULL"
		return
	if(isdatum(received_data) || isclient(received_data))
		. = "<a href='byond://?src=\ref[src];ViewReference=\ref[received_data]'>[received_data:type]</a>"
		return
	if(istext(received_data))
		. = "\"[received_data]\""
		return
	if(isfile(received_data))
		. = "\'[received_data]\'"
		return
	if(received_data || isnum(received_data))
		. = "[received_data]"
		return

	// If you somehow run into a thing that cannot be displayed in any form, you should probably resolve it
	. = "UNDEFINED DISPLAY BEHAVIOR"
	return


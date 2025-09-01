/*
	This is holding all the exceptions coming from world/error()
	they are all related to a error that come from a occurring file and line
	this attempts to display their data
*/
/datum/error_data_category
	var/name = "ERROR"
	var/error_last_seen = 0

	// associated list
	// Contents: timestamp - exception
	var/alist/exceptions = alist()
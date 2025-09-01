/mob/verb/make_runtime()
	set category = "DEV-Debug"

	var/list/cock = list("a", "b")
	world_msg("[cock[5]]")
/*
	This gets exceptions sent to it if a error occurs
	An important thing to note is you only get the file and line in the world error exception if debugging information is enabled on the dme file
	#define DEBUG
	
*/
/world/Error(exception/EX)
	if(CONFIG_DEBUG_TRACE_PROCCALL_STACK_ON_ERROR)
		CALLSTACK_DEBUG_MSG

	var/datum/error_data_category/EDCAT = GLOB.error_viewer.error_data_categories["[EX.file][EX.line]"]
	// Category for file and line error already exists, just add the exception to the total sum
	if(EDCAT)
		EDCAT.error_last_seen = world.time
		EDCAT.exceptions.Add(EX)
		return

	// A BRAND NEW NEVER BEFORE SEEN ERROR!
	EDCAT = new()
	GLOB.error_viewer.error_data_categories["[EX.file][EX.line]"] = EDCAT

	var/cur_timestamp = WORLD_TIMESTAMP
	EDCAT.name = "\[[cur_timestamp]\]: [EX.name] FILE: [EX.file]:[EX.line]"
	EDCAT.exceptions[cur_timestamp] = EX
	admin_msg({"<b>NEW RUNTIME: [EX.name] <br> File:[EX.file] Line:[EX.line] <a href='?src=\ref[GLOB.error_viewer];error_data_category=\ref[EDCAT];EDC_timestamp_key=[cur_timestamp]'>(VIEW)</a></b>"})
	
	








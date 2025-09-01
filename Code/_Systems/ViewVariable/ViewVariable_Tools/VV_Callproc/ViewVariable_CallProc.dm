
/*
	We do not in fact need a caller to call a proc off this, but is it advised? probably
	Also special thanks to goonstation for the code
*/

/datum/ui/view_variable/proc/call_proc(caller, target_thing, target_proc)
	if(!target_proc && caller) //If they gave us a caller, and no target proc string we ask the fuckin caller what the hells they want
		target_proc = input(caller, "Procpath {ex. cock_insertion}", "Proc Path:", null) as null|text
	if(!target_proc) //And at this point if we still have nothing its time to fuck off.
		return

	//Theres currently no tools to do the arguments
	TODO("Type tools + Argument helpers in call_proc on view_variable_tools")
	var/list/arguments_list = list()

	//As you can see this tries its best. So its a try_list
	var/list/try_list

	//Guess all you get for now is this part
	if(istext(target_proc))
		if(copytext(target_proc, 1, 6) == "proc/") 
			target_proc = copytext(target_proc, 6)
		else if(copytext(target_proc, 1, 7) == "/proc/")
			target_proc = copytext(target_proc, 7)
		try_list = list(target_proc, "proc/" + target_proc, "/proc/" + target_proc, "verb/" + target_proc)
	else // is an actual proc, not a name
		try_list = list(target_proc)
	
	var/success = FALSE
	for(var/actual_proc in try_list)
		try
			if (target_thing)
				if(islist(arguments_list) && length(arguments_list))
					call(target_thing, actual_proc)(arglist(arguments_list))
				else
					call(target_thing, actual_proc)()
			else
				if(islist(arguments_list) && length(arguments_list))
					call(actual_proc)(arglist(arguments_list))
				else
					call(actual_proc)()
			success = TRUE
			break
		catch(var/exception/e)
			if(e.name != "bad proc" && copytext(e.name, 1, 15) != "undefined proc") // fuck u byond
				usr_msg("Exception occurred!")
				//boutput(usr, "<span class='alert'>Exception occurred! <a style='color: #88f;' href='byond://winset?command=View-Runtimes'>View Runtimes</a></span>")
				throw e

	if(!success)
		usr_msg("Proc [target_proc] not found!")
		//boutput(usr, "<span class='alert'>Proc [procname] not found!</span>")
		return
	

var/global/list/list/procs_by_type = null

/proc/generate_procs_by_type()
	if(!isnull(procs_by_type)) // don't want to rebuild twice if someone is really spamming this
		return
	procs_by_type = list()
	var/subaddr = 0
	while(TRUE)
		var/addr = BUILD_ADDR(PROC_TYPEID, subaddr) // 26 is the type id used by procs for ref
		var/pr = locate(addr)

		if(!pr)
			break

		var/pr_path = "[pr]"
		var/last_slash = findlasttext(pr_path, "/")
		var/proc_or_verb = copytext(pr_path, last_slash - 5, last_slash)
		var/owner_type

		if(proc_or_verb == "/proc" || proc_or_verb == "/verb")
			owner_type = text2path(copytext(pr_path, 1, last_slash - 5))
		else
			owner_type = text2path(copytext(pr_path, 1, last_slash))

		var/pr_name = copytext(pr_path, last_slash + 1)

		if(!(owner_type in procs_by_type))
			procs_by_type[owner_type] = list()

		procs_by_type[owner_type][pr_name] = pr
		//if(subaddr % 100 == 0)
		//	LAGCHECK(LAG_MED)
		subaddr++
	for(var/type in procs_by_type)
		procs_by_type[type] = sortList(procs_by_type[type], /proc/cmp_text_asc)
		//LAGCHECK(LAG_MED)
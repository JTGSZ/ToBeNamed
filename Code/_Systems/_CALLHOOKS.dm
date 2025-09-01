/*
	What are callhooks?
	They just let you register a proc to be called at a place marked with a HOOK_SIG_ID
	Pretty simple, and also datum level
	
	If for some reason you want to do special args routing input per hook, 
	then you probably will need to rewrite this to track specific hooks and handle special data
*/


/*
	HOOK_SIG_ID - string of the target hook signature
	proc_call_target - ref to what we will call the proc on
	proc_ref - the proc we will be calling
*/
/datum/proc/register_hook_sig(HOOK_SIG_ID, datum/proc_call_target, proc_ref)
	if(isnull(proc_callhooks)) // datum has never had a hook before, give him he list
		proc_callhooks = alist()

	if(isnull(proc_callhooks[HOOK_SIG_ID])) // datum has never had the event before
		proc_callhooks[HOOK_SIG_ID] = list()
	
	if(isnull(proc_callhooks[HOOK_SIG_ID]["[ref(proc_call_target)]"]))
		proc_callhooks[HOOK_SIG_ID]["[ref(proc_call_target)]"] = list()
	
	proc_callhooks[HOOK_SIG_ID]["[ref(proc_call_target)]"] += proc_ref


/*
	HOOK_SIG_ID - string of the target hook signature
	proc_call_target - ref to what we will call the proc on
	proc_ref - the proc we will be calling
*/
/datum/proc/unregister_hook_sig(HOOK_SIG_ID, datum/proc_call_target, proc_ref)
	for(var/proc_call_weakref as anything in proc_callhooks[HOOK_SIG_ID])
		
		var/datum/proc_call_ref = locate(proc_call_weakref)
		if(!isnull(proc_call_ref))
			proc_callhooks[HOOK_SIG_ID].Remove(proc_call_weakref)
			break

		if(proc_call_target == proc_call_ref)
			if(proc_ref in proc_callhooks[HOOK_SIG_ID][proc_call_weakref])
				proc_callhooks[HOOK_SIG_ID][proc_call_weakref].Remove(proc_ref)
				break
		
			if(!length(proc_callhooks[HOOK_SIG_ID][proc_call_weakref]))
				proc_callhooks[HOOK_SIG_ID].Remove(proc_call_weakref)
				break

/*
	HOOK_SIG_ID - string of the target hook signature
	... - any random arguments you want to provide, gets crammed into the argslist via copying anything index 2 and further

	What is given into the params by default before extra args (src_of_invoke_call)
*/
/datum/proc/invoke_hook_sig(HOOK_SIG_ID, ...)
	var/list/arguments = list(HOOK_SIG_ID, src) // So whatever is receiving the proccall gets a ref of the thing the callhook was invoked on
	arguments |= args.Copy(2) // the rest of the args come afterwards

	for(var/proc_call_weakref as anything in proc_callhooks[HOOK_SIG_ID])
		var/datum/proc_call_ref = locate(proc_call_weakref)
		if(!proc_call_ref)
			proc_callhooks[HOOK_SIG_ID].Remove(proc_call_weakref)

		for(var/proc_refs in proc_callhooks[HOOK_SIG_ID][proc_call_weakref])
			// You get a return value and it also won't runtime
			. = . | call(proc_call_ref, proc_refs)(arglist(arguments))


/*
	HOOK_SIG_ID - string of the target hook signature
	proc_call_target - ref to what we will call the proc on
	proc_ref - the proc we will be calling
*/
/datum/proc/has_callhook(HOOK_SIG_ID, datum/proc_call_target, proc_ref)
	if(proc_ref in proc_callhooks?[HOOK_SIG_ID]?["[ref(proc_call_target)]"])
		return TRUE
	return FALSE

// Less costly than just invoking non-stop
/datum/proc/has_hooksig_calls(HOOK_SIG_ID)
	if(length(proc_callhooks?[HOOK_SIG_ID]))
		return TRUE
	return FALSE


// Just type your custom arguments related to the proc thats getting called back after the first three things
#define SPAWN_CALLBACK(target_thing, procpath, delay_time, arguments...) actual_spawn_callback("[ref(##target_thing)]", procpath, delay_time, ##arguments);

/*
a retarded wrapper callback
a proc will hold a ref to its container via .src
Which means if you spawn there is a ref held until that shits over
the src of this global proc is whatever the fuck the global procs are held on and not the object that needs the spawn
also gonna put a weakref into the params here just incase too
I didn't even bother checking this shit btw, so this may be entirely pointless
*/
/proc/actual_spawn_callback(target_ref, procpath, delaytime, ...)
	spawn(delaytime)
		var/datum/thing = locate(target_ref) // we try to find the thing from the ref macro
		if(thing) // still exists so now we keep truckin
			var/list/arguments
			if(length(args) > 3) // We were given arguments, aka there are more than three things in this list
				arguments = args.Copy(4) // now we need to copy this shit to cram it back into this retard
			call(thing, procpath)(arglist(arguments))



/*
	We still got a long way to go really
*/

/datum/ui/view_variable/Topic(href, href_list, hsrc)
	. = ..()
	if(href_list["window_closed"])
		qdel(our_window)
		our_window = null

	if(href_list["TODO"])
		world_msg("WE HIT A TODO IN VIEW_VARIABLE")

	if(href_list["ListProcs"])
		var/target_thing = locate(href_list["ListProcs"])
		if(target_thing)
			show_proc_list(target_thing)

	if(href_list["SetDirection"])
		var/atom/target_thing = locate(href_list["SetDirection"])
		if(target_thing)
			var/dir_set = href_list["DirectionToSet"]
			switch(dir_set)
				if("Left90")
					target_thing.dir = turn(target_thing.dir, 90)
				if("Left45")
					target_thing.dir = turn(target_thing.dir, 45)
				if("Right90")
					target_thing.dir = turn(target_thing.dir, -90)
				if("Right45")
					target_thing.dir = turn(target_thing.dir, -45)
				else
					var/list/english_dirs = list("NORTH", "NORTHEAST", "EAST", "SOUTHEAST", "SOUTH", "SOUTHWEST", "WEST", "NORTHWEST")
					dir_set = input(requestor, "Choose a direction for [target_thing] to face.", "Selection", "NORTH") as null|anything in english_dirs
					if (dir_set)
						target_thing.dir = text2dir(dir_set)
						usr_msg("Set [target_thing]'s direction to [dir_set]")

	if(href_list["ViewReference"])
		var target_object = locate(href_list["ViewReference"])
		if(target_object)
			requestor.View_Variable(target_object)

	if(href_list["CallProc"])
		var/target_proc = locate(href_list["proc_ref"])
		var/target_of_proccall = locate("CallProc")
		if(target_proc && target_of_proccall)
			call_proc(requestor, target_of_proccall, target_proc)

	if(href_list["ViewList"])
		var/list/target_list = locate(href_list["ViewList"])
//		list_debug_msg(target_list)
//		assc_list_debug_msg(target_list)
		VV_ListView(target_list)


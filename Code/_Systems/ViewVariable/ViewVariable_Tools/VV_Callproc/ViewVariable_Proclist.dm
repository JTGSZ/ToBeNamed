
/datum/ui/view_variable/proc/show_proc_list(datum/target) // null for global
	if(!target || !requestor)
		return

	var/list/procs = list_procs(target)
	var/link_target = isnull(target) ? "global" : "\ref[target]"
	var/list/lines = list()

	if(isnull(target))
		lines += "<title>Global procs</title>"
	else
		lines += "<title>Procs of [target] - \ref[target] - [target.type]</title>"

	world_msg("[length(procs)]")
	for(var/type in procs)
		if(type)
			lines += "<b syle='padding-left:20px;'>[type]</b><br>"
		for(var/proc_name in procs[type])
			var/pr = procs[type][proc_name]
			lines += "<a href='byond://?src=\ref[src];CallProc=[link_target];proc_ref=\ref[pr]'>[proc_name]</a><br>"

	lines = jointext(lines, "")

	our_window = new(requestor, "proc_list", null, 600, 450, src)
	our_window.html_content = lines
	our_window.quickset_stylesheet(STYLESHEET_VIEW_VARIABLES)
	our_window.fire_browser()


/*
Returns procs of a datum categorized by parent type on which they are defined.
e.g. list_procs(new /obj/item/gnome) returns
list(
	/obj/item/gnome = list("hohoho" = /obj/item/gnome/proc/hohoho),
	/obj/item = list(...),
	/obj = list(...),
	...
)
*/
/proc/list_procs(datum/target) // null for global
	. = list()

	if(!istype(procs_by_type))
		generate_procs_by_type()

	if(isnull(target))
		.[null] = procs_by_type[null]
		return

	var/type = target.type
	while(type)
		if(type in procs_by_type)
			.[type] = procs_by_type[type]

		var/string_type = "[type]"
		var/last_slash = findlasttext(string_type, "/")
		if(last_slash == 1)
			switch(type)
				if(/datum)
					return null
				if(/obj, /mob)
					return /atom/movable
				if(/area, /turf)
					return /atom
				else
					return /datum

		type = text2path(copytext(string_type, 1, last_slash)) // breaks if you override parent_type, watch out; I'd love to use initial(type.parent_type) but byond dumb

	
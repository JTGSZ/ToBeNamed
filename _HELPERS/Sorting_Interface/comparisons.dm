var/cmp_field = "name"

/proc/cmp_numeric_asc(a,b)
	return a - b

/proc/cmp_text_asc(a,b)
	return sorttext(b,a)

/proc/cmp_text_dsc(a,b)
	return sorttext(a,b)

/proc/cmp_name_asc(atom/a, atom/b)
	return sorttext(b.name, a.name)

/proc/cmp_name_dsc(atom/a, atom/b)
	return sorttext(a.name, b.name)

/proc/cmp_initial_name_asc(atom/a, atom/b)
	return sorttext(initial(b.name), initial(a.name))

/proc/cmp_initial_name_dsc(atom/a, atom/b)
	return sorttext(initial(a.name), initial(b.name))

/proc/cmp_ckey_asc(client/a, client/b)
	return sorttext(b.ckey, a.ckey)

/proc/cmp_ckey_dsc(client/a, client/b)
	return sorttext(a.ckey, b.ckey)



/proc/cmp_slavesystem_init(datum/world_slave_system/a, datum/world_slave_system/b)
	return a.initialize_order - b.initialize_order

/proc/cmp_slavesystem_display(datum/world_slave_system/a, datum/world_slave_system/b)
	if(a.stat_panel_display_rank == b.stat_panel_display_rank)
		return sorttext(b.name, a.name)
	return a.stat_panel_display_rank - b.stat_panel_display_rank

/proc/cmp_slavesystem_priority(datum/world_slave_system/a, datum/world_slave_system/b)
	return a.tick_usage_priority - b.tick_usage_priority


var/atom/cmp_dist_origin=null
/proc/cmp_dist_asc(var/atom/a, var/atom/b)
	return get_dist_squared(cmp_dist_origin, a) - get_dist_squared(cmp_dist_origin, b)

/proc/cmp_dist_desc(var/atom/a, var/atom/b)
	return get_dist_squared(cmp_dist_origin, b) - get_dist_squared(cmp_dist_origin, a)



/proc/cmp_list_by_element_desc(list/a, list/b)
	return a[cmp_field] - b[cmp_field]

/proc/cmp_list_by_element_asc(list/a, list/b)
	return b[cmp_field] - a[cmp_field]





/proc/cmp_datum_text_asc(datum/a, datum/b, variable)
	return sorttext(b.vars[variable], a.vars[variable])

/proc/cmp_datum_text_dsc(datum/a, datum/b, variable)
	return sorttext(a.vars[variable], b.vars[variable])


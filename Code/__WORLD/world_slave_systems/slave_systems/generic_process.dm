var/datum/world_slave_system/generic_process/SSGenericProcess

/*
	This guy just calls process every now and then on the shit that requests him
	V generic
*/

/datum/world_slave_system/generic_process
	name = "Generic Processing"
	
	initialize_order = SS_INIT_GENERIC_PROCESS
	tick_usage_priority = SS_PRIORITY_GENERIC_PROCESS
	stat_panel_display_rank = SS_DISPLAY_GENERIC_PROCESS
	tickdelay_before_next_work = 20

	var/list/list_of_things_that_get_proc_called = list()

/datum/world_slave_system/generic_process/New()
	SSGenericProcess = src


// As you can see, this is the part where we do the work and call all the retarded shit hooked onto us
/datum/world_slave_system/generic_process/Do_Work()
	for(var/datum/d in list_of_things_that_get_proc_called)
		d.Process()

// Add to the list of things to call procs on
/datum/world_slave_system/generic_process/proc/Add(target)
	list_of_things_that_get_proc_called += target

// Add to the list of things to call procs on
/datum/world_slave_system/generic_process/proc/Remove(target)
	list_of_things_that_get_proc_called -= target


/datum/world_slave_system/generic_process/stats_display()
	var/msg = "Registered: [list_of_things_that_get_proc_called.len]"
	..(msg)
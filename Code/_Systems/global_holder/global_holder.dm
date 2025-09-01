/*
	Idk this thing basically is just a datum to hold globals neawys
*/
var/global/datum/fancy_stats/global_holder/GLOB


/datum/fancy_stats/global_holder
	// The object used for the clickable stat() button.


/datum/fancy_stats/global_holder/stats_panel_entry()
	stat("Globals:", stat_click_object.update_text("Total Variables: [vars.len]"))
/*
	Basically if you want admins/anyone who cares about the performance of the server to see stats data
	then this will dump whatev the fuck you tracking into the SS tab
	When they try to click the text it should reach stat_click_object_click() too if you want custom menus/ui for it
*/
var/global/list/fancy_stats = list()


/datum/fancy_stats
	// The object used for the clickable stat() button.
	var/obj/stat_click_object/stat_click_object



/datum/fancy_stats/New()
	fancy_stats += src
	stat_click_object = new /obj/stat_click_object("Setting Up", src)

/*
	Thing to be displayed in the SS Tab
*/
/datum/fancy_stats/proc/stats_panel_entry()
	stat("UNDEFINED:", stat_click_object.update_text("YOU FORGOT TO TRACK DISPLAY DATA"))


// When the stat click object is clicked, it calls the thing in its ref
// Which should be this hopefully
/datum/fancy_stats/proc/stat_click_object_click()
	if(!usr.client.admin_data)
		return

	usr.client.View_Variable(src)
	admin_msg("Admin [usr.key] is debugging the [src] Global Datum.")
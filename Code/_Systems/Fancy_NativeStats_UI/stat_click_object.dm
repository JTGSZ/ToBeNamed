/*
	Basically this is a object with no icon that gets crammed into the stats panel
	The text is clickable because it is a object
	Which then calls the Click proc as thats the proc we have for mouse clickin right now
*/
/obj/stat_click_object
	// You update this with the text you want to display thats clickable
	name = "ERROR"
	// Basically this is a ref to the thing we are going to display data of
	var/ref_we_linked_to
	icon = null

/obj/stat_click_object/New(text, given_ref)
	name = text
	ref_we_linked_to = given_ref

/obj/stat_click_object/Destroy()
	ref_we_linked_to = null
	..()

/obj/stat_click_object/proc/update_text(given_text)
	name = given_text
	return src

/obj/stat_click_object/Click()
	ref_we_linked_to:stat_click_object_click()
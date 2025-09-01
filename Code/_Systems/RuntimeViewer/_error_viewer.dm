GLOB_VAR(datum/error_viewer/error_viewer) = new()

/client/proc/View_Runtimes()
	set name = "View Runtimes"
	set desc = "Open the Runtime Viewer"
	set category = "Debug"

	GLOB.error_viewer.list_of_EDCATS_menu()

/*
	This basically helps us hold runtimes and also display them in a chincy ass browser popup
*/
/datum/error_viewer
	// contents: error_data_categories["[EX.file][EX.line]"] = datum/error_data_category
	var/alist/error_data_categories = alist()



/*
	We gotta display all the categories that currently exist
	You click it and then then you see all the exceptions currently related to it inside
*/
/datum/error_viewer/proc/list_of_EDCATS_menu()
	var/html = ""

	for(var/file_and_line_keys as anything in error_data_categories)
		var/datum/error_data_category/EDCAT = error_data_categories[file_and_line_keys] 
		html += "<div><a href='?src=\ref[src];error_data_category=\ref[EDCAT]'>[EDCAT.name]</a></div>"

	var/datum/browser/our_window = new(usr, "error_handler", "Error Viewer", 720, 450, src)
	our_window.html_content = html
	our_window.quickset_stylesheet(STYLESHEET_SS13_COMMON)
	our_window.fire_browser()


	
/*
	When they click on a error data category, we list all the exceptions currently contained within it
	Display all the exceptions that are in a error data category
*/
/datum/error_viewer/proc/EDCATs_list_of_exceptions_menu(datum/error_data_category/EDCAT)
	var/html = ""


	for(var/cur_timestamp as anything in EDCAT.exceptions)
		html += "<div><a href='?src=\ref[src];error_data_category=\ref[EDCAT];EDC_timestamp_key=[cur_timestamp]'>[EDCAT.name]</a></div>"

	var/datum/browser/our_window = new(usr, "[EDCAT.name]", "[EDCAT.name]", 720, 450, src)
	our_window.html_content = html
	our_window.quickset_stylesheet(STYLESHEET_SS13_COMMON)
	our_window.fire_browser()


/*
	Display all the details that we can get out of a exception
*/
/datum/error_viewer/proc/exceptions_list_of_data_menu(datum/error_data_category/EDCAT, timestamp_key)
	var/html = ""
	var/exception/EX = EDCAT.exceptions[timestamp_key]
	
	var/list/split_desc = splittext(EX.desc, "\n")
	html += "[EX.name]<br>"
	for(var/desc_lines in split_desc)
		html += "[desc_lines]<br>"


	var/datum/browser/our_window = new(usr, "[timestamp_key][EX.name]", "[timestamp_key]:[EX.name]", 830, 450, src)
	our_window.html_content = html
	our_window.quickset_stylesheet(STYLESHEET_SS13_COMMON)
	our_window.fire_browser()



/datum/error_viewer/Topic(href, href_list)
	. = ..()
	if(href_list["error_data_category"])
		var/datum/error_data_category/EDCAT = locate(href_list["error_data_category"])

		if(href_list["EDC_timestamp_key"])
			exceptions_list_of_data_menu(EDCAT, href_list["EDC_timestamp_key"])
			return

		EDCATs_list_of_exceptions_menu(EDCAT)

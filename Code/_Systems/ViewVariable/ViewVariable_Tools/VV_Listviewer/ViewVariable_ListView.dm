
//Listview so you can get a listview
/datum/ui/view_variable/proc/VV_ListView(list/given_list)
	var/html = "<h1>List Viewer</h1>"
	html += "<table class=vartable>"

	var/current_index = 1
	for(var/current_key in given_list)
		var/current_value = given_list[current_key]

		html += "<tr class=varrow>"
		html += "<td class=varoptions>"
		html += "[current_index]. "
		html += "</td>"

		html += "<td class=varname>"
		html += VV_sift_type(current_key)
		html += "</td>"

		if(!isnull(current_value))
			html += "<td class=varvalue>"
			html += VV_sift_type(current_value)
			html += "</td>"

		html += "</tr>"

		current_index++

	html += "</table>"

	our_window = new(requestor, "[rand(1,900)]", "List Viewer", 600, 450, src)
	our_window.html_content = html
	our_window.quickset_stylesheet(STYLESHEET_VIEW_VARIABLES)
	our_window.fire_browser()
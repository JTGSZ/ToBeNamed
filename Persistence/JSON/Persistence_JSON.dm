/*
	Probably unnecessary but why not lol
*/
var/global/list/persistence_by_id_cache = list()
var/datum/Persistence_JSON/Persistence_Controller

/datum/Persistence_JSON

/*
	Some JSON helpers so I don't forget how this shit works later
*/

//Target path must be a string
/proc/get_list_from_jsonfile(target_path)
	var/list/loaded_data = list()

	var/target_file = file(target_path)
	loaded_data = json_decode(target_file)

	return loaded_data

//Target path must be a string
//Will check and do somethin akin to overwriting whats there
/proc/save_list_to_jsonfile(target_path, var/list/data_to_save)
	if(fexists("[target_path]"))  // File exists at target path
		if(!fdel("[target_path]")) // If for some reason we can't delete it we stop here
			return FALSE

	if(!data_to_save.len) // If the list contains nothing at all
		return FALSE // We just stop here

	var/writing = file("[target_path]")
	writing << json_encode(data_to_save)
	return TRUE



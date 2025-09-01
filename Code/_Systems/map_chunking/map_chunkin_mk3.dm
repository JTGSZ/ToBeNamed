
GLOB_VAR(datum/chunkin_mk_three/map_chunk_cache) = new()


// I think chunk numbers should only really be moving around in this file
#define TURF_COORD_2_CHUNK_NUM(coord_num) floor(coord_num / GLOB.map_chunk_cache.chunk_size)
// Apparently the documentation is wrong, because there is actually a global px coordinate system
#define PIXEL_2_CHUNK_NUM(coord_num) floor( floor(coord_num / CONFIG_WORLD_ICON_SIZE) / GLOB.map_chunk_cache.chunk_size)
#define CHUNK_KEY_STR(chunk_x, chunk_y, z_level) "x[chunk_x]y[chunk_y]z[z_level]"


/*
	Idk, same as the last except with more defines so its not a giant confusing blob of shit
	And you can chunk anything now

	Also, one may ask why this instead of persay, using the normal byond range searchin procs
	you basically gotta sift through all the crap you want via a ton of type checks on a loop versus just caching here and finding what you want in the list
	I didn't profile both as making the testcases sounds annoying but yea
*/
/datum/chunkin_mk_three

	// The current chunking size in turfs we are dealin with
	// thats a entire screens worth of turfs
	var/chunk_size = CONFIG_WORLD_VIEW * 2


	// thought about doing a 3d chunk cube, but that is a ton of lists that must be made if i do
	// so back to keys
	var/alist/chunk_keys = alist()


	var/list/premake_these_type_lists = list(/mob/comms_listener, /datum/sound_emitter)

/datum/chunkin_mk_three/New()
	prep_map_chunklists()


/*
	TURF PROCS
*/

/*
	Register to chunk lists by turfs
*/
/datum/chunkin_mk_three/proc/register_by_turf_range(datum/target_ref, atom/center_loc, turf_range)
	var/list/target_chunk_keys = get_list_of_chunk_keys(center_loc, floor(turf_range/chunk_size))
	for(var/chunk_key_str in target_chunk_keys)
		chunk_keys[chunk_key_str][target_ref.type] |= target_ref 

/*
	Unregister to chunk lists by turfs
*/
/datum/chunkin_mk_three/proc/unregister_by_turf_range(datum/target_ref, atom/center_loc, turf_range)
	var/list/target_chunk_keys = get_list_of_chunk_keys(center_loc, floor(turf_range/chunk_size))
	for(var/chunk_key_str in target_chunk_keys)
		chunk_keys[chunk_key_str][target_ref.type] -= target_ref 

/*
	Find type by turfs from da chunks
*/
/datum/chunkin_mk_three/proc/find_type_by_turf_range(datum/target_ref, atom/center_loc, turf_range)
	. = list()

	var/list/target_chunk_keys = get_list_of_chunk_keys(center_loc, ceil(turf_range / chunk_size))
	for(var/chunk_key_str in target_chunk_keys)
		if(length(chunk_keys[chunk_key_str][target_ref.type]))
			. |= chunk_keys[chunk_key_str][target_ref.type]



/*
	Find type by chunk ranges, shits like a screens worth of turfs right now anyways
*/
/datum/chunkin_mk_three/proc/find_type_by_chunk_range(datum/target_ref, atom/center_loc, chunk_range = 0)
	. = list()

	var/list/target_chunk_keys = get_list_of_chunk_keys(center_loc, chunk_range)
	for(var/chunk_key_str in target_chunk_keys)
		if(length(chunk_keys[chunk_key_str][target_ref.type]))
			. |= chunk_keys[chunk_key_str][target_ref.type]

/*
	Gives you a list of chunk keys so you can do your business in my chunk_keys alist
*/
/datum/chunkin_mk_three/proc/get_list_of_chunk_keys(atom/center_loc, chunk_range)
	. = list()

	var/origin_chunk_x = TURF_COORD_2_CHUNK_NUM(center_loc.x)
	var/origin_chunk_y = TURF_COORD_2_CHUNK_NUM(center_loc.y)

	// no chunk range so they just want the one we in
	if(chunk_range == 0)
		. += CHUNK_KEY_STR(origin_chunk_x, origin_chunk_y, center_loc.z)
		return

	for(var/extension_x in -chunk_range to chunk_range)
		var/target_chunk_x = origin_chunk_x + extension_x
		for(var/extension_y in -chunk_range to chunk_range)
			var/target_chunk_key = CHUNK_KEY_STR(target_chunk_x, (origin_chunk_y + extension_y), center_loc.z)
			if(chunk_keys?[target_chunk_key])
				. += target_chunk_key



/*
	Is the chunk different between these two turfs? Yes, No? Well lets find out with this proc
*/
/datum/chunkin_mk_three/proc/is_different_chunk_by_turf(atom/turf_one, atom/turf_two)
	if(CHUNK_KEY_STR(TURF_COORD_2_CHUNK_NUM(turf_one.x), TURF_COORD_2_CHUNK_NUM(turf_one.y), turf_one.z) != CHUNK_KEY_STR(TURF_COORD_2_CHUNK_NUM(turf_two.x), TURF_COORD_2_CHUNK_NUM(turf_two.y), turf_two.z))
		return TRUE
	return FALSE


/*
	Jus go ahead and make all the base lists
	why not
*/
/datum/chunkin_mk_three/proc/prep_map_chunklists()
	var/total_x_iterations = floor(world.maxx / chunk_size)
	var/total_y_iterations = floor(world.maxy / chunk_size)
	var/target_z = 1 // We only got one hardcoded map right now and no data attached to it, so this changes later along with where we get the maxx and maxy

	for(var/chunk_x in 0 to total_x_iterations)
		for(var/chunk_y in 0 to total_y_iterations)
			var/target_chunk_key = CHUNK_KEY_STR(chunk_x, chunk_y, target_z)
			chunk_keys[target_chunk_key] = list()
			for(var/type_path in premake_these_type_lists)
				chunk_keys[target_chunk_key][type_path] = list()


// this is actually a debugging proc
/datum/chunkin_mk_three/proc/check_all_chunks_for_ref()
	for(var/chunk_key in chunk_keys)
		if(islist(chunk_keys[chunk_key]))
			for(var/type_key in chunk_keys[chunk_key])
				if(length(chunk_keys[chunk_key][type_key]))
					for(var/datum/thing in chunk_keys[chunk_key][type_key])
						world_msg("[thing.type] - [ref(thing)]")

/*
	For debugging purposes, just paints in the chunks so you can see their boundaries
*/
/datum/chunkin_mk_three/proc/paint_chunks(target_z = 1, target_chunk_x, target_chunk_y, color, target_text, duration = 2 SECONDS)
	set waitfor = 0

	var/x1 = target_chunk_x * chunk_size
	var/y1 = target_chunk_y * chunk_size
	
	var/x2 = x1 - chunk_size
	var/y2 = y1 - chunk_size

	paint_turfs(x2, y2, target_z, x1, y1, target_z, color, target_text, duration)

#undef TURF_COORD_2_CHUNK_NUM
#undef CHUNK_KEY_STR


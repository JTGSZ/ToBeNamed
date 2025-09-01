


//Just changes the colors of a block of turfs
/proc/paint_turfs(LLeftX, LLeftY, LLeftZ, TRightX, TRightY, TRightZ, target_color = rgb(238, 44, 10), target_text, color_duration = 5 SECONDS)
	set waitfor = 0
	var/list/turfs = list()
	for(var/turf/T in block(locate(max(1, LLeftX), max(1, LLeftY), max(1, LLeftZ)), locate(min(world.maxx, TRightX), min(world.maxy, TRightY), min(world.maxz, TRightZ))))
		T.color = target_color
		turfs += T
		plant_maptext(target_text, T)

	sleep(color_duration)
	
	for(var/turf/T in turfs)
		T.color = null

// Sticks maptext onto something
/proc/plant_maptext(text, atom/target_for_text)
	target_for_text.maptext = text
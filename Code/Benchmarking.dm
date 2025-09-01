/*
	You put the code between the start and end and you get a benchmark time related to it wow!
*/
/mob/verb/benchmark()
	set category = "DEV-Debug"

	var start = world.timeofday

	// Code goes here

	var end = world.timeofday

	var result = end - start
	world_msg("Time Result: [result]")
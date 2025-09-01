/* 
	Eh...
*/

// If tick usage is currently over, it will hopefully either give you a true or false
// CURRENT_SS_TICK_LIMIT is a changing value that dictates when we stop our work on each slave system, or even go to the next tick
#define WSSLAVE_ALLOCATION_CHECK ( world.tick_usage > CURRENT_SS_TICK_LIMIT )

// How much of the tick the world is going to attempt to get whether anyone likes it or not.
#define WORLD_RESERVED_TICK_USAGE 3 // that would be three percent saar

// A macro in all caps to make the highlighter look cool
#define WORLD_TICK_USAGE 	world.tick_usage


/*
	The order in which we are initialized
*/
#define SS_INIT_ATOM_INITIALIZER 	1
#define SS_INIT_GENERIC_PROCESS  	2
#define SS_INIT_DELETION_HANDLER	3
#define SS_INIT_TIMER_CALLBACKS 	4
#define SS_INIT_UNDEFINED 			42069 //heh...


/*
	The order in which we are given resource priority
*/
#define SS_PRIORITY_TIMER_CALLBACKS 	1
#define SS_PRIORITY_GENERIC_PROCESS  	2
#define SS_PRIORITY_DELETION_HANDLER	3
#define SS_PRIORITY_ATOM_INITIALIZER 	4
#define SS_PRIORITY_UNDEFINED 			64209 //heh...


/*
	The order in which we are displayed whenever I get around to it
*/
#define SS_DISPLAY_ATOM_INITIALIZER 	1
#define SS_DISPLAY_TIMER_CALLBACKS 		2
#define SS_DISPLAY_GENERIC_PROCESS 		3
#define SS_DISPLAY_DELETION_HANDLER		4
#define SS_DISPLAY_UNDEFINED 			46920 //heh...
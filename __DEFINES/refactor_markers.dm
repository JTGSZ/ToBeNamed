/*
	Basically these are definition placeholders for anything thats gonna see a big refactor down the road
	You'll be able to just search and get all of it at once.
*/

//#define world_msg(msg) world << "[msg]"
#define src_msg(msg) ez_output(src, "[msg]")
#define usr_msg(msg) ez_output(usr, "[msg]")
#define dd_msg(msg) world.log << "[msg]"
#define TODO(msg) ez_output(world, "TODO: [msg]")

//A dumb macro to just iterate a list and put the contents in a world msg
#define list_debug_msg(target_list) \
	var/index = 0; \
	for(var/i in target_list) { \
		index++; \
		ez_output(world, "Index: [index], Value:[i]") \
	};

// Here is the assc list variant of it
#define assc_list_debug_msg(target_list) \
	var/index = 0; \
	for(var/i in target_list) { \
		index++; \
		ez_output(world, "Index: [index], Key: [i], Value: [target_list[i]]")\
	}; \

// Incase you just want all the information spit out from the single proc you are messing with
#define CALLEE_DEBUG_MSG \
	ez_output(world, "<b>---------<big>]ORIGIN CALLEE\[</big>---------</b>"); \
	ez_output(world, "<b>PROC:</b> [callee.proc.type], <b>SRC:</b> [callee.src], <b>USR:</b> [callee.usr]"); \
	ez_output(world, "<b>FILE:</b> [callee.file], <b>LINE:</b> [callee.line]"); \
	ez_output(world, "<b>ARGUMENTS:</b> [jointext(callee.args, ", ")]"); \

// dumb var to help you sort through a giant mass of these
var/global/callstack_debug_case = 0
// A entire caller stack of debug info
#define CALLSTACK_DEBUG_MSG \
	var/list/caller_stack = list(); \
	caller_stack.Add(callee); \
	var/callee/next_caller = caller; \
	while(!isnull(next_caller)){ \
		caller_stack.Add(next_caller); \
		next_caller = next_caller.caller; \
	}; \
	var/order_of_calls = 0; \
	for(var/i = length(caller_stack), i > 0, i--) { \
		next_caller = caller_stack[i]; \
		if(i == length(caller_stack)){ \
			ez_output(world, "<b>---------<big>]PROC CHAIN STACK CASE [callstack_debug_case] START\[</big>---------</b>"); \
		}else if(i == 1){ \
			ez_output(world, "<b>---------<big>]PROC CHAIN END\[</big>---------</b>"); \
		}else{ \
			ez_output(world, "<b>---------<big>]PROC CHAIN#[order_of_calls]\[</big>---------</b>"); \
		}; \
		ez_output(world, "<b>PROC:</b> [next_caller.proc.type], "); \
		ez_output(world, "<b>SRC:</b> [next_caller.src], <b>USR:</b> [next_caller.usr]"); \
		ez_output(world, "<b>FILE:</b> [next_caller.file], <b>LINE:</b> [next_caller.line]"); \
		ez_output(world, "<b>ARGUMENTS:</b> [jointext(next_caller.args, ", ")]"); \
		order_of_calls++; \
	}; \
	callstack_debug_case++; \


// Im tired of rewriting the same proc debug messages
#define PARAM_DEBUG_MSG \
	var/position = 1; \
	for(var/shits in args) { \
		ez_output(world, "PARAM POS: [position] - [shits]"); \
		position++; \
	}; \
	
// readout all the vars of some random crap
#define VARS_READOUT_MSG(live_target) \
	for(var/varkey in live_target.vars) { \
		world_msg("[varkey] = [live_target[varkey]]"); \
	}; \

// world message for the world
#define world_msg(msg) ez_output(world, msg)

// This basically will log a custom error into the runtime viewer too
#define ERROR_MSG(msg) world.Error(EXCEPTION("ERROR: [msg]"))

// Just sends a message to all admins
#define admin_msg(msg) \
	for(var/cur_ckey in GLOB.admin_datums) { \
		var/datum/admin_data/amsg_target = GLOB.admin_datums[cur_ckey]; \
		if(amsg_target.linked_client) { \
			ez_output(amsg_target.linked_client, msg) \
		}; \
	};



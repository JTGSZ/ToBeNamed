/*
	dumb strings tied to macros for hook signatures.
	See: _CALLHOOKS.dm
*/
/*
	Some dumb macros for highlighting purposes
*/
#define REGISTER_CALLHOOK(HOOK_SIG_ID, proc_call_target, proc_ref) register_hook_sig(HOOK_SIG_ID, proc_call_target, proc_ref)
#define UNREGISTER_CALLHOOK(HOOK_SIG_ID, proc_call_target, proc_ref) unregister_hook_sig(HOOK_SIG_ID, proc_call_target, proc_ref)

#define RAW_INVOKE_CALLHOOKS(HOOK_SIG_ID, arguments...) invoke_hook_sig(HOOK_SIG_ID, ##arguments)

#define CHECK_CALLHOOKS(HOOK_SIG_ID, proc_call_target, proc_ref) has_callhook(HOOK_SIG_ID, proc_call_target, proc_ref)
#define CHECK_PROC_CALL_TARGET(HOOK_SIG_ID, CHECK_TARGET) proc_callhooks?[HOOK_SIG_ID]?["[ref(CHECK_TARGET)]"]
#define CHECK_HOOKSIG(HOOK_SIG_ID, CHECK_TARGET) length(CHECK_TARGET.proc_callhooks?[HOOK_SIG_ID])

// a macro for both the hooksig check and invoke, you save on a pretty notable amount of cpu usage with this
#define INVOKE_CALLHOOKS(HOOK_SIG_ID, CALLER_CONTAINER, arguments...) \
if(CHECK_HOOKSIG(HOOK_SIG_ID, CALLER_CONTAINER)) { \
	CALLER_CONTAINER.RAW_INVOKE_CALLHOOKS(HOOK_SIG_ID, ##arguments) \
};

/*
	String keys that are hopefully invoked in the spot related to how you named them
	You get whatever params are in the normal proc crammed in whether you care about them or not

	Also you can copy and paste the param set into the proc hooked in conveniently as its what is given
*/

/*
	ATOM MOVABLE LEVEL
*/
//Called in /atom/movable/Move - Default returned Params(HOOK_SIG_ID, atom/movable/INVOKER_REF, NewLoc, Dir, step_x, step_y)
#define HOOKSIG_ATOM_MOVABLE_ON_MOVE	"AM_ON_MOVE"

//Called in /atom/movable/Destroy - Default returned Params(HOOK_SIG_ID, datum/INVOKER_REF)
#define HOOKSIG_ATOM_MOVABLE_ON_DESTROY	"AM_ON_DESTROY"

// Called in /atom/movable/proc/force_into_contents - Default returned Params(HOOK_SIG_ID, atom/movable/INVOKER_REF, atom/old_loc, atom/new_loc)
#define HOOKSIG_ATOM_MOVABLE_FORCED_INTO_CONTENTS	"AM_FORCED_INTO_CONTENTS"
#define HOOKSIG_ATOM_MOVABLE_CONTENTS_FORCED_INTO	"AM_CONTENTS_FORCED_INTO"

//Called in /turf/Entered - Default returned Params (HOOK_SIG_ID, atom/INVOKER_REF, atom/OldLoc, turf/new_turf)
// WARNING: Because this is on pixel movement you can have 4 turfs entered at once
#define HOOKSIG_ATOM_MOVABLE_NEW_TURF_ENTERED	"AM_NEW_TURF_ENTERED"

//Called in /atom/movable/Move, /atom/movable/proc/forceMove - Default returned Params(HOOK_SIG_ID, atom/movable/INVOKER_REF, atom/Last_loc, atom/Current_loc)
// Shitty optimization measure incase you don't want something called every single pixel movement
#define HOOKSIG_ATOM_MOVABLE_NEW_COORD_ENTERED	"AM_NEW_COORD_ENTERED"


/*
	TURF LEVEL
*/
//Called in /turf/Entered - Default returned Params (HOOK_SIG_ID, atom/INVOKER_REF, atom/movable/Obj, atom/OldLoc)
// WARNING: Because this is on pixel movement you can have 4 turfs entered at once
#define HOOKSIG_TURF_ENTERED	"TURF_ENTERED"
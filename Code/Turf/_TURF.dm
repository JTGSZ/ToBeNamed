/*
	TURF PARENT
*/
/turf


/turf/Entered(atom/movable/Obj, atom/OldLoc)
	INVOKE_CALLHOOKS(HOOKSIG_TURF_ENTERED, src, Obj, OldLoc)
	INVOKE_CALLHOOKS(HOOKSIG_ATOM_MOVABLE_NEW_TURF_ENTERED, Obj, OldLoc, src)

	..()

/turf/floor
	icon = 'zAssets/Turf/desertsand.dmi'
	icon_state = "sand1"

/turf/floor/New()
	..()

/turf/floor/Initialize()
	..()
	if(prob(5))
		icon_state = "sand[rand(2,4)]"
	else
		icon_state = "sand1"



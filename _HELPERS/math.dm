/**
 * Get Distance, Squared
 *
 * Because sqrt is slow, this returns the distance squared, which skips the sqrt step.
 *
 * Use to compare distances. Used in component mobs.
 */
/proc/get_dist_squared(var/atom/a, var/atom/b)
	return ((b.x-a.x)**2) + ((b.y-a.y)**2)

// Returns true if val is from min to max, inclusive.
/proc/IsInRange(val, min, max)
	return min <= val && val <= max
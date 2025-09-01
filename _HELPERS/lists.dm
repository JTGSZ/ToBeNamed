// This was ported from /tg/ with permission from Remmie, the author of this code.
/**
 * Like typesof() or subtypesof(), but returns a typecache instead of a list.
 *
 * Arguments:
 * - path: A typepath or list of typepaths.
 * - only_root_path: Whether the typecache should be specifically of the passed types.
 * - ignore_root_path: Whether to ignore the root path when caching subtypes.
 */
/proc/typecacheof(path, only_root_path = FALSE, ignore_root_path = FALSE)
	if(isnull(path))
		return

	if(ispath(path))
		. = list()
		if(only_root_path)
			.[path] = TRUE
			return

		for(var/subtype in (ignore_root_path ? child_typesof(path) : typesof(path)))
			.[subtype] = TRUE
		return

	if(!islist(path))
		CRASH("Tried to create a typecache of [path] which is neither a typepath nor a list.")

	. = list()
	var/list/pathlist = path
	if(only_root_path)
		for(var/current_path in pathlist)
			.[current_path] = TRUE
	else if(ignore_root_path)
		for(var/current_path in pathlist)
			for(var/subtype in child_typesof(current_path))
				.[subtype] = TRUE
	else
		for(var/current_path in pathlist)
			for(var/subpath in typesof(current_path))
				.[subpath] = TRUE

/// Checks for specific types in specifically structured (Assoc "type" = TRUE|FALSE) lists ('typecaches')
#define is_type_in_typecache(A, L) (A && length(L) && L[(ispath(A) ? A : A:type)])

/// Rurns a new list with only atoms that are in the typecache list
/proc/typecache_filter_list(list/atoms, list/typecache)

	. = list()
	for(var/atom/atom_checked as anything in atoms)
		if (typecache[atom_checked.type])
			. += atom_checked

/// Return a new list with atoms that are not in the typecache list
/proc/typecache_filter_list_reverse(list/atoms, list/typecache)

	. = list()
	for(var/atom/atom_checked as anything in atoms)
		if(!typecache[atom_checked.type])
			. += atom_checked

/// Similar to typecache_filter_list and typecache_filter_list_reverse but it supports an inclusion list and and exclusion list
/proc/typecache_filter_multi_list_exclusion(list/atoms, list/typecache_include, list/typecache_exclude)
	. = list()
	for(var/atom/atom_checked as anything in atoms)
		if(typecache_include[atom_checked.type] && !typecache_exclude[atom_checked.type])
			. += atom_checked






//any value in a list
/proc/sortList(var/list/L, cmp=/proc/cmp_text_asc)
	return sortTim(L.Copy(), cmp)

//Move a single element from position fromIndex within a list, to position toIndex
//All elements in the range [1,toIndex) before the move will be before the pivot afterwards
//All elements in the range [toIndex, L.len+1) before the move will be after the pivot afterwards
//In other words, it's as if the range [fromIndex,toIndex) have been rotated using a <<< operation common to other languages.
//fromIndex and toIndex must be in the range [1,L.len+1]
//This will preserve associations ~Carnie
/proc/moveElement(list/L, fromIndex, toIndex)
	if(fromIndex == toIndex || fromIndex+1 == toIndex)	//no need to move
		return
	if(fromIndex > toIndex)
		++fromIndex	//since a null will be inserted before fromIndex, the index needs to be nudged right by one

	L.Insert(toIndex, null)
	L.Swap(fromIndex, toIndex)
	L.Cut(fromIndex, fromIndex+1)


//Move elements [fromIndex,fromIndex+len) to [toIndex-len, toIndex)
//Same as moveElement but for ranges of elements
//This will preserve associations ~Carnie
/proc/moveRange(list/L, fromIndex, toIndex, len=1)
	var/distance = abs(toIndex - fromIndex)
	if(len >= distance)	//there are more elements to be moved than the distance to be moved. Therefore the same result can be achieved (with fewer operations) by moving elements between where we are and where we are going. The result being, our range we are moving is shifted left or right by dist elements
		if(fromIndex <= toIndex)
			return	//no need to move
		fromIndex += len	//we want to shift left instead of right

		for(var/i=0, i<distance, ++i)
			L.Insert(fromIndex, null)
			L.Swap(fromIndex, toIndex)
			L.Cut(toIndex, toIndex+1)
	else
		if(fromIndex > toIndex)
			fromIndex += len

		for(var/i=0, i<len, ++i)
			L.Insert(toIndex, null)
			L.Swap(fromIndex, toIndex)
			L.Cut(fromIndex, fromIndex+1)

//replaces reverseList ~Carnie
/proc/reverseRange(list/L, start=1, end=0)
	if(L.len)
		start = start % L.len
		end = end % (L.len+1)
		if(start <= 0)
			start += L.len
		if(end <= 0)
			end += L.len + 1

		--end
		while(start < end)
			L.Swap(start++,end--)

	return L


//creates every subtype of prototype (excluding prototype) and adds it to list L.
//if no list/L is provided, one is created.
/proc/init_subtypes(prototype, list/L)
	if(!istype(L))
		L = list()
	for(var/path in child_typesof(prototype))
		L += new path()
	return L
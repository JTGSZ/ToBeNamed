
/*
	I don't fucking know? was it really this easy?
	One must remember, a macro just runs precompilation and replaces things with the contents

	So GLOB_VAR(testcase) would define as so /datum/controller/global_holder/var/global/testcase
	the VALUE can be set via GLOB_VAR(testcase) = FALSE
	and then access would be GLOB.testcase
*/
#define GLOB_VAR(varname) /datum/fancy_stats/global_holder/var/global/##varname

#define GLOB_LIST(listname) /datum/fancy_stats/global_holder/var/global/list/##listname

#define GLOB_ALIST(listname) /datum/fancy_stats/global_holder/var/global/alist/##listname


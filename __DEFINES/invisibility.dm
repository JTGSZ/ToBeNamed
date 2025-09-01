/*


	Basically we have something called invisibility in byond which decides whether you can see/interact with something or not.
	VAR - invisibility - Goes to a grand total of 101 where at 101 the player can't see/interact with something completely. This is a atom var
	VAR - see_invisible - how much invisibility we can see this is a mob var


*/
// this is the minimum we can go
#define INVISIBILITY_MINIMUM 0

// this is the invisibility of our bodies
#define INVISIBILITY_BODYSPACE 30

// this is the invisibility of our souls
#define INVISIBILITY_SOULSPACE 80

// this is the maximum we can go before special value
#define INVISIBILITY_MAXIMUM 99

// I would say to set everything to 101, but perhaps we need to debug everything
#define INVISIBILITY_DEBUGGING_REALITY 100

// this means you never see something as its a core part of something
#define INVISIBILITY_SPIRITSPACE 101
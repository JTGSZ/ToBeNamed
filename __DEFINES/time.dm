#define SECONDS * 10
#define MINUTES * 600
#define HOURS   * 36000

#define WORLD_TIMESTAMP time2text(world.timeofday, "hh:mm:ss")

// The three dots makes it do funny things with the params and amounts of them
#define ADD_REALTIMER(target_ref, proc_ref, delay_time, arguments...) SSTimerCallbacks.Add_Timer(target_ref, proc_ref, delay_time, ##arguments);


// lol
var/list/admin_verbs_admin = list(
)

var/list/superadmin_verbs = list(
    /client/proc/admin_rights_panel,

)

var/list/admin_verbs_debug = list(
    /client/proc/View_Runtimes,
    /client/proc/View_Variable,
    /client/proc/toggle_debugvision
)

/datum/admin_data/proc/add_admin_verbs_to_client()
    if(!linked_client)
        return

    for(var/admin_rights_str in admin_rights)
        switch(admin_rights_str)
            if(ADMIN_RIGHTS_ADMIN)
                linked_client.verbs += admin_verbs_admin
            if(ADMIN_RIGHTS_DEBUG)
                linked_client.verbs += admin_verbs_debug
            if(ADMIN_RIGHTS_SUPER)
                linked_client.verbs += superadmin_verbs

/datum/admin_data/proc/remove_admin_verbs_from_client()
    if(!linked_client)
        return

    linked_client.verbs.Remove(
        admin_verbs_admin,
        admin_verbs_debug,
        superadmin_verbs
    )

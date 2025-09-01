/datum/passive/proc/is_persistent()
    if(!fexists("[CONFIG_PERSIST_PASSIVEDATA_FOLDER][name].json"))
        version = 1
        save_to_persistence()
/datum/passive/proc/save_to_persistence()
    if(!UUID)
        UUID = generate_uuid(src)
    var/list/data_to_save = list("name" = name, "options" = options, "tags" = tags, "extra_tags" = extra_tags, "UUID" = UUID, "version" = version)
    var/save_path = "[CONFIG_PERSIST_PASSIVEDATA_FOLDER]"
    save_list_to_jsonfile("[save_path][name].json", data_to_save)

/datum/passive/proc/save_to_char(path, mob/humanoid/m)
    var/list/data_to_save = list("name" = name, "options" = options, "tags" = tags, "extra_tags" = extra_tags, "UUID" = UUID, "version" = version)
    // "[CONFIG_PERSIST_MOBDATA_FOLDER][p.ckey]/Components"
    save_list_to_jsonfile("[path]/Passives/[name].json", data_to_save)


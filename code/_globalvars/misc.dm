GLOBAL_VAR_INIT(internal_tick_usage, 0.2 * world.tick_lag)

/// Global performance feature toggle flags
GLOBAL_VAR_INIT(perf_flags, NO_FLAGS)

GLOBAL_LIST_INIT(bitflags, list((1<<0), (1<<1), (1<<2), (1<<3), (1<<4), (1<<5), (1<<6), (1<<7), (1<<8), (1<<9), (1<<10), (1<<11), (1<<12), (1<<13), (1<<14), (1<<15), (1<<16), (1<<17), (1<<18), (1<<19), (1<<20), (1<<21), (1<<22), (1<<23)))

GLOBAL_VAR_INIT(master_mode, "Distress Signal: Lowpop")

GLOBAL_VAR_INIT(timezoneOffset, 0)

GLOBAL_LIST_INIT(pill_icon_mappings, map_pill_icons())

/// In-round override to default OOC color
GLOBAL_VAR(ooc_color_override)

/// List of roles that can be setup for each gamemode
GLOBAL_LIST_INIT(gamemode_roles, list())

GLOBAL_VAR_INIT(minimum_exterior_lighting_alpha, 255)

GLOBAL_DATUM_INIT(item_to_box_mapping, /datum/item_to_box_mapping, init_item_to_box_mapping())

/// Offset for the Operation time
GLOBAL_VAR_INIT(time_offset, setup_offset())

/// Sets the offset 2 lines above.
/proc/setup_offset()
	return rand(10 MINUTES, 24 HOURS)

/// The last count of possible candidates in the xeno larva queue (updated via get_alien_candidates)
GLOBAL_VAR(xeno_queue_candidate_count)

//Coordinate obsfucator
//Used by the rangefinders and linked systems to prevent coords collection/prefiring
/// A number between -500 and 500.
GLOBAL_VAR(obfs_x)
/// A number between -500 and 500.
GLOBAL_VAR(obfs_y)

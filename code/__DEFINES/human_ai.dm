#define HUMAN_AI_HEALTHITEMS "health"
#define HUMAN_AI_AMMUNITION "ammo"
#define HUMAN_AI_GRENADES "grenades"

#define AI_ACTION_APPROACH /datum/ongoing_action/approach_target
#define AI_ACTION_APPROACH_C /datum/ongoing_action/approach_target/carefully
#define AI_ACTION_RETREAT /datum/ongoing_action/retreat_from_target
#define AI_ACTION_PICKUP /datum/ongoing_action/item_pickup
#define AI_ACTION_PICKUP_GUN /datum/ongoing_action/item_pickup/pickup_primary
#define AI_ACTION_COVER /datum/ongoing_action/take_cover
#define AI_ACTION_COVER_I /datum/ongoing_action/take_inside_cover
#define AI_ACTION_TROWBACK /datum/ongoing_action/throw_back_nade

/// Action is completed, delete this and move onto the next ongoing action
#define ONGOING_ACTION_COMPLETED "completed"
/// Action isn't finished, move onto the next ongoing action
#define ONGOING_ACTION_UNFINISHED "unfinished"
/// Action isn't finished, block any further actions from the AI this tick
#define ONGOING_ACTION_UNFINISHED_BLOCK "unfinished_block"

#define ADD_ONGOING_ACTION(brain, path, arguments...) brain:_add_ongoing_action(path, ##arguments)

#define HUMAN_AI_MAX_PATHFINDING_RANGE 45

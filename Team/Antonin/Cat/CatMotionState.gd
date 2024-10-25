class_name CatMotionState extends State

const IDLE 		= "Idle"
const RUNNING 	= "Running"
const JUMPING 	= "Jumping"
const SLIDING 	= "Sliding"
const FALLING 	= "Falling"
const HIT 		= "Hit"

var player_cat: Cat


func _ready() -> void:
	await owner.ready
	player_cat = owner as Cat
	assert(player_cat != null, "The CatMotionState state type must be used only in the Cat scene. It needs the owner to be a Cat node.")

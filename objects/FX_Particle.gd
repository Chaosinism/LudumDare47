extends CPUParticles2D


var timer=60


# Called when the node enters the scene tree for the first time.
func _ready():
    emitting=true

func _process(delta):
    timer-=1
    if timer<1:
        queue_free()

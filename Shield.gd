extends AnimatedSprite


var timer=0

func _ready():
    play('default')

func _process(delta):
    if timer>0:
        timer-=1
    if timer<1:
        visible=false

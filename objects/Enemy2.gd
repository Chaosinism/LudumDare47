extends AnimatedSprite
onready var Particle = preload("res://objects/FX_Particle.tscn")


var state=0
var timer=120
var velocity=Vector2(0,0)
var hp=1

func _ready():
    play('default')

func _process(delta):
    timer-=1
    if timer<1:
        if state==0:
            state=1
            attack()
            timer=40
        elif state==1:
            state=0
            timer=120
        elif state==9:
            state=0
            modulate=Color(1,1,1,1)
            playing=true
      
    if state==1:
          position+=velocity
        
func attack():
    var dst=get_parent().get_node('MC').position
    if dst.x>position.x:
        velocity.x=6
    else:
        velocity.x=-6

func frozen():
    state=9
    modulate=Color(0,0,1,1)
    timer=420
    hp=1
    playing=false

func _on_Area2D_area_entered(area):
    hp-=1
    modulate=Color(100,0,0,1)
    if hp==0:
        die()

func die():
    get_parent().enemy_killed()
    var particle=Particle.instance()
    get_parent().add_child(particle)
    particle.position=position
    particle.color=Color(1,0,0,1)
    queue_free()

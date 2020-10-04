extends AnimatedSprite
onready var Particle = preload("res://objects/FX_Particle.tscn")
onready var EBullet = preload("res://objects/EBullet2.tscn")

var state=0
var timer=180
var velocity=Vector2(0,0)
var hp=1

func _ready():
    play('default')
    $Warning.play('default')

func _process(delta):
    timer-=1
    if timer<1:
        if state==0:
            state=1
            attack()
            $Warning.visible=false
            timer=60
        elif state==1:
            state=0
            timer=180
            var dst=get_parent().get_node('MC').position
            if dst.x>position.x:
                scale.x=1
            else:
                scale.x=-1
            $Warning.visible=true
        elif state==9:
            state=0
            modulate=Color(1,1,1,1)
            playing=true
      
    if state==1:
          position+=velocity
        
func attack():

    var bullet=EBullet.instance()
    get_parent().add_child(bullet)
    bullet.position=position     
    bullet.velocity=Vector2(scale.x*8,-16)   
    
    if position.x>960-240:
        scale.x=-1
        velocity.x=-4
    elif position.x<0+240:
        scale.x=1
        velocity.x=4
    else:
        if randf()<0.5:
            scale.x=1
            velocity.x=4
        else:
            scale.x=-1
            velocity.x=-4

func frozen():
    state=9
    modulate=Color(0,0,1,1)
    timer=420
    hp=1
    playing=false
    $Warning.visible=false

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

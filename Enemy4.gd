extends AnimatedSprite
onready var Particle = preload("res://objects/FX_Particle.tscn")
onready var EBullet = preload("res://objects/EBullet3.tscn")

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
            timer=120
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
    var temp=Vector2(2,0)
    for i in range(8):
        var bullet=EBullet.instance()
        get_parent().add_child(bullet)
        bullet.position=position     
        bullet.velocity=temp   
        temp=temp.rotated(PI/4)
    
    
    var dst= Vector2( rand_range(30,930), rand_range(30,450) )
    velocity= (dst-position)/120
    rotation=velocity.angle()+PI/2

func frozen():
    state=9
    modulate=Color(0,0,1,1)
    timer=420
    playing=false

func _on_Area2D_area_entered(area):
    hp-=1
    modulate=Color(100,0,0,1)
    if hp==0:
        die()
    hp=1

func die():
    get_parent().enemy_killed()
    var particle=Particle.instance()
    get_parent().add_child(particle)
    particle.position=position
    particle.color=Color(1,0,0,1)
    queue_free()

extends AnimatedSprite
onready var Particle = preload("res://objects/FX_Particle.tscn")
onready var EBullet = preload("res://objects/EBullet.tscn")

var state=0
var timer=180
var velocity=Vector2(0,0)
var hp=1
var bullet_velocity=null

func _ready():
    play('default')
    $Warning.play('default')

func _process(delta):
    timer-=1
    if timer<1:
        if state==0:
            state=1
            attack()
            timer=60
            $Warning.visible=false
        elif state==1:
            state=0
            timer=180
            var dst=get_parent().get_node('MC').position
            var vec=dst-global_position
            bullet_velocity=vec.normalized()*5
            $Warning.rotation=vec.angle()
            $Warning.visible=true
        elif state==9:
            state=0
            modulate=Color(1,1,1,1)
            playing=true
            

      
    if state==1:
          position+=velocity
        
func attack():
    if bullet_velocity!=null:
        var bullet=EBullet.instance()
        get_parent().add_child(bullet)
        bullet.position=position     
        bullet.velocity=bullet_velocity   
        bullet.rotation=bullet_velocity.angle()  
    
    if position.x>960-240:
        velocity.x=-4
    elif position.x<0+240:
        velocity.x=4
    else:
        if randf()<0.5:
            velocity.x=4
        else:
            velocity.x=-4

func frozen():
    state=9
    modulate=Color(0,0,1,1)
    timer=420
    hp=1
    $Warning.visible=false
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

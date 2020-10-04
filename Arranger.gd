extends Node2D
onready var Card = preload("res://objects/Card.tscn")

var card_list=[]

func _ready():
    background()
    #initialize([1,2,3,4,5,6,7,8,9,7])
    
func initialize(cards,lv):
    var ratio=min( 7.5/len(cards), 0.75)
    for i in range(len(cards)):
        var card=Card.instance()
        add_child(card)
        card.assign(cards[i])
        card.scale=Vector2(ratio,ratio)
        card.pos=i
        card.listener=self
        card.position.x=$Spawn.position.x+95*i*ratio+5*i
        card.position.y=$Spawn.position.y
        card.get_node("Description").rect_scale=Vector2(1/ratio,1/ratio)
        card_list.append(card)
        $Level.text='LEVEL '+str(lv)+' / 5'
    
    
func background():
    var viewport = get_node("Viewport")
    var sprite = get_node("Sprite")
    var viewport_sprite = get_node("Viewport_Sprite")

    # Assign the sprite's texture to the viewport texture
    viewport.set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)
    # Let two frames pass to make sure the screen was captured
    yield(get_tree(), "idle_frame")
    yield(get_tree(), "idle_frame")
    viewport_sprite.texture = viewport.get_texture()

var state=-1
func card_clicked(card):
    get_parent().get_node("SE_Shoot").playing=true
    if state==-1:
        state=card.pos
        card.get_node("Frame").visible=true
    else:
        card_list[state].get_node("Frame").visible=false
        var temp=card_list[state].id
        card_list[state].assign( card.id )
        card.assign(temp)
        state=-1
        

func _on_Button_pressed():
    var card_id_list=[]
    for card in card_list:
        card_id_list.append(card.id)
    queue_free()
    get_parent().arranged(card_id_list)

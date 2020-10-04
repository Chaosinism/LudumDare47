extends Node2D

var initial_card_list=[1,2,1,3,1,2,8,3,1,4]


func _on_Button_pressed():
    get_parent().card_list=[]
    for i in initial_card_list:
        get_parent().card_list.append(i)
    queue_free()
    get_parent().game_started()


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
    
func _ready():
    background()

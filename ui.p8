pico-8 cartridge // http://www.pico-8.com
version 39
__lua__

function title_ui()
    sspr(0,32,128,40,0,20)
    print("2023-09-30",4,4,6)
    print("v:0.1 ", 106, 4, 6)
    print("by cody mcpheron",6,64,9)
    print("created for:",8,94,6)
    print("the cre8 pico-8 game jam",6,104,6)
    print("press z/🅾️ to start!",28,118,7)

    spr(7,78,72)
    spr(8,78,80)
    spr(9,70,80)
    spr(9,86,80,1,1,true)
    spr(10,78,88)
    spr(11,86,67)
    rectfill(90,64,122,78,7)
    pset(90,64,5)
    pset(122,64,5)
    pset(90,78,5)
    pset(122,78,5)
    print("hi! i'm",93,66,9)
    print("sCRA-p!",94,72,9)
end

function combat_ui()
    combat_manager:display()
    player:hp_bar()
    opponent:hp_bar()
    print("sCRA-p", 9, 3, 7)
    print("enemy", 100, 3, 7)
    display_elog(3,22,124,62)
    if player.current_hp <= 0 then
        rectfill(0,0,128,128,6)
        print("congrats, you died!",4,24,0)
        print("if this game were completed",4,44,0)
        print("this is when you'd start over",4,54,0)
        print("the game is not done though-",4,84,0)
        print("refresh the page to try again!",4,94,0)
    end
    if opponent.current_hp <= 0 then
        rectfill(0,0,128,128,6)
        print("congrats, you won!",4,24,0)
        print("if this game were completed",4,44,0)
        print("you would absorb a part",4,54,0)
        print("from your fallen opponent.",4,64,0)
        print("the game is not done though-",4,84,0)
        print("so you can't. sorry. =(",4,94,0)
    end
end
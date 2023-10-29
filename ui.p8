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
    --static
    print("attack",8,8,6)
    print("skills",8,16,6)
    
    --dynamic
    spr(0,0,cm.sel_index*8)
    print("player tc: " .. cm.pl.tc, 8, 24, 6)
    print("enemy  tc: " .. cm.en.tc, 8, 30, 6)
    print("player hp: " .. cm.pl.current_hp, 8, 36, 6)
    print("enemy  hp: " .. cm.en.current_hp, 8, 42, 6)
end
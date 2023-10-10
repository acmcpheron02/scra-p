pico-8 cartridge // http://www.pico-8.com
version 39
__lua__

function combat.state_draw()
    combat_manager:display()
    player:hp_bar()
    print("player", 6, 3, 7)
    display_elog(3,20,124,60)
end
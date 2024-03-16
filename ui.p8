pico-8 cartridge // http://www.pico-8.com
version 39
__lua__

plt = {}

 plt[0] = 0 --black
 plt[1] = 15   --ring_primary 
 plt[2] = -11   --ring_shadow
 plt[3] = 7  --white
 plt[4] = 8     --player_primary
 plt[5] = 9    --player_secondary
 plt[6] = 2     --player_shadow
 plt[7] = 142    --player_highlight
 plt[8] = -8     --enemy_primary
 plt[9] = -9    --enemy_secondary
 plt[10] = -2     --enemy_shadow
 plt[11] = -142    --enemy_highlight
 plt[12] = -6
 plt[13] = -13
 plt[14] = -7


for i=1,#plt do
    pal(i,plt[i],1)
end

poke(0x5f2e,1)

function ui_draw()
    --ropes
    line(63,11,0,43,1)
    line(64,11,127,43,1)
    line(63,20,0,52,1)
    line(64,20,127,52,1)
    line(63,29,0,61,1)
    line(64,29,127,61,1)
    
    --divider
    line(64,0,64,44,13)
    line(63,0,63,44,13)
    
    --floor
    for i=0, 90 do
        line(63,38+i,0,70+i,1)
        line(64,38+i,127,70+i,1)
    end

    --divider
    -- line(64,0,64,127,0)
    -- line(63,0,63,127,0)
    
    --hp bars
    cm.player_health()
    cm.enemy_health()
    
    --timer
    rectfill(53,0,74,6,13)
    circfill(64,1,10, 13)
    circfill(63,1,10, 13)
    --print("2", 60, 2, 7)
    --print("0", 65, 2, 7)
    print(cm.get_time1(), 60, 2, 1)
    print(cm.get_time2(), 65, 2, 1)
    
    --shadows
    fillp(0B1010110111110111.1)
    circfill(36,70,18,2)
    circfill(91,70,18,2)
    fillp(0b0000000000000000)

    --battery display
    sspr(32,0,11,20,6,100)
    print(flr(player.current_chrg),8,108,2)
    rectfill(16, 108, 111, 111, 13)
    rectfill(17, 110, 18, 119, 13)
    rectfill(61, 105, 63, 116, 13)
    rectfill(111, 105, 113, 116, 13)
    line(16,118,17,118,12)
    line(17,118,17,109,12)
    line(18,109,112,109,12)
    line(18,110,112,110,12)
    line(62,105,62,116,12)
    line(112,105,112,116,12)
    
    --Move selector (reading order)
    rectfill(22, 96, 66, 104, 13)
    rectfill(72, 96, 116, 104, 13)
    rectfill(22, 115, 66, 123, 13)
    rectfill(72, 115, 116, 123, 13)

    --Highlight selected move
        if cm.selected == 0 then
        rectfill(22, 96, 66, 104, 14)
    elseif cm.selected == 1 then
        rectfill(72, 96, 116, 104, 14)
    elseif cm.selected == 2 then
        rectfill(22, 115, 66, 123, 14)
    elseif cm.selected == 3 then
        rectfill(72, 115, 116, 123, 14)
    end


    print("9",61,98,12)
    print("3",112,98,12)
    print("6",61,117,12)
    print("5",112,117,12)
    print_xcen("uppercut", 42, 98, 15)
    print_xcen("jab", 92, 98, 15)
    print_xcen("sparker", 42, 117, 15)
    print_xcen("rev up", 92, 117, 15)

end


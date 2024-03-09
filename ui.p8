pico-8 cartridge // http://www.pico-8.com
version 39
__lua__

plt = {}

 plt[1] = 15   --ring_primary 
 plt[2] = -11   --ring_shadow
 plt[3] = 8     --player_primary
 plt[4] = 9    --player_secondary
 plt[5] = 2     --player_shadow
 plt[6] = 14    --player_highlight
 plt[7] = 8     --enemy_primary
 plt[8] = 9    --enemy_secondary
 plt[9] = 2     --enemy_shadow
 plt[10] = 14    --enemy_highlight


for i=1,#plt do
    pal(i,plt[i],1)
end

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

    --timer
    circfill(64,1, 10, 13)
    circfill(63,1, 10, 13)
    print("2", 60, 2, 7)
    print("0", 65, 2, 7)

    --hp bars
    rectfill(0,0,53,6,3)
    rectfill(0,0,10,6,2)

    rectfill(127,0,74,6,7)
    rectfill(127,0,100,6,2)

    --shadows
    fillp(0B1010110111110111.1)
    circfill(36,70,18,2)
    circfill(91,70,18,2)
    fillp(0b0000000000000000)

    -- --battery display
    sspr(32,0,11,20,6,100)
    rectfill(16, 108, 111, 111, 13)
    rectfill(17, 108, 18, 119, 13)
    
    rectfill(61, 105, 63, 116, 13)
    rectfill(109, 105, 111, 116, 13)
    
    line(16,118,17,118,12)
    line(17,118,17,109,12)
    line(18,109,110,109,12)
    line(18,110,110,110,12)
    line(62,105,62,116,12)
    line(110,105,110,116,12)
    
    rectfill(22, 96, 66, 104, 2)
    print("uppercut", 26, 98, 7)
    print("9",61,98,12)
    rectfill(72, 96, 114, 104, 8)
    print("   jab   ", 68, 98, 7)
    print("3",109,98,12)

    rectfill(22, 115, 66, 123, 2)
    print("sparker", 26, 117, 7)
    print("6",61,117,12)
    rectfill(72, 115, 114, 123, 2)
    print(" rev up ", 70, 117, 7)
    print("5",109,117,12)

    -- --controls
    -- --rect(0,97,127,127,1)
    -- rectfill(0,96,127,127,0)
    -- --labels
    -- print("chrg", 4, 120, 7)
    -- print("def", 40, 120, 7)
    -- print("atk", 76, 120, 10)
    -- print("spec", 108, 120, 7)
    -- --color indicators
    -- rectfill(4, 102, 20, 113, 11)
    -- rectfill(21, 102, 63, 113, 3)
    -- rectfill(64, 102, 105, 113, 8)
    -- rectfill(106, 102, 123, 113, 9)
    -- spr(0,90,104)
    -- spr(1,90,96)
    -- spr(1,90,112,1,1,false,true)


end


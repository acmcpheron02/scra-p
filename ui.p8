pico-8 cartridge // http://www.pico-8.com
version 39
__lua__

function ui_draw()
    --ropes
    line(64,30,127,-2,13)
    line(64,30,0,-2,13)
    line(64,40,0,8,13)
    line(64,40,127,8,13)
    line(64,50,0,18,13)
    line(64,50,127,18,13)

    --floor
    for i=0, 70 do
        line(64,60+i,0,28+i,13)
        line(64,60+i,127,28+i,13)
    end

    --divider
    line(64,0,64,127,0)
    line(63,0,63,127,0)

    --timer
    circfill(64,1, 10, 5)
    circfill(63,1, 10, 13)
    print("2", 60, 2, 7)
    print("0", 65, 2, 7)

    --hp bars
    rectfill(0,0,53,6,3)
    rectfill(0,0,10,6,0)

    rectfill(127,0,74,6,8)
    rectfill(127,0,100,6,0)

    --shadows
    fillp(0B1010010110100101.1)
    circfill(26,68,15,1)
    circfill(102,68,15,1)
    fillp(0b0000000000000000)

    --controls
    rect(0,97,127,127,13)
    rectfill(1,96,126,126,0)
    --labels
    print("chrg", 4, 120, 7)
    print("def", 40, 120, 7)
    print("atk", 76, 120, 10)
    print("spec", 108, 120, 7)
    --color indicators
    rectfill(4, 102, 20, 113, 11)
    rectfill(21, 102, 63, 113, 3)
    rectfill(64, 102, 105, 113, 8)
    rectfill(106, 102, 123, 113, 9)
    spr(0,90,104)
    spr(1,90,96)
    spr(1,90,112,1,1,false,true)


end


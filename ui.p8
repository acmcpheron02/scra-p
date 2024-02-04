pico-8 cartridge // http://www.pico-8.com
version 39
__lua__

function ui_draw()
    line(64,30,127,-2,4)
    line(64,30,0,-2,4)
    line(64,40,0,8,4)
    line(64,40,127,8,4)
    line(64,50,0,18,4)
    line(64,50,127,18,4)
    for i=0, 60 do
        line(64,60+i,0,28+i,12)
        line(64,60+i,127,28+i,12)
    end
    line(64,0,64,127,7)
    line(63,0,63,127,7)
    rectfill(0,84,127,127,7)
end


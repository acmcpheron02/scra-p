pico-8 cartridge // http://www.pico-8.com
version 39
__lua__

#include pancelor_debug.p8
#include func.p8
#include player.p8
#include enemy.p8
#include managers.p8
#include ui.p8

game_states = {title, combat, pick_part}
game_state = nil

--definitions
parti = {"head", "larm", "rarm", "legs", "frame"}

function _init()
    printh("\n\n Fresh Run")
    game_state = title
end

function _update60()
    game_state.state_update();
end

function _draw()
    game_state.state_draw();
    -- print(#combat_manager.opp_queue,100,10)
    -- print(#combat_manager.player_queue,100,20)
    -- print(player.current_hp, 100, 30)
    -- print(opponent.current_hp, 100, 40)
end

function damage(target, dmg)
    local d = dmg - target.total_def
    if d < 0 then d = 0 end
    target.current_hp -= d
end

function attack(self, target)
    
    local pass = 4
    pass += self.acc

    for i=1,self.hits do
        local roll = flr(rnd(10))
        if pass >= roll then
            damage(target, self.dmg)
        end
    end
end

--Player--
player = {
    parts = {},
    total_def = 6,
    total_hp = 10,
    current_hp = 6,
    ready = true,
    ready_in = 0
}
player.parts.head = {
    hp = 10,
    def = 2,
    dura = 5,
    spd = 1,
    cool = 5,
    cool_left = 0,
    dmg = 6,
    hits = 1,
    acc = 5,
    name = 'laser beam',
    target = 'opponent',
    ready = true,
    action = attack
}
--player.parts.head.action = attack

player.parts.rarm = {
    hp = 10,
    def = 2,
    dura = 6,
    spd = 4,
    cool = 3,
    cool_left = 0,
    dmg = 2,
    hits = 6,
    acc = 2,
    name = 'gattling',
    target = 'opponent',
    ready = true,
    action = attack
}
player.parts.larm = {
    hp = 10,
    def = 2,
    dura = 10,
    spd = 5,
    cool = 2,
    cool_left = 0,
    dmg = 15,
    hits = 1,
    acc = 3,
    name = 'slash',
    target = 'opponent',
    ready = true,
    action = attack
}
player.parts.legs = {
    hp = 10,
    def = 2,
    dura = 20,
    spd = 2,
    cool = 2,
    cool_left = 0,
    dmg = 10,
    hits = 2,
    acc = 4,
    name = 'kick',
    target = 'opponent',
    ready = true,
    action = attack
}
player.parts.frame = {
    hp = 10,
    def = 2,
    dura = 50,
    spd = 1,
    cool = 0,
    cool_left = 0,
    dmg = 0,
    hits = 0,
    acc = 5,
    name = 'wait',
    target = 'opponent',
    ready = true,
    action = attack
}

function robo_update_stats (target)
    target.total_hp = 0
    target.total_def = 0
    for key, value in pairs(target.parts) do
        target.total_hp += target.parts[key].hp
        target.total_def += target.parts[key].def
    end
    target.current_hp = target.total_hp
    target.total_def /= 5
end

opponent = {
    parts = {},
    total_def = 1,
    total_hp = 50,
    current_hp = 48,
    ready = true,
    ready_in = 0
}
opponent.parts.head = {
    hp = 10,
    def = 2,
    dura = 10,
    spd = 2,
    cool = 5,
    cool_left = 0,
    dmg = 6,
    hits = 1,
    acc = 5,
    name = 'laser beam',
    target = 'player',
    ready = true,
    action = attack
}
opponent.parts.rarm = {
    hp = 10,
    def = 2,
    dura = 10,
    spd = 2,
    cool = 5,
    cool_left = 0,
    dmg = 2,
    hits = 4,
    acc = 2,
    name = 'gattling',
    target = 'player',
    ready = true,
    action = attack
}
opponent.parts.larm = {
    hp = 10,
    def = 2,
    dura = 10,
    spd = 2,
    cool = 5,
    cool_left = 0,
    dmg = 10,
    hits = 1,
    acc = 3,
    name = 'slash',
    target = 'player',
    ready = true,
    action = attack
}
opponent.parts.legs = {
    hp = 10,
    def = 2,
    dura = 10,
    spd = 2,
    cool = 5,
    cool_left = 0,
    dmg = 10,
    hits = 1,
    acc = 4,
    name = 'kick',
    target = 'player',
    ready = true,
    action = attack
}
opponent.parts.frame = {
    hp = 10,
    def = 2,
    dura = 10,
    spd = 2,
    cool = 0,
    cool_left = 0,
    dmg = 0,
    hits = 0,
    acc = 5,
    name = 'wait',
    target = 'player',
    ready = true,
    action = attack
}

function player:hp_bar()
    local x1, y1, x2, y2 = 6, 11, 56, 16
    local pct = self.current_hp / self.total_hp
    spr(1, x1-6, y1-1)
    rectfill(x1,y1,x2,y2,15)
    rectfill(x1,y1,x1+pct*(x2-x1),y2,8)
end

function opponent:hp_bar()
    local x1, y1, x2, y2 = 121, 11, 71, 16
    local pct = self.current_hp / self.total_hp
    spr(18, x1-1, y1-1)
    rectfill(x1,y1,x2,y2,13)
    rectfill(x1,y1,x1+pct*(x2-x1),y2,12)
end

function opponent_random_action()
    local o = opponent.parts
    local o_ready = {}
    for i=1,5 do
        local part = o[parti[i]]
        if part.ready then
            add(o_ready, part)
        end
    end
    printh(#o_ready)
    --qq(o_ready)
    return o_ready[flr(rnd(#o_ready)) + 1]
end

--Combat Menu--
combat_manager = {
    sel_index = 1,
    x_pos = 8,
    y_pos = 60,
    pl = player.parts
}

function combat_manager:display()
    --iterate through each
    for i=1,5 do
        local part = parti[i]
        local color = 7
        if not self.pl[part].ready then color = 9 end
        print(self.pl[part].name, self.x_pos, self.y_pos+i*10, color)
    end

    --cursor
    spr(0, 0, self.y_pos+self.sel_index*10)
    local part = parti[self.sel_index]
    
    --durability/charges
    spr(4, self.x_pos+64, self.y_pos+ 20)
    print(self.pl[part].dura .. " uses", self.x_pos+75, self.y_pos + 21)

    --damage
    spr(3, self.x_pos+64, self.y_pos+ 10)
    print(self.pl[part].dmg .. " x " .. self.pl[part].hits, self.x_pos+75, self.y_pos + 11)

    --accuracy
    for i=1,5 do
        spr(2, self.x_pos+64, self.y_pos+ 30)
        spr(16, self.x_pos+66+i*8, self.y_pos+ 30)
        if self.pl[part].acc >= i then 
            spr(17, self.x_pos+66+i*8, self.y_pos+ 30)
        end
    end

    --speed
    for i=1,5 do
        spr(5, self.x_pos+64, self.y_pos+ 40)
        spr(16, self.x_pos+66+i*8, self.y_pos+ 40)
        if self.pl[part].spd >= i then 
            spr(17, self.x_pos+66+i*8, self.y_pos+ 40)
        end
    end
    
    --cooldown
    for i=1,5 do
        spr(6, self.x_pos+64, self.y_pos+ 50)
        spr(16, self.x_pos+66+i*8, self.y_pos+ 50)
        if self.pl[part].cool >= i then 
            spr(17, self.x_pos+66+i*8, self.y_pos+ 50)
        end
    end
end

function combat_manager:movecursor(direction)
    if direction == "up" then
        if self.sel_index <= 1 then self.sel_index = 1 else self.sel_index -= 1
        end
    end
    if direction == "down" then
        if self.sel_index >= 5 then self.sel_index = 5 else self.sel_index += 1 
        end
    end
end

function combat_manager:selected_part()
    local index = parti[self.sel_index]
    local part = self.pl[index]
    return part
end

--event log
elog={"", "", "", "", "", ""}

function add_elog(message)
    for i=6,1,-1 do
        printh(i)
        elog[i] = elog[i-1]
    end
    printh(message)
    elog[1] = message
end

function display_elog(x0,y0,x1,y1)
    rectfill(x0,y0,x1,y1,14)
    rectfill(x0+1,y0+1,x1-1,y1-1,0)
    for i=1,6 do
        --printh(i.." elog position")
        print(elog[i], x0+3, y1-1-6*i, 7)
    end

end

--title definitions--
title = {}

function title.state_update()
    if btnp(4) then game_state = combat end
end

function title.state_draw()
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

--combat definitions--
combat = {}

function combat.state_update()
    if player.current_hp <= 0 or opponent.current_hp <= 0 then
        player.ready = false
    end 
    if player.ready then
        if btnp(2) then combat_manager:movecursor('up') end
        if btnp(3) then combat_manager:movecursor('down') end
        if btnp(4) then 
            printh("made it to point a")
            if not combat_manager:selected_part().ready then return end
            combat_manager:add_command(combat_manager:selected_part())
            printh("made it to point b")
            combat_manager:add_cooldown(combat_manager:selected_part())
            printh("made it to point c")
            while player.ready_in > 0 do
                combat_manager:advance()
            end
        end
    end
    -- if btnp(5) then 
    --     combat_manager:advance()
    --     add_elog("manual advance")
    -- end
    if opponent.ready then
        combat_manager:add_command(opponent_random_action())
        opponent.ready = false
        printh("made it to point d")
    end
end

function combat.state_draw()
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

__gfx__
0022e0000000022222080220000200002222a920000e0000222222200e0000e0ee9999ee0000004949e99e940000000000000000000000000000000000000000
00022e00000ee200208a802000282000200aa9200222220024000a209e9999e9e944e49e0000049e49e00e940000000000000000000000000000000000000000
eeeeeee00ee7e200080a08000088800020aa9020220002200240a20094444449994e7e9900004999449009440000000000000000000000000000000000000000
00022e00222222008aa9aa80008880002aa9002020000020002a200094b44b490944e49000009944049009400077700000000000000000000000000000000000
0022e00099999900080a0800008a80002aaaa9202007aa20024a0200944444490944449000049440049009400077700000000000000000000000000000000000
0000000022222200208a8020208a802020aa9020200a0020240aa020947777490944449000999940ee9009ee0777700000000000000000000000000000000000
0000000000ee220022080220022a22002aa90020220a022024aaaa20994774999ee44ee9009ee900999009990770000000000000000000000000000000000000
00000000000e222200000000000a00002a92222002222200222222200e9999e099e99e9900900900999009997000000000000000000000000000000000000000
00222000000000003330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02eed20000a88000003cc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2ed000200a888800003c7cc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2d0000200a8888000033333300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2d0000200888880000bbbbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02000200008880000033333300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00222000000000000033cc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000003333c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999909
09999999999999999999999999999999999999999999999999994999999999999999999999999999999999999999999999999949999999999999999999699999
44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
44444444444444444444444444444444444444444444444444464444444444444444444444444444444444444444444444444444444444444444444444444444
66066666666666666666666666666666666646666666666666666666666666666666666666666666666666666666666466666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666646666666666666666666666666646666666666466666666
66666666666666666666666666664666666666666666666666666666666646666666666666666666666666666666666666666666666666666666666466666666
66646666666666f4ffffff6666666666666666666666666666666666666666666666666666666666666666666666666666666666fffffffffff6666666664666
666666666666fffffffffff666666666666666466666666666666666666666666666646666666666666666646666646666666666fffff6ffffff466666666666
66666666646fffffffffffff66666666666666666666666666666646666666666666666666666666666666666666666666666666ffffffffffffff6666664666
6666666666ffffffff46fffff6466646666666666666666666666666666666666666666666666666666666666666666466666666fffffffff4fffff666664666
6666666666fffffffff4ffff4466666666666666666666666666666666666666666666666666666666664666666666666666666ffffffffffffff4f466666666
6666466664fffffff444fff444466666666fffff66666666ff4ff6666fff46666666ffffff66ffffff666666666666666666666ff4fffffff4fffff466666666
666666666fffffff444fff44444466666fff4fffff466666ffffff6f6fff446666f4fffffff6ffffff466466666666666666666ffffff444fffffff446666666
666666666fffffff4444f4444446666ffffffffffff46666ffffffffffff44466fffffffffffffffff446666666466666666666fffff44444ffffff446666666
666666666f4ffffff4444444446666ff6fffff6fffff4666ffffffff4fff4444f6ffffffffffffffff44466666666666666666ffffff44444ffffff444666466
666666666ffffffffff4644446666ffffff6fffffff44466fffffffffff4444fffff4f4ffffffffff444446666666666666666ffffff44444ffffff444666666
6664666646fffffffffff64466646fffffffffffff44446fffffffffff6444fffffffffff4f4ff4ff444466666664646666666fffffff444fff64f4444666666
66666666664f44ffffff6f666646ffffffff4444f444446ffffffffffff4444ff6fff444fffffff6f4444fffffffffff4466666fffffffffffffff4444666666
666666666666fffffffffff46664fffffff444444444466fffffff44444446ffffff44444ffffff6f4444ffffffffffff4466ffff4ffffff6f4fff4446666466
6466666646664ffffffffff4466fffffff4444666464666ffff6f64444644fffffff44444ffffffff4446ffffff4fffff4446ffffffffffff4fff44444666646
6446666666f664ffffffff4f466ff4ffff4444666666666ffffff46444444fffff6f44446fffffff4444ff6fffffffff44446fff4ff6ffffffff444446666666
666666666ff466446fffffff446fffffff644466666664ffff6ff44446666fffffff44466fff6fff4444fffffff4f6ff464466ff6f4fffffff44444466666666
66666666ff6ff644fffff6ff446fffffff444466666666ffff6ff44446666ffffffff446ffffffff4444ffffffffffff4446ffffffffffff4444444466666466
6666666fffffffff4fffffff446ffffff6f464f66666646ffffff44466666fff4fffffff4f6fff6f44446444446444444446ffffffff44444444444666666666
666666fffff4fffffffff4f44466fffffffff6ff666666ff4fff444466666fffffffffffffffffff44466644444444444446ffffffff44444444466666666666
666666ff4ffffffffffffff46466fff6fffffffff66666ffffff4444666666ffffffffffffffffff44464666666666646666fffffff444444466466646666666
6666666ff6ffffffffffff4464664fffffffff6fff4666ffffff4444666666ffffffffffffffff644446666666666666666ffffffff464446646666666666666
66666664f66fffffffff6444466664ff6ffffffff4446fffffff44466666666ff6ffffff4ffffff44446666666666666466ffffffff446666666666666666666
666666664ffffffffff444444666464ffffff4f444446ffffff4444666666666fffffff44ffffff44446666666666466666ffffffff444666666666666666666
66466666644444444444444466466664444444444444644444444446666666666444444444446444446666666666666666664444444444666666666666666466
66666666666444444444444666666666444444444446664444444446666466666644444444444444446646666666666666666444444446666666666646666666
66666666666664444444466666666666644444444466666444444446666666666666444444644444446666666666666666666644444444666666646666666666
66666646666666666666666666666666666664666666666666666666666666666666666666666666666666666666666666666666666664666666666666666666
66666666666666666666666666666666666666666666666466666666666666666666666666666666666666666666666666666646666666666666666666666666
60666666666666666666666666666666666646666666666666666666666666666666666666666666666666666666666666666646666666666666666646666666
09996999949999999999999999996999994999999999969999999999999999996999499999999999999949999999999499499999969999999999949999999999
99999999999999999999999999969999999999999999999999999999499999996999999999999999999999999499999999499999994999999999999999999999
44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
44444444444444444000444444444444444044440444444444444444444444444444444444444444444044444444440444444444444444444044444444404444

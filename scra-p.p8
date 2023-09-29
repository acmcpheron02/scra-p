pico-8 cartridge // http://www.pico-8.com
version 39
__lua__

#include pancelor_debug.p8

game_states = {title, combat, pick_part}
game_state = nil
combat_manager = {
    player_queue = {},
    opp_queue = {}
}

parti = {"head", "larm", "rarm", "legs", "frame"}

function _init()
    printh("\n\n\n\n\n Fresh Run")
    game_state = title
    reset_combat_manager()
end

function _update60()
    game_state.state_update();
end

function _draw()
    cls(5)
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
    print("title draw", 2,2,1)
    spr(4, 60, 60)
end

--combat definitions--
combat = {}

function combat.state_update()
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
    if btnp(5) then 
        combat_manager:advance()
        add_elog("manual advance")
    end
    if opponent.ready then
        combat_manager:add_command(opponent_random_action())
        opponent.ready = false
        printh("made it to point d")
    end
end

function combat.state_draw()
    combat_manager:display()
    player:hp_bar()
    print("player", 6, 3, 7)
    display_elog(3,20,124,60)
end

--Combat instructions--
function reset_combat_manager()
    match_counter = 0
    robo_update_stats(player)
    robo_update_stats(opponent)
    combat_manager.player_queue = {}
    combat_manager.opp_queue = {}
    for i=1,9999 do
        add(combat_manager.player_queue, 'empty')
        add(combat_manager.opp_queue, 'empty')
    end
end

function combat_manager:add_command(part)
    local tar 
    tar = part.target
    if tar == 'player' then
        add(combat_manager.player_queue, part, part.spd)
        part.ready = false
    end
    if tar == 'opponent' then 
        add(combat_manager.opp_queue, part, part.spd)
        part.ready = false 
    end
end

function combat_manager:add_cooldown(part)
    part.ready = false
    part.cool_left = part.cool + part.spd

    player.ready = false
    player.ready_in = part.spd
end

function combat_manager:advance()
    match_counter += 1

    local play_act = self.player_queue[1]
    if play_act != 'empty' then
        play_act:action(player)
        add_elog("t" .. match_counter .. ": enemy uses " .. play_act.name)
    end
    deli(self.player_queue, 1)

    local opp_act = self.opp_queue[1]
    if opp_act != 'empty' then
        opp_act:action(opponent)
        add_elog("t" .. match_counter .. ": player uses " .. opp_act.name)
    end
    deli(self.opp_queue, 1)

    if player.ready_in > 0 then
        player.ready_in -= 1
    else player.ready_in = 0
    end

    if player.ready_in == 0 then
        player.ready = true 
    end

    if opponent.ready_in > 0 then
        opponent.ready_in -= 1
    else opponent.ready_in = 0
    end

    if opponent.ready_in == 0 then
        opponent.ready = true 
    end

    for i=1,5 do
        if player.parts[parti[i]].cool_left > 0 then
            player.parts[parti[i]].cool_left -= 1
        else player.parts[parti[i]].cool_left = 0
        end
        
        if player.parts[parti[i]].cool_left == 0 then
            player.parts[parti[i]].ready = true
        end
    end

    for i=1,5 do
        if opponent.parts[parti[i]].cool_left > 0 then
            opponent.parts[parti[i]].cool_left -= 1
        else opponent.parts[parti[i]].cool_left = 0
        end
        
        if opponent.parts[parti[i]].cool_left == 0 then
            opponent.parts[parti[i]].ready = true
        end
    end
    
    printh('player recieves')
    ?pq(play_act)

    printh('opp receieves')
    ?pq(opp_act)

    printh('--------')
end

-- dummy_play_queue = {
--     dmg = 5,
--     hits = 2,
--     targ = opponent,
--     speed = 3,
--     cooldown = 3,
--     action = function() opponent.current_hp -= 1 end
-- }

-- dummy_opp_queue = {
--     dmg = 1,
--     hits = 2,
--     targ = player,
--     speed = 3,
--     cooldown = 3,
--     action = function(self,targ) targ.current_hp -= self.dmg end
-- }



__gfx__
002200000000022222080220000200002222a920000e000022222220000000000000000000000000000000000000000000000000000000000000000000000000
00222000000ee200208a802000282000200aa9200222220024000a20000000000000000000000000000000000000000000000000000000000000000000000000
000922000ee7e200080a08000088800020aa9020220002200240a200000000000000000000000000000000000000000000000000000000000000000000000000
00222000222222008aa9aa80008880002aa9002020000020002a2000000000000000000000000000000000000000000000000000000000000000000000000000
0022000088888800080a0800008a80002aaaa9202007aa20024a0200000000000000000000000000000000000000000000000000000000000000000000000000
0000000022222200208a8020208a802020aa9020200a0020240aa020000000000000000000000000000000000000000000000000000000000000000000000000
0000000000ee220022080220022a22002aa90020220a022024aaaa20000000000000000000000000000000000000000000000000000000000000000000000000
00000000000e222200000000000a00002a9222200222220022222220000000000000000000000000000000000000000000000000000000000000000000000000
00222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02eed20000a880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2ed000200a8888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2d0000200a8888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2d000020088888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02000200008880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

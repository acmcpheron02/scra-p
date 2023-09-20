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

parti = {"head", "larm", "frame", "rarm", "legs"}

function _init()
    printh("\n\n\n\n\n Fresh Run")
    game_state = title
    reset_combat_manager()
end

function _update60()
    game_state.state_update();
end

function _draw()
    cls(6)
    game_state.state_draw();
    print(#combat_manager.opp_queue,100,10)
    print(#combat_manager.player_queue,100,20)
    print(opponent.total_hp, 100, 30)
    print(opponent.current_hp, 100, 40)
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
            damage(opponent, self.dmg)
        end
    end
end

--Player--
player = {
    parts = {},
    total_def = 6,
    total_hp = 10,
    current_hp = 6,
    ready = true
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
    ready = true
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
    local x1, y1, x2, y2 = 10, 20, 36, 15
    local pct = self.current_hp / self.total_hp
    spr(1, x1-6, y1-6)
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
        local color = 1
        if not self.pl[part].ready then color = 13 end
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
            if not combat_manager:selected_part().ready then return end
            combat_manager:add_command(combat_manager:selected_part()) 
            combat_manager:add_cooldown(combat_manager:selected_part())
            local moved = 0
            repeat
                moved = combat_manager:advance()
                printh("function output: " .. moved)
            until moved == 1
        end
        if btnp(5) then 
            combat_manager:advance()
        end
    end
    if opponent.ready then
        combat_manager:add_command(opponent_random_action())
        opponent.ready = false
    end
end

function combat.state_draw()
    print("now we're in combat",2,2,1)
    combat_manager:display()
    player:hp_bar()
    print(combat_manager:selected_part().dmg,3,30)
    
end

--Combat instructions--
function reset_combat_manager()
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
        add(combat_manager.player_queue, part, part.spd + 1)
        part.ready = false
    end
    if tar == 'opponent' then 
        add(combat_manager.opp_queue, part, part.spd + 1)
        part.ready = false 
    end
end

function combat_manager:add_cooldown(part)
    part.ready = false
    part.cool_left = part.cool + part.spd
end

function combat_manager:advance()
    local play_act = self.player_queue[1]
    if play_act != 'empty' then
        play_act:action(player)
    end
    deli(self.player_queue, 1)

    local opp_act = self.opp_queue[1]
    if opp_act != 'empty' then
        opp_act:action(opponent)
    end
    deli(self.opp_queue, 1)

    for i=1,5 do
        if player.parts[parti[i]].cool_left > 0 then
            player.parts[parti[i]].cool_left -= 1
        else player.parts[parti[i]].cool_left = 0
        end
        
        if player.parts[parti[i]].cool_left == 0 then
            player.parts[parti[i]].ready = true
        end
    end

    if play_act == 'empty' and opp_act == 'empty' then
        return 0
    else 
        return 1
    end
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
0022000000000111110c0110000c0000cccca9c00011100accccccc0000000000000000000000000000000000000000000000000000000000000000000000000
00222000000cc10010cac01000ccc000c11aa9c001ccc1a0c1000ac0000000000000000000000000000000000000000000000000000000000000000000000000
000922000007c1000c0a0c0000ccc000c1aa91c01cddda100c10ac00000000000000000000000000000000000000000000000000000000000000000000000000
0022200011111100caa9aac000cac000caa911c0cdddadc000cac000000000000000000000000000000000000000000000000000000000000000000000000000
00220000cccccc000c0a0c0010cac010caaaa9c0cddaddc00c1a0c00000000000000000000000000000000000000000000000000000000000000000000000000
000000001111110010cac01001111100c1aa91c0cdd7ddc0c10aa0c0000000000000000000000000000000000000000000000000000000000000000000000000
0000000000011100110c011000090000caa911c0ccd7dcc0c1aaaac0000000000000000000000000000000000000000000000000000000000000000000000000
00000000000001110000000000090000ca9cccc00ccccc00ccccccc0000000000000000000000000000000000000000000000000000000000000000000000000
00111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0155d100007cc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
15d0001007cccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1d00001007cccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1d0000100ccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100010000ccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

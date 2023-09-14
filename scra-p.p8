pico-8 cartridge // http://www.pico-8.com
version 39
__lua__

game_states = {title, combat, pick_part}
game_state = nil
combat_manager = {
    player_queue = {},
    opp_queue = {}
}

function _init()
    game_state = title
    init_combat_manager(dummy_play_queue,dummy_opp_queue)
end

function _update60()
    game_state.state_update();
end

function _draw()
    cls(6)
    game_state.state_draw();
end

--Player--
player = {
    parts = {},
    total_def = 6,
    total_hp = 10,
    current_hp = 6
}
player.parts.head = {
    hp = 10,
    def = 2,
    dura = 5,
    spd = 1,
    cool = 5,
    dmg = 6,
    hits = 1,
    acc = 5,
    action = 'laser beam'
}
player.parts.rarm = {
    hp = 10,
    def = 2,
    dura = 6,
    spd = 4,
    cool = 3,
    dmg = 2,
    hits = 6,
    acc = 2,
    action = 'gattling'
}
player.parts.larm = {
    hp = 10,
    def = 2,
    dura = 10,
    spd = 5,
    cool = 2,
    dmg = 15,
    hits = 1,
    acc = 3,
    action = 'slash'
}
player.parts.legs = {
    hp = 10,
    def = 2,
    dura = 20,
    spd = 2,
    cool = 2,
    dmg = 10,
    hits = 2,
    acc = 4,
    action = 'kick'
}
player.parts.frame = {
    hp = 10,
    def = 2,
    dura = 50,
    spd = 1,
    cool = 1,
    dmg = 0,
    hits = 0,
    acc = 5,
    action = 'wait'
}

function robo_update_stats (target)
    target.total_hp = 0
    target.total_def = 0
    for key, value in pairs(target.parts) do
        target.total_hp += target.parts[key].hp
        target.total_def += target.parts[key].def
    end
    target.total_def /= 5
end

opponent = {
    parts = {},
    total_hp = 10,
    current_hp = 8,
}
opponent.parts.head = {
    hp = 10,
    def = 2,
    dura = 10,
    spd = 2,
    cool = 5,
    dmg = 6,
    hits = 1,
    acc = 5,
    action = 'laser beam'
}
opponent.parts.rarm = {
    hp = 10,
    def = 2,
    dura = 10,
    spd = 2,
    cool = 5,
    dmg = 2,
    hits = 4,
    acc = 2,
    action = 'gattling'
}
opponent.parts.larm = {
    hp = 10,
    def = 2,
    dura = 10,
    spd = 2,
    cool = 5,
    dmg = 10,
    hits = 1,
    acc = 3,
    action = 'slash'
}
opponent.parts.legs = {
    hp = 10,
    def = 2,
    dura = 10,
    spd = 2,
    cool = 5,
    dmg = 10,
    hits = 1,
    acc = 4,
    action = 'kick'
}
opponent.parts.frame = {
    hp = 10,
    def = 2,
    dura = 10,
    spd = 2,
    cool = 5,
    dmg = 0,
    hits = 0,
    acc = 5,
    action = 'wait'
}

function player:hp_bar()
    local x1, y1, x2, y2 = 10, 20, 36, 15
    local pct = self.current_hp / self.total_hp
    spr(1, x1-6, y1-6)
    rectfill(x1,y1,x2,y2,13)
    rectfill(x1,y1,x1+pct*(x2-x1),y2,12)
end


--Combat Menu--
combat_menu = {
    sel_index = 1,
    x_pos = 8,
    y_pos = 60
}

function combat_menu:display()
    local pl = player.parts
    --cross reference part name to a numerical index
    local parti = {"head", "larm", "frame", "rarm", "legs"}
    --iterate through each
    for i=1,5 do
        local part = parti[i]
        print(pl[part].action, self.x_pos, self.y_pos+i*10, 1)
    end
    --cursor
    spr(0, 0, self.y_pos+self.sel_index*10)
    local part = parti[self.sel_index]
    
    --durability/charges
    spr(4, self.x_pos+64, self.y_pos+ 20)
    print(pl[part].dura .. " uses", self.x_pos+75, self.y_pos + 21)

    --damage
    spr(3, self.x_pos+64, self.y_pos+ 10)
    print(pl[part].dmg .. " x " .. pl[part].hits, self.x_pos+75, self.y_pos + 11)

    --accuracy
    for i=1,5 do
        spr(2, self.x_pos+64, self.y_pos+ 30)
        spr(16, self.x_pos+66+i*8, self.y_pos+ 30)
        if pl[part].acc >= i then 
            spr(17, self.x_pos+66+i*8, self.y_pos+ 30)
        end
    end

    --speed
    for i=1,5 do
        spr(5, self.x_pos+64, self.y_pos+ 40)
        spr(16, self.x_pos+66+i*8, self.y_pos+ 40)
        if pl[part].spd >= i then 
            spr(17, self.x_pos+66+i*8, self.y_pos+ 40)
        end
    end
    
    --cooldown
    for i=1,5 do
        spr(6, self.x_pos+64, self.y_pos+ 50)
        spr(16, self.x_pos+66+i*8, self.y_pos+ 50)
        if pl[part].cool >= i then 
            spr(17, self.x_pos+66+i*8, self.y_pos+ 50)
        end
    end
end

function combat_menu.movecursor(self, direction)
    if direction == "up" then
        if self.sel_index <= 1 then self.sel_index = 1 else self.sel_index -= 1
        end
    end
    if direction == "down" then
        if self.sel_index >= 5 then self.sel_index = 5 else self.sel_index += 1 
        end
    end
end

--title definitions--
title = {}

function title.state_update()
    if btnp(5) then game_state = combat end
end

function title.state_draw()
    print("title draw", 2,2,1)
    spr(4, 60, 60)
end

--combat definitions--
combat = {}

function combat.state_update()
    if btnp(2) then combat_menu:movecursor("up") end
    if btnp(3) then combat_menu:movecursor("down") end
    if btnp(5) then combat_manager:advance() end
end

function combat.state_draw()
    print("now we're in combat",2,2,1)
    combat_menu:display()
    player:hp_bar()
    
end


--Combat instructions--
function init_combat_manager(play, opp)
    add(combat_manager.player_queue, play)
    add(combat_manager.opp_queue, opp)
end

function combat_manager:advance()
    play_act = self.player_queue[1]
    play_act:action()
    deli(self.player_queue, 1)

    opp_act = self.opp_queue[1]
    opp_act:action(player)
    deli(self.player_queue, 1)
end

dummy_play_queue = {
    dmg = 5,
    hits = 2,
    targ = opponent,
    speed = 3,
    cooldown = 3,
    action = function() opponent.current_hp -= 1 end
}

dummy_opp_queue = {
    dmg = 2,
    hits = 2,
    targ = player,
    speed = 3,
    cooldown = 3,
    action = function(self,targ) targ.current_hp -= self.dmg end
}



__gfx__
0022000000000666110c0110000c0000cccca9c00011100accccccc0000000000000000000000000000000000000000000000000000000000000000000000000
00222000000cc60010cac01000ccc000c11aa9c001ccc1a0c1000ac0000000000000000000000000000000000000000000000000000000000000000000000000
000922000007c6000c0a0c0000ccc000c1aa91c01cddda100c10ac00000000000000000000000000000000000000000000000000000000000000000000000000
0022200066666600caa9aac000cac000caa911c0cdddadc000cac000000000000000000000000000000000000000000000000000000000000000000000000000
00220000cccccc000c0a0c0010cac010caaaa9c0cddaddc00c1a0c00000000000000000000000000000000000000000000000000000000000000000000000000
000000006666660010cac01001111100c1aa91c0cdd7ddc0c10aa0c0000000000000000000000000000000000000000000000000000000000000000000000000
0000000000066600110c011000090000caa911c0ccd7dcc0c1aaaac0000000000000000000000000000000000000000000000000000000000000000000000000
00000000000006660000000000090000ca9cccc00ccccc00ccccccc0000000000000000000000000000000000000000000000000000000000000000000000000
00111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0155d100007cc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
15d0001007cccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1d00001007cccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1d0000100ccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100010000ccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

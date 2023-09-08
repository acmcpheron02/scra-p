pico-8 cartridge // http://www.pico-8.com
version 39
__lua__

game_states = {title, combat, pick_part}
game_state = nil
part_options = {"right arm", "left arm"}
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
    cls()
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
    def = 2
    dura = 10,
    spd = 2,
    cool = 5,
    dmg = 6,
    hits = 1,
    acc = 5,
    action = 'Laser Beam'
}
player.parts.rarm = {
    hp = 10,
    def = 2
    dura = 10,
    spd = 2,
    cool = 5,
    dmg = 2,
    hits = 4,
    acc = 2,
    action = 'Gattling'
}
player.parts.larm = {
    hp = 10,
    def = 2
    dura = 10,
    spd = 2,
    cool = 5,
    dmg = 10,
    hits = 1,
    acc = 1,
    action = 'Slash'
}
player.parts.frame = {
    hp = 10,
    def = 2
    dura = 10,
    spd = 2,
    cool = 5,
    dmg = 10,
    hits = 1,
    acc = 1,
    action = 'Wait'
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
    def = 2
    dura = 10,
    spd = 2,
    cool = 5,
    dmg = 6,
    hits = 1,
    acc = 5,
    action = 'Laser Beam'
}
opponent.parts.rarm = {
    hp = 10,
    def = 2
    dura = 10,
    spd = 2,
    cool = 5,
    dmg = 2,
    hits = 4,
    acc = 2,
    action = 'Gattling'
}
opponent.parts.larm = {
    hp = 10,
    def = 2
    dura = 10,
    spd = 2,
    cool = 5,
    dmg = 10,
    hits = 1,
    acc = 1,
    action = 'Slash'
}
opponent.parts.frame = {
    hp = 10,
    def = 2
    dura = 10,
    spd = 2,
    cool = 5,
    dmg = 10,
    hits = 1,
    acc = 1,
    action = 'Wait'
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

combat_menu.options = {
    
}

function combat_menu.display(self)
    for i=1,#self.options do
        print(self.options[i], self.x_pos, self.y_pos+i*10)
        spr(0, 0, self.y_pos+self.sel_index*10)
    end
end

function combat_menu.movecursor(self, direction)
    if direction == "up" then
        if self.sel_index <= 1 then self.sel_index = 1 else self.sel_index -= 1
        end
    end
    if direction == "down" then
        if self.sel_index >= #self.options then self.sel_index = #self.options else self.sel_index += 1 
        end
    end
end

--title definitions--
title = {}

function title.state_update()
    if btnp(5) then game_state = combat end
end

function title.state_draw()
    print("title draw")
end

--combat definitions--
combat = {}

function combat.state_update()
    if btnp(2) then combat_menu:movecursor("up") end
    if btnp(3) then combat_menu:movecursor("down") end
    if btnp(5) then combat_manager:advance() end
end

function combat.state_draw()
    print("now we're in combat")
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
00220000000006660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00222000000cc6000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000922000007c6000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00222000666666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00220000cccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000666666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000006660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

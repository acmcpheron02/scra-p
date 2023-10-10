pico-8 cartridge // http://www.pico-8.com
version 39
__lua__

--Combat Menu--
combat_manager = {
    sel_index = 1,
    x_pos = 8,
    y_pos = 60,
    pl = player.parts
}


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

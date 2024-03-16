pico-8 cartridge // http://www.pico-8.com
version 39
__lua__

cm = {
    time = 31,
    selected = 0, --1st bit x, 2nd bit y
    player_attacks = {},
    player_costs = {},
    enemy_attacks = {},
    enemy_costs = {}
}

function cm.update()
    cm.timer()
    move_select()
end

function cm.timer()
    cm.time -= 1/60
    --player.current_hp -= 0.1
    player.current_chrg += player.chrg>>10
end

function cm.get_time1()
    return flr(cm.time / 10)
end

function cm.get_time2()
    return flr(cm.time % 10)
end

function cm.player_health()
    local pct = player.current_hp / player.hp
    if pct <= 0 then
        return
    end
    rectfill(52,6,52-flr(53*pct),0,4)
end

function cm.get_player_attacks()
    printh(tostr(player.parts.larm.attack))
    cm.player_attacks[1] = player.parts.larm.attack
    cm.player_attacks[2] = player.parts.rarm.attack
    cm.player_attacks[3] = player.parts.head.attack
    cm.player_attacks[4] = player.parts.lleg.attack
end

function cm.get_player_costs()
    cm.player_costs[1] = player.parts.larm.cost
    cm.player_costs[2] = player.parts.rarm.cost
    cm.player_costs[3] = player.parts.head.cost
    cm.player_costs[4] = player.parts.lleg.cost
end

function cm.enemy_health()
    local pct = enemy.current_hp / enemy.hp
    if pct <= 0 then
        return
    end
    rectfill(75,6,75+flr(53*pct),0,8)
end

function move_select()
    if btnp(0) or btnp(1) then
        cm.selected = cm.selected ^^ 1
    end
    if btnp(2) or btnp(3) then
        cm.selected = cm.selected ^^ 2
    end

end



animations = {

}
pico-8 cartridge // http://www.pico-8.com
version 39
__lua__

cm = {
    time = 31
}

function cm.update()
    cm.timer()
end

function cm.timer()
    cm.time -= 1/60
    player.current_hp -= 2
    player.current_chrg += player.chrg/1000
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
    rectfill(52,6,52-flr(53*pct),0,3)
end

function cm.enemy_health()
    local pct = player.current_hp / player.hp
    if pct <= 0 then
        return
    end
    rectfill(75,6,75+flr(53*pct),0,3)
end

rectfill(127,0,74,6,7)
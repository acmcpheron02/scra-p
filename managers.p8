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

function move_select()
    if btnp(0) or btnp(1) then
        cm.selected = cm.selected ^^ 1
    end
    if btnp(2) or btnp(3) then
        cm.selected = cm.selected ^^ 2
    end
    if btnp(4) then
        cm.use_attack(cm.player_attacks[cm.selected+1], cm.player_costs[cm.selected+1], player, enemy)
    end
end

function cm.use_attack(atk, cost, source, target)
    if source.current_chrg < cost then
        return
    else 
        source.current_chrg -= cost
    end
    local dmg = (attack_lib[atk].power/10*source.str) - target.def
    target.current_hp -= dmg
end

function cm.player_health()
    local pct = player.current_hp / player.hp
    if pct <= 0 then
        return
    end
    rectfill(52,6,52-flr(53*pct),0,4)
end

function cm.get_player_attacks()
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


function cm.get_enemy_attacks()
    cm.enemy_attacks[1] = enemy.parts.larm.attack
    cm.enemy_attacks[2] = enemy.parts.rarm.attack
    cm.enemy_attacks[3] = enemy.parts.head.attack
    cm.enemy_attacks[4] = enemy.parts.lleg.attack
end

function cm.get_enemy_costs()
    cm.enemy_costs[1] = enemy.parts.larm.cost
    cm.enemy_costs[2] = enemy.parts.rarm.cost
    cm.enemy_costs[3] = enemy.parts.head.cost
    cm.enemy_costs[4] = enemy.parts.lleg.cost
end

function mk_animator()
    local threads = {}
    return {
        post = function(key, anim_fn)
            threads[key] = cocreate(anim_fn)
          end,
        update = function()
            for key, thread in pairs(threads) do
                if costatus(thread) ~= "dead" then
                    coresume(thread)
                else
                    threads[key] = nil -- this is ok to do here
                end
            end
        end,
        reset = function() threads = {} end,
        status = function(key)
            return costatus(threads[key])
        end,
        cancel = function(key)
            threads[key] = nil
        end
    }
end


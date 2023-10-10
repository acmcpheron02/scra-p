pico-8 cartridge // http://www.pico-8.com
version 39
__lua__

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

pico-8 cartridge // http://www.pico-8.com
version 39
__lua__

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

function opponent:hp_bar()
    local x1, y1, x2, y2 = 121, 11, 71, 16
    local pct = self.current_hp / self.total_hp
    spr(18, x1-1, y1-1)
    rectfill(x1,y1,x2,y2,13)
    rectfill(x1,y1,x1+pct*(x2-x1),y2,12)
end
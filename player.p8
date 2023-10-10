pico-8 cartridge // http://www.pico-8.com
version 39
__lua__

player = {
    parts = {},
    total_def = 0,
    total_hp = 0,
    current_hp = 0,
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

function player:hp_bar()
    local x1, y1, x2, y2 = 6, 11, 56, 16
    local pct = self.current_hp / self.total_hp
    spr(1, x1-6, y1-1)
    rectfill(x1,y1,x2,y2,15)
    rectfill(x1,y1,x1+pct*(x2-x1),y2,8)
end
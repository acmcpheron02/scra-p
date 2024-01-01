pico-8 cartridge // http://www.pico-8.com
version 39
__lua__

player = {
    parts = {},
    hp = 0,
    str = 0,
    def = 0,
    spd = 0,
    current_hp = 0,
    tc = 0,
    pos = {90, 20},
    attacks = {}
}

player.parts.frame = {
    hp = 100,
    str = 7,
    def = 2,
    spd = 5,
    spri = {16,16,16,16},
    r_pos = {0,0},
    spr = {}
}

player.parts.head = {
    hp = 25,
    str = 0,
    def = 1,
    spd = 0,
    spri = {0,16,16,16},
    r_pos = {0,-16},
    spr = {}
}

player.parts.larm = {
    hp = 0,
    str = 4,
    def = 3,
    spd = 0,
    spri = {48,16,16,16},
    r_pos = {-16,0},
    spr = {}
}

player.parts.rarm = {
    hp = 0,
    str = 8,
    def = 0,
    spd = 8,
    pwr = 100,
    hits = 1,
    spri = {64,16,16,16},
    r_pos = {16,-8},
    spr = {}
}

player.parts.legs =
{
    hp = 0,
    str = 8,
    def = 0,
    spd = 8,
    spri = {32,16,16,16},
    r_pos = {0,16},
    spr = {}
}

function player:set_sprites()
    pq(player.parts.larm)
    local p_sp = bake_sprites('frame1', 'head1', 'arm1', 'arm1', 'legs1')
    pq(p_sp)
    for key, value in pairs(self.parts) do
        printh("reached "..key)
        pq(p_sp[key])
        self.parts[key].spr = p_sp[key]
    end
    pq(player.parts.larm)
end

function player:robo_update_stats()
    for key, value in pairs(self.parts) do
        local part = self.parts[key]
        self.hp += part.hp
        self.str += part.str
        self.def += part.def
        self.spd += part.spd
        if part.pwr != nil then
            for i=1,part.hits do
                add(self.attacks, part.pwr)
            end
        end
    end
    self.current_hp = self.hp
    self.tc = self.spd
end

function player:attack()
    for i=1,#self.attacks do
        self.opp.current_hp -= (self.attacks[i]/100 * self.str) 
    end
end

function player:sprites()
    local ps = self.parts
    for k, v in pairs(ps) do
        sspr(v.spri[1],v.spri[2],v.spri[3],v.spri[4],
        v.r_pos[1] + self.pos[1],
        v.r_pos[2] + self.pos[2])
    end
end

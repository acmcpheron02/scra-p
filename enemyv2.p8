pico-8 cartridge // http://www.pico-8.com
version 39
__lua__

enemy = {
    parts = {},
    hp = 0,
    str = 0,
    def = 0,
    spd = 0,
    current_hp = 0,
    tc = 0,
    attacks = {}
}

enemy.parts.frame = {
    hp = 80,
    str = 4,
    def = 1,
    spd = 3
}

enemy.parts.head = {
    hp = 25,
    str = 0,
    def = 1,
    spd = 0
}

enemy.parts.larm = {
    hp = 0,
    str = 4,
    def = 3,
    spd = 0
}

enemy.parts.rarm = {
    hp = 0,
    str = 8,
    def = 0,
    spd = 8,
    pwr = 100,
    hits = 1
}

enemy.parts.legs =
{
    hp = 0,
    str = 8,
    def = 0,
    spd = 8
}

function enemy:robo_update_stats()
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

function enemy:attack()
    for i=1,#self.attacks do
        self.opp.current_hp -= (self.attacks[i]/100 * self.str) 
    end
end

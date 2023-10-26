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
    attacks = {}
}

player.parts.frame = {
    hp = 30,
    str = 7,
    def = 2,
    spd = 5
}

player.parts.head = {
    hp = 25,
    str = 0,
    def = 1,
    spd = 0
}

player.parts.larm = {
    hp = 0,
    str = 4,
    def = 3,
    spd = 0
}

player.parts.rarm = {
    hp = 0,
    str = 8,
    def = 0,
    spd = 8,
    pwr = 100,
    hits = 1
}

player.parts.legs =
{
    hp = 0,
    str = 8,
    def = 0,
    spd = 8
}

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
end

function player:attack()
    for i=1,#self.attacks do
        cm.en.current_hp -= (self.attacks[i] * self.str) 
    end
end

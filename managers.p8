pico-8 cartridge // http://www.pico-8.com
version 39
__lua__

--Combat Manager--
cm = {
    pl = player, 
    en = opponent,
    select
}

function cm:new(o,pl,en)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    
    self.pl = pl
    self.en = en
end

function cm:update()
    local who_turn()
    if who_turn() == "player" then
        cm:pl_turn()
    else if who_turn() == "enemy"
        cm:en_turn()
    else
        cm:turn_advance()
    end
end
    
function cm:pl_turn()
    cm:menu_nav()
    if btn(4) then 
        select.action()
        cm:reset_tc(cm.pl)
    end
end

function cm:who_turn()
    if self.pl.tc >= 50 then
        return "player"
    else if self.en.tc >= 50 then
        return "enemy"
    else return "none"
end

function cm:turn_advance()
    self.pl.tc += 1
    self.en.tc += 1
end

function cm:reset_tc(t)
    t.tc = t.speed
end

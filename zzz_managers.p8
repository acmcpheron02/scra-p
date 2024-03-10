pico-8 cartridge // http://www.pico-8.com
version 39
__lua__

--Combat Manager
cm = {
    pl = player, 
    en = enemy,
    sel_index = 1
}

function cm:new(o,pl,en)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    
    self.pl = pl
    self.en = en

    pl.opp = en
    en.opp = pl
end

function cm:update()
    if self:who_turn() == "player" then
        self:pl_turn()
    elseif self:who_turn() == "enemy" then
        self:en_turn()
    else
        self:turn_advance()
    end
end

function cm:move_cursor(direction)
    if btnp(2) then
        if self.sel_index <= 1 then self.sel_index = 1 
        else self.sel_index -= 1
        end
    end
    if btnp(3) then
        if self.sel_index >= 3 then self.sel_index = 3
        else self.sel_index += 1 
        end
    end
end

function cm:submit()
    if self.sel_index == 1 then self.pl:attack() end
end
    
function cm:pl_turn()
    self:move_cursor()
    if btn(4) then 
        self:submit()
        self:reset_tc(cm.pl)
    end
end

function cm:en_turn()
    local r = rnd(10)
    if r <= 10 then
        self.en:attack()
        self:reset_tc(cm.en)
    end
end

function cm:who_turn()
    if self.pl.tc >= 75 then
        return "player"
    elseif self.en.tc >= 75 then
        return "enemy"
    else return "none"
    end
end

function cm:turn_advance()
    self.pl.tc += 1
    self.en.tc += 1
end

function cm:reset_tc(t)
    t.tc = t.spd
end

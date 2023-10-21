pico-8 cartridge // http://www.pico-8.com
version 39
__lua__

--Combat Manager
cm = {
    pl = player, 
    en = opponent,
    sel_index = 1,
    sel = nil
}

function cm:new(o,pl,en)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    
    self.pl = pl
    self.en = en
end

function cm:move_cursor(direction)
    if btnp(2) then
        if self.sel_index <= 1 then self.sel_index = 1 
        else self.sel_index -= 1
        end
    end
    if btnp(3) then
        if self.sel_index >= 5 then self.sel_index = 5 
        else self.sel_index += 1 
        end
    end
end

function cm:update()
    if who_turn() == "player" then
        self:pl_turn()
    elseif who_turn() == "enemy" then
        self:en_turn()
    else
        self:turn_advance()
    end
end
    
function cm:pl_turn()
    self:menu_nav()
    if btn(4) then 
        select.action()
        self:reset_tc(cm.pl)
    end
end

function cm:who_turn()
    if self.pl.tc >= 50 then
        return "player"
    elseif self.en.tc >= 50 then
        return "enemy"
    else return "none"
    end
end

function cm:turn_advance()
    self.pl.tc += 1
    self.en.tc += 1
end

function cm:reset_tc(t)
    t.tc = t.speed
end

function cm:menu_nav()

end
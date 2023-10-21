pico-8 cartridge // http://www.pico-8.com
version 39
__lua__

--Combat Manager--
cm = {
    pl = player, 
    en = opponent,
    sel = 
}

function cm:new(o,pl,en)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    
    self.pl = pl
    self.en = en
end

function cm:populate_menu()
for i=1,5 do
    local part = parti[i]
    local color = 7
    if not self.pl[part].ready then color = 9 end
    print(self.pl[part].name, self.x_pos, self.y_pos+i*10, color)
    end
end


function cm:move_cursor(direction)
    if direction == "up" then
        if self.sel_index <= 1 then self.sel_index = 1 else self.sel_index -= 1
        end
    end
    if direction == "down" then
        if self.sel_index >= 5 then self.sel_index = 5 else self.sel_index += 1 
        end
    end
end

function cm:selected()
    local index = parti[self.sel_index]
    local part = self.pl[index]
    return part
end


function cm:update()
    if who_turn() == "player" then
        cm:pl_turn()
    elseif who_turn() == "enemy" then
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
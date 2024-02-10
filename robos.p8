pico-8 cartridge // http://www.pico-8.com
version 39
__lua__


function robo_make(target, frame, head, larm, rarm, legs)
    
    target.parts = {}
    target.sprites = {}
    target.hp = 0
    target.str = 0
    target.def = 0
    target.spd = 0
    target.current_hp = 0
    target.tc = 0
    target.pos = {90, 20}
    target.attacks = {}

    target.sprites = bake_sprites(frame, head, larm, rarm, legs)

    target.parts.frame = part_make(2, frame)
    target.parts.head = part_make(2, head)
    target.parts.larm = part_make(2, larm)
    target.parts.rarm = part_make(2, rarm)
    target.parts.legs = part_make(2, legs)
    
    robo_update_stats(target)

end

function part_make(grade, depot_entry)
    local part = {
        hp = 0,
        str = 0,
        def = 0,
        spd = 0,
        chrg = 0,
        grade = grade
    }
    
    local points = flr(grade * 8 + rnd(grade*4))

    for i=1, #depot_entry.distribution do
        if points <= 0 then break end
        local assign = flr(rnd(points)+1)
        points -= assign

        part[depot_entry.distribution[i]] = assign*depot_entry.dist_ratio[i]
    end

    return part
end



part_depot = {
    frame1 = {
        slot = 'frame',
        distribution = {"hp", "def", "str", "chrg", "spd"},
        dist_ratio = {10, 1, 3, 3, 3},
        s_pos = { 2, 24, 27, 28 },
        anchor = { 15, 34 },
        joints = {
            head = { 14, 27 },
            rarm = { 7,  29 },
            larm = { 23, 29 },
            rleg = { 14, 44 },
            lleg = { 27, 44 }
        },
        ani_x = 0,
        ani_y = 0 
    },
    head1 = {
        slot = 'head',
        distribution = {"hp", "def", "str", "chrg", "spd"},
        dist_ratio = {10, 1, 3, 3, 3},
        s_pos = { 2, 8, 27, 16 },
        anchor = { 15, 23 }, --sprite sheet location
        ani_x = 0,
        ani_y = 0 
    },
    arm1 = {
        slot = 'arm',
        distribution = {"hp", "def", "str", "chrg", "spd"},
        dist_ratio = {10, 1, 3, 3, 3},
        s_pos = { 66, 8, 22, 16 },
        anchor = { 85, 10 }, --sprite sheet location
        ani_x = 0,
        ani_y = 0 

    },
    leg1 = {
        slot = 'leg',
        distribution = {"hp", "def", "str", "chrg", "spd"},
        dist_ratio = {10, 1, 3, 3, 3},
        s_pos = { 64, 24, 16, 32 },
        anchor = { 78, 26 }, --sprite sheet location
        ani_x = 0,
        ani_y = 0 
    }
}

function robo_update_stats(target)
    for key, value in pairs(target.parts) do
        local part = target.parts[key]
        target.hp += part.hp
        target.str += part.str
        target.def += part.def
        target.spd += part.spd
        if part.pwr != nil then
            for i=1,part.hits do
                add(target.attacks, part.pwr)
            end
        end
    end
    target.current_hp = target.hp
    target.tc = target.spd
end

function robo_sprites(target)
    local flipx, x, y

    if target == player then
        flipx = true
        x, y = 28, 42
    else
        flipx = false
        x, y = 100, 42
    end

    local sp = target.sprites

    part_sprite(sp.rarm, x, y, flipx)
    part_sprite(sp.rleg, x, y, flipx)
    part_sprite(sp.frame, x, y, flipx)
    part_sprite(sp.head, x, y, flipx)
    part_sprite(sp.larm, x, y, flipx)
    part_sprite(sp.lleg, x, y, flipx)
end
    

function bake_sprites(frame, head, larm, rarm, legs)
    -- create an array of sprite details, then store offset values on them

    local p_sp = {}

    p_sp.frame = deepcopy(frame)
    p_sp.head = deepcopy(head)
    p_sp.larm = deepcopy(larm)
    p_sp.rarm = deepcopy(rarm)
    p_sp.lleg = deepcopy(legs)
    p_sp.rleg = deepcopy(legs)

    for key, value in pairs(p_sp) do
        p_sp[key].px_off =  set_part_xoffset(p_sp[key])
        p_sp[key].py_off =  set_part_yoffset(p_sp[key])

        if value.slot != "frame" then
            p_sp[key].px_off += set_joint_xoffset(p_sp["frame"], key)
            p_sp[key].py_off += set_joint_yoffset(p_sp["frame"], key)
        end
    end

    return p_sp
end


function set_part_xoffset(part)
    return part.s_pos[1] - part.anchor[1]
end

function set_part_yoffset(part)
    return part.s_pos[2] - part.anchor[2]
end

function set_joint_xoffset(frame, ref)
    return (frame.s_pos[1] - frame.anchor[1]) - (frame.s_pos[1] - frame.joints[ref][1])
end

function set_joint_yoffset(frame, ref)
    return (frame.s_pos[2] - frame.anchor[2]) - (frame.s_pos[2] - frame.joints[ref][2])
end

function part_sprite(part, x, y, flipx)
    local p = part
    if flipx == false then
        sspr(
            p.s_pos[1],
            p.s_pos[2], 
            p.s_pos[3], 
            p.s_pos[4], 
            x + p.px_off + p.ani_x,
            y + p.py_off + p.ani_y, 
            p.s_pos[3], 
            p.s_pos[4]
        )
    end
    if flipx == true then
        --to understand 5th arg: (s_pos - anchor) = pixels away from top left corner. Results in negative number
        --normally by adding this, you offset the pixels so that the targetted anchor is where x,y is provided
        --but because of the xflip, the anchor moves too. Because we know the sprite dimensions though,
        --we can find the right most edge and move left from there instead, so subtract the anchor.
        sspr(
            p.s_pos[1],
            p.s_pos[2],
            p.s_pos[3], 
            p.s_pos[4],
            x - p.px_off - p.ani_x,
            y + p.py_off + p.ani_y, 
            -p.s_pos[3], 
            p.s_pos[4]
        )
    end
end

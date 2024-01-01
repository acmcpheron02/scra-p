pico-8 cartridge // http://www.pico-8.com
version 39
__lua__

pdepot = {
    frame1 = {
        slot = 'frame',
        s_pos = { 2, 24, 14, 28 },
        anchor = { 15, 34 },
        joints = {
            head = { 15, 24 },
            arm = { 7, 31 },
            leg = { 9, 50 }
        }
    },
    head1 = {
        slot = 'head',
        s_pos = { 2, 8, 14, 16 },
        anchor = { 15, 23 } --sprite sheet location
    },
    arm1 = {
        slot = 'arm',
        s_pos = { 66, 8, 22, 16 },
        anchor = { 87, 8 } --sprite sheet location
    },
    legs1 = {
        slot = 'leg',
        s_pos = { 64, 24, 16, 32 },
        anchor = { 79, 24 } --sprite sheet location
    }
}



function bake_sprites(frame, head, larm, rarm, legs)
    -- create an array of sprite details, then store offset values on them

    local p_sp = {}

    p_sp.frame = deepcopy(pdepot[frame])
    p_sp.head = deepcopy(pdepot[head])
    p_sp.larm = deepcopy(pdepot[larm])
    p_sp.rarm = deepcopy(pdepot[rarm])
    p_sp.legs = deepcopy(pdepot[legs])

    printh(#p_sp)

    for i=1,#p_sp do
        p_sp[i].px_off =  set_p_xoff(p_sp[i])
        p_sp[i].py_off =  set_p_yoff(p_sp[i])

        if i>1 then
            p_sp[i].px_off += set_j_xoff(p_sp[1], p_sp[i].slot)
            p_sp[i].py_off += set_j_yoff(p_sp[1], p_sp[i].slot) 
        end
    end

    return p_sp
end

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function set_p_xoff(part)
    return part.s_pos[1] - part.anchor[1] - 1
end

function set_p_yoff(part)
    return part.s_pos[2] - part.anchor[2] - 1
end

function set_j_xoff(frame, ref)
    return (frame.s_pos[1] - frame.anchor[1] - 1) - (frame.s_pos[1] - frame.joints[ref][1] - 1)
end

function set_j_yoff(frame, ref)
    return (frame.s_pos[2] - frame.anchor[2] - 1) - (frame.s_pos[2] - frame.joints[ref][2] - 1)
end

function p_spr(part, x, y, flipx)
    local p = part
    local sl = p.slot
    if flipx == false then
        sspr(
            p.s_pos[1],
            p.s_pos[2], 
            p.s_pos[3], 
            p.s_pos[4], 
            x + set_p_xoff(p) + set_j_xoff(pdepot.frame1, sl), 
            y + set_p_yoff(p), 
            p.s_pos[3], 
            p.s_pos[4], 
            flipx
        )
        print(x + set_p_xoff(p) .. "_" .. p.slot .. sl)
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
            x - set_p_xoff(p) - set_j_xoff(pdepot.frame1, sl),
            y + set_p_yoff(p), 
            -p.s_pos[3], 
            p.s_pos[4], 
            false
        )
        print(x + set_p_xoff(p) + p.s_pos[3] .. " " .. p.slot)
    end
end

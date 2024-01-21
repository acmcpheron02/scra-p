pico-8 cartridge // http://www.pico-8.com
version 39
__lua__

part_depot = {
    frame1 = {
        slot = 'frame',
        s_pos = { 2, 24, 27, 28 },
        anchor = { 15, 34 },
        joints = {
            head = { 14, 26 },
            larm = { 7,  29 },
            rarm = { 23, 29 },
            lleg = { 14,  44 },
            rleg = { 27, 44 }
        }
    },
    head1 = {
        slot = 'head',
        s_pos = { 2, 8, 27, 16 },
        anchor = { 15, 23 } --sprite sheet location
    },
    arm1 = {
        slot = 'arm',
        s_pos = { 66, 8, 22, 16 },
        anchor = { 85, 10 } --sprite sheet location
    },
    leg1 = {
        slot = 'leg',
        s_pos = { 64, 24, 16, 32 },
        anchor = { 78, 26 } --sprite sheet location
    }
}

function bake_sprites(frame, head, larm, rarm, legs)
    -- create an array of sprite details, then store offset values on them

    local p_sp = {}

    p_sp.frame = deepcopy(part_depot[frame])
    p_sp.head = deepcopy(part_depot[head])
    p_sp.larm = deepcopy(part_depot[larm])
    p_sp.rarm = deepcopy(part_depot[rarm])
    p_sp.lleg = deepcopy(part_depot[legs])
    p_sp.rleg = deepcopy(part_depot[legs])

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
            x + p.px_off,
            y + p.py_off, 
            p.s_pos[3], 
            p.s_pos[4], 
            flipx
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
            x - p.px_off,
            y + p.py_off, 
            -p.s_pos[3], 
            p.s_pos[4], 
            false
        )
    end
end

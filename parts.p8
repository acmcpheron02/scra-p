pico-8 cartridge // http://www.pico-8.com
version 39
__lua__

pdepot = {
    frame1 = {
        slot = 'frame',
        s_pos = {2, 24, 14, 28},
        anchor = {15, 34},
        joints = {
            head = {15,24},
            arm = {7,31},
            leg = {9,50}
        },
    },
    head1 = {
        slot = 'head',
        s_pos = {2, 8, 14, 16},
        anchor = {15, 23}, --sprite sheet location
    }
}

function p_xoff(part)
    return part.anchor[1] - part.s_pos[1]
end

function p_yoff(part)
    return part.anchor[2] - part.s_pos[2]
end

function j_xoff(part, ref)
    return part.anchor[1] - part.joints[ref][1]
end

function j_yoff(part, ref)
    return part.anchor[2] - part.joints[ref][2]
end
pico-8 cartridge // http://www.pico-8.com
version 39
__lua__

part_depot = {
    frame1 = {
        --slot = 'frame',
        distribution = {"hp", "def", "chrg", "spd", "str"},
        dist_ratio = {10, 1, 2, 3, 3},
        s_pos = { 2, 24, 27, 28 },
        anchor = { 15, 34 },
        joints = {
            head = { 14, 27 },
            rarm = { 7,  29 },
            larm = { 23, 29 },
            rleg = { 14, 44 },
            lleg = { 27, 44 }
        }
    },
    head1 = {
        distribution = {"chrg", "spd", "def", "hp", "str"},
        dist_ratio = {4, 2, 1, 5, 3},
        attack = "sparker",
        cost = 6,
        s_pos = { 2, 8, 27, 16 }, --sprite sheet location
        anchor = { 15, 23 } --sprite sheet location
    },
    arm1 = {
        distribution = {"str", "def", "spd", "hp", "chrg"},
        dist_ratio = {5, 1, 2, 4, 2},
        attack = "jab",
        cost = 3,
        s_pos = { 66, 11, 22, 10 }, --sprite sheet location
        anchor = { 82, 16} --sprite sheet location
    },
    arm2 = {
        distribution = {"str", "def", "spd", "hp", "chrg"},
        dist_ratio = {5, 1, 2, 4, 2},
        attack = "uppercut",
        cost = 9,
        s_pos = { 66, 11, 22, 10 }, --sprite sheet location
        anchor = { 82, 16} --sprite sheet location
    },
    leg1 = {
        distribution = {"spd", "chrg", "hp", "def", "str"},
        dist_ratio = {5, 2, 4, 1, 2},
        attack = "rev up",
        cost = 5,
        s_pos = { 64, 24, 16, 32 }, --sprite sheet location
        anchor = { 78, 26 } --sprite sheet location
    }
}

function robo_make(target, d_frame, d_head, d_larm, d_rarm, d_legs, flipx)
    
    target.parts = {
        frame = {},
        head = {},
        larm = {},
        rarm = {},
        lleg = {},
        rleg = {}
    }
    target.attacks = {}
    target.hp = 0
    target.str = 0
    target.def = 0
    target.spd = 0
    target.chrg = 0
    target.current_hp = 0
    target.current_chrg = 0
    target.pos_x = 90 
    target.pox_y = 20
    target.flipx = flipx

    --target.sprites = bake_sprites(frame, head, larm, rarm, legs)

    part_make("frame", target.parts.frame, target.parts.frame, 3, d_frame)
    part_make("head", target.parts.head, target.parts.frame, 3, d_head)
    part_make("larm", target.parts.larm, target.parts.frame, 3, d_larm)
    part_make("rarm", target.parts.rarm, target.parts.frame, 3, d_rarm)
    part_make("lleg", target.parts.lleg, target.parts.frame, 3, d_legs)
    part_make("rleg", target.parts.rleg, target.parts.frame, 0, d_legs)

    robo_update_stats(target)

    pq(target.parts.rarm)
end

function part_make(slot, part, frame, grade, depot_entry)
    

    --stats start
    part.slot = slot
    part.hp = 0
    part.str = 0
    part.def = 0
    part.spd = 0 --used for accuracy ratio
    part.chrg = 0 --used for battery charge speed
    part.grade = grade

    local dist = dist_by_grade(grade)
    
    if part.slot != 'rleg' then

        for i=1, #depot_entry.distribution do
            part[depot_entry.distribution[i]] = dist[i]
        end
    end
    --stats end

    --sprites start
    part.s_pos = depot_entry.s_pos
    part.ani_x = 0
    part.ani_y = 0

    if part.slot == "frame" then
        part.joints = depot_entry.joints
        part.anchor = depot_entry.anchor
    end

    part.px_off = part.s_pos[1] - depot_entry.anchor[1]
    part.py_off = part.s_pos[2] - depot_entry.anchor[2]

    if part.slot != "frame" then
        part.px_off += (frame.s_pos[1] - frame.anchor[1]) - (frame.s_pos[1] - frame.joints[part.slot][1])
        part.py_off += (frame.s_pos[2] - frame.anchor[2]) - (frame.s_pos[2] - frame.joints[part.slot][2])
    end
    --sprites end

end


function robo_update_stats(target)
    for key, value in pairs(target.parts) do
        local part = target.parts[key]
        target.hp += part.hp
        target.str += part.str
        target.def += part.def
        target.spd += part.spd
        target.chrg += part.chrg
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
        target.pos_x, target.pos_y = 44, 48
    else
        flipx = false
        target.pos_x, target.pos_y = 84, 48
    end

    
    part_sprite(target.parts.rarm, target.pos_x, target.pos_y, flipx)
    part_sprite(target.parts.rleg, target.pos_x, target.pos_y, flipx)
    part_sprite(target.parts.frame, target.pos_x, target.pos_y, flipx)
    part_sprite(target.parts.head, target.pos_x, target.pos_y, flipx)
    
    line(
        target.pos_x + target.parts.larm.px_off,
        target.pos_y + target.parts.larm.py_off + 7,
        target.pos_x + target.parts.larm.px_off - target.parts.larm.ani_x,
        target.pos_y + target.parts.larm.py_off + target.parts.larm.ani_y + 7,
        4)
    line(
        target.pos_x + target.parts.larm.px_off + 1,
        target.pos_y + target.parts.larm.py_off + 7,
        target.pos_x + target.parts.larm.px_off - target.parts.larm.ani_x + 1,
        target.pos_y + target.parts.larm.py_off + target.parts.larm.ani_y + 7,
        4)
    --below is close, seems that the current y setting gets to our joint
    --line(5,5,target.pos_x + target.parts.larm.px_off - target.parts.larm.ani_x, target.pos_y + target.parts.larm.py_off + target.parts.larm.ani_y,10)
    
    part_sprite(target.parts.larm, target.pos_x, target.pos_y, flipx)
    part_sprite(target.parts.lleg, target.pos_x, target.pos_y, flipx)
end
    

function part_sprite(part, x, y, flipx)
    if flipx == false then
        sspr(
            part.s_pos[1],
            part.s_pos[2], 
            part.s_pos[3], 
            part.s_pos[4], 
            x + part.px_off + part.ani_x,
            y + part.py_off + part.ani_y, 
            part.s_pos[3], 
            part.s_pos[4]
        )
    end
    if flipx == true then
        --pq(part)
        --to understand 5th arg: (s_pos - anchor) = pixels away from top left corner. Results in negative number
        --normally by adding this, you offset the pixels so that the targetted anchor is where x,y is provided
        --but because of the xflip, the anchor moves too. Because we know the sprite dimensions though,
        --we can find the right most edge and move left from there instead, so subtract the anchor.
        sspr(
            part.s_pos[1],
            part.s_pos[2],
            part.s_pos[3], 
            part.s_pos[4],
            x - part.px_off - part.ani_x,
            y + part.py_off + part.ani_y, 
            -part.s_pos[3], 
            part.s_pos[4]
        )
    end
end

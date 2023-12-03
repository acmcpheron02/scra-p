pico-8 cartridge // http://www.pico-8.com
version 39
__lua__

#include pancelor_debug.p8
#include player.p8
#include enemy.p8
#include managers.p8
#include ui.p8
#include parts.p8

game_states = {title, combat}
game_state = nil

--definitions
parti = { "frame", "head", "larm", "rarm", "legs"}

function _init()
    printh("\n\n Fresh Run")
    game_state = title
end

function _update60()
    game_state.state_update();
end

function _draw()
    game_state.state_draw();
end

--title definitions--
title = {}

function title.state_update()
    if btnp(4) then combat.init() end
end

function title.state_draw()
    cls(1)
    --title_ui()
    local frame = pdepot.frame1
    local head = pdepot.head1
    local larm = pdepot.arm1
    local rarm = pdepot.arm1
    local posx = 64
    local posy = 52
    -- sspr(frame.s_pos[1],frame.s_pos[2],frame.s_pos[3],frame.s_pos[4],posx,posy)
    -- pset(frame.joints.head[1]+posx-frame.s_pos[1], frame.joints.head[2]+posy-frame.s_pos[2], 7)
    -- pset(frame.joints.arm[1]+posx-frame.s_pos[1], frame.joints.arm[2]+posy-frame.s_pos[2], 7)
    -- sspr(head.s_pos[1],head.s_pos[2],head.s_pos[3],head.s_pos[4],posx+,posy)
    -- sspr(frame.s_pos[1],frame.s_pos[2],frame.s_pos[3],frame.s_pos[4],posx-p_xoff(frame),posy-p_yoff(frame))
    -- sspr(head.s_pos[1],head.s_pos[2],head.s_pos[3],head.s_pos[4],posx - j_xoff(frame, 'head')-p_xoff(head),posy - j_yoff(frame, "head")-p_yoff(head))
    -- pset(64, 52, 7)
    p_spr(larm, 58, 63, false)
    p_spr(rarm, 70, 63, true)
    p_spr(frame, 64, 70, false)
    p_spr(frame, 64, 70, true)
    p_spr(head, 64, 60, false)
    p_spr(head, 64, 60, true)
    --p_spr(rarm, 64, 60, true)

end

--combat definitions--
combat = {}

function combat.init() 
    player:robo_update_stats()
    enemy:robo_update_stats()
    cm:new(cm, player, enemy)
    game_state = combat
end

function combat.state_update()
    cm:update()
    
end

function combat.state_draw()
    cls()
    combat_ui()
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00aa00000000444400000a00000004440000000aaaa4444400044444440000000000000000000000000033300000000000000000000033300000000000000000
00aaa0000444444400000aa0000044440000aaaa4444444400044444444400000000000000000000000333330033330000000000000033330000000000000000
000aa0044444444400000aaa0000444400aaaa444444444400044004444444000000333300000000003333330333333000000000000333330000000000000000
000aaa044444444400000aaaa04444440aa0044444444444000a0004444444440003333330000000003333333333333300000000003303330000000000000000
0000aaa44444aa4400000aaaaa444444aa000444444aa444000a0000444444440033333333000000033333303333333300000000033003300000000000000000
00000aa44444aa4400000aa444444a44a00004444aaaaaa4000a0000444a44440033333333000000333330003333333300000000330033000000000000000000
000000444444444400000aa44444aaa4a00044444444444400aaa000444aa4440033333333000000333300000333333300000003300330000000000000000000
000000444444444400000aa444444a440000444444444444000a000444aaa44400333b3333330003333300000033333330000033003300000000000000000000
0000004444444aa4000000a4444444440000444444444444000000044aaaa444003333b333333333333300000000330033000330033000000000000000000000
0000004444444aaa000000aa444444440000444444444444000000044444444a0003333b33333333333000000000033003303300330000000000000000000000
00000444444444aa0000000aa44444440000444444a44aaa000000044444444a0000033333333333333000000000003300303003300000000000000000000000
000004444444444400000000aa444aaa00004444444aaa4400000004444444aa0000000333333333b30000000000000330777033000000000000000000000000
0000000004444444000000000aa4444400004444444444440000000044444aaa000000000333b333b30000000000000033777330000000000000000000000000
00000000004444440000000000004444000004444444444400000000444444aa00000000000333bb330000000000000003777300000000000000000000000000
00000000004444440000000000000444000000444444444400000000044444440000000000000333300000000000000000000000000000000000000000000000
00000000000044440000000000004444000000044444444400000000044444440000000000000003300000000000000000000000000000000000000000000000
000000000000000e0002222222000000222000000000000000000000000000000000000000000ccd000000000000000000000000000000000000000000000000
00000222200000ee02eeeeeee22200002e220000000000000222222222222222000000000000cccd000000000000000000000000000000000000000000000000
000022222222eeee00022eeeee2220002ee220000002222202eeeeeeeeee2222000000000000ccdc000000000000000000000000000000000000000000000000
0000222222eeeeee0000002eee2222222ee222000022eeee02e22222eeeeeee200000000000cccdc000000000000000000000000000000000000000000000000
0002222222eeeeee0000000222222e222eee2222222eeeee02eeeee2e22ee2e200000000000cccdc000000000000000c00000000000000000000000000000000
0022222222eee22200000002222222ee22eeeeeeeeeeeeee02ee22eeeeeee2e20000000000cccdcc0000000000000ccc00000000000000000000000000000000
00222222222ee22200000002222e2222022eeeeeeeeeeeee02222222e22eeee2000000000ccccdcc00000000000ccddc00000000000000000000000000000000
00000022222ee222000000002222ee220022222eeee2222200000022ee2eeee200000000dccccdcc000000000ccddddc00000000000000000000000000000000
00000002222ee22e00000000222222ee000222222222222e000000222eeee2e20000000ddcccdcc000000000cddddddc00000000000000000000000000000000
00000000222ee2ee0000000022ee222200000002222222ee000000222eeee2e2000000dddcccdcc0000000ccddddddc000000000000000000000000000000000
00000000222eeee2000000002222ee22000000002222222e000000222eeee2e200000ddddcccdcc00000ccdddddddc0000000000000000000000000000000000
00000000222ee2ee00000000022222ee0000000002222222000000222e2ee2e20000dddddccdcc00000cddddddddc00000000000000000000000000000000000
00000000222ee22e00000000022222220000000002eeeeee000000222ee2e2e20000dddddccdcc00000ccccccddc000000000000000000000000000000000000
00000000222ee22200000000002222220000000002eeeeee0000002eeee2e2ee0000dddddccdc000000cddddcdc0000000000000000000000000000000000000
00000000222ee222000000000022222200000000022eeeee000000eeeee2e2ee0000dddddcdcc000000cddddcc00000000000000000000000000000000000000
0000000222eee22200000000002222ee000000000022eeee000000eeeee2e2ee00000ddddcdc0000000cddddc000000000000000000000000000000000000000
000000022eeeee2200000000022eeeee0000000220022eee000000eeeeeee2ee00000dddddcc000000cddddddc00000000000000000000000000000000000000
000000222eeeeee2000000002222eeee00000002220e2eee000000eeeeeee2ee00000dddddcc000000cddddddc00000000000000000000000000000000000000
00000022eeeeeeee00000002e2222eee00000002222e2eee0eeeeeeeeeeeeeee00000dddddcc000000cddddddc00000000000000000000000000000000000000
000000eeeeeeeeee0000002eee2222ee00000000222222ee0eeeeeeeeeeeeeee00000ddddccc000000cddddddc00000000000000000000000000000000000000
000000eeeeeeeeee000002eeeee2222e00000000222222220eeeeeeeeeeeeeee00000ddddccc000000cddddddc00000000000000000000000000000000000000
000000eeeeeeeeee00002eeee222222200000000022222220eeeeeeeeeeeeeee00000ddddcc0000000cddddddc00000000000000000000000000000000000000
000000eeeeeeeeee0002eeee2002eeee00000000002222ee0eeeeee00000000000000ddddcc0000000cddddddc00000000000000000000000000000000000000
000000eeeeeeeeee002eee200002eeee0000000000022eee0eeeeee000000000000000dddcc0000000cdddddddc0000000000000000000000000000000000000
0000000eeeeeeeee02ee200000002eee0000000000000eee0000000000000000000000dddcc000000cddddddddc0000000000000000000000000000000000000
0000000eeeeeeeee0220000000002eee0000000000000eee0000000000000000000000dcdcc000000cddddddddc0000000000000000000000000000000000000
00000000eeeeeeee00000000000002ee00000000000000ee0000000000000000000000dcdccc00000cddddddddc0000000000000000000000000000000000000
0000000000eeeeee00000000000002ee00000000000000ee000000000000000000000cccdccc00000cddddddddc0000000000000000000000000000000000000
00000000000eeeee000000000000002e000000000000000e0000000000000000dd00ccccdcccc0000cddddddddc0000000000000000000000000000000000000
0000000000000000000000000000002e00000000000000000000000000000000dcccccccdcccc00000cddddddc00000000000000000000000000000000000000
0000000000000000000000000000000200000000000000000000000000000000dccccddddddddd0000cddddddc00000000000000000000000000000000000000
0000000000000000000000000000000200000000000000000000000000000000dddddddddddddd00000cccccc000000000000000000000000000000000000000

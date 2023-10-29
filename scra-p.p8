pico-8 cartridge // http://www.pico-8.com
version 39
__lua__

#include pancelor_debug.p8
#include player.p8
#include enemy.p8
#include managers.p8
#include ui.p8

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
    cls()
    title_ui()
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
0022e0000000022222080220000200002222a920000e0000222222200e0000e0ee9999ee0000004949e99e940000000000000000000000000000000000000000
00022e00000ee200208a802000282000200aa9200222220024000a209e9999e9e944e49e0000049e49e00e940000000000000000000000000000000000000000
eeeeeee00ee7e200080a08000088800020aa9020220002200240a20094444449994e7e9900004999449009440000000000000000000000000000000000000000
00022e00222222008aa9aa80008880002aa9002020000020002a200094b44b490944e49000009944049009400077700000000000000000000000000000000000
0022e00099999900080a0800008a80002aaaa9202007aa20024a0200944444490944449000049440049009400077700000000000000000000000000000000000
0000000022222200208a8020208a802020aa9020200a0020240aa020947777490944449000999940ee9009ee0777700000000000000000000000000000000000
0000000000ee220022080220022a22002aa90020220a022024aaaa20994774999ee44ee9009ee900999009990770000000000000000000000000000000000000
00000000000e222200000000000a00002a92222002222200222222200e9999e099e99e9900900900999009997000000000000000000000000000000000000000
00222000000000003330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02eed20000a88000003cc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2ed000200a888800003c7cc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2d0000200a8888000033333300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2d0000200888880000bbbbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02000200008880000033333300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00222000000000000033cc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000003333c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999909
09999999999999999999999999999999999999999999999999994999999999999999999999999999999999999999999999999949999999999999999999699999
44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
44444444444444444444444444444444444444444444444444464444444444444444444444444444444444444444444444444444444444444444444444444444
66066666666666666666666666666666666646666666666666666666666666666666666666666666666666666666666466666666666666666666666666666666
66666666666666666666666666666666666666666666666666666666666666666666666666666666646666666666666666666666666646666666666466666666
66666666666666666666666666664666666666666666666666666666666646666666666666666666666666666666666666666666666666666666666466666666
66646666666666f4ffffff6666666666666666666666666666666666666666666666666666666666666666666666666666666666fffffffffff6666666664666
666666666666fffffffffff666666666666666466666666666666666666666666666646666666666666666646666646666666666fffff6ffffff466666666666
66666666646fffffffffffff66666666666666666666666666666646666666666666666666666666666666666666666666666666ffffffffffffff6666664666
6666666666ffffffff46fffff6466646666666666666666666666666666666666666666666666666666666666666666466666666fffffffff4fffff666664666
6666666666fffffffff4ffff4466666666666666666666666666666666666666666666666666666666664666666666666666666ffffffffffffff4f466666666
6666466664fffffff444fff444466666666fffff66666666ff4ff6666fff46666666ffffff66ffffff666666666666666666666ff4fffffff4fffff466666666
666666666fffffff444fff44444466666fff4fffff466666ffffff6f6fff446666f4fffffff6ffffff466466666666666666666ffffff444fffffff446666666
666666666fffffff4444f4444446666ffffffffffff46666ffffffffffff44466fffffffffffffffff446666666466666666666fffff44444ffffff446666666
666666666f4ffffff4444444446666ff6fffff6fffff4666ffffffff4fff4444f6ffffffffffffffff44466666666666666666ffffff44444ffffff444666466
666666666ffffffffff4644446666ffffff6fffffff44466fffffffffff4444fffff4f4ffffffffff444446666666666666666ffffff44444ffffff444666666
6664666646fffffffffff64466646fffffffffffff44446fffffffffff6444fffffffffff4f4ff4ff444466666664646666666fffffff444fff64f4444666666
66666666664f44ffffff6f666646ffffffff4444f444446ffffffffffff4444ff6fff444fffffff6f4444fffffffffff4466666fffffffffffffff4444666666
666666666666fffffffffff46664fffffff444444444466fffffff44444446ffffff44444ffffff6f4444ffffffffffff4466ffff4ffffff6f4fff4446666466
6466666646664ffffffffff4466fffffff4444666464666ffff6f64444644fffffff44444ffffffff4446ffffff4fffff4446ffffffffffff4fff44444666646
6446666666f664ffffffff4f466ff4ffff4444666666666ffffff46444444fffff6f44446fffffff4444ff6fffffffff44446fff4ff6ffffffff444446666666
666666666ff466446fffffff446fffffff644466666664ffff6ff44446666fffffff44466fff6fff4444fffffff4f6ff464466ff6f4fffffff44444466666666
66666666ff6ff644fffff6ff446fffffff444466666666ffff6ff44446666ffffffff446ffffffff4444ffffffffffff4446ffffffffffff4444444466666466
6666666fffffffff4fffffff446ffffff6f464f66666646ffffff44466666fff4fffffff4f6fff6f44446444446444444446ffffffff44444444444666666666
666666fffff4fffffffff4f44466fffffffff6ff666666ff4fff444466666fffffffffffffffffff44466644444444444446ffffffff44444444466666666666
666666ff4ffffffffffffff46466fff6fffffffff66666ffffff4444666666ffffffffffffffffff44464666666666646666fffffff444444466466646666666
6666666ff6ffffffffffff4464664fffffffff6fff4666ffffff4444666666ffffffffffffffff644446666666666666666ffffffff464446646666666666666
66666664f66fffffffff6444466664ff6ffffffff4446fffffff44466666666ff6ffffff4ffffff44446666666666666466ffffffff446666666666666666666
666666664ffffffffff444444666464ffffff4f444446ffffff4444666666666fffffff44ffffff44446666666666466666ffffffff444666666666666666666
66466666644444444444444466466664444444444444644444444446666666666444444444446444446666666666666666664444444444666666666666666466
66666666666444444444444666666666444444444446664444444446666466666644444444444444446646666666666666666444444446666666666646666666
66666666666664444444466666666666644444444466666444444446666666666666444444644444446666666666666666666644444444666666646666666666
66666646666666666666666666666666666664666666666666666666666666666666666666666666666666666666666666666666666664666666666666666666
66666666666666666666666666666666666666666666666466666666666666666666666666666666666666666666666666666646666666666666666666666666
60666666666666666666666666666666666646666666666666666666666666666666666666666666666666666666666666666646666666666666666646666666
09996999949999999999999999996999994999999999969999999999999999996999499999999999999949999999999499499999969999999999949999999999
99999999999999999999999999969999999999999999999999999999499999996999999999999999999999999499999999499999994999999999999999999999
44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
44444444444444444000444444444444444044440444444444444444444444444444444444444444444044444444440444444444444444444044444444404444

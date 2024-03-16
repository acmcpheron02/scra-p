pico-8 cartridge // http://www.pico-8.com
version 39
__lua__

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

function print_xcen(str,x,y,c)
    print(str, x-#str*2,y,c)
end

function dist_by_grade(grade)
    local dist = {}
    for i=1,7 do
        dist[i] = flr(grade*2.5 + rnd(grade*2))
    end
    --pq(dist)
    for i=1,#dist do
        local j = i
        while j > 1 and dist[j-1] < dist[j] do
            dist[j],dist[j-1] = dist[j-1],dist[j]
            j = j - 1
        end
    end
    --pq(dist)
    return dist
end
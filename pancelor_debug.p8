pico-8 cartridge // http://www.pico-8.com
version 39
__lua__

-- quote a single thing
-- like tostr, but for tables
function quote(t, sep)
  if type(t)~="table" then
    return tostr(t)
  end

  local s="{"
  for k,v in pairs(t) do
    s..=tostr(k).."="..quote(v)
    s..=sep or ","
  end
  return s.."}"
end

-- quotes all arguments
-- usage:
--   ?qq("p.x=",x,"p.y=",y)
function qq(...)
  local args=pack(...)
  local s=""
  for i=1,args.n do
    s..=quote(args[i]).." "
  end
  return s
end
function pq(...)
  printh(qq(...))
end

-- like sprintf (from c)
-- usage:
--   ?qf("%/% is %%",
--        3,8,3/8*100,"%")
function qf(format,...)
  local args=pack(...)
  local s=""
  for ix=1,#format do
    local code=ord(format,ix)
    if code==37 then --%
      s..=quote(deli(args,1))
    else
      s..=chr(code)
    end
  end
  if #args>0 then
    s..="(moreqf:"..#args..")"
  end
  return s
end
function pqf(...)
  printh(qf(...))
end

-- quotes an array
--   qq returns "{1=foo,2=bar}"
--   but sometimes you want
--   "{foo,bar}" instead
function qa(arr, sep)
  local s="{"
  for v in all(arr) do
    s..=quote(v)..(sep or ",")
  end
  return s.."}"
end
function pqa(arr, sep)
  printh(qa(arr,sep))
end

function pqx(num)
  pq(tostr(num,1),"(",num,")")
end
function pqb(num,...)
  pq(tobin(num,...),"(",num,")")
end

-- hi: how many above-radix bits
--   to print (>=0, default 8)
-- lo: how many below-radix bits
--   to print (>=0, default 0)
function tobin(num, hi,lo)
  local s="0b"
  hi=hi or 8
  lo=lo or 0
  for ix=hi-1,-lo,-1 do
    if ix==-1 then
      s..="."
    elseif ix%8==7 then
      s..="_"
    end
    s..=num>>>ix&1
  end
  return s
end

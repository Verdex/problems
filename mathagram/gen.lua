
function rev(l)
    local ret = {}
    for k, v in ipairs(l) do
        ret[(#l - k) + 1] = v
    end
    return ret
end

function any(l, pred)
    for _, k in ipairs(l) do
        if pred(k) then
            return true
        end
    end
    return false
end

function forall(l, pred)
    for _, k in ipairs(l) do
        if not pred(k) then
            return false
        end
    end
    return true
end

function map(l, t)
    local ret = {}
    for _, k in ipairs(l) do
        ret[#ret+1] = t(k)
    end
    return ret
end

function filter(l, pred)
    local ret = {}
    for _, k in ipairs(l) do
        if pred(k) then
            ret[#ret+1] = k
        end
    end
    return ret
end

function determine_tier(env)
    local keys = {}
    local left_count = 0
    local right_count = 0
    for k,_ in pairs(env) do
        if string.sub(k, 1, 1) == 'l' then
            left_count = left_count + 1
        end
        if string.sub(k, 1, 1) == 'r' then
            right_count = right_count + 1
        end
    end
    if left_count == 6 and right_count == 3 then 
        return 1
    elseif left_count == 12 and right_count == 6 then
        return 2
    elseif left_count == 15 and right_count == 12 then
        return 3
    else
        error("unknown tier encountered")
    end
end

function avail_from_env(env)
    local used = {}
    for _, v in pairs(env) do
        if v ~= 0 then
            used[#used+1] = v
        end
    end
    local tier = determine_tier(env)
    local pool = {} 
    if tier == 1 then
        pool = { 1, 2, 3, 4, 5, 6, 7, 8, 9 }
    elseif tier == 2 then
        pool = { 1, 2, 3, 4, 5, 6, 7, 8, 9 , 
                 1, 2, 3, 4, 5, 6, 7, 8, 9 }
    elseif tier == 3 then
        pool = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 
                 1, 2, 3, 4, 5, 6, 7, 8, 9, 
                 1, 2, 3, 4, 5, 6, 7, 8, 9 }
    end
    local avail = filter(pool, function (p) return forall(used, function(u) return u ~= p end) end )
    return "{" .. table.concat( avail, ", " ) .. "}" 
end

local symbol_count = 0
function gensym(prefix)
    prefix = prefix or ''
    local ret = prefix .. '_gensym_' .. symbol_count
    symbol_count = symbol_count + 1
    return ret
end

function comprehension(output, generators, predicate)
    local loop = [[
for _, %s in ipairs(%s) do
%s
end]]
    local terminal = [[
if %s then
%s[#%s + 1] = %s
end]]

    local output_symbol = gensym("output")

    local loops = string.format(terminal, predicate, 
                                          output_symbol,
                                          output_symbol,
                                          output)
    for _, g in ipairs(rev(generators)) do
        loops = string.format( loop, g.name, g.gen, loops ) 
    end

    local wrap = [[
(function() 
local %s = {}
%s
return %s 
end)()]]

    return string.format( wrap, output_symbol, loops, output_symbol ) 
end


local z = comprehension("ikky", { {name = "blarg"; gen = "{1,2,3}"  } 
                                  , {name = "ikky"; gen = "{4,5,6}" } }, "true") 


function solve(env) 
    local filter_code = [[
function filter(l, pred)
    local ret = {}
    for _, k in ipairs(l) do
        if pred(k) then
            ret[#ret+1] = k
        end
    end
    return ret
end

]]

    local avail_code = string.format( [[
avail = %s

]], avail_from_env(env) )

    local pre_defined = {}
    local variables = {}
    for k, v in pairs(env) do
        if v ~= 0 then
            pre_defined[#pre_defined+1] = {name=k, value=v}
        else
           variables[#variables+1] = k 
        end
    end

    local constants_list = map(pre_defined, function(c) return c.name .. " = " .. c.value end)
    local constants_code = table.concat( constants_list, "\n" )

    local lhs_ones = filter(variables, function (v) return string.sub(v, 1, 1) == 'l' 
                                                       and string.sub(v, -5, -3) == 'one' end )
    local lhs_tens = filter(variables, function (v) return string.sub(v, 1, 1) == 'l' 
                                                       and string.sub(v, -5, -3) == 'ten' end )
    local lhs_huns = filter(variables, function (v) return string.sub(v, 1, 1) == 'l' 
                                                       and string.sub(v, -5, -3) == 'hun' end )
    local rhs_ones = filter(variables, function (v) return string.sub(v, 1, 1) == 'r' 
                                                       and string.sub(v, -5, -3) == 'one' end )
    local rhs_tens = filter(variables, function (v) return string.sub(v, 1, 1) == 'r' 
                                                       and string.sub(v, -5, -3) == 'ten' end )
    local rhs_huns = filter(variables, function (v) return string.sub(v, 1, 1) == 'r' 
                                                       and string.sub(v, -5, -3) == 'hun' end )


    return filter_code 
        .. avail_code
        .. constants_code
end

local output = solve { lhs_hun_1 = 1
      , lhs_ten_1 = 0
      , lhs_one_1 = 0
      , lhs_hun_2 = 0
      , lhs_ten_2 = 0
      , lhs_one_2 = 0
      , rhs_hun_1 = 4
      , rhs_ten_1 = 6
      , rhs_one_1 = 8
      }

print(output)
--[[

emit filter 

avail = emit avail from env

forall env
    if field is already defined then
        create variable to hold defined value

if lhs_one_1 already exists then emit nothing
if any rhs versions exist then emit 
lhs_one_1_gen() =
    avail = avail filtered such that it will be less than the sum of already defined rhs versions (can optimize by - 1 per undefined rhs version, also subtract any already defined lhs versions)
    
    return avail

if any lhs versions exist AND no rhs versions exist then emit 
lhs_one_1_gen() =
    avail = avail filtered such that it will be less than the number of undefined rhs versions (also subtract any already defined lhs versions)
    
    return avail
        
lhs_one_2_gen(lhs_one_1) =
...
    
     

solutions = [ lhs_hun_1 ... rhs_one_n 
              | 
              lhs_one_1 <- lhs_one_1_gen() -- do not create generator variable if it's a const
              lhs_one_2 <- lhs_one_2_gen(lhs_one_1)
              ...
              |
              lhs_hun_1 * 100 + lhs_ten_1 * 10 + lhs_one_1 +
              ...
              == 
              rhs_hun_1 * 100 + rhs_ten_1 * 10 + rhs_one_1 + 
              ...
            ]

print( solutions )
--]]

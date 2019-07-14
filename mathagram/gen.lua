
function append(a, b)
    local ret = {}
    for _, v in ipairs(a) do
        ret[#ret+1] = v
    end
    for _, v in ipairs(b) do
        ret[#ret+1] = v
    end
    return ret
end

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


function one_gen(target, deps, ones, var_count)
    local gen_name = gensym(target .. '_one_gen')
    if #deps == 0 then
        return gen_name, string.format([[
function %s() 
    return avail
end
]], gen_name)
    end
    local deps_code = table.concat(deps, ", ")
    local and_code = table.concat( map(deps, function (d) return d .. " ~= a" end), " and " )

    if #deps == var_count - 1 then
        local r = filter(ones, function (o) return string.sub(o, 1, 1) == 'r' end)
        local l = filter(ones, function (o) return string.sub(o, 1, 1) == 'l' end)
        if string.sub(target, 1, 1) == 'l' then
            l = filter(l, function(x) return x ~= target end)
            l[#l+1] = 'a' 
        else
            r = filter(r, function(x) return x ~= target end)
            r[#r+1] = 'a' 
        end
        and_code = "(" .. table.concat(l, " + ") .. ") % 10"
                 .. " == "
                 .. "(" .. table.concat(r, " + " ) .. ") % 10"
        
    end

    local format = [[
function %s(%s)
    local ret = filter(avail, function(a) return %s end)
    return ret 
end
]]

    return gen_name, string.format(format, 
                                   gen_name,
                                   deps_code,
                                   and_code)
end

function ten_gen(target, deps, tens, ones, var_count)
    local gen_name = gensym(target .. '_ten_gen')
    local deps_code = table.concat(deps, ", ")
    local and_code = table.concat( map(deps, function (d) return d .. " ~= a" end), " and " )

    if #deps == var_count - 1 then
        local r = filter(tens, function (o) return string.sub(o, 1, 1) == 'r' end)
        local l = filter(tens, function (o) return string.sub(o, 1, 1) == 'l' end)
        if string.sub(target, 1, 1) == 'l' then
            l = filter(l, function(x) return x ~= target end)
            l[#l+1] = 'a' 
        else
            r = filter(r, function(x) return x ~= target end)
            r[#r+1] = 'a' 
        end
        local r_ones = filter(ones, function(o) return string.sub(o, 1, 1) == 'r' end)
        local l_ones = filter(ones, function(o) return string.sub(o, 1, 1) == 'l' end)
        and_code = "(((" .. table.concat(l, " + ") .. ") * 10) + (" 
                 .. table.concat(l_ones, " + ") .. ")) % 100"
                 .. " == "
                 .. "(((" .. table.concat(r, " + " ) .. ") * 10) + ("
                 .. table.concat(r_ones, " + ") .. ")) % 100"
        
    end

    local format = [[
function %s(%s)
    local ret = filter(avail, function(a) return %s end)
    return ret 
end
]]

    return gen_name, string.format(format, 
                                   gen_name,
                                   deps_code,
                                   and_code)
end

function hun_gen(target, deps, huns, tens, ones, var_count)
    local gen_name = gensym(target .. '_hun_gen')
    local deps_code = table.concat(deps, ", ")
    local and_code = table.concat( map(deps, function (d) return d .. " ~= a" end), " and " )

    local format = [[
function %s(%s)
    local ret = filter(avail, function(a) return %s end)
    return ret 
end
]]

    return gen_name, string.format(format, 
                                   gen_name,
                                   deps_code,
                                   and_code)
end

function solve(env) 
    local tier = determine_tier(env)

    local filter_code = [[
function sum(l)
    local ret = 0
    for _, v in ipairs(l) do
        ret = ret + v
    end
    return ret
end

function predicate(l_hun, r_hun, l_ten, r_ten, l_one, r_one)
    local l_tot = (sum(l_hun) * 100) + (sum(l_ten) * 10) + sum(l_one)
    local r_tot = (sum(r_hun) * 100) + (sum(r_ten) * 10) + sum(r_one)
    return l_tot < 1000 and r_tot < 1000 and l_tot == r_tot
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
    local constants_code = table.concat( constants_list, "\n" ) .. "\n\n"

    local ones_var = filter(variables, function (v) return string.sub(v, -5, -3) == 'one' end)
    local tens_var = filter(variables, function (v) return string.sub(v, -5, -3) == 'ten' end)
    local huns_var = filter(variables, function (v) return string.sub(v, -5, -3) == 'hun' end)

    local ones = append(ones_var, filter(map(pre_defined, 
                                             function (p) return p.name end),
                                         function (v) return string.sub(v, -5, -3) == 'one' end))
    local tens = append(tens_var, filter(map(pre_defined, 
                                             function (p) return p.name end),
                                         function (v) return string.sub(v, -5, -3) == 'ten' end))
    local huns = append(huns_var, filter(map(pre_defined, 
                                             function (p) return p.name end),
                                         function (v) return string.sub(v, -5, -3) == 'hun' end))
    
    local dep = {}
    local generators_code = {}
    local generator_names = {}
    for _, v in ipairs(ones_var) do
        local gen_name, gen_code = one_gen(v, dep, ones, #ones_var)
        dep[#dep+1] = v
        generators_code[#generators_code+1] = gen_code 
        generator_names[#generator_names+1] = gen_name
    end

    for _, v in ipairs(tens_var) do
        local gen_name, gen_code = ten_gen(v, dep, tens, ones, #tens_var + #ones_var)
        dep[#dep+1] = v
        generators_code[#generators_code+1] = gen_code 
        generator_names[#generator_names+1] = gen_name
    end

    for _, v in ipairs(huns_var) do
        local gen_name, gen_code = hun_gen(v, dep, huns, tens, ones, #huns_var + #tens_var + #ones_var)
        dep[#dep+1] = v
        generators_code[#generators_code+1] = gen_code 
        generator_names[#generator_names+1] = gen_name
    end

    local gens = {}
    local stage_two_deps = {}
    for i = 1, #dep do
        gens[#gens+1] = { name = dep[i]; 
                          gen = generator_names[i] .. "(" .. table.concat(stage_two_deps, ", ") ..  ")" }
        stage_two_deps[#stage_two_deps+1] = dep[i]
    end

    local output_params = map(append( append( huns, tens), ones ), 
                              function (x) return string.format("['%s'] = %s", x, x) end )

    local l_one = filter(ones, function(x) return string.sub(x, 1, 1) == 'l' end)
    local r_one = filter(ones, function(x) return string.sub(x, 1, 1) == 'r' end)
    local l_ten = filter(tens, function(x) return string.sub(x, 1, 1) == 'l' end)
    local r_ten = filter(tens, function(x) return string.sub(x, 1, 1) == 'r' end)
    local l_hun = filter(huns, function(x) return string.sub(x, 1, 1) == 'l' end)
    local r_hun = filter(huns, function(x) return string.sub(x, 1, 1) == 'r' end)

    local pred_code = "predicate( {" .. table.concat( l_hun, ", " ) .. "}, "
                   .. "{" .. table.concat( r_hun, ", " ) .. "}, "
                   .. "{" .. table.concat( l_ten, ", " ) .. "}, "
                   .. "{" .. table.concat( r_ten, ", " ) .. "}, "
                   .. "{" .. table.concat( l_one, ", " ) .. "}, "
                   .. "{" .. table.concat( r_one, ", " ) .. "} )"

    local comp_code = "local solution = " 
                    .. comprehension( "{" .. table.concat( output_params, ", " ) .. "}",
                                      gens,
                                      pred_code )

    local print_code = [[

for _, v in ipairs(solution) do
    for k, v in pairs(v) do
        print(k, v)
    end
    print( "\n" )
end
]]

    return filter_code 
        .. avail_code
        .. constants_code
        .. table.concat(generators_code, "\n")
        .. comp_code
        .. print_code
end

--[[local output = solve { lhs_hun_1 = 1
      , lhs_ten_1 = 0
      , lhs_one_1 = 0
      , lhs_hun_2 = 0
      , lhs_ten_2 = 0
      , lhs_one_2 = 0
      , rhs_hun_1 = 4
      , rhs_ten_1 = 6
      , rhs_one_1 = 8
      } --]]

local output = solve { lhs_hun_1 = 0
                     , lhs_ten_1 = 0
                     , lhs_one_1 = 0
                     , lhs_hun_2 = 0
                     , lhs_ten_2 = 0
                     , lhs_one_2 = 0
                     , lhs_hun_3 = 5
                     , lhs_ten_3 = 0
                     , lhs_one_3 = 3
                     , lhs_hun_4 = 1
                     , lhs_ten_4 = 2
                     , lhs_one_4 = 3
                     , rhs_hun_1 = 0
                     , rhs_ten_1 = 0
                     , rhs_one_1 = 0
                     , rhs_hun_2 = 7
                     , rhs_ten_2 = 9
                     , rhs_one_2 = 5
                     }
    
print(output)



function rev(l)
    local ret = {}
    for k, v in ipairs(l) do
        ret[(#l - k) + 1] = v
    end
    return ret
end

function avail_from_env(env)
    
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

function solve(env, tier) 

end

load("local x = " .. z .. [[

for _,v in ipairs(x) do
print(v)
end
]])()


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

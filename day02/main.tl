local input = io.read("*a")

local function work(n: integer, m: integer)
    
end

input:gsub("(%d*)%-(%d*)%,?", function(n: string, m: string) work(tonumber(n) as integer, tonumber(m) as integer) end)

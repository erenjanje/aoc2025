local input = io.read("*a")

local sum = 0

local function part1(n: integer, m: integer)
    for i=n,m do
        local str = tostring(i)
        if #str % 2 == 0 and str:sub(1, #str // 2) == str:sub(#str // 2 + 1, #str) then
            sum = sum + i
        end
    end
end

input:gsub("(%d*)%-(%d*)%,?", function(n: string, m: string) part1(tonumber(n) as integer, tonumber(m) as integer) end)
print(sum)

local input = io.read("*a")

local sum = 0

local FACTORS <const>: {{integer}} = {
    [1] = {},
    [2] = {1},
    [3] = {1},
    [4] = {1, 2},
    [5] = {1},
    [6] = {1, 2, 3},
    [7] = {1},
    [8] = {1, 2, 4},
    [9] = {1, 3},
    [10] = {1, 2, 5},
    [11] = {1},
    [12] = {1, 2, 3, 4, 6},
    [13] = {1},
    [14] = {1, 2, 7},
    [15] = {1, 3, 5},
    [16] = {1, 2, 4, 8},
}

local invalids: {integer: boolean} = {}

local function fast(ns: string, ms: string)
    if #ns ~= #ms then
        fast(ns, ("9"):rep(#ns))
        for i=#ns+1,#ms-1 do
            fast("1" .. ("0"):rep(i), ("9"):rep(i + 1))
        end
        fast("1" .. ("0"):rep(#ms - 1), ms)
        return
    else
        local n, m = tonumber(ns) as integer, tonumber(ms) as integer
        local length = #ns -- #ns == #ms due to the else
        for _,prefix_length in ipairs(FACTORS[length]) do
            local low_prefix, high_prefix = tonumber(ns:sub(1, prefix_length)), tonumber(ms:sub(1, prefix_length))
            for prefix=low_prefix,high_prefix do
                local repeated = tonumber(tostring(prefix):rep(length // prefix_length)) as integer
                if n <= repeated and repeated <= m and not invalids[repeated] then
                    invalids[repeated] = true
                    sum = sum + repeated
                end
            end
        end
    end
end

local function slow(ns: string, ms: string)
    local n, m = tonumber(ns) as integer, tonumber(ms) as integer
    for i=n,m do
        local str = tostring(i)
        local length = #str
        for prefix_length=1,(length // 2) do
            if length % prefix_length == 0 then
                local rep = length // prefix_length
                local prefix = str:sub(1, prefix_length)
                local repeated = prefix:rep(rep)
                if repeated == str then
                    sum = sum + i
                    break
                end
            end
        end
    end
end

do
    local start = os.clock()
    for _=1,100 do
        sum = 0
        invalids = {}
        input:gsub("(%d*)%-(%d*)%,?", fast)
    end
    local finish = os.clock()
    print(("Fast took %g"):format((finish - start) / 100.0))
end

print(sum)

do
    local start = os.clock()
    for _=1,10 do
        sum = 0
        invalids = {}
        input:gsub("(%d*)%-(%d*)%,?", slow)
    end
    local finish = os.clock()
    print(("Slow took %g"):format((finish - start) / 10.0))
end

print(sum)

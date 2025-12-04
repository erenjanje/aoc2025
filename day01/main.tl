local enum RotationDirection
    "R"
    "L"
end

local ROTATION <total>: {RotationDirection: integer} = {
    R = 1,
    L = -1,
}

local state = 50
local password = 0

local function tonum(b: boolean): integer
    return b and 1 or 0
end

local function parse_rotation(line: string): integer
    local direction_string, number_string = line:match("([RL])(%d*)")
    local direction = direction_string as RotationDirection
    local rotation = ROTATION[direction] * tonumber(number_string) as integer
    return rotation
end

local function sign(n: number): integer
    if n < 0 then
        return -1
    elseif n > 0 then
        return 1
    else
        return 0
    end
end

for line in io.lines() do
    local rotation = parse_rotation(line)
    local rotation_sign = sign(rotation)
    local rotated = state + rotation
    local old_state = state
    for i=old_state + rotation_sign,rotated,rotation_sign do
        if i % 100 == 0 then
            print(i)
            password = password + 1
        end
    end
    
    state = rotated % 100
    print(old_state, state, rotated, rotation_sign, "\n")
end

print(password)

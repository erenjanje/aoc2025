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

for rotation_input in io.lines() do
    local direction_string, number_string = rotation_input:match("([RL])(%d*)")
    local direction = direction_string as RotationDirection
    local rotation = ROTATION[direction] * tonumber(number_string) as integer

    state = (state + rotation) % 100
    if state == 0 then
        password = password + 1
    end
end

print(password)

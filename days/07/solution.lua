local print = require("common/print-if-enabled")

-- genuinely just going to use the string for this one
function parseInput(inputStr)
    return inputStr
end

function orderedInsertTowardsEnd(list, num, shouldEnforceUniqueness)
    for i = #list, 1, -1 do
        if shouldEnforceUniqueness and list[i] == num then
            return
        elseif list[i] < num then
            table.insert(list, i + 1, num)
            return
        end
    end

    -- add at the beginning if we get this far
    table.insert(list, 1, num)
end

function part1(input)
    local result = 0

    local startColumn = input:find("S", 1, true)
    print("starting column:", startColumn)

    local columnsWithTachyon = { startColumn }

    for line in input:gmatch("([^\n]+)\n?") do
        local newColumnsWithTachyon = {}

        for _, col in ipairs(columnsWithTachyon) do
            if line:sub(col, col) == "^" then
                if col > 1 then
                    orderedInsertTowardsEnd(newColumnsWithTachyon, col - 1, true)
                end

                orderedInsertTowardsEnd(newColumnsWithTachyon, col + 1, true)

                result = result + 1
            else
                orderedInsertTowardsEnd(newColumnsWithTachyon, col, true)
            end
        end

        columnsWithTachyon = newColumnsWithTachyon
    end

    return result
end

function part2(input)
    local result = 0

    local state = {
        columnsWithAtLeastOneTachyon = { },
        numberOfTachyonsByColumnIndex = { }
    }

    local function addToState(mutableState, col, numberOfTachyons)
        orderedInsertTowardsEnd(mutableState.columnsWithAtLeastOneTachyon, col, true)

        if mutableState.numberOfTachyonsByColumnIndex[col] == nil then
            mutableState.numberOfTachyonsByColumnIndex[col] = 0
        end

        mutableState.numberOfTachyonsByColumnIndex[col] = mutableState.numberOfTachyonsByColumnIndex[col] + numberOfTachyons
    end

    local startColumn = input:find("S", 1, true)
    print("starting column:", startColumn)
    addToState(state, startColumn, 1)

    for line in input:gmatch("([^\n]+)\n?") do
        local newState = {
            columnsWithAtLeastOneTachyon = {},
            numberOfTachyonsByColumnIndex = {}
        }

        for _, col in ipairs(state.columnsWithAtLeastOneTachyon) do
            local numberOfTachyonsInColumn = state.numberOfTachyonsByColumnIndex[col]

            if line:sub(col, col) == "^" then
                if col > 1 then
                    addToState(newState, col - 1, numberOfTachyonsInColumn)
                end

                addToState(newState, col + 1, numberOfTachyonsInColumn)
            else
                addToState(newState, col, numberOfTachyonsInColumn)
            end
        end

        state = newState
    end

    for _, col in ipairs(state.columnsWithAtLeastOneTachyon) do
        result = result + state.numberOfTachyonsByColumnIndex[col]
    end

    return result
end

return function(inputStr)
    local input = parseInput(inputStr)
    return part1(input) .. " " .. part2(input)
end
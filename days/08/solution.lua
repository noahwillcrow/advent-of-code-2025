local config = require("common/config")
local Heap = require("common/data-structures/heap")
local Set = require("common/data-structures/set")

local print = require("common/print-if-enabled")

function parseInput(inputStr)
    local result = {}

    for line in inputStr:gmatch("([^\n]+)\n?") do
        local coors = {}
        for numStr in line:gmatch("([^,]+)") do
            table.insert(coors, tonumber(numStr))
        end
        table.insert(result, coors)
    end

    return result
end

--[[
    heap object shape:
    {
        distanceSquared: number,
        coordinateIndexes: { number, number }
    }
]]
function customHeapCompare(a, b)
    return a.distanceSquared < b.distanceSquared
end

function buildMinDistancesHeap(coordinatesArray)
    local heap = {}

    for i = 1, #coordinatesArray do
        for j = i + 1, #coordinatesArray do
            local a = coordinatesArray[i]
            local b = coordinatesArray[j]
            local heapObject = {
                distanceSquared = (a[1]-b[1])^2 + (a[2]-b[2])^2 + (a[3]-b[3])^2,
                coordinateIndexes = {i, j}
            }
            Heap.push(heap, heapObject, customHeapCompare)
        end
    end

    if config.isDebugPrintingEnabled then
        local orderedArray = Heap.toOrderedArray(heap, customHeapCompare)
        for i = 1, #orderedArray do
            local elem = orderedArray[i]
            print(table.concat({ i, elem.distanceSquared, table.concat(elem.coordinateIndexes, ", ") }, ", "))
        end
    end

    return heap
end

function greedyBuildCircuits(coordinatesArray, minDistancesHeap, maxPairsToCombine)
    local circuitSizesByCircuitId = {}
    local coordinateIndexSetsByCircuitId = {}

    local coordinateIndexToOriginalCircuitId = {}
    local circuitIdToAbsorbedByCircuitId = {}
    local function getCircuitIdByCoordinateIndex(coordinateIndex)
        local currentCircuitId = coordinateIndexToOriginalCircuitId[coordinateIndex]
        if currentCircuitId == nil then return nil end

        while circuitIdToAbsorbedByCircuitId[currentCircuitId] do
            currentCircuitId = circuitIdToAbsorbedByCircuitId[currentCircuitId]
        end
        
        return currentCircuitId
    end

    local nextCircuitIdNum = 1

    local numberOfCoordinates = #coordinatesArray
    local biggestCircuitSize = 0
    function updateBiggestCircuitSize(updatedCircuitId)
        if circuitSizesByCircuitId[updatedCircuitId] > biggestCircuitSize then
            biggestCircuitSize = circuitSizesByCircuitId[updatedCircuitId]
        end
    end

    local mostRecentHeapElem = nil

    for iter = 1, math.min(#minDistancesHeap, maxPairsToCombine) do
        mostRecentHeapElem = Heap.pop(minDistancesHeap, customHeapCompare)
        print("{heapElem.distanceSquared}", mostRecentHeapElem.distanceSquared)
        
        local coordinateIndexes = mostRecentHeapElem.coordinateIndexes
        local i = coordinateIndexes[1]
        local j = coordinateIndexes[2]

        local currentCircuitIdForI = getCircuitIdByCoordinateIndex(i)
        local currentCircuitIdForJ = getCircuitIdByCoordinateIndex(j)
        print("{i, j, coors[i], coors[j], currentCircuitIdForI, currentCircuitForJ}", i, j, table.concat(coordinatesArray[i], ", "), table.concat(coordinatesArray[j], ", "), currentCircuitIdForI, currentCircuitIdForJ)

        if currentCircuitIdForI and currentCircuitIdForJ then
            if currentCircuitIdForI ~= currentCircuitIdForJ then
                print("making circuit for j join circuit for i")

                -- make j's circuit join i's circuit
                circuitSizesByCircuitId[currentCircuitIdForI] = circuitSizesByCircuitId[currentCircuitIdForI] + circuitSizesByCircuitId[currentCircuitIdForJ]
                Set.absorb(coordinateIndexSetsByCircuitId[currentCircuitIdForI], coordinateIndexSetsByCircuitId[currentCircuitIdForJ])

                -- remove j's circuit
                circuitSizesByCircuitId[currentCircuitIdForJ] = nil
                coordinateIndexSetsByCircuitId[currentCircuitIdForJ] = nil

                -- create record that j's circuit was absorbed by i's circuit
                circuitIdToAbsorbedByCircuitId[currentCircuitIdForJ] = currentCircuitIdForI

                updateBiggestCircuitSize(currentCircuitIdForI)
            else
                print("same circuit for i and j")
            end
        elseif currentCircuitIdForI or currentCircuitIdForJ then
            -- make the loner join the group

            -- figure out which is the loner
            local currentCircuitMember = i
            local circuitId = currentCircuitIdForI
            local loner = j
            if currentCircuitIdForI == nil then
                currentCircuitMember = j
                circuitId = currentCircuitIdForJ
                loner = i
            end

            -- just to get the linter to shut up
            if circuitId == nil then
                error("somehow circuitId is nil")
            end

            print("making loner join existing circuit {currentCircuitMember, loner, circuitId}", currentCircuitMember, loner, circuitId)

            -- add the loner to the existing circuit
            circuitSizesByCircuitId[circuitId] = circuitSizesByCircuitId[circuitId] + 1
            Set.add(coordinateIndexSetsByCircuitId[circuitId], loner)
            coordinateIndexToOriginalCircuitId[loner] = circuitId

            updateBiggestCircuitSize(circuitId)
        else
            -- create a new circuit
            local newCircuitId = "0x" .. string.format("%x", nextCircuitIdNum)
            print("new circuit! {id, i, j}", newCircuitId, i, j)
            nextCircuitIdNum = nextCircuitIdNum + 1

            circuitSizesByCircuitId[newCircuitId] = 2
            coordinateIndexSetsByCircuitId[newCircuitId] = {}
            
            Set.add(coordinateIndexSetsByCircuitId[newCircuitId], i)
            Set.add(coordinateIndexSetsByCircuitId[newCircuitId], j)

            coordinateIndexToOriginalCircuitId[i] = newCircuitId
            coordinateIndexToOriginalCircuitId[j] = newCircuitId
            
            updateBiggestCircuitSize(newCircuitId)
        end

        if biggestCircuitSize == numberOfCoordinates then break end
    end

    local circuits = {}
    for circuitId, _ in pairs(circuitSizesByCircuitId) do
        table.insert(circuits, {
            coordinateIndexesSet = coordinateIndexSetsByCircuitId[circuitId],
            size = circuitSizesByCircuitId[circuitId]
        })
    end

    table.sort(circuits, function(a, b) return a.size > b.size end)

    return {
        circuits = circuits,
        lastHeapElem = mostRecentHeapElem
    }
end

function part1(input)
    local result = 1

    local heap = buildMinDistancesHeap(input)
    local circuits = greedyBuildCircuits(input, heap, 1000).circuits

    print("number of circuits:", #circuits)

    for i = 1, math.min(3, #circuits) do
        result = result * circuits[i].size
    end

    return result
end

function part2(input)
    local result = 0

    local heap = buildMinDistancesHeap(input)
    local greedyBuildResult = greedyBuildCircuits(input, heap, math.huge)

    if #greedyBuildResult.circuits > 1 then
        error("expected exactly 1 circuit!")
    end

    local finalCoordinateIndexesPair = greedyBuildResult.lastHeapElem.coordinateIndexes
    local i = finalCoordinateIndexesPair[1]
    local j = finalCoordinateIndexesPair[2]
    local a = input[i]
    local b = input[j]
    result = a[1]*b[1]

    return result
end

return function(inputStr)
    local input = parseInput(inputStr)
    return part1(input) .. " " .. part2(input)
end
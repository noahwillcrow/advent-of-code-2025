local print = require("common/print-if-enabled")

local Heap = {}

local function swap(array, i, j)
    local temp = array[i]
    array[i] = array[j]
    array[j] = temp
end

local function bubbleUp(array, compare, index)
    local pos = index
    while pos > 1 do
        local parentPos = pos >> 1
        -- print("[Heap] bubbleUp {pos, parentPos, #array}", pos, parentPos, #array)
        if compare(array[pos], array[parentPos]) then
            swap(array, pos, parentPos)
            pos = parentPos
        else
            break
        end
    end
end

local function bubbleDown(array, compare, index)
    local pos = index
    local arrayLength = #array
    while true do
        local left = pos << 1
        local right = left + 1
        local minIndex = pos

        -- print("[Heap] bubbleDown {pos, left, right, minIndex, #array}", pos, left, right, minIndex, #array)

        if left <= arrayLength and compare(array[left], array[minIndex]) then
            minIndex = left
        end

        if right <= arrayLength and compare(array[right], array[minIndex]) then
            minIndex = right
        end

        if minIndex == pos then
            break
        end

        swap(array, pos, minIndex)
        pos = minIndex
    end
end

function Heap.pop(array, compare)
    local result = array[1];
    local last = table.remove(array)
    if #array > 0 and last ~= nil then
        array[1] = last
        bubbleDown(array, compare, 1)
    end
    return result
end

function Heap.push(array, value, compare)
    table.insert(array, value)
    bubbleUp(array, compare, #array)
end

function Heap.toOrderedArray(array, compare)
    local arrayLength = #array

    local heapCopy = {}
    for i = 1, arrayLength do
        heapCopy[i] = array[i]
    end

    local result = {}
    for i = 1, arrayLength do
        table.insert(result, Heap.pop(heapCopy, compare))
    end

    return result
end

local function minCompare(a, b) return a < b end
Heap.min = {
    pop = function (array) return Heap.pop(array, minCompare) end,
    push = function(array, value) Heap.push(array, value, minCompare) end,
    toOrderedArray = function(array) return Heap.toOrderedArray(array, minCompare) end
}

local function maxCompare(a, b) return a > b end
Heap.max = {
    pop = function (array) return Heap.pop(array, maxCompare) end,
    push = function(array, value) Heap.push(array, value, maxCompare) end,
    toOrderedArray = function(array) return Heap.toOrderedArray(array, maxCompare) end
}

return Heap
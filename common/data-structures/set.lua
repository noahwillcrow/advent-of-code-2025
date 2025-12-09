local Set = {}

function Set.absorb(set, otherSet)
    for value, _ in pairs(otherSet) do
        Set.add(set, value)
    end
end

function Set.add(set, value)
    set[value] = true
end

function Set.has(set, value)
    return set[value] == true
end

function Set.remove(set, value)
    set[value] = false
end

return Set
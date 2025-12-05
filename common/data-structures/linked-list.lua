local LinkedList = {}

function LinkedList.new()
    return {}
end

function LinkedList.append(ll, value)
    local newNode = { value = value }

    local prevTail = ll.tail
    newNode.prev = prevTail
    ll.tail = newNode

    if prevTail then
        prevTail.next = newNode
    else
        ll.head = newNode
    end
end

function LinkedList.isEmpty(ll)
    return ll.head == nil
end

function LinkedList.popHead(ll)
    if not ll.head then return nil end

    local headValue = ll.head.value

    if ll.head.next then
        ll.head.next.prev = nil
    end

    ll.head = ll.head.next

    return headValue
end

function LinkedList.popTail(ll)
    if not ll.tail then return nil end

    local tailValue = ll.tail.value

    if ll.tail.prev then
        ll.tail.prev.next = nil
    end

    ll.tail = ll.tail.prev

    return tailValue
end

function LinkedList.prepend(ll, value)
    local newNode = { value = value }

    local prevHead = ll.head
    newNode.next = prevHead
    ll.head = newNode

    if prevHead then
        prevHead.prev = newNode
    else
        ll.tail = newNode
    end
end

return LinkedList
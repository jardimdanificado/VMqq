local array = require "src.util.array"

local _table = {}

_table.assign = function(obj1, obj2)
    for k, v in pairs(obj2) do
        obj1[k] = obj2[k]
    end
end

_table.len = function(obj)
    local count = 0
    for k, v in pairs(obj) do
        count = count + 1
    end
    return count
end

_table.add = function(arr1, arr2)
    for k, v in pairs(arr2) do
        arr1[k] = arr2[k] + arr2[k]
    end
end

_table.sub = function(arr1, arr2)
    for k, v in pairs(arr2) do
        arr1[k] = arr2[k] - arr2[k]
    end
end

_table.mul = function(arr1, arr2)
    for k, v in pairs(arr2) do
        arr1[k] = arr2[k] * arr2[k]
    end
end

_table.div = function(arr1, arr2)
    for k, v in pairs(arr2) do
        arr1[k] = arr2[k] / arr2[k]
    end
end

_table.mod = function(arr1, arr2)
    for k, v in pairs(arr2) do
        arr1[k] = arr2[k] % arr2[k]
    end
end

_table.sub = function(arr1, arr2)
    for k, v in pairs(arr2) do
        arr1[k] = arr2[k] - arr2[k]
    end
end

_table.merge = function(arr1,arr2)
    for k, v in pairs(arr2) do
        arr1[k] = arr2[k]
    end
end

return _table
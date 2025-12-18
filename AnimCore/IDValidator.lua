local IDValidator = {}

function IDValidator.NormalizeAnimationId(id)
    if not id then return nil end
    local str = tostring(id)
    
    if str:match("^rbxassetid://%d+$") then
        return str
    end
    
    local digits = str:match("%d+")
    if not digits then return nil end
    
    return "rbxassetid://" .. digits
end

function IDValidator.IsValidAnimationId(id)
    local normalized = IDValidator.NormalizeAnimationId(id)
    if not normalized then return false end
    
    local numberPart = normalized:match("%d+")
    if not numberPart then return false end
    
    return tonumber(numberPart) and tonumber(numberPart) > 0
end

function IDValidator.ExtractNumericId(id)
    local normalized = IDValidator.NormalizeAnimationId(id)
    if not normalized then return nil end
    
    return tonumber(normalized:match("%d+"))
end

return IDValidator
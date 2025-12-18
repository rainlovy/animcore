local AnimationEngine = {
    CurrentTrack = nil,
    PlayingId = nil,
    AnimObject = Instance.new("Animation")
}

function AnimationEngine.NormalizeAnimId(id)
    if not id then return nil end
    local s = tostring(id)
    if s:match("^rbxassetid://%d+$") then
        return s
    end
    local digits = s:match("%d+")
    if not digits then return nil end
    return "rbxassetid://" .. digits
end

function AnimationEngine.StopAllAnimations(humanoid)
    if not humanoid or not humanoid:IsA("Humanoid") then return end
    
    if AnimationEngine.CurrentTrack then
        pcall(function()
            if AnimationEngine.CurrentTrack.IsPlaying then
                AnimationEngine.CurrentTrack:Stop(0)
            end
        end)
        AnimationEngine.CurrentTrack = nil
    end
    
    AnimationEngine.PlayingId = nil
end

function AnimationEngine.PlayAnimation(humanoid, animId, speed)
    if not humanoid or not humanoid:IsA("Humanoid") then return nil end
    
    local normalizedId = AnimationEngine.NormalizeAnimId(animId)
    if not normalizedId then return nil end
    
    if AnimationEngine.PlayingId == normalizedId and AnimationEngine.CurrentTrack then
        if AnimationEngine.CurrentTrack.IsPlaying then
            AnimationEngine.StopAllAnimations(humanoid)
            return nil
        end
    end
    
    AnimationEngine.StopAllAnimations(humanoid)
    
    AnimationEngine.AnimObject.AnimationId = normalizedId
    
    local track
    local success = pcall(function()
        track = humanoid:LoadAnimation(AnimationEngine.AnimObject)
    end)
    
    if not success or not track then return nil end
    
    track.Looped = true
    track.Priority = Enum.AnimationPriority.Action
    
    local playSuccess = pcall(function()
        track:Play(0)
    end)
    
    if not playSuccess then return nil end
    
    local finalSpeed = math.clamp(tonumber(speed) or 1, 0.75, 1.25)
    pcall(function()
        track:AdjustSpeed(finalSpeed)
    end)
    
    AnimationEngine.CurrentTrack = track
    AnimationEngine.PlayingId = normalizedId
    
    return track
end

return AnimationEngine
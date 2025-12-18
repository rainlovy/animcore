local HumanoidStabilizer = {}

function HumanoidStabilizer.ResetHumanoidScale(humanoid)
    if not humanoid or not humanoid:IsA("Humanoid") then return end
    
    local desc = humanoid:GetAppliedDescription()
    if not desc then return end
    
    desc.HeightScale = math.clamp(desc.HeightScale or 1, 0.95, 1.05)
    desc.WidthScale = math.clamp(desc.WidthScale or 1, 0.95, 1.05)
    desc.DepthScale = math.clamp(desc.DepthScale or 1, 0.95, 1.05)
    desc.HeadScale = math.clamp(desc.HeadScale or 1, 0.95, 1.05)
    desc.ProportionScale = 0
    desc.BodyTypeScale = 0
    
    pcall(function()
        humanoid:ApplyDescription(desc)
    end)
end

function HumanoidStabilizer.StopAllAnimationTracks(humanoid)
    if not humanoid or not humanoid:IsA("Humanoid") then return end
    
    for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
        if track and track:IsA("AnimationTrack") then
            pcall(function()
                if track.IsPlaying then
                    track:Stop(0)
                end
            end)
        end
    end
end

return HumanoidStabilizer
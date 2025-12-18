local SpeedController = {}

SpeedController.MIN_SPEED = 0.75
SpeedController.MAX_SPEED = 1.25
SpeedController.DEFAULT_SPEED = 1.0

function SpeedController.ClampSpeed(speed)
    local num = tonumber(speed)
    if not num then return SpeedController.DEFAULT_SPEED end
    return math.clamp(num, SpeedController.MIN_SPEED, SpeedController.MAX_SPEED)
end

function SpeedController.ValidateSpeedInput(input)
    if not input or input == "" then return SpeedController.DEFAULT_SPEED end
    
    local text = tostring(input):gsub(",", ".")
    
    if text:match("^%.%d+$") then
        text = "0" .. text
    end
    
    local num = tonumber(text)
    if not num or num <= 0 then return SpeedController.DEFAULT_SPEED end
    
    return SpeedController.ClampSpeed(num)
end

function SpeedController.AdjustTrackSpeed(track, speed)
    if not track or not track:IsA("AnimationTrack") then return end
    if not track.IsPlaying then return end
    
    local clampedSpeed = SpeedController.ClampSpeed(speed)
    pcall(function()
        track:AdjustSpeed(clampedSpeed)
    end)
end

return SpeedController
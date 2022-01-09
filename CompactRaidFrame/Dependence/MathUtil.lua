function CUFLerp(startValue, endValue, amount)
    return (1 - amount) * startValue + amount * endValue;
end

function CUFClamp(value, min, max)
    if value > max then
        return max;
    elseif value < min then
        return min;
    end
    return value;
end

function CUFSaturate(value)
    return CUFClamp(value, 0.0, 1.0);
end

function CUFWrap(value, max)
    return (value - 1) % max + 1;
end

function CUFClampDegrees(value)
    return CUFClampMod(value, 360);
end

function CUFClampMod(value, mod)
    return ((value % mod) + mod) % mod;
end

function CUFNegateIf(value, condition)
    return condition and -value or value;
end

function CUFPercentageBetween(value, startValue, endValue)
    if startValue == endValue then
        return 0.0;
    end
    return (value - startValue) / (endValue - startValue);
end

function CUFClampedPercentageBetween(value, startValue, endValue)
    return CUFSaturate(CUFPercentageBetween(value, startValue, endValue));
end

local TARGET_FRAME_PER_SEC = 60.0;
function CUFDeltaLerp(startValue, endValue, amount, timeSec)
    return CUFLerp(startValue, endValue, CUFSaturate(amount * timeSec * TARGET_FRAME_PER_SEC));
end

function CUFFrameDeltaLerp(startValue, endValue, amount, elapsed)
    return CUFDeltaLerp(startValue, endValue, amount, elapsed);
end

function CUFRandomFloatInRange(minValue, maxValue)
    return CUFLerp(minValue, maxValue, math.random());
end

function CUFRound(value)
    if value < 0.0 then
        return math.ceil(value - .5);
    end
    return math.floor(value + .5);
end

function CUFSquare(value)
    return value * value;
end

function CUFCalculateDistanceSq(x1, y1, x2, y2)
    local dx = x2 - x1;
    local dy = y2 - y1;
    return (dx * dx) + (dy * dy);
end

function CUFCalculateDistance(x1, y1, x2, y2)
    return math.sqrt(CUFCalculateDistanceSq(x1, y1, x2, y2));
end

function CUFCalculateAngleBetween(x1, y1, x2, y2)
    return math.atan2(y2 - y1, x2 - x1);
end

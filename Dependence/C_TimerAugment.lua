local TickerPrototype = {};
local TickerMetatable = {
    __index = TickerPrototype,
    __metatable = true,    
};

C_Timer = CreateFrame("Frame", "C_Timer")
C_Timer.schedule = {}
C_Timer:SetScript("OnUpdate", function(self, elapsed)
        for timestamp,callback in pairs(self.schedule) do
            if timestamp <= GetTime() then
                callback()
                self.schedule[timestamp] = nil
            end
        end
end)

C_Timer.After = function(duration, callback)
    C_Timer.schedule[GetTime() + duration] = callback
end

function C_Timer.NewTicker(duration, callback, iterations)
    local ticker = setmetatable({}, TickerMetatable);
    ticker._remainingIterations = iterations;
    ticker._callback = function()
        if ( not ticker._cancelled ) then
            callback(ticker);
            if ( not ticker._cancelled ) then
                if ( ticker._remainingIterations ) then
                    ticker._remainingIterations = ticker._remainingIterations - 1;
                end
                if ( not ticker._remainingIterations or ticker._remainingIterations > 0 ) then
                    C_Timer.After(duration, ticker._callback);
                end
            end
        end
    end;
    
    C_Timer.After(duration, ticker._callback);
    return ticker;
end

function C_Timer.NewTimer(duration, callback)
    return C_Timer.NewTicker(duration, callback, 1);
end

function TickerPrototype:Cancel()
    self._cancelled = true;
end
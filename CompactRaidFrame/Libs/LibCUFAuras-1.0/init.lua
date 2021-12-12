local MAJOR, MINOR = "LibCUFAuras-1.0", 1;
if ( not LibStub ) then error(MAJOR .. " requires LibStub") return end

local lib = LibStub:NewLibrary(MAJOR, MINOR);
if not lib then return end

lib.callbacks = LibStub("CallbackHandler-1.0"):New(lib);
if ( not lib.callbacks ) then error(MAJOR .. " requires CallbackHandler-1.0") return end

lib.handler = CreateFrame("Frame");
lib.handler:SetScript("OnEvent", function(self, event, ...)
    if ( self[event] ) then
        self[event](self, event, ...);
    end
end)

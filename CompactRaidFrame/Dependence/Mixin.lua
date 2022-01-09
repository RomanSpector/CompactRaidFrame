---------------
-- where ​... are the mixins to mixin
function CUFMixin(object, ...)
    for i = 1, select("#", ...) do
        local mixin = select(i, ...);
        for k, v in pairs(mixin) do
            object[k] = v;
        end
    end
    return object;
end
-- where ​... are the mixins to mixin
function CUFCreateFromMixins(...)
    return CUFMixin({}, ...)
end

function CUFCreateAndInitFromCUFMixin(mixin, ...)
    local object = CUFCreateFromMixins(mixin);
    object:Init(...);
    return object;
end

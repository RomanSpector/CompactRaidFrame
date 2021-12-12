---------------
-- where ​... are the mixins to mixin
function Mixin(object, ...)
    for i = 1, select("#", ...) do
        local mixin = select(i, ...);
        for k, v in pairs(mixin) do
            object[k] = v;
        end
    end
    return object;
end
-- where ​... are the mixins to mixin
function CreateFromMixins(...)
    return Mixin({}, ...)
end

function CreateAndInitFromMixin(mixin, ...)
    local object = CreateFromMixins(mixin);
    object:Init(...);
    return object;
end

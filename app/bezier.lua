local bezier = {}
 
function bezier:curve(xv, yv)
        local reductor = {__index = function(self, ind)
                return setmetatable({tree = self, level = ind}, {__index = function(curves, ind)
                        return function(t)
                                local x1, y1 = curves.tree[curves.level-1][ind](t)
                                local x2, y2 = curves.tree[curves.level-1][ind+1](t)
                                return x1 + (x2 - x1) * t, y1 + (y2 - y1) * t
                                end
                        end})
                end
        }
        local points = {}
        for i = 1, #xv do
                        points[i] = function(t) return xv[i], yv[i] end
        end
        return setmetatable({points}, reductor)[#points][1]
end
 
return bezier
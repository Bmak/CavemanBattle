local F = {}

-- return distance from object to point
function F:getDistance(obj,x,y)
	local dx = x - obj.view.x
	local dy = y - obj.view.y
	local delta = math.sqrt( dx*dx + dy*dy )
	return delta
end

--rectangle-based collision detection
function F:hasCollided( obj1, obj2 )
   if ( obj1 == nil ) then  --make sure the first object exists
      return false
   end
   if ( obj2 == nil ) then  --make sure the other object exists
      return false
   end

   local left = obj1.contentBounds.xMin <= obj2.contentBounds.xMin and obj1.contentBounds.xMax >= obj2.contentBounds.xMin
   local right = obj1.contentBounds.xMin >= obj2.contentBounds.xMin and obj1.contentBounds.xMin <= obj2.contentBounds.xMax
   local up = obj1.contentBounds.yMin <= obj2.contentBounds.yMin and obj1.contentBounds.yMax >= obj2.contentBounds.yMin
   local down = obj1.contentBounds.yMin >= obj2.contentBounds.yMin and obj1.contentBounds.yMin <= obj2.contentBounds.yMax

   return (left or right) and (up or down)
end

return F




-- ((x/2)(x/2) + ((y+1)/2)((y+1)/2)sqrt((abs(y+1))/(y+1))-1)((x/2)(x/2) + ((y-1)/2)((y-1)/2)sqrt((abs(-y+1))/(-y+1))-1)(sqrt((abs(3-abs(x-5)))/(3-abs(x-5)))-y)(-sqrt((abs(3-abs(x-5))))-y)(((x-9)/1.5)((x-9)/1.5)sqrt(abs(x+1)/(x+1))+(y/1.5)(y/1.5)-1)(0.00001sqrt((abs(0.25-abs(x-10.25)))/(0.25-abs(x-10.25)))-y) = 0
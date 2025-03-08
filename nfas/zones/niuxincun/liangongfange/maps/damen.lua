local ss_locked = [[

         村口亭 -- &HIG&练功房大门&NOR&

]]

local ss_unlocked = [[

                   练功房内室
                       ｜
         村口亭 -- &HIG&练功房大门&NOR&

]]

function map_data()
	return {
          map_locked = ss_locked,
          map_unlocked = ss_unlocked
     }
end

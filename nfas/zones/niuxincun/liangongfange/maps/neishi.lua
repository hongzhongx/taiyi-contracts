local ss_locked = [[

                   &HIG&练功房内室&NOR&

]]

local ss_unlocked = [[

                   &HIG&练功房内室&NOR&
                       ｜
                   练功房大门

]]

function map_data()
	return {
        map_locked = ss_locked,
        map_unlocked = ss_unlocked
   }
end

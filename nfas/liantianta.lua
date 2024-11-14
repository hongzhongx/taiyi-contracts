heart_beat = { consequence = true }
active = { consequence = true }

-- 返回一个table
function init_data()
    return {        
        name = "炼天塔",
        unit = "座"
    }
end

function do_active()
    nfa_helper:enable_tick()
end

function do_heart_beat()
    -- 转化自身的元气到金石    
    local nfa = nfa_helper:get_info()
	-- contract_helper:log(string.format('nfa qi=%d', nfa.qi))
    if nfa.qi > 1000 then
        nfa_helper:convert_qi_to_resource(1000, "GOLD")
    end
end


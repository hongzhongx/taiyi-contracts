short = { consequence = false }
long = { consequence = false }
exits = { consequence = false }
map = { consequence = false }

function init_data()
    return {
        is_zone = true,
        unit = '条'
    }
end

function eval_short()
    return { "村道" }
end

function get_view_narration()
    local tiandao = contract_helper:get_tiandao_property()
    if tiandao.v_timeonday == 0 then -- 凌晨
        return "四周一片静悄悄的，没有一个人影。"
    elseif tiandao.v_timeonday == 1 then -- 上午
        return "远处传来阵阵鸡鸣犬吠，村民们开始了一天的忙碌。"
    elseif tiandao.v_timeonday == 2 then -- 下午
        return "太阳高照，村民们或在田间劳作，或在树荫下乘凉。"
    else -- 夜晚
        return "夜幕降临，周围灯火点点，显得格外温馨。"
    end
end

function eval_long()
    local ss = import_contract('contract.map.niuxincun.cundao').map_data()
    local nfa_me = nfa_helper:get_info()

    ss = ss .. '    ' .. get_view_narration()
    ss = ss .. '往南（south）通向&HIC&村口亭&NOR&，往北（north）可以看到一座气派的&HIC&崇圣牌坊&NOR&，往东（east）则是&HIC&高志坚家&NOR&'

    return { ss }
end

function eval_exits()
    local exits = {
        south = "牛心村.村口亭",
        north = "牛心村.崇圣牌坊",
        east = "牛心村.高志坚家"    }
    return exits
end

function eval_map()
    local map_data = import_contract('contract.map.niuxincun').map_data()
    return { map_data }
end

function on_actor_enter(actor_nfa_id)
    local actor = contract_helper:get_actor_info(actor_nfa_id)
    contract_helper:narrate(string.format('    &YEL&%s&NOR&走在一条小路上。', actor.name), false)
end

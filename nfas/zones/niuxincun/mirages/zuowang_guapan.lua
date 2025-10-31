narrate = { consequence = false }
look = { consequence = false }

trigger = { consequence = true }

function long_desc(actor_name)
    local desc = [[
    参透卦象那刻，你看到真气如金线穿梭三界。龙脉不过是庞大灵气网的某个节点，牛心村众生皆是网中挣扎的蜉蝣。你笑着将苗刀抛向卦盘，身形逐渐化作万千光点融入天道法则。
    &HIC&（达成结局【见众生相】）&NOR&
    ]]
    return desc;
end

-- nfa_helper is valid
function eval_narrate()
    local nfa_me = nfa_helper:get_info()
    local actor = contract_helper:get_actor_info(nfa_me.id)
    contract_helper:narrate(long_desc(actor.name), false)
end

function enter_narrate()
end

function exit_narrate()
    local r_p = contract_helper:random() % 100
    local str = r_p < 20 and "突然周围一黑……" or (r_p < 50 and "周围突然全亮！" or "周围又突然发生了变化！")
    contract_helper:narrate("\n    &HBYEL&" .. str .. "&NOR&\n", false)
end

-- nfa_helper is valid
function do_trigger()
    local nfa_me = nfa_helper:get_info()
    enter_narrate()
    eval_narrate()

    exit_narrate();
    contract_helper:exit_nfa_mirage(nfa_me.id)
    contract_helper:eval_nfa_action(nfa_me.id, "look", {""})
    -- 自动激活一次心跳，回到正常状态
    contract_helper:do_nfa_action(nfa_me.id, "active", {})

    return { triggered = true }
end

function eval_look(target)
    if target == "" then
        eval_narrate()
    end
end

narrate = { consequence = false }
look = { consequence = false }

trigger = { consequence = true }

function long_desc(actor_name)
    local desc = [[
    你吞下老者头颅中滚出的尸丹，七十二盏人皮灯笼尽数没入天灵盖。三尸苗刀与脊椎融合成龙骨，每节脊椎都浮现出被镇压的龙君名讳。当最后一声龙吟消散时，你已成新的镇井人，手中刀既是枷锁也是钥匙。
    &HIC&（达成结局【我即龙渊】）&NOR&
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

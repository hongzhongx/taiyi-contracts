narrate = { consequence = false }
look = { consequence = false }

trigger = { consequence = true }
flee = { consequence = true }
recite = { consequence = true }

function long_desc(actor_name)
    local desc = [[
    指尖触及铁钉的刹那，七十二盏人皮灯笼同时炸亮。&YEL&老者&NOR&手中的磨刀石裂成两半，露出内里刻满梵文的青铜罗盘。&YEL&铁钉&NOR&上的发丝突然勒进你腕脉，将三缕黑气注入奇经八脉。祠堂方向传来瓦片碎裂声，有个眉心点朱砂的&YEL&白袍书生&NOR&踩着灯笼飘来。
    ]]
    return desc;
end

function command_list()
    return {
        names = {
            "use &YEL&铁钉 罗盘&NOR&",
            "recite &YEL&正气歌 黑气&NOR&",
            "flee &YEL&村道&NOR&"
        }
    }
end

-- nfa_helper is valid
function eval_narrate()
    local nfa_me = nfa_helper:get_info()
    local actor = contract_helper:get_actor_info(nfa_me.id)
    contract_helper:narrate(long_desc(actor.name), false)

    local str = "    你可以使用的命令："
    local names = command_list().names
    for i, name in pairs(names) do
        str = str .. name .. (i < #names and "，" or "\n")
    end
    contract_helper:narrate(str, false)
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
    enter_narrate()
    eval_narrate()

    local str = "    &HIC&三尸虫寄生度+30%，消耗0.03年阳寿。&NOR&"
    contract_helper:narrate(str, false)

    -- （心跳方案）一刻钟在正式网大约持续三个NFA心跳，注入维持心跳的真气
    -- if contract_helper:get_account_balance(contract_base_info.owner, 'QI') > 10000 then
    --     nfa_helper:deposit_from_owner(10000, 'QI', true)
    --     nfa_helper:enable_tick()
    -- end

    local nfa_me = nfa_helper:get_info()
    local yang = contract_helper:get_nfa_balance(nfa_me.id, "YANG")
    if yang > 30 then
        yang = 30
    end
    if yang > 0 then
        nfa_helper:withdraw_to(contract_base_info.owner, yang, "YANG", true)
        contract_helper:narrate(string.format("    &YEL&%s&NOR&失去了&HIC&%f&NOR&年阳寿。", actor.name, yang/1000.0), true)
    end

    return { triggered = true }
end

function eval_look(target)
    if target == "" then
        eval_narrate()
    end
end

-- 由于在心跳的时候合约没有权限转账，所以无法实现该方案
-- function on_heart_beat()
--     local nfa_me = nfa_helper:get_info()
--     local yang = contract_helper:get_nfa_balance(nfa_me.id, "YANG")
--     if yang > 30 then
--         yang = 30
--     end
--     if yang > 0 then
--         nfa_helper:withdraw_to(contract_base_info.owner, yang, "YANG", true)
--         contract_helper:narrate(string.format("&YEL&%s&NOR&失去了&HIC&%f&NOR&年阳寿。", actor.name, yang/1000.0), true)
--     end
-- end

function do_recite(something, target)
    local nfa_me = nfa_helper:get_info()
    if something == "正气歌" and target == "黑气" then
        contract_helper:enter_nfa_next_mirage(nfa_me.id, "contract.mirage.zuowang.heiqi")
        contract_helper:do_nfa_action(nfa_me.id, "trigger", {})
    end    
end

function do_flee(target)
    local nfa_me = nfa_helper:get_info()
    if target == "村道" then
        exit_narrate();
        contract_helper:exit_nfa_mirage(nfa_me.id)
        contract_helper:eval_nfa_action(nfa_me.id, "look", {""})
    end
end
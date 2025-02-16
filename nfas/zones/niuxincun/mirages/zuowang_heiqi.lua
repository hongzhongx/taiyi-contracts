narrate = { consequence = false }
look = { consequence = false }

trigger = { consequence = true }
destroy = { consequence = true }
ask = { consequence = true }

function long_desc(actor_name)
    local desc = [[
    "天地有正气——"，你刚诵出首句，黑气便从七窍喷涌成七条墨蛟。怀中&YEL&《谏佛骨表》&NOR&无风自动，将墨蛟钉在半空显形——竟是七张写满生辰八字的黄纸！白袍书生突然撕开面皮，露出&HIG&诸葛渊&NOR&年轻时的容貌，他蘸着磨刀石渗出的血在黄纸上批注："此子阳寿未尽"。
    空中黄纸燃起青白色火焰，将三尸虫烧成琉璃状的舍利子。老者突然用青铜罗盘罩住火堆，沙哑笑道："秃驴的&YEL&舍利&NOR&，正好用来喂我的&YEL&刀灵&NOR&！"
    ]]
    return desc;
end

function command_list()
    return {
        names = {
            "snatch &YEL&舍利子&NOR&",
            "destroy &YEL&舍利子&NOR&",
            "ask &YEL&老者 刀灵&NOR&"
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
    local nfa_me = nfa_helper:get_info()
    local yang = contract_helper:get_nfa_balance(nfa_me.id, "YANG")
    if yang > 50 then
        contract_helper:narrate("&HIC&文气共鸣！消耗0.5年阳寿激活浩然正气。&NOR&", false)
        -- 待实现（浩然正气状态持续三刻钟，抵御阴邪攻击）
    end
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

    local nfa_me = nfa_helper:get_info()
    local yang = contract_helper:get_nfa_balance(nfa_me.id, "YANG")
    if yang > 50 then
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

function do_ask(somebody, what)
    local nfa_me = nfa_helper:get_info()
    if somebody == "老者" and what == "刀灵" then
        contract_helper:enter_nfa_next_mirage(nfa_me.id, "contract.mirage.zuowang.daoling")
        contract_helper:do_nfa_action(nfa_me.id, "trigger", {})
    end    
end

function do_destroy(obj)
    local nfa_me = nfa_helper:get_info()
    if obj == "舍利子" then
        exit_narrate();
        contract_helper:exit_nfa_mirage(nfa_me.id)
        contract_helper:eval_nfa_action(nfa_me.id, "look", {""})
    end
end
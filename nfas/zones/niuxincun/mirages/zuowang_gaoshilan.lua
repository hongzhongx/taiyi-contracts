narrate = { consequence = false }
look = { consequence = false }

trigger = { consequence = true }
take = { consequence = true }
burn = { consequence = true }

function long_desc(actor_name)
    local desc = string.format([[
    褪色的黄纸上爬满会移动的朱砂字迹，你认出这是《&YEL&坐忘道入门心法·残卷&NOR&》的筑基篇。当读到"影饕自丹田游走十二重楼"时，纸面突然渗出黑血，将"忌思故人名讳"几个字腐蚀成漩涡状孔洞。孔洞深处传来铁链拖地声，一截缠着人发的&YEL&铁钉&NOR&从纸面缓缓凸起。
    &YEL&%s&HIC&体内先天真气波动，似乎激活了「坐忘」状态！&NOR&
    ]], actor_name)
    return desc;
end

function command_list()
    return {
        names = {
            "take &YEL&铁钉&NOR&",
            "read &YEL&残卷&NOR&",
            "burn &YEL&残卷&NOR&"
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

    return { triggered = true }
end

function eval_look(target)
    if target == "" then
        eval_narrate()
    end
end

function do_take(obj)
    local nfa_me = nfa_helper:get_info()
    if obj == "铁钉" then
        contract_helper:enter_nfa_next_mirage(nfa_me.id, "contract.mirage.zuowang.tieding")
        contract_helper:do_nfa_action(nfa_me.id, "trigger", {})
    end    
end

function do_burn(obj)
    local nfa_me = nfa_helper:get_info()
    if obj == "残卷" then
        exit_narrate();
        contract_helper:exit_nfa_mirage(nfa_me.id)
        contract_helper:eval_nfa_action(nfa_me.id, "look", {""})
    end
end
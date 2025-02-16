narrate = { consequence = false }
look = { consequence = false }

trigger = { consequence = true }
follow = { consequence = true }
meditate = { consequence = true }

function long_desc(actor_name)
    local desc = [[
    刀锋划过之处空间扭曲，诸葛渊的幻象被斩成九段《谏佛骨表》残页。每张残页都渗出黑血，在地上汇成"锁龙台"三个古篆。密道深处传来锁链断裂声，你的影子突然自立而起，用刀灵割下老者首级献祭于天。
    牌坊废墟中升起青铜卦盘，卦象显示"亢龙有悔"。你忽然明悟牛心村乃是困龙之地，每口井都是钉住龙脉的镇魂钉。此刻丹田真气翻涌如沸，需即刻抉择修行方向：
    ]]
    return desc;
end

function command_list()
    return {
        names = {
            "follow &YEL&坐忘道&NOR&",
            "follow &YEL&司天监&NOR&",
            "meditate &YEL&卦盘"
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

    contract_helper:narrate("    &HIC&触发血祭，三尸苗刀进化为「斩谪仙」。&NOR&", false)

    return { triggered = true }
end

function eval_look(target)
    if target == "" then
        eval_narrate()
    end
end

function do_follow(target)
    local nfa_me = nfa_helper:get_info()
    if target == "坐忘道" then
        contract_helper:enter_nfa_next_mirage(nfa_me.id, "contract.mirage.zuowang.zuowangdao")
        contract_helper:do_nfa_action(nfa_me.id, "trigger", {})
    elseif target == "司天监" then
        contract_helper:enter_nfa_next_mirage(nfa_me.id, "contract.mirage.zuowang.sitianjian")
        contract_helper:do_nfa_action(nfa_me.id, "trigger", {})
    end
end

function do_meditate(target)
    local nfa_me = nfa_helper:get_info()
    if target == "卦盘" then
        contract_helper:enter_nfa_next_mirage(nfa_me.id, "contract.mirage.zuowang.guapan")
        contract_helper:do_nfa_action(nfa_me.id, "trigger", {})
    end
end
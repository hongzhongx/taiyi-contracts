narrate = { consequence = false }
look = { consequence = false }

trigger = { consequence = true }
inspect = { consequence = true }
go = { consequence = true }

function long_desc(actor_name)
    local desc = [[
    你站在牛心村斑驳的青石牌坊下，&YEL&槐树&NOR&籽顺着腐烂的枝条砸在肩头。村口歪斜的&YEL&告示栏&NOR&贴着褪色的符纸，墨迹蜿蜒如百足蜈蚣。远处&HIC&狗娃家&NOR&传来叮当声，却夹杂着似哭似笑的呜咽。穿粗布衣裳的&YEL&老者&NOR&蹲在碾盘旁磨刀，刀刃刮过石面时迸出幽蓝火星。
    西北方的&HIC&祠堂&NOR&檐角挂着七十二盏人皮灯笼，夜风掠过时竟发出婴儿吮吸般的声响。
    ]]
    return desc;
end

function command_list()
    return {
        names = {
            "inspect &YEL&告示栏&NOR&",
            "inspect &YEL&槐树&NOR&",
            "go &YEL&村道&NOR&",
            "talk &YEL&老者&NOR&"
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
    local r_p = contract_helper:random() % 100
    local str = r_p < 20 and "不好……" or (r_p < 50 and "糟糕！" or "突然！")
    contract_helper:narrate("\n    &HBYEL&" .. str .. "&NOR&\n", false)
end

function exit_narrate()
    local r_p = contract_helper:random() % 100
    local str = r_p < 20 and "突然周围一黑……" or (r_p < 50 and "周围突然全亮！" or "周围又突然发生了变化！")
    contract_helper:narrate("\n    &HBYEL&" .. str .. "&NOR&\n", false)
end

-- nfa_helper is valid
function do_trigger()
    enter_narrate()
    -- 入口剧情不需要再调用look，上层世界会接着调用
    return { triggered = true }
end

function eval_look(target)
    if target == "" then
        eval_narrate()
    end
end

function do_inspect(target)
    local nfa_me = nfa_helper:get_info()
    if target == "告示栏" then
        contract_helper:enter_nfa_next_mirage(nfa_me.id, "contract.mirage.zuowang.gaoshilan")
        contract_helper:do_nfa_action(nfa_me.id, "trigger", {})
    end
end

function do_go(target)
    local nfa_me = nfa_helper:get_info()
    if target == "村道" then
        exit_narrate()
        contract_helper:exit_nfa_mirage(nfa_me.id)
        contract_helper:eval_nfa_action(nfa_me.id, "look", {""})
        -- 自动激活一次心跳，回到正常状态
        contract_helper:do_nfa_action(nfa_me.id, "active", {})
    end
end

function on_heart_beat()
    local nfa_me = nfa_helper:get_info()

    -- 如果是李火旺，自动走出幻境
    if nfa_me.id == 11 then
        do_go("村道")        
    end
end

narrate = { consequence = false }
look = { consequence = false }
map = { consequence = false }

trigger = { consequence = true }
go = { consequence = true }

function long_desc(actor_name)
    local desc = [[
    密道石阶上浮动着青铜色的先天一炁，每踏出一步都会在虚空凝成《&YEL&连山&NOR&》卦象。两侧岩壁嵌着八十一盏琉璃人俑灯，灯芯竟是浸泡在龙髓中的活人眼球。地道深处传来锁链击打&YEL&青铜柱&NOR&的声响，柱面浮雕的&YEL&囚牛图案&NOR&正用獠牙啃食自己尾巴，鳞片剥落处渗出散发檀香的脓血。

    你注意到头顶倒悬着三十六重青铜齿轮组，齿牙间卡着写满契约的符箓。每当锁链声响，齿轮便逆向转动三刻，将符箓上"借寿五纪"的字样碾成金粉洒落。金粉触及地面的瞬间，竟在青砖缝里开出半透明的曼珠沙华。
    ]]
    return desc;
end

function command_list()
    return {
        names = {
            "go &YEL&牌坊&NOR&"
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

    local str = "    &HIC&先天一炁异常流动，每呼吸一次消耗0.01年阳寿转化为护体真气。&NOR&"
    contract_helper:narrate(str, false)

    return { triggered = true }
end

function eval_look(target)
    if target == "" then
        eval_narrate()
    end
end

function eval_map(target)
    local map = import_contract('contract.map.zhenlongjing')
    contract_helper:narrate(map.map_data(), false)
end

function do_go(target)
    local nfa_me = nfa_helper:get_info()
    if target == "牌坊" then
        contract_helper:enter_nfa_next_mirage(nfa_me.id, "contract.mirage.zuowang.daoling")
        contract_helper:do_nfa_action(nfa_me.id, "trigger", {})
    end
end

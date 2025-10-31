narrate = { consequence = false }
look = { consequence = false }

trigger = { consequence = true }
go = { consequence = true }
wield = { consequence = true }
bury = { consequence = true }

function long_desc(actor_name)
    local nfa_me = nfa_helper:get_info()
    -- 检查有没有苗刀
    local inv = contract_helper:list_nfa_inventory(nfa_me.id, "nfa.weapon.miaodao")
    local chinese_number = import_contract('contract.utils.numbers').chinese_number
    local public_data = contract_helper:read_contract_data({reward_items=true})
    local reward_ct = #public_data.reward_items
    local desc = (reward_ct > 0 and #inv == 0) and string.format([[
    老者掀开衣襟露出胸腔，只见%s把迷你&YEL&苗刀&NOR&插在肋骨间嗡鸣。他拔出沾血的刀灵抛向你："接住这三尸虫炼的刀，你就是坐忘道第三十七代记名弟子！"刀灵入手的瞬间，舍利子突然爆开成金粉，在空中勾勒出大欢喜天女魔舞之相。
    诸葛渊&YEL&幻象&NOR&突然并指为剑刺向你眉心，怀中《谏佛骨表》自动护主，将剑气转化为淬刀真火。刀身浮现出"斩佛"二字铭文，村口&YEL&牌坊&NOR&轰然倒塌露出通往镇龙井的&HIC&密道&NOR&。
    ]], chinese_number(reward_ct)) or [[
    村口&YEL&牌坊&NOR&轰然倒塌露出通往镇龙井的&HIC&密道&NOR&。]]
    return desc;
end

function command_list()
    return {
        names = {
            "go &YEL&密道&NOR&",
            "wield &YEL&苗刀 幻象&NOR&",
            "bury &YEL&苗刀 牌坊&NOR&"
        }
    }
end

function init(items)
    assert(contract_helper:is_owner(), 'no auth')
    assert(items ~= nil, "must input item nfa id list")
    -- 注意，此处没有检查是否是苗刀的symbol
    local public_data = {reward_items = items}
	contract_helper:write_contract_data(public_data, {reward_items=true})
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

    local nfa_me = nfa_helper:get_info()
    -- 检查有没有苗刀
    local inv = contract_helper:list_nfa_inventory(nfa_me.id, "nfa.weapon.miaodao")
    if #inv == 0 then
        local public_data = contract_helper:read_contract_data({reward_items=true})
        local reward_ct = #public_data.reward_items
        if reward_ct > 0 then
            nfa_helper:add_child_from_contract_owner(public_data.reward_items[1])
            -- 从列表删除这个NFA id
            local items = public_data.reward_items
            table.remove(items, 1)
            contract_helper:write_contract_data({reward_items = items}, {reward_items=true})
            contract_helper:narrate("    &HIC&获得成长型法宝「三尸苗刀」，需定期喂饲阳寿。&NOR&", false)
        end
    end

    return { triggered = true }
end

function eval_look(target)
    if target == "" then
        eval_narrate()
    end
end

function do_wield(something, target)
    local nfa_me = nfa_helper:get_info()
    if something == "苗刀" and target == "幻象" then
        -- 检查有没有苗刀
        local inv = contract_helper:list_nfa_inventory(nfa_me.id, "nfa.weapon.miaodao")
        if #inv > 0 then
            contract_helper:enter_nfa_next_mirage(nfa_me.id, "contract.mirage.zuowang.huanxiang")
            contract_helper:do_nfa_action(nfa_me.id, "trigger", {})
        else
            contract_helper:narrate("你还没有苗刀。", false)
        end
    end    
end

function do_go(target)
    local nfa_me = nfa_helper:get_info()
    if target == "密道" then
        contract_helper:enter_nfa_next_mirage(nfa_me.id, "contract.mirage.zuowang.midao")
        contract_helper:do_nfa_action(nfa_me.id, "trigger", {})
    end
end

function do_bury(something, where)
    local nfa_me = nfa_helper:get_info()
    if something == "苗刀" and where == "牌坊" then
        exit_narrate();
        contract_helper:exit_nfa_mirage(nfa_me.id)
        contract_helper:eval_nfa_action(nfa_me.id, "look", {""})
        -- 自动激活一次心跳，回到正常状态
        contract_helper:do_nfa_action(nfa_me.id, "active", {})
    end    
end

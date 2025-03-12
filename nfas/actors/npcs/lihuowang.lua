welcome = { consequence = false }
look = { consequence = false }
inventory = { consequence = false }
hp = { consequence = false }
resource = { consequence = false }
map = { consequence = false }
help = { consequence = false }

go = { consequence = true }
deposit_qi = { consequence = true }
withdraw_qi = { consequence = true }
exploit = { consequence = true }
start_cultivation = { consequence = true }
stop_cultivation = { consequence = true }
eat = { consequence = true }
touch = { consequence = true }
active = { consequence = true }

function init_data()
    return {
        is_actor = true,
        unit = '个'
    }
end

function get_title()
    return "修真者"
end

function eval_help()
    import_contract('contract.help.actors.cultivator').help();
end

function eval_welcome()
    import_contract('contract.welcome').welcome();
end

function eval_look(target)
    local look = import_contract("contract.cmds.std.look").look
    look(target)
end

function eval_inventory(target, options)
    local inventory = import_contract("contract.cmds.actor.inventory").inventory
    inventory(target, options)
end

function eval_hp(target, option)
    local hp = import_contract("contract.cmds.actor.hpcmd").hp
    hp(target, option)
end

function eval_resource(target, option)
    local resource = import_contract("contract.cmds.actor.resource").resource
    resource(target, option)
end

function eval_map(target)
    local map = import_contract("contract.cmds.std.map").map
    map(target)
end

function check_live()
    local nfa_me = nfa_helper:get_info()
    local actor_me = contract_helper:get_actor_info(nfa_me.id)
    assert(actor_me.health > 0, string.format('&YEL&%s&NOR&已经去世了', actor_me.name))
end

function do_go(dir)
    check_live()
    local go = import_contract("contract.cmds.std.gocmd").go
    go(dir)
end

function do_eat(something)
    check_live()
    local eat = import_contract("contract.cmds.std.eat").eat
    eat(something)
end

function do_exploit(something)
    check_live()
    if something == "" then
        local exploit = import_contract("contract.cmds.std.exploit").exploit
        exploit()
    elseif something == "zone"  then
        local break_new_zone = import_contract("contract.cmds.std.exploit").break_new_zone
        break_new_zone()
    end
end

function do_start_cultivation()
    local start = import_contract("contract.cmds.std.cultivation").start
    local qi = nfa_helper:get_info().qi / 2
    start(math.floor(qi))
end

function do_stop_cultivation()
    local stop = import_contract("contract.cmds.std.cultivation").stop
    stop()
end

function do_active()
    nfa_helper:enable_tick()

    local nfa_me = nfa_helper:get_info()
    local actor = contract_helper:get_actor_info(nfa_me.id)
    contract_helper:narrate(string.format('&YEL&%s&NOR&意灌丹田，尝试导引真气。', actor.name), true)
end

function on_heart_beat()
    local nfa_me = nfa_helper:get_info()
    local actor = contract_helper:get_actor_info(nfa_me.id)

    local nfa_data = nfa_helper:read_contract_data({ last_cultivation_time=true })
    if nfa_data.last_cultivation_time == nil or nfa_data.last_cultivation_time == 0 then
        if actor.health == 0 or nfa_me.qi < 1000000 then
            contract_helper:narrate(string.format('&YEL&%s&NOR&感到身体太差，准备开始修真。', actor.name), true)
            do_start_cultivation()
            nfa_data.last_cultivation_time = contract_helper:block()
            nfa_helper:write_contract_data(nfa_data, { last_cultivation_time=true })
        end
    elseif contract_helper:block() >= (nfa_data.last_cultivation_time + 200) then
        -- 大约10分钟后停止修真
        do_stop_cultivation()
        nfa_data.last_cultivation_time = 0
        nfa_helper:write_contract_data(nfa_data, { last_cultivation_time=true })
    end

    local task1_tick = import_contract('contract.tasks.niuxincun.patrol').tick
    task1_tick()

    -- local task2_tick = import_contract('contract.tasks.niuxincun.mirage').tick
    -- task2_tick()
end

function do_deposit_qi(amount)
    assert(amount > 0, "设置的真气无效")
    nfa_helper:deposit_from(contract_base_info.caller, amount, "QI", true)
end

function do_withdraw_qi(amount)
    assert(amount > 0, "设置的真气无效")

    local nfa = nfa_helper:get_info()
    assert(nfa.qi >= amount, "角色体内真气不足")

    assert(contract_base_info.caller == nfa.owner_account, "无权从角色体内提取真气")
    nfa_helper:withdraw_to(nfa.owner_account, amount, "QI", true)
end

-- 成长回调函数
function on_grown()
    -- local tiandao = contract_helper:get_tiandao_property()
    local nfa_me = nfa_helper:get_info()
    local actor = contract_helper:get_actor_info(nfa_me.id)
    contract_helper:narrate(string.format('&YEL&%s&NOR&成长到&YEL&%d&NOR&岁，健康&YEL&%d&NOR&。', actor.name, actor.age, actor.health), true)
end

function do_touch(target_name)
    local nfa_me = nfa_helper:get_info()
    local actor = contract_helper:get_actor_info(nfa_me.id)
    local inv = contract_helper:list_nfa_inventory(nfa_me.id, "")
    if #inv == 0 then
        contract_helper:narrate(string.format('    &YEL&%s&NOR&没有&YEL&%s&NOR&', actor.name, target_name), false)
    else
        Item = import_contract('contract.inherit.item').Item
        for i, obj in pairs(inv) do
            local item = Item:new(obj)
            local short_name = item:short()
            if target_name == short_name then
                contract_helper:do_nfa_action(obj.id, "touch", {actor.name})
                break
            end
        end
    end
end
welcome = { consequence = false }
look = { consequence = false }
inventory = { consequence = false }
hp = { consequence = false }
resource = { consequence = false }
map = { consequence = false }

go = { consequence = true }
deposit_qi = { consequence = true }
withdraw_qi = { consequence = true }
exploit = { consequence = true }
start_cultivation = { consequence = true }
stop_cultivation = { consequence = true }
eat = { consequence = true }

function init_data()
    return {
        is_actor = true,
        unit = '个'
    }
end

function get_title()
    return "普通百姓"
end

function eval_welcome()
    import_contract('contract.welcome').welcome();
end

function eval_look(target)
    local look = import_contract("contract.cmds.std.look").look
    look(target)
end

function eval_inventory(target)
    local inventory = import_contract("contract.cmds.actor.inventory").inventory
    inventory(target)
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

function on_heart_beat()
    local nfa_me = nfa_helper:get_info()
    local actor = contract_helper:get_actor_info(nfa_me.id)
    contract_helper:narrate(string.format("这里是&YEL&%s&NOR&的心跳。", actor.name), false)
end

function do_deposit_qi(amount)
    assert(amount > 0, "设置的真气无效")
    nfa_helper:deposit_from(contract_base_info.caller, amount, "QI", true)
end

function do_withdraw_qi(amount)
    assert(amount > 0, "设置的真气无效")

    local nfa = nfa_helper:get_info()
    assert(nfa.qi < amount, "角色体内真气不足")

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
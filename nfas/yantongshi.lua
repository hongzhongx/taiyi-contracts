born_actor = { consequence = true }
upgrade_actor = { consequence = true }
place_in = { consequence = true }
take_out = { consequence = true }
deposit_resource = { consequence = true }

-- 返回一个table
function init_data()
    return {
        name = "衍童石",
        unit = "块"
    }
end

function do_deposit_resource(amount, symbol)
    assert(amount > 0, "设置的资源数量无效")
    nfa_helper:deposit_from(contract_base_info.caller, amount, symbol, true)
end

-- 出生角色
-- gender: 0=random, -1=男, 1=女, -2=男生女相, 2=女生男相
-- sexuality: 0=无性取向，1=喜欢男性，2=喜欢女性，3=双性恋
-- material_ratio: 将法宝材料注入到角色体内的比率万分比，[0, 10000]
-- 注意，这个行为的调用是从法宝的角度进来的，所以caller nfa是法宝，不是角色
function do_born_actor(actor_name, gender, sexuality, init_attrs, material_ratio)
    local nfa = nfa_helper:get_info()
    assert(contract_helper:is_nfa_valid(nfa.parent), "法宝未安置好")
    local parent_nfa = contract_helper:get_nfa_info(nfa.parent)
    assert(parent_nfa.data.is_zone, "法宝未安置在区域上")
    local zone = contract_helper:get_zone_info(nfa.parent)

    assert(contract_helper:is_actor_valid_by_name(actor_name), string.format('未找到名为"%s"的角色', actor_name))
    local actor = contract_helper:get_actor_info_by_name(actor_name)
    assert(actor.born == false, string.format('"%s"已经在世了', actor_name))

    assert(#init_attrs == 8, '初始属性参数的数目不匹配，必须是八个属性值')

    contract_helper:born_actor(actor_name, gender, sexuality, init_attrs, zone.name)
    -- update actor info after born
    actor = contract_helper:get_actor_info_by_name(actor_name)
    assert(actor.born == true, string.format('"%s"出生失败', actor_name))

    -- 按等比率将法宝托管的资源材料注入物质给角色NFA，这样角色的五行将由法宝资源确定
    local resources = contract_helper:get_nfa_resources(nfa.id)
    local gold = resources.gold * material_ratio / 10000
    local food = resources.food * material_ratio / 10000
    local wood = resources.wood * material_ratio / 10000
    local fabric = resources.fabric * material_ratio / 10000
    local herb = resources.herb * material_ratio / 10000
    if gold > 0 then
        nfa_helper:inject_material_to(actor.nfa_id, gold, "GOLD", true)
    end
    if food > 0 then
        nfa_helper:inject_material_to(actor.nfa_id, food, "FOOD", true)
    end
    if wood > 0 then
        nfa_helper:inject_material_to(actor.nfa_id, wood, "WOOD", true)
    end
    if fabric > 0 then
        nfa_helper:inject_material_to(actor.nfa_id, fabric, "FABR", true)
    end
    if herb > 0 then
        nfa_helper:inject_material_to(actor.nfa_id, herb, "HERB", true)
    end

    contract_helper:log(string.format('%d年%d月，"%s"在%s出生了', actor.born_vyears, actor.born_vmonths, actor_name, zone.name))
end

-- 升级角色（主合约升级）
-- 注意，这个行为的调用是从法宝的角度进来的，所以caller nfa是法宝，不是角色
function do_upgrade_actor(actor_name)
    local nfa = nfa_helper:get_info()
    assert(contract_helper:is_nfa_valid(nfa.parent), "法宝未安置好")
    local parent_nfa = contract_helper:get_nfa_info(nfa.parent)
    assert(parent_nfa.data.is_zone, "法宝未安置在区域上")
    local zone = contract_helper:get_zone_info(nfa.parent)

    assert(contract_helper:is_actor_valid_by_name(actor_name), string.format('未找到名为"%s"的角色', actor_name))
    local actor = contract_helper:get_actor_info_by_name(actor_name)
    assert(actor.location == zone.name, string.format('角色"%s"需要位于法宝所在地"%s"', actor_name, zone.name))

    -- 角色nfa的symbol不会改变，仅仅改变nfa的主合约
    contract_helper:change_nfa_contract(actor.nfa_id, "contract.actor.normal")
    contract_helper:log(string.format('"%s"整个人发生了一些变化', actor_name))
end

function do_place_in(parent)
    -- check parent valid by get_nfa_info
    local parent_nfa = contract_helper:get_nfa_info(parent)
    -- parent_nfa must have same owner as caller account
    nfa_helper:add_to_parent(parent_nfa.id)
end

function do_take_out()
    nfa_helper:remove_from_parent()
end

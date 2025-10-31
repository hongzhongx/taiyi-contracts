short = { consequence = false }
long = { consequence = false }
help = { consequence = false }

born_actor = { consequence = true }
upgrade_actor = { consequence = true }
upgrade_actor_cultivator = { consequence = true }
upgrade_actor_with = { consequence = true }
set_zone = { consequence = true }
deposit_resource = { consequence = true }

-- 返回一个table
function init_data()
    return {
        name = "衍童石",
        unit = "块",
        set_zone = -1   -- zone nfa id
    }
end

function eval_help()
  local ss = [[
&WHT&『&HIY&衍童石可用命令&NOR&&WHT&』
    &HIG&绿色命令&NOR&为产生影响（因果）的命令，需要消耗真气并等待天道网络响应

    &WHT&help []&NOR&                                  - 显示本帮助

    &HIG&born_actor ["角色名", 性别, 性取向, 初始属性列表, 物性]&NOR&         - 出生角色
        角色名：必须是已经创建但未出生的角色
        性别：0=随机，-1=男，1=女，-2=男生女相，2=女生男相
        性取向：0=无性取向，1=喜欢男性，2=喜欢女性，3=双性恋
        初始属性列表：一个包含八个整数的列表，对应初始的八项核心属性（体质、根骨、悟性、灵根、力量、敏捷、定力、魅力）
        物性：将法宝材料注入到角色体内的比率万分比，[0, 10000]，10000表示全部注入
    &HIG&upgrade_actor ["角色名"]&NOR&                  - 升级某人为普通角色
    &HIG&upgrade_actor_cultivator ["角色名"]&NOR&       - 升级某人为修炼者角色
    &HIG&upgrade_actor_with ["角色名", "主合约名"]&NOR&  - 升级某人为指定主合约的角色
        角色名：必须是已经出生的角色
        主合约名：例如"contract.actor.someone"
    &HIG&set_zone [区域nfa_id]&NOR&                     - 设置法宝所在区域
        区域nfa_id：必须是一个有效的区域nfa id
    &HIG&deposit_resource [数量, 资源符号]&NOR&          - 向法宝内存入资源
        资源符号：GOLD=金钱, FOOD=食物, WOOD=木材, FABR=织物, HERB=草药
        资源数量：必须是正整数
]]
  contract_helper:narrate(ss, false)
end

function eval_short()
    local nfa_data = nfa_helper:read_contract_data({ name=true })
	return { nfa_data.name }
end

function eval_long()
    local nfa_data = nfa_helper:read_contract_data({ name=true })
	return { "这是一块" .. nfa_data.name .. "，这个法宝用来出生和升级角色" }
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
    local nfa_data = nfa_helper:read_contract_data({ set_zone=true })
    assert(nfa_data.set_zone ~= -1 and contract_helper:is_nfa_valid(nfa_data.set_zone), "法宝未安置好")
    local zone_nfa = contract_helper:get_nfa_info(nfa_data.set_zone)
    assert(zone_nfa.data.is_zone, "法宝未安置在区域上")
    local zone = contract_helper:get_zone_info(nfa_data.set_zone)

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

    contract_helper:narrate(string.format('%d年%d月，"%s"在%s出生了', actor.born_vyears, actor.born_vmonths, actor_name, zone.name), false)
end

-- 升级角色（主合约升级）
-- 注意，这个行为的调用是从法宝的角度进来的，所以caller nfa是法宝，不是角色
function do_upgrade_actor(actor_name)
    local nfa_data = nfa_helper:read_contract_data({ set_zone=true })
    assert(nfa_data.set_zone ~= -1 and contract_helper:is_nfa_valid(nfa_data.set_zone), "法宝未安置好")
    local zone_nfa = contract_helper:get_nfa_info(nfa_data.set_zone)
    assert(zone_nfa.data.is_zone, "法宝未安置在区域上")
    local zone = contract_helper:get_zone_info(nfa_data.set_zone)

    assert(contract_helper:is_actor_valid_by_name(actor_name), string.format('未找到名为"%s"的角色', actor_name))
    local actor = contract_helper:get_actor_info_by_name(actor_name)
    assert(actor.location == zone.name, string.format('角色"%s"需要位于法宝所在地"%s"', actor_name, zone.name))

    -- 角色nfa的symbol不会改变，仅仅改变nfa的主合约
    contract_helper:change_nfa_contract(actor.nfa_id, "contract.actor.normal")
    contract_helper:narrate(string.format('&YEL&%s&NOR&整个人发生了一些变化', actor_name), true)
end

function do_upgrade_actor_cultivator(actor_name)
    local nfa_data = nfa_helper:read_contract_data({ set_zone=true })
    assert(nfa_data.set_zone ~= -1 and contract_helper:is_nfa_valid(nfa_data.set_zone), "法宝未安置好")
    local zone_nfa = contract_helper:get_nfa_info(nfa_data.set_zone)
    assert(zone_nfa.data.is_zone, "法宝未安置在区域上")
    local zone = contract_helper:get_zone_info(nfa_data.set_zone)

    assert(contract_helper:is_actor_valid_by_name(actor_name), string.format('未找到名为"%s"的角色', actor_name))
    local actor = contract_helper:get_actor_info_by_name(actor_name)
    assert(actor.location == zone.name, string.format('角色"%s"需要位于法宝所在地"%s"', actor_name, zone.name))

    -- 角色nfa的symbol不会改变，仅仅改变nfa的主合约
    contract_helper:change_nfa_contract(actor.nfa_id, "contract.actor.cultivator")
    contract_helper:narrate(string.format('&YEL&%s&NOR&整个人发生了一些变化', actor_name), true)
end

function do_upgrade_actor_with(actor_name, main_contract)
    local nfa_data = nfa_helper:read_contract_data({ set_zone=true })
    assert(nfa_data.set_zone ~= -1 and contract_helper:is_nfa_valid(nfa_data.set_zone), "法宝未安置好")
    local zone_nfa = contract_helper:get_nfa_info(nfa_data.set_zone)
    assert(zone_nfa.data.is_zone, "法宝未安置在区域上")
    local zone = contract_helper:get_zone_info(nfa_data.set_zone)

    assert(contract_helper:is_actor_valid_by_name(actor_name), string.format('未找到名为"%s"的角色', actor_name))
    local actor = contract_helper:get_actor_info_by_name(actor_name)
    assert(actor.location == zone.name, string.format('角色"%s"需要位于法宝所在地"%s"', actor_name, zone.name))

    -- 角色nfa的symbol不会改变，仅仅改变nfa的主合约
    contract_helper:change_nfa_contract(actor.nfa_id, main_contract)
    contract_helper:narrate(string.format('&YEL&%s&NOR&整个人发生了一些变化', actor_name), true)
end

function do_set_zone(zone_nfa_id)
    -- check nfa valid by get_nfa_info
    local zone_nfa = contract_helper:get_nfa_info(zone_nfa_id)
    assert(zone_nfa.data.is_zone, "法宝必须安置在区域上")
    local zone = contract_helper:get_zone_info(zone_nfa_id)

    local nfa_data = nfa_helper:read_contract_data({ name=true, set_zone=true })
    nfa_data.set_zone = zone_nfa_id
	nfa_helper:write_contract_data(nfa_data, { set_zone=true })

    contract_helper:narrate(string.format('&YEL&%s&NOR&写上了一个地区的名字——&HIC&%s&HIC&', nfa_data.name, zone.name), false)
end

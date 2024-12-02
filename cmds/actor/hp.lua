chinese_types = import_contract("contract.utils.types")

function status_color(current, max)
    local percent
    if max > 0 then
        percent = current * 100 / max;
    else
        percent = 100
    end

    if percent > 100 then
        return '&HIC&'
    elseif percent >= 90 then
        return '&HIG&'
    elseif percent >= 60 then
        return '&HIY&'
    elseif percent >= 30 then
        return '&YEL&'
    elseif percent >= 10 then
        return '&HIR&'
    else
        return '&RED&'
    end
end

function gender_desc_data(gender)
    if gender == -2 then return "男生女相"
    elseif gender == -1 then return "男"
    elseif gender == 0 then return "无性"
    elseif gender == 1 then return "女"
    elseif gender == 2 then return "女生男相"
    elseif gender == 3 then return "双性"
    else
        assert(false, "gender invalid")
    end
end

function standpoint_type_descs(type)
    if type == 0 then return "刚正"
    elseif type == 1 then return "仁善"
    elseif type == 2 then return "中庸"
    elseif type == 3 then return "叛逆"
    elseif type == 4 then return "唯我"
    else
        assert(false, "standpoint type invalid")
    end
end

function standpoint_type_color(type)
    if type == 0 then return "&YEL&"
    elseif type == 1 then return "&HIC&"
    elseif type == 2 then return "&HIW&"
    elseif type == 3 then return "&HIM&"
    elseif type == 4 then return "&HIR&"
    else
        assert(false, "standpoint type invalid")
    end
end

function five_phases_color(type)
    if type == 0 then return "&YEL&"
    elseif type == 1 then return "&CYN&"
    elseif type == 2 then return "&BLU&"
    elseif type == 3 then return "&HIR&"
    elseif type == 4 then return "&HIW&"
    else
        assert(false, "standpoint type invalid")
    end
end

function hp(target, option)
    local nfa_me = nfa_helper:get_info()
    local nfa_info = {}
    local obj_info = {}
    if target == "" then
        nfa_info = nfa_me
        if contract_helper:is_actor_valid(nfa_info.id) then
            obj_info = contract_helper:get_actor_info(nfa_info.id)
        elseif contract_helper:is_zone_valid(nfa_info.id) then
            obj_info = contract_helper:get_zone_info(nfa_info.id)
        else
            contract_helper:log('还无法查看。')
            return
        end
    elseif type(target) == "string" then
        if contract_helper:is_actor_valid_by_name(target) then
            obj_info = contract_helper:get_actor_info_by_name(target)
        elseif contract_helper:is_zone_valid_by_name(target) then
            obj_info = contract_helper:get_zone_info_by_name(target)
        else
            contract_helper:log(string.format('还无法查看%s。', target))
            return
        end
        nfa_info = contract_helper:get_nfa_info(obj_info.nfa_id)
    else
        contract_helper:log('无法查看未知事物。')
        return
    end

    if nfa_info.data.is_actor ~= true then
        contract_helper:log("目前只能查看角色。")
        return
    end

    if not obj_info.born then
        contract_helper:log("还没有出生呐，察看什么？")
    elseif option == "" then
        Zone = import_contract("contract.inherit.zone").Zone
        local location_zone = Zone:new(contract_helper:get_zone_info_by_name(obj_info.location))
        local ss = "你目前的状态属性如下：\n"
        ss = ss .. '&HIC&≡&HIY&----------------------------------------------------------------&HIC&≡&NOR&\n'
        ss = ss .. string.format('&HIC&【 年 龄 】 &GRN&%5d                      &HIC&【 性 别 】   &GRN&%s\n',
            obj_info.age, gender_desc_data(obj_info.gender))
        ss = ss .. string.format('&HIC&【 立 场 】   %s%s                     &HIC&【 健 康 】 %s%5d / %5d\n',
            standpoint_type_color(obj_info.standpoint_type), standpoint_type_descs(obj_info.standpoint_type),
            status_color(obj_info.health, obj_info.health_max), obj_info.health, obj_info.health_max)
        ss = ss .. string.format('&HIC&【 出生时节 】&GRN&%s                     &HIC&【 位 于 】   &GRN&%s\n',
            chinese_types.solar_term_data[obj_info.born_vtimes], location_zone:short())
        ss = ss .. string.format('&HIC&【 五 行 】   %s%s                       &HIC&【 从 属 】   &GRN&%s\n',
            five_phases_color(obj_info.five_phase), chinese_types.five_phases_data[obj_info.five_phase+1], obj_info.base)
        ss = ss .. string.format('&HIC&【 健 康 】 %s%5d/ %5d               &HIC&【 年 龄 】 %s%5d / %5d\n',
            status_color(obj_info.health, obj_info.health_max), obj_info.health, obj_info.health_max,
            status_color(obj_info.age, 100), obj_info.age, 100)
        ss = ss .. '&HIC&≡&HIY&----------------------------------------------------------------&HIC&≡&NOR&\n'
        contract_helper:log(ss)
    elseif option == '-c' then
        local attributes = contract_helper:get_actor_core_attributes(obj_info.nfa_id)
        local ss = "你目前的状态属性如下：\n"
        ss = ss .. '&HIC&≡&HIY&----------------------------------------------------------------&HIC&≡&NOR&\n'
        ss = ss .. string.format('&HIC&【 膂 力 】 %s%5d/ %5d               &HIC&【 体 质 】 %s%5d / %5d\n',
            status_color(attributes.strength, attributes.strength_max), obj_info.health, obj_info.health_max,
            status_color(attributes.physique, attributes.physique_max), attributes.physique, attributes.physique_max)
        ss = ss .. string.format('&HIC&【 灵 敏 】 %s%5d/ %5d               &HIC&【 根 骨 】 %s%5d / %5d\n',
            status_color(attributes.agility, attributes.agility_max), attributes.agility, attributes.agility_max,
            status_color(attributes.vitality, attributes.vitality_max), attributes.vitality, attributes.vitality_max)
        ss = ss .. string.format('&HIC&【 悟 性 】 %s%5d/ %5d               &HIC&【 定 力 】 %s%5d / %5d\n',
            status_color(attributes.comprehension, attributes.comprehension_max), attributes.comprehension, attributes.comprehension_max,
            status_color(attributes.willpower, attributes.willpower_max), attributes.willpower, attributes.willpower_max)
        ss = ss .. string.format('&HIC&【 魅 力 】 %s%5d/ %5d               &HIC&【 心 情 】 %s%5d / %5d\n',
            status_color(attributes.charm, attributes.charm_max), attributes.charm, attributes.charm_max,
            status_color(attributes.mood, attributes.mood_max), attributes.mood, attributes.mood_max)
        ss = ss .. '&HIC&≡&HIY&----------------------------------------------------------------&HIC&≡&NOR&\n'
        contract_helper:log(ss)
    end
end

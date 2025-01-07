chinese_types = import_contract("contract.utils.types")

function resource(target, option)
    local nfa_me = nfa_helper:get_info()
    local nfa_info = {}
    if target == "" then
        nfa_info = nfa_me
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

    if option == "" then
        local resources = contract_helper:get_nfa_resources(nfa_info.id)
        local ss = "你目前的资源情况如下：\n"
        ss = ss .. '&HIC&≡&HIY&----------------------------------------------------------------&HIC&≡&NOR&\n'
        ss = ss .. string.format('&HIC&【 金 石 】  &GRN&%5.6f               &HIC&【 食 物 】    &GRN&%5.6f\n',
            resources.gold / 100000.0, resources.food / 1000000.0)
        ss = ss .. string.format('&HIC&【 木 材 】  &GRN&%5.6f               &HIC&【 织 物 】    &GRN&%5.6f\n',
            resources.wood / 100000.0, resources.fabric / 1000000.0)
        ss = ss .. string.format('&HIC&【 药 材 】  &GRN&%5.6f\n',
            resources.herb / 100000.0)
        ss = ss .. '&HIC&≡&HIY&----------------------------------------------------------------&HIC&≡&NOR&\n'
        contract_helper:log(ss)
    elseif option == '-m' then
        local materials = contract_helper:get_nfa_materials(nfa_info.id)
        local ss = "你目前的材质情况如下：\n"
        ss = ss .. '&HIC&≡&HIY&----------------------------------------------------------------&HIC&≡&NOR&\n'
        ss = ss .. string.format('&HIC&【 金 石 】  &GRN&%5.6f               &HIC&【 食 物 】    &GRN&%5.6f\n',
            materials.gold / 100000.0, materials.food / 1000000.0)
        ss = ss .. string.format('&HIC&【 木 材 】  &GRN&%5.6f               &HIC&【 织 物 】    &GRN&%5.6f\n',
            materials.wood / 100000.0, materials.fabric / 1000000.0)
        ss = ss .. string.format('&HIC&【 药 材 】  &GRN&%5.6f\n',
            materials.herb / 100000.0)
        ss = ss .. string.format('&HIC&【 五 行 】   %s%s\n',
            chinese_types.five_phases_color(nfa_info.five_phase), chinese_types.five_phases_data[nfa_info.five_phase+1])
        ss = ss .. '&HIC&≡&HIY&----------------------------------------------------------------&HIC&≡&NOR&\n'
        contract_helper:log(ss)
    end
end
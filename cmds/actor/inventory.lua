function inventory(target)
    local nfa_me = nfa_helper:get_info()
    local nfa_info = {}
    local obj_info = {}
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

    local inv = contract_helper:list_nfa_inventory(nfa_info.id)
    if #inv == 0 then
        if nfa_info.data.is_actor then
            if nfa_info.id == nfa_me.id then
                contract_helper:log("目前你身上没有任何东西。")
            else
                contract_helper:log(string.format("%s身上没有携带任何东西。", target));
            end
        elseif nfa_info.data.is_zone then
            if nfa_info.id == nfa_me.id then
                contract_helper:log("目前你没有任何东西。")
            else
                contract_helper:log(string.format("%s里没有任何东西。", target));
            end
        else
            contract_helper:log(string.format("%s没有包含任何东西。", target));
        end
        return
    end

    local str = ""
    if nfa_info.data.is_actor then
        if nfa_info.id == nfa_me.id then
            str = "你身上带着下列这些东西：\n"
        else
            str = string.format("%s身上带着下列这些东西：\n", target)
        end
    elseif nfa_info.data.is_zone then
        if nfa_info.id == nfa_me.id then
            str = "你身上有下列这些东西：\n"
        else
            str = string.format("%s有下列这些东西：\n", target)
        end
    else
        str = string.format("%s包含下列这些东西：\n", target)
    end

    local item_count = {};
    local item_unit = {};
    local equiped = {};

    Item = import_contract('contract.inherit.item').Item
    for i, obj in pairs(inv) do
        local item = Item:new(obj)
        local short_name = item:short()
        if item_count[short_name] == nil then
            item_count[short_name] = 1
        else
            item_count[short_name] = item_count[short_name] + 1
        end
        if item:unit() then
            item_unit[short_name] = item:unit()
        end
    end

    local handing_name = ""

    for n, ct in pairs(item_count) do
        if n == handing_name then
            -- handing now
            str = str .. "&HIM&□ &NOR&"
        elseif equiped[n] then
            str = str .. "&HIC&□ &NOR&"
        else
            str = str .. "  "
        end

        if ct > 1 then
            local chinese_number = import_contract('contract.utils.numbers').chinese_number
            str = str .. chinese_number(ct) .. (item_unit[n] or "个")
        end
        str = str .. '&HIC&' .. n .. "&NOR&\n"
    end
    contract_helper:log(str)
end

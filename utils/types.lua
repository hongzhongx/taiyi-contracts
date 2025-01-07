solar_term_data = {"立春","雨水","惊蛰","春分","清明","谷雨","立夏","小满","芒种","夏至","小暑","大暑","立秋","处暑","白露","秋分","寒露","霜降","立冬","小雪","大雪","冬至","小寒","大寒"}

five_phases_data = {"金","木","水","火","土"}
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

zone_type_strings = {"虚空","原野","湖泊","农田","林地","密林","园林","山岳","洞穴","石林","丘陵","桃源","桑园","峡谷","沼泽","药园","海洋","沙漠","荒野","暗渊","都会","门派","市镇","关寨","村庄"}

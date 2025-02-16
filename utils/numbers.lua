c_digit = {"零", "十", "百", "千", "万", "亿", "兆"}
c_num = {"零", "一", "二", "三", "四", "五", "六", "七", "八", "九", "十"}

function chinese_number(i)
    if i < 0 then
        return "负" .. chinese_number(-i)
    elseif i < 11 then
        return c_num[i + 1]
    elseif i < 20 then
        return c_digit[1] .. c_num[i - 10 + 1]
    elseif i < 100 then
        if i % 10 then
            return c_num[i / 10 + 1] .. c_digit[1] .. c_num[i % 10 + 1]
        else
            return c_num[i / 10 + 1] .. c_digit[1]
        end
    elseif i < 1000 then
        if i % 100 == 0 then
            return c_num[i / 100 + 1] .. c_digit[2]
        elseif i % 100 < 10 then
            return c_num[i / 100 + 1] .. c_digit[2] .. c_num[0 + 1] .. chinese_number(i % 100)
        elseif i % 100 < 10 then
            return c_num[i / 100 + 1] .. c_digit[2] .. c_num[1 + 1] .. chinese_number(i % 100)
        else
            return c_num[i / 100 + 1] .. c_digit[2] .. chinese_number(i % 100)
        end
    elseif i < 10000 then
        if i % 1000 == 0 then
            return c_num[i / 1000 + 1] .. c_digit[3]
        elseif i % 1000 < 100 then
            return c_num[i / 1000 + 1] .. c_digit[3] .. c_num[0 + 1] .. chinese_number(i % 1000)
        else
            return c_num[i / 1000 + 1] .. c_digit[3] .. chinese_number(i % 1000)
        end
    elseif i < 100000000 then
        if i % 10000 == 0 then
            return chinese_number(i / 10000) .. c_digit[4]
        elseif i % 10000 < 1000 then
            return chinese_number(i / 10000) .. c_digit[4] .. c_num[0 + 1] .. chinese_number(i % 10000)
        else
            return chinese_number(i / 10000) .. c_digit[4] .. chinese_number(i % 10000)
        end
    elseif i < 1000000000000 then
        if i % 100000000 == 0 then
            return chinese_number(i / 100000000) .. c_digit[5]
        elseif i % 100000000 < 1000000 then
            return chinese_number(i / 100000000) .. c_digit[5] .. c_num[0 + 1] .. chinese_number(i % 100000000)
        else
            return chinese_number(i / 100000000) .. c_digit[5] .. chinese_number(i % 100000000)
        end
    end

    if i % 1000000000000 == 0 then
        return chinese_number(i / 1000000000000) .. c_digit[6]
    elseif i % 1000000000000 < 100000000 then
        return chinese_number(i / 1000000000000) .. c_digit[6] .. c_num[0 + 1] .. chinese_number(i % 1000000000000)
    else
        return chinese_number(i / 1000000000000) .. c_digit[6] .. chinese_number(i % 1000000000000)
    end
end

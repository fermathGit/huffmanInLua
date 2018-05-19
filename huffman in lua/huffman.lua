require("printTable")
require("numConvert")

huffman = {}

local m = huffman

huffman.fixLenBin = {} --二进制码
huffman.huffmanBin = {} --二进制码
huffman.fixedLengthCount = nil --定长编码的长度

function m:split(szFullString, szSeparator)
    local nFindStartIndex = 1
    local nSplitIndex = 1
    local nSplitArray = {}
    while true do
        local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)
        if not nFindLastIndex then
            nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))
            break
        end
        nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
        nFindStartIndex = nFindLastIndex + string.len(szSeparator)
        nSplitIndex = nSplitIndex + 1
    end
    return nSplitArray
end

function m:getTable(str)
    return m:split(str, ",")
end

function m:twoPower(num)
    index = 1
    while math.pow(2, index) < num do
        index = index + 1
    end
    return index
end

function huffman:fixedLengthSerialize(str)
    local t = m:getTable(str)
    local frequency = {}
    local frequencyCount = 0
    local ret = ""
    fixLenBin = {}

    huffman:myPrint("log t")
    for k, v in pairs(t) do
        huffman:myPrint2(k, v)
        if frequency[v] == nil then
            frequency[v] = 1
            frequencyCount = frequencyCount + 1
        else
            frequency[v] = frequency[v] + 1
        end
    end
    huffman:myPrint("******************end*********************")

    huffman:myPrint("lenght:" .. frequencyCount)

    fixedLengthCount = m:twoPower(frequencyCount)

    huffman:myPrint("fixedLengthCount:" .. fixedLengthCount)

    huffman:myPrint("log frequency")
    local startOne = 1

    for k, v in pairs(frequency) do
        huffman:myPrint2(k, v)
        local res = ConvertDec2X(startOne, 2)
        while string.len(res) < fixedLengthCount do
            res = "0" .. res
        end
        fixLenBin[k] = res
        startOne = startOne + 1
    end
    huffman:myPrint("******************end*********************")

    huffman:myPrint("log fixLenBin")
    for k, v in pairs(fixLenBin) do
        huffman:myPrint2(k, v)
    end
    huffman:myPrint("******************end*********************")

    for k, v in pairs(t) do
        ret = ret .. fixLenBin[v]
    end

    return ret
end

function string_foreach(str, func)
    str:gsub(
        ".",
        function(c)
            func(c)
        end
    )
end

function huffman:fixedLengthDeserialize(bin)
    local temp = ""
    local ret = ""
    string_foreach(
        bin,
        function(char)
            temp = temp .. char
            if string.len(temp) == fixedLengthCount then
                local findValue = nil
                for k, v in pairs(fixLenBin) do
                    if v == temp then
                        findValue = k
                    end
                end

                ret = ret .. findValue
                temp = ""
            end
        end
    )
    return ret
end

function m:findValueInTable(table, value)
    for k, v in pairs(table) do
        if v == valua then
            return k
        end
    end
    return nil
end

function huffman:huffmanSerialize(str)
    local t = m:getTable(str)
    local frequency = {}
    local frequencyCount = 0
    local frequencyRate = {}
    local count = 0
    local ret = ""
    huffmanBin = {}

    huffman:myPrint("log t")
    for k, v in pairs(t) do
        huffman:myPrint2(k, v)
        count = count + 1
        if frequency[v] == nil then
            frequency[v] = 1
            frequencyCount = frequencyCount + 1
        else
            frequency[v] = frequency[v] + 1
        end
    end
    huffman:myPrint("******************end*********************")

    huffman:myPrint("log frequency")

    for k, v in pairs(frequency) do
        huffman:myPrint2(k, v)
        local temp = {}
        temp["rate"] = v / count
        temp["info"] = k
        table.insert(frequencyRate, temp)
    end
    huffman:myPrint("******************end*********************")
    print_r(frequencyRate)
    huffman:myPrint("log frequencyRate")

    for i = 1, frequencyCount do
        table.sort(
            frequencyRate,
            function(a, b)
                return a.rate < b.rate
            end
        )
        print_r(frequencyRate)
        local min1, min2 = nil
        for i, v in pairs(frequencyRate) do
            if i == 1 then
                min1 = v
            end
            if i == 2 then
                min2 = v
            end
        end

        local temp = {}
        temp["rate"] = tonumber(min1.rate) + tonumber(min2.rate)
        temp["info"] = {}
        table.insert(temp["info"], min1)
        table.insert(temp["info"], min2)

        table.insert(frequencyRate, temp)
        min1.rate = 100
        min2.rate = 100
        huffman:myPrint("nil****************************************")

        print_r(frequencyRate)

        huffman:myPrint("******************end*********************")
    end

    huffman:myPrint("******************result*********************")
    print_r(frequencyRate)

    local notOk = true
    local left, right
    local tempTable = frequencyRate[1].info
    preorder(tempTable, "")
    huffman:myPrint("show")
    print_r(huffmanBin)

    for k, v in pairs(t) do
        ret = ret .. huffmanBin[v]
    end

    return ret
end

function preorder(t, stack)
    if (type(t) ~= "table") then
        huffmanBin[t] = stack
        return
    end
    preorder(t[1].info, stack .. "0")
    preorder(t[2].info, stack .. "1")
end

function huffman:huffmanDeserialize(bin)
    local temp = ""
    local ret = ""
    local isFind = false
    string_foreach(
        bin,
        function(char)
            temp = temp .. char
            local findValue = nil

            for k, v in pairs(huffmanBin) do
                if v == temp then
                    findValue = k
                    isFind = true
                end
            end

            if isFind then
                ret = ret .. findValue
                temp = ""
                isFind = false
            end
        end
    )

    return ret
end

function huffman:myPrint(str)
    if (isPrint == true) then
        print(str)
        printStrings = printStrings .. str .. "\n"
    end
end

function huffman:myPrint2(str1, str2)
    huffman:myPrint(str1 .. "," .. str2)
end

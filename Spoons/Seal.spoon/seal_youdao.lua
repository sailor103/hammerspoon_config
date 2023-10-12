--- === Seal.plugins.youdao ===
---
--- A plugin to add file search capabilities, making Seal act as a spotlight file search
local obj = {}
obj.__index = obj
obj.__name = "seal_youdao"
local utils = require("../../utils")

EMPTY_QUERY = ".*"

-- Public methods
function obj:commands()
    return {
        youdao = {
            cmd = "yd",
            fn = obj.translate,
            name = "Translate By Youdao",
            description = "Translate By Youdao",
            plugin = obj.__name
        }
    }
end

function obj:bare()
    return nil
end

function obj.completionCallback(rowInfo)
    hs.pasteboard.setContents(rowInfo["text"])
end

local function translation_extract(arg)
    if arg then
        if arg.translation then
            return arg.translation
        else
            return {}
        end
    else
        return {}
    end 
end

local function basic_extract(arg)
    if arg then
        return arg.explains
    else
        return {}
    end
end

local function web_extract(arg)
    if arg then
        local value = hs.fnutils.imap(arg, function(item)
            return item.key .. table.concat(item.value, ",")
        end)
        return value
    else
        return {}
    end
end

local function phonetic_extract(decoded_data)
    -- 检查 decoded_data 是否是一个表格
    if type(decoded_data) == "table" then
        -- 检查 decoded_data 是否有一个名为 basic 的字段
        if decoded_data.basic then
            -- 检查 basic 是否是一个表格
            if type(decoded_data.basic) == "table" then
                -- 检查 basic 是否有一个名为 phonetic 的字段
                if decoded_data.basic.phonetic then
                    -- phonetic 存在，返回 true
                    return {decoded_data.basic.phonetic}
                else
                    -- phonetic 不存在，返回 false
                    return {}
                end
            else
                -- basic 不是一个表格，返回 false
                return {}
            end
        else
            -- decoded_data 没有一个名为 basic 的字段，返回 false
            return {}
        end
    else
        -- decoded_data 不是一个表格，返回 false
        return ""
    end
end

local function script_path()
    local str = debug.getinfo(2, "S").source:sub(2)
    return str:match("(.*/)")
end

obj.spoonPath = script_path()

local preQuery = ''

-- 定义一个防抖函数
-- fn: 要执行的函数
-- wait: 等待的时间（毫秒）
-- 返回一个新的函数，该函数在wait时间内只执行一次fn
local function debounce(fn, wait)
    local timer -- 用来保存定时器的句柄
    return function(query)
        -- 清除之前的定时器，如果有的话
        if timer then
            timer:stop()
            timer = nil
        end
        -- 创建一个新的定时器，在wait时间后执行fn，并传入参数
        timer = hs.timer.doAfter(wait / 1000, function()
            fn(query)
            -- timer:stop()
            timer = nil
        end)
    end
end

local function truncate(q)
    local len = utils.utf8len(q)
    -- print('len--'..len)
    if len <= 20 then
        return q
    end
    return utils.utf8sub(q, 1, 10) .. len .. utils.utf8sub(q, len - 9, len)
end

local function merge_tables(...)
    -- 创建一个空的结果table
    local result = {}
    -- 遍历所有的参数table
    for _, t in ipairs({...}) do
      -- 检查t是否是一个table
      if type(t) == "table" then
        -- 遍历t中的所有键值对
        for k, v in pairs(t) do
          -- 将键值对复制到结果table中
        --   result[k] = v
            table.insert(result, v)
        end
      end
    end
    -- 返回结果table
    return result
end
  

local chooser_data = {}

local config = {}

local file = io.open(os.getenv("HOME") .. "/.hammerspoon/config.json", "r")
if file then
    config = hs.json.decode(file:read())
    file:close()
end

function obj.translateByYoudao(query)

    local appKey = config.appKey -- 应用id
    local key = config.key
    local youdao_base_url = "https://openapi.youdao.com/api"
    local salt = math.floor(hs.timer.secondsSinceEpoch())
    local curtime = salt
    local from = "zh-CHS"
    local to = "en"
    local str1 = appKey .. truncate(query) .. salt .. curtime .. key
    local sign = hs.hash.SHA256(str1)
    local data = {
        q = hs.http.encodeForQuery(query),
        appKey = appKey,
        salt = salt,
        from = from,
        to = to,
        sign = sign,
        signType = "v3",
        curtime = curtime
    }

    -- print('-----truncate----' .. truncate(query))

    local queryUrl = youdao_base_url .. "?appKey=" .. data.appKey .. "&signType=" .. data.signType .. "&from=" ..
                         data.from .. "&q=" .. data.q .. "&curtime=" .. data.curtime .. "&sign=" .. data.sign .. "&to=" ..
                         data.to .. "&salt=" .. data.salt

    -- print('query----' .. query)
    -- print('preQuery----' .. preQuery)

    if string.len(query) > 0 and query ~= EMPTY_QUERY and query ~= preQuery then
        preQuery = query
        -- print('preQuery after----' .. preQuery)
        hs.http.asyncGet(queryUrl, nil, function(status, res)
            if status == 200 then
                -- print(res)
                local resContent = hs.json.decode(res)
                -- print(hs.inspect(resContent))
                local decoded_data = hs.json.decode(res)
                if decoded_data.errorCode == "0" then
                    local basictrans = basic_extract(decoded_data.basic)
                    local webtrans = web_extract(decoded_data.web)
                    local translation = translation_extract(decoded_data)
                    local phonetic = phonetic_extract(decoded_data)

                    local dictpool = merge_tables(
                        phonetic,
                        basictrans,
                        webtrans,
                        translation
                    )
                    -- print(hs.inspect(dictpool))
                    -- print('---dict---')
                    -- print(hs.inspect(dictpool))
                    if #dictpool > 0 then
                        chooser_data = hs.fnutils.imap(dictpool, function(item)
                            return {
                                text = item,
                                image = hs.image.imageFromPath(obj.spoonPath .. "/resources/youdao.png"),
                                output = "clipboard",
                                arg = item,
                                plugin = obj.__name
                            }
                        end)

                        -- print(hs.inspect(chooser_data))
                        obj.showQueryResultsTimer = hs.timer.doAfter(0.2, function()
                            obj.showQueryResultsTimer:stop()
                            obj.seal.chooser:refreshChoicesCallback()
                        end)
                    end
                end
            end
        end)
    end
end

local debounced_translate = debounce(obj.translateByYoudao, 1500)

function obj.translate(query)
    -- print('----' .. query .. '----')
    debounced_translate(query)
    return chooser_data
end

return obj

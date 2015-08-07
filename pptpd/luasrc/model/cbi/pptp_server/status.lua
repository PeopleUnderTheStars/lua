f = SimpleForm("user_status", translate("登录状态"), translate("此页面可以查看用户的登录状态."))
f.reset = false
f.submit = false

--- 执行命令返回需要的字符串.
-- @param command	需要执行的字符串命令
-- @return			返回的字符串
function execmd(command)
	local pp   = io.popen(command)
	local data = pp:read()
	pp:close()
	return data
end

-- 获取在线用户信息.
function onlineUser()
	local data = {}
	local k = 1
	local j = 0
	local username
	local userIP
	local connectTime
	local OnlineTimeById
	local ps = luci.util.execi("/bin/busybox ls -l /var/run/pptpd-users/ | awk -F ' ' '{print $9}'")

	if not ps then
		return
	end
--io.popen("echo 'mytest' >/tmp/debug.txt")
	for line in ps do
		username = line
--io.popen("echo " .. username .. " >>/tmp/debug.txt")
		local tmpDevice = execmd("cat /var/run/pptpd-users/" .. username .. " | awk -F ' ' '{print $2}'")
		userIP = execmd("route -n | grep " .. tmpDevice .. " | awk -F ' ' '{print $1}'")
--io.popen("echo " .. userIP .. " >>/tmp/debug.txt")

		local t1 = execmd("date +%s -r /var/run/pptpd-users/" .. username)
		local t2 = os.difftime(os.time(), t1)
		local tmpTimezone = execmd("uci get system.@system[0].timezone")
		if (tmpTimezone == "CST-8")
		then
			t2 = t2 - 3600*8
		end
		if (t2 >= 3600*24)
		then
			t2 = t2 - 3600*24
			OnlineTimeById = os.date("%d天%H:%M:%S", t2)
		else
			OnlineTimeById = os.date("%H:%M:%S", t2)
		end
		connectTime = os.date("%c", t1)
--io.popen("echo " .. OnlineTimeById .. " >>/tmp/debug.txt")
		data[k] = {
			['username']     = username,
			['userIP']    = userIP,
			['connectTime']	= connectTime,
			['OnlineTimeById']    = OnlineTimeById,
		}
		k = k + 1
	end

	return data
end

t = f:section(Table, onlineUser())
t:option(DummyValue, "username", translate("用户名"))
t:option(DummyValue, "userIP", translate("用户IP"))
t:option(DummyValue, "connectTime", translate("建立连接时间"))
t:option(DummyValue, "OnlineTimeById", translate("在线时长"))

kill = t:option(Button, "_kill", translate("下线"))
kill.inputstyle = "reset"
function kill.write(self, section)
	local onlineUserTab = onlineUser()
	local killPid = execmd("cat /var/run/pptpd-users/" .. onlineUserTab[section].username .. " | awk -F ' ' '{print $1}'")
	execmd("kill " .. killPid)
end


return f
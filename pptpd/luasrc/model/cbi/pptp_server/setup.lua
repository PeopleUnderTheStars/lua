require("luci.sys")
--require "nixio"

local m = Map("pptpd", translate("PPTP服务器设置"), translate("此页面可以启用PPTP服务器，设置PPTP客户端所获取的IP，及PPTP服务器的IP<br>"))

local s = m:section(TypedSection, "service", translate("服务器信息"))
s.addremove = false
s.anonymous = true

local PPTPserverEnable = s:option(Flag, "enabled", translate("PPTP服务器开关"))
local PPTPserverIP = s:option(Value, "localip", translate("PPTP服务器IP"))
PPTPserverIP.datatype = "ip4addr"
local PPTPclientIP = s:option(Value, "remoteip", translate("PPTP客户端IP范围"))
PPTPclientIP.datatype = "string"

local apply = luci.http.formvalue("cbi.apply")
if apply then
	io.popen("/etc/init.d/pptpd restart")
end

return m

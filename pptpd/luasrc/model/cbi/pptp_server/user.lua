require("luci.sys")
require("luci.util")

local m = Map("pptpd", translate("PPTP用户设置"), translate("此页面可以设置PPTP服务器客户端的用户名，密码和IP地址。注意，IP地址若留空则在预置范围内分配<br>"))

local s = m:section(TypedSection, "login", translate("用户条目"))
s.addremove = true
s.anonymous = true
s.template = "cbi/tblsection"

local un = s:option(Value, "username", translate("用户名"))
un.datatype = "string"
un.rmempty  = false

local pw = s:option(Value, "password", translate("密码"))
pw.datatype = "string"
pw.rmempty  = false

local ip = s:option(Value, "ip", translate("IP 地址"))
ip.datatype = "ipaddr"
ip.rmempty  = true

local apply = luci.http.formvalue("cbi.apply")
if apply then
	io.popen("/etc/init.d/pptpd restart")
end


return m

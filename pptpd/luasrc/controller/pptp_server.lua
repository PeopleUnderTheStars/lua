module("luci.controller.pptp_server", package.seeall)

function index()
	entry({"admin", "network", "pptp_server"}, alias("admin", "network", "pptp_server", "setup"), _("PPTP服务器"), 30).index = true
	entry({"admin", "network", "pptp_server", "setup"}, cbi("pptp_server/setup"), _("PPTP服务器设置"), 1)
	entry({"admin", "network", "pptp_server", "user"}, cbi("pptp_server/user"), _("用户设置"), 2)
	entry({"admin", "network", "pptp_server", "status"}, cbi("pptp_server/status"), _("状态查看"), 3)
end

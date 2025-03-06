#!/bin/bash

PKG_PATH="$GITHUB_WORKSPACE/wrt/package/"
cd $PKG_PATH

#修复HomeProxy的google检测
HP_DIR=$(find ../feeds/luci/ -maxdepth 3 -type d -wholename "*/applications/luci-app-homeproxy")
if [ -d "$HP_DIR" ]; then
	HP_PATH="$HP_DIR/root/usr/share/rpcd/ucode/luci.homeproxy"
	sed -i 's|www.google.com|www.google.com/generate_204|g' $HP_PATH

	cd $PKG_PATH && echo "homeproxy check has been fixed!"
fi

#修复Coremark编译失败
CM_FILE=$(find ../feeds/packages/ -maxdepth 3 -type f -wholename "*/coremark/Makefile")
if [ -f "$CM_FILE" ]; then
	sed -i 's/mkdir/mkdir -p/g' $CM_FILE

	cd $PKG_PATH && echo "coremark has been fixed!"
fi

#修复Frpc配置文件
FRPC_DIR=$(find ../feeds/luci/ -maxdepth 3 -type d -wholename "*/applications/luci-app-frpc")
if [ -d "$FRPC_DIR" ]; then
	FRPC_PATH="$FRPC_DIR/htdocs/luci-static/resources/view/frpc.js"
	sed -i "s|'tcp', 'kcp', 'websocket'|'tcp', 'kcp', 'websocket', 'quic'|g" $FRPC_PATH

	cd $PKG_PATH && echo "luci-app-frpc has been fixed!"
fi

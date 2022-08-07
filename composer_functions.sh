#!/usr/bin/env bash
composer() {
	# composer 命令同名劫持函数，仅加载Windows环境变量来运行composer，以避免不必要的问题
	# Windows版的composer或自制的composer工具包路径必须在%PATH%环境变量下已设置；
	# 使用 composer.sh 是为了不用指定composer绝对路径的同时防止无限递归调用本函数；
	# 注意：经过测试，${ORIGINAL_PATH}应当在具体的composer可执行文件中设定（此时默认为："H:\PHP_Work\Composer\composer"）；
	## ---------------------------------------------------------------
	#PATH="${ORIGINAL_PATH}" TEMP="${LOCALAPPDATA}\\Temp" TMP="${LOCALAPPDATA}\\Temp" composer.sh $@
	if type -f composer.sh &>/dev/null;then
		TEMP="${LOCALAPPDATA}\\Temp" TMP="${LOCALAPPDATA}\\Temp" composer.sh $@ #优先检查composer.sh是否存在
	elif type -f composer &>/dev/null;then
		$(type -f composer|awk '{print $3;exit}') $@  #直接调用 composer 脚本文件
	else
		print_color 9 "PHP Composer未安装，请安装Composer并将其加入 %PATH% 环境变量！"
	fi
}
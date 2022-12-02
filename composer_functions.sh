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

composer-select-php() {
	#交互式选择composer使用的PHP版本，供多版本Windows PHP切换使用；
	#local phpBin_8.0='H:\PHP_Work\php-8.0.22-nts-Win32-vs16-x64\php.exe'
	local phpBins=$(cat <<'EOF'
H:\PHP_Work\php-7.4.12-nts-Win32-vc15-x64\php.exe
H:\PHP_Work\php-8.0.6-nts-Win32-vs16-x64\php.exe
H:\PHP_Work\php-8.0.22-nts-Win32-vs16-x64\php.exe
H:\PHP_Work\php-8.1.9-nts-Win32-vs16-x64\php.exe
H:\PHP_Work\php-8.1.11-nts-Win32-vs16-x64\php.exe
EOF
)
	print_color 33 "【composer-select-php】交互式选择Composer要使用的Windows PHP版本："
	[ ! -z "$1" ] && local phpBins=$(echo "$phpBins"|grep -i "$1") #$1传递了参数则对手册列表按关键字过滤
	echo "$phpBins"|awk '{print NR" )："$0}'
	while :;
	do
		read -p "请输入序号选择要使用的PHP（ 0 或 q 退出操作）：" choosePHP
		if [[ "${choosePHP,,}" == "0" || "${choosePHP,,}" == "q" ]];then
			print_color 40 "退出操作..."
			return
		elif [ -z "$choosePHP" ];then
			#print_color 40 "选择为空，请重新选择..."
			print_color 40 "PHP 版本未更改，退出操作..." && return
		else
			local phpEXE=$(echo "$phpBins"|awk 'NR=='${choosePHP}'{print;exit}' 2>/dev/null)
			if [ -z "$phpEXE" ];then
				print_color 40 "选择无效，请重新选择...."
			elif [[ "$phpEXE" =~ "------" ]];then
				print_color 40 "选择了分隔线，选择无效，请重新选择...."
			else
				break
			fi
		fi
	done
	echo "你选择的PHP版本：$phpEXE ..."
	if [ ! -f "$phpEXE" ];then
		print_color 9 "你选择的PHP可执行文件不存在，请检查..."
		return
	fi
	export PHPBIN="$phpEXE"
	print_color 40 "检查 \$PHPBIN 环境变量..."
	echo "$PHPBIN"
	print_color "设置 Done..."
}
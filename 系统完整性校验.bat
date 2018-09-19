@echo off
title 系统完整性校验
color F0

::BatchGotAdmin
:--------------------------------------
REM --> 检查权限
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
REM --> 如果出现了拒绝访问（错误代码：5），则目前的批处理未以管理员权限运行。
if '%errorlevel%' equ '5' (
    goto  UACPrompt
) else if '%errorlevel%' equ '0' (
goto gotAdmin
) else (
	@echo off
	echo Sorry额，脚本自动获取管理员权限失败了。
	echo 当然，您可以尝试：右击该脚本--选择：以管理员身份运行。
	echo 以下是错误信息：
	"%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
	echo+
	echo 以下是错误码：
	echo %errorlevel%
	echo+
	pause>nul
	exit
)

:UACPrompt
echo 点击“是”，以使得该脚本可以以管理员身份运行
> "%temp%\getadmin.vbs" echo Set UAC = CreateObject^("Shell.Application"^)
>> "%temp%\getadmin.vbs" echo UAC.ShellExecute "%~s0", "%*", "", "runas", 1
%temp%\getadmin.vbs
exit /B

:gotAdmin
REM -->建议在检测到权限之后删除临时文件
REM -->if exist "%temp%\getadmin.vbs"(del "%temp%\getadmin.vbs")
:--------------------------------------

:Prepare
REM -->设置一些固定的字符串和数据
set vbs_arg=262208
set tips1=系统文件
set tips2=已完成！！！请查看系统文件校验结果。

set echo1=############正在
set echo2=系统文件损坏。。。。。。###############

set act1=校验
set act2=校验与修复
set act3=强力%act1%
set act4=强力%act2%

set title_end=完成提示
goto menu

:menu
cls
echo 请选择：
echo 输入1并回车为仅执行扫描。
echo 输入2并回车为执行扫描并修复被修改的系统文件。
echo 输入3并回车为仅执行强力扫描(默认选项)。
echo 输入4并回车为执行强力扫描并强力修复损坏的系统文件(仅支持Windows 8、Windows Server 2012 及以上版本的操作系统)。
echo 输入其它任意值并回车或者关闭窗口为退出。
set /a choose=3
set /p choose=
if %choose%==1 (
goto verifyonly
) else if %choose%==2 (
goto fix
) else if %choose%==3 (
goto powerful_verify_only
) else if %choose%==4 (
goto powerful_fix
) else exit

:verifyonly
cls
echo "%echo1%%act1%%echo2%"
sfc /verifyonly & mshta vbscript:msgbox("%tips1% %act1% %tips2%",%vbs_arg%,"%tips1% %act1% %title_end%")(window.close)
echo 按任意键返回菜单
pause>nul
goto menu

:fix
cls
echo "%echo1%%act2%%echo2%"
sfc /scannow & mshta vbscript:msgbox("%tips1%%act2%%tips2%",%vbs_arg%,"%tips1%%act2%%title_end%")(window.close)
echo 按任意键退出
pause>nul
exit

:powerful_verify_only
cls
echo "%echo1%%act3%%echo2%"
dism /online /cleanup-image /ScanHealth & mshta vbscript:msgbox("%tips1%%act3%%tips2%",%vbs_arg%,"%tips1%%act3%%title_end%")(window.close)
echo 按任意键返回菜单
pause>nul
goto menu

:powerful_fix
cls
echo "%echo1%%act4%%echo2%"
dism /online /cleanup-image /RestoreHealth & mshta vbscript:msgbox("%tips1%%act4%%tips2%",%vbs_arg%,"%tips1%%act4%%title_end%")(window.close)
echo 按任意键退出
pause>nul
exit

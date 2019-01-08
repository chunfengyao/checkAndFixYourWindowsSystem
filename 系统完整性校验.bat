@echo off
title 系统完整性校验
color F0

::BatchGotAdmin
:--------------------------------------
REM --> 设置邮箱地址
set mailAddr=testmailaddr@test.com
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' equ '5' (
    goto  UACPrompt
) else if '%errorlevel%' equ '0' (
goto gotAdmin
) else (
	@echo off
	echo Sorry额，脚本自动获取管理员权限失败了。
	>nul choice /t 1 /d y
	echo 当然，您可以尝试：右击该脚本--选择：以管理员身份运行。
	>nul choice /t 1 /d y
	echo 以下是错误信息：
	"%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
	call set level=%%errorlevel%%
	echo+
	echo 以下是错误码：
	call echo %%level%%
	echo+
	echo+
)
>nul choice /t 1 /d y
echo 您可以输入2并回车，截图该页面或者复制该页面的内容，并发送至邮箱：%mailAddr%。
echo 输入1并回车，将为您打开邮件发送页面。
echo 或者，直接回车、关闭窗口、输入任何其它值并回车以退出。
set /a tipsChoose=2
set /p tipsChoose=
if %tipsChoose%==1 (
	start mailto:"%mailAddr%?subject=系统完整性校验-调试信息求助&body=错误码：%level%"
	>nul choice /t 2 /d y
	echo 已帮您打开邮件发送页面，如果未打开。您可以手动发送邮件至：%mailAddr%，谢谢。
	>nul pause
	exit
) else exit


:UACPrompt
echo 点击“是”，以使得该脚本可以以管理员身份运行
> "%temp%\getadmin.vbs" echo Set UAC = CreateObject^("Shell.Application"^)
>> "%temp%\getadmin.vbs" echo UAC.ShellExecute "%~s0", "%*", "", "runas", 1
%temp%\getadmin.vbs
exit /B

:gotAdmin
REM -->建议在检测到权限之后删除临时文件（此处为了降低磁盘IO，暂时不进行临时文件的删除）
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
echo+
echo 直接回车默认运行选项 3（默认选项）
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

@echo off
title ϵͳ������У��
color F0

::BatchGotAdmin
:-----------------------------------------------------------------
REM --> ���Ȩ�� 
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system" 
REM --> ��������˴�����Ŀǰ��������δ�Թ���ԱȨ�����С� 
if '%errorlevel%' NEQ '0' ( 
    goto UACPrompt 
) else ( goto gotAdmin )

:UACPrompt
echo ������ǡ�����ʹ�øýű������Թ���Ա�������
> "%temp%\getadmin.vbs" echo Set UAC = CreateObject^("Shell.Application"^)
>> "%temp%\getadmin.vbs" echo UAC.ShellExecute "%~s0", "%*", "", "runas", 1
%temp%\getadmin.vbs
exit /B

:gotAdmin
REM -->�����ڼ�⵽Ȩ��֮��ɾ����ʱ�ļ�����һ��ע�;�������ɾ���ģ�
REM -->if exist "%temp%\getadmin.vbs"(del "%temp%\getadmin.vbs")

:-----------------------------------------------------------------

REM -->����һЩ�̶����ַ���������
set vbs_arg=262208
set tips1=ϵͳ�ļ�
set tips2=����ɣ�������鿴ϵͳ�ļ�У������

set echo1=############����
set echo2=ϵͳ�ļ��𻵡�����������###############

set act1=У��
set act2=У�����޸�
set act3=ǿ��%act1%
set act4=ǿ��%act2%

set title_end=�����ʾ

:menu
cls
echo ��ѡ��
echo ����1���س�Ϊ��ִ��ɨ�衣
echo ����2���س�Ϊִ��ɨ�貢�޸����޸ĵ�ϵͳ�ļ���
echo ����3���س�Ϊ��ִ��ǿ��ɨ��(Ĭ��ѡ��)��
echo ����4���س�Ϊִ��ǿ��ɨ�貢ǿ���޸��𻵵�ϵͳ�ļ���
echo ������������ֵ���س����߹رմ���Ϊ�˳���
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
echo ����������ز˵�
pause>nul
goto menu

:fix
cls
echo "%echo1%%act2%%echo2%"
sfc /scannow & mshta vbscript:msgbox("%tips1%%act2%%tips2%",%vbs_arg%,"%tips1%%act2%%title_end%")(window.close)
echo ��������˳�
pause>nul

:powerful_verify_only
cls
echo "%echo1%%act3%%echo2%"
dism /online /cleanup-image /ScanHealth & mshta vbscript:msgbox("%tips1%%act3%%tips2%",%vbs_arg%,"%tips1%%act3%%title_end%")(window.close)
echo ����������ز˵�
pause>nul
goto menu

:powerful_fix
cls
echo "%echo1%%act4%%echo2%"
dism /online /cleanup-image  /RestoreHealth & mshta vbscript:msgbox("%tips1%%act4%%tips2%",%vbs_arg%,"%tips1%%act4%%title_end%")(window.close)
echo ��������˳�
pause>nul


@echo off
echo ================[��������Ҳ���·��������������Ļ�������]================
::�����ӻ���������
setlocal enabledelayedexpansion
cd..
echo ================[����������ʼ����ʼ]
echo ================[��ʼ������Ŀ����]
set projectName="null"
for %%a in (%cd%\*.csproj) do (
	set projectName=%%~na
)
if "%errorlevel%" NEQ "0" (
	echo ================[������Ŀ���Ƴ���]
	goto end
) else (
	echo ================[������Ŀ���Ƴɹ�]
)
if "%projectName%"=="null" (
	echo ================[��ȡ��Ŀ���Ƴ���]
	goto end
) else (
	echo ================[��ȡ��Ŀ���Ƴɹ�]
	echo ================[��Ŀ���ƣ�%projectName%]
)
set nugetRunFilePath=%cd%"\NuGetRun\nuget.exe"
set packagesconfigFilePath="packages.config"
set packagesPath="..\packages"
set nugetReleaseSource="http://localhost:8001/nuget/ReleaseDefault"
set nugetReleaseSymbolsSource="http://localhost:8001/nuget/SymbolsReleaseDefault"
set nugetDebugSymbolsSource="http://localhost:8001/nuget/SymbolsDebugDefault"
set nugetDebugSource="http://localhost:8001/nuget/DebugDefault"
echo ================[����������ʼ������]
echo ================[���ڻ�ԭNuGet��]
%nugetRunFilePath:"=% restore -source %nugetReleaseSource:"=% -configfile %packagesconfigFilePath:"=% -packagesdirectory %packagesPath:"=%
if "%errorlevel%" NEQ "0" (
	echo ================[��ԭNuGet������]
	rem goto end
) else (
	echo ================[��ԭNuGet���ɹ�]
)
:end
echo ================[��������Ҳ���·��������������Ļ�������]================
pause & exit
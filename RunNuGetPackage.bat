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
	rem goto end
) else (
	echo ================[������Ŀ���Ƴɹ�]
)
if "%projectName%"=="null" (
	echo ================[��ȡ��Ŀ���Ƴ���]
	rem goto end
) else (
	echo ================[��ȡ��Ŀ���Ƴɹ�]
	echo ================[��Ŀ���ƣ�%projectName%]
)
set nugetRunFilePath=%cd%"\NuGetRun\nuget.exe"
set nuGetPath="bin\NuGet\"
set releaseFileName=%projectName%".Release.nupkg"
set releaseSymbolsFileName=%projectName%".Release.Symbols.nupkg"
set debugSymbolsFileName=%projectName%".Debug.Symbols.nupkg"
set debugFileName=%projectName%".Debug.nupkg"
set nugetApiKey="Admin:Admin"
set nugetReleaseSource="http://localhost:8001/nuget/ReleaseDefault"
set nugetReleaseSymbolsSource="http://localhost:8001/nuget/SymbolsReleaseDefault"
set nugetDebugSymbolsSource="http://localhost:8001/nuget/SymbolsDebugDefault"
set nugetDebugSource="http://localhost:8001/nuget/DebugDefault"
echo ================[����������ʼ������]
echo ================[�ж��ļ����Ƿ����]
if not exist %nuGetPath:"=% (
	echo ================[NuGet�ļ��в����ڿ�ʼ����]
	mkdir %nuGetPath:"=%
) else (
	echo ================[NuGet�ļ����Ѿ����ڣ�]
)
echo ================[ɾ��NuGet�ļ��е��ļ�]
del /f /q %nuGetPath:"=%*.*
echo ================[��ʼ���NuGet]
echo ================[���Release�汾]
%nugetRunFilePath:"=% pack %projectName%.csproj -symbols -properties Configuration=Release -outputdirectory %nuGetPath:"=%
if "%errorlevel%" NEQ "0" (
	echo ================[�������]
	rem goto end
)
echo ================[������Release����]
for %%a in (%nuGetPath:"=%*) do (
	echo %%a | findstr /i /c:"symbols.nupkg" > nul && set /a isReleaseSymbols=1 || set /a isReleaseSymbols=0
	if !isReleaseSymbols! EQU 1 (
		set newReleaseFileName=%releaseSymbolsFileName%
	) else (
		set newReleaseFileName=%releaseFileName%
	)
	ren %%a !newReleaseFileName!
	echo ================[�������ɹ���!newReleaseFileName:"=!]
)
if "%errorlevel%" NEQ "0" (
	echo ================[����������]
	rem goto end
)
echo ================[���Debug-Symbols�汾]
%nugetRunFilePath:"=% pack %projectName%.csproj -symbols -outputdirectory %nuGetPath:"=%
if "%errorlevel%" NEQ "0" (
	echo ================[�������]
	rem goto end
)
echo ================[������Debug����]
for %%a in (%nuGetPath:"=%*) do (
	echo %%a | findstr /i "Release" > nul && set /a isReleaseFile=1 || set /a isReleaseFile=0
	if !isReleaseFile! EQU 0 (
		echo %%a | findstr /i /c:"symbols.nupkg" > nul && set /a isDebugSymbols=1 || set /a isDebugSymbols=0
		if !isDebugSymbols! EQU 1 (
			set newDebugFileName=%debugSymbolsFileName%
		) else (
			set newDebugFileName=%debugFileName%
		)
		ren %%a !newDebugFileName!
		echo ================[�������ɹ���!newDebugFileName:"=!]
	)
)
if "%errorlevel%" NEQ "0" (
	echo ================[����������]
	rem goto end
)
echo ================[��ʼ�ύ���ڲ�nuget]
echo ================[�ύ��Release Feed]
%nugetRunFilePath:"=% push %cd%\%nuGetPath:"=%%releaseFileName:"=% -apikey %nugetApiKey:"=%  -source %nugetReleaseSource:"=%
if "%errorlevel%" NEQ "0" (
	echo ================[�ύ��Release Feedʧ��]
	rem goto end
) else (
	echo ================[�ύ��Release Feed�ɹ�]
)
echo ================[�ύ��Release-Symbols Feed]
%nugetRunFilePath:"=% push %cd%\%nuGetPath:"=%%releaseSymbolsFileName:"=% -apikey %nugetApiKey:"=%  -source %nugetReleaseSymbolsSource:"=%
if "%errorlevel%" NEQ "0" (
	echo ================[�ύ��Release-Symbols Feedʧ��]
	rem goto end
) else (
	echo ================[�ύ��Release-Symbols Feed�ɹ�]
)
echo ================[�ύ��Debug-Symbols Feed]
%nugetRunFilePath:"=% push %cd%\%nuGetPath:"=%%debugSymbolsFileName:"=% -apikey %nugetApiKey:"=%  -source %nugetDebugSymbolsSource:"=%
if "%errorlevel%" NEQ "0" (
	echo ================[�ύ��Debug-Symbols Feedʧ��]
	rem goto end
) else (
	echo ================[�ύ��Debug-Symbols Feed�ɹ�]
)
echo ================[�ύ��Debug Feed]
%nugetRunFilePath:"=% push %cd%\%nuGetPath:"=%%debugFileName:"=% -apikey %nugetApiKey:"=%  -source %nugetDebugSource:"=%
if "%errorlevel%" NEQ "0" (
	echo ================[�ύ��Debug Feedʧ��]
	rem goto end
) else (
	echo ================[�ύ��Debug Feed�ɹ�]
)
:end
echo ================[��������Ҳ���·��������������Ļ�������]================

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
::MSBuild·��
set mSBuildPath="C:\Windows\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe"
::�������Ŀ¼
set debugOutputPath="bin\Debug"
set releaseOutputPaht="bin\Release"
::����ƽ̨(Any CPU,x86,x64)
set debugPlatform="Any CPU"
set releasePlatform="Any CPU"
::����xml�ĵ�
set debugGenerateDocumentation=true
set releaseGenerateDocumentation=true
::xml�ĵ����·��
set debugDocumentationFile="bin\Debug\"%projectName%".xml"
set releaseDocumentationFile="bin\Release\"%projectName%".xml"
::���pdb�ļ�
set debugSymbols=true
set releaseSymbols=true
echo ================[����������ʼ������]
echo ================[ɾ�������ļ�]
del /f /q %debugOutputPath:"=%\*.*
del /f /q %releaseOutputPaht:"=%\*.*
echo ================[ɾ�������ļ�����]
echo ================[���ڱ���Debug�汾]
%mSBuildPath:"=% %projectName:"=%.csproj /p:OutputPath=%debugOutputPath:"=%;Platform=%debugPlatform%;Configuration=Debug;GenerateDocumentation=%debugGenerateDocumentation%;DocumentationFile=%debugDocumentationFile:"=%;DebugSymbols=%debugSymbols%
if "%errorlevel%" NEQ "0" (
	echo ================[����Debug�汾����]
	goto end
) else (
	echo ================[����Debug�汾�ɹ�]
)
echo ================[���ڱ���Release�汾]
%mSBuildPath:"=% %projectName:"=%.csproj /p:OutputPath=%releaseOutputPaht:"=%;Platform=%releasePlatform%;Configuration=Release;GenerateDocumentation=%releaseGenerateDocumentation%;DocumentationFile=%releaseDocumentationFile:"=%;DebugSymbols=%releaseSymbols%
if "%errorlevel%" NEQ "0" (
	echo ================[����Release�汾����]
	goto end
) else (
	echo ================[����Release�汾�ɹ�]
)
:end
echo ================[��������Ҳ���·��������������Ļ�������]================
pause



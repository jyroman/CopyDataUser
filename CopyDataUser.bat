@echo off

::International charcters
chcp 858
echo.
echo Profile data copy script V1.10
echo.
echo /!\ This script must be executed on the source computer, abort if this is not the right computer /!\
echo.
pause
echo.

:: Mounting Network Drive
echo /!\ Warning if a Z: Drive is already mounted, it will be unmounted, abort the script if needed. /!\
echo.
pause

:BegMD
:: Checking Z: drive
if exist Z: net use Z: /delete

:: Asking for the name of the computer
:NameProm
set /p CompName= Enter the name of the computer : 
echo Computer Name entered : %CompName% 
:NamePromVal
set /p InfoOK= Is the data above correct ?(Y/N) : 
if %InfoOK% == Y (
	echo Computer name checked
	) else if %InfoOK% == N (
		goto NameProm
	) else ( 
		goto NamePromVal
	)  
echo.

:: Asking for credential 
:UserProm
set /p userA= Enter your Administrator account (Domain\user format) : 
echo Login Administrator entered : %userA%
:UserPromVal
set /p userOK= Is the data above correct ?(Y/N) : 
if %userOK% == Y (
	echo Administrator user checked
	) else if %userOK% == N (
		goto UserProm
	) else ( 
		goto UserPromVal
	)  
echo.

:: Mapping drive 
echo Mapping Drive Z:
net use Z: \\%CompName%\C$ /user:%userA% * /p:no
if not exist Z: goto BegMD
	
	
:: Checking local profile
:SelName1
set /p userl= Enter the local user login to copy : 
echo Local login input : %userl%
:UserPromVal2
set /p userOK= Is the data above correct ?(Y/N) : 
if %userOK% == Y (
	echo Local user checked
	) else if %userOK% == N (
		goto SelName1
	) else ( 
		goto UserPromVal2
	)  
echo.
if exist "C:\users\%userl%" (
		echo Local profil checked
		echo.
	) else (
		echo Profile not found, check the login or login into the computer
		echo.
		goto SelName1	
	)

:: Selecting distant profile
:SelName2
set /p userd= Enter the distant user login to copy : 
echo Distant login input : %userd%
:UserPromVal3
set /p userOK= Is the data above correct ?(Y/N) : 
if %userOK% == Y (
	echo Distant user checked
	) else if %userOK% == N (
		goto SelName2
	) else ( 
		goto UserPromVal3
	) 
echo.	
::Checking distant profile
if exist "Z:\users\%userd%" (
		echo Distant profile checked
		echo.
	) else (
		echo Profile not found, check the login or login into the computer
		echo.
		goto SelName1	
	)

:: Copy arguments
:CopArg
::set /p NbC= Enter the number of threads (parallel file copy 16 is recommended - 8 if not sure) : Change the numbers manually setting this to default 8
set NbC = 8
set /p LogF= Enter the name of the log file : 
::echo Number of cores : %NbC% - Name of the log file : %LogF%
echo Name of the log file : %LogF%
:CopArgVal
set /p InfoOK= Is the data above correct ?(Y/N) : 
if %InfoOK% == Y (
	echo Data checked
	) else if %InfoOK% == N (
		goto CopArg
	) else ( 
		goto CopArgVal
	)
echo The log file will be located in C:\users\%user%\ on the destination computer
echo.
pause
echo.

::Writing informations into the log file
echo Source computer : %COMPUTERNAME% >> %LogF%.log
echo Destination computer : %CompName% >> %LogF%.log
echo Local user data to copy : %userl% >> %LogF%.log
echo Distant user data to copy : %userd% >> %LogF%.log
echo Admin account used : %userA% >> %LogF%.log
echo.


:: Begining data copy 
echo Beginning Data copy
echo.
echo Profile copy : Desktop 
robocopy /V /E /XC /XN /XO /TEE /ETA /MT:%NbC% /log+:C:\users\%userl%\%LogF%.log C:\users\%userl%\Desktop Z:\users\%userd%\Desktop

echo Profile copy : Contacts 
robocopy /V /E /XC /XN /XO /TEE /ETA /MT:%NbC% /log+:C:\users\%userl%\%LogF%.log C:\users\%userl%\Contacts Z:\users\%userd%\Contacts

echo Profile copy : Documents 
robocopy /V /E /XC /XN /XO /TEE /ETA /MT:%NbC% /log+:C:\users\%userl%\%LogF%.log C:\users\%userl%\Documents Z:\users\%userd%\Documents /XD "My Music" "My Pictures" "My Videos" "Ma Musique" "Mes Images" "Mes Vid‚os"

echo Profile copy : Downloads 
robocopy /V /E /XC /XN /XO /TEE /ETA /MT:%NbC% /log+:C:\users\%userl%\%LogF%.log C:\users\%userl%\Downloads Z:\users\%userd%\Downloads

echo Profile copy : Favorites (Internet Explorer)
robocopy /V /E /XC /XN /XO /TEE /ETA /MT:%NbC% /log+:C:\users\%userl%\%LogF%.log C:\users\%userl%\Favorites Z:\users\%userd%\Favorites

echo Profile copy : Links 
robocopy /V /E /XC /XN /XO /TEE /ETA /MT:%NbC% /log+:C:\users\%userl%\%LogF%.log C:\users\%userl%\Links Z:\users\%userd%\Links

echo Profile copy : Music 
robocopy /V /E /XC /XN /XO /TEE /ETA /MT:%NbC% /log+:C:\users\%userl%\%LogF%.log C:\users\%userl%\Music Z:\users\%userd%\Music

echo Profile copy : Pictures 
robocopy /V /E /XC /XN /XO /TEE /ETA /MT:%NbC% /log+:C:\users\%userl%\%LogF%.log C:\users\%userl%\Pictures Z:\users\%userd%\Pictures

echo Profile copy : Videos
robocopy /V /E /XC /XN /XO /TEE /ETA /MT:%NbC% /log+:C:\users\%userl%\%LogF%.log C:\users\%userl%\Videos Z:\users\%userd%\Videos

echo Profile copy : Outlook Signature
if not exist Z:\Users\%userd%\AppData\Roaming\Microsoft\Signatures (mkdir Z:\Users\%userd%\AppData\Roaming\Microsoft\Signatures)

robocopy /V /E /IS /TEE /ETA /MT:%NbC% /log+:%LogF%.log C:\Users\%userl%\AppData\Roaming\Microsoft\Signatures Z:\users\%userd%\AppData\Roaming\Microsoft\Signatures

echo Profile copy : Chrome bookmarks

robocopy /V /IS /TEE /ETA /MT:%NbC% /log+:%LogF%.log "C:\Users\%userl%\AppData\Local\Google\Chrome\User Data\Default" "Z:\Users\%userd%\AppData\Local\Google\Chrome\User Data\Default" Bookmarks

echo.
echo End of the data copy, if there are any files outside of the profile data, you must copy them manually. >> %LogF%.log
echo.

::Tranfer of log to the destination computer
robocopy /IS /TEE /ETA /MT:%NbC% C:\users\%userl%\ Z:\Users\%userd%\ %LogF%.log

pause

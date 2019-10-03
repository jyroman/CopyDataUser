@echo off

::International charcters
chcp 858
echo.
echo Profile data copy script V1.9A
echo.
echo /!\ This script must be executed on the source computer, abort if this is not the right computer /!\
echo.
pause
echo.

:: Mounting Network Drive
echo /!\ Warning if a Z: Drive is already mounted, it will be unmounted, abort the screept if needed. /!\
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
set /p user= Enter the user login to copy : 
echo Login input : %user%
echo.
if exist "C:\users\%user%" (
		echo Local profil checked
		echo.
	) else (
		echo Profile not found, check the login or login into the computer
		echo.
		goto SelName1	
	)

:: Checking distant profile
if exist "Z:\users\%user%" (
		echo Distant profile checked
		echo.
	) else (
		echo Profile not found, check the login or login into the computer
		echo.
		goto SelName1	
	)

:: Copy arguments
:CopArg
set /p NbC= Enter the number of threads (paralel file copy 16 is recommended - 8 if not sure) : 
set /p LogF= Enter the name of the log file : 
echo Number of cores : %NbC% - Name of the log file : %LogF%
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
echo User data to copy : %user% >> %LogF%.log
echo Admin account used : %userA% >> %LogF%.log
echo.


:: Begining data copy 
echo Beginning Data copy
echo.
echo Profile copy : Desktop 
robocopy /ZB /V /E /XC /XN /XO /TEE /ETA /MT:%NbC% /log+:%LogF%.log C:\users\%user%\Desktop Z:\users\%user%\Desktop

echo Profile copy : Contacts 
robocopy /ZB /V /E /XC /XN /XO /TEE /ETA /MT:%NbC% /log+:%LogF%.log C:\users\%user%\Contacts Z:\users\%user%\Contacts

echo Profile copy : Documents 
robocopy /ZB /V /E /XC /XN /XO /TEE /ETA /MT:%NbC% /log+:%LogF%.log C:\users\%user%\Documents Z:\users\%user%\Documents /XD "My Music" "My Pictures" "My Videos" "Ma Musique" "Mes Images" "Mes Vid‚os"

echo Profile copy : Downloads 
robocopy /ZB /V /E /XC /XN /XO /TEE /ETA /MT:%NbC% /log+:%LogF%.log C:\users\%user%\Downloads Z:\users\%user%\Downloads

echo Profile copy : Favorites (Internet Explorer)
robocopy /ZB /V /E /XC /XN /XO /TEE /ETA /MT:%NbC% /log+:%LogF%.log C:\users\%user%\Favorites Z:\users\%user%\Favorites

echo Profile copy : Links 
robocopy /ZB /V /E /XC /XN /XO /TEE /ETA /MT:%NbC% /log+:%LogF%.log C:\users\%user%\Links Z:\users\%user%\Links

echo Profile copy : Music 
robocopy /ZB /V /E /XC /XN /XO /TEE /ETA /MT:%NbC% /log+:%LogF%.log C:\users\%user%\Music Z:\users\%user%\Music

echo Profile copy : Pictures 
robocopy /ZB /V /E /XC /XN /XO /TEE /ETA /MT:%NbC% /log+:%LogF%.log C:\users\%user%\Pictures Z:\users\%user%\Pictures

echo Profile copy : Videos
robocopy /ZB /V /E /XC /XN /XO /TEE /ETA /MT:%NbC% /log+:%LogF%.log C:\users\%user%\Videos Z:\users\%user%\Videos

echo Profile copy : Outlook Signature
if not exist Z:\Users\%user%\AppData\Roaming\Microsoft\Signatures (mkdir Z:\Users\%user%\AppData\Roaming\Microsoft\Signatures)

robocopy /ZB /V /E /IS /TEE /ETA /MT:%NbC% /log+:%LogF%.log C:\Users\%user%\AppData\Roaming\Microsoft\Signatures Z:\users\%user%\AppData\Roaming\Microsoft\Signatures

echo Profile copy : Chrome bookmarks

robocopy /ZB /V /IS /TEE /ETA /MT:%NbC% /log+:%LogF%.log "C:\Users\%user%\AppData\Local\Google\Chrome\User Data\Default" "Z:\Users\%user%\AppData\Local\Google\Chrome\User Data\Default" Bookmarks

echo.
echo End of the data copy, if there are any files outside of the profile data, you must copy them manually. >> %LogF%.log
echo.

::Tranfer of log to the destination computer
robocopy /IS /TEE /ETA /MT:%NbC% %~dp0. "Z:\Users\%user%\" %LogF%.log

pause

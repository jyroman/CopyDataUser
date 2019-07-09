@echo off

echo.
echo Profile data copy script V1.5
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
echo Name entered : %CompName% 
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
echo User entered : %userA%
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
set /p user= Enter the user login : 
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
set /p NbC= Enter the number of cores : 
set /p LogF= Entrez the name of the log file : 
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
echo The log file will be at the same location as this script
echo.
pause
echo.

:: Begining data copy 
echo Beginning Data copy
echo.
echo Profile copy : Desktop 
robocopy /E /IS /TEE /ETA /MT:%NbC% /log+:%LogF%.log C:\users\%user%\Desktop Z:\users\%user%\Desktop

echo Profile copy : Contacts 
robocopy /E /IS /TEE /ETA /MT:%NbC% /log+:%LogF%.log C:\users\%user%\Contacts Z:\users\%user%\Contacts

echo Profile copy : Documents 
robocopy /E /IS /TEE /ETA /MT:%NbC% /log+:%LogF%.log C:\users\%user%\Documents Z:\users\%user%\Documents /XD "My Music" "My Pictures" "My Videos"

echo Profile copy : Downloads 
robocopy /E /IS /TEE /ETA /MT:%NbC% /log+:%LogF%.log C:\users\%user%\Downloads Z:\users\%user%\Downloads

echo Profile copy : Favorites (Internet Explorer)
robocopy /E /IS /TEE /ETA /MT:%NbC% /log+:%LogF%.log C:\users\%user%\Favorites Z:\users\%user%\Favorites

echo Profile copy : Links 
robocopy /E /IS /TEE /ETA /MT:%NbC% /log+:%LogF%.log C:\users\%user%\Links Z:\users\%user%\Links

echo Profile copy : Music 
robocopy /E /IS /TEE /ETA /MT:%NbC% /log+:%LogF%.log C:\users\%user%\Music Z:\users\%user%\Music

echo Profile copy : Pictures 
robocopy /E /IS /TEE /ETA /MT:%NbC% /log+:%LogF%.log C:\users\%user%\Pictures Z:\users\%user%\Pictures

echo Profile copy : Videos
robocopy /E /IS /TEE /ETA /MT:%NbC% /log+:%LogF%.log C:\users\%user%\Videos Z:\users\%user%\Videos

echo Profile copy : Outlook Signature
if not exist Z:\Users\%user%\AppData\Roaming\Microsoft\Signatures (mkdir Z:\Users\%user%\AppData\Roaming\Microsoft\Signatures)

robocopy /E /IS /TEE /ETA /MT:%NbC% /log+:%LogF%.log C:\Users\%user%\AppData\Roaming\Microsoft\Signatures Z:\users\%user%\AppData\Roaming\Microsoft\Signatures

echo.
echo End of the data copy, if there are any files outside of the profile data, you must copy them manually.
echo.

pause

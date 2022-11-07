REM This batch script collects informations about paths and builds a tree with tabulators

REM 1. build tree with paths of user
tree C:\Temp /A >>C:\TreeLink\TreeLink.txt
tree C:\Tree /A >>C:\TreeLink\TreeLink.txt
tree C:\TreeLink /A >>C:\TreeLink\TreeLink.txt

REM 2. use tab in file delimiter.ini needed in output file
for /f "delims=" %%x IN (delimiter.ini) DO set TAB=%%x

REM 3. write result tree as a tabulator tree
echo C:\>C:\TreeLink\TreeLink_tab.txt
@echo off 
SETLOCAL ENABLEDELAYEDEXPANSION
FOR /f "usebackqdelims=" %%a IN ("C:\TreeLink\TreeLink.txt") DO (
SET "line=%%a"
SET "line=!line:+= !"
SET "line=!line:---=   !"
SET "line=!line:|= !"
SET "line=!line:\   =    !"
SET "line=!line:    =%TAB%!"
SET "lin2=!line:~0,2!"
REM test with: echo !lin2!
SET "lin3=%TAB%!line!"
IF NOT !lin2!==Au (IF NOT !lin2!==Es (IF NOT !lin2!==Vo ECHO !lin3!))
) >> C:\TreeLink\TreeLink_tab.txt


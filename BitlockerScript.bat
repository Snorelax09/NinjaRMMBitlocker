@echo off

:: Turns bitlocker on, if already on does nothing.
manage-bde -on c:

:: Unlocks bitlocker, bitlocker will lock if tampering is detected on its own. Required so NinjaRMM can grab the bitlocker password.
manage-bde -unlock C: -pw

:: Gets output of -protectors to check if there is a numerical password will set %var10% as "Numerical Password:" and %var11% as the actual Numerical Password
SETLOCAL ENABLEDELAYEDEXPANSION
SET count=1
FOR /F "tokens=* USEBACKQ" %%F IN (`manage-bde -protectors -get C:`) DO (
  SET var!count!=%%F
  SET /a count=!count!+1
)

:: Checks to see if Numerical Password is defined and starts the next part of the script
if defined var11 (echo "The numerical password exists NinjaRMM can grab it.") else (manage-bde -protectors -add C: -RecoveryPassword)

ENDLOCAL
@echo off
setlocal enabledelayedexpansion

title !global-title! - Settings
mode !global-window-width!, !global-window-height!
color !global-color!

set "result="
set "index="

:ini (
  set menu="Emulator location" "Roms location" "Change name" "Change password" "Share locations" "Backup" "Delete account" "" "Back"
  set "menu-show="

  for %%x in (!menu!) do (
    call lib\center-text %%x, result
    set menu-show=!menu-show! "!result!"
  )

  goto :home
)

:home (
  cls
  echo.
  call lib\draw-center-text "{0c}-{06}-{02}-{0f} Settings {0c}-{06}-{02}-", 4
  echo.
  call lib\draw "settings"
  echo.

  cmdmenusel f880 !menu-show!

  call lib\get-array-vector menu, !errorlevel!, result
  set result=!result:~1,-1!

  if "!result!" == "Emulator location" start /wait /shared screens\settings\emulator-location
  if "!result!" == "Roms location" start /wait /shared screens\settings\roms-location
  if "!result!" == "Change name" (
    start /wait /shared screens\settings\change-name

    if not exist "data\users\!user-name!" exit
  )
  if "!result!" == "Change password" start /wait /shared screens\settings\change-password
  if "!result!" == "Share locations" start /wait /shared screens\settings\share-locations
  if "!result!" == "Backup" start /shared messages\not-implemented
  if "!result!" == "Delete account" (
    start /wait /shared screens\settings\confirm-password

    set /p answer=<"temp\confirm-password.txt"

    if "!answer!" == "y" (
      rd /s /q "data\users\!user-name!"

      start index
      exit
    )
  )
  if "!result!" == "Delete account" exit

  goto :home
)

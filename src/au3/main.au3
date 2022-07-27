#include "lib/require.au3"
#include "lib/ultralight.au3"
#include "lib/JSON/OO_JSON.au3"
#include <String.au3>

#include "tasks/download.au3"

;~ #AutoIt3Wrapper_Run_AU3Check=N

EnvSet("PATH", @ScriptDir & '\bin' & ';' & EnvGet('PATH'))

main()

Func main()
	downloadLibrary()
	Ultralight_ConfigWindowSize(600, 600)
	Ultralight_ConfigWindowFlag($kWindowFlags_Borderless)
	Ultralight_InitApp()
	Ultralight_SetMinWindowSize(200, 200)

	If (Not @Compiled) Then
		Ultralight_LoadURL('http://localhost:3000')
	Else
		Ultralight_SPA()
	EndIf

	Ultralight_RunApp()
	Exit
EndFunc   ;==>main

Func downloadLibrary()
	If (@Compiled) Then
		REQUIRE_Zip('https://raw.githubusercontent.com/xtilam/ultralight/master/au3-lib/bin.zip', '', 'Ultralight Depenpencies')
		REQUIRE_StartDownload() 
	EndIf
EndFunc   ;==>downloadLibrary
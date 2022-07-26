#include-once
#include <MsgBoxConstants.au3>
#include <Array.au3>
#include <File.au3>
#include "CoProc.au3"

#include "JSON/OO_JSON.au3"
#NoTrayIcon

Global $ultralightDLL = -1
Global $Ultralight_WHWND = -1
Global Enum $Ultralight_kCursor_Pointer, $Ultralight_kCursor_Cross, $Ultralight_kCursor_Hand, $Ultralight_kCursor_IBeam, $Ultralight_kCursor_Wait, $Ultralight_kCursor_Help, $Ultralight_kCursor_EastResize, $Ultralight_kCursor_NorthResize, $Ultralight_kCursor_NorthEastResize, $Ultralight_kCursor_NorthWestResize, $Ultralight_kCursor_SouthResize, $Ultralight_kCursor_SouthEastResize, $Ultralight_kCursor_SouthWestResize, $Ultralight_kCursor_WestResize, $Ultralight_kCursor_NorthSouthResize, $Ultralight_kCursor_EastWestResize, $Ultralight_kCursor_NorthEastSouthWestResize, $Ultralight_kCursor_NorthWestSouthEastResize, $Ultralight_kCursor_ColumnResize, $Ultralight_kCursor_RowResize, $Ultralight_kCursor_MiddlePanning, $Ultralight_kCursor_EastPanning, $Ultralight_kCursor_NorthPanning, $Ultralight_kCursor_NorthEastPanning, $Ultralight_kCursor_NorthWestPanning, $Ultralight_kCursor_SouthPanning, $Ultralight_kCursor_SouthEastPanning, $Ultralight_kCursor_SouthWestPanning, $Ultralight_kCursor_WestPanning, $Ultralight_kCursor_Move, $Ultralight_kCursor_VerticalText, $Ultralight_kCursor_Cell, $Ultralight_kCursor_ContextMenu, $Ultralight_kCursor_Alias, $Ultralight_kCursor_Progress, $Ultralight_kCursor_NoDrop, $Ultralight_kCursor_Copy, $Ultralight_kCursor_None, $Ultralight_kCursor_NotAllowed, $Ultralight_kCursor_ZoomIn, $Ultralight_kCursor_ZoomOut, $Ultralight_kCursor_Grab, $Ultralight_kCursor_Grabbing, $Ultralight_kCursor_Custom

Global $ultralightOldLocationX = 0
Global $ultralightOldLocationY = 0
Global $ultralightOldHeight = 0
Global $ultralightOldWidth = 0
Global $ultralightIsStartWatchMove = 0
Global Const $JS_TYPE_NUMBER = 1
Global Const $JS_TYPE_STRING = 2
Global Const $JS_TYPE_OBJECT = 3
Global Const $JS_TYPE_UNDEFINED = 4
Global Const $JS_TYPE_NULL = 5
Global Const $JS_TYPE_BOOLEAN = 6
Global Const $kWindowFlags_Borderless = 1
Global Const $kWindowFlags_Maximizable = 8
Global Const $kWindowFlags_Resizable = 4
Global Const $kWindowFlags_Titled = 2
Global Const $HTML_SPA_DEFAULT = '<!DOCTYPE html><html> <head> <meta charset="utf-8"/> </head> <body> <div id="root"></div></body></html>'



Func Ultralight_RunApp()
	DllCall($ultralightDLL, 'NONE', 'runApp')
EndFunc   ;==>Ultralight_RunApp

Func Ultralight_InitApp()
	Ultralight_LoadDLL()
	DllCall($ultralightDLL, 'NONE', 'initApp')
	$Ultralight_WHWND = Ultralight_GetWindowHandle()
	DllCall($ultralightDLL, 'NONE', 'setCallbackHandleCallFunction', 'ptr', DllCallbackGetPtr(DllCallbackRegister(Ultralight_MainHandleData, 'none', 'wstr;ptr')))
EndFunc   ;==>Ultralight_InitApp

Func Ultralight_MainHandleData($strExecute, $pointerResult)
	Local $timeStart = TimerInit()
	Local $result = Execute($strExecute)

	If (@error <> 0) Then Return

	Switch (VarGetType($result))
		Case 'String'
			DllCall($ultralightDLL, 'none', 'makeString', 'ptr', $pointerResult, 'wstr', $result)
		Case 'Object'
			DllCall($ultralightDLL, 'none', 'makeObject', 'ptr', $pointerResult, 'wstr', $result.json())
		Case 'Array'
			DllCall($ultralightDLL, 'none', 'makeObject', 'ptr', $pointerResult, 'wstr', Ultralight_GetReturnFuncArray($result).json())
		Case Else
			If (IsNumber($result)) Then
				DllCall($ultralightDLL, 'none', 'makeNumber', 'ptr', $pointerResult, 'double', $result)
			Else
				DllCall($ultralightDLL, 'none', 'makeNull', 'ptr', $pointerResult)
			EndIf
	EndSwitch
	Local $end = TimerDiff($timeStart)
EndFunc   ;==>Ultralight_MainHandleData

Func Ultralight_GetReturnFuncArray(ByRef $l)
	Static $arrFilterString = 'window.arrFilter ? window.arrFilter : (window.arrFilter = {items:[],reset:function(){this.items=[]},push:function(){var d=arguments,e=arguments.length;for(var b=[this.items],c=0,f=this.open,g=this.close,a=0;a<e;a++)d[a]===f?(b[++c]=[]):d[a]===g?b[--c].push(b[c+1]):b[c].push(d[a])},open:{},close:{}})'
	Local $arrFilter = _JSVal($arrFilterString)
	Local $o = $arrFilter.open
	Local $p = $arrFilter.close
	$arrFilter.reset()
	Local $commands = '$arrFilter.push(' & Ultralight_GetReturnFuncArrayRecursive($l, '$l') & ')'
	Execute($commands)
	Return $arrFilter.items
EndFunc   ;==>Ultralight_GetReturnFuncArray

Func Ultralight_GetReturnFuncArrayRecursive(ByRef $list, $parent)
	Local $d0 = UBound($list, 0)
	If ($d0 = 1) Then
		Local $d1 = UBound($list) - 1
		If ($d1 = -1) Then Return ''

		Local $result = ''
		Local $start = ''
		For $i = 0 To $d1
			If (IsArray($list[$i])) Then
				$result &= $start & '$o,' & Ultralight_GetReturnFuncArrayRecursive($list[$i], '(' & $parent & '[' & $i & '])') & ',$p'
			Else
				$result &= $start & $parent & '[' & $i & ']'
			EndIf
			$start = ','
		Next
		Return $result
	ElseIf ($d0 = 2) Then
		Local $d1 = UBound($list, 1) - 1
		Local $d2 = UBound($list, 2) - 1
		If ($d1 = -1) Then Return ''
		If ($d2 = -1) Then Return ''

		Local $result = ''
		Local $start = ''

		For $i = 0 To $d1
			$current = $parent & '[' & $i & ']'
			$result &= $start & '$o,'
			$start = ''

			For $j = 0 To $d2
				If (IsArray($list[$i][$j])) Then
					$result &= $start & '$o,' & Ultralight_GetReturnFuncArrayRecursive($list[$i][$j], '(' & $current & '[' & $j & '])') & ',$p'
				Else
					$result &= $start & $current & '[' & $j & ']'
				EndIf
				$start = ','
			Next

			$start = ','
			$result &= ',$p'
		Next

		Return $result
	Else
		Return
	EndIf
EndFunc   ;==>Ultralight_GetReturnFuncArrayRecursive

Func Ultralight_createThread($func)
	Local $handle = DllCallbackRegister($func, 'none', '')
	DllCall($ultralightDLL, 'none', 'createThread', 'ptr', DllCallbackGetPtr($handle), 'int', $handle)
EndFunc   ;==>Ultralight_createThread

Func Ultralight_LoadDLL($ultralightDLLPath = "AU3Utralight.dll")
	If ($ultralightDLL = -1) Then

		$ultralightDLL = DllOpen($ultralightDLLPath)
		If ($ultralightDLL = -1) Then
			MsgBox($MB_ICONERROR, "Lỗi", "Không load đc dll (AU3Utralight.dll)")
			Exit
		EndIf
		Local $signalAddress = DllCall($ultralightDLL, 'LONG_PTR', 'getSendSignalAddress')[0]
		_SuperGlobalSet('parentPID', @AutoItPID)
		_SuperGlobalSet('sendSignalAddress', $signalAddress)
		;~ ll(_SuperGlobalGet('sendSignalAddress'))
		;~ ll(_SuperGlobalGet('parentPID'))
	EndIf
EndFunc   ;==>Ultralight_LoadDLL

Func Ultralight_LoadURL($url)
	DllCall($ultralightDLL, "NONE", "loadURL", "str", $url)
EndFunc   ;==>Ultralight_LoadURL

Func Ultralight_GetWindowHandle()
	If ($Ultralight_WHWND <> -1) Then $Ultralight_WHWND
	Return DllCall($ultralightDLL, "hwnd", "getWindowHandle")[0]
EndFunc   ;==>Ultralight_GetWindowHandle

Func Ultralight_LoadHTML($html)
	DllCall($ultralightDLL, "NONE", "loadHTML", "str", $html)
EndFunc   ;==>Ultralight_LoadHTML

Func Ultralight_ConfigWindowSize($width, $height)
	Ultralight_LoadDLL()
	DllCall($ultralightDLL, "NONE", "configWindowSize", "int", $width, 'int', $height)
EndFunc   ;==>Ultralight_ConfigWindowSize

Func Ultralight_ConfigWindowFlag($flag)
	Ultralight_LoadDLL()
	DllCall($ultralightDLL, "NONE", "configWindowFlag", "int", $flag)
EndFunc   ;==>Ultralight_ConfigWindowFlag

Func Ultralight_ResizeWindow($width, $height)
	Local $aPos = WinGetPos($Ultralight_WHWND)
	WinMove($Ultralight_WHWND, '', $aPos[0], $aPos[1], $width, $height)
EndFunc   ;==>Ultralight_ResizeWindow

Func Ultralight_MoveWindow($x, $y)
	Local $aPos = WinGetPos($Ultralight_WHWND)
	WinMove($Ultralight_WHWND, '', $x, $y, $aPos[2], $aPos[3])
EndFunc   ;==>Ultralight_MoveWindow

Func Ultralight_SetWindowTitle($title = '')
	DllCall($ultralightDLL, 'none', 'setTitle', 'str', $title)
EndFunc   ;==>Ultralight_SetWindowTitle

Func Ultralight_SendSignal($signal)
	If Not IsObj($signal) Then
		ll('wrong signal')
		SetError(1)
		Return
	EndIf

	DllCall($ultralightDLL, 'none', 'sendSignal', 'wstr', $signal.json())
EndFunc   ;==>Ultralight_SendSignal

Func Ultralight_Close()
	DllClose($ultralightDLL)
EndFunc   ;==>Ultralight_Close

Func Ultralight_IsDevMode()
	Ultralight_LoadDLL()
	Return DllCall($ultralightDLL, "BOOLEAN", "isDevMode")[0]
EndFunc   ;==>Ultralight_IsDevMode

Func Ultralight_OnReadyExecute($script)
	Ultralight_LoadDLL()
	DllCall($ultralightDLL, "none", "readyScript", 'str', $script)
EndFunc   ;==>Ultralight_OnReadyExecute

Func Ultralight_SetCursor($cursorIndex, $path)
	Ultralight_LoadDLL()
	DllCall($ultralightDLL, "none", "setCursor", 'int', $cursorIndex, 'str', $path)
EndFunc   ;==>Ultralight_SetCursor


Func Ultralight_SetMinWindowSize($width, $height)
	Ultralight_LoadDLL()
	DllCall($ultralightDLL, "none", "setLimitSize", 'int', $width, 'int', $height)
EndFunc   ;==>Ultralight_SetMinWindowSize

Func Ultralight_SPA($scriptEncryptPath = @ScriptDir & '\data.dat', $html = $HTML_SPA_DEFAULT)
	$workingDir = @ScriptDir
	Local $indexPath = _PathFull($workingDir & '\assets\ic.html')
	$scriptEncryptPath = _PathFull($scriptEncryptPath)
	Local $indexFileHandle = FileOpen($indexPath, 8 + 2)
	FileWrite($indexPath, $html)
	FileClose($indexFileHandle)
	Ultralight_LoadURL('file:///ic.html')
	Ultralight_OnReadyExecute('executeResource("' & StringReplace($scriptEncryptPath, '\', '\\') & '");au3("FileDelete", "' & StringReplace($indexPath, '\', '\\') & '");')
EndFunc   ;==>Ultralight_SPA

Func ll($content, $subScription = '')
	ConsoleWrite($subScription & " => " & $content & @CRLF)
EndFunc   ;==>ll

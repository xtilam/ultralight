#include "CoProc.au3"

Global $parentPID, $sendSignalAddress, $sendSignalDLL

Func UltralightProc_SendSignal($message)
	UltralightProc_LoadDLL()
	
	If Not IsObj($message) Then
		ConsoleWrite('wrong signal' & @CRLF)
		SetError(1)
		return False
	EndIf

	Local $isSuccess = DllCall($sendSignalDLL, 'bool', 'sendSignal', 'DWORD', $parentPID, 'ptr', $sendSignalAddress, 'wstr', $message.json())

	If @error = 0 Then
		Return $isSuccess[0]
	Else
		Return False
	EndIf
EndFunc   ;==>UltralightProc_SendSignal

Func UltralightProc_Start($func, $objStart = '')
	Local $processPID
	If (IsObj($objStart)) Then
		$processPID = _CoProc($func, $objStart.json())
	Else
		$processPID = _CoProc($func, $objStart)
	EndIf

	if @error Then Return -1
	return $processPID
EndFunc   ;==>UltralightProc_Start

Func UltralightProc_AutoKill()
	UltralightProc_LoadDLL()
	DllCall($sendSignalDLL, 'none', 'startAutoKill', 'DWORD', $parentPID)
EndFunc   ;==>UltralightProc_Start

Func UltralightProc_LoadDLL()
	If Not IsDeclared('sendSignalDLL') Then
		Global $parentPID = _SuperGlobalGet('parentPID')
		Global $sendSignalAddress = _SuperGlobalGet('sendSignalAddress')
		Global $sendSignalDLL = DllOpen('SendSignalDLL.dll')
		Return UltralightProc_LoadDLL()
	ElseIf $sendSignalDLL == -1 Then
		Return False
	EndIf

	Return True
EndFunc   ;==>UltralightProc_LoadDLL

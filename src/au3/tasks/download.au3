#include-once
#include "../lib/JSON/OO_JSON.au3"
#include "../lib/ultralight_proc.au3"
#include <File.au3>
#include <InetConstants.au3>
#include <Array.au3>
#include <WinAPIProc.au3>

Func proc_download($data)
	UltralightProc_AutoKill()
	$data = _JSVal($data)

	Local $url = $data.at(0)
	Local $pathSave = $data.at(1)

	Local $URLSize = InetGetSize($url)
	Local $hDownload = InetGet($url, $pathSave, $INET_FORCERELOAD, $INET_DOWNLOADBACKGROUND)
		Local $isSuccress = UltralightProc_SendSignal($_JSA('downloadProgress', $URLSize, 0, $pathSave))

	Do
		Local $currentSize = InetGetInfo($hDownload, $INET_DOWNLOADREAD)
		Local $isSuccress = UltralightProc_SendSignal($_JSA('downloadProgress', $URLSize, $currentSize, $pathSave))
		Sleep(250)
	Until InetGetInfo($hDownload, $INET_DOWNLOADCOMPLETE)

	InetClose($hDownload)

	UltralightProc_SendSignal($_JSA('downloadComplete'))
EndFunc   ;==>startThreadDownload

Func startDownload($url, $pathSave)
	$pathSave = _PathFull($pathSave)
	UltralightProc_Start('proc_download', $_JSA($url, $pathSave))
EndFunc   ;==>startDownload

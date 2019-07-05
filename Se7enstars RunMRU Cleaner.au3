#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=1.ico
#AutoIt3Wrapper_Res_Description=Run list cleaner by ODILjoni SRB
#AutoIt3Wrapper_Res_Fileversion=1.0.0.4
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_LegalCopyright=Se7enstars
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
_Initializing()

Opt("TrayIconHide", 1)

Global $ver = "1.0.0"
Global $appname = "Se7enstars RunMRU Cleaner"

$gui = GUICreate($appname, 600, 400)
GUISetIcon(@SystemDir & "\shell32.dll", 25, $gui)
GUISetBkColor(0x313331, $gui)
GUISetFont(10, 600, Default, "Microsoft Sans Serif", $gui, 5) ; $CLEARTYPE_QUALITY
GUICtrlCreatePic(@TempDir & "\Logo.7s", 0, 0, 600, 100)
$list = GUICtrlCreateList(' #' & @TAB & 'Commands' & @TAB & @TAB & 'Click to "Scan" >>>', 13, 111, 445, 269, 0x00200000 + 0x0080)
$status = GUICtrlCreateLabel("Ready!", 13, 380, 574, 17)
GUICtrlSetColor($status, 0xffffff)
GUICtrlSetFont($status, 10, 600, 2, "Microsoft Sans Serif", 5) ; $CLEARTYPE_QUALITY
$scan = GUICtrlCreateButton("Scan", 463, 110, 130, 30)
$clean = GUICtrlCreateButton("Clean", 463, 145, 130, 30)
$help = GUICtrlCreateButton("Help", 463, 180, 130, 30)
$about = GUICtrlCreateButton("About", 463, 215, 130, 30)
$prog1 = GUICtrlCreateProgress(463, 250, 130, 20)
$prog2 = GUICtrlCreateProgress(463, 275, 130, 20)
$prog3 = GUICtrlCreateProgress(463, 300, 130, 20)
$tip = GUICtrlCreateLabel("Se7enstars RunMRU Cleaner" & " Version: " & $ver & @CRLF & "by ODILjoni SRB™", 463, 325, 130, 47)
GUICtrlSetColor($tip, 0xffffff)
GUICtrlSetFont($tip, 7.5, 600, 2, "Microsoft Sans Serif", 5) ; $CLEARTYPE_QUALITY

GUISetState(@SW_SHOW, $gui)

While 1
	$msg = GUIGetMsg()
	Switch $msg
		Case -3
			If Not @error Then
				FileDelete(@TempDir & "\Logo.7s")
			EndIf
			Exit
		Case $scan
			_Status("Scaning...")
			_Scan()
			_Animation()
			_Status("Scaned OK!")
		Case $clean
			_Status("Cleaning...")
			_Animation(2)
			_Clean()
			_Animation(3)
			_Status("Run List successful cleaned!")
		Case $help
			ShellExecute("http://seven.moy.su/")
		Case $about
			_About()
		Case $list
			;_Status(GUICtrlRead($list))
	EndSwitch
WEnd

Func _Scan()
	Local $reg = "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\RunMRU"
	Local $numR[27] = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "v", "z"]
	$getReg = RegRead($reg, "MRUList")
	If Not @error Then
		GUICtrlSetData($list, "")
		GUICtrlSetData($list, ' #' & @TAB & 'Commands' & @TAB & @TAB & 'Click to "Scan" >>>')
		For $i = 0 To StringLen($getReg) - 1
			If Not RegRead($reg, $numR[$i]) = "" Then
				GUICtrlSetData($list, "#" & $i + 1 & @TAB & StringTrimRight(RegRead($reg, $numR[$i]), 2))
			EndIf
		Next
	Else
		_Status('#Error: "MRUList" not found from RegEdit')
	EndIf
EndFunc   ;==>_Scan

Func _Clean()
	Local $reg = "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\RunMRU"
	Local $numR[27] = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "v", "z"]
	$getReg = RegRead($reg, "MRUList")
	If Not @error Then
		For $i = 0 To StringLen($getReg) - 1
			RegDelete($reg, $numR[$i])
		Next
	Else
		_Status('#Error: "MRUList" not found from RegEdit')
	EndIf
EndFunc   ;==>_Clean

Func _Animation($type = 0)
	If $type = 0 Then
		For $i = 0 To 99 Step 4.5
			GUICtrlSetData($prog1, $i)
			Sleep(1)
		Next
		For $i = 0 To 99 Step 3
			GUICtrlSetData($prog2, $i)
			Sleep(1)
		Next
		For $i = 0 To 99 Step 1.5
			GUICtrlSetData($prog3, $i)
			Sleep(1)
		Next
	ElseIf $type = 1 Then
		For $i = 0 To 99 Step 4.5
			GUICtrlSetData($prog1, $i)
			Sleep(1)
		Next
	ElseIf $type = 2 Then
		For $i = 0 To 99 Step 3
			GUICtrlSetData($prog2, $i)
			Sleep(1)
		Next
	ElseIf $type = 3 Then
		For $i = 0 To 99 Step 3
			GUICtrlSetData($prog3, $i)
			Sleep(1)
		Next
	Else
		$type = 0
	EndIf
EndFunc   ;==>_Animation

Func _About()
	MsgBox(64, "About " & $appname, $appname & " created by ODILjoni SRB™" & @CRLF & _
	"on 18 september 2016" & @CRLF & "Thanks for use!")
EndFunc   ;==>_About

Func _Status($data)
	GUICtrlSetData($status, $data)
EndFunc   ;==>_Status

Func _Initializing()
	If Not FileExists(@TempDir & "\Logo.7s") Then
		FileInstall("Logo.7s", @TempDir & "\Logo.7s", 1)
	EndIf
EndFunc   ;==>_Initializing
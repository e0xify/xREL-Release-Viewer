#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.12.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=favicon.ico
#AutoIt3Wrapper_Outfile=xREL - Release Viewer.exe
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Res_Fileversion=1.3.0.0
#AutoIt3Wrapper_Res_LegalCopyright=reVerse
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include <Inet.au3>
#include <Array.au3>
#include <String.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GuiListView.au3>
#include <File.au3>

Fileinstall("C:\Users\lol_als_ob_es_dich_intressieren_darf\config.txt",@scriptdir & "\config.txt")

Opt("TrayOnEventMode",1)

Opt("TrayAutoPause",0)

Opt("TrayMenuMode",2)

Local $show = TrayCreateItem("xREL - Release Viewer")
Local $prefsitem = TrayCreateItem("xREL Thread")
Local $aboutitem = TrayCreateItem("Über")

global $version = "1.3.1"

TrayItemSetOnEvent($prefsitem,"shell")
TrayItemSetOnEvent($aboutitem,"about")

TrayItemSetOnEvent($show,"trayklick")

func shell()
	ShellExecute("http://www.xrel.to/forum/thread/4961.html")
ENdfunc

func about()
info()
EndFunc

func been()
	Exit
Endfunc

func trayklick()
	GUISetState(@SW_SHOW)
	WinSetState("xREL - Release Viewer","",@SW_RESTORE)
Endfunc



global $config
FileDelete(@TempDir & "\xrl.txt")
$config2 = fileread(@scriptdir & "\config.txt")
$config = _StringBetween($config2,"<",">")
;_ArrayDisplay($config)


AdlibRegister("new_rls",$config[2])

fetch()

new_rls()
write()
Gui()


Func Gui()
	if $config[4] = 1 then
global $gui = Guicreate("xREL - Release Viewer",760,310,"","",$WS_SIZEBOX)
else
	global $gui = Guicreate("xREL - Release Viewer",760,310,"","")
Endif
$menu = GUICtrlCreateMenu("xREL - Release Viewer")
;$menu2 = GUICtrlCreateMenu("                                                                                                                                                        Version: " & $version)
;GUICtrlSetState(-1,$GUI_DISABLE)
$item1 = GUICtrlCreateMenuItem("Konfiguration",$menu)
$item5 = GUICtrlCreateMenuItem("aktualisieren",$menu)
$item4 = GUICtrlCreateMenuItem("Beenden",$menu)

$help= GuictrlcreateMenu("Hilfe")
$item2 = GUICtrlCreateMenuItem("xREL Thread",$help)
$item3 = GUICtrlCreateMenuItem("Über",$help)




global $lv = GUICtrlCreateListView("Typ|Release|Info|Zeit",1,0,760,298,"","LVS_EX_FULLROWSELECT")
_GUICtrlListView_SetExtendedListViewStyle($lv, BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT))
_GUICtrlListView_SetColumnWidth($lv,0,60)
_GUICtrlListView_SetColumnWidth($lv,1,370)
_GUICtrlListView_SetColumnWidth($lv,2,157)
_GUICtrlListView_SetColumnWidth($lv,3,155)
GUIRegisterMsg(0x004E, "WM_NOTIFY")
;$version = GUICtrlCreateButton("Version",502,
GUISetState(@SW_SHOW) ; will display an empty dialog box

for $i = 0 to UBound($title) -1
	GUICtrlCreateListViewItem("[" & $rls[$i]& "] " & "|"& $title[$i] & "|" & $rlss[$i] & "|" & $time[$i],$lv)



Next
    While 1
        $msg = GUIGetMsg()
		switch $msg
   Case $GUI_EVENT_MINIMIZE
                GUISetState(@SW_HIDE)
                TraySetState(1)
			case $item1
				ShellExecute(@ScriptDir & "\config.txt")
			case $item2
				shell()
			case $item3
				info()
			case $item4
				exit
			case $item5
				Traytip("xREL v3","checking for new releases...",2,1)
				new_rls()
EndSwitch
        If $msg = $GUI_EVENT_CLOSE Then Exit
    WEnd
    GUIDelete()
Endfunc

func fetch()
$config2 = fileread(@scriptdir & "\config.txt")
$config = _StringBetween($config2,"<",">")
$rss_source = _INetGetSource($config[1])
;FileWrite("bla.txt",$rss_source)

global $title = _StringBetween($rss_source,"<entry><title>","</title><link href=")
;_ArrayDisplay($title)
global $rls = _StringBetween($rss_source,'</updated><summary>[','] ')
;_ArrayDisplay($rls)
global $url = _StringBetween($rss_source,'</title><link href="','" /><id>')
;_ArrayDisplay($url)
global $rlss = _StringBetween($rss_source,'(',')')
;_ArrayDisplay($rlss)
global $time = _StringBetween($rss_source,"</id><updated>","+02:00</updated>")


for $o = 0 to Ubound($time) -1
	$time[$o] = StringReplace($time[$o],"-",".")
	$time[$o] = StringReplace($time[$o],"T"," um ")
	$time[$o] = $time[$o] & " Uhr"
Next






Endfunc

func write()
	Filewrite(@tempdir & "\xrl.txt",$title[0])
EndFunc

func new_rls()
	fetch()
	$lol = Fileread(@TempDir & "\xrl.txt")
	if $lol <> $title[0] Then
Traytip("xREL v3 - Neues Release [" & $rls[0]& "] ",$title[0],2,1)
FileDelete(@TempDir & "\xrl.txt")
write()
WinActivate("xREL - Release Viewer")
Endif
EndFunc


Do
    Sleep(50)
Until GUIGetMsg() = -3

Func WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)

    Local $hWndFrom, $iCode, $tNMHDR, $hWndListView
    $hWndListView = $lv
    If Not IsHWnd($lv) Then $hWndListView = GUICtrlGetHandle($lv)

    $tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
    $hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
    $iCode = DllStructGetData($tNMHDR, "Code")
    Switch $hWndFrom
        Case $hWndListView
            Switch $iCode

                Case $NM_DBLCLK  ; Sent by a list-view control when the user double-clicks an item with the left mouse button
                   Local $tInfo = DllStructCreate($tagNMITEMACTIVATE, $ilParam)

                   $Index = DllStructGetData($tInfo, "Index")

                   $subitemNR = DllStructGetData($tInfo, "SubItem")





                   ; make sure user clicks on the listview & only the activate
                   If $Index <> -1 Then

                       ; col1 ITem index
                        $item = StringSplit(_GUICtrlListView_GetItemTextString($lv, $Index),'|')
                        $item = $item[0]


                        ;Col item 2 index
                        $item2 = StringSplit(_GUICtrlListView_GetItemTextString($lv, $subitemNR),'|')
                        $item2= $item2[0]

                        ConsoleWrite($item & ' '  & @CRLF & $Index)
						ShellExecute($url[$Index])
						if $config[3] = 1 then
						Clipput($title[$Index])
						Endif

                    EndIf
					Case $LVN_HOTTRACK
				    Local $tInfo = DllStructCreate($tagNMLISTVIEW, $ilParam)
                    ListView_HOTTRACK(DllStructGetData($tInfo, "SubItem"))


            EndSwitch
    EndSwitch
    Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY

func info()
$font="Times New Roman Fett"
GUICreate("About", 220, 80)

GUICtrlCreateLabel("xREL - Release Viewer v. "& $version, 20, 20, 300, 80)
GUICtrlSetFont(-1,9,"","",$font)
$label = GuictrlCreateLabel("© reVerse 2013",20,40,100,25)
GUICtrlSetFont(-1,9,"","",$font)
GUISetState()

Do
    $msg = GUIGetMsg()
    If $msg = $label Then ShellExecute("http://www.xrel.to/user-profile.html?user=Mt01hyxx18562")
Until $msg = -3
If $msg = $GUI_EVENT_CLOSE Then GUIDelete()
Endfunc

Func ListView_HOTTRACK($iSubItem)
	if $config[5] = 1 then
    Local $HotItem = _GUICtrlListView_GetHotItem($lv)
    If $HotItem <> -1 Then _ToolTipMouseExit('released at: '& $time[$HotItem], 500)
	ENdif
EndFunc   ;==>ListView_HOTTRACK

Func _ToolTipMouseExit($TEXT, $TIME=-1, $x=-1, $y=-1, $TITLE='', $ICON=0, $OPT='')
    If $TIME = -1 Then $TIME = 3000
    Local $start = TimerInit(), $pos0 = MouseGetPos()
    If ($x = -1) Or ($y = -1) Then
        ToolTip($TEXT, $pos0[0], $pos0[1], $TITLE, $ICON, $OPT)
    Else
        ToolTip($TEXT, $x, $y, $TITLE, $ICON, $OPT)
    EndIf
    Do
        Sleep(50)
        $pos = MouseGetPos()
    Until (TimerDiff($start) > $TIME) Or _
        (Abs($pos[0] - $pos0[0]) > 10 Or _
         Abs($pos[1] - $pos0[1]) > 10)
    ToolTip('')
EndFunc ;_ToolTipMouseExit
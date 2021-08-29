#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <Array.au3>
#include <File.au3>
#include <MsgBoxConstants.au3>
#include <Constants.au3>
;#include <FileListToArray3.au3>

;#RequireAdmin

$res = _FileListToArrayRec(@ScriptDir, "res", 2, 1)
;_ArrayDisplay($res, "")

;$index = _ArraySearch($res, "src\main\res")
$res_result = _ArrayToString($res, ";")
$res_exists = StringInStr($res_result, "src\main\res")

If $res_exists = 0 Then
   MsgBox(0+64, "", "Info: No resources found")
Else
   ;MsgBox(0+64, "", "Found resources: "&$res_result)
   ;MsgBox(0, "", $is_res_in)
   $res_found = MsgBox(4+64, "Resource check", "Resources found. Do you want to compile the resources?")
EndIf

If $res_found = 6 Then
   FileChangeDir(@ScriptDir)
   ;$aapt2_compile = "aapt2 compile --dir BetterStatus\src\main\res -o tmpres.zip"
   While NOT @Error
	  Sleep(50)
	  $plugin_name = InputBox("Select plugin", "Please type the plugin name you want to compile the resources")
	  If @error = 1 Then
		 Exit
	  Else
		 If $plugin_name = '' Then
			MsgBox(0+16, "Error", "Please type a plugin name to continue!")
			ContinueLoop
		 Else
			If FileExists($plugin_name) And StringInStr(FileGetAttrib($plugin_name),"D") Then
			   $aapt2_compile = "aapt2 compile --dir "&$plugin_name&"\src\main\res -o tmpres.zip"
			   RunWait('"' & @ComSpec & '" /c' & $aapt2_compile)  ;/c is hidden     ;/k is not hidden
			   Sleep(100)
			   ExitLoop
			Else
			   MsgBox(0+16, "Error", "Please type a plugin name that exists!")
			   ContinueLoop
			EndIf
		 EndIf
	  EndIf
   WEnd
   Sleep(500)
   $aapt2_link = "aapt2 link -I D:\Sdk\platforms\android-30\android.jar -R tmpres.zip --manifest BetterStatus/src/main/AndroidManifest.xml -o plugin-tmp.apk"
   RunWait('"' & @ComSpec & '" /c' & $aapt2_link)  ;/c is hidden     ;/k is not hidden
   Sleep(100)
   $res_check = FileFindFirstFile("*.apk")
   $res_fname = FileFindNextFile($res_check)
   ;MsgBox(0, "", $res_fname)
   If FileExists($res_fname) Then
	  MsgBox(0+64, "Compile", "Resource compile success")
	  Sleep(100)
	  $build_f = _FileListToArrayRec(@ScriptDir, "build", 2, 1)
	  $build_f_result = _ArrayToString($build_f, ";")
	  ;MsgBox(0, "", $plugin_result)
	  $build_f_result_split = StringSplit($build_f_result, ";")
	  ;MsgBox(0, "", $build_f_result_split[2])
	  FileChangeDir($build_f_result_split[2])
	  Sleep(100)
	  ;MsgBox(0, "", $plugin_fname)
	  While (1)
		 $plugin_check = FileFindFirstFile("*.zip")
		 $plugin_fname = FileFindNextFile($plugin_check)
		 If FileExists($plugin_name&".zip") Then
			MsgBox(0+64, "Plugin check", $plugin_name&".zip plugin found")
			ExitLoop
		 Else
			MsgBox(0+64, "Plugin check", $plugin_name&".zip plugin not found. Program will wait until the plugin build is complete. Press Ok if it's done.")
			ContinueLoop
		 EndIf
		 Sleep(50)
	  WEnd
	  Sleep(100)
	  MsgBox(0+64, "Merge", "Merging plugin with compiled resources...")
	  ;Merge resources and plugin
	  FileChangeDir(@ScriptDir)
	  Sleep(100)
	  $unpack_res = "7za x -omerge-temp plugin-tmp.apk"
	  RunWait('"' & @ComSpec & '" /c' & $unpack_res)  ;/c is hidden     ;/k is not hidden
	  Sleep(100)
	  FileCopy($plugin_name&"\build\"&$plugin_name&".zip", @ScriptDir&"\merge-temp")
	  FileCopy("7za.exe", "merge-temp")
	  Sleep(100)
	  FileChangeDir("merge-temp")
	  $merge_res_plugin = "7za a "&$plugin_name&".zip res"
	  RunWait('"' & @ComSpec & '" /c' & $merge_res_plugin)  ;/c is hidden     ;/k is not hidden
	  Sleep(100)
	  $merge_res_plugin2 = "7za a "&$plugin_name&".zip resources.arsc"
	  RunWait('"' & @ComSpec & '" /c' & $merge_res_plugin2)  ;/c is hidden     ;/k is not hidden
	  Sleep(100)
	  $f_plugin_validation = "7za l "&@ScriptDir&"\"&$plugin_name&"\build\"&$plugin_name&".zip"
	  $f_plugin_validation2 = Run('"' & @ComSpec & '" /c ' & $f_plugin_validation, @ScriptDir&'\merge-temp', @SW_HIDE, $STDOUT_CHILD)  ;/c is hidden     ;/k is not hidden
	  Sleep(500)

	  If Not ProcessExists("7za.exe") Then
	  While (1)
		 $f_plugin_validation_line = StdoutRead($f_plugin_validation2)
		 ;MsgBox(0, "STDOUT read:", $f_plugin_validation_line)
		 ;MsgBox(0, "", $ourTest)
		 If Not StringInStr($f_plugin_validation_line, "ac-plugin") Or Not StringInStr($f_plugin_validation_line, ".dex") Then
			MsgBox(0+16, "Plugin validation", "This plugin is missing some files. Please check and build again.")
			ExitLoop
			Exit
		 Else
			MsgBox(0+64, "Plugin validation", "This plugin is valid.")
			ExitLoop
		 EndIf
		 Sleep(50)
	  WEnd
	  EndIf

	  FileMove($plugin_name&".zip", @ScriptDir&"\"&$plugin_name&"\build", 1)
	  Sleep(100)
	  FileChangeDir(@ScriptDir)
	  Sleep(100)
	  DirRemove("merge-temp", 1)
	  FileDelete("tmpres.zip")
	  FileDelete("plugin-tmp.apk")
   EndIf
Else
   If $res_found = 7 Then
	  Exit
   EndIf
EndIf

;Some funcs

Func _StdoutExpect($hOurProcess, $sOurExpected, $iOurTimeout = 100, $sOurSeparator = "|")
    Local $iOurTimer, $sOurOutput, $asOurExpected
    ; Explode the expected substrings into a StringSplit array
    $asOurExpected = StringSplit($sOurExpected, $sOurSeparator)
    ; Record the time to test vs our tiumeout.
    $iOurTimer = TimerInit()
    ; Loop
    While 1
        ; Return empty-handed of the timeout has elapsed
        If TimerDiff($iOurTimer) > $iOurTimeout Then
            SetError(1)
            Return 0
        EndIf
        ; Read and save available output from STDOUT
        $sOurOutput &= StdoutRead($hOurProcess)
        ; Step through provided substrings and test vs output
        For $incr = 1 To $asOurExpected[0]
            If StringInStr($sOurOutput, $asOurExpected[$incr]) Then
                ; Found this substring, so return its index
                Return $incr
            EndIf
        Next
    WEnd
EndFunc
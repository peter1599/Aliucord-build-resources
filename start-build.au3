#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <Array.au3>
#include <File.au3>
#include <MsgBoxConstants.au3>
#include <Constants.au3>
#include <AutoItConstants.au3>
;#include <FileListToArray3.au3>

;#RequireAdmin

$res = _FileListToArrayRec(@ScriptDir, "res", 2, 1)
;_ArrayDisplay($res, "")

;$index = _ArraySearch($res, "src\main\res")
$res_result = _ArrayToString($res, ";")
$res_exists = StringInStr($res_result, "src\main\res")

;-----------------------SDK Detection--------------------------------
Local $hFileOpen_sdk_path2 = FileOpen("sdk-path.conf", $FO_READ)
If $hFileOpen_sdk_path2 = -1 Then
   MsgBox(0+64, "SDK Detection", "Searching for Android SDK on default paths..."&@CRLF&@CRLF&"(Don't touch anything! This message will disappear automatically!)", 6)
   ;MsgBox(0+64, "", "An error occurred when reading Sdk path save file."&@CRLF&@CRLF&"Empty save file created and later will be used.")
   ;$init2 = FileWrite("sdk-path.conf", "")
   ;FileClose($init2)
EndIf
Local $sFileRead_sdk_path2 = FileRead($hFileOpen_sdk_path2)
FileClose($hFileOpen_sdk_path2)

$sdk_1 = _FileListToArrayRec(@LocalAppDataDir, "Sdk", 2, 1, Default, 2)
$sdk_2 = _FileListToArrayRec(@AppDataCommonDir, "Sdk", 2, 1, Default, 2)
$sdk_3 = _FileListToArrayRec(@AppDataDir, "Sdk", 2, 1, Default, 2)

;_ArrayDisplay($sdk_1, "1")
;_ArrayDisplay($sdk_2, "2")
;_ArrayDisplay($sdk_3, "3")

;$foo = _FileListToArray3("E:\", "Sdk", 0, 1)
;$foo = _FileListToArrayFolders1("E:\", "res", "res", 1)
;_ArrayDisplay($foo, "")

#comments-start
Local $sdk_4
Local $sdk_5
Local $sdk_6

If DriveStatus("C:\") = "READY" And DirGetSize("C:\") > 0 Then
   $sdk_4 = _FileListToArrayRec("C:\", "Sdk", 2, 1, Default, 2)
Endif
If DriveStatus("D:\") = "READY" And DirGetSize("D:\") > 0 Then
   $sdk_5 = _FileListToArrayRec("D:\", "Sdk", 2, 1, Default, 2)
Endif
If DriveStatus("E:\") = "READY" And DirGetSize("E:\") > 0 Then
   $sdk_6 = _FileListToArrayRec("E:\", "Sdk", 2, 1, Default, 2)
Endif
#comments-end

$sdk_1_result = _ArrayToString($sdk_1, ";")
$sdk_2_result = _ArrayToString($sdk_2, ";")
$sdk_3_result = _ArrayToString($sdk_3, ";")

#comments-start
$sdk_4_result = _ArrayToString($sdk_4, ";")
$sdk_5_result = _ArrayToString($sdk_5, ";")
$sdk_6_result = _ArrayToString($sdk_6, ";")
#comments-end

$sdk_1_exists = StringInStr($sdk_1_result, "Sdk\")
$sdk_2_exists = StringInStr($sdk_2_result, "Sdk\")
$sdk_3_exists = StringInStr($sdk_3_result, "Sdk\")

#comments-start
$sdk_4_exists = StringInStr($sdk_4_result, "Sdk\")
$sdk_5_exists = StringInStr($sdk_5_result, "Sdk\")
$sdk_6_exists = StringInStr($sdk_6_result, "Sdk\")
#comments-end


;_ArrayDisplay($sdk_6, "")
;MsgBox(0, "2", $sdk_6_result)

;MsgBox(0, "", StringSplit($sdk_6_result, ";")[2])
Local $sdk_path

Local $hFileOpen_sdk_path = FileOpen("sdk-path.conf", $FO_READ)
If $hFileOpen_sdk_path = -1 Then
   MsgBox(0+64, "SDK Detection", "An error occurred when reading Sdk path save file."&@CRLF&@CRLF&"Empty save file created and later will be used.")
   $init = FileWrite("sdk-path.conf", "")
   FileClose($init)
EndIf
Local $sFileRead_sdk_path = FileRead($hFileOpen_sdk_path)
FileClose($hFileOpen_sdk_path)


If ($sdk_1_exists  Or $sdk_2_exists Or $sdk_3_exists) = 0 Or ($sFileRead_sdk_path = '') Then
   $sdk_notfound = MsgBox(4+32, "SDK Detection", "SDK not found on default paths. Do you want to tpye the Sdk path manually?")
   If $sdk_notfound = 6 Then
	  $sdk_path = InputBox("Sdk path", "Please type the full Sdk path (with backslash '\'): "&@CRLF&@CRLF&"eg.: E:\Sdk\ <--(always put a \ at the end)", "", "", 300)
	  If @error = 1 Then
		 Exit
	  Else
		 If Not FileWrite("sdk-path.conf", "") Then
			MsgBox($MB_SYSTEMMODAL, "", "An error occurred whilst writing the Sdk path save file.")
			Return False
		 EndIf
		 Local $hFileOpen = FileOpen("sdk-path.conf", $FO_OVERWRITE)
		 If $hFileOpen = -1 Then
			MsgBox($MB_SYSTEMMODAL, "", "An error occurred whilst writing the Sdk path save file.")
			Return False
		 EndIf
		 FileWrite("sdk-path.conf", $sdk_path)
		 FileClose($hFileOpen)
	  EndIf
   ElseIf $sdk_notfound = 7 Then
	  Exit
   EndIf
Else
   #comments-start
   If Not $sdk_6_result = 0 or Not $sdk_6_result = -1 And DirGetSize(StringSplit($sdk_6_result, ";")[2]) > 250000000 Then
	  $sdk_path = StringSplit($sdk_6_result, ";")[2]
	  MsgBox(0+64, "SDK Detection", "SDK found on: '"&StringSplit($sdk_6_result, ";")[2]&"' and applied")
   ElseIf Not $sdk_5_result = 0 or (Not $sdk_5_result = -1 And DirGetSize(StringSplit($sdk_5_result, ";")[2]) > 250000000 Then
	  $sdk_path = StringSplit($sdk_5_result, ";")[2]
	  MsgBox(0+64, "SDK Detection", "SDK found on: '"&StringSplit($sdk_5_result, ";")[2]&"' and applied")
   ElseIf Not $sdk_4_result = 0 or Not $sdk_4_result = -1 And DirGetSize(StringSplit($sdk_4_result, ";")[2]) > 250000000 Then
	  $sdk_path = StringSplit($sdk_4_result, ";")[2]
	  MsgBox(0+64, "SDK Detection", "SDK found on: '"&StringSplit($sdk_4_result, ";")[2]&"' and applied")
   Else
   #comments-end


   If Not $sdk_3_exists = 0 And $sdk_3_result = -1 And (DirGetSize(StringSplit($sdk_3_result, ";")[2]) > 250000000) Then
	  $sdk_path = StringSplit($sdk_3_result, ";")[2]
	  MsgBox(0+64, "SDK Detection", "SDK found on: '"&StringSplit($sdk_3_result, ";")[2]&"' and applied")
   ElseIf Not $sdk_2_exists = 0 And $sdk_2_result = -1 And (DirGetSize(StringSplit($sdk_2_result, ";")[2]) > 250000000) Then
	  $sdk_path = StringSplit($sdk_2_result, ";")[2]
	  MsgBox(0+64, "SDK Detection", "SDK found on: '"&StringSplit($sdk_2_result, ";")[2]&"' and applied")
   ElseIf Not $sdk_1_exists = 0 And $sdk_1_result = -1 And (DirGetSize(StringSplit($sdk_1_result, ";")[2]) > 250000000) Then
	  $sdk_path = StringSplit($sdk_1_result, ";")[2]
	  MsgBox(0+64, "SDK Detection", "SDK found on: '"&StringSplit($sdk_1_result, ";")[2]&"' and applied")
   ElseIf $sFileRead_sdk_path Then
	  $sdk_path = $sFileRead_sdk_path
	  MsgBox(0+64, "SDK Detection", "No SDK was found on default paths. "&@CRLF&@CRLF&"SDK save file found with: '"&$sdk_path&"' and applied")
   EndIf
EndIf

;MsgBox(0, "", $sdk_1_result)
;_ArrayDisplay($sdk_1, "")

;-------------------------------------------------------------------

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
   $aapt2_link = "aapt2 link -I "&$sdk_path&"platforms\android-30\android.jar -R tmpres.zip --manifest "&$plugin_name&"/src/main/AndroidManifest.xml -o plugin-tmp.apk"
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
			MsgBox(0+16, "Plugin validation", "The final merged plugin is missing some files. Please check and build again.")
			ExitLoop
			Exit
		 Else
			MsgBox(0+64, "Plugin validation", "The final merged plugin is valid.")
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
B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=9.3
@EndOfDesignText@
Sub Class_Globals
	Private fx As JFX
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	
End Sub

Public Sub CheckAndAddInStartup(AddInLocalMachineForAllUsersFalseOnlyForCurrentUser As Boolean, ApplicationName As String, ExecutableNameAfterCreatingWithBuiltInB4JPackager11 As String)
	Dim sKey As String
	Dim jShell As Shell
	
	
	If AddInLocalMachineForAllUsersFalseOnlyForCurrentUser = False Then
		sKey = "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run"
	Else
		sKey = "HKEY_LOCAL_mACHINE\Software\Microsoft\Windows\CurrentVersion\Run"
	End If
	
	
	
	If CheckIfWindows = True Then
		Log("Checked OS: Windows")
		jShell.Initialize("js", "C:\Windows\System32\Reg.exe", Array As String("QUERY", sKey, "/v", ApplicationName))
	
		Dim shr As ShellSyncResult = jShell.RunSynchronous(3000)
	
		LogTheResult(shr)
	
		If shr.StdOut.Contains(ApplicationName) Then
			Log("Not adding anything")
		Else
			Try
				jShell.Initialize("js", "C:\Windows\System32\Reg.exe", Array As String("ADD", sKey, "/v", ApplicationName, "/d", File.Combine(File.GetFileParent(File.DirApp), ExecutableNameAfterCreatingWithBuiltInB4JPackager11) ))
				shr = jShell.RunSynchronous(3000)
				LogTheResult(shr)
			Catch
				Log(LastException)
			End Try

		End If
	Else
		Log("Checked OS: Not Windows")
	End If	

End Sub


Public Sub Delete (AddInLocalMachineForAllUsersFalseOnlyForCurrentUser As Boolean, ApplicationName As String)
	Dim sKey As String
	Dim jShell As Shell
	
	
	If AddInLocalMachineForAllUsersFalseOnlyForCurrentUser = False Then
		sKey = "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run"
	Else
		sKey = "HKEY_LOCAL_mACHINE\Software\Microsoft\Windows\CurrentVersion\Run"
	End If
	
	
	
	If CheckIfWindows = True Then
		Log("Checked OS: Windows")
		jShell.Initialize("js", "C:\Windows\System32\Reg.exe", Array As String("QUERY", sKey, "/v", ApplicationName))
	
		Dim shr As ShellSyncResult = jShell.RunSynchronous(3000)
		
		LogTheResult(shr)
		
		If shr.StdOut.Contains(ApplicationName) Then
			Try
				jShell.Initialize("js", "C:\Windows\System32\Reg.exe", Array As String("DELETE", sKey, "/v", ApplicationName, "/f"))
				shr = jShell.RunSynchronous(3000)
				LogTheResult(shr)
			Catch
				Log(LastException)
			End Try

		Else		
			Log("Not deleting anything")
		End If
	Else
		Log("Checked OS: Not Windows")
	End If
	
End Sub



Public Sub IsDotNetFrameWorkInstalled() As Boolean
	Dim sKey As String
	Dim jShell As Shell
	
	sKey = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full"
	
	If CheckIfWindows = True Then
		Log("Checked OS: Windows")
		jShell.Initialize("js", "C:\Windows\System32\Reg.exe", Array As String("QUERY", sKey))
	
		Dim shr As ShellSyncResult = jShell.RunSynchronous(3000)
	
		LogTheResult(shr)
	
		If shr.StdOut = "" Then
			Return False
		Else
			Return True			
		End If
	Else
		Log("Checked OS: Not Windows")
	End If

End Sub



Sub AddElevatedAppToTasks(TaskFolderAndNameofApp As String,apppath As String)
	'=========== Add a an app to tasks to run with elevated priviledges ===============
	'By Magma
	'This will add the app at Tasks with the name of exe produced by b4jpackager !
	'AddElevatedAppToTasks("Magma\mSupport",File.GetFileParent(File.DirApp) & "\" & "msupport.exe")
	If CheckIfWindows = True Then
		Dim t1 As String=sys32run("schtasks.exe",Array("/create","/SC","ONLOGON","/TN",QUOTE & TaskFolderAndNameofApp & QUOTE,"/TR",QUOTE & apppath & QUOTE,"/RL","HIGHEST"))
		Log(t1)
	End If
End Sub


Sub DeleteElevatedAppFromTasks(TaskFolderAndNameofApp As String)
	'=========== Add a an app from tasks where it was added to run with elevated priviledges ===============
	'This will remove it from Tasks...
	'DeleteElevatedAppFromTasks("Magma\mSupport")
	'By Magma
	If CheckIfWindows = True Then
		Dim t1 As String=sys32run("schtasks.exe",Array("/delete","/TN",QUOTE & TaskFolderAndNameofApp & QUOTE,"/f"))
		Log(t1)
	End If
End Sub

' By Magma
Private Sub sys32run(app As String,params As List) As String
	Dim js As Shell
	js.Initialize("js", app, params)
	js.WorkingDirectory="c:\windows\system32"
	'If Main.ShellEncoding.Length>0 Then js.Encoding=Main.ShellEncoding
	Dim string1 As ShellSyncResult
	Dim string2 As String
	string1=js.RunSynchronous(-1)
	string2=string1.StdOut
	Return string2
End Sub


Private Sub LogTheResult(shr As ShellSyncResult)
	Log("---stdout----")
	If shr.StdOut = "" Then 
		Log("----")
	Else
		Log(shr.StdOut)
	End If
	Log("---stderr----")
	If shr.Stderr = "" Then
		Log("----")
	Else
		Log(shr.StdErr)
	End If
End Sub


Private Sub CheckIfWindows As Boolean
	Return GetSystemProperty("os.name", "").ToLowerCase.Contains("windows")
End Sub
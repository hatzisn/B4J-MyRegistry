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

Public Sub CheckAndAddInStartup(AddInLocalMachineFalseForLocalUser As Boolean, ApplicationName As String)
	Dim sKey As String
	Dim jShell As Shell
	
	
	If AddInLocalMachineFalseForLocalUser = False Then
		sKey = "HKEY_LOCAL_USER\Software\Microsoft\Windows\CurrentVersion\Run"
	Else
		sKey = "HKEY_LOCAL_mACHINE\Software\Microsoft\Windows\CurrentVersion\Run"
	End If
	
	
	
	jShell.Initialize("js", "C:\Windows\System32\Reg.exe", Array As String("QUERY", sKey))
	
	Dim shr As ShellSyncResult = jShell.RunSynchronous(3000)
	
	Log(shr.StdOut)
	
End Sub



Private Sub CheckIfWindows As Boolean
	Return GetSystemProperty("os.name", "").ToLowerCase.Contains("windows")
End Sub
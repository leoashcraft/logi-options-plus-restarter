try
    set scriptPath to (POSIX path of (path to home folder)) & "Library/Application Support/LogiOptionsPlusRestarter/restart.sh"
    do shell script quoted form of scriptPath
    display notification "Options+ agent restart requested." with title "Logi Options+ Restarter"
on error errMsg
    display dialog "Restart failed: " & errMsg buttons {"OK"} default button "OK"
end try

#Requires AutoHotkey v2.0
GetDuration(soundPath) {
    try {
        player := ComObject("WMPlayer.OCX.7")
        player.settings.autoStart := false
        media := player.newMedia(soundPath)
        return Round(media.duration * 1000)
    } catch {
        return 2000
    }
}
; Путь к папке со звуками
basepath := "C:\\steeeeem\\steamapps\\common\\Counter-Strike Global Offensive\\game\\bin\\win64\\nix\\scripts\\sounds\\"
sound_files := Array()
extensions := ["mp3", "wav"]  ; Добавь другие форматы, если нужно, например "ogg", "flac"
Loop 7 {
    found := false
    num := A_Index
    for ext in extensions {
        soundPath := basepath . num . "." . ext
        if FileExist(soundPath) {
            sound_files.Push(num . "." . ext)
            found := true
            break
        }
    }
    if !found {
        MsgBox("Не найден файл для звука " . num)
        ExitApp
    }
}
; Бинды звуков в саундпаде
binds := Array()
binds.Push("0")
binds.Push("9")
binds.Push("8")
binds.Push("7")
binds.Push("6")
binds.Push("F6")
binds.Push("F7")
SetTimer(CheckTrigger, 50)
CheckTrigger()
{
    if FileExist("C:\nixware\killmic_trigger.txt")
    {       
        idx := Random(1, sound_files.Length)
       
        soundPath := basepath . sound_files[idx]
        bind_key := binds[idx]
       
        duration := GetDuration(soundPath)
        ; u - бинд на микрофон в cs2 - поменяй для себя
        Send("{u down}")
        Sleep(50)
        Send("{" . bind_key . "}")
        Sleep(duration + 500)  ; Добавил 500 мс для компенсации задержки
        Send("{u up}")
       
        FileDelete("C:\nixware\killmic_trigger.txt")
    }
}
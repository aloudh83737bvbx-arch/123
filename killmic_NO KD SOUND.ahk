#Requires AutoHotkey v2.0

; Путь к папке со звуками
basepath := "C:\\steeeeem\\steamapps\\common\\Counter-Strike Global Offensive\\game\\bin\\win64\\nix\\scripts\\sounds\\"

sound_files := Array()
extensions := ["mp3", "wav"] ; Добавь другие форматы, если нужно

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

; Бинды звуков в саундпаде (соответствуют порядку 1–7)
binds := Array()
binds.Push("0")
binds.Push("9")
binds.Push("8")
binds.Push("7")
binds.Push("6")
binds.Push("F6")
binds.Push("F7")

; === Настройки спама ===
mic_held := false
release_delay := 3000  ; Время (мс) удержания микрофона после последнего триггера.
                       ; Увеличь до 5000–8000, если хочешь, чтобы последние звуки доигрывались полнее.
                       ; Уменьши до 1000–2000 для более быстрого отпускания и большего обрезания.

ReleaseMic() {
    global mic_held
    if (mic_held) {
        Send("{u up}")  ; u — бинд на микрофон в CS2, поменяй при необходимости
        mic_held := false
    }
}

CheckTrigger() {
    global mic_held, release_delay
    trigger := "C:\nixware\killmic_trigger.txt"
    
    if FileExist(trigger) {
        if (!mic_held) {
            Send("{u down}")
            mic_held := true
        }
        
        idx := Random(1, sound_files.Length)
        bind_key := binds[idx]
        Send("{" . bind_key . "}")
        
        FileDelete(trigger)
        
        ; Сбрасываем таймер отпускания микрофона
        SetTimer(ReleaseMic, -release_delay)
    }
}

; Проверка каждые 20 мс — практически без задержки
SetTimer(CheckTrigger, 20)

; Немедленная проверка при запуске скрипта
CheckTrigger()
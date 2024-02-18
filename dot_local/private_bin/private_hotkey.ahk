#Include drag-mouse.ahk

; lastwin := 0

term(title, cmd := "", max := false) {
  SetTitleMatchMode 3
  if ((WinExist("ahk_class CASCADIA_HOSTING_WINDOW_CLASS")) and (WinExist(title))){
    If WinActive(title){
      WinMinimize
    }Else{
      WinActivate
    }
  }else{
    if (max){
      RunWait "wt.exe -f nt -M --suppressApplicationTitle --title " . title . " " . cmd
      WinWait(title)
      WinMaximize
      WinActivate
    }else{
      RunWait "wt.exe -f nt --suppressApplicationTitle --title " . title . " " . cmd
      WinActivate
    }
  }
}

termclose(title, cmd := "", max := false) {
  SetTitleMatchMode 3
  if ((WinExist("ahk_class CASCADIA_HOSTING_WINDOW_CLASS")) and (WinExist(title))){
    WinClose
    WinActivate lastwin
  }else{
    global lastwin := WinActive("A")
    if (max){
      RunWait "wt.exe -f nt -M --suppressApplicationTitle --title " . title . " " . cmd
      WinWait(title)
      WinMaximize
      WinActivate
    }else{
      RunWait "wt.exe -f nt --suppressApplicationTitle --title " . title . " " . cmd
      WinWait(title)
      WinActivate
      ; WinWaitClose
      ; WinActivate lastwin
    }
  }
}

#Enter:: term("term:linux",, true)

#+Enter:: term("term:lf", "wsl.exe -- lf ~/", false)

#+p:: termclose("term:pass","wsl.exe -- BASH_ENV=~/.config/shell/profile pass menu", false)

#w::{
  SetTitleMatchMode "RegEx"
  if ((WinExist("ahk_class Chrome_WidgetWin_1")) and (WinExist("Vieb.*"))){
    If (WinActive("ahk_class Chrome_WidgetWin_1")) and (WinActive("Vieb.*")){
        WinMinimize
    }Else{
      WinActivate
    }
  }else{
      RunWait "vieb.exe"
  }
}


#+w::{
  SetTitleMatchMode "RegEx"
  if (WinExist("ahk_class MozillaWindowClass")){
    If WinActive("ahk_class MozillaWindowClass"){
        WinMinimize
    }Else{
      WinActivate
    }
  }else{
      RunWait "firefox.exe"
  }
}

#f:: WinMaximize("A")
#+f:: WinMinimize("A")

#d:: WinClose("A")
#+d:: WinKill("A")

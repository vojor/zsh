
plugins/antidote.zsh
9:5:    print -P "%F{244}[%D{%H:%M:%S}]%f %F{yellow}%BWarning:%b%f %F{242}Antidote not found.%f"
14:5:    print -P "%F{blue}%BUpdating plugins bundle...%b%f"
17:9:        print -P "%F{244}[%D{%H:%M:%S}]%f %F{yellow}%BWarning:%b%f %F{242}No proxy detected, plugin download might fail or hang.%f"
23:9:        print -P "%F{blue}%BRun antidote bundle...%b%f"
29:13:            print -P "%F{244}[%D{%H:%M:%S}]%f %F{green}%BSuccess:%b%f %F{blue}plugins bundle and loaded.%f"
31:13:            print -P "%F{244}[%D{%H:%M:%S}]%f %F{red}%BError:%b%f %F{172}antidote bundle failed, retain..., check network%f"
37:9:        print -P "%F{244}[%D{%H:%M:%S}]%f %F{red}%BError:%b%f %F{172}plugins.txt file not found%f"
45:5:    print -P "%F{green}%BInitializing or updating plugins...%b%f"

core/colors.zsh
15:9:        print -Pn "\e]0;%n@%m: %~\a"

README.md
22:9:        print -P "%F{blue}%BDetecting proxy, auto-installing Antidote...%b%f"
24:13:            print -P "%F{green}Antidote installed successfully!%f"
33:17:                print -P "\n%F{160}%BDependency Check Failed:%b%f"
34:17:                print -P "%F{214}Missing tools: %B${missing[*]}%b%f"
35:17:                print -P "%F{76}Please install them, then run: %B%F{32}source ~/.zshrc%b%f\n"
40:9:        print -P "%F{yellow}%BWarning:%b No proxy detected. Skipping install antidote.%f"
49:5:    print -P "%F{red}%BError:%b%f %F{172}Initialization file not found.%f"

boot/proxy.zsh
8:59:        proxy_host=$(ip route show | grep default | awk '{print $3}')
10:59:        proxy_host=$(ip route show | grep default | awk '{print $3}')
25:5:    print -P "%F{244}[%D{%H:%M:%S}]%f %F{76}%BProxy Success On:%b%f %F{32}${proxy_url}%f"
30:5:    print -P "%F{244}[%D{%H:%M:%S}]%f %F{202}%BProxy Success Off%b%f"

extend/archive.zsh
5:27:    [[ -f "$file" ]] || { print -P "%F{red}󰅚 %f File '$file' not found."; return 1 }
8:5:    print -P "%F{blue}󰛒 %f Extracting '$file' to '$dest'..."
9:38:    bsdtar -xf "$file" -C "$dest" && print -P "%F{green}󰄬 %f Done."
17:45:    [[ -z "$target" || $count -eq 0 ]] && { print -P "%F{yellow}Usage:%f p <arch.ext> <files...>"; return 1 }
19:5:    print -P "%F{blue}󰿖 %f Packing %B$count%b item(s) into '$target'..."
20:35:    bsdtar -acf "$target" "$@" && print -P "%F{green}󰄬 %f Created."
LICENSE
186:13:      same "printed page" as the copyright notice for easier

core/colors.zsh
15:9:        print -Pn "\e]0;%n@%m: %~\a"

boot/proxy.zsh
8:59:        proxy_host=$(ip route show | grep default | awk '{print $3}')
10:59:        proxy_host=$(ip route show | grep default | awk '{print $3}')
25:5:    print -P "%F{244}[%D{%H:%M:%S}]%f %F{76}󱊟 %BProxy Success On:%b%f %F{32}${proxy_url}%f"
30:5:    print -P "%F{244}[%D{%H:%M:%S}]%f %F{202}󱊠 %BProxy Success Off%b%f"

extend/archive.zsh
5:27:    [[ -f "$file" ]] || { print -P "%F{red}󰅚 %f File '$file' not found."; return 1 }
8:5:    print -P "%F{blue}󰛒 %f Extracting '$file' to '$dest'..."
9:38:    bsdtar -xf "$file" -C "$dest" && print -P "%F{green}󰄬 %f Done."
17:45:    [[ -z "$target" || $count -eq 0 ]] && { print -P "%F{yellow}Usage:%f p <arch.ext> <files...>"; return 1 }
19:5:    print -P "%F{blue}󰿖 %f Packing %B$count%b item(s) into '$target'..."
20:35:    bsdtar -acf "$target" "$@" && print -P "%F{green}󰄬 %f Created."

plugins/antidote.zsh
9:5:    print -P "%F{244}[%D{%H:%M:%S}]%f %F{yellow} %BWarning:%b%f %F{242}Antidote not found.%f"
14:5:    print -P "%F{blue}󰚰 %BUpdating plugins bundle...%b%f"
17:9:        print -P "%F{244}[%D{%H:%M:%S}]%f %F{yellow} %BWarning:%b%f %F{242}No proxy detected, Skipping plugin install.%f"
23:9:        print -P "%F{blue}󱓞 %BRun antidote bundle...%b%f"
29:13:            print -P "%F{244}[%D{%H:%M:%S}]%f %F{green}󰄬 %BSuccess:%b%f %F{blue}plugins bundle and loaded.%f"
31:13:            print -P "%F{244}[%D{%H:%M:%S}]%f %F{red}󰅚 %BError:%b%f %F{172}antidote bundle failed, retain..., check network%f"
37:9:        print -P "%F{244}[%D{%H:%M:%S}]%f %F{red}󰅚 %BError:%b%f %F{172}plugins.txt file not found%f"
45:5:    print -P "%F{green}󱐥 %BInitializing or updating plugins...%b%f"

README.md
22:9:        print -P "%F{blue}%BDetecting proxy, auto-installing Antidote...%b%f"
24:13:            print -P "%F{green}Antidote installed successfully!%f"
33:17:                print -P "\n%F{160}%BDependency Check Failed:%b%f"
34:17:                print -P "%F{214}Missing tools: %B${missing[*]}%b%f"
35:17:                print -P "%F{76}Please install them, then run: %B%F{32}source ~/.zshrc%b%f\n"
40:9:        print -P "%F{yellow}%BWarning:%b No proxy detected. Skipping install antidote.%f"
49:5:    print -P "%F{red}%BError:%b%f %F{172}Initialization file not found.%f"

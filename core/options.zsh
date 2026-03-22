# 通配符
setopt EXTENDED_GLOB        # 开启高级通配符
setopt GLOB_DOTS            # 允许用 * 匹配到以点开头的隐藏文件
# 交互
setopt NO_BEEP              # 关掉那个烦人的哔哔声
setopt INTERACTIVE_COMMENTS # 允许在命令行里用 # 写注释
setopt RM_STAR_WAIT         # 执行 'rm *' 前等待 10 秒确认
setopt NO_CLOBBER           # 禁止使用 > 覆盖，必须用 >! 强制覆盖
# 补全
setopt CORRECT              # 拼写检查
setopt COMPLETE_IN_WORD     # 允许在单词中间进行补全
setopt ALWAYS_TO_END        # 补全后自动将光标移到末尾
setopt LIST_PACKED          # 补全列表显示更紧凑
setopt AUTO_MENU            # 第二次按 Tab 时显示补全菜单
# 目录
setopt AUTO_CD              # 输入目录名直接进入

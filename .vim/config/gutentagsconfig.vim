let g:gutentags_ctags_exclude = ['/Users/*','~', '/', '/bin/*', '/boot/*', '/dev/*', '/etc/*', '/home/*/.cache', '/home/*/.config', '/home/*/.local', '/home/*/.vim', '/home/*/.gnupg', '/home/*/.ssh', '/lib/*', '/lib64/*', '/media/*', '/mnt/*', '/opt/*', '/proc/*', '/root/*', '/run/*', '/sbin/*', '/srv/*', '/sys/*', '/tmp/*', '/usr/*', '/var/*', '~/Library', '~/Downloads', '~/Music', '~/Pictures', '~/Movies', '~/Desktop', '*.tmp', '*.log', '*.sock', '*.savedState' ]

let g:gutentags_exclude = ['/Users/*','~', '/', '/bin/*', '/boot/*', '/dev/*', '/etc/*', '/home/*/.cache', '/home/*/.config', '/home/*/.local', '/home/*/.vim', '/home/*/.gnupg', '/home/*/.ssh', '/lib/*', '/lib64/*', '/media/*', '/mnt/*', '/opt/*', '/proc/*', '/root/*', '/run/*', '/sbin/*', '/srv/*', '/sys/*', '/tmp/*', '/usr/*', '/var/*', '~/Library', '~/Downloads', '~/Music', '~/Pictures', '~/Movies', '~/Desktop', '*.tmp', '*.log', '*.sock', '*.savedState' ]
let g:gutentags_ctags_exclude_project_root = ['/Users/*','~', '/', '/bin/*', '/boot/*', '/dev/*', '/etc/*', '/home/*/.cache', '/home/*/.config', '/home/*/.local', '/home/*/.vim', '/home/*/.gnupg', '/home/*/.ssh', '/lib/*', '/lib64/*', '/media/*', '/mnt/*', '/opt/*', '/proc/*', '/root/*', '/run/*', '/sbin/*', '/srv/*', '/sys/*', '/tmp/*', '/usr/*', '/var/*', '~/Library', '~/Downloads', '~/Music', '~/Pictures', '~/Movies', '~/Desktop', '*.tmp', '*.log', '*.sock', '*.savedState' ]

" gtags cscope doesn't work on mac, avoid changing on master until solution is found
let g:gutentags_modules = ['ctags', 'gtags_cscope']

" config project root markers.

let g:gutentags_project_root = ['.root','.git', '.hg', '.svn', '.bzr']

" generate datebases in my cache directory, prevent gtags files polluting my project
let g:gutentags_cache_dir = expand('~/.cache/tags')

" change focus to quickfix window after search (optional).
let g:gutentags_plus_switch = 1

"set statusline+=%{gutentags#statusline()}
let g:gutentags_trace = 0

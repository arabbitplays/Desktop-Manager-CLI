project('DesktopManagerCLI',
        ['cpp', 'c'],
        default_options : [
            'warning_level=3',
            'cpp_std=c++20'
        ],
)

incdirs = [
]

project_root = meson.current_source_dir()

py = import('python').find_installation('python3')
run_command(py, 'scripts/generate_meson_files.py', 'src', check: true)

src = []
subdir('src')

exe = executable(
    'DesktopManagerCLI',
    sources: src,
    dependencies: [

    ],
    include_directories: incdirs,
    install : true,
)

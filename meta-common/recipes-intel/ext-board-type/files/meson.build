project(
    'extBoardType',
    'cpp',
    license: 'proprietary',
    version: '0.1',
        default_options: [
        'warning_level=0',
        'werror=false',
        'cpp_std=c++20'
    ],
)

boost = dependency('boost', required: true, version : '>=1.71', modules: [ 'coroutine', 'context'])

sdbusplus = dependency('sdbusplus', required: true)
sdbusplus_dep = sdbusplus.partial_dependency(link_args: true, includes : true, links: true)


systemd = dependency('systemd', required: true)
systemd_system_unit_dir = systemd.get_pkgconfig_variable('systemdsystemunitdir', define_variable: ['prefix', get_option('prefix')])

configure_file(
  copy: true,
  input: 'xyz.openbmc_project.ext_board_type.service',
  install: true,
  install_dir: systemd_system_unit_dir,
  output: 'xyz.openbmc_project.ext_board_type.service',
)

threads = dependency('threads')

deps = [
    boost,
    sdbusplus_dep,
    threads,
]

executable(
    'ext-board-type',
    'ext_board_type.cpp',
    dependencies: deps,
    install: true,
    install_dir: get_option('bindir'),
    override_options : ['warning_level=0', 'werror=true'])


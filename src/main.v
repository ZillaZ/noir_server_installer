module main

import os
import readline { read_line }
import net.http

fn build_path(elems []string) string {
	sep := $if windows {
		'\\'
	}$else{
		'/'
	}
	return elems.join(sep)
}

fn main() {
	default_path := os.home_dir()
	mut install_path := read_line('Type the installation path (defaults to ${default_path}):\n') or {
		default_path
	}

	if install_path.trim_space().len == 0 {
		install_path = default_path
	}
	
	install_path = build_path([install_path, 'Noir Server'])
	println('Installing on ${install_path}')
	if !os.exists(install_path) {
		os.mkdir("${install_path}") or {
			println('Unable to create install directory on ${install_path}\n${err}')
			return
		}
	}
	println("Downloading precompiled binary from Github...")
	base_url := $if linux {
		'https://github.com/ZillaZ/noir_cicd_server/releases/download/release/cicd_server-unix64'
	} $else {
		'https://github.com/ZillaZ/noir_cicd_server/releases/download/release/cicd_server-win64.exe'
	}
	binary_name := $if linux {
		'noir_server'
	} $else {
		'noir_server.exe'
	}
	http.download_file_with_progress(base_url, build_path([install_path, binary_name])) or {
		println('Failed to download executable.\n${err}')
		return
	}
	config_path := os.config_dir() or {
		println("Unable to create config dir.\n${err}")
		return
	}
	server_config_path := build_path([config_path, 'Noir', 'Server'])
	make_dir(build_path([config_path, 'Noir']))
	make_dir(server_config_path)
	make_dir(build_path([server_config_path, 'logs']))
	make_dir(build_path([server_config_path, 'envs']))
	println('Created config directories at ${server_config_path}')
	println("You're almost ready! Just add ${install_path} to your PATH.\nRead about server configuration on https://github.com/ZillaZ/noir_cicd_server")
}

fn make_dir(path string) {
	os.mkdir(path) or {
		println('Failed to create directory at ${path}.\n${err}')
	}
}
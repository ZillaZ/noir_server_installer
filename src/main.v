module main

import os
import readline { read_line }
import net.http

fn main() {
	default_path := os.home_dir()
	mut install_path := read_line('Type the installation path (defaults to ${default_path}):\n') or {
		default_path
	}

	if install_path.trim_space().len == 0 {
		install_path = default_path
	}
	
	install_path = "${install_path}\\Noir Server"
	println('Installing on ${install_path}')
	if !os.exists(install_path) {
		os.mkdir("${install_path}") or {
			println('Unable to create install directory on ${install_path}\n${err}')
			return
		}
	}
	println("Downloading precompiled binary from Github...")
	mut base_url := 'https://github.com/ZillaZ/noir_cicd_server/releases/download/release/cicd_server-unix64'
	$if windows {
		base_url = 'https://github.com/ZillaZ/noir_cicd_server/releases/download/release/cicd_server-win64.exe'
	}
	mut binary_name := 'noir_server'
	$if windows {
		binary_name = 'noir_server.exe'
	}
	http.download_file_with_progress(base_url, "${install_path}\\${binary_name}") or {
		println('Failed to download executable.\n${err}')
		return
	}
	config_path := os.config_dir() or {
		println("Unable to create config dir.\n${err}")
		return
	}
	if !os.exists("${config_path}\\Noir\\Server") {
		os.mkdir("${config_path}\\Noir") or {}
		os.mkdir("${config_path}\\Noir\\Server") or {}
	}
	println('Created config directories at ${config_path}\\Noir\\Server')
	println("You're almost ready! Just add ${install_path} to your PATH.\nRead about server configuration on https://github.com/ZillaZ/noir_cicd_server")
}

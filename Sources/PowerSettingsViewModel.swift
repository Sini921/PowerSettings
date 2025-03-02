//
// Copyright (c) 2025 Nightwind
//

import FrontBoardServices
import libroot

internal final class PowerSettingsViewModel {
	func respring() {
		Spawn.run(path: jbRootPath("/usr/bin/killall"), args: ["killall", "SpringBoard"])
	}

	func safeMode() {
		Spawn.run(path: jbRootPath("/usr/bin/killall"), args: ["killall", "-SeGV", "SpringBoard"])
	}

	func userspaceReboot() {
		Spawn.run(path: jbRootPath("/usr/bin/launchctl"), args: ["launchctl", "reboot", "userspace"])
	}

	func reboot() {
		FBSSystemService.shared()?.reboot()
	}

	func shutdown() {
		FBSSystemService.shared()?.shutdown()
	}

	func isUserspaceRebootAvailable() -> Bool {
		FileManager.default.fileExists(atPath: jbRootPath("/usr/bin/launchctl"))
	}
}
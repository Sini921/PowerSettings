//
// Copyright (c) 2025 Nightwind
//

internal enum PowerAction: Identifiable {
	case respring, safeMode, userspaceReboot, reboot, shutdown

	var id: Self { self }

	var title: String {
		switch self {
		case .respring: return "Respring"
		case .safeMode: return "Safe Mode"
		case .userspaceReboot: return "Userspace Reboot"
		case .reboot: return "Reboot"
		case .shutdown: return "Shutdown"
		}
	}

	var message: String {
		switch self {
		case .respring: return "Are you sure you want to respring?"
		case .safeMode: return "Are you sure you want to enter safe mode?"
		case .userspaceReboot: return "Are you sure you want to perform a userspace reboot?"
		case .reboot: return "Are you sure you want to reboot your device?"
		case .shutdown: return "Are you sure you want to shut down your device?"
		}
	}
}
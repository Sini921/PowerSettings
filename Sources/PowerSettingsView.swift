//
// Copyright (c) 2025 Nightwind
//

import SwiftUI

internal struct PowerSettingsView: View {
	private let viewModel = PowerSettingsViewModel()

	@State private var selectedAction: PowerAction? = nil

	var body: some View {
		List {
			PowerSettingsButton(title: "Respring", subtitle: "killall SpringBoard", action: { self.selectedAction = .respring })
			PowerSettingsButton(title: "Safe Mode", subtitle: "killall -SeGV SpringBoard", action: { self.selectedAction = .safeMode })

			// On some older jailbreaks the userspace reboot functionality may not have been implemented
			if viewModel.isUserspaceRebootAvailable() {
				PowerSettingsButton(title: "Userspace Reboot", subtitle: "launchctl reboot userspace", action: { self.selectedAction = .userspaceReboot })
			}

			PowerSettingsButton(title: "Reboot", subtitle: "FBSSystemService.reboot()", action: { self.selectedAction = .reboot })
			PowerSettingsButton(title: "Shut Down", subtitle: "FBSSystemService.shutdown()", action: { self.selectedAction = .shutdown })
		}
		.alert(item: self.$selectedAction) { action in
			Alert(
				title: Text(action.title),
				message: Text(action.message),
				primaryButton: .destructive(Text("OK")) {
					switch action {
					case .respring: self.viewModel.respring()
					case .safeMode: self.viewModel.safeMode()
					case .userspaceReboot: self.viewModel.userspaceReboot()
					case .reboot: self.viewModel.reboot()
					case .shutdown: self.viewModel.shutdown()
					}
				},
				secondaryButton: .cancel()
			)
		}
	}
}

// Using .foregroundColor instead of .foregroundStyle for compatibility with iOS 13 and 14
private struct PowerSettingsButton: View {
    let title: String
    let subtitle: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading) {
                    Text(title)
                        .foregroundColor(Color(.label))
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(Color(.secondaryLabel))
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(Color(.tertiaryLabel))
            }
            .padding(5)
        }
    }
}
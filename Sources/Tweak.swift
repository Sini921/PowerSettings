//
// Copyright (c) Nightwind 2025
//

import UIKit
import SwiftUI
import CydiaSubstrate

private struct Hooks {
	private static let targetClass: AnyClass = {
		if #available(iOS 18, *) {
			// SwiftUI.NavigationStackHostingController<SwiftUI.AnyView>
			return objc_getClass("_TtGC7SwiftUI32NavigationStackHostingControllerVS_7AnyView_") as! AnyClass
		} else {
			return objc_getClass("PSUIPrefsListController") as! AnyClass
		}
	}()

    fileprivate static func hook() {
        var origIMP: IMP?
        let hook: @convention(block) (UIViewController, Selector) -> Void = { target, selector in
			let orig = unsafeBitCast(origIMP, to: (@convention(c) (UIViewController, Selector) -> Void).self)
			orig(target, selector)

			initTopMenu(target)
        }

        MSHookMessageEx(targetClass, sel_getUid("viewDidLoad"), imp_implementationWithBlock(hook), &origIMP)
    }

	fileprivate static func addHandler() {
		let implementation: @convention(block) (UIViewController, Selector, UIBarButtonItem) -> Void = { target, selector, sender in
			let controller = UIHostingController(rootView: PowerSettingsView())
			target.present(controller, animated: true)
		}
		class_addMethod(targetClass, sel_getUid("_ps_handleButtonClick:"), imp_implementationWithBlock(implementation), "v@:@")
	}

	private static func initTopMenu(_ target: UIViewController) {
		guard let gearImage = UIImage(systemName: "gear")?.withRenderingMode(.alwaysTemplate) else { return }
		let topMenuButton = UIBarButtonItem(image: gearImage, style: .plain, target: target, action: sel_getUid("_ps_handleButtonClick:"))
		target.navigationItem.rightBarButtonItem = topMenuButton
	}
}

@_cdecl("swift_init")
func tweakInit() {
	Hooks.hook()
	Hooks.addHandler()
}
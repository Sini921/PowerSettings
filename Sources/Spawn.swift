//
// Copyright (c) 2025 Nightwind
//

import Darwin.POSIX
import Foundation

internal struct Spawn {
	static func run(path: String, args: [String]) {
		let cPath = (path as NSString).fileSystemRepresentation

		let cArgs = args.map {
			UnsafeMutablePointer(mutating: ($0 as NSString).utf8String!)
		} + [nil]

		cArgs.withUnsafeBufferPointer { unsafeCArgs in
			var pid: pid_t = 0
			posix_spawn(&pid, cPath, nil, nil, unsafeCArgs.baseAddress, nil)
		}
	}
}
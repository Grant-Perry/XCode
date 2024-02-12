//   ViewExt.swift
//   BigPoly
//
//   Created by: Grant Perry on 2/11/24 at 1:18 AM
//     Modified: 
//
//  Copyright © 2024 Delicious Studios, LLC. - Grant Perry
//

import SwiftUI

extension View {
	func horizontallyCentered() -> some View {
		HStack {
			Spacer(minLength: 0)
			self
			Spacer(minLength: 0)
		}
	}

	func leftJustify() -> some View {
		HStack {
			self
			Spacer(minLength: 0)
		}
	}

	func rightJustify() -> some View {
		HStack {
			Spacer(minLength: 10)
			self
		}
	}
}

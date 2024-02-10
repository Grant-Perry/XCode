//   CLLArrayExt.swift
//   BigPoly
//
//   Created by: Grant Perry on 2/10/24 at 11:15 AM
//     Modified: 
//
//  Copyright © 2024 Delicious Studios, LLC. - Grant Perry
//

import SwiftUI
import CoreLocation

extension Array where Element == CLLocation {
	var calcDistance: Double {
		print("CLLocation.distance count = \(count)")
		guard count > 1 else { return 0 }
		var mapDistance = Double.zero

		for i in 0..<count-1 {
			let location = self[i]
			let nextLocation = self[i+1]
			mapDistance += nextLocation.distance(from: location)
		}
		return mapDistance / 1609.344
	}

	var elevation: Double {
		guard count > 1 else { return 0 }
		var mapElevation = Double.zero

		for i in 0..<count-1 {
			let location = self[i]
			let nextLocation = self[i+1]
			let delta = nextLocation.altitude - location.altitude
			if delta > 0 {
				mapElevation += delta
			}
		}
		return mapElevation
	}
}

extension CLLocationCoordinate2D {
	var location: CLLocation {
		CLLocation(latitude: latitude, longitude: longitude)
	}
}

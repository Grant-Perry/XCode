//   WorkoutData.swift
//   BigPoly
//
//   Created by: Grant Perry on 2/17/24 at 2:42 PM
//     Modified: 
//
//  Copyright © 2024 Delicious Studios, LLC. - Grant Perry
//

import SwiftUI
import HealthKit
import CoreLocation
import MapKit

struct WorkoutData {
	let id = UUID()
	let workout: HKWorkout
	let workoutDate: Date
	var workoutDistance: Double
	var workoutAddress: Address?
	var workoutCoords: [CLLocationCoordinate2D]?
	var workoutPoly: MKPolyline?
}


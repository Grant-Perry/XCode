//   WorkoutCore.swift
//   BigPoly
//
//   Created by: Grant Perry on 2/8/24 at 9:58 AM
//     Modified:
//
//  Copyright © 2024 Delicious Studios, LLC. - Grant Perry
//

import SwiftUI
import HealthKit
import CoreLocation
import Observation

@Observable
class WorkoutCore {
	static let shared = WorkoutCore()
	private let healthStore = HKHealthStore()

	private init() {}

	// Requests permission to access HealthKit data.
	func requestHealthKitPermission() async throws {
		let typesToRead: Set<HKObjectType> = [
			HKObjectType.workoutType(),
			HKSeriesType.workoutRoute()
		]

		try await healthStore.requestAuthorization(toShare: [], read: typesToRead)
	}

	// Fetches the last specified number of workouts.
	func fetchLastWorkouts(limit: Int) async throws -> [HKWorkout] {
		let predicate = HKQuery.predicateForWorkouts(with: .walking)
		let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)

		return try await withCheckedThrowingContinuation { continuation in
			let query = HKSampleQuery(sampleType: HKObjectType.workoutType(), 
											  predicate: predicate,
											  limit: limit, 
											  sortDescriptors: [sortDescriptor]) { _, result, error in
				if let error = error {
					continuation.resume(throwing: error)
				} else if let workouts = result as? [HKWorkout] {
					continuation.resume(returning: workouts)
				} else {
					continuation.resume(returning: [])
				}
			}
			self.healthStore.execute(query)
		}
	}

	// Fetches route data for a given workout and returns the coordinates.
	func fetchRouteData(for workout: HKWorkout) async throws -> [CLLocationCoordinate2D] {
		// Directly use HKSeriesType.workoutRoute() since it's non-optional
		let routeType = HKSeriesType.workoutRoute()

		// Fetch routes
		let routes: [HKWorkoutRoute] = try await withCheckedThrowingContinuation { continuation in
			let predicate = HKQuery.predicateForObjects(from: workout)
			let query = HKSampleQuery(sampleType: routeType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, error in
				if let error = error {
					continuation.resume(throwing: error)
				} else if let routes = samples as? [HKWorkoutRoute] {
					continuation.resume(returning: routes)
				} else {
					// It's crucial to resume the continuation even if no routes are found to avoid hanging.
					continuation.resume(returning: [])
				}
			}
			self.healthStore.execute(query)
		}

		// Ensure there's at least one route to process
		guard let firstRoute = routes.first else {
			return []
		}

		// Proceed to fetch and process coordinates from the first route
		return try await fetchCoordinates(for: firstRoute)
	}

	// Helper function to fetch coordinates for a route.
	private func fetchCoordinates(for route: HKWorkoutRoute) async throws -> [CLLocationCoordinate2D] {
		try await withCheckedThrowingContinuation { continuation in
			var coordinates: [CLLocationCoordinate2D] = []

			let query = HKWorkoutRouteQuery(route: route) { _, returnedLocations, done, errorOrNil in
				if let error = errorOrNil {
					continuation.resume(throwing: error)
					return
				}

				if let locations = returnedLocations {
					coordinates.append(contentsOf: locations.map { $0.coordinate })
				}

				if done {
					continuation.resume(returning: coordinates)
				}
			}

			healthStore.execute(query)
		}
	}
	

//	public func getWorkoutDistance(_ thisWorkout: HKWorkout) async throws -> Double {
//		guard let route = await getWorkoutRoute(workout: thisWorkout)?.first else {
//			return 0
//		}
//		// get the coordinates of the last workout
//		let coords = await getCLocationDataForRoute(routeToExtract: route)
//		var longitude = coords.last?.coordinate.longitude
//		var latitude = coords.last?.coordinate.latitude
//		return coords.calcDistance
//		//		return await getCLocationDataForRoute(routeToExtract: route).calcDistance
//	}

}


//	func requestHealthKitPermission(completion: @escaping (Bool, Error?) -> Void) {
//		guard HKHealthStore.isHealthDataAvailable() else {
//			completion(false, nil) // Health data not available on device
//			return
//		}
//
//		let healthStore = HKHealthStore()
//		let typesToRead: Set<HKObjectType> = [
//			HKObjectType.workoutType() // Add other types as needed
//		]
//
//		// No types to write in this case, adjust as necessary
//		healthStore.requestAuthorization(toShare: [], read: typesToRead) { (success, error) in
//			completion(success, error)
//		}
//	}
//}

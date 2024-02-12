//   polyView.swift
//   BigPoly
//
//   Created by: Grant Perry on 2/8/24 at 9:26 AM
//     Modified:
//
//  Copyright © 2024 Delicious Studios, LLC. - Grant Perry
//

import SwiftUI
import HealthKit

struct PolyView: View {
	@State private var workouts: [HKWorkout] = []
	@State private var isLoading = true

	var body: some View {
		NavigationView {
			if isLoading {
				ProgressView("Loading Workouts...")
			} else {
				List(workouts, id: \.uuid) { workout in
					NavigationLink(destination: FullMapView(workout: workout)) {
						WorkoutRouteView(workout: workout)
						Text("\(workout.startDate, style: .date)")
					}
				}
				.navigationTitle("Workouts")
			}
		}
		.onAppear {
			Task {
				await loadWorkouts()
			}
		}
	}

	private func loadWorkouts() async {
		do {
			try await WorkoutCore.shared.requestHealthKitPermission()
			workouts = try await WorkoutCore.shared.fetchLastWorkouts(limit: 100)
			isLoading = false
		} catch {
			print("Error loading workouts: \(error)")
			isLoading = false
		}
	}
}






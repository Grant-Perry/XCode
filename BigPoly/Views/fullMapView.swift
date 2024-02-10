//   fullMapView.swift
//   BigPoly
//
//   Created by: Grant Perry on 2/8/24 at 9:56 AM
//     Modified: 
//
//  Copyright © 2024 Delicious Studios, LLC. - Grant Perry
//

import SwiftUI
import MapKit
import HealthKit


struct FullMapView: View {
	let workout: HKWorkout
	@State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
	@State private var identifiableRouteCoordinates: [IdentifiableCoordinate] = [] // Updated to use IdentifiableCoordinate
	@State private var isLoading = true

	let gradient = LinearGradient(
		colors: [.red, .green, .blue],
		startPoint: .leading, endPoint: .trailing)
	let stroke = StrokeStyle(
		lineWidth: 5,
		lineCap: .round, lineJoin: .round, dash: [10, 10])

	var body: some View {
		Map(coordinateRegion: $region,
			 showsUserLocation: true,
			 annotationItems: identifiableRouteCoordinates) { identifiableCoord in

			MapPin(coordinate: identifiableCoord.coordinate, tint: .blue)
		}
		.onAppear {
			Task {
				await loadRouteData()
			}
		}
	}

	private func loadRouteData() async {
		do {
			let coordinates = try await WorkoutCore.shared.fetchRouteData(for: workout)
			if !coordinates.isEmpty {
				// Wrap each CLLocationCoordinate2D in IdentifiableCoordinate
				identifiableRouteCoordinates = coordinates.map { IdentifiableCoordinate(coordinate: $0) }
				region.center = coordinates.first ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
			}
			isLoading = false
		} catch {
			print("Error fetching route data: \(error)")
			isLoading = false
		}
	}
}

//struct MapPolylineOverlay: View {
//	var polyline: MKPolyline
//
//	var body: some View {
//		// Custom view to represent the polyline if necessary.
//	}
//}


// Assuming you have a MapView that can take coordinates.
//struct MapView: View {
//	var coordinates: [CLLocationCoordinate2D]
//
//	var body: some View {
//		// Your implementation to display the map and polyline
//		Text("Map Placeholder")
//	}
//}


//struct FullMapView: View {
//	var workoutRoute: HKWorkoutRoute
//	@State private var region = MKCoordinateRegion()
//	@State private var polyline = MKPolyline()
//
//	var body: some View {
//		Map(coordinateRegion: $region, showsUserLocation: false, userTrackingMode: nil, annotationItems: [polyline]) { item in
//			MapOverlay(coordinate: item.coordinate, anchorPoint: CGPoint(x: 0.5, y: 0.5))
//		}
//		.onAppear {
//			Task {
//				await loadRouteData()
//			}
//		}
//		.edgesIgnoringSafeArea(.all)
//		.navigationTitle("Workout Route")
//	}
//
//	private func loadRouteData() async {
//		let locations = await WorkoutCore.shared.getCLocationDataForRoute(routeToExtract: workoutRoute)
//		updateMapRegionAndPolyline(with: locations)
//	}
//
//	private func updateMapRegionAndPolyline(with locations: [CLLocation]) {
//		guard !locations.isEmpty else { return }
//
//		let coordinates = locations.map { $0.coordinate }
//		self.polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
//
//		let region = MKCoordinateRegion(center: coordinates.first!, latitudinalMeters: 5000, longitudinalMeters: 5000)
//		self.region = region
//	}
//}

// Define MapOverlay if needed or use existing Map annotations/overlays as per your app's design.


//		Map {
//			MapPolyline (coordinates: identifiableRouteCoordinates.coordinate)
//				.stroke(gradient, style: stroke)
//		}

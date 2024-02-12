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
	@State private var holdCoords: [CLLocationCoordinate2D] = []
	@State private var isLoading = true
	@State var poly: MKPolyline = MKPolyline(coordinates: [], count: 0)
	@State var startWorkout = CLLocationCoordinate2D(latitude: 37.000914, longitude: -76.442160)
	@State var endWorkout = CLLocationCoordinate2D(latitude: 37.000914, longitude: -76.2442360)
	var position: MapCameraPosition = .automatic
//	var searchResults: [MKMapItem]
//	var visibleRegion: MKCoordinateRegion?


	let gradient = LinearGradient(
		colors: [.gpPink, .gpGreen, .gpBlue],
		startPoint: .leading,
		endPoint: .trailing)
	
	let stroke = StrokeStyle(
		lineWidth: 4,
		lineCap: .round,
		lineJoin: .round,
		dash: [15, 10])

	var body: some View {


		Map {
			MapPolyline(coordinates: holdCoords)
				.stroke(gradient,
						  style: stroke)

			Annotation(
				"Start",
				coordinate: startWorkout,
				anchor: .bottom
			) {
				Image(systemName: "figure.walk.departure")
					.imageScale(.small)
					.padding(4)
					.foregroundStyle(.white)
					.background(Color.gpGreen)
					.cornerRadius(4)
			}
		
			Annotation(
				"End",
				coordinate: endWorkout,
				anchor: .bottom
			) {
				Image(systemName: "figure.walk.arrival")
					.imageScale(.small)
					.padding(4)
					.foregroundStyle(.white)
					.background(Color.gpRed)
					.cornerRadius(4)
			}
			
//			Marker("Start", coordinate: startWorkout)
//			Marker("End", coordinate: endWorkout)
		}

		.onAppear {
			Task {
				await loadRouteData()
			}
		}
		.mapStyle(.imagery(elevation: .realistic))
		.background(.clear)

	}

	private func loadRouteData() async {
		do {
			let coordinates = try await WorkoutCore.shared.fetchRouteData(for: workout)
			if !coordinates.isEmpty {
				// Wrap each CLLocationCoordinate2D in IdentifiableCoordinate
				holdCoords = coordinates
				poly = MKPolyline(coordinates: coordinates, count: coordinates.count)
				startWorkout = coordinates.first!
				endWorkout = coordinates.last!
//				print("poly = \(poly)\ncoordinates = \(coordinates)")
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

//   THIS WORKS -
//		Map(coordinateRegion: $region,
//			 showsUserLocation: true,
//			 annotationItems: identifiableRouteCoordinates) { identifiableCoord in
//
//			MapPin(coordinate: identifiableCoord.coordinate, tint: .blue)
//		}
//		.onAppear {
//			Task {
//				await loadRouteData()
//			}
//		}

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

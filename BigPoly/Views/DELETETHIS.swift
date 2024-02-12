//   DELETETHIS.swift
//   BigPoly
//
//   Created by: Grant Perry on 2/12/24 at 12:31 PM
//     Modified:
//
//  Copyright © 2024 Delicious Studios, LLC. - Grant Perry
//

import SwiftUI
import MapKit

struct DeleteThis: View {
	@State var home = CLLocationCoordinate2D(latitude: 37.000914, longitude: -76.442160)
	@State private var position: MapCameraPosition = .automatic

	var body: some View {
		VStack(alignment: .leading) { // Align VStack to leading
			HStack(spacing: 15) {
				// MARK: - Address Container
				VStack {
					Spacer()
					Text("Newport News")
						.font(.system(size: 20)).bold()
						.foregroundColor(.white)
						.padding(.leading)
						.leftJustify()
					VStack(alignment: .leading, spacing: 1) {
						Text("5912 Huntington Ave.")
						Text(Date(), style: .date)
						Text("2.3")
							.rightJustify()
							.padding(.trailing)
							.font(.system(size: 14).bold())
						Text("miles")
							.rightJustify()
							.padding(.trailing)
							.font(.system(size: 8))
					}
					.font(.system(size: 12))
					.foregroundColor(.white)
					.padding(.leading, 25) // indent the text
					.leftJustify()
					Spacer()
				}
//				.frame(width: 200, height: 100)
				.frame(width: UIScreen.main.bounds.width * 0.5, height: 100)
				.background(Color.blue.gradient)
				.cornerRadius(10)
				.leftJustify()

				// MARK: - Map View
//				HStack {
					Map(position: $position) {

						Marker("Route Start", coordinate: home)

					}
					.mapControlVisibility(.hidden)
					.mapStyle(.hybrid(elevation: .realistic ))
					.disabled(true)
					.frame(width: UIScreen.main.bounds.width * 0.35, height: .infinity)
					.cornerRadius(10)
					.padding(.leading, -25)
//				}
			}
			.frame(width: UIScreen.main.bounds.width * 0.75, height: 100)
//			.padding()
		}
	}
}


#Preview {
	DeleteThis()
}

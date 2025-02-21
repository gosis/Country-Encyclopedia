import SwiftUI
import MapKit

struct MapView: View {
    let latitude: Double
    let longitude: Double
    let placeName: String

    @State private var cameraPosition: MapCameraPosition = .automatic

    var body: some View {
        Map(position: $cameraPosition) {
            Marker(placeName, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        }
        .mapControls {
            MapUserLocationButton()
        }
        .ignoresSafeArea()
        .onAppear {
            updateCameraPosition()
        }
        .onChange(of: latitude, { _, _ in
            updateCameraPosition()
        })
        .onChange(of: longitude) { _, _ in
            updateCameraPosition()
        }
    }

    private func updateCameraPosition() {
        DispatchQueue.main.async {
            cameraPosition = .region(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                    span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
                )
            )
        }
    }
}

#Preview {
    MapView(latitude: 56, longitude: 54, placeName: "Riga")
}

//
//  MainScreenView.swift
//  LIMS-chaitanya
//
//  Created by Chaitanya Makkapati on 12/9/24.
//

import SwiftUI
import MapKit

struct MainScreenView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 42.6526, longitude: -73.7562),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    @State private var searchQuery: String = ""
    @State private var selectedFilter: String = "Versa"
    @State private var selectedCounty: String? = nil
    @State private var bottomSheetHeight: CGFloat = UIScreen.main.bounds.height * 0.4
    
    @State private var currentTextIndex: Int = 0
    private let placeholderTexts = ["Search by city", "Search by parent company", "Search by trade name", "Search by establishment#"]
    private let filters = ["Versa", "Non-Versa"]
    private let counties = ["Albany", "Syracuse", "Buffalo", "Rochester", "NYC", "Yonkers"]
    
    struct Establishment: Identifiable {
        let id = UUID()
        let name: String
        let number: String
        let address: String
        let latitude: Double
        let longitude: Double
    }
    
    @State private var establishments = [
        Establishment(name: "SH FOODS LLC", number: "361350", address: "346 SOUTH MAIN STREET, PERRY, NY 14530", latitude: 42.7136, longitude: -78.0031),
        Establishment(name: "1667 GENERAL STORE", number: "351345", address: "1667 WESTERN AVENUE, ALBANY, NY 12203", latitude: 42.6895, longitude: -73.8500),
        Establishment(name: "PARKS CUSTARD & CANDY INC", number: "123459", address: "123 MAIN STREET, SYRACUSE, NY 13210", latitude: 43.0481, longitude: -76.1474),
        Establishment(name: "1667 GENERAL STORE", number: "351346", address: "1667 WESTERN AVENUE, ALBANY, NY 12203", latitude: 42.6895, longitude: -73.8500),
        Establishment(name: "CUSTARD & CANDY INC", number: "123479", address: "123 MAIN STREET, SYRACUSE, NY 13210", latitude: 43.0481, longitude: -76.1474)
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Fullscreen Map
                Map(coordinateRegion: $region, annotationItems: establishments) { establishment in
                    MapAnnotation(coordinate: region.center) {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.orange)
                            .font(.title)
                            .accessibilityLabel("Map pin for \(establishment.name)")
                    }
                }
                .edgesIgnoringSafeArea(.all)
                .accessibilityElement()
                .accessibilityLabel("Interactive map showing establishments.")
                
                // Drag-Up Filter & Results Section
                GeometryReader { geometry in
                    VStack(spacing: 8) {
                        // Drag handle
                        Capsule()
                            .frame(width: 40, height: 6)
                            .foregroundColor(.gray)
                            .padding(.top, 8)
                        
                        // Search Bar with Animation
                        ZStack(alignment: .leading) {
                            if searchQuery.isEmpty {
                                Text(placeholderTexts[currentTextIndex])
                                    .foregroundColor(.gray)
                                    .padding(.leading, 35) // Adjust padding for icon placement
                                    .transition(.opacity)
                                    .animation(.easeInOut, value: currentTextIndex)
                            }
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                    .padding(.leading, 8)
                                
                                TextField("", text: $searchQuery)
                                    .padding(.vertical, 8)
                                    .padding(.leading, 4)
                                
                                Spacer()
                                
                                Image(systemName: "mic.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                        .onAppear {
                            Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
                                withAnimation {
                                    currentTextIndex = (currentTextIndex + 1) % placeholderTexts.count
                                }
                            }
                        }
                        .frame(height: 40)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .padding(.horizontal)
                        
                        // Horizontal Dragable Filters and Buttons
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(filters, id: \.self) { filter in
                                    Button(action: {
                                        selectedFilter = filter
                                    }) {
                                        HStack {
                                            Image(systemName: "building.columns")
                                            
                                            Text(filter)
                                        }
                                        .fontWeight(.bold)
                                        .padding()
                                        .background(Color.gray.opacity(0.2))
                                        .foregroundColor(.black)
                                        .cornerRadius(10)
                                        
                                    }
                                }
                                
                                // Dropdown for County
                                Menu {
                                    ForEach(counties, id: \.self) { county in
                                        Button(action: {
                                            selectedCounty = county
                                        }) {
                                            Text(county)
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Image(systemName: "map.fill")
                                        
                                        Text(selectedCounty ?? "County")}
                                    .fontWeight(.bold)
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .foregroundColor(.black)
                                    .cornerRadius(10)
                                }
                                
                                // Sync Button
                                Button(action: {
                                    // Sync action
                                    print("Syncing data...")
                                }) {
                                    Text("Sync")
                                        .fontWeight(.bold)
                                        .padding()
                                        .background(Color.gray.opacity(0.2))
                                        .foregroundColor(.black)
                                        .cornerRadius(10)
                                }
                                
                                // New Button
                                Button(action: {
                                    // New action
                                    print("Creating new...")
                                }) {
                                    Text("New")
                                        .fontWeight(.bold)
                                        .padding()
                                        .background(Color.gray.opacity(0.2))
                                        .foregroundColor(.black)
                                        .cornerRadius(10)
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // Scrollable Results
                        ScrollView {
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(establishments.filter {
                                    searchQuery.isEmpty || $0.name.localizedCaseInsensitiveContains(searchQuery)
                                }) { establishment in
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(establishment.name)
                                            .font(.headline)
                                            .accessibilityLabel("Establishment name: \(establishment.name)")
                                        
                                        Text("Number: \(establishment.number)")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                            .accessibilityLabel("Establishment number: \(establishment.number)")
                                        
                                        Text(establishment.address)
                                            .font(.footnote)
                                            .foregroundColor(.secondary)
                                            .accessibilityLabel("Address: \(establishment.address)")
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    .shadow(radius: 2)
                                    .accessibilityElement()
                                }
                            }
                            .padding(.horizontal)
                        }
                        .frame(maxHeight: geometry.size.height * 0.8) // Dynamic height for ScrollView
                    }
                    .background(Color(.systemGroupedBackground)) // Light gray background
                    .cornerRadius(16)
                    .frame(width: geometry.size.width, height: bottomSheetHeight) // Ensure it fills the bottom
                    .offset(y: geometry.size.height - bottomSheetHeight)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let newHeight = bottomSheetHeight - value.translation.height
                                if newHeight > geometry.size.height * 0.4 && newHeight < geometry.size.height * 0.85 {
                                    bottomSheetHeight = newHeight
                                }
                            }
                            .onEnded { value in
                                let midpoint = geometry.size.height * 0.6
                                if bottomSheetHeight > midpoint {
                                    bottomSheetHeight = geometry.size.height * 0.85 // Snap to expanded
                                } else {
                                    bottomSheetHeight = geometry.size.height * 0.4 // Snap to collapsed
                                }
                            }
                    )
                }
                .edgesIgnoringSafeArea(.bottom)
            }.toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
}

#Preview {
    MainScreenView()
}



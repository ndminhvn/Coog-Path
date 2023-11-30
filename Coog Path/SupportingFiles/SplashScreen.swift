//
//  SplashScreen.swift
//  Coog Path
//
//  Created by Minh Nguyen on 11/29/23.
//

import SwiftData
import SwiftUI

struct SplashScreen: View {
    @Environment(\.modelContext) private var modelContext
    // isActive is used to trigger ContentView
    @State private var isActive = false
    // needSamples is used to trigger generateSample function
    // default to Yes for demo purpose
    @State private var needSamples = true
    // progress is used to calculate the progress view
    @State private var progress = 0.2
    // isBtnClicked is used to trigger the click of Launch button
    @State private var isBtnClicked = false
    // queries data used to generate samples
    @Query var profiles: [Profile]
    @Query var courses: [Course]
    @Query var buildings: [Building]

    private func generateSamples() {
        if profiles.isEmpty {
            modelContext.insert(Profile(name: "Guest User"))
        }
        if needSamples {
            // add sample courses
            let course1 = Course(name: "COSC 4355", roomNumber: "HBS 315", building: "HBS", room: "315", date1: "Thursday", timeFrom: "4:00PM", timeTo: "7:00PM")
            let course2 = Course(name: "COSC 4353", roomNumber: "PGH 561", building: "PGH", room: "561", date1: "Tuesday", date2: "Thursday", timeFrom: "2:30PM", timeTo: "4:00PM")
            let course3 = Course(name: "COSC 4377", roomNumber: "SR 17", building: "SR", room: "17", date1: "Monday", date2: "Wednesday", timeFrom: "4:00PM", timeTo: "5:30PM")
            let course4 = Course(name: "COSC 3337", roomNumber: "PGH 232", building: "PGH", room: "232", date1: "Monday", date2: "Wednesday", timeFrom: "1:00PM", timeTo: "2:30PM")
            let course5 = Course(name: "MATH 4322", roomNumber: "SEC 104", building: "SEC", room: "104", date1: "Tuesday", date2: "Thursday", timeFrom: "11:30AM", timeTo: "1:00PM")
            modelContext.insert(course1)
            modelContext.insert(course2)
            modelContext.insert(course3)
            modelContext.insert(course4)
            modelContext.insert(course5)

            // add sample favorited buildings with corresponding courses
            if let building1 = buildings.first(where: { $0.Abbr == "HBS" }) {
                building1.isFavorited = true
                building1.courses?.append(course1)
            }
            if let building2 = buildings.first(where: { $0.Abbr == "PGH" }) {
                building2.isFavorited = true
                building2.courses?.append(course2)
            }
            if let building3 = buildings.first(where: { $0.Abbr == "SR" }) {
                building3.isFavorited = true
                building3.courses?.append(course3)
            }
            if let building4 = buildings.first(where: { $0.Abbr == "PGH" }) {
                building4.isFavorited = true
                building4.courses?.append(course4)
            }
            if let building5 = buildings.first(where: { $0.Abbr == "SEC" }) {
                building5.isFavorited = true
                building5.courses?.append(course5)
            }
        }
    }

    var body: some View {
        if isActive {
            ContentView()
        } else {
            VStack {
                // show generate sample option only on the first launch
                if courses.isEmpty && profiles.isEmpty {
                    Spacer()
                    Text("Welcome to Coog Path!")
                        .font(.title)
                        .bold()
                        .foregroundStyle(Color.main)
                    Spacer()
                    Image("uh_red")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .opacity(0.8)
                    Spacer()
                    Text("Do you want to generate some sample cases?")
                        .fontWeight(.semibold)
                    Picker("Do you want to include some sample cases?", selection: $needSamples) {
                        Text("Yes, give me some.").tag(true)
                        Text("No, I want a fresh app.").tag(false)
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    Spacer()
                    Spacer()
                    Button(action: {
                        isBtnClicked.toggle()
                        generateSamples()
                    }, label: {
                        Text("Launch Coog Path!")
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundStyle(Color.main)
                    })
                    // show loading sign after click on Launch button
                    if isBtnClicked {
                        ProgressView(value: progress, total: 1.0)
                            .progressViewStyle(GaugeProgressStyle())
                            .frame(width: 150, height: 150)
                            .contentShape(Rectangle())
                            .ignoresSafeArea()
                            .onAppear {
                                // run a full circle before navigating to Home Screen
                                Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
                                    if progress < 1.1 {
                                        withAnimation {
                                            progress += 0.2
                                        }
                                    } else {
                                        // navigate to Home Screen
                                        timer.invalidate()
                                        isActive = true
                                    }
                                }
                            }
                    }

                    Spacer()
                } else {
                    // the splash screen on non-first launches
                    ProgressView(value: progress, total: 1.0)
                        .progressViewStyle(GaugeProgressStyle())
                        .frame(width: 150, height: 150)
                        .contentShape(Rectangle())
                        .onAppear {
                            // run a full circle before navigating to Home Screen
                            Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
                                if progress < 1.1 {
                                    withAnimation {
                                        progress += 0.2
                                    }
                                } else {
                                    // navigate to Home Screen
                                    timer.invalidate()
                                    isActive = true
                                }
                            }
                        }
                }
            }
        }
    }
}

struct GaugeProgressStyle: ProgressViewStyle {
    var strokeColor = Color.main
    var strokeWidth = 15.0

    func makeBody(configuration: Configuration) -> some View {
        let completed = configuration.fractionCompleted ?? 0

        return ZStack {
            Circle()
                .trim(from: 0, to: completed)
                .stroke(strokeColor, style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
    }
}

#Preview {
    SplashScreen()
        .modelContainer(for: [Profile.self, Course.self, Building.self])
}

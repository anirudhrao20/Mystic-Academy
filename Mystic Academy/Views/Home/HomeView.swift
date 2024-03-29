//
//  HomeView.swift
//  Mystic Academy
//
//  Created by Anirudh Rao on 3/5/23.
//

import SwiftUI
import FirebaseFirestoreSwift

struct HomeView: View {
    
    @EnvironmentObject var loginManager: SessionStore
    
    @FirestoreQuery(collectionPath: "Courses") var courses: [Course]
    @FirestoreQuery(collectionPath: "Categories") var categories: [Category]
    
    @State var hasNotification = false
    @State var selectedlearningTrack = ""
    @State var showTrackSelectionSheet = false
    
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    
                    header
                    
                    if selectedlearningTrack.isEmpty {
                        VStack(spacing: 24.0) {
                            trackSelector
                            
                            categorySelector
                            
                            recommendedList
                            
                            popularList
                        }
                    } else {
                        VStack(spacing: 24.0) {
                            trackSelector
                            
                            trackBody
                        }
                    }
                }
                .padding(.horizontal, 24.0)
            }
        }
        .sheet(isPresented: $showTrackSelectionSheet) {
            TrackSelectionSheet(selectedlearningTrack: $selectedlearningTrack)
                .presentationDetents([.medium, .large])
        }
    }
    
    var header: some View {
        HStack(spacing: 8.0) {
            AsyncImage(url: URL(string: "https://firebasestorage.googleapis.com/v0/b/mystic-academy-20355.appspot.com/o/defaultprofilepicture.jpg?alt=media&token=36564139-10fd-444f-9dc2-8e75772e550e")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 48.0, height: 48.0)
                    .clipShape(Circle())
            } placeholder: {
                ProgressView()
            }
            VStack(alignment: .leading) {
                Text("Welcome Back!")
                    .font(.callout)
                    .fontWeight(.medium)
                Text("Anirudh Rao")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            Spacer()
            if hasNotification {
                Image(systemName: "bell.badge.fill")
                    .symbolRenderingMode(.multicolor)
                    .foregroundStyle(Color.red)
                    .font(.title2)
                    .padding(8.0)
                    .background(Color("Card Background"))
                    .cornerRadius(8.0)
            } else {
                Image(systemName: "bell.fill")
                    .font(.title2)
                    .padding(8.0)
                    .background(Color("Card Background"))
                    .cornerRadius(8.0)
            }
        }
    }
    
    var trackSelector: some View {
        ZStack {
            Image("Banner")
                .resizable()
                .aspectRatio(contentMode: .fit)
            Button {
                showTrackSelectionSheet.toggle()
            } label: {
                HStack {
                    Text(selectedlearningTrack.isEmpty ? "Choose a Learning Track" : selectedlearningTrack)
                    Spacer()
                    Image(systemName: "chevron.down")
                }
            }
            .fontWeight(.semibold)
            .foregroundColor(Color("Neutral-3"))
            .padding(.vertical, 12)
            .padding(.horizontal, 24)
            .background(Color("Card Background"))
            .cornerRadius(100)
            .padding(.horizontal, 16)
            .offset(y: 50)
        }
    }
    
    var categorySelector: some View {
        VStack(alignment: .leading, spacing: 16.0) {
            HStack {
                Text("Categories")
                    .fontWeight(.bold)
                Spacer()
                NavigationLink(destination: CategoriesView()) {
                    Text("See all")
                        .fontWeight(.bold)
                }
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12.0) {
                    ForEach(categories) { category in
                        CategoryItem(category: category)
                    }
                }
            }
        }
    }
    
    var recommendedList: some View {
        VStack(alignment: .leading, spacing: 16.0) {
            HStack {
                Text("Recommended Courses")
                    .fontWeight(.bold)
                Spacer()
                Button {
                    
                } label: {
                    Text("See all")
                        .fontWeight(.bold)
                }
                
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12.0) {
                    ForEach(courses.prefix(5)) { course in
                        NavigationLink(destination: CourseView(course: course)) {
                            CourseItem(course: course)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
    
    var popularList: some View {
        VStack(alignment: .leading, spacing: 16.0) {
            HStack {
                Text("Popular Courses")
                    .fontWeight(.bold)
                Spacer()
                Button {
                    
                } label: {
                    Text("See all")
                        .fontWeight(.bold)
                }
                
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12.0) {
                    ForEach(sortPopularCourses().prefix(5)) { course in
                        CourseItem(course: course)
                    }
                }
            }
        }
    }
    
    var trackBody: some View {
        VStack(alignment: .leading, spacing: 32.0) {
            VStack(alignment: .leading, spacing: 16.0) {
                Text("Foundation")
                    .fontWeight(.bold)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12.0) {
                        ForEach(sortPopularCourses()) { course in
                            CourseItem(course: course)
                        }
                    }
                }
            }
            VStack(alignment: .leading, spacing: 16.0) {
                Text("Beginner")
                    .fontWeight(.bold)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12.0) {
                        ForEach(sortPopularCourses()) { course in
                            CourseItem(course: course)
                        }
                    }
                }
            }
            VStack(alignment: .leading, spacing: 16.0) {
                Text("Intermediate")
                    .fontWeight(.bold)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12.0) {
                        ForEach(sortPopularCourses()) { course in
                            CourseItem(course: course)
                        }
                    }
                }
            }
            VStack(alignment: .leading, spacing: 16.0) {
                Text("Advanced")
                    .fontWeight(.bold)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12.0) {
                        ForEach(sortPopularCourses()) { course in
                            CourseItem(course: course)
                        }
                    }
                }
            }
        }
    }
    
    func sortPopularCourses() -> [Course] {
        return testCourses.sorted(by: { $0.numberOfStudents > $1.numberOfStudents })
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(SessionStore())
    }
}

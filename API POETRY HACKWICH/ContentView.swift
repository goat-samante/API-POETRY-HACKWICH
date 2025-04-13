//
//  ContentView.swift
//  API POETRY HACKWICH
//
//  Created by Samuel Amante on 4/13/25.
//

import SwiftUI

struct ContentView: View {
    @State private var authors = [String]()
    var body: some View {
        NavigationView {
            List(authors, id: \.self) { author in
                NavigationLink(destination: Text(author)) {
                    Text(author)
                }
            }
            .navigationTitle("Poetry Authors")
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            await getAuthors()  
        }
    }
    func getAuthors() async {
           let query = "https://poetrydb.org//author"
           if let url = URL(string: query) {
               if let (data, _) = try? await URLSession.shared.data(from: url) {
                   if let decodedResponse = try? JSONDecoder().decode(Authors.self, from: data) {
                       authors = decodedResponse.authors
                   }
               }
           }
       }
}
struct Authors: Codable {
    var authors: [String]
}

#Preview {
    ContentView()
}

//
//  PoemsView.swift
//  API POETRY HACKWICH
//
//  Created by Samuel Amante on 4/13/25.
//

import SwiftUI

struct PoemsView: View {
    
    @State private var poems = [Poem]()
    @State private var showingAlert = false
    let author: String
    
    var body: some View {
        List(poems) { poem in
            NavigationLink {
                ScrollView {
                    VStack {
                        Text(poem.title)
                            .font(.headline)
                        Text("by \(author)").padding(.bottom)
                        ForEach(poem.lines, id: \.self) { line in
                            Text(line)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                }
            } label: {
                Text(poem.title)
            }
        }
        .navigationTitle("Poems by " + author)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await getPoems()
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Loading Error"),
                  message: Text("There was a problem loading the poetry authors"),
                  dismissButton: .default(Text("Ok")))
        }
    }
}
func getPoems() async {
    let query = "https://poetrydb.org/author/" + author + "/title,lines"
    if let url = URL(string: query) {
        if let (data, _) = try? await URLSession.shared.data(from: url) {
            if let decodedResponse = try? JSONDecoder().decode([Poem].self, from: data) {
                poems = decodedResponse.poems
                return
            }
        }
        showingAlert = true
    }
}
struct Poem: Identifiable, Codable {
    let id = UUID()
    let title: String
    let lines: [String]
    
    enum CodingKeys: String, CodingKey {
        case title, lines
    }
}

#Preview {
    PoemsListView(author: "Walt Whitman")
}

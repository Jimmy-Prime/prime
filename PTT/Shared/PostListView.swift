//
//  PostListView.swift
//  PTT
//
//  Created by Jimmy Lee on 2020/8/17.
//

import SwiftUI

struct PostListView: View {
    let posts: [Post]

    var body: some View {
        NavigationView {
            List(posts) { post in
                PostView(post: post)
            }
                .navigationTitle(Text("PC_Shopping"))
        }
    }
}

struct PostListView_Previews: PreviewProvider {
    static var posts: [Post] {
        (0..<30).map { index in
            Post(
                id: 103642 - index,
                date: "08/17",
                title: "□ [請益] 主機板推薦",
                authorID: "rul3gj3"
            )
        }
    }

    static var previews: some View {
        PostListView(posts: posts)
    }
}

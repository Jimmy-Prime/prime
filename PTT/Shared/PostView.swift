//
//  PostView.swift
//  PTT
//
//  Created by Jimmy Lee on 2020/8/17.
//

import SwiftUI

struct Post: Identifiable {
    let id: Int
    let date: String
    let title: String
    let authorID: String

    // 推噓
    // " ", "+", "~", "m", ...
}

struct PostView: View {
    let post: Post

    var body: some View {
        VStack(alignment: .leading) {
            Text(post.title)
                .font(.system(.body, design: .monospaced))
            HStack {
                Text("\(post.date) \(post.authorID)")
                Spacer()
                Text(String(post.id))
            }
                .font(.system(.footnote, design: .monospaced))
                .foregroundColor(.secondary)
        }
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(
            post: Post(
                id: 103642,
                date: "8/17",
                title: "□ [請益] 主機板推薦",
                authorID: "rul3gj3"
            )
        )
            .previewLayout(.sizeThatFits)
    }
}

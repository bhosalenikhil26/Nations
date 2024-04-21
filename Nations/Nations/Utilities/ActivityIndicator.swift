//
//  ActivityIndicator.swift
//  Nations
//
//  Created by Nikhil Bhosale on 2024-04-20.
//

import SwiftUI

struct ActivityIndicator: View {
    @State private var isLoading = false

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color(.systemGray5), lineWidth: 7)
                .frame(width: 50, height: 50)

            Circle()
                .trim(from: 0, to: 0.2)
                .stroke(Color.green, lineWidth: 5)
                .frame(width: 50, height: 50)
                .rotationEffect(Angle(degrees: isLoading ? 360 : 0))
                .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false), value: UUID())
                .onAppear() {
                    self.isLoading = true
                }
        }
    }
}

#Preview {
    ActivityIndicator()
}

//
//  FHeaderView.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 3/10/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import SwiftUI

struct FHeaderView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("filterHeaderLabel")
                .fixedSize(horizontal: false, vertical: true)
        }
        .font(.caption)
        .foregroundColor(.secondaryLabel)
    }
}

struct FHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        FHeaderView()
    }
}

//
//  HelpFeedbackView.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-05-15.
//

import SwiftUI

struct HelpFeedbackView: View {
    
    private let termsURL = "https://thebonnechance.com/ternsofservice/"
    private let privacyURL = "https://thebonnechance.com/privacypolicy/"
    
    var body: some View {
        List {
            Section("HELP & SUPPORT") {
                Button {
                    if let url = URL(string: termsURL) {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    HStack(alignment: .center) {
                        Image(systemName: "doc")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                        Text("Terms of Service")
                            .font(.subheadline)
                        Spacer()
                        Image(systemName: "chevron.forward")
                            .imageScale(.small)
                            .foregroundColor(.gray)
                    }
                }
                Button {
                    if let url = URL(string: privacyURL) {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    HStack(alignment: .center) {
                        Image(systemName: "person.badge.shield.checkmark")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                        Text("Privacy Policy")
                            .font(.subheadline)
                        Spacer()
                        Image(systemName: "chevron.forward")
                            .imageScale(.small)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
}

#Preview {
    HelpFeedbackView()
}

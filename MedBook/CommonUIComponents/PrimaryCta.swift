//
//  PrimaryCta.swift
//  MedBook
//
//  Created by Sai Prithvi on 16/03/25.
//

import SwiftUI

struct PrimaryCta: View {
    let text: String
    let rightIcon: Image?
    let isEnabled: Bool
    let action: () -> Void
    
    init(
        text: String,
        rightIcon: Image? = Image(systemName: "arrow.right"),
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.text = text
        self.rightIcon = rightIcon
        self.isEnabled = isEnabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(text)
                    .font(.body)
                    .fontWeight(.semibold)
                
                if let icon = rightIcon {
                    icon
                        .font(.body)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .padding(.horizontal, 24)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
            )
            .foregroundColor(isEnabled ? .black : .gray)
        }
        .disabled(!isEnabled)
    }
}

#Preview {
    VStack(spacing: 20) {
        PrimaryCta(text: "Signup") {
            print("Button tapped!")
        }
        
        PrimaryCta(text: "Disabled", isEnabled: false) {
            print("Button tapped!")
        }
        
        PrimaryCta(text: "Custom Icon", rightIcon: Image(systemName: "star.fill")) {
            print("Button tapped!")
        }
    }
    .padding()
}

//
//  SignInEmailView.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-03-11.
//

import SwiftUI

struct SignInEmailView: View {
    
    @StateObject private var viewModel = SignInEmailViewModel()
    @Binding var email: String
    
    @Environment(\.dismiss) var dismiss

    @AppStorage("signed_in") var currentUserSignedIn: Bool?
    
    var body: some View {
        VStack {
            HStack {
                CommonBackButton {
                    dismiss()
                }
                .padding(.top, 10)
                Spacer()
            }
            VStack {
                TextField("email address", text: $email)
                    .padding()
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 0.5)
                    )
                
                SecureField("password", text: $viewModel.password)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 0.5)
                    )
                
                Button {
                    Task {
                        do {
                            viewModel.email = email
                            try await viewModel.signUp()
                            currentUserSignedIn = true
                            return
                        } catch {
                            print("Error occurred during sign up")
                            print(error)
                        }
                        
                        do {
                            viewModel.email = email
                            try await viewModel.signIn()
                            currentUserSignedIn = true
                            return
                        } catch {
                            print("Error occurred during sing in")
                            print(error)
                        }
                    }
                
                } label: {
                    Text("Sign In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(email.isEmpty == true ? Color.gray : Color.purple)
                        .cornerRadius(10)
                }
                
                Spacer()
                
            }
            .padding()
            
        }
        .navigationBarBackButtonHidden(true)
        
        
    }
}

struct SignInEmailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SignInEmailView(email: .constant(""))
        }
    }
}

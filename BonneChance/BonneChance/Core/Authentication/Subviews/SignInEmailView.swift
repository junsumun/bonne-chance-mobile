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
    @Binding var hasAccount: Bool
    
    @State var errorMessage: String = ""
    
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
                
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                        .foregroundColor(.red)
                        .font(.system(size: 15))
                        .padding(.horizontal)
                }
                Button {
                    Task {
                        if (hasAccount) {
                            do {
                                viewModel.email = email
                                try await viewModel.signIn()
                                currentUserSignedIn = true
//                                return
                            } catch let error as AuthenticationError {
                                errorMessage = error.errorDescription
                            }
                        } else {
                            do {
                                viewModel.email = email
                                try await viewModel.signUp()
                                currentUserSignedIn = true
                                return
                            } catch let error as AuthenticationError {
                                errorMessage = error.errorDescription
                            }
                        }
                    }
                
                } label: {
                    Text(hasAccount ? "Sign In" : "Sign Up")
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
            SignInEmailView(email: .constant(""), hasAccount: .constant(false))
        }
    }
}

//
//  SignInEmailView.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-03-11.
//

import SwiftUI

struct SignInEmailView: View {
    
    enum FocusField {
        case email
    }
    
    @StateObject private var viewModel = SignInEmailViewModel()
    
    @Binding var email: String
    @Binding var hasAccount: Bool
    
    @State var errorMessage: String = ""
    
    @FocusState private var focusedField: FocusField?
    
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
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .focused($focusedField, equals: .email)
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                    .padding(.leading, 5)
                    .overlay(
                        Divider()
                            .frame(maxHeight: 1)
                            .background(.black),
                        alignment: .bottom
                    )
                
                SecureField("password", text: $viewModel.password)
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                    .padding(.leading, 5)
                    .overlay(
                        Divider()
                            .frame(maxHeight: 1)
                            .background(.black),
                        alignment: .bottom
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
                        .padding(16)
                        .frame(maxWidth: .infinity)
                        .background(email.isEmpty == true ? Color("ButtonDisabledColor") : Color("MainColor"))
                        .cornerRadius(27)
                        .padding(.horizontal, 15)
                        .foregroundColor(.white)
                        .bold()
                }
                .padding(.top, 20)
                
                Spacer()
                
            }
            .padding()
            
        }
        .navigationBarBackButtonHidden(true)
        .onAppear{
            focusedField = .email
        }
        
        
    }
}

struct SignInEmailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SignInEmailView(email: .constant(""), hasAccount: .constant(false))
        }
    }
}

//
//  AuthenticationView.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-03-11.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct AuthenticationView: View {
    
    @StateObject private var viewModel = AuthenticationViewModel()
    
    @State var email: String = ""
    
    @Binding var hasAccount: Bool
    
    // User Profile
    @AppStorage("firstName") var currentUserFirstName: String?
    @AppStorage("lastName") var currentUserLastName: String?
    @AppStorage("gender") var currentUserGender: Gender?
    @AppStorage("birthdate") var currentUserBirthdate: String?
    
    @AppStorage("signed_in") var currentUserSignedIn: Bool?
    
    
    var body: some View {
        VStack {
            HStack {
                Text(hasAccount ? "Sign in" : "Sign up")
                    .font(.title)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 10)
            
            Text("Please confirm your email to continue.")
                .font(.body)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 20)
                
            
            TextField("email address", text: $email)
                .autocapitalization(.none)
                .padding()
                .keyboardType(.emailAddress)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 0.5)
                )
            
            NavigationLink {
                SignInEmailView(email: $email, hasAccount: $hasAccount)
            } label: {
                Text("Continue")
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(email.isEmpty == true ? Color.gray : Color.purple)
                    .cornerRadius(10)
            }
            .disabled(email.isEmpty)
            
            HStack {
                VStack {
                    Divider().background(.gray)
                }
                .padding(20)
                Text("OR")
                VStack {
                    Divider().background(.gray)
                }
                .padding(20)
            }
            
            
            Button {
                Task {
                    do {
                        if (hasAccount) {
                            try await viewModel.signInGoogle()
                        } else {
                            try await viewModel.signUpGoogle(
                                firstName: currentUserFirstName,
                                lastName: currentUserLastName,
                                gender: currentUserGender,
                                birthdate: currentUserBirthdate)
                        }
                        currentUserSignedIn = true
                    } catch {
                        print(error)
                    }
                }
            } label: {
                HStack {
                    Image("google_logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15)
                        
                    Text("Continue with Google")
                        .foregroundStyle(.black)
                        .font(.system(size: 20))
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.black, lineWidth: 0.5)
                )
            }
            .alert(isPresented: Binding<Bool>(get: { viewModel.showSignInFailAlert }, set: { _ in })) {
                Alert(
                    title: Text("Sign in failed"),
                    message: Text(AuthenticationError.invalidCredential.errorDescription + "\nPlease sign up first."),
                    dismissButton: .default(Text("Close"))
                )
            }
            
            
            Button(action: {
                Task {
                    do {
                        if hasAccount {
                            try await viewModel.signInApple()
                        } else {
                            try await viewModel.signUpApple(
                                firstName: currentUserFirstName,
                                lastName: currentUserLastName,
                                gender: currentUserGender,
                                birthdate: currentUserBirthdate)
                        }
                        
                    } catch {
                        print(error)
                    }
                }
            }, label: {
                SignInWithAppleButtonViewRepresentable(type: .continue, style: .black)
                    .allowsHitTesting(/*@START_MENU_TOKEN@*/false/*@END_MENU_TOKEN@*/)
            })
            .frame(height: 55)
            .onChange(of: viewModel.didSignInWithApple) {
                if viewModel.didSignInWithApple == true {
                    currentUserSignedIn = true
                } else {
                    currentUserSignedIn = false
                }
            }
            .alert(isPresented: Binding<Bool>(get: { viewModel.showSignInFailAlert }, set: { _ in })) {
                Alert(
                    title: Text("Sign in failed"),
                    message: Text(AuthenticationError.invalidCredential.errorDescription + "\nPlease sign up first."),
                    dismissButton: .default(Text("Close"))
                )
            }

            Spacer()
        }
        .padding()
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AuthenticationView(hasAccount: .constant(false))
        }
    }
}

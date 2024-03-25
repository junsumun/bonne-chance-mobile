//
//  AuthenticationView.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-03-11.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift




@MainActor
final class AuthenticationViewModel: ObservableObject {
    
    @Published var didSignInWithApple: Bool = false
    let signInAppleHelper = SignInAppleHelper()
    
    func signInGoogle() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        
        try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
    }
    
    func signInApple() async throws {
        signInAppleHelper.startSignInWithAppleFlow { result in
            switch result {
            case .success(let signInAppleResult):
                Task {
                    do {
                        try await AuthenticationManager.shared.signInWithApple(tokens: signInAppleResult)
                        self.didSignInWithApple = true
                    } catch {
                        
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
}

struct AuthenticationView: View {
    
    @StateObject private var viewModel = AuthenticationViewModel()
    @Binding var showSignInView: Bool
    
    @State var email: String = ""
    
    var body: some View {
        let _ = print("Authentication View: \(showSignInView)")
        VStack {
            HStack {
                Text("Sign up")
                    .font(.title)
                Text("or")
                    .font(.title3)
                Text("Log in")
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
                SignInEmailView(showsSignInView: $showSignInView, email: $email)
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
                        try await viewModel.signInGoogle()
                        showSignInView = false
                    } catch {
                        print(error)
                    }
                }
            } label: {
                HStack {
                    Image("google-logo")
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
            
            Button(action: {
                Task {
                    do {
                        try await viewModel.signInApple()
                        
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
                    showSignInView = false
                } else {
                    showSignInView = true
                }
            }

            Spacer()
        }
        .padding()
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AuthenticationView(showSignInView: .constant(true))
        }
    }
}

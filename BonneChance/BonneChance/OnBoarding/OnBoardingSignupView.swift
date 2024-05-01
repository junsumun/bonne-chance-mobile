//
//  OnBoardingSignupView.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-03-19.
//

import SwiftUI

struct OnBoardingSignupView: View {
    enum FocusField {
        case firstName
        case lastName
    }
    
    @State var onboardingState: Int = 0
    
    // User Profile Inputs
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var gender: Gender?
    @State var birthdate: Date = Date()
    
    @State private var currentStep: Int = 0
    
    @State private var onBoardingSignupSteps: Int = 4
    
    @FocusState private var focusedField: FocusField?
    
    @Environment(\.dismiss) var dismiss
    
    @AppStorage("firstName") var currentUserFirstName: String?
    @AppStorage("lastName") var currentUserLastName: String?
    @AppStorage("gender") var currentUserGender: Gender?
    @AppStorage("birthdate") var currentUserBirthdate: String?
    
    var body: some View {
        VStack {
            HStack {
                CommonBackButton {
                    handleBackButtonClicked()
                }
                .padding(.top, 10)
                Spacer()
            }

            VStack {
                switch onboardingState {
                case 0:
                    firstNamePromptView
                case 1:
                    lastNamePromptView
                case 2:
                    genderPromptView
                case 3:
                    birthdayPromptView
                case 4:
                    authenticationView
                default:
                    firstNamePromptView
                }
            }

        }
        .navigationBarBackButtonHidden(true)
            
    }
    
    
}

extension OnBoardingSignupView {
    private func nextButton(buttonDisabled: Bool) -> some View {
        Text("Next")
            .padding(16)
            .frame(maxWidth: .infinity)
            .background(buttonDisabled == true ? Color("ButtonDisabledColor") : Color("MainColor"))
            .cornerRadius(27)
            .padding(.horizontal, 15)
            .foregroundColor(.white)
            .bold()
            .onTapGesture {
                handleNextButtonClicked()
            }
            .disabled(buttonDisabled)
    }
    
    private var signupProgressIndicator: some View {
        HStack {
            ForEach(0..<onBoardingSignupSteps, id: \.self) { index in
                if index == currentStep {
                    Rectangle()
                        .frame(width: 20, height: 10)
                        .cornerRadius(10)
                        .foregroundColor(Color("MainColor"))
                } else if index < currentStep {
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundColor(Color("MainColor"))
                } else {
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.bottom, 24)
    }
    
    private var firstNamePromptView: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("What's your **first name**?")
                    .font(.title)
                    .fontDesign(.serif)

                TextField("first name", text: $firstName)
                    .limitInputLength(value: $firstName, length: 20)
                    .focused($focusedField, equals: .firstName)
                    .padding(.bottom, 10)
                    .padding(.leading, 5)
                    .overlay(
                        Divider()
                            .frame(maxHeight: 1)
                            .background(.black),
                        alignment: .bottom
                    )
            }
            .padding(.top, 30)
            .padding(.bottom, 24)
            
            signupProgressIndicator
            
            nextButton(buttonDisabled: !firstNameInputIsValid())
            
            Spacer()
        }
        .padding()
        .onAppear {
            focusedField = .firstName
        }
    }
    
    private var lastNamePromptView: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("What's your **last name**?")
                    .font(.title)
                    .fontDesign(.serif)

                TextField("last name", text: $lastName)
                    .limitInputLength(value: $lastName, length: 20)
                    .focused($focusedField, equals: .lastName)
                    .padding(.bottom, 10)
                    .padding(.leading, 5)
                    .overlay(
                        Divider()
                            .frame(maxHeight: 1)
                            .background(.black),
                        alignment: .bottom
                    )

            }
            .padding(.top, 30)
            .padding(.bottom, 24)
            
            signupProgressIndicator
            
            nextButton(buttonDisabled: !lastNameInputIsValid())
            
            Spacer()
        }
        .padding()
        .onAppear {
            focusedField = .lastName
        }
    }
    
    private var genderPromptView: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("What's your **gender**?")
                    .font(.title)
                    .fontDesign(.serif)
                
                Text("Male")
                    .bold()
                    .padding(16)
                    .frame(maxWidth: .infinity)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(gender == Gender.male ? Color("MainColor") : Color.black, lineWidth: 0.5)
                    )
                    .background(gender == Gender.male ? Color("MainColor") : Color.white)
                    .cornerRadius(10)
                    .foregroundColor(gender == Gender.male ? Color.white : Color.black)
                    .onTapGesture {
                        gender = Gender.male
                    }
                
                Text("Female")
                    .bold()
                    .padding(16)
                    .frame(maxWidth: .infinity)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(gender == Gender.female ? Color("MainColor") : Color.black, lineWidth: 0.5)
                    )
                    .background(gender == Gender.female ? Color("MainColor") : Color.white)
                    .cornerRadius(10)
                    .foregroundColor(gender == Gender.female ? Color.white : Color.black)
                    .onTapGesture {
                        gender = Gender.female
                    }
                
                Text("Other")
                    .bold()
                    .padding(16)
                    .frame(maxWidth: .infinity)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(gender == Gender.other ? Color("MainColor") : Color.black, lineWidth: 0.5)
                    )
                    .background(gender == Gender.other ? Color("MainColor") : Color.white)
                    .cornerRadius(10)
                    .foregroundColor(gender == Gender.other ? Color.white : Color.black)
                    .onTapGesture {
                        gender = Gender.other
                    }
            }
            .padding(.top, 30)
            .padding(.bottom, 24)
            
            Spacer()
            
            signupProgressIndicator
            
            nextButton(buttonDisabled: !isGenderSelected())
        }
        .padding()
    }
    
    private var birthdayPromptView: some View {
        VStack {
            VStack(alignment: .center) {
                Text("When is your **birthday**?")
                    .font(.title)
                    .fontDesign(.serif)
                DatePicker("",
                           selection: $birthdate,
                           displayedComponents: [.date])
                    .datePickerStyle(.wheel)
                    .labelsHidden()
            }
            .padding(.top, 30)
            .padding(.bottom, 24)
            
            Spacer()
            
            signupProgressIndicator
            
            nextButton(buttonDisabled: false)
        }
        .padding()
    }
    
    private var authenticationView: some View {
        AuthenticationView(hasAccount: .constant(false))
    }
}

extension OnBoardingSignupView {
    private func handleNextButtonClicked() {
        if (onboardingState <= onBoardingSignupSteps - 1) {
            storeUserProfile()
            withAnimation(.spring) {
                onboardingState += 1
            }
            currentStep += 1
        }
    }
    
    private func handleBackButtonClicked() {
        if (onboardingState >= 1) {
            withAnimation(.spring) {
                onboardingState -= 1
            }
            currentStep -= 1
        } else {
            dismiss()
        }
    }
    
    private func firstNameInputIsValid() -> Bool {
        return !firstName.isEmpty
    }
    
    private func lastNameInputIsValid() -> Bool {
        return !lastName.isEmpty
    }
    
    private func isGenderSelected() -> Bool {
        return gender != nil;
    }
    
    private func storeUserProfile() -> Void {
        currentUserFirstName = firstName
        currentUserLastName = lastName
        currentUserGender = gender
        currentUserBirthdate = DateFormatter.localizedString(from: birthdate, dateStyle: .medium, timeStyle: .none)
        print("Birthdate: \(String(describing: currentUserBirthdate))")
    }
}


#Preview {
    OnBoardingSignupView()
}

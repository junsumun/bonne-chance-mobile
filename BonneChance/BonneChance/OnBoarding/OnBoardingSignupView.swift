//
//  OnBoardingSignupView.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-03-19.
//

import SwiftUI

enum Gender {
    case male
    case female
}

struct OnBoardingSignupView: View {
    @Binding var showSignInView: Bool
    
    @State var onboardingState: Int = 0
    
    @State var firstName: String = ""
    @State var lastName: String = ""
    
    @State var gender: Gender?
    
    @State var birthdate: Date = Date()
    
    @State private var currentStep: Int = 0
    
    @State private var onBoardingSignupSteps: Int = 5
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            HStack {
                CommonBackButton {
                    handleBackButtonClicked()
                }
                Spacer()
            }

            VStack {
                switch onboardingState {
                case 0:
                    firstNamePromptView
                case 1:
//                    authenticationView
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
            .background(buttonDisabled == true ? Color.gray : Color.purple)
            .cornerRadius(10)
            .foregroundColor(.white)
            .onTapGesture {
                print(birthdate)
                handleNextButtonClicked()
            }
            .disabled(buttonDisabled)
    }
    
    private var backButton: some View {
        HStack {
            Button(action: {
                handleBackButtonClicked()
            }) {
                Label("Back", systemImage: "chevron.backward")
                    .foregroundColor(.purple)
            }
            Spacer()
        }
        .padding(.horizontal, 10)
    }
    
    private var signupProgressIndicator: some View {
        HStack {
            ForEach(0..<onBoardingSignupSteps, id: \.self) { index in
                if index == currentStep {
                    Rectangle()
                        .frame(width: 20, height: 10)
                        .cornerRadius(10)
                        .foregroundColor(.purple)
                } else if index < currentStep {
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundColor(.purple)
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
            VStack {
                Image("onboarding1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250, height: 250)


                Text("What's your **first name**?")
                    .multilineTextAlignment(.center)
                    .font(.title)

                TextField("max 20 characters", text: $firstName)
                    .limitInputLength(value: $firstName, length: 20)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 0.5)
                    )
            }
            
            .padding(.bottom, 24)
            
            Spacer()
            
            signupProgressIndicator
            
            nextButton(buttonDisabled: !firstNameInputIsValid())
        }
        .padding()
    }
    
    private var lastNamePromptView: some View {
        VStack {
            VStack {
                Image("onboarding1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250, height: 250)


                Text("What's your **last name**?")
                    .multilineTextAlignment(.center)
                    .font(.title)

                TextField("max 20 characters", text: $lastName)
                    .limitInputLength(value: $lastName, length: 20)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 0.5)
                    )

            }
            .padding(.bottom, 24)
            
            Spacer()
            
            signupProgressIndicator
            
            nextButton(buttonDisabled: !lastNameInputIsValid())
        }
        .padding()
    }
    
    private var genderPromptView: some View {
        VStack {
            VStack {
                Image("onboarding1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250, height: 250)

                Text("What's your **gender**?")
                    .multilineTextAlignment(.center)
                    .font(.title)
                
                Text("Male")
                    .bold()
                    .padding(16)
                    .frame(maxWidth: .infinity)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(gender == Gender.male ? Color.purple : Color.black, lineWidth: 0.5)
                    )
                    .background(gender == Gender.male ? Color.purple : Color.white)
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
                            .stroke(gender == Gender.female ? Color.purple : Color.black, lineWidth: 0.5)
                    )
                    .background(gender == Gender.female ? Color.purple : Color.white)
                    .cornerRadius(10)
                    .foregroundColor(gender == Gender.female ? Color.white : Color.black)
                    .onTapGesture {
                        gender = Gender.female
                    }
            }
            .padding(.bottom, 24)
            
            Spacer()
            
            signupProgressIndicator
            
            nextButton(buttonDisabled: !isGenderSelected())
        }
        .padding()
    }
    
    private var birthdayPromptView: some View {
        VStack {
            VStack {
                Image("onboarding1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250, height: 250)
                Text("When is your **birthday**?")
                    .multilineTextAlignment(.center)
                    .font(.title)
            }
            .padding(.bottom, 24)
            
            var dateClosedRange: ClosedRange<Date> {
                let min = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
                let max = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
                return min...max
            }
            
            DatePicker("", selection: $birthdate, displayedComponents: [.date])
                .datePickerStyle(.wheel)
                .labelsHidden()
            
            
            Spacer()
            
            signupProgressIndicator
            
            nextButton(buttonDisabled: false)
        }
        .padding()
    }
    
    private var authenticationView: some View {
        AuthenticationView(showSignInView: $showSignInView)
    }
}

extension OnBoardingSignupView {
    private func handleNextButtonClicked() {
        if (onboardingState < onBoardingSignupSteps - 1) {
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
}


#Preview {
    OnBoardingSignupView(showSignInView: .constant(true))
}

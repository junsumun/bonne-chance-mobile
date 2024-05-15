//
//  UpdateProfileView.swift
//  BonneChance
//
//  Created by Junsu Mun on 2024-05-07.
//

import SwiftUI

struct UpdateProfileView: View {
    
    @EnvironmentObject var profileViewModel: ProfileViewModel
    
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var gender: Gender = Gender.male
    @State var birthdate: Date = Date()
    
    var body: some View {
        VStack {
            Image(self.gender == Gender.male ? "man_profile" : "woman_profile")
                .resizable()
                .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                .frame(width: 95, height: 95)
                .foregroundColor(.purple)
            
            VStack(alignment: .leading) {
                Text("**First name**")
                    .font(.title)
                    .fontDesign(.serif)
                
                TextField("first name", text: $firstName)
                    .limitInputLength(value: $firstName, length: 20)
                    .padding(.bottom, 10)
                    .padding(.leading, 5)
                    .overlay(
                        Divider()
                            .frame(maxHeight: 1)
                            .background(.black),
                        alignment: .bottom
                    )
            }
            .padding(.bottom, 15)
            
            VStack(alignment: .leading) {
                Text("**Last name**")
                    .font(.title)
                    .fontDesign(.serif)
                
                TextField("first name", text: $lastName)
                    .limitInputLength(value: $lastName, length: 20)
                    .padding(.bottom, 10)
                    .padding(.leading, 5)
                    .overlay(
                        Divider()
                            .frame(maxHeight: 1)
                            .background(.black),
                        alignment: .bottom
                    )
            }
            .padding(.bottom, 15)
            
            HStack {
                Text("**Gender**")
                    .font(.title)
                    .fontDesign(.serif)
                Spacer()
                Picker("Gender", selection: $gender) {
                    Text("Male").tag(Gender.male)
                    Text("Female").tag(Gender.female)
                    Text("Ohter").tag(Gender.other)
                }
            }
            .padding(.bottom, 15)
            
            HStack {
                Text("**Birthday**")
                    .font(.title)
                    .fontDesign(.serif)
                Spacer()
                DatePicker("",
                           selection: $birthdate,
                           displayedComponents: [.date])
                .datePickerStyle(.compact)
                .labelsHidden()
            }
            .padding(.bottom, 15)
            
            Text("Update")
                .padding(16)
                .frame(maxWidth: .infinity)
                .background(Color("MainColor"))
                .cornerRadius(27)
                .padding(.horizontal, 15)
                .foregroundColor(.white)
                .bold()
                .onTapGesture {
                    updateProfile()
                }
            Spacer()
        }
        .padding()
        .onAppear {
            guard let firstName = profileViewModel.user?.firstName,
                  let lastName = profileViewModel.user?.lastName,
                  let gender = profileViewModel.user?.gender,
                  let birthdate = profileViewModel.user?.birthdate else {
                return
            }
            self.firstName = firstName
            self.lastName = lastName
            self.gender = gender
            self.birthdate = convertDate(dateString: birthdate)
        }
    }
    
    func convertDate(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        
        return dateFormatter.date(from: dateString)!
    }
}

extension UpdateProfileView {
    func updateProfile() {
        Task {
            await profileViewModel.updateProfile(firstName: self.firstName,
                                                 lastName: self.lastName,
                                                 gender: self.gender,
                                                 birthdate: DateFormatter.localizedString(from: self.birthdate, dateStyle: .medium, timeStyle: .none))
        }
        
    }
}

#Preview {
    UpdateProfileView()
        .environmentObject(ProfileViewModel())
}

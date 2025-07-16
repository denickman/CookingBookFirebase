//
//  RegisterView.swift
//  CookBook
//
//  Created by Gwinyai Nyatsoka on 2/5/2024.
//

import SwiftUI

struct RegisterView: View {
    
    @State var viewModel = RegisterViewModel()
    @Environment(\.dismiss) var dismiss
    @Environment(SessionManager.self) var sessionManager: SessionManager
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text("Username")
                    .font(.system(size: 15))
                TextField("Username", text: $viewModel.username)
                    .keyboardType(.emailAddress)
                    .textFieldStyle(AuthTextFieldStyle())
                Text("Email")
                    .font(.system(size: 15))
                TextField("Email", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .textFieldStyle(AuthTextFieldStyle())
                Text("Password")
                    .font(.system(size: 15))
                PasswordComponentView(showPassword: $viewModel.showPassword, password: $viewModel.password)
                Button(action: {
                    Task {
                        if let user = await viewModel.signUp() {
                            sessionManager.currentUser = user
                            sessionManager.sessionState = .loggedIn
                        }
                    }
                }, label: {
                    Text("Sign Upppp")
                })
                .buttonStyle(PrimaryButtonStyle())
                HStack {
                    Spacer()
                    Text("Already have an account?")
                        .font(.system(size: 14))
                    Button(action: {
                        dismiss()
                    }, label: {
                        Text("Login now")
                            .font(.system(size: 14, weight: .semibold))
                    })
                    Spacer()
                }
                .padding(.top, 20)
            }
            .padding(.horizontal, 10)
            
            if viewModel.isLoading {
                LoadingComponentView()
               
            }
           
        }
        .alert(item: $viewModel.errorMessage) { alert in
            Alert(
                title: Text("Ошибка"),
                message: Text(alert.text),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

#Preview {
    RegisterView().environment(SessionManager())
}

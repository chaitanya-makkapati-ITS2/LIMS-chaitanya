//
//  LoginView.swift
//  LIMS-chaitanya
//
//  Created by Chaitanya Makkapati on 12/5/24.
//
import SwiftUI

struct LoginView: View {
    // Dynamic Constants
    private let primaryColor = Color(red: 0/255, green: 118/255, blue: 129/255)
    private let buttonBackgroundColor = Color(red: 127/255, green: 169/255, blue: 174/255)
    private let lightGrayColorName = "LightGray"

    // State variables
    @State private var username: String = ""
    @State private var password: String = ""

    
    ///in this body we will have ui view of login page
    var body: some View {
       
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height

            VStack(spacing: screenHeight * 0.02) {
                // Header Section
                VStack(spacing: screenHeight * 0.02) {
                    Image("Image") /// Nystate logo
                        .resizable()
                        .scaledToFit()
                        .frame(width: screenWidth * 0.6)
                        .accessibilityHidden(true)

                    Image("Food") ///NYS AGM logo
                        .resizable()
                        .scaledToFit()
                        .frame(width: screenWidth * 0.15)
                        .accessibilityHidden(true)

                    Text("AGM Samples")
                        .font(.system(size: screenHeight * 0.03, weight: .bold))
                        .foregroundColor(primaryColor)
                        .multilineTextAlignment(.center)
                        .accessibilityLabel("App Title")
                }
                .padding(.bottom, screenHeight * 0.04)

                // Form Section
                /// here we do all the desiging
                ZStack(alignment: .top) {
                    RoundedRectangle(cornerRadius: screenHeight * 0.03)
                        .fill(primaryColor)
                        .edgesIgnoringSafeArea(.bottom)

                    VStack(spacing: screenHeight * 0.02) {
                        // Username Field
                        HStack {
                            Image(systemName: "person.circle")
                                .foregroundColor(primaryColor)
                                .accessibilityHidden(true)

                            TextField("Username", text: $username)
                                .foregroundColor(primaryColor)
                                .disableAutocorrection(true)
                                .accessibilityLabel("Username")

                            Image(systemName: "faceid")
                                .foregroundColor(primaryColor)
                                .accessibilityHidden(true)
                        }
                        .padding()
                        .frame(height: screenHeight * 0.07)
                        .background(Color.white)
                        .cornerRadius(screenHeight * 0.03)
                        .shadow(radius: screenHeight * 0.005)

                        // Password Field
                        HStack {
                            Image(systemName: "key.fill")
                                .foregroundColor(primaryColor)
                                .accessibilityHidden(true)

                            SecureField("Password", text: $password)
                                .accessibilityLabel("Password")

                           
                        }
                        .padding()
                        .frame(height: screenHeight * 0.07)
                        .background(Color.white)
                        .cornerRadius(screenHeight * 0.03)
                        .shadow(radius: screenHeight * 0.005)

                        // Log In Button
                        loginButton(width: screenWidth * 0.8, height: screenHeight * 0.07)

                        // Version Info
                        Text("Dev Version: 2.0.1")
                            .font(.footnote)
                            .foregroundColor(.white)
                            .accessibilityLabel("Developer Version 2.0.1")
                    }
                    .padding(.horizontal, screenWidth * 0.1)
                    .padding(.top, screenHeight * 0.05)
                    .background(
                        RoundedRectangle(cornerRadius: screenHeight * 0.03)
                            .fill(Color(lightGrayColorName))
                            .shadow(radius: screenHeight * 0.01)
                    )
                }
            }

        }
    }
    
    ///  here we will able to authenticate the login after
    /// - Parameters:
    ///   - width: <#width description#>
    ///   - height: <#height description#>
    /// - Returns: we will be sucessfully able to login
    private func loginButton(width: CGFloat, height: CGFloat) -> some View {
        Button(action: {
            print("Log in tapped")
        }) {
            Text("Log In")
                .font(.headline)
                .foregroundColor(.white)
                .frame(width: width, height: height)
                .background(buttonBackgroundColor)
                .cornerRadius(height * 0.5)
        }
        .accessibilityLabel("Log in to your account")
        .accessibilityHint("Tap to log in")
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

//
//  SignInView.swift
//  SignInView
//
//  Created by Philipp on 19.07.21.
//

import AuthenticationServices
import SwiftUI

struct SignInView: View {

    enum SignInStatus {
        case unknown, authorized, failure(Error?)
    }

    @State private var status = SignInStatus.unknown
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        NavigationView {
            Group {
                switch status {
                case .unknown:
                    VStack(alignment: .leading) {
                        ScrollView {
                            Text("""
                            In order to keep our community safe, we ask you to sign in before commenting on a project.

                            We don't track your personal information; your name is used for display purposes only.

                            Please note: we reserve the right to remove messages that are inappropriate or offensive.
                            """)
                        }

                        Spacer()

                        SignInWithAppleButton(onRequest: configureSignIn, onCompletion: completeSignIn)
                            .frame(height: 44)
                            .signInWithAppleButtonStyle(colorScheme == .light ? .black : .white)

                        Button("Cancel", action: close)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }

                case .authorized:
                    Text("You're all set!")

                case .failure(let error):
                    if let error = error {
                        Text("Sorry, there was an error \(error.localizedDescription)")
                    } else {
                        Text("Sorry, there was an error.")
                    }

                }
            }
            .padding()
            .navigationTitle("Please sign in")
        }
    }

    func close() {
        presentationMode.wrappedValue.dismiss()
    }

    func configureSignIn(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName]
    }

    func completeSignIn(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let auth):
            if let appleID = auth.credential as? ASAuthorizationAppleIDCredential {
                if let fullName = appleID.fullName {
                    let formatter = PersonNameComponentsFormatter()
                    var username = formatter.string(from: fullName).trimmingCharacters(in: .whitespacesAndNewlines)
                    if username.isEmpty {
                        // Refuse to allow empty string names
                        username = "User-\(Int.random(in: 1001...9999))"
                    }

                    UserDefaults.standard.set(username, forKey: "username")
                    NSUbiquitousKeyValueStore.default.set(username, forKey: "username")

                    status = .authorized
                    close()
                    return
                }
            }

            status = .failure(nil)

        case .failure(let error):
            if let error = error as? ASAuthorizationError,
               error.code == .canceled {
                status = .unknown
                return
            }

            status = .failure(error)
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}

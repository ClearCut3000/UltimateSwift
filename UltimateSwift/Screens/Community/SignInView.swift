//
//  SignInView.swift
//  UltimateSwift
//
//  Created by Николай Никитин on 17.04.2023.
//

import SwiftUI
import AuthenticationServices

struct SignInView: View {

  // MARK: - View Properties
  enum SignInStatus {
    case unknown
    case authorized
    case failure(Error?)
  }
  @State private var status = SignInStatus.unknown
  @Environment(\.presentationMode) var presentationMode
  @Environment(\.colorScheme) var colorScheme

  // MARK: - View Body
  var body: some View {
    NavigationView {
      Group {
        switch status {
        case .unknown:
          VStack(alignment: .leading) {
            ScrollView {
              Text("""
              In order to keep our community safe, we ask that you sign in before commenting on a project.
              We don't track your personal information; your name is used only for display purposes.
              Please note: we reserve the right to remove messages that are inappropriate or offensive.
              """)
              Spacer()
              SignInWithAppleButton(onRequest: configureSignIn(_:),
                                    onCompletion: completeSignIn(_:))
              .frame(height: 44)
              .signInWithAppleButtonStyle(colorScheme == .light ? .black : .white)
              Button("Cancel", action: close)
                .frame(maxWidth: .infinity)
                .padding()
            }
          }
        case .authorized:
          Text("You're all set!")
        case .failure(let error):
          if let error {
            Text("Sorry, there was an error: \(error.localizedDescription)")
          } else {
            Text("Sorry, there was an error.")
          }
        }
      }
      .padding()
      .navigationTitle("Please sign in")
    }
  }

  // MARK: - View Methods
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
      if let error = error as? ASAuthorizationError {
        if error.errorCode == ASAuthorizationError.canceled.rawValue {
          status = .unknown
          return
        }
      }
      status = .failure(error)
    }
  }

  func close() {
    presentationMode.wrappedValue.dismiss()
  }
}

struct SignInView_Previews: PreviewProvider {
  static var previews: some View {
    SignInView()
  }
}

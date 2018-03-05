//
// Copyright 2011 - 2018 Schibsted Products & Technology AS.
// Licensed under the terms of the MIT license. See LICENSE in the project root.
//

class AuthenticationCodeInteractor {
    let identityManager: IdentityManager

    init(identityManager: IdentityManager) {
        self.identityManager = identityManager
    }

    func validate(authCode: String, completion: @escaping (Result<User, ClientError>) -> Void) {
        self.identityManager.validate(authCode: authCode) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success:
                completion(.success(strongSelf.identityManager.currentUser))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

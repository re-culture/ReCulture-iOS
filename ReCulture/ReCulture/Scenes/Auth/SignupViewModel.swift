//
//  SignupViewModel.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 6/8/24.
//

import UIKit

final class SignupViewModel {
    
    // MARK: - Functions
        
    func postUserRegister(requestDTO: SignupRequestDTO, fromCurrentVC: UIViewController) {
        NetworkManager.shared.postUserRegister(signupRequestDTO : requestDTO) { result in
            switch result {
            case .success(let responseDTO):
                print("회원가입 성공! 응답값은: \(responseDTO)")
                let accessToken = String(responseDTO.accessToken)
                let refreshToken = String(responseDTO.refreshToken)
                
                KeychainManager.shared.saveToken(type: .accessToken, token: accessToken)
                KeychainManager.shared.saveToken(type: .refreshToken, token: refreshToken)
                
                print("access token: \(KeychainManager.shared.getToken(type: .accessToken))")
                print("refresh token: \(KeychainManager.shared.getToken(type: .refreshToken))")
                
                UserDefaultsManager.shared.setData(value: responseDTO.id, key: .userId)
                
                (fromCurrentVC as? SignUpVC)?.signupSuccess = true
            case .failure(let error):
                LoadingIndicator.hideLoading()
                
                var networkAlertController: UIAlertController
                
                switch error {
                case .userAuthError:
                    networkAlertController = self.authErrorAlert(error)
                default:
                    networkAlertController = self.networkErrorAlert(error)
                }

                DispatchQueue.main.async {
                    fromCurrentVC.present(networkAlertController, animated: true)
                }
            }
        }
    }
    
    private func authErrorAlert(_ error: Error) -> UIAlertController {
        let alertController = UIAlertController(title: "이미 존재하는 이메일입니다.",
                                                message: "다시 시도해주세요.",
                                                preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(confirmAction)
        
        return alertController
    }
    
    private func networkErrorAlert(_ error: Error) -> UIAlertController {
        let alertController = UIAlertController(title: "네트워크 에러가 발생했습니다. 다시 시도해주세요", message: error.localizedDescription, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(confirmAction)
        
        return alertController
    }
}

//
//  ActionSheetViewModel.swift
//  Vridge
//
//  Created by Kang Mingu on 2020/10/13.
//

import UIKit

protocol ActionSheetViewModelDelegate: class {
    func updateUser()
}

struct ActionSheetViewModel {
    
    weak var delegate: ActionSheetViewModelDelegate?
    
    func amendActionSheet(_ viewController: HomeViewController, row: Int, post: Post) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let amendButton = UIAlertAction(title: "수정하기", style: .default) { _ in
            // amend service
            PostService.shared.amendPost(row: row, viewController: viewController, post: post) { posts in
                let controller = PostingViewController(config: .amend(post), post: post)
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                viewController.present(nav, animated: true, completion: nil)
            }
        }
        let deleteButton = UIAlertAction(title: "삭제하기", style: .destructive) { _ in
            let deleteAlert = UIAlertController(title: "정말 삭제할까?",
                                                message: "게시글을 삭제하면\n이전으로 되돌릴 수 없어…!",
                                                preferredStyle: .alert)
            let noButton = UIAlertAction(title: "아니오", style: .default, handler: nil)
            let okButton = UIAlertAction(title: "예", style: .destructive) { _ in
                // delete service
                PostService.shared.deletePost(row: row, viewController: viewController, postId: post.postID) { (err, ref) in
                    delegate?.updateUser()
                }
            }
            deleteAlert.addAction(noButton)
            deleteAlert.addAction(okButton)
            viewController.present(deleteAlert, animated: true, completion: nil)
        }
        let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(amendButton)
        alert.addAction(deleteButton)
        alert.addAction(cancelButton)
        return alert
    }
    
    func reportActionSheet(_ viewController: HomeViewController, post: Post) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let reportButton = UIAlertAction(title: "신고하기", style: .default) { _ in
            let alert = UIAlertController(title: "신고 사유 선택", message: nil, preferredStyle: .actionSheet)
            let sexualHarass = UIAlertAction(title: "성적 수치심 유발", style: .default) { _ in
                viewController.showReportAlert()
            }
            let swear = UIAlertAction(title: "욕설/비하", style: .default) { _ in
                viewController.showReportAlert()
            }
            let fraud = UIAlertAction(title: "유출/사칭/사기", style: .default) { _ in
                viewController.showReportAlert()
            }
            let advertise = UIAlertAction(title: "상업적 광고 및 판매", style: .default) { _ in
                viewController.showReportAlert()
            }
            let nonsense = UIAlertAction(title: "채식과 관련 없음", style: .default) { _ in
                viewController.showReportAlert()
            }
            let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            alert.addAction(sexualHarass)
            alert.addAction(swear)
            alert.addAction(fraud)
            alert.addAction(advertise)
            alert.addAction(nonsense)
            alert.addAction(cancelButton)
            viewController.present(alert, animated: true, completion: nil)
        }
        let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(reportButton)
        alert.addAction(cancelButton)
        return alert
    }
    
    func photoUploadAlert(_ viewController: UIViewController) -> UIAlertController {
        let alert = UIAlertController(title: "",
                                      message: "최소 한 장의 사진을 올려주세요.",
                                      preferredStyle: .alert)
        let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okButton)
        return alert
    }
    
    func noPhotoChangeAllowed(_ viewController: UIViewController) -> UIAlertController {
        let alert = UIAlertController(title: "", message: "사진은 수정할 수 없댜규!",
                                      preferredStyle: .alert)
        let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okButton)
        return alert
    }
    
    func leavingPostPage(_ viewController: UIViewController) -> UIAlertController {
        let alert = UIAlertController(title: "이 페이지를 벗어날거야?",
                                      message: "지금까지 작성한\n글들은 저장되지 않아…!",
                                      preferredStyle: .alert)
        let noButton = UIAlertAction(title: "아니오", style: .default, handler: nil)
        let yesButton = UIAlertAction(title: "예", style: .destructive) { _ in
            viewController.dismiss(animated: true, completion: nil)
        }
        alert.addAction(noButton)
        alert.addAction(yesButton)
        return alert
    }
    
    func pleaseLogin(_ viewController: UIViewController) -> UIAlertController {
        let alert = UIAlertController(title: "회원가입 후 이용해주세요",
                                      message: "가입하면 더 많은 서비스를\n이용할 수 있어요",
                                      preferredStyle: .alert)
        let noButton = UIAlertAction(title: "계속 둘러보기", style: .cancel, handler: nil)
        let yesButton = UIAlertAction(title: "회원가입하기", style: .default) { _ in
            let controller = UINavigationController(rootViewController: LoginViewController())
            controller.modalPresentationStyle = .fullScreen
            viewController.present(controller, animated: true) {
                // 랭킹뷰에서 메인으로 이동!
                viewController.navigationController?.popViewController(animated: true)
            }
        }
        alert.addAction(noButton)
        alert.addAction(yesButton)
        return alert
    }
    
}

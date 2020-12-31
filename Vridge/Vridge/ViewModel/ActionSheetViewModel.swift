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
        let amendButton = UIAlertAction(title: amendTitle, style: .default) { _ in
            // amend service
            PostService.shared.amendPost(post: post) { posts in
                let controller = PostingViewController(config: .amend(post), post: post)
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                viewController.present(nav, animated: true, completion: nil)
            }
        }
        let deleteButton = UIAlertAction(title: deleteButtonTitle, style: .destructive) { _ in
            let deleteAlert = UIAlertController(title: deleteAlertTitle,
                                                message: deleteAlertMessage,
                                                preferredStyle: .alert)
            let noButton = UIAlertAction(title: no, style: .default, handler: nil)
            let okButton = UIAlertAction(title: yes, style: .destructive) { _ in
                // delete service
                PostService.shared.deletePost(row: row, viewController: viewController, postId: post.postID) { (err, ref) in
                    delegate?.updateUser()
                    viewController.numberOfPosts()
                    viewController.fetchPosts()
                }
            }
            deleteAlert.addAction(noButton)
            deleteAlert.addAction(okButton)
            viewController.present(deleteAlert, animated: true, completion: nil)
        }
        let cancelButton = UIAlertAction(title: cancel, style: .cancel, handler: nil)
        alert.addAction(amendButton)
        alert.addAction(deleteButton)
        alert.addAction(cancelButton)
        return alert
    }
    
    func reportActionSheet(_ viewController: HomeViewController, post: Post, row: Int) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let reportButton = UIAlertAction(title: reportButtonTitle, style: .default) { _ in
            let alert = UIAlertController(title: reasonToReportTitle, message: nil, preferredStyle: .actionSheet)
            let sexualHarass = UIAlertAction(title: sexualHarassTitle, style: .default) { _ in
                reportPost(post: post, viewController: viewController, row: row)
            }
            let swear = UIAlertAction(title: swearTitle, style: .default) { _ in
                reportPost(post: post, viewController: viewController, row: row)
            }
            let fraud = UIAlertAction(title: fraudTitle, style: .default) { _ in
                reportPost(post: post, viewController: viewController, row: row)
            }
            let advertise = UIAlertAction(title: advertiseTitle, style: .default) { _ in
                reportPost(post: post, viewController: viewController, row: row)
            }
            let nonsense = UIAlertAction(title: nonsenseTitle, style: .default) { _ in
                reportPost(post: post, viewController: viewController, row: row)
            }
            let cancelButton = UIAlertAction(title: cancel, style: .cancel, handler: nil)
            alert.addAction(sexualHarass)
            alert.addAction(swear)
            alert.addAction(fraud)
            alert.addAction(advertise)
            alert.addAction(nonsense)
            alert.addAction(cancelButton)
            viewController.present(alert, animated: true, completion: nil)
        }
        let cancelButton = UIAlertAction(title: cancel, style: .cancel, handler: nil)
        alert.addAction(reportButton)
        alert.addAction(cancelButton)
        return alert
    }
    
    func reportPost(post: Post, viewController: HomeViewController, row: Int) {
        PostService.shared.reportPost(post: post) { (err, ref) in
            viewController.showReportAlert()
            viewController.loadMore(row: row)
            viewController.tableView.scrollToRow(at: IndexPath(row: row, section: 0), at: .bottom, animated: true)
            print("DEBUG: row === \(row)")
        }
    }
    
    func photoUploadAlert(_ viewController: UIViewController) -> UIAlertController {
        let alert = UIAlertController(title: "",
                                      message: minimumOnePhotoMsg,
                                      preferredStyle: .alert)
        let okButton = UIAlertAction(title: confirm, style: .default, handler: nil)
        alert.addAction(okButton)
        return alert
    }
    
    func noPhotoChangeAllowed(_ viewController: UIViewController) -> UIAlertController {
        let alert = UIAlertController(title: "", message: noPhotoChangeMsg,
                                      preferredStyle: .alert)
        let okButton = UIAlertAction(title: confirm, style: .default, handler: nil)
        alert.addAction(okButton)
        return alert
    }
    
    func leavingPostPage(_ viewController: UIViewController) -> UIAlertController {
        let alert = UIAlertController(title: leavePageTitle,
                                      message: leavePageMsg,
                                      preferredStyle: .alert)
        let noButton = UIAlertAction(title: no, style: .default, handler: nil)
        let yesButton = UIAlertAction(title: yes, style: .destructive) { _ in
            viewController.dismiss(animated: true, completion: nil)
        }
        alert.addAction(noButton)
        alert.addAction(yesButton)
        return alert
    }
    
    func pleaseLogin(_ viewController: UIViewController) -> UIAlertController {
        let alert = UIAlertController(title: pleaseLoginTitle,
                                      message: pleaseLoginMsg,
                                      preferredStyle: .alert)
        let noButton = UIAlertAction(title: keepBrowsing, style: .cancel, handler: nil)
        let yesButton = UIAlertAction(title: signUp, style: .default) { _ in
            let controller = UINavigationController(rootViewController: IntroViewController())
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

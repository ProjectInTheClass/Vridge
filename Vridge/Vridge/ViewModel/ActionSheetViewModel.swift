//
//  ActionSheetViewModel.swift
//  Vridge
//
//  Created by Kang Mingu on 2020/10/13.
//

import UIKit

struct ActionSheetViewModel {
    
    func amendActionSheet(_ viewController: UIViewController) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let amendButton = UIAlertAction(title: "수정하기", style: .default) { _ in
            print("DEBUG: 수정하기로 이동")
        }
        let deleteButton = UIAlertAction(title: "삭제하기", style: .destructive) { _ in
            let deleteAlert = UIAlertController(title: "정말 삭제할까?",
                                                message: "게시글을 삭제하면\n이전으로 되돌릴 수 없어…!",
                                                preferredStyle: .alert)
            let noButton = UIAlertAction(title: "아니오", style: .default, handler: nil)
            let okButton = UIAlertAction(title: "예", style: .destructive) { _ in
                print("DEBUG: 삭제 처리")
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
    
    func reportActionSheet(_ viewController: HomeViewController) -> UIAlertController {
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
    
}

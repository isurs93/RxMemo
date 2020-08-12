//
//  ScenCoordinator.swift
//  RxMemo
//
//  Created by 박성주 on 2020/07/14.
//  Copyright © 2020 박성주. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

// DetailView 부분 작업하면서 추가함
extension UIViewController {
    var scenecViewController: UIViewController {
        return self.children.first ?? self
    }
}

class SceneCoordinator: SceneCoordinatorType {
    private let bag = DisposeBag()
    
    private var window: UIWindow
    private var currentVC: UIViewController
    
    required init(window: UIWindow) {
        self.window = window
        currentVC = window.rootViewController!
    }
    
    // PublishSubject를 이용한 방식
    @discardableResult
    func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> Completable {
        let subject = PublishSubject<Void>()
        
        let target = scene.instantiate()
        
        switch style {
        case .root:
            currentVC = target.scenecViewController
            window.rootViewController = target
            subject.onCompleted()
            
        case .push:
            print(currentVC)
            guard let nav = currentVC.navigationController else {
                subject.onError(TransitionError.navigationControllerMissing)
                break
            }
            
            // 기본 네비게이션 버튼을 이용하여 DetailView 화면 전환을 위해 추가
            nav.rx.willShow
                .subscribe(onNext: { [unowned self] evt in
                    self.currentVC = evt.viewController.scenecViewController
                })
                .disposed(by: bag)
            //
            
            nav.pushViewController(target, animated: animated)
            currentVC = target.scenecViewController
            subject.onCompleted()
            
        case .modal:
            currentVC.present(target, animated: animated) {
                subject.onCompleted()
            }
            currentVC = target.scenecViewController
        }
        
        return subject.ignoreElements()
    }
    
    // Completable을 직접 생성하여 사용하는 방식
    @discardableResult
    func close(animated: Bool) -> Completable {
        return Completable.create { [unowned self] completable in
            if let presentingVC = self.currentVC.presentingViewController {
                self.currentVC.dismiss(animated: animated) {
                    self.currentVC = presentingVC.scenecViewController
                    completable(.completed)
                }
            }
            else if let nav = self.currentVC.navigationController {
                guard  nav.popViewController(animated: animated) != nil else {
                    return Disposables.create()
                }
                self.currentVC = nav.viewControllers.last!
                completable(.completed)
            }
            else {
                completable(.error(TransitionError.unknown))
            }
            
            return Disposables.create()
        }
    }
}

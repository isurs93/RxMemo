//
//  SceneCoordinatorType.swift
//  RxMemo
//
//  Created by 박성주 on 2020/07/14.
//  Copyright © 2020 박성주. All rights reserved.
//

import Foundation
import RxSwift

protocol SceneCoordinatorType {
    
    // 새로운 Scene을 표시
    @discardableResult
    func transition(to scene: Scene, using style: TransitionStyle, animated: Bool)
        -> Completable
    
    // 현재 Scene을 닫고 이전 Scene으로 돌아감
    @discardableResult
    func close(animated: Bool) -> Completable
}

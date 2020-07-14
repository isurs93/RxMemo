//
//  ViewModelBindableType.swift
//  RxMemo
//
//  Created by 박성주 on 2020/07/14.
//  Copyright © 2020 박성주. All rights reserved.
//

import UIKit

// 프토토콜을 제네릭 프로토콜로 설정 -> 모델마다 타입이 달라지므로
protocol ViewModelBindableType {
    associatedtype ViewModelType
    
    var viewModel: ViewModelType! { get set }
    func bindViewModel()
}

// 프로토콜 익스텐션 추가
extension ViewModelBindableType where Self: UIViewController {
    // viewModel 속성의 viewModel을 실제로 저장하고
    // bindViewModel()을 자동으로 호출하는 메소드
    mutating func bind(viewModel: Self.ViewModelType) {
        self.viewModel = viewModel
        loadViewIfNeeded()
        
        bindViewModel()
    }
}

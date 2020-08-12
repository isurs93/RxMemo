//
//  MemoListViewModel.swift
//  RxMemo
//
//  Created by 박성주 on 2020/07/14.
//  Copyright © 2020 박성주. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

// 메모 목록 화면 모델
class MemoListViewModel: CommonViewModel{
    var memoList: Observable<[Memo]> {
        return storage.memoList()
    }
}

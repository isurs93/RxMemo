//
//  MemoryStorage.swift
//  RxMemo
//
//  Created by 박성주 on 2020/07/14.
//  Copyright © 2020 박성주. All rights reserved.
//

import Foundation
import RxSwift

// 메모리에 메모를 저장하는 클래스
// reloadData로는 갱신이 되지 않고
// 계속 데이터 리스트를 방출 해줘야만 테이블 뷰에 갱신이 된다.
class MemoryStorage: MemoStorageType {
    private var list = [
        Memo(content: "Hello, RxSwift", insertDate: Date().addingTimeInterval(-10)),
        Memo(content: "으아잇차", insertDate: Date().addingTimeInterval(-20))
    ]

    // 배열은 Observable로 표시 Observable로 하면 액션을 취해야 함
    private lazy var store = BehaviorSubject<[Memo]>(value: list)
    
    @discardableResult
    func createMemo(content: String) -> Observable<Memo> {
        let memo = Memo(content: content)
        list.insert(memo, at: 0)
        store.onNext(list)
        return Observable.just(memo)
    }
    
    @discardableResult
    func memoList() -> Observable<[Memo]> {
        return store
    }
    
    @discardableResult
    func update(memo: Memo, content: String) -> Observable<Memo> {
        let updated = Memo(original: memo, updatedContent: content)
        
        if let index = list.firstIndex(where: { $0 == memo}) {
            list.remove(at: index)
            list.insert(updated, at: index)
        }
        store.onNext(list)
        return Observable.just(updated)
    }
    
    @discardableResult
    func delete(memo: Memo) -> Observable<Memo> {
        if let index = list.firstIndex(where: {$0 == memo}) {
            list.remove(at: index)
            store.onNext(list)
        }
        return Observable.just(memo)
    }
    
    
}

//
//  LanguageViewController.swift
//  GithubRxSample
//
//  Created by Alexander Krylov on 26/05/2020.
//  Copyright © 2020 Alexander Krylov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class LanguageViewController: UIViewController {
    
    weak var coordinator: MainCoordinator!
    var viewModel: LanguageViewModel!
    
    //MARK: Rx
    
    private let db = DisposeBag()
    
    //MARK: Outlets
    
    @IBOutlet private weak var languagePicker: UIPickerView!
    @IBOutlet private weak var confirmButton: ConfirmButton!
    
    //MARK: ViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        subscribe()
    }
}

//MARK: Subscriber

extension LanguageViewController: Subscriber {
    func subscribe() {
        viewModel.languages
            .bind(to: languagePicker.rx.itemTitles) { String($1) }
            .disposed(by: db)
        
        let tapEvent = confirmButton.rx.tap.share()
        
        tapEvent
            .map { [weak self] in
                guard let self = self else { return .zero }
                return self.languagePicker.selectedRow(inComponent: .zero)
            }.bind(to: viewModel.selectedRow)
            .disposed(by: db)
        
        tapEvent
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.coordinator.dismiss(self)
            }).disposed(by: db)
    }
}

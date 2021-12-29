//
//  CatViewController.swift
//  CatsAPI_MVVM
//
//  Created by Roman Gorshkov on 23.12.2021.
//

import UIKit
import Combine

class CatViewController: BaseViewController {
    
    private var viewModel: CatViewModel
    
    init(viewModel: CatViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchBreeds()
        setupBindables()
    }
    
    private func setupBindables() {
        viewModel.$cats
            .sink { [weak self] cats in
                if cats.count >= 20 {
                    self?.collectionView.reloadData()
                }
            }.store(in: &cancellables)
    }
    
    override func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.register(CatCell.self)
        view.addSubview(collectionView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.frame
    }
}

extension CatViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.catsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(cellType: CatCell.self, for: indexPath)
        if indexPath.row == viewModel.catsCount - 1, viewModel.catsCount < 47 {
            viewModel.fetchBreeds()
        }
        cell.update(with: viewModel.cat(at: indexPath.row))
        return cell
    }
}

extension CatViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewModel = viewModel.viewModelForSelectedRow(at: indexPath)
        let catDetailVC = CatDetailViewController(viewModel: detailViewModel)
        catDetailVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(catDetailVC, animated: true)
    }
}

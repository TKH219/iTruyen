//
//  BookPage.swift
//  iTruyen
//
//  Created by HanLTP on 4/18/19.
//  Copyright © 2019 HanLTP. All rights reserved.
//

import UIKit
import PDFKit

class BookPage: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {


    var arrView : [ReadPageVC] = []
    let arrColor : [UIColor] = [.red, .green, .purple, .cyan, .lightGray ]
    var isBarHidden = false
    var currentPage = 0
    let pageVC = UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: nil)

    var pdfDocument = PDFDocument()
    let thumbnail = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    let cellID = "PageCell"
    
    var urlString : String?
    var chapterName : String?
    var fileURL : URL?
    var status : Bool = false

    var allBookmark : [Bookmark]?
    var bookmark : Bookmark?
    var position : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

     
        view.backgroundColor = .white
        guard let newChapterName = chapterName else { return }
        self.navigationItem.title = newChapterName
        
        if status == false
        {
            guard let newUrlString = urlString else { return }
            let url : NSURL! = NSURL(string: newUrlString)
            update(url as URL, (bookmark?.currentPage![position!])!)
        } else {
            currentPage = (bookmark?.currentPage![position!])!
        }
        setupPageVC()
        loadPDF()
        
        if arrView.first != nil {
            pageVC.setViewControllers([arrView[currentPage]], direction: .forward, animated: true, completion: nil)
        }
        
        setupThumbnailView()
        
        pageVC.view.bottomAnchor.constraint(equalTo: thumbnail.topAnchor, constant: 0).isActive = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        pageVC.view.addGestureRecognizer(tap)
    }

    override func viewDidLayoutSubviews() {
        let currentIndexPath = IndexPath(item: currentPage, section: 0)
        thumbnail.scrollToItem(at: currentIndexPath, at: .centeredHorizontally, animated: true)
        thumbnail.selectItem(at: currentIndexPath, animated: true, scrollPosition: .centeredHorizontally)
    }

    func update(_ filePath : URL, _ onPage : Int) {
        fileURL = filePath
        currentPage = onPage
    }

    override func viewWillDisappear(_ animated: Bool) {
    }

    @objc func handleTap() {
        if isBarHidden == false {
            navigationController?.setNavigationBarHidden(true, animated: true)
            isBarHidden = true
            thumbnail.constraints[0].isActive = false
            thumbnail.heightAnchor.constraint(equalToConstant: 0).isActive = true
            view.layoutIfNeeded()
        }
        else {
            navigationController?.setNavigationBarHidden(false, animated: true)
            isBarHidden = false
            thumbnail.constraints[0].isActive = false
            thumbnail.heightAnchor.constraint(equalToConstant: 60).isActive = true
            view.layoutIfNeeded()
        }
    }

    func loadPDF() {
        pdfDocument = PDFDocument(url: fileURL!)!

        for index in 0..<pdfDocument.pageCount {
            let subView = ReadPageVC()
            subView.pdfDocument.insert(pdfDocument.page(at: index)!, at: 0)
            arrView.append(subView)
        }
    }

    fileprivate func setupPageVC() {
        addChild(pageVC)
        view.addSubview(pageVC.view)
        pageVC.didMove(toParent: self)

        pageVC.dataSource = self
        pageVC.delegate = self

        pageVC.view.translatesAutoresizingMaskIntoConstraints = false

        pageVC.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        pageVC.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        pageVC.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        
    }

    func setupThumbnailView() {
        view.addSubview(thumbnail)

        let layout : UICollectionViewFlowLayout = {
            let l = UICollectionViewFlowLayout()
            l.scrollDirection = .horizontal
            l.minimumLineSpacing = 20
            l.minimumInteritemSpacing = 10
            return l
        }()

        thumbnail.translatesAutoresizingMaskIntoConstraints = false
        thumbnail.showsVerticalScrollIndicator = false
        thumbnail.showsHorizontalScrollIndicator = false
        thumbnail.backgroundColor = pageVC.view.backgroundColor
        thumbnail.setCollectionViewLayout(layout, animated: true)

        thumbnail.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        thumbnail.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        thumbnail.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        thumbnail.heightAnchor.constraint(equalToConstant: 60).isActive = true

        thumbnail.dataSource = self
        thumbnail.delegate = self
        thumbnail.register(PageCell.self, forCellWithReuseIdentifier: cellID)
    }

}

protocol BookPageDelegate {
    func getCurrentPage(currentPage : Int) -> Int
}

extension BookPage {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrView.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = thumbnail.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! PageCell
        cell.updateCell(arrView[indexPath.row].pdfDocument.page(at: 0)!, indexPath.row)
        cell.alpha = 0.3
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 30, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 5)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if currentPage < indexPath.row {
            currentPage = indexPath.row
            pageVC.setViewControllers([arrView[currentPage]], direction: .forward, animated: true, completion: nil)
        }
        else if currentPage > indexPath.row {
            currentPage = indexPath.row
            pageVC.setViewControllers([arrView[currentPage]], direction: .reverse, animated: true, completion: nil)
        }
        
        thumbnail.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        bookmark?.currentPage![position!] = currentPage
        Bookmark.setData(bookmark: allBookmark!)
    }
}

extension BookPage {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = arrView.index(of : viewController as! ReadPageVC) else {
            return nil
        }

        let prevIndex = vcIndex - 1

        guard prevIndex >= 0 else {
            return nil
        }

        guard prevIndex < arrView.count else {
            return nil
        }

        currentPage = prevIndex
        
        bookmark?.currentPage![position!] = prevIndex
        Bookmark.setData(bookmark: allBookmark!)

        return arrView[prevIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = arrView.index(of : viewController as! ReadPageVC) else {
            return nil
        }

        let nextIndex = vcIndex + 1

        guard nextIndex != arrView.count else {
            return nil
        }

        guard nextIndex < arrView.count else {
            return nil
        }

        currentPage = nextIndex
        
        bookmark?.currentPage![position!] = nextIndex
        Bookmark.setData(bookmark: allBookmark!)

        return arrView[nextIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentVC = pageViewController.viewControllers![0]
        if let index = arrView.index(of: pageContentVC as! ReadPageVC) {
            currentPage = index
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, didUpdateIndex index : Int) {

    }
}

//
//  ImagesViewController.swift
//  UI Task
//
//  Created by Hamad Hamad on 03/10/2022.
//

import Cocoa

class ImagesViewController: NSViewController {
    
    @IBOutlet weak var collectionView: NSCollectionView!
    let nib = NSNib(nibNamed: "CollectionViewItem", bundle: nil)
    let collectionItemIdenrifier: NSUserInterfaceItemIdentifier = NSUserInterfaceItemIdentifier(rawValue: "collectionItemIdenrifier")
    let thumbnailSize = NSSize(width: 130.0, height: 130.0)
    var photos = [[PhotoInfo(with: "autumn-gf6b20960a_1920"), PhotoInfo(with: "coconut-tree-g719fd7b4e_1280"), PhotoInfo(with: "png-g424aa618e_1920"),PhotoInfo(with: "crocus-gef52229b8_1280"), PhotoInfo(with: "poppy-g57dfbc1a3_1920")]]
    //var photos = [[PhotoInfo(with: "autumn-gf6b20960a_1920"), PhotoInfo(with: "coconut-tree-g719fd7b4e_1280"), PhotoInfo(with: "png-g424aa618e_1920")],[PhotoInfo(with: "crocus-gef52229b8_1280"), PhotoInfo(with: "poppy-g57dfbc1a3_1920")]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        createThumbnails()
    }
    
    func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.enclosingScrollView?.borderType = .noBorder
        collectionView.register(nib, forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "collectionItemIdenrifier"))
        configureGridLayout()
    }
    
    func configureGridLayout() {
        let gridLayout = NSCollectionViewGridLayout()
        gridLayout.minimumInteritemSpacing = 135.0
        gridLayout.minimumLineSpacing = 30.0
        //flowLayout.itemSize = NSSize(width: 150.0, height: 150.0)
        gridLayout.maximumNumberOfRows = 3
        gridLayout.maximumNumberOfColumns = 3
        gridLayout.minimumItemSize = NSSize(width: 150.0, height: 150.0)
        gridLayout.maximumItemSize = NSSize(width: 150.0, height: 150.0)
        collectionView.collectionViewLayout = gridLayout
    }
    
    
    func getProcessedPhotos() {
        if photos.count > 0 {
            self.photos[self.photos.count - 1] = PhotoHelper.shared.photosToProcess
        }
    }
    
    func createThumbnails() {
        guard let recentPhotos = photos.last else { return }
        PhotoHelper.shared.createThumbnails(for: recentPhotos, desiredSize: thumbnailSize, progress: { (currentPhoto) in
        }) { () in
            //for i in 0..<5 {
            DispatchQueue.main.async {
                self.getProcessedPhotos()
                self.collectionView.enclosingScrollView?.contentView.scroll(to:
                                                                                NSPoint(x: 0.0, y: self.collectionView.collectionViewLayout?.collectionViewContentSize.height ?? 0.0))
                //}
            }
        }
        
    }
}

extension ImagesViewController: NSCollectionViewDataSource {
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos[section].count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        guard let item = collectionView.makeItem(withIdentifier: collectionItemIdenrifier, for: indexPath) as? CollectionViewItem else { return NSCollectionViewItem() }
        item.imageView?.image = photos[indexPath.section][indexPath.item].thumbnail
        print(indexPath.section, indexPath.item)
        return item
    }
}

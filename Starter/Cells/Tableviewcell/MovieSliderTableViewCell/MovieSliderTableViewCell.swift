//
//  MovieSliderTableViewCell.swift
//  Starter
//
//  Created by KC on 09/02/2022.
//

import UIKit

class MovieSliderTableViewCell: UITableViewCell {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionViewMovie: UICollectionView!
    
    weak var delegate:MovieItemDelegate?=nil

    var contentType: String = ""
    
    var data : [MovieResult]?{
        didSet{
            if let data = data {
                pageControl.numberOfPages = data.count 
                collectionViewMovie.reloadData()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        registerCollectionViewCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func registerCollectionViewCell(){
        collectionViewMovie.dataSource = self
        collectionViewMovie.delegate = self
        collectionViewMovie.registerForCell(identifier: MovieSliderCollectionViewCell.identifier)
        pageControl.addTarget(self, action: #selector(self.pageControlSelectionAction(_:)), for: .touchUpInside)
    }
    
    @IBAction func pageControlSelectionAction(_ sender: UIPageControl) {
        let page: Int? = sender.currentPage
        var frame: CGRect = self.collectionViewMovie.frame
        frame.origin.x = frame.size.width * CGFloat(page ?? 0)
        frame.origin.y = 0
        self.collectionViewMovie.scrollRectToVisible(frame, animated: true)
    }
}

extension MovieSliderTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueCell(identifier: MovieSliderCollectionViewCell.identifier, indexPath: indexPath) as MovieSliderCollectionViewCell
        
        cell.data = data?[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: CGFloat(240))
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item  =  data?[indexPath.row]
        delegate?.onTapMovie(id: item?.id ?? 0, type: contentType)
    }
    
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}

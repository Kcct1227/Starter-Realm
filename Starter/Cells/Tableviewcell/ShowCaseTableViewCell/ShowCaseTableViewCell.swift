//
//  ShowCaseTableViewCell.swift
//  Starter
//
//  Created by KC on 11/02/2022.
//

import UIKit

class ShowCaseTableViewCell: UITableViewCell {

   
    @IBOutlet weak var collectionViewShowCases: UICollectionView!
    @IBOutlet weak var lblShowCase: UILabel!
    @IBOutlet weak var lblMoreShowCases: UILabel!
    @IBOutlet weak var heightCollectionViewShowCases: NSLayoutConstraint!
    
    weak var delegate: MovieItemDelegate?=nil
    var moreShowCaseDelegate : MoreShowCaseDelegate? = nil

    var contentType: String = ""

    
    var data: [MovieResult]? {
        didSet{
            if let _ = data {
                lblMoreShowCases.isUserInteractionEnabled = true
                collectionViewShowCases.reloadData()
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        lblMoreShowCases.underLineText(text: "MORE SHOWCASES")
        registerCollectionViewCell()
        
        let itemWidth: CGFloat = collectionViewShowCases.frame.width - 50
        let itemHeight: CGFloat = (itemWidth / 16) * 9
        heightCollectionViewShowCases.constant =  itemHeight
        
        lblMoreShowCases.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapShowCases)))
        
    }
    
    @objc func onTapShowCases(){
        moreShowCaseDelegate?.onTapMoreShowCases(data: data!)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func registerCollectionViewCell(){
        collectionViewShowCases.dataSource = self
        collectionViewShowCases.delegate = self
        collectionViewShowCases.registerForCell(identifier: ShowCaseCollectionViewCell.identifier)
    }
    
}

extension ShowCaseTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueCell(identifier: ShowCaseCollectionViewCell.identifier, indexPath: indexPath) as ShowCaseCollectionViewCell
        cell.data = data?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemWidth: CGFloat = collectionView.frame.width - 50
        let itemHeight: CGFloat = (itemWidth / 16) * 9
                
        return CGSize(width: itemWidth, height: itemHeight)
        //return CGSize(width: collectionView.frame.width - 50, height: CGFloat(180))
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        ((scrollView.subviews[(scrollView.subviews.count-1)]).subviews[0]).backgroundColor = UIColor(named: "color_yellow")
        
        // vertical indicator (minus 20)
        // ((scrollView.subviews[(scrollView.subviews.count-1)]).subviews[0]).backgroundColor = UIColor(named: "color_yellow")
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item  =  data?[indexPath.row]
        delegate?.onTapMovie(id: item?.id ?? 0, type: contentType)
    }
    
}

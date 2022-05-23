//
//  GenereTableViewCell.swift
//  Starter
//
//  Created by KC on 10/02/2022.
//

import UIKit

class GenereTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionViewMovie: UICollectionView!
    @IBOutlet weak var collectionViewGenere: UICollectionView!

    var contentType: String = ""

    var genreList: [GenreVO]? {
        didSet{
            if let _ = genreList {
                collectionViewGenere.reloadData()
                
                genreList?.removeAll(where: { (genreVo) -> Bool in
                    let genreID = genreVo.id
                    let results = movieListByGenre.filter { (key, value) -> Bool in
                        genreID == key
                    }
                    
                    return results.count == 0
                })

            }
            onTapGenre(genreId: genreList?.first?.id ?? 0)

        }
    }
    
    var allMoviesAndSeries : [MovieResult] = []{
        didSet{
            // computation
            allMoviesAndSeries.forEach { (movieSereis) in
                movieSereis.genreIDS?.forEach({ (genreId) in
                    let key = genreId // 12 -> nil
                    /*
                     first time -> 12 -> nil -> [MovieResult] () -> 12 = [MovieResult]
                     second time -> 12 -> [MovieRsult] -> .append(newMovieData)
                     third tiem..
                     fourth time .....
                     nth time ....
                     */
                    
                    if var _ = movieListByGenre[key]{
                        movieListByGenre[key]!.insert(movieSereis)
                    }else{
                        movieListByGenre[key] = [movieSereis]
                    }
                })
            }

        }
    }
    
    private var selectedMovieList: [MovieResult] = []
    private var movieListByGenre : [Int : Set<MovieResult>] = [ : ]
    
    /**
        let movieListKeyValuePair : [MovieGenreID : [MovieResult] ]
         14 -> movieList
          19 -> movieList
     **/
    
    weak var delegate : MovieItemDelegate?=nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        registerCollectionViewCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func registerCollectionViewCell(){
        collectionViewGenere.dataSource = self
        collectionViewGenere.delegate = self
        collectionViewGenere.registerForCell(identifier: GenreCollectionViewCell.identifier)
        
        collectionViewMovie.dataSource = self
        collectionViewMovie.delegate = self
        collectionViewMovie.registerForCell(identifier: PopularFilmCollectionViewCell.identifier)
   
    }
    
}

extension GenereTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == collectionViewMovie{
            return selectedMovieList.count
        }
        else{
            return genreList?.count  ?? 0
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewMovie{
            let cell =  collectionView.dequeueCell(identifier: PopularFilmCollectionViewCell.identifier, indexPath: indexPath) as PopularFilmCollectionViewCell
            
            cell.data = selectedMovieList[indexPath.row]
            
            
            return cell
        }
        else{
            let cell = collectionView.dequeueCell(identifier: GenreCollectionViewCell.identifier, indexPath: indexPath) as GenreCollectionViewCell
            cell.data = genreList?[indexPath.row] // data binding
            cell.onTapItem  = { genreId in
                self.onTapGenre(genreId: genreId)
            }
            
            return cell
        }
        
    }
    
    private func onTapGenre(genreId: Int){
        
        
        self.genreList?.forEach{ (genreVo) in
            if genreId == genreVo.id{
                genreVo.isSelected = true
            }
            else{
                genreVo.isSelected = false
            }
        }
        
        
        let movieList = self.movieListByGenre[genreId]
        self.selectedMovieList = movieList?.map{ $0 } ?? [MovieResult] ()
        
        self.collectionViewMovie.reloadData()
        self.collectionViewGenere.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == collectionViewMovie{
            let itemWidth : CGFloat = 120
            let itemHeight : CGFloat = collectionView.frame.height

            return CGSize(width: itemWidth, height: itemHeight)
        }
        else{
            return CGSize(width: widthOfString(text: genreList?[indexPath.row].name ?? "", font: UIFont(name : "Geeza Pro Regular", size: 14) ?? UIFont.systemFont(ofSize: 14))+20, height: 45)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func widthOfString(text:String, font:UIFont)->CGFloat{
        let fontAttributes = [NSAttributedString.Key.font : font]
        let textSize  = text.size(withAttributes: fontAttributes)
        return textSize.width
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item  = self.selectedMovieList[indexPath.row]
        delegate?.onTapMovie(id: item.id ?? 0, type: contentType)
    }
    
}



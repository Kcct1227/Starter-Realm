//
//  MovieDetailViewController.swift
//  Starter
//
//  Created by ADMIN on 07/02/2022.
//

import UIKit
import YouTubePlayer
import RxCocoa
import RxDataSources
import RxSwift
import CoreData
import Combine

class MovieDetailViewController: UIViewController,ActorActionDelegate, MovieItemDelegate{
    
    //MARK: - IBOutlet
    @IBOutlet weak var stackViewTime: UIStackView!
    @IBOutlet weak var viewForVotes: UIView!
    @IBOutlet weak var imgBookMark: UIImageView!
    @IBOutlet weak var labelStoryLine: UILabel!
    @IBOutlet weak var collectionViewCompanies: UICollectionView!
    @IBOutlet weak var imageProfileHeigtContraint: NSLayoutConstraint!
    @IBOutlet weak var labelSimilar : UILabel!
    @IBOutlet weak var viewForActor : UIView!
    @IBOutlet weak var viewForCompany: UIView!
    @IBOutlet weak var viewForAbout: UIView!
    @IBOutlet weak var viewForSimlarContent : UIView!
    @IBOutlet weak var collectionViewSimilarContents: UICollectionView!
    @IBOutlet weak var collectionViewActors: UICollectionView!
    @IBOutlet weak var btnRateMovie: UIButton!
    @IBOutlet weak var labelReleasedYear : UILabel!
    @IBOutlet weak var labelMovieTitle : UILabel!
    @IBOutlet weak var labelDuraton : UILabel!
    @IBOutlet weak var labelMovieDescription : UILabel!
    @IBOutlet weak var labelRating : UILabel!
    @IBOutlet weak var viewRatingCount : RatingControl!
    @IBOutlet weak var labelVoteCount : UILabel!
    @IBOutlet weak var labelAboutMovieTitle : UILabel!
    @IBOutlet weak var labelGenreString : UILabel!
    @IBOutlet weak var labelProductionCountry : UILabel!
    @IBOutlet weak var labelAboutMovieDescription : UILabel!
    @IBOutlet weak var labelRelaeaseDate : UILabel!
    @IBOutlet weak var imageViewMoviePoster : UIImageView!
    @IBOutlet weak var buttonPlay : UIButton!
    @IBOutlet weak var ivBack: UIImageView!

    
    //MARK: - Property
    private let disposeBag = DisposeBag()
    private var productionCompanies : [ProductionCompany] = []
    
    //private var objects = Array.init(repeating: "Hello", count: 10000000)
    
    var viewModel : MovieDetailViewModelType!
    private var cancellables = Set<AnyCancellable>()


    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
   
        
        initView()
        bindViewState()

        viewModel.setupData()
        viewModel.fetchDetails()
        addCollectionViewCastsBindingObserver()
        addCastItemSelectedObserver()
        addSimilarMoiveItemSelectedObserver()
        similarMovieCollectionViewBindingObserver()


            
    }
    
    private func bindViewState(){
        viewModel.viewState
            .eraseToAnyPublisher()
            .print()
            .sink{ [weak self] (state) in
                guard let self = self else { return }
                switch state {
                case .addedBookMark:
                    self.imgBookMark.image = UIImage(systemName: "bookmark.fill")
                    break
                case .removeBookMark:
                    self.imgBookMark
                        .image = UIImage(systemName: "bookmark")
                    break
                case .bindActorData(let data):
                    self.bindActorData(data: data)
                case .bindMovieData(let data):
                    self.bindData(data: data)
                case .bindSeriesData(let data):
                    self.bindSeriesData(data: data)
                }
            }.store(in: &cancellables)
    }

   
    
    deinit{
        print("This object is released!")
        viewModel.deinitFetchController()

    }
        
    //MARK: - Init View
    private func initView(){
        initGestureRecoginizer()
        btnRateMovie.layer.borderColor =   UIColor.white.cgColor
        btnRateMovie.layer.borderWidth = 2
        btnRateMovie.layer.cornerRadius = 20
        imgBookMark.isUserInteractionEnabled = true
        imgBookMark.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapBookMark)))
        registerCollectionViewCell()
        
    }
    
    @objc func onTapBookMark(){
        viewModel.toggleWatched()
    }
    
 
    @IBAction func onClickPlayTrailer(_ sender : UIButton){
        if viewModel.type == ContentType.ActorType.rawValue{
            if let dataURL = URL(string: "https://www.google.com") {
                UIApplication.shared.open(dataURL)
            }
        }
        else{
            let item = viewModel.movieTrailers.first
            let youtubeId = item?.key
            let playerVC = YouTubePlayerViewController()
            playerVC.youtubeId = youtubeId
            self.present(playerVC, animated: true, completion: nil)
        }

    }
    
    func onTapMovie(id: Int, type: String) {
        navigateToMovieDetailViewController(movieId: viewModel.movieID, contentType: viewModel.type)

    }

    
    private func addCollectionViewCastsBindingObserver() {
        // Bind Data to collection view cell
        viewModel.movieCasts
            .bind(to: collectionViewActors.rx.items(
                    cellIdentifier: String(describing: ActorCollectionViewCell.self),
                    cellType: ActorCollectionViewCell.self))
            { [weak self] (row, element, cell) in
                guard let self = self else { return }

                cell.delegate = self
                let item: MovieCast = element
                cell.data = item.convertToActorInfoResponse()

            }
            .disposed(by: disposeBag)
    }
    
    private func addCastItemSelectedObserver() {
        // On Item Selected
        collectionViewActors.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                let items = try! self.viewModel.movieCasts.value()
                let item = items[indexPath.row]

                self.navigateToMovieDetailViewController(movieId: item.id ?? 0, contentType: ContentType.ActorType.rawValue)

            })
            .disposed(by: disposeBag)
    }
    
    private func similarMovieCollectionViewBindingObserver() {
        // Bind Data to collection view cell
        viewModel.similarMovies
            .bind(to: collectionViewSimilarContents.rx.items(
                    cellIdentifier: String(describing: PopularFilmCollectionViewCell.self),
                    cellType: PopularFilmCollectionViewCell.self))
            {  (row, element, cell) in
                cell.data = element

            }
            .disposed(by: disposeBag)
    }
    
    private func addSimilarMoiveItemSelectedObserver() {
        // On Item Selected
        collectionViewSimilarContents.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                let items = try! self.viewModel.similarMovies.value()
                let item = items[indexPath.row]
                self.navigateToMovieDetailViewController(movieId: item.id ?? 0, contentType: item.media_type ?? ContentType.MovieType.rawValue)

            })
            .disposed(by: disposeBag)
    }



    
  
    // MARK: - Register Collection Cell
    private func registerCollectionViewCell(){
        collectionViewActors.delegate = self
        collectionViewActors.registerForCell(identifier: ActorCollectionViewCell.identifier)
        collectionViewActors.showsHorizontalScrollIndicator = false
        collectionViewActors.showsVerticalScrollIndicator = false
        
        collectionViewSimilarContents.delegate = self
        collectionViewSimilarContents.registerForCell(identifier: PopularFilmCollectionViewCell.identifier)
        collectionViewSimilarContents.showsHorizontalScrollIndicator = false
        collectionViewSimilarContents.showsVerticalScrollIndicator = false

        
        collectionViewCompanies.dataSource = self
        collectionViewCompanies.delegate = self
        collectionViewCompanies.registerForCell(identifier: ProductionCompainiesCell.identifier)
        collectionViewCompanies.showsHorizontalScrollIndicator = false
        collectionViewCompanies.showsVerticalScrollIndicator = false

    }
    
    // MARK: - Bind Data
    private func bindActorData(data: ActorDetailResponse){
        
        let posterPath =  "\(AppConstants.baseImageUrl)/\(data.profilePath ?? "")"
        imageViewMoviePoster.sd_setImage(with: URL(string: posterPath))
        
        labelReleasedYear.text = data.birthday ?? ""
        labelMovieTitle.text = data.name
        labelMovieDescription.text = data.biography ?? ""
        labelRating.text = ""
        self.navigationItem.title = data.name
        
        stackViewTime.isHidden = true
        viewForActor.isHidden = true
        viewForCompany.isHidden = true
        viewForAbout.isHidden = true
        viewForVotes.isHidden = true
        btnRateMovie.isHidden = true
        
        labelSimilar.text = "TV Credits"
        labelStoryLine.text = "BIOGRAPHY"
        
        let screenSize: CGRect = UIScreen.main.bounds
        imageProfileHeigtContraint.constant = screenSize.height * 3/5
        
        buttonPlay.setTitle("Read More", for: .normal)
        buttonPlay.setImage(UIImage(named: "navigator.png"),for: .normal)
        //url = data.homepage ?? ""
        
        imgBookMark.isHidden = true
        
        

    }
    
    private func bindSeriesData(data: SeriesDetailResponse){
        
        productionCompanies = data.productionCompanies ?? [ProductionCompany]()
        if productionCompanies.count > 0 {
            viewForCompany.isHidden = false
            collectionViewCompanies.reloadData()
        }else{
            viewForCompany.isHidden = true
        }
        
        let posterPath =  "\(AppConstants.baseImageUrl)/\(data.backdropPath ?? "")"
        imageViewMoviePoster.sd_setImage(with: URL(string: posterPath))
        
        
        let releasedYear = data.firstAirDate ?? ""
        if releasedYear.isEmpty{
            labelReleasedYear.text = ""
        }
        else{
            labelReleasedYear.text = String(releasedYear.split(separator: "-")[0])
        }
        labelMovieTitle.text = data.originalName
        labelMovieDescription.text = data.overview
        self.navigationItem.title = data.originalName

        if data.episodeRunTime?.count == 0{
            labelDuraton.text = ""
        }
        else{
            let runTime = data.episodeRunTime
            labelDuraton.text = "\(String(runTime?[0] ?? 0)) mins"
        }
        
        labelRating.text = "\(data.voteAverage ?? 0.0)"
        viewRatingCount.rating = Int((data.voteAverage ?? 0) * 0.5)
        labelVoteCount.text = "\(data.voteCount ?? 0) votes"
        labelAboutMovieTitle.text = data.originalName
        
        var genreListStr = ""
        data.genres?.forEach({ (item) in
            genreListStr += "\(item.name ), "
        })
        if genreListStr.isEmpty{
            labelGenreString.text = ""
        }else{
            genreListStr.removeLast()
            genreListStr.removeLast()
            labelGenreString.text = genreListStr
        }
        
        var countryListStr = ""
        data.productionCountries?.forEach({ (item) in
            countryListStr = "\(item.name ?? ""), "
        })
        
        if countryListStr.isEmpty{
            labelProductionCountry.text = ""
        }else{
            countryListStr.removeLast()
            countryListStr.removeLast()
            labelProductionCountry.text = countryListStr
        }
        
        labelAboutMovieDescription.text = data.overview
        labelRelaeaseDate.text = data.firstAirDate
        
        self.buttonPlay.isHidden = viewModel.movieTrailers.isEmpty && viewModel.type != ContentType.ActorType.rawValue

        
    }
    
    private func bindData(data: MovieDetailResponse){
        
        productionCompanies = data.productionCompanies ?? [ProductionCompany]()
        if productionCompanies.count > 0 {
            viewForCompany.isHidden = false
            collectionViewCompanies.reloadData()
        }else{
            viewForCompany.isHidden = true

        }
        
        let posterPath =  "\(AppConstants.baseImageUrl)/\(data.backdropPath ?? "")"
        imageViewMoviePoster.sd_setImage(with: URL(string: posterPath))

        let releasedYear = data.releaseDate ?? ""
        if releasedYear.isEmpty{
            labelReleasedYear.text = ""
        }
        else{
            labelReleasedYear.text = String(releasedYear.split(separator: "-")[0])
        }
        labelMovieTitle.text = data.originalTitle
        labelMovieDescription.text = data.overview
        self.navigationItem.title = data.originalTitle

        
        let runTimeHour = Int ((data.runtime ?? 0)  / 60)
        let runTimeMin = (data.runtime ?? 0) % 60
        labelDuraton.text = "\(runTimeHour) hr  \(runTimeMin) mins"
        
        labelRating.text = "\(data.voteAverage ?? 0.0)"
        viewRatingCount.rating = Int((data.voteAverage ?? 0) * 0.5)
        labelVoteCount.text = "\(data.voteCount ?? 0) votes"
        labelAboutMovieTitle.text = data.originalTitle
        
        var genreListStr = ""
        data.genres?.forEach({ (item) in
            genreListStr += "\(item.name ), "
        })
        if genreListStr.isEmpty{
            labelGenreString.text = ""
        }else{
            genreListStr.removeLast()
            genreListStr.removeLast()
            labelGenreString.text = genreListStr
        }
     
        var countryListStr = ""
        data.productionCountries?.forEach({ (item) in
            countryListStr = "\(item.name ?? ""), "
        })
        if countryListStr.isEmpty{
            labelProductionCountry.text = ""
        }else{
            countryListStr.removeLast()
            countryListStr.removeLast()
            labelProductionCountry.text = countryListStr
        }
       
        
        
        labelAboutMovieDescription.text = data.overview
        labelRelaeaseDate.text = data.releaseDate
                
        self.buttonPlay.isHidden = viewModel.movieTrailers.isEmpty && viewModel.type != ContentType.ActorType.rawValue

        
    }
    
    // MARK: - Tap Items
    private func initGestureRecoginizer(){
        let tapGestureForBack = UITapGestureRecognizer(target: self, action: #selector(onTapBack))
        
        ivBack.isUserInteractionEnabled = true
        ivBack.addGestureRecognizer(tapGestureForBack)
    }
    

    @objc func onTapBack(){
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    func onTapFavorite(isFavorite: Bool) {
        debugPrint("Favorite tap \(isFavorite)")
    }
    
   
   

}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension MovieDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewCompanies{
            return productionCompanies.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewCompanies{
            let cell = collectionView.dequeueCell(identifier: ProductionCompainiesCell.identifier, indexPath: indexPath) as ProductionCompainiesCell
            cell.data = productionCompanies[indexPath.row]
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        
        if collectionView == collectionViewCompanies {
            let itemWidth : CGFloat  = collectionView.frame.height
            let itemHeight : CGFloat = itemWidth
            return CGSize(width: itemWidth, height: itemHeight)
        }
        else if collectionView == collectionViewActors{
            
            let itemWidth : CGFloat = 120
            let itemHeight : CGFloat = itemWidth * 1.5
            return CGSize(width: itemWidth, height: itemHeight)
        }
        else if collectionView == collectionViewSimilarContents{
            let itemWidth : CGFloat = collectionView.frame.width / 3
            let itemHeight : CGFloat = collectionView.frame.height
            return CGSize(width: itemWidth, height: itemHeight)

        }
        else{
            return CGSize.zero
        }
    }
    
}






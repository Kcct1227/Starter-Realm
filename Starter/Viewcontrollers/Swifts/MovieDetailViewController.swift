//
//  MovieDetailViewController.swift
//  Starter
//
//  Created by ADMIN on 07/02/2022.
//

import UIKit
import YouTubePlayer

class MovieDetailViewController: UIViewController,ActorActionDelegate, MovieItemDelegate{
    
    
    //MARK: - IBOutlet
    @IBOutlet weak var stackViewTime: UIStackView!
    @IBOutlet weak var viewForVotes: UIView!
    @IBOutlet weak var imgSearch: UIImageView!
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
    private let movieModel : MovieModel = MovieModelImpl.shared
    private let seriesModel : SeriesModel = SeriesModelImpl.shared
    private let actorModel : ActorModel = ActorModelImpl.shared
    
    var movieID : Int = -1
    var type: String = ""
    private var url = ""
    private var productionCompanies : [ProductionCompany] = []
    private var casts: [MovieCast] = []
    private var similarMovies: [MovieResult] = []
    private var movieTrailers : [MovieTrailer] = []
    
    //private var objects = Array.init(repeating: "Hello", count: 10000000)
    
    deinit{
        print("This object is released!")
    }

    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
            
    }
    
    //MARK: - Init View
    private func initView(){
        initGestureRecoginizer()
        btnRateMovie.layer.borderColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        btnRateMovie.layer.borderWidth = 2
        btnRateMovie.layer.cornerRadius = 20
        registerCollectionViewCell()
        
        switch(type){
        case ContentType.MovieType.rawValue:
            setUpMovie()
        case ContentType.SerieType.rawValue:
            setUpSeries()
        case ContentType.ActorType.rawValue:
            setUpActors()
        default:
            print("")
        }
      
    
    }
    
    private func setUpActors(){
        fetchActorInfo(id: movieID)
        fetchMovieCombinedList(id: movieID)
    }
    
    private func setUpSeries(){
        self.buttonPlay.isHidden = true
        fetchSeriesDetail(id: movieID)
        fetchSeriesTrailer(id: movieID)
        fetchSeriesCredit(id: movieID)
        fectchSimilarSeries(id: movieID)
    }
    
    private func setUpMovie(){
        self.buttonPlay.isHidden = true
        fetchMovieDetails(id: movieID)
        fetchMovieTrailer(id: movieID)
        getMovieCreditsByid(id: movieID)
        fectchSimilarMovies(id: movieID)

    }
    
    @IBAction func onClickPlayTrailer(_ sender : UIButton){
        
        if type == ContentType.ActorType.rawValue{
            if let dataURL = URL(string: "https://www.google.com") {
                UIApplication.shared.open(dataURL)
            }
        }
        else{
            // play
            let item = movieTrailers.first
            let youtubeId = item?.key
            //let ytURL = "https://youtube.com/watch?v=\(youtubeVideoKey)"
            let playerVC = YouTubePlayerViewController()
            playerVC.youtubeId = youtubeId
            self.present(playerVC, animated: true, completion: nil)
        }

    }
    
    func onTapMovie(id: Int, type: String) {
        navigateToMovieDetailViewController(movieId: id, contentType: type)

    }
    
    //MARK: - API CALL
    private func fetchMovieCombinedList(id: Int){
        actorModel.getActorCombinedListById(id: id) { [weak self](result) in
            guard let self = self else { return }
            switch result{
            case .success(let data):
                if data.count != 0{
                    self.viewForSimlarContent.isHidden = false
                    self.similarMovies = data
                    self.collectionViewSimilarContents.reloadData()
                }
                else{
                    self.viewForSimlarContent.isHidden = true
                }
               
            case .failure(let message):
                print(message)
                self.viewForSimlarContent.isHidden = true
            }
        }
    }
    
    private func fetchActorInfo(id: Int){
        actorModel.getActorDetailInfoById(id: id) { (result) in
            switch result{
            case .success(let data):
                self.bindActorData(data: data)
            case .failure(let message):
                print(message)
            }
        }
    }
    
    private func fetchMovieTrailer(id: Int){
        movieModel.getMovieTrailerVideo(id: id) { (result) in
            switch result{
            case .success(let data):
                self.movieTrailers = data.results ?? [MovieTrailer] ()
                self.buttonPlay.isHidden = self.movieTrailers.isEmpty && self.type != ContentType.ActorType.rawValue
            case .failure(let message):
                print(message)
            }
        }
    }
    
    private func fectchSimilarMovies(id: Int){
        movieModel.getSimilarMovieById(id: id) { (result) in
            switch result{
            case .success(let data):
                if data.count != 0{
                    self.viewForSimlarContent.isHidden = false
                    self.similarMovies = data ?? [MovieResult]()
                    self.collectionViewSimilarContents.reloadData()
                }
                else{
                    self.viewForSimlarContent.isHidden = true
                }
            case .failure(let message):
                print(message)
                self.viewForSimlarContent.isHidden = true
            }
        }
    }
    
    private func fetchMovieDetails(id: Int){
        movieModel.getMovieDetailById(id: id){ (result) in
            switch result{
            case .success(let resultData):
                self.bindData(data: resultData)
            case .failure(let message):
                print(message)
            }
        }
    }
    
    private func getMovieCreditsByid(id: Int){
        movieModel.getMovieCreditByid(id: id) { (result) in
            switch result{
            case .success(let resultData):
                if resultData.cast?.count != 0{
                    self.viewForActor.isHidden = false
                    self.casts = resultData.cast ??  [MovieCast]()
                    self.collectionViewActors.reloadData()
                }
                else{
                    self.viewForActor.isHidden = true
                }
            case .failure(let message):
                print(message)
                self.viewForActor.isHidden = true
            }
        }
    }
    
    private func fectchSimilarSeries(id: Int){
        seriesModel.getSimilarSeriesById(id: id) { (result) in
            switch result{
            case .success(let data):
                if data.count != 0{
                    self.viewForSimlarContent.isHidden = false
                    self.similarMovies = data 
                    self.collectionViewSimilarContents.reloadData()
                }
                else{
                    self.viewForSimlarContent.isHidden = true
                }
            case .failure(let message):
                print(message)
                self.viewForSimlarContent.isHidden = true
            }
        }
    }
    
    private func fetchSeriesDetail(id: Int){
        seriesModel.getSeriesDetailById(id: id) { (result) in
            switch result{
            case .success(let resultData):
                self.bindSeriesData(data: resultData)
            case .failure(let message):
                print(message)
            }
        }
    }
    
    private func fetchSeriesTrailer(id: Int){
        seriesModel.getSeriesTrailerVideo(id: id) { (result) in
            switch result{
            case .success(let data):
                self.movieTrailers = data.results ?? [MovieTrailer] ()
                self.buttonPlay.isHidden = self.movieTrailers.isEmpty && self.type != ContentType.ActorType.rawValue
            case .failure(let message):
                print(message)
            }
        }
    }
    
    private func fetchSeriesCredit(id: Int){
        seriesModel.getSeriesCreditByid(id: id) { (result) in
            switch result{
            case .success(let resultData):
                if resultData.cast?.count != 0{
                    self.viewForActor.isHidden = false
                    self.casts = resultData.cast ??  [MovieCast]()
                    self.collectionViewActors.reloadData()
                }
                else{
                    self.viewForActor.isHidden = true
                }
                
            case .failure(let message):
                print(message)
                self.viewForActor.isHidden = true
            }
        }
    }
    
  
    // MARK: - Register Collection Cell
    private func registerCollectionViewCell(){
        collectionViewActors.dataSource = self
        collectionViewActors.delegate = self
        collectionViewActors.registerForCell(identifier: ActorCollectionViewCell.identifier)
        collectionViewActors.showsHorizontalScrollIndicator = false
        collectionViewActors.showsVerticalScrollIndicator = false
        
        collectionViewSimilarContents.dataSource = self
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
        
        imgSearch.isHidden = true
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
        url = data.homepage ?? ""
        
        

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
     
        
//        labelGenreString.text = data.genres?.map{ $0.name}.reduce(""){
//            "\($0), \($1)"
//        }
        
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
        else if collectionView == collectionViewActors{
            return casts.count
        }
        else if collectionView == collectionViewSimilarContents{
            return similarMovies.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewCompanies{
            let cell = collectionView.dequeueCell(identifier: ProductionCompainiesCell.identifier, indexPath: indexPath) as ProductionCompainiesCell
            cell.data = productionCompanies[indexPath.row]
            return cell
        }
        else if collectionView == collectionViewActors{
            let cell = collectionView.dequeueCell(identifier: ActorCollectionViewCell.identifier, indexPath: indexPath) as ActorCollectionViewCell
            cell.delegate = self
            let item: MovieCast = casts[indexPath.row]
            cell.data = item.convertToActorInfoResponse()
            return cell
        }
        else if collectionView == collectionViewSimilarContents {
            let cell = collectionView.dequeueCell(identifier: PopularFilmCollectionViewCell.identifier, indexPath: indexPath) as PopularFilmCollectionViewCell
            cell.data = similarMovies[indexPath.row]
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
            
//            let itemWidth : CGFloat = collectionView.frame.width / 3
//            let itemHeight : CGFloat = itemWidth * 1.5
//            return CGSize(width: itemWidth, height: itemHeight)
        }
        else{
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionViewActors{
            let item: MovieCast = casts[indexPath.row]
            navigateToMovieDetailViewController(movieId: item.id ?? 0 , contentType: ContentType.ActorType.rawValue )
        }
        else if collectionView == collectionViewSimilarContents{
            let item: MovieResult = similarMovies[indexPath.row]
            navigateToMovieDetailViewController(movieId: item.id ?? 0, contentType: item.media_type ?? ContentType.MovieType.rawValue)
        }
    }
   
    
    
}



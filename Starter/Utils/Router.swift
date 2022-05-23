//
//  Router.swift
//  Starter
//
//  Created by KC on 11/02/2022.
//

import Foundation
import UIKit

enum StoryBoardName: String{
    case Main = "Main"
    case Authentication = "Authentication"
    case LaunchScreen = "LaunchScreen"
}

extension UIStoryboard{
    static func mainStoryBoard()-> UIStoryboard{
        UIStoryboard(name: StoryBoardName.Main.rawValue, bundle: nil)
    }
}

extension UIViewController{
    func navigateToMovieDetailViewController(movieId: Int, contentType: String){
        guard let vc = UIStoryboard.mainStoryBoard().instantiateViewController(identifier: MovieDetailViewController.identifer) as? MovieDetailViewController else {return}
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .flipHorizontal
        vc.movieID = movieId
        vc.type = contentType
        self.navigationController?.pushViewController(vc, animated: true)
        //present(vc, animated: true)
        
    }
    
    func navigateToSearchContentViewController(){
        //let vc = SearchMovieViewController()
        let vc = RxSearchViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        //present(vc, animated: true, completion: nil)
    }
    
    func navigateToMoreShowCaseViewController(data: [MovieResult]){
        let vc = MoreShowCaseViewController()
        vc.initData = data
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToMoreActorsViewController(data: [ActorInfoResponse]){
        let vc = MoreActorViewController()
        vc.initData = data
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

//
//  OnboardingVC.swift
//  Hamla
//
//  Created by Bassant on 07/03/2024.
//

import UIKit
import FXPageControl

class OnboardingVC: UIViewController {

    @IBOutlet weak var OnboardingCollectionView: UICollectionView!
    
    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var pageControl: FXPageControl!
    
    var slides: [OnboardingSlide] = []
    var currentPage = 0{
        didSet{
            pageControl.currentPage = currentPage
            //setupPageControl()
            
            if currentPage == slides.count-1{
                nextButton.setTitle("Get started!", for: .normal)
                skipBtn.isHidden = true
            }else{
                nextButton.setTitle("Next", for: .normal)
            }
        }
    }
    
//    func setupPageControl(){
//
//        //let pageControl = AdvancedPageControl()
//        // Customize the page control if needed
//        //self.view.addSubview(pageControl)
//
//        //pageControl.currentPageIndicatorTintColor = .white
//        //pageControl.pageIndicatorTintColor = .clear
//        pageCon.preferredCurrentPageIndicatorImage = UIImage(named: "Rectangle")
//        pageCon.preferredIndicatorImage = UIImage(named: "Circle")
//
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rect = CGRect(x: -10, y: -5, width: 20, height: 10)
        let cornerRadius = rect.height / 2.0 // Adjust this value as needed for the desired capsule shape
        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath
        
        
        // Define the rectangle
        let Rect = CGRect(x: 0, y: 0, width: 100, height: 50)

        // Create a CGPath representing the rectangle
        //let Path = CGPath(rect: Rect, transform: nil)
        //let x = CGPath(rect: Rect, transform: nil)
        
        //pageControl.dotSize = 10.0
        //pageControl.selectedDotSize = 40.0
        pageControl.dotSize = 10.0
        pageControl.selectedDotColor = .white
        pageControl.selectedDotShape = path
        pageControl.dotColor = .clear
        pageControl.dotBorderColor = .white
        pageControl.dotBorderWidth = 2
        pageControl.selectedDotBorderColor = .white
        pageControl.selectedDotBorderWidth = 2
        pageControl.dotSpacing = 20.0
        
//        pageControl.selectedDotImage = UIImage(named: "Rectangle")
//        pageControl.dotImage = UIImage(named: "Circle")
        //pageControl.
//        let selectedDotWidth = 20.0 // Width of the selected dot
//        let dotSpacing = 10.0 // Desired spacing between dots
//
//        // Calculate the total width of a dot and its spacing
//        let totalDotWidth = selectedDotWidth + dotSpacing
//
//        // Adjust the dot spacing to ensure equal spacing between dots
//        pageControl.dotSpacing = totalDotWidth - pageControl.selectedDotSize
        
        //setupPageControl()
        //pageControl.customPageControl(dotFillColor: .white, dotBorderColor: .white, dotBorderWidth: 2)
        
        OnboardingCollectionView.delegate = self
        OnboardingCollectionView.dataSource = self
        
        OnboardingCollectionView.register(UINib(nibName: "OnboardingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "OnboardingCollectionViewCell")
        
        slides = [OnboardingSlide(image: UIImage(named: "Onboarding1")!, num: "1", description: "24 hours,\n7 days available \ntrucks!"),
                  OnboardingSlide(image: UIImage(named: "Onboarding2")!, num: "2", description: "Low cost,\nFast, and safe \ntransport!"),
                  OnboardingSlide(image: UIImage(named: "Onboarding3")!, num: "3", description: "Trusted app\nand qualified \ndrivers!")]
        
        
    }


    
    @IBAction func nextButtonClicked(_ sender: UIButton) {
        if currentPage == slides.count-1{
//            UserDefaults.standard.set(true, forKey: "WalkthroughCompleted")
            let vc = SignInVC(nibName: "SignInVC", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else{
            OnboardingCollectionView.isPagingEnabled = false
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            OnboardingCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            OnboardingCollectionView.isPagingEnabled = true
        }
    }
    
    
}


extension OnboardingVC: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCollectionViewCell", for: indexPath) as! OnboardingCollectionViewCell
        cell.setup(slide: slides[indexPath.row])
        
        return cell
    }
}

extension OnboardingVC:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x/width)
    }
}


extension UIPageControl {

    func customPageControl(dotFillColor:UIColor, dotBorderColor:UIColor, dotBorderWidth:CGFloat) {
        for (pageIndex, dotView) in self.subviews.enumerated() {
            if self.currentPage == pageIndex {
                dotView.backgroundColor = dotFillColor
                dotView.layer.cornerRadius = dotView.frame.size.height / 2
            }else{
                dotView.backgroundColor = .clear
                dotView.layer.cornerRadius = dotView.frame.size.height / 2
                dotView.layer.borderColor = dotBorderColor.cgColor
                dotView.layer.borderWidth = dotBorderWidth
            }
        }
    }

}

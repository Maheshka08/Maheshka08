//
//  WelcomeViewController.swift
//  Tweak and Eat
//
//  Created by Viswa Gopisetty on 02/09/16.
//  Copyright © 2016 Viswa Gopisetty. All rights reserved.
//

import UIKit
import AssetsLibrary
import AAInfographics
import AVKit
import AVFoundation
import MobileCoreServices
import CoreData
import OneSignal
import Realm
import RealmSwift
import Firebase
import FirebaseAuth
import FirebaseInstanceID
import FirebaseMessaging
import CoreImage
import HealthKit
import Alamofire
import CoreTelephony
import Branch
import FacebookCore
import RNCryptor
import CleverTapSDK

let IS_IPHONE4 = (UIScreen.main.bounds.size.height == 480) ? true : false
let IS_iPHONE5 = (UIScreen.main.bounds.size.height == 568) ? true : false
let IS_iPHONE678 = (UIScreen.main.bounds.size.height == 667) ? true : false
let IS_iPHONE678P = (UIScreen.main.bounds.size.height == 736) ? true : false
let IS_iPHONEXXS = (UIScreen.main.bounds.size.height == 812) ? true : false
let IS_iPHONEXRXSMAX = (UIScreen.main.bounds.size.height == 896) ? true : false
 let ptpIndiaPackage: String = "-PtpIndu4fke3hfj8skf"
 let ptpIndonesiaPackage: String = "-PtpIdno8kwg2npl5vna"
 let ptpUSAPackage: String = "-PtpUsa9aqws5fcb7mkG"
 let ptpMalaysiaPackage: String = "-PtpMys1ogs7bwt3malu"
 let ptpPhilippinesPackage: String = "-PtpPhy3mskop9Avqj5L"
 let ptpSingaporePackage: String = "-PtpSgn5Kavqo3cakpqh"

struct LastTenData {
    let tweak_id: Int
    let type: String
    let tweak_modified_image_url: String
    let total_calories: Int
    let carbs_perc: Int
    let fats_perc: Int
    let fiber_perc: Int
    let protein_perc: Int
    let others_perc: Int
    let meal_type: Int
    let tweak_crt_dttm: String
    let tweak_upd_dttm: String
    
}

struct TodayData {
    let tweak_id: Int
    let type: String
    let tweak_modified_image_url: String
    let total_calories: Int
    let carbs_perc: Int
    let fats_perc: Int
    let fiber_perc: Int
    let protein_perc: Int
    let others_perc: Int
    let meal_type: Int
    let tweak_crt_dttm: String
    let tweak_upd_dttm: String
    
}

struct WeekData {
    let tweak_id: Int
    let type: String
    let tweak_modified_image_url: String
    let total_calories: Int
    let carbs_perc: Int
    let fats_perc: Int
    let fiber_perc: Int
    let protein_perc: Int
    let others_perc: Int
    let meal_type: Int
    let tweak_crt_dttm: String
    let tweak_upd_dttm: String
    
}

struct MonthData {
    let tweak_id: Int
    let type: String
    let tweak_modified_image_url: String
    let total_calories: Int
    let carbs_perc: Int
    let fats_perc: Int
    let fiber_perc: Int
    let protein_perc: Int
    let others_perc: Int
    let meal_type: Int
    let tweak_crt_dttm: String
    let tweak_upd_dttm: String
    
}

class WelcomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDelegate, UITableViewDataSource, UserCallSchedule, MyNutritionButtonsTapped, ReportsButtonTaped {
    var dataBtnArray = [String]()
    var dataBtnDict = [String: String]()
    var nutritionViewSelectedMeal = "Select your meal"
    var nutritionViewLast10TweaksDataVal = "Last 10 Tweaks"
    var showGraph = false
    var switchButton: SwitchWithText!
    func tappedOnLast10Tweaks() {
        if self.myNutritionViewLast10TweaksTableView.isHidden == false {
            self.myNutritionViewLast10TweaksTableView.isHidden = true
            return
        }
        self.myNutritionViewSelectYourMealTableView.isHidden = true
        self.myNutritionViewLast10TweaksTableView.frame = CGRect(x: self.myNutritionDetailsView.last10TweaksView.frame.minX + 20, y: self.myNutritionDetailsView.frame.maxY + 90, width: self.myNutritionDetailsView.selectYourMealView.frame.width, height: 180)
               self.myNutritionViewLast10TweaksTableView.delegate = self
               self.myNutritionViewLast10TweaksTableView.dataSource = self
               self.view.addSubview(self.myNutritionViewLast10TweaksTableView)
               if  self.myNutritionViewSelectYourMealTableView.isHidden == true {
                   //MBProgressHUD.showAdded(to: self.myNutritionViewLast10TweaksTableView, animated: true)
                self.myNutritionViewLast10TweaksTableView.isHidden = false
                 self.myNutritionViewLast10TweaksTableView.reloadData()
               }
    }
    
    func tappedOnSelectYourMeal() {
        if self.myNutritionViewSelectYourMealTableView.isHidden == false {
            self.myNutritionViewSelectYourMealTableView.isHidden = true
            return
        }
        self.myNutritionViewLast10TweaksTableView.isHidden = true
        self.myNutritionViewSelectYourMealTableView.frame = CGRect(x: self.myNutritionDetailsView.selectYourMealView.frame.minX + 20, y: self.myNutritionDetailsView.frame.maxY + 90, width: self.myNutritionDetailsView.selectYourMealView.frame.width, height: 260)
        self.myNutritionViewSelectYourMealTableView.delegate = self
        self.myNutritionViewSelectYourMealTableView.dataSource = self
        self.view.addSubview(self.myNutritionViewSelectYourMealTableView)
        if  self.myNutritionViewSelectYourMealTableView.isHidden == true {
            MBProgressHUD.showAdded(to: self.myNutritionViewSelectYourMealTableView, animated: true)
         self.myNutritionViewSelectYourMealTableView.isHidden = false
        }
        self.getMealTypes(tblView: self.myNutritionViewSelectYourMealTableView)
        
    }
    
    @objc var myNutritionDetailsView : MyNutritionView! = nil;//myNutritionDetailsView

    func closeBtnTapped() {
        self.callSchedulePopup.removeFromSuperview()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.mealTypeTableView || tableView == self.myNutritionViewSelectYourMealTableView {
        return self.mealTypeArray.count
        } else if tableView == self.floatingTableView {
            return self.floatingButtonsArray.count
        } else if tableView == self.myNutritionViewLast10TweaksTableView {
                   return self.dataBtnArray.count
        }
        return 0
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if tableView == self.floatingTableView {
//            return "My Premium Service(s)!"
//        }
//        return ""
//    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if tableView == self.mealTypeTableView || tableView == self.myNutritionViewSelectYourMealTableView {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        cell.textLabel?.textColor = .white
            if tableView == self.myNutritionViewSelectYourMealTableView {
                cell.contentView.backgroundColor = UIColor.init(displayP3Red: 0.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1);
                cell.textLabel?.textColor = .white


            } else {
        cell.contentView.backgroundColor = UIColor.black.withAlphaComponent(0.6);
            }
        cell.textLabel?.textAlignment = .center
        let cellDict = self.mealTypeArray[indexPath.row];
        cell.textLabel?.text = (cellDict["name"] as! String)
        return cell;
        } else if tableView == self.floatingTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! FloatingCell
            let cellDict = self.floatingButtonsArray[indexPath.row];
            cell.pkgName.text = (cellDict["pkgName"] as! String)
            cell.imgView.image = UIImage.init(named: (cellDict["imgName"] as! String))
            cell.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.3, animations: {
                cell.transform = CGAffineTransform.identity
            })

            return cell

        } else if tableView == self.myNutritionViewLast10TweaksTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
            cell.textLabel?.text = self.dataBtnArray[indexPath.row];
            cell.contentView.backgroundColor = UIColor.init(displayP3Red: 0.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1);
            cell.textLabel?.textColor = .white

            cell.textLabel?.textAlignment = .center
            return cell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.mealTypeTableView || tableView == self.myNutritionViewSelectYourMealTableView {
        let cellDict = self.mealTypeArray[indexPath.row];
        self.mealType = cellDict["value"] as! Int
            //if tableView == self.mealTypeTableView {
        self.mealTypeLabel.text = (cellDict["name"] as! String)
            //} else if tableView == self.myNutritionViewSelectYourMealTableView {
                
                self.nutritionViewSelectedMeal = (cellDict["name"] as! String)
           // }
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut],
                       animations: {
                        tableView.isHidden = true
                        self.view.layoutIfNeeded()
                        
        },  completion: {(_ completed: Bool) -> Void in
        })
        self.setDefaultDataBtns(name: self.dataBtnName)
        } else if tableView == self.floatingTableView {
            //"Premium Tweak Pack"
            self.floatingButtonsView.isHidden = true
            self.floatingCrownBtn.setImage(UIImage.init(named: "crownstar-btn"), for: .normal)
            let cellDict = self.floatingButtonsArray[indexPath.row];
            if (cellDict["pkgName"] as! String) != "Tweak & Eat Club" && (cellDict["pkg"] as! String) != "-NcInd5BosUcUeeQ9Q32" {
                self.performSegue(withIdentifier: "myTweakAndEat", sender: (cellDict["pkg"] as! String))
            } else if (cellDict["pkg"] as! String) == "-NcInd5BosUcUeeQ9Q32" {
                self.goToNutritonConsultantScreen(packageID: (cellDict["pkg"] as! String))

            } else {
                //floatingToNutrition
                //self.performSegue(withIdentifier: "floatingToNutrition", sender: (cellDict["pkg"] as! String))
                self.goToTAEClubMemPage()

            }
            
        } else if tableView == self.myNutritionViewLast10TweaksTableView {
            
            let data = self.dataBtnArray[indexPath.row];
            self.nutritionViewLast10TweaksDataVal = data
            tableView.isHidden = true
            self.dataBtnName = self.dataBtnDict[data]!
            self.myNutritionDetailsView.last10TweaksLbl.text = data
            self.setDefaultDataBtns(name: self.dataBtnName)
            
        }

    }
    
    func goToNutritonConsultantScreen(packageID: String) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let clickViewController = storyBoard.instantiateViewController(withIdentifier: "TweakandEatClubMemberVC") as? TweakandEatClubMemberVC;
        clickViewController?.packageID = packageID
     self.navigationController?.pushViewController(clickViewController!, animated: true)
    }
    
    enum PackageName :String {
        case AiDP
        case MyTweakAndEat
        case both
        case Normal
        func package() ->String { return self.rawValue }
    }
    
    var last10Data = [LastTenData]()
    var todayData = [TodayData]()
    var weekData = [WeekData]()
    var monthData = [MonthData]()
    var floatingButtonsArray = [[String: AnyObject]]()
    var dataSelected = ""
    var mealType = 0
    var trends = "Calories"
    var recipesArray = NSArray()
    var isCallBtnTapped = false
    var loadingView = UIView()
//    var tweaksArray = NSMutableArray()
//    var tweakFeedsArray = [TweakWall]()
    var mhpId = 0
    @IBOutlet weak var smallScreenPopUpBtn: UIButton!
 @IBOutlet weak var approxCalLeftForDayLabel: UILabel!
    @IBOutlet weak var floatingBtnHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var premiumMemberTopButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var premiumMemberBottomButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var premiumMemberTopButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var premiumMemberBottomButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var floatingButtonsView: UIView!
    @IBOutlet weak var floatingCrownBtn: UIButton!
    @IBOutlet weak var tapToTweakButton: UIButton!
    @IBOutlet weak var floatingTableView: UITableView!
    @IBOutlet weak var caloriesInfoViewOkBtn: UIButton!
    @IBOutlet weak var caloriesInfoLabel: UILabel!
    @IBOutlet weak var caloriesInfoView: UIView!
    @IBOutlet weak var minCalCountLabel: UILabel!
    
    @IBOutlet weak var monthBtnTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var noGraphDataLabel: UILabel!
    @IBOutlet weak var mealTypeTableView: UITableView!
    @IBOutlet weak var topButtonsDataView: UIView!
    @IBOutlet weak var last10TweaksBtn: UIButton!
    @IBOutlet weak var todayBtn: UIButton!
    @IBOutlet weak var weekBtn: UIButton!
    @IBOutlet weak var monthBtn: UIButton!
    @IBOutlet weak var selectYourMealTypeView: UIView!
    @IBOutlet weak var mealTypeLabel: UILabel!;
    @IBOutlet weak var mainMenuView: UIView!
    @IBOutlet weak var myEDRView: UIView!
    @IBOutlet weak var tweakWallView: UIView!
    @IBOutlet weak var recipeView: UIView!
    @IBOutlet weak var myFitnessView: UIView!
    

    @IBOutlet weak var mealTypeView: UIView!
    var dataBtnName = "lastTenData"
    var sectionsForGamifyArray = [[String: AnyObject]]()
    var infoIconTapped = false
    @IBOutlet weak var philippinesPTPView1: UIView!
    @IBOutlet weak var philippinesPTPView2: UIView!
    @IBOutlet weak var buyMoreBtn1: UIButton!
    @IBOutlet weak var buyMoreBtn2: UIButton!

    @IBOutlet weak var premiumMemberBottomBtn: UIButton!
    @IBOutlet weak var premiumMemberTopBtn: UIButton!
    @IBOutlet weak var  taeClubMemberTopButton: UIButton!
    @IBOutlet weak var  taeClubMemberBottomButton: UIButton!
    
    @IBOutlet weak var chatViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var popUpViewForPTP: UIView!
    
    @IBOutlet weak var tweakBeforeDefaultView: UIView!
    @IBOutlet weak var popUpPTPTextView: UITextView!
    @IBOutlet weak var popUPPTPImageView: UIImageView!
    @IBOutlet weak var taeClubTrialPeriodExpiryView: UIView!
    @IBOutlet weak var ptpPhBtn1: UIButton!
    @IBOutlet weak var taeClubTrialPeriodExpiryViewLbl: UILabel!
    @IBOutlet weak var trendsButonViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var ptpPhBtn2: UIButton!
    @IBOutlet weak var topButtonsDataViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var taeClubMemberTopView: UIView!
    @IBOutlet weak var beforeTweakImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var beforeTweakImageView: UIImageView!
    @IBOutlet weak var taeClubMemberBottomView: UIView!
    @IBOutlet weak var taeClubMemberTopRightButton: UIButton!
    @IBOutlet weak var taeClubMemberBottomRightButton: UIButton!
    
    @IBOutlet weak var menuBtnHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topImageView: UIView!
    @IBOutlet weak var foodImageShadowView: UIView!
    @IBOutlet weak var protienButton: UIButton!
    @IBOutlet weak var infoIconBarButton: UIBarButtonItem!
    @IBOutlet weak var fatButton: UIButton!
    @IBOutlet weak var caloriesButton: UIButton!
    @IBOutlet weak var carbsButton: UIButton!
    
    @IBOutlet weak var ptpBtn2: UIButton!
    @IBOutlet weak var ptpBtn1: UIButton!
    @IBOutlet weak var innerDragMenuView: UIView!
    @IBOutlet weak var bottomBtnViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var ptpSubscribeLabel: UILabel!
    var checkUserScheduleArray = [[String: AnyObject]]()
    @IBOutlet weak var smallScreenPopUpTextView: UITextView!
    @IBOutlet weak var smallScreenPopUpImageView: UIImageView!
    @IBOutlet weak var smallScreenPopUp: UIView!
    @IBOutlet weak var navBarButtonItemTimer: UIBarButtonItem!
    @IBOutlet weak var premiumTweakPackBtnTopConstraint: NSLayoutConstraint!
    var randomPromoLink = ""
    @IBOutlet weak var foodImageShadowViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var taeClubViewTopConstraint: NSLayoutConstraint!
    private var minimumHeight: CGFloat!
    private var minimumFrame: CGRect!
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var draggableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var trendButtonsView: UIView!
    @IBOutlet weak var outerChartView: UIView!
    @IBOutlet weak var draggableImageView: UIImageView!
    private let maxDragPosition = UIScreen.main.bounds.size.height - 150
    @IBOutlet var swipeUpGesture: UISwipeGestureRecognizer!
    var draggableConstant: CGFloat = 0
    @IBOutlet weak var draggableContainerView: UIView!
    @IBOutlet var swipeDownGesture: UISwipeGestureRecognizer!
    @IBOutlet weak var bottomButtonsView: UIView!
    var goneUp = false
    var minDragPosition: CGFloat = 0.0
    let aaChartView = AAChartView()
    @IBOutlet weak var draggableView: UIView!
    let dataPoints = [0,400,150,280,140,290,110,300,460,0]
    private var foodImageFrame: CGRect!
    var flashCounter = 0
//    var tapToTweak = Bool() {
//        didSet {
//            if tapToTweak == true {
//                self.tappedOnStartTweakingView()
//            }
//        }
//    }
    var tapToTweak = false

    @IBOutlet weak var myTrendsLabel: UILabel!
    
    @IBOutlet weak var chartView: UIView!
    var trialPeriodExpired = false
    var ptpPackage = ""
    var links = ""
    var counts = 0
    var mealTypeArray = [[String: AnyObject]]();
    @IBOutlet weak var diagnalScreen: UIImageView!;
    @IBOutlet weak var premiumBtnBottomConstraint: NSLayoutConstraint!;
    var packageNames = ""
    @IBOutlet weak var recipeWallBtn: UIButton!
    @IBOutlet weak var myEdrBtn: UIButton!
    @objc var activeCountriesArray = NSMutableArray();
    @objc var popUpView = UIView();
    @objc var pkgIdsArray = NSMutableArray();
    @objc var premiumPackagesArray = NSMutableArray();
    @objc var fromCrown = false;
    @objc var insidePopUpView = UIView();
    @objc var path = Bundle.main.path(forResource: "en", ofType: "lproj");
    var isLoaded = false
    var showMyNutririonDetailsView = [Int]() {
      didSet {
            checkIfUserIsNewOrTrialPeriodExpired()
        }
    }
    @IBOutlet weak var startTweakingLabel: UILabel!
    @IBOutlet weak var trialPeriodExpiryTextLbl: UILabel!
    @IBOutlet weak var buyPkgsButton: UIButton!
    @IBOutlet weak var premiumTweakPackButton: UIButton!
    @objc var bundle = Bundle();
    @objc var count:Int = 0;
    let imageCache = NSCache<AnyObject, AnyObject>()
    @objc let healthStore = HealthHelper.sharedInstance.healthStore;
    var userSubscribedTAE = 0
    var userIndMyAidpSub = 0
    var localTimeZoneName: String { return TimeZone.current.identifier }
    
    var timeZoneAbbreviations: [String:String] { return TimeZone.abbreviationDictionary }
    
    @objc var stepsDictionary = [String:AnyObject]();
    @objc var floorsDictionary = [String:AnyObject]();
    @objc var distanceDictionary = [String:AnyObject]();
    @objc var caloriesDictionary = [String:AnyObject]();
    @objc var activeMinsDictionary = [String:AnyObject]();
    
    @objc var activitiesArray = NSMutableArray();
    @objc let formatter = DateFormatter();
    @objc var allCountryArray = NSMutableArray();
    @objc var countryArray = NSArray();
    @objc var packageIDArray = NSMutableArray();
    @objc var languageSelected = false;
    @objc var firebaseTopicNamesArray = NSArray();
    @objc var userSeenVideoCount = 0;
    @objc var totalCMS : String = "";
    var myNutritionViewSelectYourMealTableView = UITableView()
    var myNutritionViewLast10TweaksTableView = UITableView()
    @IBOutlet weak var askSiaButton: UIButton!
    @IBOutlet weak var adsImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var myTweakEatView: UIView!
    @IBOutlet weak var iconsView: UIView!;
    @IBOutlet weak var spinner: UIActivityIndicatorView!;
    @IBOutlet weak var fitBitSyncView: UIView!;
    @IBOutlet weak var tweakCountLbl: UILabel!;
        @IBOutlet weak var tweakStreakView: UIView!;
    @IBOutlet weak var refreshTweakBtn: UIButton!
    @IBOutlet weak var adsImageView: UIImageView!;
    @objc var deviceInfo = UIDevice.current.modelName;
    @IBOutlet weak var outerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var kuwaitIconsView: UIView!;
    
    @IBOutlet weak var startTweakingView: UIView!
    @IBOutlet weak var trialPeriodExpiryView: UIView!
    @IBOutlet weak var myEdrLbl1: UILabel!;
    @IBOutlet weak var nutritionLbl1: UILabel!;
    @IBOutlet weak var recipeWallLbl1: UILabel!;
    @IBOutlet weak var tweakWallLbl1: UILabel!;
    @IBOutlet weak var myNutritionLbl1: UILabel!;
    @IBOutlet weak var fitnessLbl1: UILabel!;
    
    @IBOutlet weak var tweakBubbleImageView: UIImageView!;
    @IBOutlet var menuButtonsView2: UIView!;
    @IBOutlet weak var cloudBubbleImage: UIImageView!;
    
    @IBOutlet weak var myNutritionButton: UIButton!
    @IBOutlet weak var nutritionLabelsButton: UIButton!
    @IBOutlet var menuButtonsView: UIView!;
    @IBOutlet var menuButtonsViewTopConstraint: NSLayoutConstraint!;
    @IBOutlet weak var menuViewTopConstraint: NSLayoutConstraint!;
    @IBOutlet var shadowImageTopConstraint: NSLayoutConstraint!;
    @IBOutlet var ButtonTopConstraint: NSLayoutConstraint!;
    
    @IBOutlet weak var upperMainView: UIView!
    @IBOutlet weak var premiumBtnTopConstraint: NSLayoutConstraint!;
    @IBOutlet weak var premiumMember: UIButton!;
    
    @objc var snapShotID: String = "-L0edGJLp_CzjxObmItX";
    var myProfileInfo : Results<MyProfileInfo>?;
    
    @IBOutlet var myEDRButton: UIButton!;
    @IBOutlet var myProfileButton: UIButton!;
    @IBOutlet var buzzButton: UIButton!;
    @IBOutlet var myWallButton: UIButton!;
    @IBOutlet var notificationBadgeLabel: UILabel!;
    
    @IBOutlet weak var premiumIconBarButton: UIBarButtonItem!;
    @IBOutlet var birdieImgView: UIImageView!;
    @IBOutlet var tweakStreakCountButton: UIButton!;
    @IBOutlet var settingsBarButton: UIBarButtonItem!;
    @IBOutlet var faceDetectionImageView: UIImageView!;
    @IBOutlet var faceDetectionView: UIView!;
    
    @objc var tweakFeedsRef : DatabaseReference!;
    @objc var premiumBtnRef : DatabaseReference!;
    
    @objc var tweakView : TweakAnimationWelcomeView! = nil;
    @objc var congratulationsTweakerView : CongratulationsTweaker! = nil;
    @objc var howToTweakView : HowToTweak! = nil;

    @objc var tweakTextView : TweakAndEatWelcomeScreen! = nil;
    @objc var tweakOTPView : TweakAndEatOTPView! = nil;
    @objc var tweakOptionView : TweakAndEatOptionsView! = nil;
    @objc var tweakFinalView : TweakAndEatFinalIntroScreen! = nil;
    @objc var callSchedulePopup : UserCallSchedulePopUp! = nil;
    @objc var tweakSelection : TweakAndEatSelectionView! = nil;
    @objc var tweakGoalsView : TweakAndEatGoalsView! = nil;
    @objc var tweakTermsServiceView : TweakServiceAgreement! = nil;
    @objc var tweakNoNetworkView : TweakAndEatNOIntenetVIew! = nil;
    @objc var getTimelines : TimelinesDetailsViewController! = nil;
    @objc var pieChartView : TweakPieChartView! = nil;
    
    @objc var tweakStreakCount = "";
    @objc var totalTweakCount = "";
    @objc var checkPremiumUserCount:Int = 0;
    
    @objc var pickOption = [["2 feet", "3 feet", "4 feet","5 feet", "6 feet", "7 feet","8 feet"], ["0 inch","1 inch", "2 inches", "3 inches", "4 inches","5 inches", "6 inches", "7 inches","8 inches","9 inches", "10 inches", "11 inches"]];
    var congratsTweakerBgStr = ""
    var congratsTweakerReview1Str = ""
    var congratsTweakerReview2Str = ""
    
    var howToTweakBgStr = ""
    var step1Str = ""
    var step2Str = ""
    var step3Str = ""
    var youAreDoneStr = ""


    @objc var weightFieldArray = [String]();
    @objc var heightFieldArray =  [String]();
    @objc var bmi : String = "";
    
    @IBOutlet var tweakReactView: UIView!;
    @IBOutlet weak var streakTextView: UIView!;
    @IBOutlet weak var subscribeNowButton: UIButton!
    @IBOutlet weak var appVersionUpdateButton: UIButton!
    @IBOutlet weak var appCheckVersionView: UIView!
    @IBOutlet weak var subscribeToPTPNowLblHeightConstraint: NSLayoutConstraint!
    @objc var name : String = "";
    @objc var countryCode = "";
    @objc var Number : String = "";
    @objc var nicKName : String = "";
    @objc var sex : String = "";
    @objc var userMsisdn : String = "";
    @objc var badgeCount: Int = 0;
    @objc var faceBox : UIView!;
    var tweakCount = 0
    @objc var selectedDate : String!;
    @objc let requestId = "Request ID";
    @objc let categoryId = "Category ID";
    @objc var introTextArray : [AnyObject]? = nil;
    @objc var comingFromSettings : Bool = false;
    @objc var picker = UIImagePickerController();
    @objc var dbArray:[AnyObject] = [];
    @objc let textSaperator : String = "#";
    @objc var cloudTapped = UITapGestureRecognizer();
    @objc var adsImageViewTapped = UITapGestureRecognizer();
    var existingUserDate = Date()
    var tweakNowAlert : Bool?;
    var myWallAlert : Bool?;
    var myEdRAlert : Bool?;
    var recipeWallAlert : Bool?;
    var existingUser = false
    @objc var link = "";
    @IBOutlet weak var roundImageView: UIImageView!;
    @IBOutlet var shadowView: UIView!;
    
    @IBOutlet weak var cameraBtnHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cameraBtnWidthConstraint: NSLayoutConstraint!
    @objc var reachability : Reachability!;
    @objc var latitude : String = "0.0";
    @objc var longitude : String = "0.0";
    @objc var appDelegateTAE : AppDelegate!;
    
    @objc var msisdn : String? = nil;
    @objc var selectedAge : NSString? = nil;
    @objc var selectedGender  = "";
    @objc var selectedBodyShape : UIImageView? = nil;
    @objc var weight : NSString? = nil;
    @objc var height : NSString? = nil;
    @objc var awesomeWall: Bool = true;
    @objc var commentsWall: Bool = false;
    @objc var getPromoResponse = [String: AnyObject]();
    @IBOutlet weak var floatingCallBtn: UIButton!
    
    @IBOutlet weak var tweakandeatClubButtonView: UIView!
    @IBOutlet weak var tweakandeatClubButtonViewBottom: UIView!
    @IBOutlet weak var tweakAndEatCLubExpiryViewWithButtons: UIView!
    @IBOutlet weak var smallScreenPopupImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var upperViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var randomMessages: UILabel!;
    @IBOutlet weak var tweakStreakLbl: UILabel!;
    @IBOutlet weak var cameraTweakLabel: UILabel!;
    @IBOutlet weak var recipeWallLabel: UILabel!;
    @IBOutlet weak var myFitnessLabel: UILabel!;
    @IBOutlet weak var myEDRLabel: UILabel!;
    @IBOutlet weak var checkThisOutLabel: UILabel!;
    @IBOutlet weak var tweakWallLabel: UILabel!;
    @objc var caloriesArray = NSMutableArray();
    @objc var carbsArray = NSMutableArray();
    @objc var fatssArray = NSMutableArray();
    @objc var proteinArray = NSMutableArray()
    var clubPackageSubscribed = ""
    @IBOutlet weak var clubHome1LeftBth: UIButton!
    @IBOutlet weak var clubHome1RightBth: UIButton!
    @IBOutlet weak var clubHome2LeftBth: UIButton!
    @IBOutlet weak var clubHome2RightBth: UIButton!
    @IBOutlet weak var navigationBarButtonItemTimer: UIBarButtonItem!
    @IBOutlet weak var navigationBarTimerViewButton: UIButton!
    
    @IBOutlet weak var personalisedServicesBtn: UIButton!
    
    @IBOutlet weak var taeClubHome2Btn: UIButton!
    @IBOutlet weak var myNutritionView: UIView!
    @IBOutlet weak var approxCalLeftView: UIView!
    @IBOutlet weak var topBgImageView: UIImageView!
    @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var topViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tapToTweakView: UIView!
    
    @IBOutlet weak var containerViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var subscribeNowButtonView: UIView!
    
    
    @IBOutlet weak var scrollContainerView: UIView!
    @IBAction func taeClubMemberButtonTapped(_ sender: Any) {
        self.goToTAEClubMemPage()
    }
    @IBAction func askSiaTapped(_ sender: Any) {
        //AskSiaViewController
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let clickViewController = storyBoard.instantiateViewController(withIdentifier: "AskSiaViewController") as? AskSiaViewController;
     self.navigationController?.pushViewController(clickViewController!, animated: true)
    }
    func goToTAEClubMemPage() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let clickViewController = storyBoard.instantiateViewController(withIdentifier: "TweakandEatClubMemberVC") as? TweakandEatClubMemberVC;
     self.navigationController?.pushViewController(clickViewController!, animated: true)
       
    }
    
    @objc func goToMyTAE() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let clickViewController = storyBoard.instantiateViewController(withIdentifier: "MyTweakAndEatVCViewController") as? MyTweakAndEatVCViewController;
     self.navigationController?.pushViewController(clickViewController!, animated: true)
       
    }

    
    @IBAction func taeClubHome2BtnTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "taeClub", sender: self);

    }
    func goToBuyScreen(packageID: String, identifier: String) {
            UserDefaults.standard.set(identifier, forKey: "POP_UP_IDENTIFIERS")
            UserDefaults.standard.synchronize()
            DispatchQueue.main.async {
                                  MBProgressHUD.showAdded(to: self.view, animated: true);
                                  }
                                  self.moveToAnotherView(promoAppLink: packageID)

    //        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
    //                       let vc : AvailablePremiumPackagesViewController = storyBoard.instantiateViewController(withIdentifier: "AvailablePremiumPackagesViewController") as! AvailablePremiumPackagesViewController;
    //        vc.packageID = packageID
    //        vc.identifierFromPopUp = identifier
    //         vc.fromHomePopups = true
    //                       let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
    //                       navController?.pushViewController(vc, animated: true);
        }
    @IBAction func smallScreenPopUpDoneTapped(_ sender: Any) {
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
                   self.countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
        }
        var clubPackageSubscribed = ""
        if self.countryCode == "91" {
            clubPackageSubscribed = "-ClubInd3gu7tfwko6Zx"
        } else if self.countryCode == "62" {
            clubPackageSubscribed = "-ClubIdn4hd8flchs9Vy"
        } else if self.countryCode == "1" {
            clubPackageSubscribed = "-ClubUSA4tg6cvdhizQn"
        } else if self.countryCode == "65" {
            clubPackageSubscribed = "-ClubSGNPbeleu8beyKn"
        } else if self.countryCode == "60" {
            clubPackageSubscribed = "-ClubMYSheke8ebdjoWs"
        }
        if (link == "" || link == "HOME") {
            self.smallScreenPopUp.isHidden = true
        } else if link == "CALS_LEFT_FS_POPUP" {
            //UIView.setani
            self.smallScreenPopUp.isHidden = true
            self.performSegue(withIdentifier: "calorieMeter", sender: self)


        } else if link == "HOW_IT_WORKS" {
            
            self.smallScreenPopUp.isHidden = true
            self.playVideo()
        } else if link == "CLUB_PURCHASE" || link == "CLUB_PUR_IND_OP_1M" {
            self.smallScreenPopUp.isHidden = true

            if UserDefaults.standard.value(forKey: "-ClubInd3gu7tfwko6Zx") != nil || UserDefaults.standard.value(forKey: "-ClubIdn4hd8flchs9Vy") != nil {
              self.goToTAEClubMemPage()
            } else {
                if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
                    self.countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
                }
                if self.countryCode == "91" {
                self.goToBuyScreen(packageID: "-ClubInd3gu7tfwko6Zx", identifier: "CLUB_PUR_IND_OP_1M")
                } else {
                    self.goToPurchaseTAEClubScreen()

                }
                

            }
        } else  if link == "NCP_PUR_IND_OP" {
            if UserDefaults.standard.value(forKey: "-NcInd5BosUcUeeQ9Q32") != nil {
                self.performSegue(withIdentifier: "myTweakAndEat", sender: link);
            } else {
        self.goToBuyScreen(packageID: "-NcInd5BosUcUeeQ9Q32", identifier: link)
            }
        } else if link == "MYAIDP_PUR_IND_OP_3M" {
            if UserDefaults.standard.value(forKey: "-AiDPwdvop1HU7fj8vfL") != nil {
                self.performSegue(withIdentifier: "myTweakAndEat", sender: link);

            } else {
        self.goToBuyScreen(packageID: "-AiDPwdvop1HU7fj8vfL", identifier: link)
            }
        } else if link == "CLUBAIDP_PUR_IND_OP_1M" {
            if UserDefaults.standard.value(forKey: "-ClubInd4tUPXHgVj9w3") != nil {
             self.performSegue(withIdentifier: "myTweakAndEat", sender: "-ClubInd4tUPXHgVj9w3");
                //self.performSegue(withIdentifier: "myTweakAndEat", sender: link);
            } else {
           self.goToBuyScreen(packageID: "-ClubInd4tUPXHgVj9w3", identifier: link)
            }
        } else if link == "MYTAE_PUR_IND_OP_3M" || link == "WLIF_PUR_IND_OP_3M" {
            self.smallScreenPopUp.isHidden = true

                   if link == "MYTAE_PUR_IND_OP_3M" {
                       if UserDefaults.standard.value(forKey: "-IndIWj1mSzQ1GDlBpUt") != nil {
                        self.performSegue(withIdentifier: "myTweakAndEat", sender: "-IndIWj1mSzQ1GDlBpUt");
                           //self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
                       } else {
                   self.goToBuyScreen(packageID: "-IndIWj1mSzQ1GDlBpUt", identifier: link)
                       }
                   } else if link == "WLIF_PUR_IND_OP_3M" {
                       if UserDefaults.standard.value(forKey: "-IndWLIntusoe3uelxER") != nil {
                        self.performSegue(withIdentifier: "myTweakAndEat", sender: "-IndWLIntusoe3uelxER");
                           //self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
                       } else {
                   self.goToBuyScreen(packageID: "-IndWLIntusoe3uelxER", identifier: link)
                       }
                   }
               } else if link == "CLUB_SUBSCRIPTION" || link == clubPackageSubscribed {
                //MYTAE_PUR_IND_OP_3M
                          if UserDefaults.standard.value(forKey: clubPackageSubscribed) != nil {
                             self.goToTAEClubMemPage()
                           } else {
                            DispatchQueue.main.async {
                            MBProgressHUD.showAdded(to: self.view, animated: true);
                            }
                            self.moveToAnotherView(promoAppLink: clubPackageSubscribed)                       }
            } else if link == "-NcInd5BosUcUeeQ9Q32" {
                
                
                if UserDefaults.standard.value(forKey: link) != nil {
                    self.goToNutritonConsultantScreen(packageID: link)
                } else {
                    DispatchQueue.main.async {
                        MBProgressHUD.showAdded(to: self.view, animated: true);
                    }
                    self.moveToAnotherView(promoAppLink: link)

                    
                    
                }
                
            } else {
            self.smallScreenPopUp.isHidden = true
            tappedOnPopUpDone()
        }
    }
    
    func goToPurchaseTAEClubScreen() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let clickViewController = storyBoard.instantiateViewController(withIdentifier: "TAEClub4VCViewController") as? TAEClub4VCViewController;
        clickViewController?.fromPopUpScreen = true
        self.navigationController?.pushViewController(clickViewController!, animated: true)

    }
    @IBAction func floatingCrownBtnTapped(_ sender: Any) {//CancelBtn
        if self.floatingCrownBtn.currentImage != UIImage.init(named: "CancelBtn") {
            DispatchQueue.main.async {
                self.view.bringSubviewToFront(self.floatingButtonsView)
                self.view.bringSubviewToFront(self.floatingCrownBtn)

                     self.floatingCrownBtn.setImage(UIImage.init(named: "CancelBtn"), for: .normal)
                   self.floatingButtonsView.isHidden = false
                   self.floatingButtonsView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
                   self.floatingTableView.reloadData()
                self.floatingBtnHeightConstraint.constant = CGFloat(self.floatingButtonsArray.count * 58) + 42

            }
       
        } else {
             DispatchQueue.main.async {
             self.floatingCrownBtn.setImage(UIImage.init(named: "crownstar-btn"), for: .normal)
            self.floatingButtonsView.isHidden = true
        }
        }
    }
    @IBAction func navigationBarButtonTimerTapped(_ sender: Any) {
        TweakAndEatUtils.AlertView.showAlert(view: self, message: "Enjoy your free trial! Subscribe at anytime & ensure your Nutrition 'Trends' right!")
    }
    @IBAction func nutritionLabelsTapped(_ sender: Any) {
        //fromMyNutritionLabels
        var package: String = ""
        if self.nutritionLabelsButton.currentImage == UIImage.init(named: "myaidp") {
            package = "-AiDPwdvop1HU7fj8vfL"
            self.performSegue(withIdentifier: "myTweakAndEat", sender: package)
            
        } else if self.nutritionLabelsButton.currentImage == UIImage.init(named: "mytae") {
            package = "-IndIWj1mSzQ1GDlBpUt"
            self.performSegue(withIdentifier: "myTweakAndEat", sender: package);
            
        } else {
        self.performSegue(withIdentifier: "fromMyNutritionLabels", sender: self)
        }
    }
    
    @IBAction func myNutritionTapped(_ sender: Any) {
        var package: String = ""

        if self.myNutritionButton.currentImage == UIImage.init(named: "mytae") {
            package = "-IndIWj1mSzQ1GDlBpUt"
            self.performSegue(withIdentifier: "myTweakAndEat", sender: package);
        } else  if self.myNutritionButton.currentImage == UIImage.init(named: "myaidp") {
            package = "-AiDPwdvop1HU7fj8vfL"
            self.performSegue(withIdentifier: "myTweakAndEat", sender: package)
            
            
        } else {
        self.performSegue(withIdentifier: "fromMyNutritions", sender: self)
        }
    }
    
    @IBAction func appVersionCheckUpdateBtn(_ sender: Any) {
        self.appCheckVersionView.isHidden = true
        guard let url = URL(string: "https://apps.apple.com/in/app/tweak-eat/id1267286348") else {
                                     return
                                 }
                                if UIApplication.shared.canOpenURL(url) {
                                     UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                 }
    }
    @IBAction func trendsButtonTapped(_ sender: Any) {
        let btn = sender as! UIButton
        DispatchQueue.main.async {
            self.caloriesButton.alpha = 1.0
            self.carbsButton.alpha = 1.0
            self.fatButton.alpha = 1.0
            self.protienButton.alpha = 1.0
            self.fatButton.backgroundColor = UIColor.clear
            self.protienButton.backgroundColor = UIColor.clear
            self.carbsButton.backgroundColor = UIColor.clear
            self.caloriesButton.backgroundColor = UIColor.clear
        }
       
        if btn.currentTitle == "Calories" {
            self.trends = "Calories"
            DispatchQueue.main.async {

            self.myTrendsLabel.text = "MY CALORIE TRENDS"
                self.caloriesButton.backgroundColor = UIColor.black.withAlphaComponent(0.3);
            }
        } else if btn.currentTitle == "Carbs" {
            self.trends = "Carbs"
            DispatchQueue.main.async {

            self.myTrendsLabel.text = "MY CARB TRENDS"
            self.carbsButton.backgroundColor = UIColor.black.withAlphaComponent(0.3);
            }
           // self.updateChartFromSecondTime(backGroundCol: "#ce1371", data: self.carbsArray as! [Any], name: "Carbs", colorTheme: ["#9E1B76"])
        } else if btn.currentTitle == "Protein" {
            self.trends = "Protein"
            DispatchQueue.main.async {

            self.myTrendsLabel.text = "MY PROTEIN TRENDS"
            self.protienButton.backgroundColor = UIColor.black.withAlphaComponent(0.3);
            }
            //self.updateChartFromSecondTime(backGroundCol: "#69b04c", data: self.proteinArray as! [Any], name: "Protein", colorTheme: ["#0B6B64"])
        } else if btn.currentTitle == "Fats" {
            self.trends = "Fats"
            DispatchQueue.main.async {

            self.myTrendsLabel.text = "MY FATS TRENDS"
            self.fatButton.backgroundColor = UIColor.black.withAlphaComponent(0.3);
            }
            //self.updateChartFromSecondTime(backGroundCol: "#d49741", data: self.fatssArray as! [Any], name: "Fat", colorTheme: ["#D79F53"])
        }
        self.setDefaultDataBtns(name: self.dataBtnName)

        
    }
    
    @IBAction func callBtnTapped(_ sender: Any) {
        self.isCallBtnTapped = true
        self.getUserCallSchedueDetails()
    }
    
    @IBAction func popUpPTPDoneBtnTapped(_ sender: Any) {
        self.popUpViewForPTP.isHidden = true
        
        tappedOnPopUpDone()
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func updateChartFromSecondTime(backGroundCol: String, data: [Any], name: String, colorTheme: [Any]) {
        self.chartView.backgroundColor = hexStringToUIColor(hex: backGroundCol)
        self.topButtonsDataView.backgroundColor = hexStringToUIColor(hex: backGroundCol)
        self.mealTypeTableView.backgroundColor = hexStringToUIColor(hex: backGroundCol)
        let aaChartModel = AAChartModel()
            .chartType(.spline)//Can be any of the chart types listed under `AAChartType`.
            .animationType(.bouncePast)
            .title("")//The chart title
            .subtitle("")//The chart subtitle
            .dataLabelsEnabled(true) //Enable or disable the data labels. Defaults to false
            .tooltipValueSuffix("")//the value suffix of the chart tooltip
            .categories(["1", "2", "3", "4", "5", "6",
                         "7", "8", "9", "10"])
            .colorsTheme(["#FFFFFF"])
            .series([
                AASeriesElement()
                    .name(name)
                    .data(data)
                
                ])
        aaChartModel.yAxisGridLineWidth = 0.0
        aaChartView.scrollEnabled = false
        aaChartView.isClearBackgroundColor = true
        aaChartModel.gradientColorEnable = true
        aaChartModel.yAxisVisible = false
        aaChartModel.backgroundColor = backGroundCol
        aaChartModel.legendEnabled = false
        aaChartModel.axesTextColor = "#FFFFFF"
        
        aaChartView.aa_refreshChartWholeContentWithChartModel(aaChartModel)

    }
    
    @IBAction func ptpBtnTapped(_ sender: Any) {
        if self.countryCode == "91" {
            self.ptpPackage = "-IndAiBPtmMrS4VPnwmD"
        } else if self.countryCode == "1" {
            self.ptpPackage = "-UsaAiBPxnaopT55GJxl"
        } else if self.countryCode == "65" {
            self.ptpPackage = "-SgnAiBPJlXfM3KzDWR8"
        } else if self.countryCode == "62" {
            self.ptpPackage = "-IdnAiBPLKMO5ePamQle"
        } else if self.countryCode == "60" {
            self.ptpPackage = "-MysAiBPyaX9TgFT1YOp"
        } else if self.countryCode == "63" {
            self.ptpPackage = "-PhyAiBPcYLiSYlqhjbI"
        }
                    if UserDefaults.standard.value(forKey: self.ptpPackage) != nil {
                        self.performSegue(withIdentifier: "nutritionAnalytics", sender: self)
                    } else {
                        if self.countryCode == "91" {
                            Analytics.logEvent("TAE_PTP_CLICKED_IND", parameters: [AnalyticsParameterItemName: "when user click on “Premium Tweak Pack"])
                        } else if self.countryCode == "1" {
                            Analytics.logEvent("TAE_PTP_CLICKED_USA", parameters: [AnalyticsParameterItemName: "when user click on “Premium Tweak Pack"])
                        } else if self.countryCode == "65" {
                            Analytics.logEvent("TAE_PTP_CLICKED_SGP", parameters: [AnalyticsParameterItemName: "when user click on “Premium Tweak Pack"])
                        } else if self.countryCode == "62" {
                            Analytics.logEvent("TAE_PTP_CLICKED_INDO", parameters: [AnalyticsParameterItemName: "when user click on “Premium Tweak Pack"])
                        } else if self.countryCode == "60" {
                            Analytics.logEvent("TAE_PTP_CLICKED_MYS", parameters: [AnalyticsParameterItemName: "when user click on “Premium Tweak Pack"])
                        } else if self.countryCode == "63" {
                            Analytics.logEvent("TAE_PTP_CLICKED_PHL", parameters: [AnalyticsParameterItemName: "when user click on “Premium Tweak Pack"])
                        }
        self.performSegue(withIdentifier: "premiumTweakPack", sender: self)
        }
    }
    func updateChart(backGroundCol: String, data: [Any], name: String, colorTheme: [Any]) {
        self.chartView.backgroundColor = hexStringToUIColor(hex: backGroundCol)
        self.topButtonsDataView.backgroundColor = hexStringToUIColor(hex: backGroundCol)
        self.mealTypeTableView.backgroundColor = hexStringToUIColor(hex: backGroundCol)
        let aaChartModel = AAChartModel()
            .chartType(.spline)//Can be any of the chart types listed under `AAChartType`.
            .animationType(.bouncePast)
            .title("")//The chart title
            .subtitle("")//The chart subtitle
            .dataLabelsEnabled(true) //Enable or disable the data labels. Defaults to false
            .tooltipValueSuffix("")//the value suffix of the chart tooltip
            .categories(["1", "2", "3", "4", "5", "6",
                         "7", "8", "9", "10"])
            .colorsTheme(colorTheme)
            .series([
                AASeriesElement()
                    .name(name)
                    .data(data)
                
                ])
        aaChartModel.yAxisGridLineWidth = 0.0
        aaChartView.scrollEnabled = false
        aaChartView.isClearBackgroundColor = true
        aaChartModel.gradientColorEnable = true
        aaChartModel.yAxisVisible = false
        aaChartModel.backgroundColor = backGroundCol
        aaChartModel.legendEnabled = false
        aaChartModel.axesTextColor = "#FFFFFF"
        
        
        
        aaChartView.aa_drawChartWithChartModel(aaChartModel)
    }
    
    @IBAction func handleSwipeView(_ gestureRecognizer: UISwipeGestureRecognizer) {
        if gestureRecognizer.direction == .up {
            if self.goneUp == true {
                return
            }
            DispatchQueue.main.async {
                UIView.animate(
                    withDuration: 1,
                    animations: { [self] in
                        self.upperMainView.alpha = 0
                        self.upperViewTopConstraint.constant = -270
                        self.topBgImageView.contentMode = .scaleToFill
                        self.containerViewBottomConstraint.constant = 110

                        if self.totalTweakCount == "0" {
                            self.startTweakingView.isHidden = false
                            self.startTweakingLabel.alpha = 1
                        } else {
                            self.startTweakingView.isHidden = true
                            self.startTweakingLabel.alpha = 0
                        }
                        if self.trialPeriodExpired == true {
//                        self.taeClubTrialPeriodExpiryView.isHidden = true
//                        self.taeClubTrialPeriodExpiryViewLbl.isHidden = true
                            self.trialPeriodExpiryView.isHidden = true
                            self.trialPeriodExpiryTextLbl.isHidden = true
                        }
                            self.view.layoutIfNeeded()
                    //last
                            
            },  completion: {(_ completed: Bool) -> Void in

                self.goneUp = true
                
            })
            }
        } else {
            if self.goneUp == false {
                return
            }
            DispatchQueue.main.async {
                UIView.animate(
                    withDuration: 1,
                    animations: {
                        self.upperMainView.alpha = 1
                        self.upperViewTopConstraint.constant = 0
                        self.topBgImageView.contentMode = .scaleAspectFill
                        self.containerViewBottomConstraint.constant = 0
                        if self.totalTweakCount == "0" {
                            self.startTweakingView.isHidden = false
                            self.startTweakingLabel.alpha = 1
                        } else {
                            self.startTweakingView.isHidden = true
                            self.startTweakingLabel.alpha = 0
                        }
                        if self.trialPeriodExpired == true {
                            
//                        self.taeClubTrialPeriodExpiryView.isHidden = false
//                            self.taeClubTrialPeriodExpiryViewLbl.isHidden = false
                            self.trialPeriodExpiryView.isHidden = false
                            self.trialPeriodExpiryTextLbl.isHidden = false

                        }
//                        self.outerViewHeightConstraint.constant = 237
//                        self.topViewHeightConstraint.constant = 302
//                        self.myNutritionView.alpha = 1
//                        if self.showGraph == false {
//                        self.outerChartView.isHidden = true
//                        } else {
//                            self.outerChartView.alpha = 1
//
//                        }
//                        if (self.myNutritionDetailsView != nil) {
//                        self.myNutritionDetailsView.frame = CGRect(x: 0, y: 0, width: self.myNutritionView.frame.width, height: 237)
//
//                            self.myNutritionView.frame = CGRect(x: 0, y: 0, width: self.myNutritionView.frame.width, height: 237)
//                            self.outerChartView.frame = self.myNutritionView.frame
//
//                        }
//                        self.containerViewBottomConstraint.constant = 0
//                        self.topBgImageView.contentMode = .scaleAspectFill
////                        self.startTweakingView.isHidden = false
////                        self.trialPeriodExpiryView.isHidden = false
////                        self.taeClubTrialPeriodExpiryView.isHidden = false

                            self.view.layoutIfNeeded()
                    //last
                            
            },  completion: {(_ completed: Bool) -> Void in
                self.goneUp = false
//                if self.showGraph == false {
//                self.outerChartView.isHidden = false
//                } else {
//                    self.outerChartView.isHidden = false
//
//                }
//                self.approxCalLeftView.isHidden = false



                
            })
            }
        }
    }
    
    @IBAction func handleSwipe(_ gestureRecognizer: UISwipeGestureRecognizer) {
        self.myNutritionViewLast10TweaksTableView.isHidden = true
              self.myNutritionViewSelectYourMealTableView.isHidden = true
              self.mealTypeTableView.isHidden = true
        if gestureRecognizer.direction == .up {
            if self.goneUp == true {
                return
            }
           //self.outerChartView.alpha = 0
           // self.bottomButtonsView.isHidden = false;
            DispatchQueue.main.async {
                UIView.animate(
                    withDuration: 1,
                    animations: {
                            if IS_iPHONEXRXSMAX {
                                self.draggableViewHeightConstraint.constant = UIScreen.main.bounds.size.height - self.foodImageView.frame.maxY - 44 - 5
                            } else if IS_iPHONEXXS {
                                self.draggableViewHeightConstraint.constant = 630
                            } else if IS_iPHONE678P {
                                self.draggableViewHeightConstraint.constant = 580
                            } else if IS_iPHONE678 {
                                self.draggableViewHeightConstraint.constant = 510
                            } else if IS_iPHONE5 {
                                self.draggableViewHeightConstraint.constant = 410
                            } else {
                                self.draggableViewHeightConstraint.constant = 380
                            }
                        
                            
                       // self.myNutritionDetailsView.alpha = 0
                        if UserDefaults.standard.value(forKey: "NEW_USER") != nil {
                            //self.tweakBeforeDefaultView.alpha = 1
                            if self.trialPeriodExpired == false {
                                self.tweakBeforeDefaultView.alpha = 0
                            } else {
                               // self.tweakBeforeDefaultView.alpha = 1
                            }

                        } else {
                            self.tweakBeforeDefaultView.alpha = 0

                        }
                            self.outerChartView.alpha = 0
                            self.switchButton.alpha = 0
                        
                       // self.chartView.alpha = 0
                           // self.buyMoreBtn2.isHidden = false
                            //self.ptpBtn2.isHidden = false
                            self.bottomBtnViewTopConstraint.constant = 0
                            //self.bottomButtonsView.backgroundColor = UIColor.groupTableViewBackground
                            self.view.layoutIfNeeded()
                    //last
                            
            },  completion: {(_ completed: Bool) -> Void in
                self.goneUp = true
                
            })
            }
        } else if gestureRecognizer.direction == .down {
            if self.goneUp == false {
                return
            }
           
            DispatchQueue.main.async {
                UIView.animate(
                    withDuration: 1,
                    animations: {
                        var minHeight:CGFloat = 0
                        if UserDefaults.standard.value(forKey: "NEW_USER") != nil {
                            if self.trialPeriodExpired == true {
                                minHeight = 70
                            } else {
                            minHeight = 190
                            }
                        } else {
                            minHeight = 70
                        }
                        if self.showGraph == false {
                             self.draggableViewHeightConstraint.constant = self.draggableConstant

                        } else  {
                            if IS_iPHONEXRXSMAX {
                                                           
                                                           self.draggableViewHeightConstraint.constant = 300 - 86 + minHeight
                                                       } else if IS_iPHONEXXS {
                                                           self.draggableViewHeightConstraint.constant = 150 + 30 + 20
                                                       } else if IS_iPHONE678P {
                                                           self.draggableViewHeightConstraint.constant = 130
                                                       } else if IS_iPHONE678 {
                                                           self.draggableViewHeightConstraint.constant = 175 - 76
                                                       } else if IS_iPHONE5 {
                                                           self.draggableViewHeightConstraint.constant = 30
                                                       } else {
                                                           self.draggableViewHeightConstraint.constant = 43 - 86
                                                       }
                        }
                           
                           // self.myNutritionDetailsView.alpha = 1
                        self.switchButton.alpha = 1
                            self.outerChartView.alpha = 1
                        self.tweakBeforeDefaultView.alpha = 1

                            self.bottomBtnViewTopConstraint.constant = -108

                            self.view.layoutIfNeeded()
                            
                            
            },  completion: {(_ completed: Bool) -> Void in
                self.goneUp = false
                //self.outerChartView.alpha = 1

            })
            }
            }
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if self.goneUp == true {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SCROLL_HOME_SCREEN"), object: true)
        }

//                    if self.goneUp == false {
//             return
//         }
//
//         DispatchQueue.main.async {
//             UIView.animate(
//                 withDuration: 1,
//                 animations: {
//                     var minHeight:CGFloat = 0
//                     if UserDefaults.standard.value(forKey: "NEW_USER") != nil {
//                         if self.trialPeriodExpired == true {
//                             minHeight = 70
//                         } else {
//                         minHeight = 190
//                         }
//                     } else {
//                         minHeight = 70
//                     }
//                     if self.showGraph == false {
//                          self.draggableViewHeightConstraint.constant = self.draggableConstant
//
//                     } else  {
//                         if IS_iPHONEXRXSMAX {
//
//                                                        self.draggableViewHeightConstraint.constant = 300 - 86 + minHeight
//                                                    } else if IS_iPHONEXXS {
//                                                        self.draggableViewHeightConstraint.constant = 150 + 30 + 20
//                                                    } else if IS_iPHONE678P {
//                                                        self.draggableViewHeightConstraint.constant = 130
//                                                    } else if IS_iPHONE678 {
//                                                        self.draggableViewHeightConstraint.constant = 175 - 76
//                                                    } else if IS_iPHONE5 {
//                                                        self.draggableViewHeightConstraint.constant = 30
//                                                    } else {
//                                                        self.draggableViewHeightConstraint.constant = 43 - 86
//                                                    }
//                     }
//
//                        // self.myNutritionDetailsView.alpha = 1
//                     self.switchButton.alpha = 1
//                         self.outerChartView.alpha = 1
//                     self.tweakBeforeDefaultView.alpha = 1
//
//                         self.bottomBtnViewTopConstraint.constant = -108
//
//                         self.view.layoutIfNeeded()
//
//
//         },  completion: {(_ completed: Bool) -> Void in
//             self.goneUp = false
//             //self.outerChartView.alpha = 1
//
//         })
//         }

    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews();
        self.myNutritionView.roundCorners(corners: [.topLeft, .topRight], radius: 10)
        self.outerChartView.roundCorners(corners: [.topLeft, .topRight], radius: 10)
        self.topButtonsDataView.roundCorners(corners: [.topLeft, .topRight], radius: 10)
        self.approxCalLeftView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10)
        self.view.layoutIfNeeded()
        if (self.myNutritionDetailsView != nil) {
            self.myNutritionDetailsView.frame = CGRect(x: 0, y: 0, width: self.myNutritionView.frame.width, height: self.myNutritionView.frame.height)
        }
        if self.isLoaded == false {
      //  self.updateUIAccordingTOEachDevice()
        }
        if IS_iPHONE678P {
            self.menuBtnHeightConstraint.constant = 50
        } else if IS_iPHONE678 {
            self.menuBtnHeightConstraint.constant = 40.5
        } else if IS_iPHONE5 {
            self.menuBtnHeightConstraint.constant = 26.5
        }
    }
    
    func updateUIAccordingTOEachDevice() {
//
//        if self.goneUp == true {
//                   return
//               }
//               if (IS_iPHONE5 || IS_IPHONE4) {
//                                    if self.showGraph == false {
//
//                                     if UserDefaults.standard.value(forKey: "NEW_USER") != nil {
//                                         if self.trialPeriodExpired == true {
//                                             self.taeClubViewTopConstraint.constant = 55
//
//                                              aaChartView.frame = CGRect(x: 0, y: 0, width: 320, height: 140)
//
//                                             self.chatViewHeightConstraint.constant = 140
//                                              self.draggableViewHeightConstraint.constant = 30
//                                             self.draggableConstant = self.draggableViewHeightConstraint.constant
//
//                                             self.trendButtonsView.isHidden = false
//                                             self.topButtonsDataView.isHidden = false
//                                             //self.minCalCountLabel.stopBlink()
//                                             self.beforeTweakImageViewHeightConstraint.constant = 0
//                                             self.topButtonsDataViewHeightConstraint.constant = 63
//                                             if (self.myNutritionDetailsView != nil) {
//                                                 self.myNutritionDetailsView.isHidden = false
//                                             }
//
//                                         } else {
//                                             self.chatViewHeightConstraint.constant = 0
//                                             aaChartView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
//                                             self.draggableViewHeightConstraint.constant = 30 + 100
//                                             self.draggableConstant = self.draggableViewHeightConstraint.constant
//
//                                             self.taeClubViewTopConstraint.constant = 55
//                                            if (self.myNutritionDetailsView != nil) {
//                                                self.myNutritionDetailsView.isHidden = true
//                                                self.switchButton.alpha = 0
//
//                                            }
//                                         }
//
//
//                                     } else {
//                                         self.taeClubViewTopConstraint.constant = 55
//
//                                          aaChartView.frame = CGRect(x: 0, y: 0, width: 320, height: 140)
//
//                                        self.chatViewHeightConstraint.constant = 140
//                                         self.draggableViewHeightConstraint.constant = 30
//                                         self.draggableConstant = self.draggableViewHeightConstraint.constant
//                                        if (self.myNutritionDetailsView != nil) {
//                                            self.switchButton.alpha = 1
//
//                                            if self.showGraph == true {
//                                                self.myNutritionDetailsView.isHidden = true
//                                            } else {
//                                            self.myNutritionDetailsView.isHidden = false
//                                            self.myNutritionDetailsView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 140 + 63)
//                                            }
//                                        }
//
//                                     }
//                                     self.monthBtnTrailingConstraint.constant = 30;
//
//                                    } else {
//                 //                   aaChartView.frame = CGRect(x: 0, y: 0, width: 375, height: 200)
//                 //                   self.chatViewHeightConstraint.constant = 200
//                 //
//                 //                   self.draggableViewHeightConstraint.constant = 150
//                                     if UserDefaults.standard.value(forKey: "NEW_USER") != nil {
//                                      aaChartView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
//
//                                         self.chatViewHeightConstraint.constant = 0
//                                      self.draggableViewHeightConstraint.constant = 30
//                                         self.draggableConstant = self.draggableViewHeightConstraint.constant
//                                        if (self.myNutritionDetailsView != nil) {
//                                            self.myNutritionDetailsView.isHidden = true
//                                            self.switchButton.alpha = 0
//
//                                        }
//
//
//                                     } else {
//                                        self.chatViewHeightConstraint.constant = 140
//                 aaChartView.frame = CGRect(x: 0, y: 0, width: 320, height: 140)
//                                      self.draggableViewHeightConstraint.constant = 30
//                                         self.draggableConstant = self.draggableViewHeightConstraint.constant
//                                        if (self.myNutritionDetailsView != nil) {
//                                            self.switchButton.alpha = 1
//
//                                            if self.showGraph == true {
//                                                self.myNutritionDetailsView.isHidden = true
//                                            } else {
//                                            self.myNutritionDetailsView.isHidden = false
//                                            self.myNutritionDetailsView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 140 + 63)
//                                            }
//                                        }
//
//                                     }
//
//                                     self.monthBtnTrailingConstraint.constant = 30;
//                                    }
//                self.monthBtnTrailingConstraint.constant = 30;
//                self.taeClubViewTopConstraint.constant = 55
//                self.draggableConstant = self.draggableViewHeightConstraint.constant
//               } else if IS_iPHONE678P {
//
//
//                   self.monthBtnTrailingConstraint.constant = 50;
//                self.taeClubViewTopConstraint.constant = 55
//                if UserDefaults.standard.value(forKey: "NEW_USER") != nil {
//                    if self.trialPeriodExpired == true {
//                        self.taeClubViewTopConstraint.constant = 55
//
//                         aaChartView.frame = CGRect(x: 0, y: 0, width: 414, height: 170)
//
//                        self.chatViewHeightConstraint.constant = 170
//                         self.draggableViewHeightConstraint.constant = 130 + 50
//                        self.draggableConstant = self.draggableViewHeightConstraint.constant
//                        self.trendButtonsView.isHidden = false
//                        self.topButtonsDataView.isHidden = false
//                        //self.minCalCountLabel.stopBlink()
//                        self.beforeTweakImageViewHeightConstraint.constant = 0
//                        self.topButtonsDataViewHeightConstraint.constant = 63
//                        if (self.myNutritionDetailsView != nil) {
//                            self.myNutritionDetailsView.isHidden = false
//                            //self.switchButton.isHidden = true
//                        }
//
//                    } else {
//                        self.chatViewHeightConstraint.constant = 0
//                                               aaChartView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
//                                               self.draggableViewHeightConstraint.constant = 130 + 50 + 110
//                        self.draggableConstant = self.draggableViewHeightConstraint.constant
//                        self.taeClubViewTopConstraint.constant = 55
//                        if (self.myNutritionDetailsView != nil) {
//                            self.myNutritionDetailsView.isHidden = true
//                            self.switchButton.alpha = 0
//                        }
//                    }
//
//
//                } else {
//                    self.taeClubViewTopConstraint.constant = 55
//
//                    aaChartView.frame = CGRect(x: 0, y: 0, width: 414, height: 170)
//                    self.beforeTweakImageViewHeightConstraint.constant = 0
//                    self.topButtonsDataViewHeightConstraint.constant = 63
//                   self.chatViewHeightConstraint.constant = 170
//                    self.draggableViewHeightConstraint.constant = 130 + 50
//                    self.draggableConstant = self.draggableViewHeightConstraint.constant
//                    if (self.myNutritionDetailsView != nil) {
//                        self.switchButton.alpha = 1
//
//                        if self.showGraph == true {
//                            self.myNutritionDetailsView.isHidden = true
//                        } else {
//                        self.myNutritionDetailsView.isHidden = false
//                        self.myNutritionDetailsView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 170 + 63)
//                        }
//                    }
//                }
//
//
//
//
//
//               } else if IS_iPHONE678 {
//
//                   aaChartView.frame = CGRect(x: 0, y: 0, width: 375, height: 160)
//                   self.chatViewHeightConstraint.constant = 160
//                   self.draggableViewHeightConstraint.constant = 175 - 76
//                //   self.foodImageShadowViewHeightConstraint.constant = 113
//                   self.premiumTweakPackBtnTopConstraint.constant = 8
//                   self.monthBtnTrailingConstraint.constant = 30;
//                self.taeClubViewTopConstraint.constant = 55
//                if UserDefaults.standard.value(forKey: "NEW_USER") != nil {
//                    if self.trialPeriodExpired == true {
//                        self.taeClubViewTopConstraint.constant = 55
//
//                         aaChartView.frame = CGRect(x: 0, y: 0, width: 375, height: 160)
//
//                        self.chatViewHeightConstraint.constant = 160
//                         self.draggableViewHeightConstraint.constant = 175 - 76
//                        self.draggableConstant = self.draggableViewHeightConstraint.constant
//                        self.trendButtonsView.isHidden = false
//                        self.topButtonsDataView.isHidden = false
//                        //self.minCalCountLabel.stopBlink()
//                        self.beforeTweakImageViewHeightConstraint.constant = 0
//                        self.topButtonsDataViewHeightConstraint.constant = 63
//                        if (self.myNutritionDetailsView != nil) {
//                            self.myNutritionDetailsView.isHidden = false
//                        }
//
//                    } else {
//                        self.chatViewHeightConstraint.constant = 0
//                                               aaChartView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
//                                               self.draggableViewHeightConstraint.constant = 175 - 76 + 130
//                        self.draggableConstant = self.draggableViewHeightConstraint.constant
//                        self.taeClubViewTopConstraint.constant = 55
//                        if (self.myNutritionDetailsView != nil) {
//                            self.myNutritionDetailsView.isHidden = true
//                            self.switchButton.alpha = 0
//                        }
//                    }
//
//
//                } else {
//                    self.taeClubViewTopConstraint.constant = 55
//
//                    aaChartView.frame = CGRect(x: 0, y: 0, width: 375, height: 160)
//
//                   self.chatViewHeightConstraint.constant = 160
//                    self.draggableViewHeightConstraint.constant = 175 - 76
//                    self.draggableConstant = self.draggableViewHeightConstraint.constant
//                    if (self.myNutritionDetailsView != nil) {
//                        self.switchButton.alpha = 1
//
//                        if self.showGraph == true {
//                            self.myNutritionDetailsView.isHidden = true
//                        } else {
//                        self.myNutritionDetailsView.isHidden = false
//                        self.myNutritionDetailsView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 160 + 63)
//                        }
//                    }
//                }
//
//                self.draggableConstant = self.draggableViewHeightConstraint.constant
//
//               } else if IS_iPHONEXXS {
//                   if self.showGraph == false {
//
//                    if UserDefaults.standard.value(forKey: "NEW_USER") != nil {
//                        if self.trialPeriodExpired == true {
//                            self.taeClubViewTopConstraint.constant = 55
//
//                             aaChartView.frame = CGRect(x: 0, y: 0, width: 375, height: 160)
//
//                            self.chatViewHeightConstraint.constant = 160
//                             self.draggableViewHeightConstraint.constant = 150 + 30 + 20
//                            self.draggableConstant = self.draggableViewHeightConstraint.constant
//
//                            self.trendButtonsView.isHidden = false
//                            self.topButtonsDataView.isHidden = false
//                            //self.minCalCountLabel.stopBlink()
//                            self.beforeTweakImageViewHeightConstraint.constant = 0
//                            self.topButtonsDataViewHeightConstraint.constant = 63
//                            if (self.myNutritionDetailsView != nil) {
//                                self.myNutritionDetailsView.isHidden = false
//                            }
//
//                        } else {
//                            self.chatViewHeightConstraint.constant = 0
//                            aaChartView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
//                            self.draggableViewHeightConstraint.constant = 150 + 30 + 20 + 160
//                            self.draggableConstant = self.draggableViewHeightConstraint.constant
//
//                            self.taeClubViewTopConstraint.constant = 55
//                            if (self.myNutritionDetailsView != nil) {
//                                self.myNutritionDetailsView.isHidden = true
//                                self.switchButton.alpha = 0
//                            }
//                        }
//
//
//                    } else {
//                        self.taeClubViewTopConstraint.constant = 55
//
//                         aaChartView.frame = CGRect(x: 0, y: 0, width: 375, height: 170)
//
//                       self.chatViewHeightConstraint.constant = 170
//                        self.draggableViewHeightConstraint.constant = 150 + 30 + 20 + 30
//                        self.draggableConstant = self.draggableViewHeightConstraint.constant
//                        if (self.myNutritionDetailsView != nil) {
//                            self.switchButton.alpha = 1
//
//                            if self.showGraph == true {
//                                self.myNutritionDetailsView.isHidden = true
//                            } else {
//                            self.myNutritionDetailsView.isHidden = false
//                            self.myNutritionDetailsView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 170 + 63)
//                            }
//                        }
//                    }
//                    self.monthBtnTrailingConstraint.constant = 30;
//
//                   } else {
////                   aaChartView.frame = CGRect(x: 0, y: 0, width: 375, height: 200)
////                   self.chatViewHeightConstraint.constant = 200
////
////                   self.draggableViewHeightConstraint.constant = 150
//                    if UserDefaults.standard.value(forKey: "NEW_USER") != nil {
//                     aaChartView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
//
//                        self.chatViewHeightConstraint.constant = 0
//                     self.draggableViewHeightConstraint.constant = 150 + 30
//                        self.draggableConstant = self.draggableViewHeightConstraint.constant
//                        if (self.myNutritionDetailsView != nil) {
//                            self.myNutritionDetailsView.isHidden = true
//                            self.switchButton.alpha = 0
//                        }
//
//
//                    } else {
//                       self.chatViewHeightConstraint.constant = 200
//aaChartView.frame = CGRect(x: 0, y: 0, width: 375, height: 200)
//                     self.draggableViewHeightConstraint.constant = 150 + 30 + 20
//                        self.draggableConstant = self.draggableViewHeightConstraint.constant
//                        if (self.myNutritionDetailsView != nil) {
//                                                   self.switchButton.alpha = 1
//
//                                                   if self.showGraph == true {
//                                                       self.myNutritionDetailsView.isHidden = true
//                                                   } else {
//                                                   self.myNutritionDetailsView.isHidden = false
//                                                   self.myNutritionDetailsView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 170 + 63)
//                                                   }
//                                               }
//                    }
//
//                    self.monthBtnTrailingConstraint.constant = 30;
//                   }
//                self.taeClubViewTopConstraint.constant = 55
//
//
//               } else if IS_iPHONEXRXSMAX {
//                   if self.showGraph == false {
//                    if UserDefaults.standard.value(forKey: "NEW_USER") != nil {
//                        if self.trialPeriodExpired == true {
//                            self.taeClubViewTopConstraint.constant = 55
//
//                             aaChartView.frame = CGRect(x: 0, y: 0, width: 414, height: 170)
//
//                            self.chatViewHeightConstraint.constant = 170
//                             self.draggableViewHeightConstraint.constant = 300 - 86 + 30 + 70
//                            self.trendButtonsView.isHidden = false
//                            self.topButtonsDataView.isHidden = false
//                            //self.minCalCountLabel.stopBlink()
//                            self.beforeTweakImageViewHeightConstraint.constant = 0
//                            self.topButtonsDataViewHeightConstraint.constant = 63
//                            if (self.myNutritionDetailsView != nil) {
//                                self.myNutritionDetailsView.isHidden = false
//                            }
//
//                        } else {
//                            self.chatViewHeightConstraint.constant = 0
//                                                   aaChartView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
//                                                   self.draggableViewHeightConstraint.constant = 300 - 86 + 30 + 190
//                                                   self.taeClubViewTopConstraint.constant = 55
//                                                   if (self.myNutritionDetailsView != nil) {
//                                self.myNutritionDetailsView.isHidden = true
//                                self.switchButton.alpha = 0
//                            }
//
//                        }
//
//
//                    } else {
//                        self.taeClubViewTopConstraint.constant = 55
//
//                        aaChartView.frame = CGRect(x: 0, y: 0, width: 414, height: 170)
//
//                       self.chatViewHeightConstraint.constant = 170
//                        self.draggableViewHeightConstraint.constant = 300 - 86 + 30 + 70
//                        if (self.myNutritionDetailsView != nil) {
//                                                   self.switchButton.alpha = 1
//
//                                                   if self.showGraph == true {
//                                                       self.myNutritionDetailsView.isHidden = true
//                                                   } else {
//                                                   self.myNutritionDetailsView.isHidden = false
//                                                   self.myNutritionDetailsView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 170 + 63)
//                                                   }
//                                               }
//                    }
//                    self.draggableConstant = self.draggableViewHeightConstraint.constant
//
//                       self.monthBtnTrailingConstraint.constant = 50;
//                   } else {
//
//                   if UserDefaults.standard.value(forKey: "NEW_USER") != nil {
//                    aaChartView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
//
//                       self.chatViewHeightConstraint.constant = 0
//                    self.draggableViewHeightConstraint.constant = 300 - 86 + 190
//                    if (self.myNutritionDetailsView != nil) {
//                        self.myNutritionDetailsView.isHidden = true
//                        self.switchButton.alpha = 0
//                    }
//
//                   } else {
//                      self.chatViewHeightConstraint.constant = 200
//                    aaChartView.frame = CGRect(x: 0, y: 0, width: 414, height: 200)
//                    self.draggableViewHeightConstraint.constant = 300 - 86 + 70
//                    if (self.myNutritionDetailsView != nil) {
//                                                              self.switchButton.alpha = 1
//
//                                                              if self.showGraph == true {
//                                                                  self.myNutritionDetailsView.isHidden = true
//                                                              } else {
//                                                              self.myNutritionDetailsView.isHidden = false
//                                                              self.myNutritionDetailsView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200 + 63)
//                                                              }
//                                                          }
//                   }
//                    self.draggableConstant = self.draggableViewHeightConstraint.constant
//
//                    self.monthBtnTrailingConstraint.constant = 50;
//                                      }
//
//               }
        aaChartView.frame = CGRect(x: 0, y: 0, width: self.chartView.frame.width, height: self.chartView.frame.height)
        self.view.layoutIfNeeded()
        self.loadingView.frame = CGRect(x: self.outerChartView.frame.origin.x, y: self.outerChartView.frame.origin.y, width: self.outerChartView.frame.size.width, height: self.chartView.frame.maxY)
        self.isLoaded = true
    }
    
    @objc func pushToTimeLines() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let homeViewController = storyBoard.instantiateViewController(withIdentifier: "timelinesViewController") as! TimelinesViewController;
        self.navigationController?.pushViewController(homeViewController, animated: true);
        return
    }
    
    @objc func moveToRespectedPage(_ notify: NSNotification) {
        print(notify.object as! String)
        if notify.object as! String == "RECIPEWALL" {
            self.performSegue(withIdentifier: "recipeWall", sender: self);
            
        } else if notify.object as! String == "TWEAKWALL" {
            self.performSegue(withIdentifier: "myWall", sender: self);
        } else if notify.object as! String == "DEVICEINTEGRATION" {
            if (UserDefaults.standard.value(forKey: "FITBIT_TOKEN") == nil && UserDefaults.standard.value(forKey: "HEALTHKIT") == nil)  {
                
                self.performSegue(withIdentifier: "connectNewDevice", sender: self);
                
            } else if (UserDefaults.standard.value(forKey: "HEALTHKIT") == nil &&  UserDefaults.standard.value(forKey: "FITBIT_TOKEN") != nil) {
                self.performSegue(withIdentifier: "activityTracker", sender: self);
                
            } else if (UserDefaults.standard.value(forKey: "HEALTHKIT") != nil &&  UserDefaults.standard.value(forKey: "FITBIT_TOKEN") == nil) {
                self.performSegue(withIdentifier: "activityTracker", sender: self);
            }
        } else if notify.object as! String == "TWEAKWALL" {
            self.performSegue(withIdentifier: "myWall", sender: self);
        } else if notify.object as! String == "PROFILE" {
            self.goToSettings(index: 2);
        } else if notify.object as! String == "REMINDERS" {
            self.goToSettings(index: 1);
        } else if notify.object as! String == "WEIGHTREADINGS" {
            self.performSegue(withIdentifier: "profile", sender: self);
        }
        return
    }
    
    @objc func tapOnPromoAd(mhp_id: Int) {
        let param = ["pid": mhp_id]
        APIWrapper.sharedInstance.homePromoClick(param as NSDictionary, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, successBlock: {(responseDic : AnyObject!) -> (Void) in

            let status = responseDic as! [String:AnyObject];
            let responseResult = status["callStatus"] as! String
            if  responseResult == "GOOD" {
              //  self.getAdDetails()
                print("yahooooo")
            }
            
        }, failureBlock: { (error : NSError!) -> (Void) in
            //error
            print("error");
          
        })
        
    }
    
    @objc func getAdDetails() {
        APIWrapper.sharedInstance.postRequestWithHeaders(TweakAndEatURLConstants.GET_HOME_PROMO, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, success: { response in
            self.getPromoResponse = response as! [String:AnyObject];
            let responseResult = self.getPromoResponse["callStatus"] as! String
            if  responseResult == "GOOD" {
                print("Sucess")
                let data = self.getPromoResponse["data"] as! [String: AnyObject]
                if data.count > 0 {
                DispatchQueue.main.async {
                    if (data["@mhp_img"] is NSNull) {
                        return
                    }
                    
                    let promoImgUrl = data["@mhp_img"] as! String
                    self.randomPromoLink = data["@mhp_link"] as! String
                    self.mhpId = data["@mhp_id"] as! Int



                        self.adsImageView.sd_setImage(with: URL(string: promoImgUrl)) { (image, error, cache, url) in
                                                                           // Your code inside completion block
                            self.adsImageView.isUserInteractionEnabled = true;

                            if image != nil {
                          let ratio = image!.size.width / image!.size.height
                          let newHeight = self.adsImageView.frame.width / ratio
                         
                              UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut],
                                                    animations: {
                                                     self.adsImageViewHeightConstraint.constant = newHeight
                                                      self.view.layoutIfNeeded()
                                     }, completion: nil)


                          }
                        }
                }

                }
            }
        }, failure : { error in
            
          //  TweakAndEatUtils.AlertView.showAlert(view: self, message: "Your internet connection is appears to be offline !!")
            
        })
    }
  
    @objc func getWeightInLbs() {
        self.weightFieldArray = [String]()
        for i in 20...550 {
            let str1 = String(i)
            let str2 = "lbs"
            let str3 = "\(str1) \(str2)"
            self.weightFieldArray.append(str3)
            
        }
    }
    
    func getDataTrendsArray(dictionary: [String: AnyObject], tweakDictionary: [String: AnyObject]) {
       // let dictionary: [String: AnyObject] = self.loadJson(filename: "sample")!["tweaks"] as! [String : AnyObject]
                self.caloriesArray = NSMutableArray()
                self.carbsArray = NSMutableArray()
                self.fatssArray = NSMutableArray()
                self.proteinArray = NSMutableArray()
                self.last10Data = [LastTenData]()
                self.todayData = [TodayData]()
                self.monthData = [MonthData]()
                self.weekData = [WeekData]()
        var minCalories = 0
        var maxCalories = 0
        var todayCalories = 0
        UserDefaults.standard.set(0 , forKey: "TODAY_CALORIES")
        UserDefaults.standard.synchronize()
        UserDefaults.standard.set(0, forKey: "MAX_CALORIES")
        UserDefaults.standard.synchronize()
        UserDefaults.standard.set(0, forKey: "MIN_CALORIES")
        UserDefaults.standard.synchronize()
       // let calDictionary: [String: AnyObject] = self.loadJson(filename: "sample")!
        minCalories = tweakDictionary["userMinCalsPerDay"] as AnyObject as! Int
        maxCalories = tweakDictionary["userMaxCalsPerDay"] as AnyObject as! Int
        UserDefaults.standard.set(maxCalories, forKey: "MAX_CALORIES")
        UserDefaults.standard.synchronize()
        UserDefaults.standard.set(minCalories, forKey: "MIN_CALORIES")
        UserDefaults.standard.synchronize()
        if dictionary.index(forKey: "lastTenData") != nil {
        let last10DataArray = dictionary["lastTenData"] as AnyObject as! NSArray
        for data in last10DataArray {
            let dataDict = data as! [String: AnyObject]
            self.last10Data.append(LastTenData(tweak_id: dataDict["tweak_id"] as! Int, type: dataDict["type"] as! String, tweak_modified_image_url: dataDict["tweak_modified_image_url"] as! String, total_calories: dataDict["total_calories"] as! Int, carbs_perc: dataDict["carbs_perc"] as! Int, fats_perc: dataDict["fats_perc"] as! Int, fiber_perc: dataDict["fiber_perc"] as! Int, protein_perc: dataDict["protein_perc"] as! Int, others_perc: dataDict["others_perc"] as! Int, meal_type: dataDict["meal_type"] as! Int, tweak_crt_dttm: dataDict["tweak_crt_dttm"] as! String, tweak_upd_dttm: dataDict["tweak_upd_dttm"] as! String))
        }
        self.last10Data = self.last10Data.sorted(by: { $0.tweak_upd_dttm > $1.tweak_upd_dttm })
        }
        if dictionary.index(forKey: "todaysData") != nil {
        let todayDataArray = dictionary["todaysData"] as AnyObject as! NSArray
        for data in todayDataArray {
            let dataDict = data as! [String: AnyObject]
            todayCalories += dataDict["total_calories"] as! Int
            self.todayData.append(TodayData(tweak_id: dataDict["tweak_id"] as! Int, type: dataDict["type"] as! String, tweak_modified_image_url: dataDict["tweak_modified_image_url"] as! String, total_calories: dataDict["total_calories"] as! Int, carbs_perc: dataDict["carbs_perc"] as! Int, fats_perc: dataDict["fats_perc"] as! Int, fiber_perc: dataDict["fiber_perc"] as! Int, protein_perc: dataDict["protein_perc"] as! Int, others_perc: dataDict["others_perc"] as! Int, meal_type: dataDict["meal_type"] as! Int, tweak_crt_dttm: dataDict["tweak_crt_dttm"] as! String, tweak_upd_dttm: dataDict["tweak_upd_dttm"] as! String))
        }
            UserDefaults.standard.set(todayCalories, forKey: "TODAY_CALORIES")
            UserDefaults.standard.synchronize()

        self.todayData = self.todayData.sorted(by: { $0.tweak_upd_dttm > $1.tweak_upd_dttm })
        }
        let mean: CGFloat = CGFloat((minCalories + maxCalories) / 2)
        let approxCal = Int(mean) - todayCalories
        UserDefaults.standard.set(Int(mean), forKey: "MEAN_CALORIES")
        UserDefaults.standard.synchronize()
        UserDefaults.standard.set(approxCal, forKey: "APPROX_CALORIES")
        UserDefaults.standard.synchronize()
        DispatchQueue.main.async {
            self.minCalCountLabel.text = "\(approxCal <= 0 ? 0: approxCal)";
        }
if dictionary.index(forKey: "weeksData") != nil {
        let weeksDataArray = dictionary["weeksData"] as AnyObject as! NSArray
        for data in weeksDataArray {
            let dataDict = data as! [String: AnyObject]
            self.weekData.append(WeekData(tweak_id: dataDict["tweak_id"] as! Int, type: dataDict["type"] as! String, tweak_modified_image_url: dataDict["tweak_modified_image_url"] as! String, total_calories: dataDict["total_calories"] as! Int, carbs_perc: dataDict["carbs_perc"] as! Int, fats_perc: dataDict["fats_perc"] as! Int, fiber_perc: dataDict["fiber_perc"] as! Int, protein_perc: dataDict["protein_perc"] as! Int, others_perc: dataDict["others_perc"] as! Int, meal_type: dataDict["meal_type"] as! Int, tweak_crt_dttm: dataDict["tweak_crt_dttm"] as! String, tweak_upd_dttm: dataDict["tweak_upd_dttm"] as! String))
        }
        self.weekData = self.weekData.sorted(by: { $0.tweak_upd_dttm > $1.tweak_upd_dttm })
        }
        if dictionary.index(forKey: "monthsData") != nil {

        let monthDataArray = dictionary["monthsData"] as AnyObject as! NSArray
        for data in monthDataArray {
            let dataDict = data as! [String: AnyObject]
            self.monthData.append(MonthData(tweak_id: dataDict["tweak_id"] as! Int, type: dataDict["type"] as! String, tweak_modified_image_url: dataDict["tweak_modified_image_url"] as! String, total_calories: dataDict["total_calories"] as! Int, carbs_perc: dataDict["carbs_perc"] as! Int, fats_perc: dataDict["fats_perc"] as! Int, fiber_perc: dataDict["fiber_perc"] as! Int, protein_perc: dataDict["protein_perc"] as! Int, others_perc: dataDict["others_perc"] as! Int, meal_type: dataDict["meal_type"] as! Int, tweak_crt_dttm: dataDict["tweak_crt_dttm"] as! String, tweak_upd_dttm: dataDict["tweak_upd_dttm"] as! String))
        }
        self.monthData = self.monthData.sorted(by: { $0.tweak_upd_dttm > $1.tweak_upd_dttm })
        }
    }
    
    @objc func getTrends() {
        //api call for labelperc
//        self.loadingView.isHidden = false
//        MBProgressHUD.showAdded(to: self.loadingView, animated: true)
        
        if UserDefaults.standard.value(forKey: "userSession") == nil {
            
        } else {
           // MBProgressHUD.showAdded(to: self.view, animated: true)
        
            let userSession : String = UserDefaults.standard.value(forKey: "userSession") as! String;
        APIWrapper.sharedInstance.getTweakLabels(userSession: userSession, successBlock: {(responseDic : AnyObject!) -> (Void) in
            print("Sucess");
            print(responseDic);
            //MBProgressHUD.hide(for: self.view, animated: true)
            if responseDic["callStatus"] as AnyObject as! String == "GOOD" {
               // MBProgressHUD.hide(for: self.view, animated: true);
                //self.tweaksArray = responseDic["tweaks"] as AnyObject as! NSArray
                let tweakDict = responseDic as AnyObject as! [String: AnyObject]
                let tweakLblDict = tweakDict["tweaks"] as! [String : AnyObject]
                self.draggableView.isUserInteractionEnabled = true
                self.getDataTrendsArray(dictionary: tweakLblDict, tweakDictionary: tweakDict)
                self.setDefaultDataBtns(name: self.dataBtnName)
                
                

                
            }
            
        }, failureBlock: {(error : NSError!) -> (Void) in
            print("Failure");
           // MBProgressHUD.hide(for: self.view, animated: true);
            if error?.code == -1011 {
                
                self.startTweakingView.isHidden = false;
                self.startTweakingLabel.alpha = 1.0
                self.startTweakingView.alpha = 0.9
                self.startTweakingLabel.text = "Start Tweaking to see your own Nutritional Trend here. Make the Trend your friend!";
                self.setDefaultsTrendBtns()
             //   self.updateChartFromSecondTime(backGroundCol: "#168c7a", data: [20,100,30,150,200,50,300,40,400,30], name: "Calories", colorTheme: ["#528039"])
                self.updateChart(backGroundCol: "#168c7a", data:  [20,100,30,150,200,50,300,40,400,30] as [Any], name: "Calories", colorTheme: ["#FFFFFF"])
                
            }
//            TweakAndEatUtils.AlertView.showAlert(view: self, message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil));
        })
        }
    }
    
    func setDefaultsTrendBtns() {
        DispatchQueue.main.async {
            
          
            self.myTrendsLabel.text = "MY CALORIE TRENDS"
            self.caloriesButton.backgroundColor = UIColor.black.withAlphaComponent(0.3);
            self.carbsButton.layer.borderColor = UIColor.white.cgColor
            self.carbsButton.layer.borderWidth = 1
            self.caloriesButton.layer.borderColor = UIColor.white.cgColor
            self.caloriesButton.layer.borderWidth = 1
            self.fatButton.layer.borderColor = UIColor.white.cgColor
            self.fatButton.layer.borderWidth = 1
            self.protienButton.layer.borderColor = UIColor.white.cgColor
            self.protienButton.layer.borderWidth = 1
           
            self.carbsButton.layer.cornerRadius = 5
            self.caloriesButton.layer.cornerRadius = 5
            self.fatButton.layer.cornerRadius = 5
            self.protienButton.layer.cornerRadius = 5
        }
    }
    
    //tappedOnTAEClubTrialPeriodExpiryView
    @objc func tappedOnTAEClubTrialPeriodExpiryView() {
        tappedOnTAEClubExpiryView()
    }
    @objc func tappedOntrialPeriodExpiryView() {
        self.performSegue(withIdentifier: "buyPackages", sender: self);

        //self.performSegue(withIdentifier: "premiumTweakPack", sender: self)
//               if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
//                  self.countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
//           if self.countryCode == "62" {
//       if UserDefaults.standard.value(forKey: "-ClubIdn4hd8flchs9Vy") != nil {
//                             self.goToTAEClubMemPage()
//
//                         } else {
//                             self.goToTAEClub()
//                         }
//           } else {
//               self.performSegue(withIdentifier: "buyPackages", sender: self);
//
//           }
//       }
        
    }
    @objc func setupNavigationTitle() {
         let titleImg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width * 0.7, height: 44))
               titleImg.image = UIImage.init(named: "TweakAndEatTitleImage")
               titleImg.contentMode = .scaleAspectFit
               navigationItem.titleView = titleImg
    }
    
    func loadJson(filename fileName: String) -> [String: AnyObject]? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                if let dictionary = object as? [String: AnyObject] {
                    
                    return dictionary
                }
            } catch {
                print("Error!! Unable to parse  \(fileName).json")
            }
        }
        return nil
    }
    
    @IBAction func todayBtnTapped(_ sender: Any) {
        self.mealType = 0
        self.mealTypeLabel.text = "All"
        self.dataBtnName = "todaysData"
        self.nutritionViewSelectedMeal = bundle.localizedString(forKey: "select_meal_type", value: nil, table: nil);
        self.nutritionViewLast10TweaksDataVal = "Today"
        
        
        self.setDefaultDataBtns(name: "todaysData")
    }
    @IBAction func weekBtnTapped(_ sender: Any) {
        self.mealType = 0
        self.mealTypeLabel.text = "All"
        self.dataBtnName = "weeksData"
        self.nutritionViewSelectedMeal = bundle.localizedString(forKey: "select_meal_type", value: nil, table: nil);
        self.nutritionViewLast10TweaksDataVal = "Week"
        self.setDefaultDataBtns(name: "weeksData")
    }
    
    @IBAction func monthBtnTapped(_ sender: Any) {
        self.mealType = 0
        self.mealTypeLabel.text = "All"
        self.dataBtnName = "monthsData"
        self.nutritionViewSelectedMeal = bundle.localizedString(forKey: "select_meal_type", value: nil, table: nil);
        self.nutritionViewLast10TweaksDataVal = "Month"
        self.setDefaultDataBtns(name: "monthsData")
    }
    
    @IBAction func last10TweaksBtnTapped(_ sender: Any) {
        self.mealType = 0
        self.mealTypeLabel.text = "All"
        self.dataBtnName = "lastTenData"
        self.nutritionViewSelectedMeal = bundle.localizedString(forKey: "select_meal_type", value: nil, table: nil);
        self.nutritionViewLast10TweaksDataVal = bundle.localizedString(forKey: "last_ten_tweaks", value: nil, table: nil);
        self.setDefaultDataBtns(name: "lastTenData")
        
       
    }
    
    func setDefaultDataBtns(name: String) {
        self.caloriesArray = NSMutableArray()
        self.carbsArray = NSMutableArray()
        self.fatssArray = NSMutableArray()
        self.proteinArray = NSMutableArray()
        self.noGraphDataLabel.isHidden = true
        if name == "lastTenData" {
            self.last10TweaksBtn.layer.cornerRadius = 5
            self.last10TweaksBtn.backgroundColor = UIColor.black.withAlphaComponent(0.3);
            self.todayBtn.layer.cornerRadius = 0
            self.todayBtn.backgroundColor = UIColor.clear
            self.todayBtn.alpha = 1.0
            self.weekBtn.layer.cornerRadius = 0
            self.weekBtn.backgroundColor = UIColor.clear
            self.weekBtn.alpha = 1.0
            self.monthBtn.layer.cornerRadius = 0
            self.monthBtn.backgroundColor = UIColor.clear
            self.monthBtn.alpha = 1.0
            if self.last10Data.count > 0 {
            var sortingArr = [LastTenData]()
            if self.mealType != 0 {
              sortingArr = self.last10Data.sorted(by: { $0.tweak_upd_dttm > $1.tweak_upd_dttm }).filter({$0.type == self.dataBtnName}).filter({$0.meal_type == self.mealType})
            } else {
                sortingArr = self.last10Data.sorted(by: { $0.tweak_upd_dttm > $1.tweak_upd_dttm }).filter({$0.type == self.dataBtnName})
            }
            for data in sortingArr {
                self.caloriesArray.add(CGFloat(data.total_calories));
                self.carbsArray.add(CGFloat(data.carbs_perc));
                self.proteinArray.add(CGFloat(data.protein_perc));
                self.fatssArray.add(CGFloat(data.fats_perc));
            }
            }
        } else if name == "todaysData" {
            self.todayBtn.layer.cornerRadius = 5
            self.todayBtn.backgroundColor = UIColor.black.withAlphaComponent(0.3);
            self.weekBtn.layer.cornerRadius = 0
            self.weekBtn.backgroundColor = UIColor.clear
            self.weekBtn.alpha = 1.0
            self.monthBtn.layer.cornerRadius = 0
            self.monthBtn.backgroundColor = UIColor.clear
            self.monthBtn.alpha = 1.0
            self.last10TweaksBtn.layer.cornerRadius = 0
            self.last10TweaksBtn.backgroundColor = UIColor.clear
            self.last10TweaksBtn.alpha = 1.0
             if self.todayData.count > 0 {
            var sortingArr = [TodayData]()
            if self.mealType != 0 {
                sortingArr = self.todayData.sorted(by: { $0.tweak_upd_dttm > $1.tweak_upd_dttm }).filter({$0.type == self.dataBtnName}).filter({$0.meal_type == self.mealType})
            } else {
                sortingArr = self.todayData.sorted(by: { $0.tweak_upd_dttm > $1.tweak_upd_dttm }).filter({$0.type == self.dataBtnName})
            }
          
            for data in sortingArr {
                self.caloriesArray.add(CGFloat(data.total_calories));
                self.carbsArray.add(CGFloat(data.carbs_perc));
                self.proteinArray.add(CGFloat(data.protein_perc));
                self.fatssArray.add(CGFloat(data.fats_perc));
            }
            }
        }  else if name == "weeksData" {
            self.weekBtn.layer.cornerRadius = 5
            self.weekBtn.backgroundColor = UIColor.black.withAlphaComponent(0.3);
            self.monthBtn.layer.cornerRadius = 0
            self.monthBtn.backgroundColor = UIColor.clear
            self.monthBtn.alpha = 1.0
            self.last10TweaksBtn.layer.cornerRadius = 0
            self.last10TweaksBtn.backgroundColor = UIColor.clear
            self.last10TweaksBtn.alpha = 1.0
            self.todayBtn.layer.cornerRadius = 0
            self.todayBtn.backgroundColor = UIColor.clear
            self.todayBtn.alpha = 1.0
           if self.weekData.count > 0 {
                var sortingArr = [WeekData]()
                if self.mealType != 0 {
                    sortingArr = self.weekData.sorted(by: { $0.tweak_upd_dttm > $1.tweak_upd_dttm }).filter({$0.type == self.dataBtnName}).filter({$0.meal_type == self.mealType})
                } else {
                    sortingArr = self.weekData.sorted(by: { $0.tweak_upd_dttm > $1.tweak_upd_dttm }).filter({$0.type == self.dataBtnName})
                }
                
                for data in sortingArr {
                self.caloriesArray.add(CGFloat(data.total_calories));
                self.carbsArray.add(CGFloat(data.carbs_perc));
                self.proteinArray.add(CGFloat(data.protein_perc));
                self.fatssArray.add(CGFloat(data.fats_perc));
            }
            }
        }   else if name == "monthsData" {
            self.monthBtn.layer.cornerRadius = 5
            self.monthBtn.backgroundColor = UIColor.black.withAlphaComponent(0.3);
            self.last10TweaksBtn.layer.cornerRadius = 0
            self.last10TweaksBtn.backgroundColor = UIColor.clear
            self.last10TweaksBtn.alpha = 1.0
            self.todayBtn.layer.cornerRadius = 0
            self.todayBtn.backgroundColor = UIColor.clear
            self.todayBtn.alpha = 1.0
            self.weekBtn.layer.cornerRadius = 0
            self.weekBtn.backgroundColor = UIColor.clear
            self.weekBtn.alpha = 1.0
         if self.monthData.count > 0 {
                var sortingArr = [MonthData]()
                if self.mealType != 0 {
                    sortingArr = self.monthData.sorted(by: { $0.tweak_upd_dttm > $1.tweak_upd_dttm }).filter({$0.type == self.dataBtnName}).filter({$0.meal_type == self.mealType})
                } else {
                    sortingArr = self.monthData.sorted(by: { $0.tweak_upd_dttm > $1.tweak_upd_dttm }).filter({$0.type == self.dataBtnName})
                }
                
                for data in sortingArr {
                self.caloriesArray.add(CGFloat(data.total_calories));
                self.carbsArray.add(CGFloat(data.carbs_perc));
                self.proteinArray.add(CGFloat(data.protein_perc));
                self.fatssArray.add(CGFloat(data.fats_perc));
            }
            }
        }
        UserDefaults.standard.set(self.caloriesArray, forKey: "GET_TREND_CALORIES")
        UserDefaults.standard.synchronize()
//        MBProgressHUD.hide(for: self.loadingView, animated: true);
//        self.loadingView.isHidden = true
        if self.showGraph == true {
            DispatchQueue.main.async {
                            if self.trends == "Calories" {
                                     
                                  self.updateChartFromSecondTime(backGroundCol: "#168c7a", data: self.caloriesArray as! [Any], name: "Calories", colorTheme: ["#528039"])
                                      
                                  } else if self.trends == "Carbs" {
                                      self.updateChartFromSecondTime(backGroundCol: "#ce1371", data: self.carbsArray as! [Any], name: "Carbs", colorTheme: ["#9E1B76"])
                                  } else if self.trends == "Protein" {
                                      self.updateChartFromSecondTime(backGroundCol: "#69b04c", data: self.proteinArray as! [Any], name: "Protein", colorTheme: ["#0B6B64"])
                                  } else if self.trends == "Fats" {
                                      self.updateChartFromSecondTime(backGroundCol: "#d49741", data: self.fatssArray as! [Any], name: "Fat", colorTheme: ["#D79F53"])
                                  }
                                  if (self.caloriesArray.count == 0 || self.carbsArray.count == 0 || self.proteinArray.count == 0 ||
                                  self.fatssArray.count == 0) {
                                      self.noGraphDataLabel.isHidden = false
                                      self.noGraphDataLabel.text = "No Trends found! Start Tweaking now to see your own Nutritional Trend here. Make the Trend your friend! "
                                      self.view.bringSubviewToFront(self.noGraphDataLabel)
                                  }
                       }
       
        } else {
//            if UserDefaults.standard.value(forKey: "NEW_USER") != nil {
//                               } else {
//                                              self.showMyNutritionDetails()
//
//                               }
             self.showMyNutritionDetails()
        }
    }
    
    @IBAction func infoIconBarButtonTapped(_ sender: Any) {
//        if self.countryCode == "62" {
//            return
//        }
        //HandleRedirections.sharedInstance.tappedOnPopUpDone(link: "-IndWLIntusoe3uelxER")
        self.infoIconTapped = true
        showHowToTweakScreen()

        
    }
    func getMealTypes(tblView: UITableView) {
        APIWrapper.sharedInstance.getMealTypes({ (responceDic : AnyObject!) -> (Void) in
            if(TweakAndEatUtils.isValidResponse(responceDic as? [String:AnyObject])) {
                let response : [String:AnyObject] = responceDic as! [String:AnyObject]
                
                if(response[TweakAndEatConstants.CALL_STATUS] as! String == TweakAndEatConstants.TWEAK_STATUS_GOOD) {
                    MBProgressHUD.hide(for: tblView, animated: true)
                    self.mealTypeArray = (response["data"] as AnyObject as! NSArray) as! [[String : AnyObject]]
                    let allType: [String:AnyObject] = ["value": 0 as AnyObject , "name": "All" as AnyObject];
                    self.mealTypeArray.insert(allType, at: 0)
                    print(self.mealTypeArray)
                    tblView.reloadData()
                   
                }
                
            }else {
                //error
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: tblView, animated: true)
                }
                print("error")
                
                TweakAndEatUtils.AlertView.showAlert(view: self, message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil))
            }
        }) { (error : NSError!) -> (Void) in
            //error
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: tblView, animated: true)
            }
            
           
            
        }
    }
    
    
    @IBAction func caloriesInfoBtnTapped(_ sender: Any) {
        TweakAndEatUtils.AlertView.showAlert(view: self, message: "Your Approximate calorie range left for the day is indicated here.\n\n Calorie range indicated is calculated automatically based on your personal profile i.e your height,weight,BMI etc");
        
    }
    @IBAction func selectMealTypeBtnTapped(_ sender: Any) {
        if  self.mealTypeTableView.isHidden == true {
            MBProgressHUD.showAdded(to: self.mealTypeTableView, animated: true)
         self.mealTypeTableView.isHidden = false
        }
        self.getMealTypes(tblView: self.mealTypeTableView)
    }
    
    func dummyNavigation() {
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
//        let clickViewController = storyBoard.instantiateViewController(withIdentifier: "TAEClub4VCViewController") as? TAEClub4VCViewController;
//        clickViewController?.fromPopUpScreen = true
//        self.navigationController?.pushViewController(clickViewController!, animated: true)
        //self.dummyNav2(packageIDs: "-ClubInd3gu7tfwko6Zx", identifier: "CLUB_PUR_IND_OP_1M")

        //self.dummyNav2(packageIDs: "-IndIWj1mSzQ1GDlBpUt", identifier: "MYTAE_PUR_IND_OP_3M")
self.dummyNav2(packageIDs: "-MzqlVh6nXsZ2TCdAbOp", identifier: "WLIF_PUR_IND_OP_3M")
        
    }
    
    func dummyNav2(packageIDs: String, identifier: String) {
        self.goToBuyScreen(packageID: packageIDs, identifier: identifier)
    }
    
    func dummyPopUp() {
        self.smallScreenPopUp.isHidden = false
        self.smallScreenPopUpImageView.sd_setImage(with: URL(string: "https://ptadworks.s3.ap-south-1.amazonaws.com/tweakandeatcovid/popup_covid_ind_001.jpg")) { (image, error, cache, url) in
            // Your code inside completion block
            let ratio = image!.size.width / image!.size.height
            let newHeight = self.smallScreenPopUpImageView.frame.width / ratio
            self.smallScreenPopupImageViewHeightConstraint.constant = newHeight
            self.view.layoutIfNeeded()
        }
        
        self.smallScreenPopUpTextView.text = ""
        var frame = self.smallScreenPopUpTextView.frame
        frame.size.height = self.smallScreenPopUpTextView.contentSize.height
        self.smallScreenPopUpTextView.frame = frame
//
//        self.popUpView.removeFromSuperview()
//        self.popUpView = UIView(frame: CGRect(x: (self.view.frame.origin.x), y: 0, width: (self.view.frame.width), height: (self.view.frame.height)))
//        self.view.addSubview(self.popUpView);
//        self.popUpView.backgroundColor = UIColor.black
//        self.insidePopUpView = UIView(frame: CGRect(x: 30, y: 2, width: (self.view.frame.width) - 60, height: (self.popUpView.frame.height - 100)))
//        self.insidePopUpView.backgroundColor = UIColor.white
//        self.insidePopUpView.layer.cornerRadius = 10
//        self.popUpView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
//
//        let imgView = UIImageView()
//        imgView.frame =  CGRect(x: 10, y: 10, width: self.insidePopUpView .frame.width - 20, height: 350)
//        imgView.contentMode = .scaleAspectFit
//        imgView.clipsToBounds = true
//        imgView.layer.masksToBounds = true
//        //https://tweakandeatpremiumpacks.s3.ap-south-1.amazonaws.com/mytae_ios_inr_01.png
//        //https://ptadworks.s3.ap-south-1.amazonaws.com/tweakandeatcovid/popup_covid_ind_001.jpg
//
//        imgView.sd_setImage(with: URL.init(string: "https://ptadworks.s3.ap-south-1.amazonaws.com/tweakandeatcovid/popup_covid_ind_001.jpg"))
//        let label = UITextView()
//        label.frame = CGRect(x: 10, y: imgView.frame.maxY, width: self.insidePopUpView.frame.width - 20, height: self.insidePopUpView.frame.height - 46 - 350 - 10)
//        label.isEditable = false
//        label.isSelectable = false
//        //label.font = UIFont.systemFont(ofSize: 17)
//        label.textColor = UIColor.black
//
//
//        label.font = UIFont(name:"QUESTRIAL-REGULAR", size: 17.0)
//        let button = UIButton()
//        button.frame = CGRect(x: 0, y: self.insidePopUpView.frame.height - 46, width: self.insidePopUpView .frame.width, height: 46)
//        button.backgroundColor = UIColor.purple
//        button.setTitle("DONE", for: .normal)
//        button.addTarget(self, action: #selector(WelcomeViewController.pressed(sender:)), for: .touchUpInside)
//
//        self.insidePopUpView.addSubview(button)
//        self.insidePopUpView.addSubview(imgView)
//        self.insidePopUpView.addSubview(label)
//        self.insidePopUpView.removeFromSuperview()
//        self.popUpView.addSubview(self.insidePopUpView)
    }
    func showCircularProgressViews(image: String, someViews: CircularProgressView, value: Double, progressColor: UIColor, trackColor: UIColor) {
          let image = UIImage(named: image)
                 let imageView = UIImageView(image: image!)
                 imageView.frame = CGRect(x: 0, y: 0, width: someViews.frame.size.width, height: someViews.frame.size.width)
                 someViews.addSubview(imageView)
          someViews.progressClr = progressColor
          someViews.trackClr = trackColor
                 someViews.createCircularPath()
        someViews.progressAnimation(duration: 1.5,val: value)
      }
//   func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//    if touch.view?.isDescendant(of: self.myNutritionViewTableView) ?? false {
//
//            // Don't let selections of auto-complete entries fire the
//            // gesture recognizer
//            return false
//        }
//
//        return true
//    }

    
    func showMyNutritionDetails() {
        if (self.myNutritionDetailsView == nil) {
        self.myNutritionDetailsView = (Bundle.main.loadNibNamed("MyNutritionView", owner: self, options: nil)! as NSArray).firstObject as? MyNutritionView;
           // self.myNutritionDetailsView.frame = self.myNutritionView.frame
            self.myNutritionDetailsView.layer.cornerRadius = 10

        self.myNutritionDetailsView.delegate = self
        self.myNutritionDetailsView.reportsButtonDelegate = self
        self.myNutritionViewSelectYourMealTableView.backgroundColor = UIColor.groupTableViewBackground
        self.myNutritionViewLast10TweaksTableView.backgroundColor = UIColor.groupTableViewBackground
        self.myNutritionDetailsView.last10TweaksLbl.text = self.nutritionViewLast10TweaksDataVal
        self.myNutritionDetailsView.selectYourMealLbl.text = self.nutritionViewSelectedMeal
            self.myNutritionDetailsView.myNutritionLabel.text = bundle.localizedString(forKey: "my_nutrition", value: nil, table: nil);
//            if UserDefaults.standard.value(forKey: "NEW_USER") != nil {
//self.myNutritionDetailsView.isHidden = true
//            } else {
//                self.myNutritionDetailsView.isHidden = false
//            }
            self.myNutritionView.addSubview(self.myNutritionDetailsView)
           // self.myNutritionDetailsView.translatesAutoresizingMaskIntoConstraints = true
           // self.myNutritionDetailsView.layoutIfNeeded()
            self.showMyNutririonDetailsView.append(1)

self.topImageView.alpha = 1
            self.outerChartView.alpha = 1
            self.myNutritionDetailsView.updateSwitchUI(bool: false)
       
//             if IS_iPHONE5 || IS_IPHONE4 {
//                self.myNutritionDetailsView.viewHghtConstraint.constant = 70
//                        self.myNutritionDetailsView.viewWdthConstraint.constant = 70
//                    } else if IS_iPHONE678 {
//                        self.myNutritionDetailsView.viewHghtConstraint.constant = 84
//                        self.myNutritionDetailsView.viewWdthConstraint.constant = 84
//                    } else if IS_iPHONE678P {
//                        self.myNutritionDetailsView.viewHghtConstraint.constant = 93.67
//                        self.myNutritionDetailsView.viewWdthConstraint.constant = 93.67
//                    } else if IS_iPHONEXRXSMAX {
//                        self.myNutritionDetailsView.viewHghtConstraint.constant = 93.5
//                        self.myNutritionDetailsView.viewWdthConstraint.constant = 93.5
//                      } else if IS_iPHONEXXS {
//                        self.myNutritionDetailsView.viewHghtConstraint.constant = 83.67
//                        self.myNutritionDetailsView.viewWdthConstraint.constant = 83.67
//                    }
                    self.myNutritionDetailsView.layoutIfNeeded()
                    self.myNutritionDetailsView.myNutritionCarbsView.layer.cornerRadius = self.myNutritionDetailsView.myNutritionCaloriesView.frame.size.height / 2
                    self.myNutritionDetailsView.myNutritionFatsView.layer.cornerRadius = self.myNutritionDetailsView.myNutritionCaloriesView.frame.size.height / 2
                    self.myNutritionDetailsView.myNutritionProteinsView.layer.cornerRadius = self.myNutritionDetailsView.myNutritionCaloriesView.frame.size.height / 2
              //v2.frame = v1.frame
       self.showCircularProgressViews()
        } else {
            self.showCircularProgressViews()
        }
        
    }
    
    func showCircularProgressViews() {
        if IS_iPHONE5 {
          
            self.myNutritionDetailsView.last10TweaksLbl.font = UIFont(name:"QUESTRIAL-REGULAR", size: 13.0)
            self.myNutritionDetailsView.selectYourMealLbl.font = UIFont(name:"QUESTRIAL-REGULAR", size: 13.0)
            self.myNutritionDetailsView.carbsValue.font = UIFont(name:"QUESTRIAL-REGULAR", size: 14.0)
            self.myNutritionDetailsView.fatsValue.font = UIFont(name:"QUESTRIAL-REGULAR", size: 14.0)
            self.myNutritionDetailsView.proteinsValue.font = UIFont(name:"QUESTRIAL-REGULAR", size: 14.0)
            self.myNutritionDetailsView.caloriesValue.font = UIFont(name:"QUESTRIAL-REGULAR", size: 14.0)

        }
        self.myNutritionDetailsView.last10TweaksLbl.text = self.nutritionViewLast10TweaksDataVal
               self.myNutritionDetailsView.selectYourMealLbl.text = self.nutritionViewSelectedMeal
        var count = CGFloat(0)
               for val in self.carbsArray {
                   count += val as! CGFloat
               }
               let carbsVal = Double(count/CGFloat(self.carbsArray.count))
               self.myNutritionDetailsView.carbsValue.text = carbsVal.isNaN ? "0%" : "\(carbsVal.round(to:2))%"
               count = CGFloat(0)
               for val in self.fatssArray {
                   count += val as! CGFloat
               }
               let fatsVal = Double(count/CGFloat(self.fatssArray.count))
               self.myNutritionDetailsView.fatsValue.text = fatsVal.isNaN ? "0%" : "\(fatsVal.round(to:2))%"
               count = CGFloat(0)
               for val in self.proteinArray {
                   count += val as! CGFloat
               }
               let proteinVal = Double(count/CGFloat(self.proteinArray.count))
               self.myNutritionDetailsView.proteinsValue.text = proteinVal.isNaN ? "0%" : "\(proteinVal.round(to:2))%"
               count = CGFloat(0)
                      for val in self.caloriesArray {
                          count += val as! CGFloat
                      }
               self.myNutritionDetailsView.caloriesValue.text = count.isNaN ? "0" : "\(Int(count))"
               
               let image = UIImage(named: "calories")
                              let imageView = UIImageView(image: image!)
                              imageView.frame = CGRect(x: 0, y: 0, width: self.myNutritionDetailsView.myNutritionCaloriesView.frame.size.width, height: self.myNutritionDetailsView.myNutritionCaloriesView.frame.size.width)
                              self.myNutritionDetailsView.myNutritionCaloriesView.addSubview(imageView)
               showCircularProgressViews(image: "carbs", someViews: self.myNutritionDetailsView.myNutritionCarbsView, value: (carbsVal/Double(100)).round(to:2), progressColor: UIColor.init(red: 208.0/255.0, green: 235.0/255.0, blue: 165.0/255.0, alpha: 1.0), trackColor: UIColor.init(red: 85.0/255.0, green: 123.0/255.0, blue: 34.0/255.0, alpha: 1.0))
                     showCircularProgressViews(image: "fats", someViews: self.myNutritionDetailsView.myNutritionFatsView, value: (fatsVal/Double(100)).round(to:2),progressColor: UIColor.init(red: 229.0/255.0, green: 202.0/255.0, blue: 155.0/255.0, alpha: 1.0), trackColor: UIColor.init(red: 140.0/255.0, green: 90.0/255.0, blue: 31.0/255.0, alpha: 1.0) )
                     showCircularProgressViews(image: "protein", someViews: self.myNutritionDetailsView.myNutritionProteinsView, value: (proteinVal/Double(100)).round(to:2), progressColor: UIColor.init(red: 163.0/255.0, green: 189.0/255.0, blue: 234.0/255.0, alpha: 1.0), trackColor: UIColor.init(red: 16.0/255.0, green: 54.0/255.0, blue: 123.0/255.0, alpha: 1.0))
        if (self.caloriesArray.count == 0 || self.carbsArray.count == 0 || self.proteinArray.count == 0 ||
        self.fatssArray.count == 0) {
//            TweakAndEatUtils.AlertView.showAlert(view: self, message: "No Trends found! Start Tweaking now to see your own Nutritional Trend here. Make the Trend your friend! ")
        }
    }
    
    func updateSwitchUI(bool: Bool) {
       
          // self.switchButton.setStatus(bool)
       }
    
    func configureShadow(tableView: UITableView) {
           //tableView.backgroundColor = UIColor.clear
           tableView.layer.shadowColor = UIColor.darkGray.cgColor
           tableView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
           tableView.layer.shadowOpacity = 0.6
           tableView.layer.shadowRadius = 5.0
           
//           tableView.layer.cornerRadius = ShadowTableViewController.cornerRadius
           tableView.layer.masksToBounds = true
       }
   func calculateDaysBetweenTwoDates(start: Date, end: Date) -> Int {

          let currentCalendar = Calendar.current
          guard let start = currentCalendar.ordinality(of: .day, in: .era, for: start) else {
              return 0
          }
          guard let end = currentCalendar.ordinality(of: .day, in: .era, for: end) else {
              return 0
          }
          return end - start
      }
    
    func checkAppVersion() {
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
                   self.countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
            let extraParam = "/\(self.countryCode)/IOS"
               
        APIWrapper.sharedInstance.getJSON(url: TweakAndEatURLConstants.CHECK_APP_VERSION + extraParam , { (responceDic : AnyObject!) -> (Void) in
            if(TweakAndEatUtils.isValidResponse(responceDic as? [String:AnyObject])) {
                let response : [String:AnyObject] = responceDic as! [String:AnyObject];
                
                if(response[TweakAndEatConstants.CALL_STATUS] as! String == TweakAndEatConstants.TWEAK_STATUS_GOOD) {
                   // MBProgressHUD.hide(for: self.view, animated: true)
                    let dictionary = Bundle.main.infoDictionary!;
                    let currentAppVersionInString = dictionary["CFBundleShortVersionString"] as! String;
                    let currentAppVersionInDouble = Double(currentAppVersionInString)!
                    let version =  response["version"] as! NSNumber
                    if currentAppVersionInDouble < Double(truncating: version) {
                        self.appCheckVersionView.isHidden = false
                    }
                } else {
                        //MBProgressHUD.hide(for: self.view, animated: true)
                    }
                }
             else {
                //error
                //MBProgressHUD.hide(for: self.view, animated: true)
            }
        }) { (error : NSError!) -> (Void) in
            //error
            if error?.code == -1011 {
                           
                       } else {
                         //  TweakAndEatUtils.AlertView.showAlert(view: self, message: "Your internet connection is appears to be offline !!")
                       }
                   }
        }
    }
    
    func checkIfUserIsNewOrTrialPeriodExpired() {
        
        if UserDefaults.standard.value(forKey: "NEW_USER") != nil {
            self.trendButtonsView.isHidden = true
            self.topButtonsDataView.isHidden = true
            self.beforeTweakImageViewHeightConstraint.constant = 110
            self.topButtonsDataViewHeightConstraint.constant = 0
            self.startTweakingView.isHidden = true
            self.startTweakingLabel.alpha = 0
            self.trialPeriodExpiryView.isHidden = true
            if self.trialPeriodExpired == false {
            self.taeClubTrialPeriodExpiryView.isHidden = true
            taeClubTrialPeriodExpiryViewLbl.isHidden = true
            } else {
                self.taeClubTrialPeriodExpiryView.isHidden = false
                taeClubTrialPeriodExpiryViewLbl.isHidden = false
            }
            if IS_iPHONE5 {
                
                self.cameraBtnWidthConstraint.constant = 70
                self.cameraBtnHeightConstraint.constant = 70
            } else {
                           self.cameraBtnWidthConstraint.constant = 110
                           self.cameraBtnHeightConstraint.constant = 110

                       }
//            if self.flashCounter == 0 {
               // self.minCalCountLabel.startBlink()

            //self.runTimerFor5Seconds(label: self.minCalCountLabel)
          //  }
             if (self.myNutritionDetailsView != nil) {
                           if self.tweakCount > 0 {
                               self.myNutritionDetailsView.isHidden = false
                         //   self.myNutritionDetailsView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.chartView.frame.maxY)

                            self.startTweakingView.isHidden = true
                            self.startTweakingLabel.alpha = 0
                           } else {
                            self.startTweakingView.isHidden = false;
                            self.startTweakingLabel.alpha = 1.0
                            self.startTweakingView.alpha = 0.8
                            //if self.trialPeriodExpired == false {
                            self.startTweakingLabel.text = "Start Tweaking to see your own Nutritional Trend here. Make the Trend your friend!";
                            //}
                    // self.myNutritionDetailsView.isHidden = true
                      //      self.myNutritionDetailsView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.chartView.frame.maxY)

                           }
                       }
        } else {
            self.trendButtonsView.isHidden = false
            self.topButtonsDataView.isHidden = false
            self.minCalCountLabel.stopBlink()
            //self.startTweakingView.isHidden = false
            self.beforeTweakImageViewHeightConstraint.constant = 0
            self.topButtonsDataViewHeightConstraint.constant = 63
                        if IS_iPHONE5 {
                           self.cameraBtnWidthConstraint.constant = 70
                           self.cameraBtnHeightConstraint.constant = 70
            } else {
                self.cameraBtnWidthConstraint.constant = 90
                self.cameraBtnHeightConstraint.constant = 90

            }
            if (self.myNutritionDetailsView != nil) {
                if self.tweakCount > 0 {
                    self.myNutritionDetailsView.isHidden = false
                   // self.myNutritionDetailsView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.chartView.frame.maxY)


                } else {
                    self.myNutritionDetailsView.isHidden = false
                  //  self.myNutritionDetailsView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.chartView.frame.maxY)

                }
            }
        }
        self.updateUIAccordingTOEachDevice()

    }
    
    func runTimerFor5Seconds(label: UILabel) {
        let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fire(timer:)), userInfo: ["counter": 5, "label": label], repeats: false)
        label.startBlink()

    }
    
    @objc func fire(timer: Timer) {
        if  let userInfo = timer.userInfo as? [String: AnyObject] {
            flashCounter = userInfo["counter"] as! Int
        let lbl = userInfo["label"] as! UILabel
        while flashCounter <= 5 {
            flashCounter -= 1
            if flashCounter == 0 {
                timer.invalidate()
                lbl.stopBlink()
                
                
            }
        }
        }
    }
    
    func showCongratulationsTweakerView() {
        self.navigationController?.isNavigationBarHidden = true;
        
        congratulationsTweakerView = (Bundle.main.loadNibNamed("CongratulationsTweaker", owner: self, options: nil)! as NSArray).firstObject as? CongratulationsTweaker;
        congratulationsTweakerView.frame = self.view.frame;
        congratulationsTweakerView.delegate = self;
        self.view.addSubview(congratulationsTweakerView);
        congratulationsTweakerView.beginning();
        self.getIntroSlide1()
    }
    
    @objc func infoIconClick() {
       
        showCongratulationsTweakerView()
        //self.dummyPopUp()

    }
    override func viewDidLoad() {

        super.viewDidLoad();
        
        self.mainMenuView.layer.cornerRadius = 10
        self.myEDRView.layer.cornerRadius = 10
        self.tweakWallView.layer.cornerRadius = 10
        self.recipeView.layer.cornerRadius = 10
        self.myFitnessView.layer.cornerRadius = 10
        self.mainMenuView.addBorders(color: .lightGray, margins: 0, borderLineSize: 0.5, attribute: .bottom)

        
        //self.tapToTweakButton.flash()
      //  self.scrollContainerView.addBorder(toSide: .Top, withColor: UIColor.darkGray.cgColor, andThickness: 1)
//        link = "-NcInd5BosUcUeeQ9Q32"
//        if UserDefaults.standard.value(forKey: link) != nil {
//            self.goToNutritonConsultantScreen(packageID: link)
//        } else {
//            DispatchQueue.main.async {
//                MBProgressHUD.showAdded(to: self.view, animated: true);
//            }
//            self.moveToAnotherView(promoAppLink: link)
//
//            
//            
//        }
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
            countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
        
            if self.countryCode == "91" {
                self.clubPackageSubscribed = "-ClubInd3gu7tfwko6Zx"
            } else if self.countryCode == "62" {
                self.clubPackageSubscribed = "-ClubIdn4hd8flchs9Vy"
            } else if self.countryCode == "1" {
                self.clubPackageSubscribed = "-ClubUSA4tg6cvdhizQn"
            } else if self.countryCode == "65" {
                self.clubPackageSubscribed = "-ClubSGNPbeleu8beyKn"
            } else if self.countryCode == "60" {
                self.clubPackageSubscribed = "-ClubMYSheke8ebdjoWs"
            }
        }
        if UserDefaults.standard.value(forKey: self.clubPackageSubscribed) != nil {
        self.subscribeNowButton.setImage(UIImage.init(named: "upgrade_now_btn"), for: .normal)
    } else {
        self.subscribeNowButton.setImage(UIImage.init(named: "subscribe_now_btn"), for: .normal)

    }
        

        self.subscribeNowButtonView.layer.cornerRadius = 10
        self.menuButtonsView.layer.cornerRadius = 10
        self.tapToTweakView.backgroundColor = UIColor.black.withAlphaComponent(0.85)
        self.startTweakingView.layer.cornerRadius = 10
        self.trialPeriodExpiryView.layer.cornerRadius = 10
        self.taeClubTrialPeriodExpiryView.layer.cornerRadius = 10
        self.adsImageViewTapped = UITapGestureRecognizer(target: self, action: #selector(self.tappedOnNewAdImageView))
        self.adsImageViewTapped.numberOfTapsRequired = 1
        self.adsImageView?.addGestureRecognizer(self.adsImageViewTapped)
        
      

        if UserDefaults.standard.value(forKey: "FROM_DEEP_LINKS") != nil {
            link = UserDefaults.standard.value(forKey: "FROM_DEEP_LINKS") as! String
            UserDefaults.standard.removeObject(forKey: "FROM_DEEP_LINKS")
            self.tappedOnPopUpDone()
        }
        self.refreshTweakBtn.isHidden = true
        //UserDefaults.standard.set("YES", forKey: "NEW_USER")
        
        self.tweakStreakCountButton.setImage(UIImage.init(named: "my_tweak_streak.png"), for: .normal)

        //self.checkIfUserIsNewOrTrialPeriodExpired()
               // UserDefaults.standard.synchronize()
        if UserDefaults.standard.value(forKey: "-ClubInd3gu7tfwko6Zx") != nil || UserDefaults.standard.value(forKey: "-ClubIdn4hd8flchs9Vy") != nil {
            self.taeClubMemberBottomView.isHidden = false
            self.taeClubMemberTopView.isHidden = false
        } else {
            
        }
       
        self.tweakandeatClubButtonView.isHidden = true
        self.tweakandeatClubButtonViewBottom.isHidden = true
        self.taeClubTrialPeriodExpiryView.isHidden = true
        if UserDefaults.standard.value(forKey: "CLUBHOME1_RIGHT_BUTTON") != nil {
                 DispatchQueue.main.async {
                     
                     self.clubHome1RightBth.setImage(UIImage(data: UserDefaults.standard.value(forKey: "CLUBHOME1_RIGHT_BUTTON") as! Data), for: .normal)
                    self.clubHome2RightBth.setImage(UIImage(data: UserDefaults.standard.value(forKey: "CLUBHOME1_RIGHT_BUTTON") as! Data), for: .normal)
                     
                     
                 }
             }
             if UserDefaults.standard.value(forKey: "CLUBHOME1_LEFT_BUTTON") != nil {
                 DispatchQueue.main.async {
                     
                     self.clubHome1LeftBth.setImage(UIImage(data: UserDefaults.standard.value(forKey: "CLUBHOME1_LEFT_BUTTON") as! Data), for: .normal)
                    self.clubHome2LeftBth.setImage(UIImage(data: UserDefaults.standard.value(forKey: "CLUBHOME1_LEFT_BUTTON") as! Data), for: .normal)
                    self.premiumMemberTopBtn.setImage(UIImage(data: UserDefaults.standard.value(forKey: "CLUBHOME1_LEFT_BUTTON") as! Data), for: .normal)
                    self.premiumMemberBottomBtn.setImage(UIImage(data: UserDefaults.standard.value(forKey: "CLUBHOME1_LEFT_BUTTON") as! Data), for: .normal)
                    

                     
                     
                 }
             }
        if UserDefaults.standard.value(forKey: "CLUBHOME3_LEFT_BUTTON") != nil {
            DispatchQueue.main.async {
          
               self.taeClubMemberTopButton.setImage(UIImage(data: UserDefaults.standard.value(forKey: "CLUBHOME3_LEFT_BUTTON") as! Data), for: .normal)
               self.taeClubMemberBottomButton.setImage(UIImage(data: UserDefaults.standard.value(forKey: "CLUBHOME3_LEFT_BUTTON") as! Data), for: .normal)
               

                
                
            }
        }
        if UserDefaults.standard.value(forKey: "CLUBHOME3_RIGHT_BUTTON") != nil {
            DispatchQueue.main.async {
          
                self.taeClubMemberTopRightButton.setImage(UIImage(data: UserDefaults.standard.value(forKey: "CLUBHOME3_RIGHT_BUTTON") as! Data), for: .normal)
            
               self.taeClubMemberBottomRightButton.setImage(UIImage(data: UserDefaults.standard.value(forKey: "CLUBHOME3_RIGHT_BUTTON") as! Data), for: .normal)
               

                
                
            }
        }
        if UserDefaults.standard.value(forKey: "CLUBHOME2_TOP_BUTTON") != nil {
                       DispatchQueue.main.async {
                           
                           self.taeClubHome2Btn.setImage(UIImage(data: UserDefaults.standard.value(forKey: "CLUBHOME2_TOP_BUTTON") as! Data), for: .normal)
                           
                           
                       }
                   }
                   if UserDefaults.standard.value(forKey: "PERSONALIZED_SERVICES_BTN_DATA") != nil {
                       DispatchQueue.main.async {
                           
                           self.personalisedServicesBtn.setImage(UIImage(data: UserDefaults.standard.value(forKey: "PERSONALIZED_SERVICES_BTN_DATA") as! Data), for: .normal)
                           
                           
                       }
                   }
       // tweakAndEatCLubExpiryViewWithButtons.isHidden = false
        self.approxCalLeftForDayLabel.text = "Approx. calories left for the day"
        self.appVersionUpdateButton.layer.cornerRadius = 15
        self.appCheckVersionView.backgroundColor = UIColor.purple.withAlphaComponent(0.7)
        if IS_iPHONE5 {
                  self.approxCalLeftForDayLabel.font = UIFont(name:"QUESTRIAL-REGULAR", size: 13.0)

              }
//        let dateFormatter = DateFormatter()
//                                  dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//                                  let start = Date()
//                                  let end = dateFormatter.date(from: "2020-08-16T05:22:06.000Z")
//                                  let diff = calculateDaysBetweenTwoDates(start: start, end: end!)
//                                  if diff < 22 {
//                                  // destination.hideBottomMessageBox = true
//                                   //2020-07-14T05:22:06.000Z
//                                  }
        self.draggableView.isUserInteractionEnabled = false
        self.topImageView.alpha = 0
        self.outerChartView.alpha = 0
        
        self.switchButton = SwitchWithText(frame: CGRect(x: self.view.frame.width - 130, y: 9, width: 125, height: 40))
        self.outerChartView.addSubview(self.switchButton)
        self.switchButton.isHidden = true

        self.loadingView.backgroundColor = UIColor.white
        self.loadingView.isHidden = true
        self.outerChartView.addSubview(self.loadingView)
        self.dataBtnName = "todaysData"
        self.dataBtnName = "weeksData"
        self.dataBtnName = "monthsData"
        self.dataBtnName = "lastTenData"
        self.dataBtnArray = ["Last 10 Tweaks", "Today", "Week", "Month"]
        self.dataBtnDict = ["Last 10 Tweaks": "lastTenData", "Today": "todaysData", "Week": "weeksData", "Month": "monthsData"]
        self.myNutritionViewSelectYourMealTableView.isHidden = true
        self.myNutritionViewSelectYourMealTableView.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")
        self.myNutritionViewLast10TweaksTableView.isHidden = true
        self.myNutritionViewLast10TweaksTableView.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")
        
           NotificationCenter.default.addObserver(self, selector: #selector(WelcomeViewController.showPopUpNotifications(_:)), name: NSNotification.Name(rawValue: "SHOW_POPUP"), object: nil);
        self.tweakBubbleImageView.isHidden = false
                           self.tweakReactView.isHidden = false
            if UserDefaults.standard.value(forKey: "PREMIUM_BUTTON_DATA") != nil {
                DispatchQueue.main.async {
                    
//                    self.premiumMemberTopBtn.setBackgroundImage(UIImage(data: UserDefaults.standard.value(forKey: "PREMIUM_BUTTON_DATA") as! Data), for: .normal)
//                    self.premiumMemberBottomBtn.setBackgroundImage(UIImage(data: UserDefaults.standard.value(forKey: "PREMIUM_BUTTON_DATA") as! Data), for: .normal)
//                    self.tweakBubbleImageView.isHidden = false
//                    self.tweakReactView.isHidden = false
                    
                }
            }
       // self.mealTypeTableView.separatorStyle = .singleLine
  
//        self.performSegue(withIdentifier: "premiumTweakPack", sender: promoAppLink);
//        self.performSegue(withIdentifier: "nutritionAnalytics", sender: promoAppLink);
        //synced
        let labelsCount = 10
        UserDefaults.standard.set(labelsCount, forKey: "USER_LABELS_COUNT")
        UserDefaults.standard.synchronize()
        self.trialPeriodExpiryTextLbl.text = "Your trial period is completed.\n(Continue to use base service for free)\n\nClick here to subscribe now.";
        
        
        self.smallScreenPopUp.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        //self.link = "CLUB_PURCHASE"
//        self.smallScreenPopUpBtn.setTitle("PLAY VIDEO", for: .normal)
        //self.dummyPopUp()
//        self.link = "-IndIWj1mSzQ1GDlBpUt"
//        tappedOnPopUpDone()

    // self.link = "-MysRamadanwgtLoss99"
        //HOW_IT_WORKS
        self.minCalCountLabel.text = ""
        self.floatingTableView.separatorStyle = .singleLine
        self.subscribeToPTPNowLblHeightConstraint.constant = 0
        self.floatingCrownBtn.layer.shadowColor = UIColor.black.cgColor
        self.floatingCrownBtn.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        self.floatingCrownBtn.layer.shadowRadius = 2
        self.floatingCrownBtn.layer.shadowOpacity = 0.5
        self.floatingCrownBtn.layer.masksToBounds = false

        self.minCalCountLabel.layer.cornerRadius = 10.0
        self.minCalCountLabel.clipsToBounds = true
        self.selectYourMealTypeView.layer.cornerRadius = 6
        self.mealTypeView.backgroundColor = UIColor.black.withAlphaComponent(0.3); self.selectYourMealTypeView.backgroundColor = UIColor.black.withAlphaComponent(0.3); self.last10TweaksBtn.layer.cornerRadius = 10
        self.last10TweaksBtn.backgroundColor = UIColor.black.withAlphaComponent(0.3);
       // self.mealTypeLabel.textAlignment = .center
       
        self.popUPPTPImageView.contentMode = .scaleToFill
        
        self.popUPPTPImageView.clipsToBounds = true

        setDefaultsTrendBtns()

        self.startTweakingLabel.alpha = 0
        self.updateChart(backGroundCol: "#168c7a", data:  [] as [Any], name: "Calories", colorTheme: ["#FFFFFF"])
       
        self.setupNavigationTitle()
//        self.ptpBtn1.layer.shadowColor = UIColor.black.cgColor
//        self.ptpBtn1.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
//        self.ptpBtn1.layer.shadowRadius = 4
//        self.ptpBtn1.layer.shadowOpacity = 0.5
//        self.ptpBtn1.layer.masksToBounds = false
//
//        self.ptpBtn2.layer.shadowColor = UIColor.black.cgColor
//        self.ptpBtn2.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
//        self.ptpBtn2.layer.shadowRadius = 4
//        self.ptpBtn2.layer.shadowOpacity = 0.5
//        self.ptpBtn2.layer.masksToBounds = false

       
        //self.ptpBtn1.frame.origin.x = self.view.center.x
        //self.buyMoreBtn1.isHidden = true
//        self.ptpBtn1.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        self.ptpBtn1.widthAnchor.constraint(equalToConstant: 160)
//        self.ptpBtn1.heightAnchor.constraint(equalToConstant: 45)
       // self.ptpBtn1.center.x = self.view.center.x
        //Trebuchet MS 16.0
        let formattedString = NSMutableAttributedString()
        formattedString
            .normal("Subscribe to ")
            .bold(" ")
            .normal("now!")

        self.ptpSubscribeLabel.attributedText = formattedString
        self.trialPeriodExpiryView.isUserInteractionEnabled = true
        let trialTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tappedOntrialPeriodExpiryView))
        trialTapGesture.numberOfTapsRequired = 1
        self.trialPeriodExpiryView.addGestureRecognizer(trialTapGesture)
        
        self.taeClubTrialPeriodExpiryView.isUserInteractionEnabled = true
              let trialTapGestureForTAEClub = UITapGestureRecognizer(target: self, action: #selector(self.tappedOnTAEClubTrialPeriodExpiryView))
              trialTapGestureForTAEClub.numberOfTapsRequired = 1
              self.taeClubTrialPeriodExpiryView.addGestureRecognizer(trialTapGestureForTAEClub)
        
        self.startTweakingView.isUserInteractionEnabled = true
        let startTweakViewtapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tappedOnStartTweakingView))
        startTweakViewtapGesture.numberOfTapsRequired = 1
        self.startTweakingView.addGestureRecognizer(startTweakViewtapGesture)
        self.navigationBarButtonItemTimer.tintColor = UIColor.white
        self.navigationBarButtonItemTimer.isEnabled = false
        self.navigationBarTimerViewButton.isHidden = true
        self.iconsView.isHidden = true
        self.menuButtonsView.isHidden = false
       // showButtonsView()
       //self.startTweakingView.isHidden = false
       // print(UserDefaults.standard.value(forKey: "NutritionistSignature") as! String)
     //   let signature = UserDefaults.standard.value(forKey: "NutritionistSignature") as! String;
        
       // let msg = signature.html2String;
    //    print(msg)
     //   print( UserDefaults.standard.value(forKey: "NutritionistFirebaseId") as! String)
      
         NotificationCenter.default.addObserver(self, selector: #selector(WelcomeViewController.swapViews(_:)), name: NSNotification.Name(rawValue: "SWAP_VIEW"), object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(WelcomeViewController.getTrends), name: NSNotification.Name(rawValue: "GET_TRENDS"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(WelcomeViewController.goToMyTAE), name: NSNotification.Name(rawValue: "MYTAEVC"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(WelcomeViewController.decideToGotoTAEClub), name: NSNotification.Name(rawValue: "MYTAECLUB"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(WelcomeViewController.takephoto), name: NSNotification.Name(rawValue: "CONTINUE_TAKING_PHOTO"), object: nil)
        //SHOW_CALL_FLOATING_BUTTON
        
        //SWAP_VIEW
         NotificationCenter.default.addObserver(self, selector: #selector(WelcomeViewController.getUserCallSchedueDetails), name: NSNotification.Name(rawValue: "SHOW_CALL_FLOATING_BUTTON"), object: nil)
       // NotificationCenter.default.addObserver(self, selector: #selector(WelcomeViewController.swipeDownDraggingView), name: NSNotification.Name(rawValue: "SWIPE_DOWN_DRAGGING_VIEW"), object: nil)
        
        self.getTrends()
      
        
        DispatchQueue.main.async {

       // self.bottomButtonsView.isHidden = true
       
      //  self.roundImageView.image = UIImage.init(named: "defaultRecipe.jpg")
     
        }
        self.chartView.addSubview(aaChartView)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        
        swipeUp.direction = .up
        swipeDown.direction = .down
        
        self.draggableImageView.addGestureRecognizer(swipeUp)
        self.draggableImageView.addGestureRecognizer(swipeDown)
        self.innerDragMenuView.isUserInteractionEnabled = true
        let swipeUpForInnerDragMenuView = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        let swipeDownForInnerDragMenuView = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        
        swipeUpForInnerDragMenuView.direction = .up
        swipeDownForInnerDragMenuView.direction = .down
        
        self.innerDragMenuView.addGestureRecognizer(swipeUpForInnerDragMenuView)
        self.innerDragMenuView.addGestureRecognizer(swipeDownForInnerDragMenuView)
        
        let swipeUpView = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeView(_:)))
        let swipeDownView = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeView(_:)))
        
        swipeUpView.direction = .up
        swipeDownView.direction = .down
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(swipeUpView)
        self.view.addGestureRecognizer(swipeDownView)
        //scrollContainerView
//        self.scrollContainerView.isUserInteractionEnabled = true
//        let swipeUpContainerView = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeView(_:)))
//        //let swipeDownView = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeView(_:)))
//        
//        swipeUpContainerView.direction = .up
//       /// swipeDownView.direction = .down
//        self.scrollContainerView.addGestureRecognizer(swipeUpContainerView)
//        
        
        //self.foodImageView.layer.cornerRadius = 30.0
      //  self.foodImageShadowView.layer.cornerRadius = 30.0
//        //self.roundImageView.layer.borderColor = UIColor.gray.cgColor
//       // self.roundImageView.layer.borderWidth = 1.0
//        self.roundImageView.clipsToBounds = true
//        self.roundImageView.layer.cornerRadius = 30.0
//        self.roundImageView.clipsToBounds = true
        
        self.minimumHeight = self.draggableView.frame.height
        self.minimumFrame = self.draggableView.frame
       // self.foodImageFrame = self.foodImageView.frame
        DispatchQueue.main.async {
            self.caloriesButton.alpha = 1.0
            self.carbsButton.alpha = 1.0
            self.fatButton.alpha = 1.0
            self.protienButton.alpha = 1.0
            self.fatButton.backgroundColor = UIColor.clear
            self.protienButton.backgroundColor = UIColor.clear
            self.carbsButton.backgroundColor = UIColor.clear
        }
        self.minDragPosition = self.draggableViewHeightConstraint.constant
        
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
            self.getNutritionistFBID()
        }
    //UserDefaults.standard.removeObject(forKey: "PUSHWHENKILLED")
       if  UserDefaults.standard.value(forKey: "PUSHWHENKILLED") != nil {
        print(UserDefaults.standard.value(forKey: "PUSHWHENKILLED")!)
       // TweakAndEatUtils.AlertView.showAlert(view: self, message: "yeah")
        let userInfo = UserDefaults.standard.value(forKey: "PUSHWHENKILLED")! as! [String: AnyObject]
//        if userinfo.index(forKey: "custom") != nil {
//            let insideInfo = userinfo["custom"] as! [String: AnyObject]
//            if insideInfo.index(forKey: "a") != nil {
//                let dictA = insideInfo["a"]  as! [String: AnyObject]
//                print(dictA["tweak_id"] as! AnyObject)
//            }
//        }
//               if userInfo.index(forKey: "aps") != nil {
//                let apsDict = userInfo["aps"] as! [String: AnyObject]
//                if apsDict.index(forKey: "link") != nil {
//        showPopupFromAppLaunchWhenTappedNotification(aps: apsDict)
//                }
//        }
        var type = 0
        var tweakID: NSNumber = 0
        if userInfo.index(forKey: "aps") != nil {
            let apsInfo = userInfo["aps"] as AnyObject as! [String: AnyObject]
            if apsInfo.index(forKey: "type") != nil {
                type = apsInfo["type"] as AnyObject as! Int
            }
            if type == 4 {
            if apsInfo.index(forKey: "tweakId") != nil {
            tweakID = apsInfo["tweakId"] as! NSNumber
                UserDefaults.standard.setValue(tweakID, forKey: "TWEAK_ID");
                UserDefaults.standard.removeObject(forKey: "PUSHWHENKILLED")
            self.pushToTimeLines()
                
        }
            }
            
        }
        if userInfo.index(forKey: "custom") != nil {
            let insideInfo = userInfo["custom"] as! [String: AnyObject]
            if insideInfo.index(forKey: "a") != nil {
                let additionalData = insideInfo["a"]  as! [String: AnyObject]
                // print(dictA["tweak_id"] as! AnyObject)
                
                if additionalData.index(forKey: "tweak_complete") != nil {
                    let tweak_complete = additionalData["tweak_complete"] as! Bool
                    if tweak_complete == true {
                        if additionalData.index(forKey: "tweak_id") != nil {
                            let tweakID = additionalData["tweak_id"] as! NSNumber
                            UserDefaults.standard.setValue(tweakID, forKey: "TWEAK_ID");
                            
                            //      NotificationCenter.default.post(name: NSNotification.Name(rawValue: "TWEAK_NOTIFICATION"), object: nil)
                            UserDefaults.standard.removeObject(forKey: "PUSHWHENKILLED")
                            self.pushToTimeLines()
                            
                        }
                    }
                }
                
                if additionalData.index(forKey: "tweak_chat") != nil {
                    let chat_notify = additionalData["tweak_chat"] as! Bool
                    if chat_notify == true {
                        if additionalData.index(forKey: "tweak_id") != nil {
                            let tweakID = Int(additionalData["tweak_id"] as! String)!
                            
                            UserDefaults.standard.setValue(tweakID, forKey: "CHAT_NOTIFICATION");
                            UserDefaults.standard.setValue(tweakID, forKey: "TWEAK_ID");
                            UserDefaults.standard.removeObject(forKey: "PUSHWHENKILLED")
                            self.pushToTimeLines()
                        }
                    }
                }
                
            }
            
        }
        }
//        let html: String = "<b>Great App! Most Innovative! Cheapest Service available in the market! And not that’s on sale - I couldn’t believe it.<br/><br/>Bought the Annual ‘My Tweak & Eat’ Service @ 30% OFF! WOW!!!</b><br/><br/><b>Starts Nov 8th - Ends Nov 14th</b>";
        
//        let html = "Hi {USERNAME},<br><br>This is Sam, Senior Nutritionist from Tweak &amp; Eat. I see your profile and 'My AiDP' (Artificial Intelligence Based Diet Plans) service is a perfect fit for you i.e. Healthy Eating &amp; Weight Loss while managing your Hypo &amp; Hyper Thyroidism, and low Blood Pressure. The AiDP Plan will also include specific diet to improve's fertility. You will see amazing, positive change!<br><br>Please click on 'Premium Services' button on the Tweak &amp; Eat App page, and subscribe to<b> My AiDP</b>. Sign up today! It's super-affordable and <b>IT'S ON SALE!</b> So Hurry!<br><br>"
//        let html = "Unbelievable but true!\n\nMost affordable Diet Plan's Service now on sale! Grab it now!\n\n30% OFF! Just this week!\n\nStarts Nov 8th - Ends Nov 14th"
      //  print(html.html2String);
        DispatchQueue.main.async {

        self.tweakBubbleImageView.isHidden = true
        self.tweakReactView.isHidden = true
       
        self.myTweakEatView.isHidden = true
        
        self.tweakBubbleImageView.isHidden = true
        self.tweakReactView.isHidden = true
        self.adsImageView.isUserInteractionEnabled = false
        //self.premiumIconBarButton.isEnabled = false
           //self.premiumIconBarButton.tintColor = .white
        self.premiumMember.isUserInteractionEnabled = true
        if UserDefaults.standard.value(forKey: "PREMIUM_MEMBER") != nil {
            //self.premiumIconBarButton.isEnabled = true
            self.premiumMember.isHidden = true
        }
        }
        path = Bundle.main.path(forResource: "en", ofType: "lproj");
        bundle = Bundle.init(path: path!)! as Bundle;
        self.setUpUI();
       
        self.premiumMember.layer.cornerRadius = 10;
        NotificationCenter.default.addObserver(self, selector: #selector(self.moveToRespectedPage(_:)), name: NSNotification.Name(rawValue: "ADLOCALURL"), object: nil);
        formatter.dateFormat = "yyyy-MM-dd"
        
        NotificationCenter.default.addObserver(self, selector: #selector(WelcomeViewController.pushToTimeLines), name: NSNotification.Name(rawValue: "TWEAK_NOTIFICATION"), object: nil)
       // self.tweakStreakLbl.textAlignment = .center
        
        self.tweakFeedsRef = Database.database().reference().child("TweakFeeds");
        
        
        for i in 20...350 {
            let str1 = String(i)
            let str2 = "kgs"
            let str3 = "\(str1) \(str2)"
            self.weightFieldArray.append(str3)
            
        }
        
        for i in 20...225 {
            let str1 = String(i)
            let str2 = "Cms"
            let str3 = "\(str1) \(str2)"
            self.heightFieldArray.append(str3)
            
        }
        
        if tweakNowAlert == true {
            checkTweakable()
        }
        if myWallAlert == true {
            self.performSegue(withIdentifier: "myWall", sender: self)
        }
        if recipeWallAlert == true {
            self.performSegue(withIdentifier: "recipeWall", sender: self)
        }
        if myEdRAlert == true {
            self.performSegue(withIdentifier: "myEDR", sender: self)
        }
        
        appDelegateTAE = UIApplication.shared.delegate as! AppDelegate;
        
        picker.delegate = self;
        DispatchQueue.main.async {
            
        
        self.notificationBadgeLabel.layer.cornerRadius = self.notificationBadgeLabel.frame.size.width / 2
        self.notificationBadgeLabel.clipsToBounds = true
        self.notificationBadgeLabel.isHidden = true
        
        self.tweakReactView.layer.borderWidth = 1;
        self.tweakReactView.layer.borderColor = UIColor.white.cgColor;
        self.tweakReactView.layer.cornerRadius = 5.0;
        }
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(WelcomeViewController.checkTweakable));
      //  cameraTweakLabel.isUserInteractionEnabled = true;
      //  cameraTweakLabel.addGestureRecognizer(tapGestureRecognizer);
        
        self.reachability = Reachability.forInternetConnection();
        self.reachability.startNotifier();
        
        self.tweakTermsServiceView = (Bundle.main.loadNibNamed("TweakServiceAgreement", owner: self, options: nil)! as NSArray).firstObject as! TweakServiceAgreement;
        
        //        locManager.delegate = self;
        //        locManager.desiredAccuracy = kCLLocationAccuracyBest;
        //        locManager.requestWhenInUseAuthorization();
        //        locManager.startMonitoringSignificantLocationChanges();
        //        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
        //            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways)
        //        {
        //            latitude = "\(locManager.location?.coordinate.latitude ?? 0.0)";
        //            longitude = "\(locManager.location?.coordinate.longitude ?? 0.0)";
        //
        //        } else {
        //
        //        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(WelcomeViewController.reachabilityChanged(notification:)), name: NSNotification.Name.reachabilityChanged, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(WelcomeViewController.badgeCountChanged(notification:)), name: NSNotification.Name(rawValue: "BADGECOUNT"), object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(WelcomeViewController.scrollHome(notification:)), name: NSNotification.Name(rawValue: "SCROLL_HOME_SCREEN"), object: nil);
        if UserDefaults.standard.value(forKey: "LANGUAGE") != nil {
            let language = UserDefaults.standard.value(forKey: "LANGUAGE") as! String
            self.getStaticText(lang: language)
        } else {
            self.getStaticText(lang: "EN")
        }
//        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
//            let  countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
//
//            if countryCode == "91"{
//                self.getNutritionistFBID()
//            }
//        }
        //   razor()
        if UserDefaults.standard.value(forKey: "MYTAECLUB") != nil {
                  UserDefaults.standard.removeObject(forKey: "MYTAECLUB")
                  self.decideToGotoTAEClub()
              }
              if UserDefaults.standard.value(forKey: "MYTAEVC") != nil {
                  UserDefaults.standard.removeObject(forKey: "MYTAEVC")
                  if UserDefaults.standard.value(forKey: "-IndIWj1mSzQ1GDlBpUt") != nil {
                      
                      self.performSegue(withIdentifier: "myTweakAndEat", sender: "-IndIWj1mSzQ1GDlBpUt");
                  } else {
                      DispatchQueue.main.async {
                      MBProgressHUD.showAdded(to: self.view, animated: true);
                      }
                      self.moveToAnotherView(promoAppLink: "-IndIWj1mSzQ1GDlBpUt")

                      
                      
                  }
              }
    }
    
    //    func razorpayApiCall() {
    //        let ratingParams : [String : AnyObject] = ["planId" : "plan_CeTZ8p75bS7351" as AnyObject,"pkgId": "-IndIWj1mSzQ1GDlBpUt" as AnyObject,"totalCount": 40  as AnyObject, "pkgDesc": "MYTAE_IND_QUATERLY" as AnyObject, "pkgDuration": 3 as AnyObject, "system": false as AnyObject];
    //
    //        let userSession : String = UserDefaults.standard.value(forKey: "userSession") as! String;
    //        APIWrapper.sharedInstance.razorPayApi(ratingParams as [String:AnyObject],userSession: userSession, successBlock: {(responseDic : AnyObject!) -> (Void) in
    //            print("Sucess");
    //
    //
    //        }, failureBlock: {(error : NSError!) -> (Void) in
    //            print("Failure");
    //        })
    //    }
    //
    //    func razor(){
    //        let paramsDictionary = ["planId": "plan_CeTZ8p75bS7351",
    //                                "pkgId": "-IndIWj1mSzQ1GDlBpUt",
    //            "totalCount": 40.0,
    //            "pkgDesc": "MYTAE_IND_QUATERLY",
    //            "pkgDuration": 3,
    //            "system": false] as [String : Any]
    //        APIWrapper.sharedInstance.postRequestWithHeaderMethod(TweakAndEatURLConstants.RAZORPAY_API, userSession: UserDefaults.standard.value(forKey: "userSession") as! String,parameters: paramsDictionary as [String : AnyObject] , success: { response in
    //            print(response)
    //
    //            let responseDic : [String:AnyObject] = response as! [String:AnyObject];
    //            let responseResult = responseDic["callStatus"] as! String;
    //            if  responseResult == "GOOD" {
    //
    //            }
    //        }, failure : { error in
    //            MBProgressHUD.hide(for: self.view, animated: true);
    //
    //            print("failure")
    //            TweakAndEatUtils.AlertView.showAlert(view: self, message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil));
    //        })
    //    }
    
    @objc func swipeDownDraggingView() {
        if self.goneUp == true {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 2.0, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: [.curveEaseInOut],
                           animations: {
                            if IS_iPHONEXRXSMAX {
                                self.draggableViewHeightConstraint.constant = 300
                            } else if IS_iPHONEXXS {
                                self.draggableViewHeightConstraint.constant = 230
                            } else if IS_iPHONE678P {
                                self.draggableViewHeightConstraint.constant = 220
                            } else if IS_iPHONE678 {
                                self.draggableViewHeightConstraint.constant = 175
                            } else if IS_iPHONE5 {
                                self.draggableViewHeightConstraint.constant = 43
                            } else {
                                self.draggableViewHeightConstraint.constant = 43
                            }
                            self.outerChartView.alpha = 1
                            self.bottomBtnViewTopConstraint.constant = -88
                            //                            self.bottomButtonsView.backgroundColor = UIColor.white
                            //                            self.ptpBtn2.isHidden = true
                            //                            self.buyPkgsButton.isHidden = true
                            //                            self.bottomButtonsView.isHidden = true
                            self.draggableContainerView.layoutIfNeeded()
                            self.view.layoutIfNeeded()


            },  completion: {(_ completed: Bool) -> Void in
                self.goneUp = false

            })
        }
        }
    }
    
    @objc func tappedOnCloudBubbleImage(_ tapGesture: UITapGestureRecognizer)  {
        self.randomMessages.stopBlink();
        fromCrown = false
        
        self.gotToDesiredPackageViewController();
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == self.tweakOTPView.countryCodePickerView {
            return 1;
        } else {
            if self.tweakOptionView.bmi == "height" {
                if (self.tweakOTPView.countryCodeTextField.text == "+91" || self.tweakOTPView.countryCodeTextField.text == "+1") {
                    return 2;
                }else {
                    return 1
                }
            } else if self.tweakOptionView.bmi == "weight" {
                return 1;
            }
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.tweakOTPView.countryCodePickerView {
            return self.allCountryArray.count
        } else {
            
            if self.tweakOptionView.bmi == "height" {
                if (self.tweakOTPView.countryCodeTextField.text == "+91" || self.tweakOTPView.countryCodeTextField.text == "+1") {
                    return pickOption[component].count
                } else {
                    return heightFieldArray.count
                }
            }
            else if self.tweakOptionView.bmi == "weight" {
                return weightFieldArray.count
            }
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        if  pickerView == self.tweakOTPView.countryCodePickerView {
            
            let cellDictionary = self.allCountryArray[row] as! NSDictionary;
            let myView = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.bounds.width,height: 60));
            
            myView.backgroundColor = UIColor.white;
            
            let imageView = UIImageView(frame: CGRect(10, 10, 40, 40))
            let imageUrl = cellDictionary["ctr_flag_url"] as AnyObject as? String
            imageView.sd_setImage(with: URL(string: imageUrl!));
            
            imageView.contentMode = UIView.ContentMode.scaleAspectFit
            let countryLabel = UILabel(frame: CGRect(imageView.frame.maxX + 30, 0, 150, 60))
            countryLabel.text = cellDictionary["ctr_name"] as AnyObject as? String
            let countryCodeLabel = UILabel(frame: CGRect(myView.frame.size.width - 70, 0, 70, 60))
            countryCodeLabel.text = "\(cellDictionary["ctr_phonecode"] as AnyObject as! Int)"
            
            myView.addSubview(countryLabel)
            myView.addSubview(countryCodeLabel)
            myView.addSubview(imageView)
            
            return myView
        } else {
            let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: pickerView.bounds.width,height: 60))
            
            if pickerView == self.tweakOptionView.bmiPickerView {
                if self.tweakOptionView.bmi == "height" {
                    if (self.tweakOTPView.countryCodeTextField.text == "+91" || self.tweakOTPView.countryCodeTextField.text == "+1") {
                        
                        lbl.textAlignment = .center
                        lbl.text = pickOption[component][row]
                    } else {
                        lbl.textAlignment = .center
                        lbl.text = heightFieldArray[row]
                    }
                    
                } else if self.tweakOptionView.bmi == "weight" {
                    lbl.textAlignment = .center
                    lbl.text = weightFieldArray[row]
                    
                    
                    
                }
            }
            return lbl
        }
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.tweakOTPView.countryCodePickerView {
            
            let cellDictionary = self.allCountryArray[row] as! NSDictionary;
            print(cellDictionary)
            if cellDictionary.count > 0 {
                UserDefaults.standard.setValue(cellDictionary["ctr_name"] as AnyObject, forKey: "COUNTRY_NAME")
                //
                UserDefaults.standard.setValue(cellDictionary["ctr_phonecode"] as AnyObject, forKey: "COUNTRY_CODE")
                let imageUrl = cellDictionary["ctr_flag_url"] as AnyObject as? String;
                self.tweakOTPView.countryCode = "+" +  "\(cellDictionary["ctr_phonecode"] as AnyObject as! NSNumber as! Int)"
                self.tweakOTPView.flagImage.sd_setImage(with: URL(string: imageUrl!));
                self.tweakOTPView.countryCodeTextField.text = "+" + "\(cellDictionary["ctr_phonecode"] as AnyObject as! Int)"
                self.tweakOTPView.ctrPhoneMax = (cellDictionary["ctr_phone_max"] as AnyObject as? Int)!
                self.tweakOTPView.ctrPhoneMin = (cellDictionary["ctr_phone_min"] as AnyObject as? Int)!
                if ((cellDictionary["ctr_phonecode"] as AnyObject as! NSNumber as! Int) == 1) {
                    
                    self.getWeightInLbs()
                } else {
                    self.weightFieldArray = [String]()
                    
                    for i in 20...350 {
                        let str1 = String(i)
                        let str2 = "kgs"
                        let str3 = "\(str1) \(str2)"
                        self.weightFieldArray.append(str3)
                        
                    }
                }
                print(self.tweakOTPView.ctrPhoneMax)
                print(self.tweakOTPView.ctrPhoneMin)
                
                
            }
        } else {
            if self.tweakOptionView.bmi == "height" {
                if self.tweakOTPView.countryCodeTextField.text == "+91"  {
                    let color = pickOption[0][pickerView.selectedRow(inComponent: 0)];
                    let model = pickOption[1][pickerView.selectedRow(inComponent: 1)];
                    let feetArray = color.components(separatedBy: " ");
                    let inchArray = model.components(separatedBy: " ");
                    let feet = Int(feetArray[0])!;
                    let inches = Int(inchArray[0])!;
                    if inchArray[0].count == 1 {
                        let totalCM: Int = Int((Float(Double(feet) * 30.48) + Float(Double(inches) * 2.54)));
                        tweakOptionView.heightTextField.text = "\(totalCM)";
                        
                    } else if inchArray[0].count == 2 {
                        let totalCM: Int = Int((Float(Double(feet) * 30.48) + Float(Double(inches) * 2.54)));
                        tweakOptionView.heightTextField.text = "\(totalCM)";
                        
                    }
                } else {
                    var selectedRow = 0;
                    selectedRow = row;
                    let myString: String = heightFieldArray[row];
                    var myStringArr =  myString.components(separatedBy: " ");
                    
                    let totalHeight : String = myStringArr [0];
                    var _: String = myStringArr [1];
                    tweakOptionView.heightTextField.text = "\(totalHeight)";
                }
                
                if self.tweakOTPView.countryCodeTextField.text == "+1" {
                    
                    let color = pickOption[0][pickerView.selectedRow(inComponent: 0)];
                    let model = pickOption[1][pickerView.selectedRow(inComponent: 1)];
                    let feetArray = color.components(separatedBy: " ");
                    let inchArray = model.components(separatedBy: " ");
                    let feet = "\(feetArray[0])";
                    let inches = "\(inchArray[0])";
                    let totalInches = feet + "'" + inches + "''"
                    
                    let feet1 = Int(feetArray[0])!;
                    let inches1 = Int(inchArray[0])!;
                    if inchArray[0].count == 1 {
                        
                        tweakOptionView.heightTextField.text = totalInches;
                        
                        let totalCM: Int = Int((Float(Double(feet1) * 30.48) + Float(Double(inches1) * 2.54)));
                        self.totalCMS = "\(totalCM)"
                        
                    } else if inchArray[0].count == 2 {
                        
                        tweakOptionView.heightTextField.text = totalInches;
                        let totalCM: Int = Int((Float(Double(feet1) * 30.48) + Float(Double(inches1) * 2.54)));
                        self.totalCMS = "\(totalCM)";
                    }
                    
                }
                
            }
            else if  self.tweakOptionView.bmi == "weight" {
                var selectedRow = 0;
                selectedRow = row;
                let myString: String = weightFieldArray[row];
                var myStringArr =  myString.components(separatedBy: " ");
                
                let totalWeight : String = myStringArr [0];
                var _: String = myStringArr [1];
                tweakOptionView.weightTextField.text = "\(totalWeight)";
                
            }
        }
    }
    
    @IBAction func tweakStreakInfo(_ sender: Any) {
        var streakString = ""
//        if self.tweakStreakLbl.text == bundle.localizedString(forKey: "my_tweak_streak", value: nil, table: nil) {
//           streakString = TweakAndEatConstants.TWEAK_STREAK
//        //  }
//          } else if self.tweakStreakLbl.text == bundle.localizedString(forKey: "my_tweak_total", value: nil, table: nil) {
//            streakString = TweakAndEatConstants.TWEAK_TOTAL
//          }
        if self.tweakStreakCountButton.currentImage == UIImage.init(named: "my_tweak_streak.png") {
            streakString = TweakAndEatConstants.TWEAK_STREAK
            DispatchQueue.main.async {
                self.tweakCountLbl.text = self.totalTweakCount
                self.tweakStreakCountButton.setImage(UIImage.init(named: "my_tweak_total.png"), for: .normal)
            }
        } else {
            
          DispatchQueue.main.async {
            self.tweakCountLbl.text = self.tweakStreakCount
            streakString = TweakAndEatConstants.TWEAK_TOTAL
                self.tweakStreakCountButton.setImage(UIImage.init(named: "my_tweak_streak.png"), for: .normal)
            }
        }
        DispatchQueue.main.async {
        MBProgressHUD.showAdded(to: self.view, animated: true);
        }
        var lang = ""
        if UserDefaults.standard.value(forKey: "LANGUAGE") != nil {
            lang = UserDefaults.standard.value(forKey: "LANGUAGE") as! String
        }
        APIWrapper.sharedInstance.getStaticText(lang: lang, { (responceDic : AnyObject!) ->(Void) in
            if(TweakAndEatUtils.isValidResponse(responceDic as? [String:AnyObject])) {
                
                let response : [String:AnyObject] = responceDic as! [String:AnyObject];
                var welcomeText : NSString? = nil;
                if(response[TweakAndEatConstants.CALL_STATUS] as!
                    String == TweakAndEatConstants.TWEAK_STATUS_GOOD) {
                    DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.view, animated: true);
                    }
                    let staticTextArray = response[TweakAndEatConstants.DATA] as! [[String: AnyObject]];
                    for dict in staticTextArray {
                        for (_,val) in dict {
                            if val as! String == streakString {
                                let firstObj = dict[TweakAndEatConstants.STATIC_VALUE] as AnyObject as! String
                                print(firstObj.html2String)
                                TweakAndEatUtils.AlertView.showAlert(view: self, message: firstObj.html2String)
//                                let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NutritionistPopViewController") as! NutritionistPopViewController;
//                                self.addChild(popOverVC);
//                                popOverVC.viewController = self
//                                //popOverVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
//                                popOverVC.popUp1 = true
//                                popOverVC.tweakText = firstObj.html2String
//                                self.view.addSubview(popOverVC.view);
//                                popOverVC.didMove(toParent: self);
                            }
                        }
                    }

                }
            } else {
                DispatchQueue.main.async {
        MBProgressHUD.hide(for: self.view, animated: true);
        }
            }
        }) { (error : NSError!) -> (Void) in
            
            DispatchQueue.main.async {
        MBProgressHUD.hide(for: self.view, animated: true);
        }
            TweakAndEatUtils.AlertView.showAlert(view: self, message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil));
        }

    }
    
    @IBAction func cameraBtnAction(_ sender: Any) {
        self.checkTweakable()
    }
    
    @objc func checkTweakable(){
        DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view, animated: true);
                }
        APIWrapper.sharedInstance.postRequestWithHeaders(TweakAndEatURLConstants.CHECKTWEAKABLE, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, success: { response in
            let responseDic : [String:AnyObject] = response as! [String:AnyObject];
            let responseResult = responseDic["callStatus"] as! String
            if  responseResult == "GOOD" {
                
                print("Sucess")
//                if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
//                           self.countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
//                       }
                 DispatchQueue.main.async {
                                    MBProgressHUD.hide(for: self.view, animated: true);
                                    }
                
                

                self.takephoto();
                
                
            } else{
                DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true);
                }
                let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NutritionistPopViewController") as! NutritionistPopViewController;
                self.addChild(popOverVC);
                popOverVC.viewController = self
                let htmlTxt =  responseDic["msg"] as! String
                popOverVC.popUpText = htmlTxt.html2String
                popOverVC.popUp = true
                self.view.addSubview(popOverVC.view);
                popOverVC.didMove(toParent: self);
                
            }
        }, failure : { error in
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true);
                }
            //self.premiumIconBarButton.isEnabled = true;
            let alertController = UIAlertController(title: self.bundle.localizedString(forKey: "no_internet", value: nil, table: nil), message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil), preferredStyle: UIAlertController.Style.alert)
            
            let defaultAction = UIAlertAction(title:  self.bundle.localizedString(forKey: "ok", value: nil, table: nil), style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        })
    }
    @objc func showBadge() {
        
        let db = DBManager()
        
        let entities = db.realm.objects(BadgeCount.self)
        let id = entities.max(ofProperty: "id") as Int?
        let entity = id != nil ? entities.filter("id == %@", id!).first : nil
        if entity == nil {
            self.badgeCount = 0
        } else {
            self.badgeCount = (entity?.badgeCount)!
        }
        DispatchQueue.main.async(execute: {
            if self.badgeCount == 0 {
                self.notificationBadgeLabel.isHidden = true
            } else {
                self.notificationBadgeLabel.isHidden = false
                self.notificationBadgeLabel.text = String(self.badgeCount)
            }
            
        })
    }
    
    @objc func badgeCountChanged(notification : NSNotification) {
        
        self.showBadge()
    }
    @objc func scrollHome(notification : NSNotification) {
        let notify = notification.object as! Bool
        self.goneUp = notify
        self.scrollHomeScreen()
    }
    
    @objc func scrollHomeScreen() {
        if self.goneUp == false {
        
            DispatchQueue.main.async {
                UIView.animate(
                    withDuration: 1,
                    animations: { [self] in
                        self.upperMainView.alpha = 0
                        self.upperViewTopConstraint.constant = -270
                        self.topBgImageView.contentMode = .scaleToFill
                        self.containerViewBottomConstraint.constant = 110
//                        self.topViewHeightConstraint.constant = 0
//                        if self.showGraph == false {
//                        self.outerChartView.isHidden = true
//                        } else {
//                            self.outerChartView.alpha = 0
//
//                        }
//                        self.myNutritionView.alpha = 0
//                        self.outerViewHeightConstraint.constant = 0
//                        if (self.myNutritionDetailsView != nil) {
//                        self.myNutritionDetailsView.frame = CGRect(x: 0, y: 0, width: self.myNutritionView.frame.width, height: 237)
//
//                            self.myNutritionView.frame = CGRect(x: 0, y: 0, width: self.myNutritionView.frame.width, height: 237)
//                            self.outerChartView.frame = self.myNutritionView.frame
//
//                        }
//                        self.approxCalLeftView.isHidden = true
//                        self.containerViewBottomConstraint.constant = 110
//                        self.topBgImageView.contentMode = .scaleToFill
                        if self.totalTweakCount == "0" {
                            self.startTweakingView.isHidden = false
                            self.startTweakingLabel.alpha = 1
                        } else {
                            self.startTweakingView.isHidden = true
                            self.startTweakingLabel.alpha = 0
                        }
                        if self.trialPeriodExpired == true {
//                        self.taeClubTrialPeriodExpiryView.isHidden = true
//                        self.taeClubTrialPeriodExpiryViewLbl.isHidden = true
                            self.trialPeriodExpiryView.isHidden = true
                            self.trialPeriodExpiryTextLbl.isHidden = true
                        }
                            self.view.layoutIfNeeded()
                    //last
                            
            },  completion: {(_ completed: Bool) -> Void in

                self.goneUp = true
                
            })
            }
        } else {
            DispatchQueue.main.async {
                UIView.animate(
                    withDuration: 1,
                    animations: {
                        self.upperMainView.alpha = 1
                        self.upperViewTopConstraint.constant = 0
                        self.topBgImageView.contentMode = .scaleAspectFill
                        self.containerViewBottomConstraint.constant = 0
                        if self.totalTweakCount == "0" {
                            self.startTweakingView.isHidden = false
                            self.startTweakingLabel.alpha = 1
                        } else {
                            self.startTweakingView.isHidden = true
                            self.startTweakingLabel.alpha = 0
                        }
                        if self.trialPeriodExpired == true {
//                        self.taeClubTrialPeriodExpiryView.isHidden = false
//                            self.taeClubTrialPeriodExpiryViewLbl.isHidden = false
                            self.trialPeriodExpiryView.isHidden = false
                            self.trialPeriodExpiryTextLbl.isHidden = false

                        }
//                        self.outerViewHeightConstraint.constant = 237
//                        self.topViewHeightConstraint.constant = 302
//                        self.myNutritionView.alpha = 1
//                        if self.showGraph == false {
//                        self.outerChartView.isHidden = true
//                        } else {
//                            self.outerChartView.alpha = 1
//
//                        }
//                        if (self.myNutritionDetailsView != nil) {
//                        self.myNutritionDetailsView.frame = CGRect(x: 0, y: 0, width: self.myNutritionView.frame.width, height: 237)
//
//                            self.myNutritionView.frame = CGRect(x: 0, y: 0, width: self.myNutritionView.frame.width, height: 237)
//                            self.outerChartView.frame = self.myNutritionView.frame
//
//                        }
//                        self.containerViewBottomConstraint.constant = 0
//                        self.topBgImageView.contentMode = .scaleAspectFill
////                        self.startTweakingView.isHidden = false
////                        self.trialPeriodExpiryView.isHidden = false
////                        self.taeClubTrialPeriodExpiryView.isHidden = false

                            self.view.layoutIfNeeded()
                    //last
                            
            },  completion: {(_ completed: Bool) -> Void in
                self.goneUp = false
//                if self.showGraph == false {
//                self.outerChartView.isHidden = false
//                } else {
//                    self.outerChartView.isHidden = false
//
//                }
//                self.approxCalLeftView.isHidden = false



                
            })
            }

        }

    }
    
    @objc func languageSelected(lang: String) {
        if lang == "BA" {
            self.languageSelected = true
            UserDefaults.standard.set(lang, forKey: "LANGUAGE")
            path = Bundle.main.path(forResource: "id", ofType: "lproj")
            bundle = Bundle.init(path: path!)! as Bundle
            self.tweakView.removeFromSuperview()
            self.getStaticText(lang: lang)
            
            self.tweakView.languageSelectionView.isHidden = true
        } else if lang == "EN" {
            UserDefaults.standard.set(lang, forKey: "LANGUAGE")
            path = Bundle.main.path(forResource: "en", ofType: "lproj")
            bundle = Bundle.init(path: path!)! as Bundle
            self.tweakBubbleImageView.isHidden = true
            self.tweakReactView.isHidden = true
            self.tweakView.languageSelectionView.isHidden = true
        }
    }
    
    @objc func playVideo() {
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
            self.countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
            
            if self.countryCode == "91" || self.countryCode == "63" || self.countryCode == "65" {
                
                let videoURL = URL(string: "https://tweakandeatappassets.s3.ap-south-1.amazonaws.com/tae_en_howitworks_20180926.mp4")
                let player = AVPlayer(url: videoURL!)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                self.present(playerViewController, animated: true) {
                    playerViewController.player!.play()
                }
                
            } else {
                if UserDefaults.standard.value(forKey: "LANGUAGE") != nil {
                    let language = UserDefaults.standard.value(forKey: "LANGUAGE") as! String
                    
                    if language == "EN" {
                        
                        let videoURL = URL(string: "https://tweakandeatappassets.s3.ap-south-1.amazonaws.com/tae_en_howitworks_20180926.mp4")
                        let player = AVPlayer(url: videoURL!)
                        let playerViewController = AVPlayerViewController()
                        playerViewController.player = player
                        self.present(playerViewController, animated: true) {
                            playerViewController.player!.play()
                        }
                        
                    } else if language == "BA" {
                        let videoURL = URL(string: "https://s3.ap-south-1.amazonaws.com/tweakandeatappassets/tae_and_how_it_works_ba.mp4")
                        let player = AVPlayer(url: videoURL!)
                        let playerViewController = AVPlayerViewController()
                        playerViewController.player = player
                        self.present(playerViewController, animated: true) {
                            playerViewController.player!.play()
                        }
                        
                        
                    }
                } else {
                    guard let vPath = Bundle.main.path(forResource: "tae_en_howitworks_20180926", ofType: "mp4") else {
                        debugPrint("video.mp4 not found")
                        return
                    }
                    let player = AVPlayer(url: URL(fileURLWithPath: vPath))
                    let playerController = AVPlayerViewController()
                    playerController.player = player
                    present(playerController, animated: true) {
                        player.play()
                    }
                }
            }
        }
        
    }
    

    func playVideoStartPage() {
       
            if UserDefaults.standard.value(forKey: "LANGUAGE") != nil {
                let language = UserDefaults.standard.value(forKey: "LANGUAGE") as! String
                
                if language == "EN" {
                    
                    let videoURL = URL(string: "https://tweakandeatappassets.s3.ap-south-1.amazonaws.com/tae_en_howitworks_20180926.mp4")
                    let player = AVPlayer(url: videoURL!)
                    let playerViewController = AVPlayerViewController()
                    playerViewController.player = player
                    self.present(playerViewController, animated: true) {
                        playerViewController.player!.play()
                    }
                    
                } else if language == "BA" {
                    let videoURL = URL(string: "https://s3.ap-south-1.amazonaws.com/tweakandeatappassets/tae_and_how_it_works_ba.mp4")
                    let player = AVPlayer(url: videoURL!)
                    let playerViewController = AVPlayerViewController()
                    playerViewController.player = player
                    self.present(playerViewController, animated: true) {
                        playerViewController.player!.play()
                    }

                }
            } else {
                guard let vPath = Bundle.main.path(forResource: "tae_en_howitworks_20180926", ofType: "mp4") else {
                    debugPrint("video.mp4 not found")
                    return
                }
                let player = AVPlayer(url: URL(fileURLWithPath: vPath))
                let playerController = AVPlayerViewController()
                playerController.player = player
                present(playerController, animated: true) {
                    player.play()
                }
                
            }
            
        }
    
    @objc func showPopupFromAppLaunchWhenTappedNotification(aps: [String: AnyObject]) {
        var msg = ""
        var imgUrlString = ""
        let obj = aps
        if obj.index(forKey: "msg") != nil {
            let message = obj["msg"] as! String
            msg = message.html2String.replacingOccurrences(of: "\\", with: "")
           
        }
        if obj.index(forKey: "img") != nil {
                   imgUrlString = obj["img"] as! String
        }
        link = obj["link"] as! String
        if obj["type"] as! Int == 1 {
            // self.navigationController?.isNavigationBarHidden = true
            self.popUpViewForPTP.isHidden = false
            self.popUPPTPImageView.sd_setImage(with: URL.init(string: imgUrlString))
            self.popUpPTPTextView.text = ""
        } else if obj["type"] as! Int == 0 {
            self.smallScreenPopUp.isHidden = false
            if link == "HOW_IT_WORKS" {
                self.smallScreenPopUpBtn.setTitle("PLAY VIDEO", for: .normal)
            };
            self.smallScreenPopUpImageView.sd_setImage(with: URL(string: imgUrlString)) { (image, error, cache, url) in
                // Your code inside completion block
                let ratio = image!.size.width / image!.size.height
                let newHeight = self.smallScreenPopUpImageView.frame.width / ratio
                self.smallScreenPopupImageViewHeightConstraint.constant = newHeight
                self.view.layoutIfNeeded()
            }
            
            self.smallScreenPopUpTextView.text = msg
        }  else if obj["type"] as! Int == 3 {
                   
                   let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
                        let clickViewController = storyBoard.instantiateViewController(withIdentifier: "MyWallViewController") as? MyWallViewController;
                   clickViewController?.feedId = link
                   clickViewController?.type = obj["type"] as! Int
                     self.navigationController?.pushViewController(clickViewController!, animated: true)
               } else if obj["type"] as! Int == 4 {
                          
                          let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
                               let clickViewController = storyBoard.instantiateViewController(withIdentifier: "MyWallViewController") as? MyWallViewController;
                          clickViewController?.feedId = link
                          clickViewController?.type = obj["type"] as! Int
                            self.navigationController?.pushViewController(clickViewController!, animated: true)
                      }
        UserDefaults.standard.removeObject(forKey: "PUSHWHENKILLED")
        
    }
    
    func reportsButtonTapped() {
        self.goToTweakTrends()
    }
    
    func goToTweakTrends() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
                let vc : TweakTrendReportViewController = storyBoard.instantiateViewController(withIdentifier: "TweakTrendReportViewController") as! TweakTrendReportViewController;
                let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
                navController?.pushViewController(vc, animated: true);
    }
    
    @objc func swapViews(_ notification: NSNotification) {
//        let bool = notification.object as! Bool
//        UIView.transition(with: self.view, duration: 0.2, options: .transitionCrossDissolve, animations: {
//               }, completion: {(_ completed: Bool) -> Void in
//                self.goToTweakTrends()
//
////                if bool == true {
////                    if (self.myNutritionDetailsView != nil) {
////                        self.myNutritionViewLast10TweaksTableView.isHidden = true
////                        self.myNutritionViewSelectYourMealTableView.isHidden = true
////                        self.myNutritionView.isHidden = true
////                        self.switchButton.isHidden = false
////                        self.showGraph = true
////                        //self.myNutritionDetailsView.switchButton.setStatus(bool)
////
////                        self.updateSwitchUI(bool: true)
////                        self.setDefaultDataBtns(name: self.dataBtnName)
////                    }
////                } else {
////                    if (self.myNutritionDetailsView != nil) {
////                        self.mealTypeTableView.isHidden = true
////                        self.switchButton.isHidden = true
////                                   self.myNutritionView.isHidden = false
////                                   self.showGraph = false
////                         self.myNutritionDetailsView.switchButton.setStatus(false)
////                                   self.setDefaultDataBtns(name: self.dataBtnName)
////                    }
////                }
////
////                self.updateUIAccordingTOEachDevice()
//
//        })
        
        
    }
    @objc func showPopUpNotifications(_ notification: NSNotification) {
        var msg = ""
        var imgUrlString = ""
        let obj = notification.object as! [String: AnyObject]
        if obj.index(forKey: "msg") != nil {
            let message = obj["msg"] as! String
            msg = message.html2String.replacingOccurrences(of: "\\", with: "")
            imgUrlString = obj["imgUrlString"] as! String
        }
        link = obj["link"] as! String
        if obj["type"] as! Int == 1 {
           // self.navigationController?.isNavigationBarHidden = true
            self.popUpViewForPTP.isHidden = false
            self.popUPPTPImageView.sd_setImage(with: URL.init(string: imgUrlString))
            self.popUpPTPTextView.text = msg
        } else if obj["type"] as! Int == 0 {
            self.smallScreenPopUp.isHidden = false
            if link == "HOW_IT_WORKS" {
                self.smallScreenPopUpBtn.setTitle("PLAY VIDEO", for: .normal)
            };
            self.smallScreenPopUpImageView.sd_setImage(with: URL(string: imgUrlString)) { (image, error, cache, url) in
                // Your code inside completion block
                let ratio = image!.size.width / image!.size.height
                let newHeight = self.smallScreenPopUpImageView.frame.width / ratio
                self.smallScreenPopupImageViewHeightConstraint.constant = newHeight
                self.view.layoutIfNeeded()
            }
            
            self.smallScreenPopUpTextView.text = msg

        } else if obj["type"] as! Int == 3 {
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
                 let clickViewController = storyBoard.instantiateViewController(withIdentifier: "MyWallViewController") as? MyWallViewController;
            clickViewController?.feedId = link
            clickViewController?.type = obj["type"] as! Int
              self.navigationController?.pushViewController(clickViewController!, animated: true)
        } else if obj["type"] as! Int == 4 {
                   
                   let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
                        let clickViewController = storyBoard.instantiateViewController(withIdentifier: "MyWallViewController") as? MyWallViewController;
                   clickViewController?.feedId = link
                   clickViewController?.type = obj["type"] as! Int
                     self.navigationController?.pushViewController(clickViewController!, animated: true)
               }
    }
    
    @objc func decideToGotoTAEClub() {
         if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
                   self.countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
            if self.countryCode == "91" || self.countryCode == "62" {
        if UserDefaults.standard.value(forKey: "-ClubInd3gu7tfwko6Zx") != nil || UserDefaults.standard.value(forKey: "-ClubIdn4hd8flchs9Vy") != nil {
                              self.goToTAEClubMemPage()

                          } else {
                              self.goToTAEClub()
                          }
        }
        }
    }
    
    @objc func pressed(sender: UIButton!) {
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
                   self.countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
        }
        var clubPackageSubscribed = ""
        if self.countryCode == "91" {
            clubPackageSubscribed = "-ClubInd3gu7tfwko6Zx"
        } else if self.countryCode == "62" {
            clubPackageSubscribed = "-ClubIdn4hd8flchs9Vy"
        } else if self.countryCode == "1" {
            clubPackageSubscribed = "-ClubUSA4tg6cvdhizQn"
        } else if self.countryCode == "65" {
            clubPackageSubscribed = "-ClubSGNPbeleu8beyKn"
        } else if self.countryCode == "60" {
            clubPackageSubscribed = "-ClubMYSheke8ebdjoWs"
        }
        if (link == "" || link == "HOME") {
            self.popUpView.removeFromSuperview()
        } else if link == "CLUB_PURCHASE" || link == "CLUB_PUR_IND_OP_1M" {
            self.popUpView.removeFromSuperview()
            if UserDefaults.standard.value(forKey: "-ClubInd3gu7tfwko6Zx") != nil || UserDefaults.standard.value(forKey: "-ClubIdn4hd8flchs9Vy") != nil {
              self.goToTAEClubMemPage()
            } else {
                if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
                    self.countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
                }
                if self.countryCode == "91" {
                self.goToBuyScreen(packageID: "-ClubInd3gu7tfwko6Zx", identifier: "CLUB_PUR_IND_OP_1M")
                } else {
                    self.goToPurchaseTAEClubScreen()

                }
                

            }
        } else if link == "CLUBAIDP_PUR_IND_OP_1M" {
            if UserDefaults.standard.value(forKey: "-ClubInd4tUPXHgVj9w3") != nil {
             self.performSegue(withIdentifier: "myTweakAndEat", sender: "-ClubInd4tUPXHgVj9w3");
                //self.performSegue(withIdentifier: "myTweakAndEat", sender: link);
            } else {
           self.goToBuyScreen(packageID: "-ClubInd4tUPXHgVj9w3", identifier: link)
            }
        } else if link == "MYTAE_PUR_IND_OP_3M" || link == "WLIF_PUR_IND_OP_3M" {
            self.popUpView.removeFromSuperview()
            if link == "MYTAE_PUR_IND_OP_3M" {
                if UserDefaults.standard.value(forKey: "-IndIWj1mSzQ1GDlBpUt") != nil {
                 self.performSegue(withIdentifier: "myTweakAndEat", sender: "-IndIWj1mSzQ1GDlBpUt");
                    //self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
                } else {
            self.goToBuyScreen(packageID: "-IndIWj1mSzQ1GDlBpUt", identifier: link)
                }
            } else if link == "WLIF_PUR_IND_OP_3M" {
                if UserDefaults.standard.value(forKey: "-IndWLIntusoe3uelxER") != nil {
                 self.performSegue(withIdentifier: "myTweakAndEat", sender: "-IndWLIntusoe3uelxER");
                    //self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
                } else {
            self.goToBuyScreen(packageID: "-IndWLIntusoe3uelxER", identifier: link)
                }
            }
        } else if link == "CLUB_SUBSCRIPTION" || link == clubPackageSubscribed {
            //MYTAE_PUR_IND_OP_3M
                      if UserDefaults.standard.value(forKey: clubPackageSubscribed) != nil {
                         self.goToTAEClubMemPage()
                       } else {
                        DispatchQueue.main.async {
                        MBProgressHUD.showAdded(to: self.view, animated: true);
                        }
                        self.moveToAnotherView(promoAppLink: clubPackageSubscribed)                       }
        }  else if link == "-NcInd5BosUcUeeQ9Q32" {
            
            
            if UserDefaults.standard.value(forKey: link) != nil {
                self.goToNutritonConsultantScreen(packageID: link)
            } else {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true);
                }
                self.moveToAnotherView(promoAppLink: link)

                
                
            }
            
        } else {
            self.popUpView.removeFromSuperview()
            tappedOnPopUpDone()
        }
        
        print("presseddd")
    }
    
    @objc func languageSelectedAgain(lang: String) {
        self.view.endEditing(true)
        if lang == "BA" {
            UserDefaults.standard.set(lang, forKey: "LANGUAGE")
            path = Bundle.main.path(forResource: "id", ofType: "lproj")
            bundle = Bundle.init(path: path!)! as Bundle
            self.tweakOTPView.otpLanguageView.isHidden = true
        } else if lang == "EN" {
            UserDefaults.standard.set(lang, forKey: "LANGUAGE")
            path = Bundle.main.path(forResource: "en", ofType: "lproj")
            bundle = Bundle.init(path: path!)! as Bundle
            self.tweakOTPView.otpLanguageView.isHidden = true
        }
        // self.tweakOTPView.tweakOTPView.setupUI()
        self.setUpUIElements()
        
    }
    
    @objc func setUpUIElements() {
        DispatchQueue.main.async {
            
        
        self.tweakOTPView.welcomeLabel.text = self.bundle.localizedString(forKey: "intro_welcome", value: nil, table: nil)
        self.tweakOTPView.numberHintLabel.text = self.bundle.localizedString(forKey: "not_required_zero", value: nil, table: nil)
        self.tweakOTPView.doneBarButton.title = self.bundle.localizedString(forKey: "action_done", value: nil, table: nil)
        self.tweakOTPView.cancelBarButton.title = self.bundle.localizedString(forKey: "action_cancel", value: nil, table: nil)
        self.tweakOTPView.otpLangDescLabel.text = self.bundle.localizedString(forKey: "preferred_language", value: nil, table: nil);
        self.tweakOTPView.sendANDVerifyButton.setTitle(self.bundle.localizedString(forKey: "button_send_code", value: nil, table: nil), for: .normal)
        self.tweakOTPView.resendButton.setTitle(self.bundle.localizedString(forKey: "button_resend", value: nil, table: nil), for: .normal)
        }
    }
    
    
    
    @objc func getStaticText(lang: String) {
        let showRegistration : Bool?  = UserDefaults.standard.value(forKey: "showRegistration") as? Bool;
        if(showRegistration == nil || showRegistration!) {
            
            self.tabBarController?.tabBar.isHidden = true;
            self.navigationController?.isNavigationBarHidden = true;
            
            tweakView = (Bundle.main.loadNibNamed("TweakAnimationWelcomeView", owner: self, options: nil)! as NSArray).firstObject as! TweakAnimationWelcomeView;
            tweakView.frame = self.view.frame;
            tweakView.delegate = self;
            self.view.addSubview(tweakView);
            tweakView.beginning();
            self.tweakView.languageSelectionView.isHidden = true
            if  self.languageSelected == false {
                
                let networkInfo = CTTelephonyNetworkInfo();
                let carrier = networkInfo.subscriberCellularProvider;
                let countryCode = carrier?.isoCountryCode?.uppercased();
                if countryCode != nil {
                    let country = "+\(getCountryPhonceCode(countryCode!))" ;
                    if country == "+62" || country == "+60" {
                        self.tweakView.languageSelectionView.isHidden = false
                    } else {
                        UserDefaults.standard.set("EN", forKey: "LANGUAGE")
                        path = Bundle.main.path(forResource: "en", ofType: "lproj")
                        bundle = Bundle.init(path: path!)! as Bundle
                    }
                    
                } else {
                    self.tweakView.languageSelectionView.isHidden = false
                }
            }
            self.tweakView.okButton.setTitle(bundle.localizedString(forKey: "ok", value: nil, table: nil), for: .normal)
            self.tweakView.welcomeToLabel.text = bundle.localizedString(forKey: "intro_welcome", value: nil, table: nil)
            self.selectedGender = self.bundle.localizedString(forKey: "male", value: nil, table: nil)
            
            appDelegateTAE = UIApplication.shared.delegate as! AppDelegate;
            appDelegateTAE.networkReconnectionBlock = {
                DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view, animated: true);
                }
                APIWrapper.sharedInstance.getStaticText(lang: lang, { (responceDic : AnyObject!) ->(Void) in
                    if(TweakAndEatUtils.isValidResponse(responceDic as? [String:AnyObject])) {
                        
                        let response : [String:AnyObject] = responceDic as! [String:AnyObject];
                        var welcomeText : NSString? = nil;
                        if(response[TweakAndEatConstants.CALL_STATUS] as!
                            String == TweakAndEatConstants.TWEAK_STATUS_GOOD) {
                            self.introTextArray = response[TweakAndEatConstants.DATA] as? [AnyObject];
                            if(self.introTextArray != nil) {
                                let introTextDic = self.introTextArray!.filter({ (element) -> Bool in
                                    if((element as! NSDictionary).value(forKey: TweakAndEatConstants.STATIC_NAME) as! String == TweakAndEatConstants.INTRO_TEXT) {
                                        return true;
                                    } else {
                                        return false;
                                    }
                                })
                                
                                if(introTextDic .count > 0) {
                                    welcomeText = (introTextDic[0] as! NSDictionary).value(forKey: TweakAndEatConstants.STATIC_VALUE) as? NSString;
                                }
                                
                                if(welcomeText != nil) {
                                    let notesArray : [String] = welcomeText!.components(separatedBy: self.textSaperator)
                                    print(notesArray)
                                    if(notesArray.count > 0) {
                                        self.tweakView.setWelcomeViewText(notesArray[0] as String,looseWeightText: notesArray[1] as String);
                                        DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true);
                }
                                        self.tweakView.animateLogo();
                                        
                                    }
                                }
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true);
                }
                    }
                }) { (error : NSError!) -> (Void) in
                    
                    DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true);
                }
                    let alertController = UIAlertController(title: self.bundle.localizedString(forKey: "no_internet", value: nil, table: nil), message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil), preferredStyle: UIAlertController.Style.alert)
                    
                    let okAction1 = UIKit.UIAlertAction(title: self.bundle.localizedString(forKey: "retry", value: nil, table: nil), style: UIAlertAction.Style.default) {
                        UIAlertAction in
                        NSLog("OK Pressed")
                        self.tweakView.removeFromSuperview()
                        if UserDefaults.standard.value(forKey: "LANGUAGE") != nil {
                            let language = UserDefaults.standard.value(forKey: "LANGUAGE") as! String
                            self.getStaticText(lang: language)
                        } else {
                            self.getStaticText(lang: "EN")
                        }
                        
                    }
                    
                    // Add the actions
                    alertController.addAction(okAction1)
                    
                    // Present the controller
                    self.present(alertController, animated: true, completion: nil)
                    
                    
                }
            }
            if(self.reachability.currentReachabilityStatus() == NetworkStatus.NotReachable) {
                DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true);
                }
                let alertController = UIAlertController(title: self.bundle.localizedString(forKey: "no_internet", value: nil, table: nil), message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil), preferredStyle: UIAlertController.Style.alert)
                
                let okAction1 = UIKit.UIAlertAction(title: self.bundle.localizedString(forKey: "retry", value: nil, table: nil), style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    NSLog("OK Pressed")
                    self.tweakView.removeFromSuperview()
                    
                    if UserDefaults.standard.value(forKey: "LANGUAGE") != nil {
                        let language = UserDefaults.standard.value(forKey: "LANGUAGE") as! String
                        self.getStaticText(lang: language)
                    } else {
                        self.getStaticText(lang: "EN")
                    }
                }
                
                
                // Add the actions
                alertController.addAction(okAction1)
                
                // Present the controller
                self.present(alertController, animated: true, completion: nil)
            } else {
                appDelegateTAE.networkReconnectionBlock!();
            }
        }
    }
    
    @objc func registrationProcess(){
        
        TweakAndEatUtils.AlertView.showAlert(view: self, message: bundle.localizedString(forKey: "blocked_status", value: nil, table: nil))
        
        self.tabBarController?.tabBar.isHidden = true;
        self.navigationController?.isNavigationBarHidden = true;
        tweakView = (Bundle.main.loadNibNamed("TweakAnimationWelcomeView", owner: self, options: nil)! as NSArray).firstObject as! TweakAnimationWelcomeView;
        tweakView.frame = self.view.bounds;
        tweakView.delegate = self;
        self.view.addSubview(tweakView);
        tweakView.beginning();
        self.tweakView.okButton.setTitle(bundle.localizedString(forKey: "ok", value: nil, table: nil), for: .normal)
        
        self.tweakView.welcomeToLabel.text = bundle.localizedString(forKey: "intro_welcome", value: nil, table: nil)
        appDelegateTAE = UIApplication.shared.delegate as! AppDelegate;
        appDelegateTAE.networkReconnectionBlock = {
            DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view, animated: true);
                }
            var language = "EN"
            if UserDefaults.standard.value(forKey: "LANGUAGE") != nil {
                language = UserDefaults.standard.value(forKey: "LANGUAGE") as! String
            }
            APIWrapper.sharedInstance.getStaticText(lang: language, { (responceDic : AnyObject!) ->(Void) in
                if(TweakAndEatUtils.isValidResponse(responceDic as? [String:AnyObject])) {
                    let response : [String:AnyObject] = responceDic as! [String:AnyObject];
                    var welcomeText : NSString? = nil;
                    if(response[TweakAndEatConstants.CALL_STATUS] as! String == TweakAndEatConstants.TWEAK_STATUS_GOOD) {
                        self.introTextArray = response[TweakAndEatConstants.DATA] as? [AnyObject];
                        if(self.introTextArray != nil) {
                            let introTextDic =  self.introTextArray!.filter({ (element) -> Bool in
                                if((element as! NSDictionary).value(forKey: TweakAndEatConstants.STATIC_NAME) as! String == TweakAndEatConstants.INTRO_TEXT) {
                                    return true;
                                } else {
                                    return false;
                                }
                            })
                            
                            if(introTextDic .count > 0) {
                                welcomeText = (introTextDic[0] as! NSDictionary).value(forKey: TweakAndEatConstants.STATIC_VALUE) as? NSString;
                            }
                            
                            if(welcomeText != nil) {
                                let notesArray : [String] = welcomeText!.components(separatedBy: self.textSaperator)
                                if(notesArray.count > 0) {
                                    self.tweakView.setWelcomeViewText(notesArray[0] as String, looseWeightText: notesArray[1] as String);
                                    DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true);
                }
                                    self.tweakView.animateLogo();
                                }
                            }
                        }
                    }
                } else {
                    //error
                    DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true);
                }
                }
            }) { (error : NSError!) -> (Void) in
                //error
                DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true);
                }
                let alertController = UIAlertController(title: self.bundle.localizedString(forKey: "no_internet", value: nil, table: nil), message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil), preferredStyle: UIAlertController.Style.alert)
                
                let defaultAction = UIAlertAction(title:  self.bundle.localizedString(forKey: "ok", value: nil, table: nil), style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @objc func takephoto() {
        
        let optionMenu = UIAlertController(title: nil, message: bundle.localizedString(forKey: "capture_food", value: nil, table: nil), preferredStyle: .actionSheet);
        
        // 2
        let cameraAction = UIAlertAction(title: bundle.localizedString(forKey: "camera", value: nil, table: nil), style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                let imagePicker = UIImagePickerController();
                imagePicker.delegate = self;
                imagePicker.sourceType = UIImagePickerController.SourceType.camera
                imagePicker.allowsEditing = true;
                self.present(imagePicker, animated: true, completion: nil);
            }
            
        })
        let saveAction = UIAlertAction(title: bundle.localizedString(forKey: "choose_photo_library", value: nil, table: nil), style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                let imagePicker = UIImagePickerController();
                imagePicker.delegate = self;
                imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary;
                imagePicker.allowsEditing = true;
                self.present(imagePicker, animated: true, completion: nil);
            }
            
        })
        
        
        let cancelAction = UIAlertAction(title: bundle.localizedString(forKey: "action_cancel", value: nil, table: nil), style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        optionMenu.addAction(cameraAction);
        optionMenu.addAction(saveAction);
        optionMenu.addAction(cancelAction);
        
        self.present(optionMenu, animated: true, completion: nil);
    }
    
    @objc func ageAlert() {
        let alert = UIAlertController(title: bundle.localizedString(forKey: "alert", value: nil, table: nil), message: bundle.localizedString(forKey: "alert_allfields", value: nil, table: nil), preferredStyle: UIAlertController.Style.alert);
        alert.addAction(UIAlertAction(title: bundle.localizedString(forKey: "ok", value: nil, table: nil), style: UIAlertAction.Style.default, handler: nil));
        self.present(alert, animated: true, completion: nil);
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true);
        return false;
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true);
        super.touchesBegan(touches, with: event);
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(true)
//        if self.goneUp == true {
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SCROLL_HOME_SCREEN"), object: true)
//        }
//
//    }
    override func viewDidAppear(_ animated: Bool) {
    //    roundImageView.contentMode = UIView.ContentMode.scaleAspectFill;
        if UserDefaults.standard.value(forKey: "GET_TREND_CALORIES") != nil {
                   let calArray = UserDefaults.standard.value(forKey: "GET_TREND_CALORIES")
           
            
          self.mealType = 0
            self.mealTypeLabel.text = "All"
            self.dataBtnName = "lastTenData"
            self.trends = "Calories"
            nutritionViewSelectedMeal = bundle.localizedString(forKey: "select_meal_type", value: nil, table: nil);
            nutritionViewLast10TweaksDataVal = bundle.localizedString(forKey: "last_ten_tweaks", value: nil, table: nil);
            DispatchQueue.main.async {
                      self.caloriesButton.alpha = 1.0
                      self.carbsButton.alpha = 1.0
                      self.fatButton.alpha = 1.0
                      self.protienButton.alpha = 1.0
                      self.fatButton.backgroundColor = UIColor.clear
                      self.protienButton.backgroundColor = UIColor.clear
                      self.carbsButton.backgroundColor = UIColor.clear
                      self.caloriesButton.backgroundColor = UIColor.clear
                  }
                 
                      self.trends = "Calories"
                      DispatchQueue.main.async {

                      self.myTrendsLabel.text = "MY CALORIE TRENDS"
                          self.caloriesButton.backgroundColor = UIColor.black.withAlphaComponent(0.3);
                      }
            self.setDefaultDataBtns(name: "lastTenData")
            
                //   self.updateChartFromSecondTime(backGroundCol: "#168c7a", data: calArray as! [Any], name: "Calories", colorTheme: ["#528039"])
               } else {
                   
               }
    }
    
    @objc func goToMyPackages() {
        self.gotToDesiredPackageViewController();
    }
    
    @objc func setUpUI() {
        
        if UserDefaults.standard.value(forKey: "LANGUAGE") != nil {
            let language = UserDefaults.standard.value(forKey: "LANGUAGE") as! String;
            if language == "BA" {
                path = Bundle.main.path(forResource: "id", ofType: "lproj");
                bundle = Bundle.init(path: path!)! as Bundle;
            
            } else if language == "EN" {
                
                path = Bundle.main.path(forResource: "en", ofType: "lproj");
                bundle = Bundle.init(path: path!)! as Bundle;
                
            }
        }
        self.title = bundle.localizedString(forKey: "app_name", value: nil, table: nil);
        DispatchQueue.main.async {
            
      //  self.tweakStreakLbl.text = self.bundle.localizedString(forKey: "my_tweak_streak", value: nil, table: nil)
        self.tweakWallLabel.text = self.bundle.localizedString(forKey: "tweak_wall", value: nil, table: nil);
        
      //  self.checkThisOutLabel.text = self.bundle.localizedString(forKey: "check_this_out", value: nil, table: nil);
        
      //  self.cameraTweakLabel.text = self.bundle.localizedString(forKey: "camera_click_text", value: nil, table: nil);
            self.approxCalLeftForDayLabel.text = self.bundle.localizedString(forKey: "approximate_calories_left_for_the_day", value: nil, table: nil);
        
        self.recipeWallLabel.text = self.bundle.localizedString(forKey: "recipe_wall", value: nil, table: nil);
        
        self.myFitnessLabel.text = self.bundle.localizedString(forKey: "my_fitness", value: nil, table: nil);
        
        self.myEDRLabel.text = self.bundle.localizedString(forKey: "my_edr", value: nil, table: nil);
        
        self.myEdrLbl1.text = self.bundle.localizedString(forKey: "my_edr", value: nil, table: nil);
        
        self.nutritionLbl1.text = self.bundle.localizedString(forKey: "nutition_label", value: nil, table: nil);
        
        self.recipeWallLbl1.text = self.bundle.localizedString(forKey: "recipe_wall", value: nil, table: nil);
        
        self.tweakWallLbl1.text = self.bundle.localizedString(forKey: "tweak_wall", value: nil, table: nil);
        
        self.myNutritionLbl1.text = self.bundle.localizedString(forKey: "nutition_analytics", value: nil, table: nil);
        
        self.fitnessLbl1.text = self.bundle.localizedString(forKey: "my_fitness", value: nil, table: nil);
            
        }
        
//        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
//            countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
//            if (countryCode == "1" || countryCode == "60" || countryCode == "65" || countryCode == "62") {
//                DispatchQueue.main.async {
//                self.premiumIconBarButton.tintColor = UIColor.white;
//                self.iconsView.isHidden = true;
//                    self.menuButtonsView.isHidden = false
//                self.premiumMember.isUserInteractionEnabled = true;
//                self.premiumMember.setImage(UIImage.init(named: "mytae_btn.png"), for: .normal);
//                }
//            } else if countryCode == "91" {
//                 DispatchQueue.main.async {
//                self.tweakBubbleImageView.isHidden = false
//                self.tweakReactView.isHidden = false
//                self.randomMessages.text = "Recommend 'Go Premium' very highly!"
//                }
//            }
//
//        }
        
    }
    
    
    @IBAction func myTandEViewFitness(_ sender: Any) {
        self.fitnessBtnAction();
    }
    
    @objc func setUpPhilippinesView() {
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
            let  countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
            if countryCode == "63" {
    self.philippinesPTPView1.isHidden = false
    self.philippinesPTPView2.isHidden = false
                self.ptpBtn1.layer.shadowRadius = 0
                self.ptpBtn1.layer.shadowOpacity = 0
                self.ptpBtn1.layer.shadowColor = UIColor.clear.cgColor
                self.ptpBtn2.layer.shadowRadius = 0
                self.ptpBtn2.layer.shadowOpacity = 0
                self.ptpBtn2.layer.shadowColor = UIColor.clear.cgColor


            }
        }
    
    }
    
//    func getGlobalVariablesData() {
//        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
//            self.countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
//        }
//        Database.database().reference().child("GlobalVariables").child("Pages").child("GamifyingLevel0").child(self.countryCode).child("iOS").observe(DataEventType.value, with: { (snapshot) in
//
//                    if snapshot.childrenCount > 0 {
//                         self.sectionsForGamifyArray = []
//                                let dispatch_group1 = DispatchGroup();
//                                dispatch_group1.enter();
//                                   for obj in snapshot.children.allObjects as! [DataSnapshot] {
//                                    if obj.key == "Sections" {
//                                        let sectionsArray = obj.value as AnyObject as! NSArray
//                                        self.sectionsForGamifyArray = sectionsArray as AnyObject as! [[String : AnyObject]]
//
//                                    }
//
//
//                    }
//
//                        dispatch_group1.leave();
//
//                        dispatch_group1.notify(queue: DispatchQueue.main) {
//                            MBProgressHUD.hide(for: self.view, animated: true);
//
//                            self.performSegue(withIdentifier: "gamify", sender: self)
//                        }
//
//                    } else {
//                        DispatchQueue.main.async {
//                        MBProgressHUD.hide(for: self.view, animated: true);
//                        }
//                        self.takephoto();
//            }
//
//
//
//
//                })
//    }

    @objc func getPremiumBtn() {
        //CLUBHOME1_RIGHT_BUTTON
     

        if let _ = Auth.auth().currentUser?.uid {
            if UserDefaults.standard.value(forKey: "PREMIUM_BUTTON_DATA") != nil {
                DispatchQueue.main.async {
                    
                    self.premiumMember.setImage(UIImage(data: UserDefaults.standard.value(forKey: "PREMIUM_BUTTON_DATA") as! Data), for: .normal)
                    self.tweakBubbleImageView.isHidden = false
                    self.tweakReactView.isHidden = false
                    
                }
            } else {
        Database.database().reference().child("GlobalVariables").child("btn_premium_pkgs").observe(DataEventType.value, with: { (snapshot) in
           
            let imageUrl = snapshot.value as AnyObject as! String
            
                let url = URL(string: imageUrl)
            DispatchQueue.global(qos: .background).async {
                // Call your background task
                let data = try? Data(contentsOf: url!)
                // UI Updates here for task complete.
             //   UserDefaults.standard.set(data, forKey: "PREMIUM_BUTTON_DATA");

                if let imageData = data {
                    let image = UIImage(data: imageData)
                    DispatchQueue.main.async {
                        
                        self.premiumMember.setImage(image, for: .normal)
                        
                    }
            }
            

                
            }
           
            
           
            
        })
        }
        }
        
    }
    
    @objc func showButtonsView() {

        Database.database().reference().child("NonPremiumPackages").observe(DataEventType.value, with: { (snapshot) in
            // this runs on the background queue
            // here the query starts to add new 10 rows of data to arrays
            self.activeCountriesArray = NSMutableArray();
            
            if snapshot.childrenCount > 0 {
                let dispatch_group = DispatchGroup();
                dispatch_group.enter();
                
                for premiumPackages in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let packageObj = premiumPackages.value as? [String : AnyObject];
                    if !((packageObj?["activeCountries"] as AnyObject) is NSNull) {
                        
                        self.activeCountriesArray = packageObj!["activeCountries"] as AnyObject as! NSMutableArray;
                        
                        
                    } else {
                        
                    }
                }
                dispatch_group.leave();
                dispatch_group.notify(queue: DispatchQueue.main) {
//                    if self.activeCountriesArray.contains(self.countryCode) {
////                        if (self.countryCode == "62" || self.countryCode == "65") {
////                             DispatchQueue.main.async {
////                            self.tweakBubbleImageView.isHidden = false
////                            self.tweakReactView.isHidden = false
////                            self.adsImageView.isHidden = true
////                            self.premiumMember.isHidden = true
////                            self.iconsView.isHidden = false
////                            //self.premiumIconBarButton.isEnabled = false
////                            self.menuButtonsView.isHidden = true
////                            }
////
////
////                        } else
//                            if (self.countryCode == "1" || self.countryCode == "60" || self.countryCode == "65" || self.countryCode == "62") {
//                             DispatchQueue.main.async {
//                            self.tweakBubbleImageView.isHidden = false
//                            self.tweakReactView.isHidden = false
//                            self.adsImageView.isHidden = true
//                                self.menuButtonsView.isHidden = false
//                            //self.premiumMember.isHidden = false
//                            self.premiumMember.isUserInteractionEnabled = true
//                            //self.premiumIconBarButton.isEnabled = false
//                            self.iconsView.isHidden = true
//                            }
//                            //self.menuButtonsView.isHidden = false
//
//
//                        } else if self.countryCode == "91" {
//                             DispatchQueue.main.async {
//                            self.tweakBubbleImageView.isHidden = false
//                            self.tweakReactView.isHidden = false
//                            self.iconsView.isHidden = false
//                            self.menuButtonsView.isHidden = true
//                            self.adsImageView.isHidden = true
//                            }
//                            //self.premiumMember.isHidden = false
//                            self.getBottomImageView()
////                            if let currentUserID = Auth.auth().currentUser?.uid {
////                                self.getPremiumBtn()
////                            }
//                        } else {
//                             DispatchQueue.main.async {
//                            self.tweakBubbleImageView.isHidden = false
//                            self.tweakReactView.isHidden = false
//                            self.adsImageView.isHidden = true
//                            self.premiumMember.isHidden = true
//                            //self.premiumMember.isUserInteractionEnabled = false
//                            //self.premiumIconBarButton.isEnabled = false
//                            self.iconsView.isHidden = true
//                            self.menuButtonsView.isHidden = false
//                        }
//                        }
//
//                    } else {
//                         DispatchQueue.main.async {
//                        self.tweakBubbleImageView.isHidden = false
//                        self.tweakReactView.isHidden = false
//                        self.adsImageView.isHidden = true
//                        self.premiumMember.isHidden = true
//                       // self.premiumMember.isUserInteractionEnabled = false
//                        //self.premiumIconBarButton.isEnabled = false
//                        self.iconsView.isHidden = true
//                        self.menuButtonsView.isHidden = false
//                        }
//                    }
                    
                }
                
            } else {
                DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true);
                }
                
            }
        })
    }
    
    @objc func getFirebaseData() {
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
            countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
            //  countryCode = "62"
        }
        var cCode = ""
        var dbReference = Database.database().reference().child("PremiumPackageDetailsiOS")
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
            cCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
            if cCode == "91" || cCode == "1" {
                dbReference = Database.database().reference().child("PremiumPackageDetails").child("Packs")
            }
              }
        dbReference.observe(DataEventType.value, with: { (snapshot) in
            // this runs on the background queue
            // here the query starts to add new 10 rows of data to arrays
            self.premiumPackagesArray = NSMutableArray()
            
            if snapshot.childrenCount > 0 {
                let dispatch_group = DispatchGroup()
                dispatch_group.enter()
                
                for premiumPackages in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let packageObj = premiumPackages.value as? [String : AnyObject];
                    if !((packageObj?["activeCountries"] as AnyObject) is NSNull) {
                        let activeCountriesArray = packageObj!["activeCountries"] as AnyObject as! NSMutableArray
                        if ((activeCountriesArray.contains(Int(self.countryCode)!)) || (activeCountriesArray.contains(self.countryCode))) {
                            self.premiumPackagesArray.add(packageObj!)
                            
                        }
                        
                        
                    } else {
                        TweakAndEatUtils.AlertView.showAlert(view: self, message: "There are no available Premium Packages. Please come later!")
                    }
                }
                //print(self.premiumPackagesArray)
                dispatch_group.leave()
                dispatch_group.notify(queue: DispatchQueue.main) {
//                    MBProgressHUD.hide(for: self.view, animated: true);
//                    if UserDefaults.standard.value(forKey: "PREMIUM_MEMBER") != nil {
//                        let pkgsArray = UserDefaults.standard.value(forKey: "PREMIUM_PACKAGES") as! NSArray
//                        if self.premiumPackagesArray.count == pkgsArray.count {
//                            self.randomMessages.stopBlink()
//                            //self.premiumIconBarButton.isEnabled = true
//                            self.premiumMember.isHidden = true
//                        }  else {
//                            self.randomMessages.startBlink()
//
//                            //self.premiumIconBarButton.isEnabled = true
//                            // self.premiumMember.isHidden = false
//
//                        }
//                    } else {
//
//
//                        self.randomMessages.startBlink()
//                        //self.premiumIconBarButton.isEnabled = false
//                        //self.premiumMember.isHidden = false
//                    }
                 
//                    if (self.countryCode == "1" || self.countryCode == "60" || self.countryCode == "65" || self.countryCode == "62") {
//                        DispatchQueue.main.async {
//
//
//                        self.tweakBubbleImageView.isHidden = false
//                        self.tweakReactView.isHidden = false
//                        self.adsImageView.isHidden = true
//                        //self.premiumMember.isHidden = false
//                        self.premiumMember.isUserInteractionEnabled = true
//                        //self.premiumIconBarButton.isEnabled = false
//                        self.iconsView.isHidden = true
//                            self.menuButtonsView.isHidden = false
//                        }
//                        //self.menuButtonsView.isHidden = false
//                    } else {
//                        self.showButtonsView()
//                    }
                    
                }
                
            } else {
                DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true);
                }
                
            }
        })
    }
    
   
    
    
    
    
    
    @IBAction func mainViewTweakWallTapped(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let clickViewController = storyBoard.instantiateViewController(withIdentifier: "MyWallViewController") as? MyWallViewController;
     self.navigationController?.pushViewController(clickViewController!, animated: true)
    }
    
    @IBAction func mainViewRecipeTapped(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let clickViewController = storyBoard.instantiateViewController(withIdentifier: "TweakRecipeViewController") as? TweakRecipeViewController;
     self.navigationController?.pushViewController(clickViewController!, animated: true)
    }
    

    
    
    @objc func tappedOnNewAdImageView() {
        self.tapOnPromoAd(mhp_id: self.mhpId)
        self.tappedOnTAEClubExpiryView()
    }
    @objc func tappedOnTAEClubExpiryView() {
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
                   self.countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
        }
        if self.countryCode == "91" {
            self.ptpPackage = "-IndAiBPtmMrS4VPnwmD"
        } else if self.countryCode == "1" {
            self.ptpPackage = "-UsaAiBPxnaopT55GJxl"
        } else if self.countryCode == "65" {
            self.ptpPackage = "-SgnAiBPJlXfM3KzDWR8"
        } else if self.countryCode == "62" {
            self.ptpPackage = "-IdnAiBPLKMO5ePamQle"
        } else if self.countryCode == "60" {
            self.ptpPackage = "-MysAiBPyaX9TgFT1YOp"
        } else if self.countryCode == "63" {
            self.ptpPackage = "-PhyAiBPcYLiSYlqhjbI"
        }
        var clubPackageSubscribed = ""
        if self.countryCode == "91" {
            clubPackageSubscribed = "-ClubInd3gu7tfwko6Zx"
        } else if self.countryCode == "62" {
            clubPackageSubscribed = "-ClubIdn4hd8flchs9Vy"
        } else if self.countryCode == "1" {
            clubPackageSubscribed = "-ClubUSA4tg6cvdhizQn"
        } else if self.countryCode == "65" {
            clubPackageSubscribed = "-ClubSGNPbeleu8beyKn"
        } else if self.countryCode == "60" {
            clubPackageSubscribed = "-ClubMYSheke8ebdjoWs"
        }
        self.pkgIdsArray = NSMutableArray()
        if UserDefaults.standard.value(forKey: "PREMIUM_MEMBER") != nil {
            if UserDefaults.standard.value(forKey: "PREMIUM_PACKAGES") != nil {
                let pkgsArray = UserDefaults.standard.value(forKey: "PREMIUM_PACKAGES") as! NSArray;
                for pkgID in pkgsArray {
                    let pkgDict = pkgID as! [String: AnyObject];
                    let pkgIDs = pkgDict["premium_pack_id"] as! String;
                    self.pkgIdsArray.add(pkgIDs)
                }
                
                
            }
        }
        let promoAppLink = self.randomPromoLink //PP_PACKAGES
        // || promoAppLink == "-IndClub3gu7tfwko6Zx"
        if promoAppLink == "CLUB_SUBSCRIPTION" || promoAppLink == clubPackageSubscribed {
         //MYTAE_PUR_IND_OP_3M
                   if UserDefaults.standard.value(forKey: clubPackageSubscribed) != nil {
                      self.goToTAEClubMemPage()
                    } else {
                     DispatchQueue.main.async {
                     MBProgressHUD.showAdded(to: self.view, animated: true);
                     }
                     self.moveToAnotherView(promoAppLink: clubPackageSubscribed)
                        
                    }
     } else if promoAppLink == "-NcInd5BosUcUeeQ9Q32" {
        
        
        if UserDefaults.standard.value(forKey: promoAppLink) != nil {
            self.goToNutritonConsultantScreen(packageID: promoAppLink)
        } else {
            DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view, animated: true);
            }
            self.moveToAnotherView(promoAppLink: promoAppLink)

            
            
        }
        
    } else if promoAppLink == "MYTAE_PUR_IND_OP_3M" || promoAppLink == "WLIF_PUR_IND_OP_3M" {
            if promoAppLink == "MYTAE_PUR_IND_OP_3M" {
                if UserDefaults.standard.value(forKey: "-IndIWj1mSzQ1GDlBpUt") != nil {
                 self.performSegue(withIdentifier: "myTweakAndEat", sender: "-IndIWj1mSzQ1GDlBpUt");
                    //self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
                } else {
            self.goToBuyScreen(packageID: "-IndIWj1mSzQ1GDlBpUt", identifier: promoAppLink)
                }
            } else if promoAppLink == "WLIF_PUR_IND_OP_3M" {
                if UserDefaults.standard.value(forKey: "-IndWLIntusoe3uelxER") != nil {
                 self.performSegue(withIdentifier: "myTweakAndEat", sender: "-IndWLIntusoe3uelxER");
                    //self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
                } else {
            self.goToBuyScreen(packageID: "-IndWLIntusoe3uelxER", identifier: promoAppLink)
                }
            }
        } else if promoAppLink == "CLUBAIDP_PUR_IND_OP_1M" {
            if UserDefaults.standard.value(forKey: "-ClubInd4tUPXHgVj9w3") != nil {
             self.performSegue(withIdentifier: "myTweakAndEat", sender: "-ClubInd4tUPXHgVj9w3");
                //self.performSegue(withIdentifier: "myTweakAndEat", sender: link);
            } else {
           self.goToBuyScreen(packageID: "-ClubInd4tUPXHgVj9w3", identifier: promoAppLink)
            }
        } else if promoAppLink == "CLUB_PURCHASE" || promoAppLink == "CLUB_PUR_IND_OP_1M" {
            if UserDefaults.standard.value(forKey: "-ClubInd3gu7tfwko6Zx") != nil || UserDefaults.standard.value(forKey: "-ClubIdn4hd8flchs9Vy") != nil {
              self.goToTAEClubMemPage()
            } else {
                if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
                    self.countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
                }
                if self.countryCode == "91" {
                self.goToBuyScreen(packageID: "-ClubInd3gu7tfwko6Zx", identifier: "CLUB_PUR_IND_OP_1M")
                } else {
                    self.goToPurchaseTAEClubScreen()

                }
                

            }
        } else if promoAppLink == "PP_PACKAGES" {
            self.performSegue(withIdentifier: "buyPackages", sender: self);
        } else if promoAppLink == "PP_LABELS" {
            self.performSegue(withIdentifier: "nutritionPack", sender: self)
        } else if promoAppLink == "-TacvBsX4yDrtgbl6YOQ" {
            if UserDefaults.standard.value(forKey: "PREMIUM_MEMBER") != nil {
                let pkgsArray = UserDefaults.standard.value(forKey: "PREMIUM_PACKAGES") as! NSArray
                if pkgsArray.count == 1 {
                    for dict in pkgsArray {
                        let infoDict = dict as! [String: AnyObject]
                        let pkgID = infoDict["premium_pack_id"] as! String
                        if pkgID == promoAppLink {
                            for dict in self.premiumPackagesArray {
                                let infoDict = dict as! [String: AnyObject]
                                if infoDict["packageId"] as! String == pkgID {
                                    self.performSegue(withIdentifier: "fromAdsToPurchase", sender: infoDict)
                                }
                            }
                        } else {
                            for dict in self.premiumPackagesArray {
                                let infoDict = dict as! [String: AnyObject]
                                if infoDict["packageId"] as! String == promoAppLink {
                                    self.performSegue(withIdentifier: "nutritionPack", sender: infoDict)
                                }
                            }
                            
                        }
                        
                    }
                } else if pkgsArray.count > 1 {
                    if (self.pkgIdsArray.contains(promoAppLink)) {
                        for dict in pkgsArray {
                            let infoDict = dict as! [String: AnyObject]
                            let pkgID = infoDict["premium_pack_id"] as! String
                            if pkgID == promoAppLink {
                                for dict in self.premiumPackagesArray {
                                    let infoDict = dict as! [String: AnyObject]
                                    if infoDict["packageId"] as! String == pkgID {
                                        self.performSegue(withIdentifier: "fromAdsToPurchase", sender: infoDict)
                                    }
                                }
                            }
                            
                        }
                    } else {
                        for dict in self.premiumPackagesArray {
                            let infoDict = dict as! [String: AnyObject]
                            if infoDict["packageId"] as! String == promoAppLink {
                                self.performSegue(withIdentifier: "nutritionPack", sender: infoDict)
                            }
                        }
                    }
                    
                }
                
            } else {
                for dict in self.premiumPackagesArray {
                    let infoDict = dict as! [String: AnyObject]
                    if infoDict["packageId"] as! String == promoAppLink {
                        self.performSegue(withIdentifier: "nutritionPack", sender: infoDict)
                    }
                }
            }
        } else if promoAppLink == "-KyotHu4rPoL3YOsVxUu" {
            if UserDefaults.standard.value(forKey: "PREMIUM_MEMBER") != nil {
                let pkgsArray = UserDefaults.standard.value(forKey: "PREMIUM_PACKAGES") as! NSArray
                if pkgsArray.count == 1 {
                    for dict in pkgsArray {
                        let infoDict = dict as! [String: AnyObject]
                        let pkgID = infoDict["premium_pack_id"] as! String
                        if pkgID == promoAppLink {
                            for dict in self.premiumPackagesArray {
                                let infoDict = dict as! [String: AnyObject]
                                if infoDict["packageId"] as! String == pkgID {
                                    self.performSegue(withIdentifier: "fromAdsToPurchase", sender: infoDict)
                                }
                            }
                        } else {
                            for dict in self.premiumPackagesArray {
                                let infoDict = dict as! [String: AnyObject]
                                if infoDict["packageId"] as! String == promoAppLink {
                                    self.performSegue(withIdentifier: "fromAdsToMore", sender: infoDict)
                                }
                            }
                            
                        }
                        
                    }
                } else if pkgsArray.count > 1 {
                    if (self.pkgIdsArray.contains(promoAppLink)) {
                        for dict in pkgsArray {
                            let infoDict = dict as! [String: AnyObject]
                            let pkgID = infoDict["premium_pack_id"] as! String
                            if pkgID == promoAppLink {
                                for dict in self.premiumPackagesArray {
                                    let infoDict = dict as! [String: AnyObject]
                                    if infoDict["packageId"] as! String == pkgID {
                                        self.performSegue(withIdentifier: "fromAdsToPurchase", sender: infoDict)
                                    }
                                }
                            }
                            
                        }
                    } else {
                        for dict in self.premiumPackagesArray {
                            let infoDict = dict as! [String: AnyObject]
                            if infoDict["packageId"] as! String == promoAppLink {
                                self.performSegue(withIdentifier: "fromAdsToMore", sender: infoDict)
                            }
                        }
                    }
                    
                }
                
            } else {
                for dict in self.premiumPackagesArray {
                    let infoDict = dict as! [String: AnyObject]
                    if infoDict["packageId"] as! String == promoAppLink {
                        self.performSegue(withIdentifier: "fromAdsToMore", sender: infoDict)
                    }
                }
            }
        } else if promoAppLink == "-SquhLfL5nAsrhdq7GCY" {
            if UserDefaults.standard.value(forKey: "PREMIUM_MEMBER") != nil {
                let pkgsArray = UserDefaults.standard.value(forKey: "PREMIUM_PACKAGES") as! NSArray
                if pkgsArray.count == 1 {
                    for dict in pkgsArray {
                        let infoDict = dict as! [String: AnyObject]
                        let pkgID = infoDict["premium_pack_id"] as! String
                        if pkgID == promoAppLink {
                            for dict in self.premiumPackagesArray {
                                let infoDict = dict as! [String: AnyObject]
                                if infoDict["packageId"] as! String == pkgID {
                                    self.performSegue(withIdentifier: "fromAdsToAiDP", sender: infoDict)
                                }
                            }
                        } else {
                            for dict in self.premiumPackagesArray {
                                let infoDict = dict as! [String: AnyObject]
                                if infoDict["packageId"] as! String == promoAppLink {
                                    self.performSegue(withIdentifier: "fromAdsToMore", sender: infoDict)
                                }
                            }
                            
                        }
                        
                    }
                } else if pkgsArray.count > 1 {
                    if (self.pkgIdsArray.contains(promoAppLink)) {
                        for dict in pkgsArray {
                            let infoDict = dict as! [String: AnyObject]
                            let pkgID = infoDict["premium_pack_id"] as! String
                            if pkgID == promoAppLink {
                                for dict in self.premiumPackagesArray {
                                    let infoDict = dict as! [String: AnyObject]
                                    if infoDict["packageId"] as! String == pkgID {
                                        self.performSegue(withIdentifier: "fromAdsToAiDP", sender: infoDict)
                                    }
                                }
                            }
                            
                        }
                    } else {
                        for dict in self.premiumPackagesArray {
                            let infoDict = dict as! [String: AnyObject]
                            if infoDict["packageId"] as! String == promoAppLink {
                                self.performSegue(withIdentifier: "fromAdsToMore", sender: infoDict)
                            }
                        }
                    }
                    
                }
                
            } else {
                for dict in self.premiumPackagesArray {
                    let infoDict = dict as! [String: AnyObject]
                    if infoDict["packageId"] as! String == promoAppLink {
                        self.performSegue(withIdentifier: "fromAdsToMore", sender: infoDict)
                    }
                }
            }
        } else if promoAppLink == "-IndIWj1mSzQ1GDlBpUt" {//IndWLIntusoe3uelxER
            
            
            if UserDefaults.standard.value(forKey: "-IndIWj1mSzQ1GDlBpUt") != nil {
                
                self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
            } else {
                DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view, animated: true);
                }
                self.moveToAnotherView(promoAppLink: promoAppLink)

                
                
            }
            
        }  else if promoAppLink == "-ClubInd4tUPXHgVj9w3" {
            
            
            if UserDefaults.standard.value(forKey: "-ClubInd4tUPXHgVj9w3") != nil {
                
                self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
            } else {
                DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view, animated: true);
                }
                self.moveToAnotherView(promoAppLink: promoAppLink)

                
                
            }
            
        }  else if promoAppLink == "-ClubUsa5nDa1M8WcRA6" {
            
            
            if UserDefaults.standard.value(forKey: "-ClubUsa5nDa1M8WcRA6") != nil {
                
                self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
            } else {
                DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view, animated: true);
                }
                self.moveToAnotherView(promoAppLink: promoAppLink)

                
                
            }
            
        } else if promoAppLink == "-IndWLIntusoe3uelxER" {//IndWLIntusoe3uelxER
                   
                   
                   if UserDefaults.standard.value(forKey: "-IndWLIntusoe3uelxER") != nil {
                       
                       self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
                   } else {
                       DispatchQueue.main.async {
                       MBProgressHUD.showAdded(to: self.view, animated: true);
                       }
                       self.moveToAnotherView(promoAppLink: promoAppLink)

                       
                       
                   }
                   
        } else if promoAppLink == "CHECK_THIS_OUT" {
            self.performSegue(withIdentifier: "checkThisOut", sender: self)
        } else if promoAppLink == "-Qis3atRaproTlpr4zIs" {
            self.performSegue(withIdentifier: "floatingToNutrition", sender: promoAppLink)

        } else if promoAppLink == "-AiDPwdvop1HU7fj8vfL" {
            if UserDefaults.standard.value(forKey: "-AiDPwdvop1HU7fj8vfL") != nil {
                
                self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
            } else {
                DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view, animated: true);
                }
              self.moveToAnotherView(promoAppLink: promoAppLink)
                
            }
        } else if promoAppLink == "-IdnMyAiDPoP9DFGkbas" {
            if UserDefaults.standard.value(forKey: "-IdnMyAiDPoP9DFGkbas") != nil {
                
                self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
            } else {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true);
                }
                self.moveToAnotherView(promoAppLink: promoAppLink)
                
            }
        } else if promoAppLink == "-MalAXk7gLyR3BNMusfi" {
            if UserDefaults.standard.value(forKey: "-MalAXk7gLyR3BNMusfi") != nil {
                
                self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
            } else {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true);
                }
                self.moveToAnotherView(promoAppLink: promoAppLink)
                
            }
        } else if promoAppLink == "-MzqlVh6nXsZ2TCdAbOp" {
            if UserDefaults.standard.value(forKey: "-MzqlVh6nXsZ2TCdAbOp") != nil {
                
                self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
            } else {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true);
                }
                self.moveToAnotherView(promoAppLink: promoAppLink)
                
            }
        } else if promoAppLink == "-SgnMyAiDPuD8WVCipga" {
            if UserDefaults.standard.value(forKey: "-SgnMyAiDPuD8WVCipga") != nil {
                
                self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
            } else {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true);
                }
                self.moveToAnotherView(promoAppLink: promoAppLink)
                
            }
        } else if promoAppLink == "-MysRamadanwgtLoss99" {
                   if UserDefaults.standard.value(forKey: "-MysRamadanwgtLoss99") != nil {
                       
                       self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
                   } else {
                       DispatchQueue.main.async {
                           MBProgressHUD.showAdded(to: self.view, animated: true);
                       }
                       self.moveToAnotherView(promoAppLink: promoAppLink)
                       
                   }
               } else if promoAppLink == self.ptpPackage {
            if UserDefaults.standard.value(forKey:  self.ptpPackage) != nil {
                
                self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
            } else {
            
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true);
                }
                self.moveToAnotherView(promoAppLink: promoAppLink)
                

            }
        }
    }
    
    func goToTAEClub() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
                let vc : TAEClub1VCViewController = storyBoard.instantiateViewController(withIdentifier: "TAEClub1VCViewController") as! TAEClub1VCViewController;
                let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
                navController?.pushViewController(vc, animated: true);
    }
    
    @objc func tappedOnPopUpDone() {
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
                   self.countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
        }
        if self.countryCode == "91" {
            self.ptpPackage = "-IndAiBPtmMrS4VPnwmD"
        } else if self.countryCode == "1" {
            self.ptpPackage = "-UsaAiBPxnaopT55GJxl"
        } else if self.countryCode == "65" {
            self.ptpPackage = "-SgnAiBPJlXfM3KzDWR8"
        } else if self.countryCode == "62" {
            self.ptpPackage = "-IdnAiBPLKMO5ePamQle"
        } else if self.countryCode == "60" {
            self.ptpPackage = "-MysAiBPyaX9TgFT1YOp"
        } else if self.countryCode == "63" {
            self.ptpPackage = "-PhyAiBPcYLiSYlqhjbI"
        }
        var clubPackageSubscribed = ""
        if self.countryCode == "91" {
            clubPackageSubscribed = "-ClubInd3gu7tfwko6Zx"
        } else if self.countryCode == "62" {
            clubPackageSubscribed = "-ClubIdn4hd8flchs9Vy"
        } else if self.countryCode == "1" {
            clubPackageSubscribed = "-ClubUSA4tg6cvdhizQn"
        } else if self.countryCode == "65" {
            clubPackageSubscribed = "-ClubSGNPbeleu8beyKn"
        } else if self.countryCode == "60" {
            clubPackageSubscribed = "-ClubMYSheke8ebdjoWs"
        }
        self.pkgIdsArray = NSMutableArray()
        if UserDefaults.standard.value(forKey: "PREMIUM_MEMBER") != nil {
            if UserDefaults.standard.value(forKey: "PREMIUM_PACKAGES") != nil {
                let pkgsArray = UserDefaults.standard.value(forKey: "PREMIUM_PACKAGES") as! NSArray;
                for pkgID in pkgsArray {
                    let pkgDict = pkgID as! [String: AnyObject];
                    let pkgIDs = pkgDict["premium_pack_id"] as! String;
                    self.pkgIdsArray.add(pkgIDs)
                }
                
                
            }
        }
        let promoAppLink = link //PP_PACKAGES
       
        if promoAppLink == "PP_PACKAGES" {
            self.performSegue(withIdentifier: "buyPackages", sender: self);
        } else if promoAppLink == "TWEAK_WALL" {
            self.goToTweakWall()
        } else if promoAppLink == "RECIPE_WALL" {
            self.goToRecipeWall()
        } else if promoAppLink == "CLUBAIDP_PUR_IND_OP_1M" {
            if UserDefaults.standard.value(forKey: "-ClubInd4tUPXHgVj9w3") != nil {
             self.performSegue(withIdentifier: "myTweakAndEat", sender: "-ClubInd4tUPXHgVj9w3");
                //self.performSegue(withIdentifier: "myTweakAndEat", sender: link);
            } else {
           self.goToBuyScreen(packageID: "-ClubInd4tUPXHgVj9w3", identifier: promoAppLink)
            }
        } else if promoAppLink == "CLUB_PURCHASE" || promoAppLink == "CLUB_PUR_IND_OP_1M" {
            if UserDefaults.standard.value(forKey: "-ClubInd3gu7tfwko6Zx") != nil || UserDefaults.standard.value(forKey: "-ClubIdn4hd8flchs9Vy") != nil {
              self.goToTAEClubMemPage()
            } else {
                if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
                    self.countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
                }
                if self.countryCode == "91" {
                self.goToBuyScreen(packageID: "-ClubInd3gu7tfwko6Zx", identifier: "CLUB_PUR_IND_OP_1M")
                } else {
                    self.goToPurchaseTAEClubScreen()

                }
                

            }
        } else if promoAppLink == "MYTAE_PUR_IND_OP_3M" || promoAppLink == "WLIF_PUR_IND_OP_3M" {
            if promoAppLink == "MYTAE_PUR_IND_OP_3M" {
                if UserDefaults.standard.value(forKey: "-IndIWj1mSzQ1GDlBpUt") != nil {
                 self.performSegue(withIdentifier: "myTweakAndEat", sender: "-IndIWj1mSzQ1GDlBpUt");
                    //self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
                } else {
            self.goToBuyScreen(packageID: "-IndIWj1mSzQ1GDlBpUt", identifier: promoAppLink)
                }
            } else if promoAppLink == "WLIF_PUR_IND_OP_3M" {
                if UserDefaults.standard.value(forKey: "-IndWLIntusoe3uelxER") != nil {
                 self.performSegue(withIdentifier: "myTweakAndEat", sender: "-IndWLIntusoe3uelxER");
                    //self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
                } else {
            self.goToBuyScreen(packageID: "-IndWLIntusoe3uelxER", identifier: promoAppLink)
                }
            }
        } else if promoAppLink == "CLUB_SUBSCRIPTION" || promoAppLink == clubPackageSubscribed {
            //MYTAE_PUR_IND_OP_3M
                      if UserDefaults.standard.value(forKey: clubPackageSubscribed) != nil {
                         self.goToTAEClubMemPage()
                       } else {
                        DispatchQueue.main.async {
                            MBProgressHUD.showAdded(to: self.view, animated: true);
                        }
                        self.moveToAnotherView(promoAppLink: clubPackageSubscribed)                       }
        } else if promoAppLink == "-NcInd5BosUcUeeQ9Q32" {
            
            
            if UserDefaults.standard.value(forKey: promoAppLink) != nil {
                self.goToNutritonConsultantScreen(packageID: promoAppLink)
            } else {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true);
                }
                self.moveToAnotherView(promoAppLink: promoAppLink)

                
                
            }
            
        } else if promoAppLink == "PP_LABELS" {
            self.performSegue(withIdentifier: "nutritionPack", sender: self)
        } else if promoAppLink == "-TacvBsX4yDrtgbl6YOQ" {
            if UserDefaults.standard.value(forKey: "PREMIUM_MEMBER") != nil {
                let pkgsArray = UserDefaults.standard.value(forKey: "PREMIUM_PACKAGES") as! NSArray
                if pkgsArray.count == 1 {
                    for dict in pkgsArray {
                        let infoDict = dict as! [String: AnyObject]
                        let pkgID = infoDict["premium_pack_id"] as! String
                        if pkgID == promoAppLink {
                            for dict in self.premiumPackagesArray {
                                let infoDict = dict as! [String: AnyObject]
                                if infoDict["packageId"] as! String == pkgID {
                                    self.performSegue(withIdentifier: "fromAdsToPurchase", sender: infoDict)
                                }
                            }
                        } else {
                            for dict in self.premiumPackagesArray {
                                let infoDict = dict as! [String: AnyObject]
                                if infoDict["packageId"] as! String == promoAppLink {
                                    self.performSegue(withIdentifier: "nutritionPack", sender: infoDict)
                                }
                            }
                            
                        }
                        
                    }
                } else if pkgsArray.count > 1 {
                    if (self.pkgIdsArray.contains(promoAppLink)) {
                        for dict in pkgsArray {
                            let infoDict = dict as! [String: AnyObject]
                            let pkgID = infoDict["premium_pack_id"] as! String
                            if pkgID == promoAppLink {
                                for dict in self.premiumPackagesArray {
                                    let infoDict = dict as! [String: AnyObject]
                                    if infoDict["packageId"] as! String == pkgID {
                                        self.performSegue(withIdentifier: "fromAdsToPurchase", sender: infoDict)
                                    }
                                }
                            }
                            
                        }
                    } else {
                        for dict in self.premiumPackagesArray {
                            let infoDict = dict as! [String: AnyObject]
                            if infoDict["packageId"] as! String == promoAppLink {
                                self.performSegue(withIdentifier: "nutritionPack", sender: infoDict)
                            }
                        }
                    }
                    
                }
                
            } else {
                for dict in self.premiumPackagesArray {
                    let infoDict = dict as! [String: AnyObject]
                    if infoDict["packageId"] as! String == promoAppLink {
                        self.performSegue(withIdentifier: "nutritionPack", sender: infoDict)
                    }
                }
            }
        } else if promoAppLink == "-KyotHu4rPoL3YOsVxUu" {
            if UserDefaults.standard.value(forKey: "PREMIUM_MEMBER") != nil {
                let pkgsArray = UserDefaults.standard.value(forKey: "PREMIUM_PACKAGES") as! NSArray
                if pkgsArray.count == 1 {
                    for dict in pkgsArray {
                        let infoDict = dict as! [String: AnyObject]
                        let pkgID = infoDict["premium_pack_id"] as! String
                        if pkgID == promoAppLink {
                            for dict in self.premiumPackagesArray {
                                let infoDict = dict as! [String: AnyObject]
                                if infoDict["packageId"] as! String == pkgID {
                                    self.performSegue(withIdentifier: "fromAdsToPurchase", sender: infoDict)
                                }
                            }
                        } else {
                            for dict in self.premiumPackagesArray {
                                let infoDict = dict as! [String: AnyObject]
                                if infoDict["packageId"] as! String == promoAppLink {
                                    self.performSegue(withIdentifier: "fromAdsToMore", sender: infoDict)
                                }
                            }
                            
                        }
                        
                    }
                } else if pkgsArray.count > 1 {
                    if (self.pkgIdsArray.contains(promoAppLink)) {
                        for dict in pkgsArray {
                            let infoDict = dict as! [String: AnyObject]
                            let pkgID = infoDict["premium_pack_id"] as! String
                            if pkgID == promoAppLink {
                                for dict in self.premiumPackagesArray {
                                    let infoDict = dict as! [String: AnyObject]
                                    if infoDict["packageId"] as! String == pkgID {
                                        self.performSegue(withIdentifier: "fromAdsToPurchase", sender: infoDict)
                                    }
                                }
                            }
                            
                        }
                    } else {
                        for dict in self.premiumPackagesArray {
                            let infoDict = dict as! [String: AnyObject]
                            if infoDict["packageId"] as! String == promoAppLink {
                                self.performSegue(withIdentifier: "fromAdsToMore", sender: infoDict)
                            }
                        }
                    }
                    
                }
                
            } else {
                for dict in self.premiumPackagesArray {
                    let infoDict = dict as! [String: AnyObject]
                    if infoDict["packageId"] as! String == promoAppLink {
                        self.performSegue(withIdentifier: "fromAdsToMore", sender: infoDict)
                    }
                }
            }
        } else if promoAppLink == "-SquhLfL5nAsrhdq7GCY" {
            if UserDefaults.standard.value(forKey: "PREMIUM_MEMBER") != nil {
                let pkgsArray = UserDefaults.standard.value(forKey: "PREMIUM_PACKAGES") as! NSArray
                if pkgsArray.count == 1 {
                    for dict in pkgsArray {
                        let infoDict = dict as! [String: AnyObject]
                        let pkgID = infoDict["premium_pack_id"] as! String
                        if pkgID == promoAppLink {
                            for dict in self.premiumPackagesArray {
                                let infoDict = dict as! [String: AnyObject]
                                if infoDict["packageId"] as! String == pkgID {
                                    self.performSegue(withIdentifier: "fromAdsToAiDP", sender: infoDict)
                                }
                            }
                        } else {
                            for dict in self.premiumPackagesArray {
                                let infoDict = dict as! [String: AnyObject]
                                if infoDict["packageId"] as! String == promoAppLink {
                                    self.performSegue(withIdentifier: "fromAdsToMore", sender: infoDict)
                                }
                            }
                            
                        }
                        
                    }
                } else if pkgsArray.count > 1 {
                    if (self.pkgIdsArray.contains(promoAppLink)) {
                        for dict in pkgsArray {
                            let infoDict = dict as! [String: AnyObject]
                            let pkgID = infoDict["premium_pack_id"] as! String
                            if pkgID == promoAppLink {
                                for dict in self.premiumPackagesArray {
                                    let infoDict = dict as! [String: AnyObject]
                                    if infoDict["packageId"] as! String == pkgID {
                                        self.performSegue(withIdentifier: "fromAdsToAiDP", sender: infoDict)
                                    }
                                }
                            }
                            
                        }
                    } else {
                        for dict in self.premiumPackagesArray {
                            let infoDict = dict as! [String: AnyObject]
                            if infoDict["packageId"] as! String == promoAppLink {
                                self.performSegue(withIdentifier: "fromAdsToMore", sender: infoDict)
                            }
                        }
                    }
                    
                }
                
            } else {
                for dict in self.premiumPackagesArray {
                    let infoDict = dict as! [String: AnyObject]
                    if infoDict["packageId"] as! String == promoAppLink {
                        self.performSegue(withIdentifier: "fromAdsToMore", sender: infoDict)
                    }
                }
            }
        } else if promoAppLink == "-IndIWj1mSzQ1GDlBpUt" {//IndWLIntusoe3uelxER
            
            
            if UserDefaults.standard.value(forKey: "-IndIWj1mSzQ1GDlBpUt") != nil {
                
                self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
            } else {
                DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view, animated: true);
                }
                self.moveToAnotherView(promoAppLink: promoAppLink)

                
                
            }
            
        }  else if promoAppLink == "-ClubInd4tUPXHgVj9w3" {
            
            
            if UserDefaults.standard.value(forKey: "-ClubInd4tUPXHgVj9w3") != nil {
                
                self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
            } else {
                DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view, animated: true);
                }
                self.moveToAnotherView(promoAppLink: promoAppLink)

                
                
            }
            
        }  else if promoAppLink == "-ClubUsa5nDa1M8WcRA6" {
            
            
            if UserDefaults.standard.value(forKey: "-ClubUsa5nDa1M8WcRA6") != nil {
                
                self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
            } else {
                DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view, animated: true);
                }
                self.moveToAnotherView(promoAppLink: promoAppLink)

                
                
            }
            
        } else if promoAppLink == "-IndWLIntusoe3uelxER" {//IndWLIntusoe3uelxER
                   
                   
                   if UserDefaults.standard.value(forKey: "-IndWLIntusoe3uelxER") != nil {
                       
                       self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
                   } else {
                       DispatchQueue.main.async {
                       MBProgressHUD.showAdded(to: self.view, animated: true);
                       }
                       self.moveToAnotherView(promoAppLink: promoAppLink)

                       
                       
                   }
                   
        } else if promoAppLink == "CHECK_THIS_OUT" {
            self.performSegue(withIdentifier: "checkThisOut", sender: self)
        } else if promoAppLink == "-Qis3atRaproTlpr4zIs" {
            self.performSegue(withIdentifier: "floatingToNutrition", sender: promoAppLink)

        } else if promoAppLink == "-AiDPwdvop1HU7fj8vfL" {
            if UserDefaults.standard.value(forKey: "-AiDPwdvop1HU7fj8vfL") != nil {
                
                self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
            } else {
                DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view, animated: true);
                }
              self.moveToAnotherView(promoAppLink: promoAppLink)
                
            }
        } else if promoAppLink == "-IdnMyAiDPoP9DFGkbas" {
            if UserDefaults.standard.value(forKey: "-IdnMyAiDPoP9DFGkbas") != nil {
                
                self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
            } else {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true);
                }
                self.moveToAnotherView(promoAppLink: promoAppLink)
                
            }
        } else if promoAppLink == "-MalAXk7gLyR3BNMusfi" {
            if UserDefaults.standard.value(forKey: "-MalAXk7gLyR3BNMusfi") != nil {
                
                self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
            } else {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true);
                }
                self.moveToAnotherView(promoAppLink: promoAppLink)
                
            }
        } else if promoAppLink == "-MzqlVh6nXsZ2TCdAbOp" {
            if UserDefaults.standard.value(forKey: "-MzqlVh6nXsZ2TCdAbOp") != nil {
                
                self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
            } else {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true);
                }
                self.moveToAnotherView(promoAppLink: promoAppLink)
                
            }
        } else if promoAppLink == "-SgnMyAiDPuD8WVCipga" {
            if UserDefaults.standard.value(forKey: "-SgnMyAiDPuD8WVCipga") != nil {
                
                self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
            } else {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true);
                }
                self.moveToAnotherView(promoAppLink: promoAppLink)
                
            }
        } else if promoAppLink == "-MysRamadanwgtLoss99" {
                   if UserDefaults.standard.value(forKey: "-MysRamadanwgtLoss99") != nil {
                       
                       self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
                   } else {
                       DispatchQueue.main.async {
                           MBProgressHUD.showAdded(to: self.view, animated: true);
                       }
                       self.moveToAnotherView(promoAppLink: promoAppLink)
                       
                   }
               } else if promoAppLink == self.ptpPackage {
            if UserDefaults.standard.value(forKey:  self.ptpPackage) != nil {
                
                self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
            } else {
            
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true);
                }
                self.moveToAnotherView(promoAppLink: promoAppLink)
                

            }
        }
    }
    
    func goToHomePage() {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
            let clickViewController = storyBoard.instantiateViewController(withIdentifier: "homeViewController") as? WelcomeViewController;
         self.navigationController?.pushViewController(clickViewController!, animated: true)
           
        }//
    
    func goToRecipeWall() {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
            let clickViewController = storyBoard.instantiateViewController(withIdentifier: "TweakRecipeViewController") as? TweakRecipeViewController;
         self.navigationController?.pushViewController(clickViewController!, animated: true)
           
        }
    func goToTweakWall() {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
            let clickViewController = storyBoard.instantiateViewController(withIdentifier: "MyWallViewController") as? MyWallViewController;
         self.navigationController?.pushViewController(clickViewController!, animated: true)
           
        }
 
 
    func moveToAnotherView(promoAppLink: String) {
        var packageObj = [String : AnyObject]();
        var cCode = ""
        var dbReference = Database.database().reference().child("PremiumPackageDetailsiOS")
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
            cCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
            if cCode == "91" || cCode == "1" {
                dbReference = Database.database().reference().child("PremiumPackageDetails").child("Packs")
            }
              }
        dbReference.observe(DataEventType.value, with: { (snapshot) in
            self.premiumPackagesArray = NSMutableArray()
            // this runs on the background queue
            // here the query starts to add new 10 rows of data to arrays
            if snapshot.childrenCount > 0 {
                
                let dispatch_group = DispatchGroup();
                dispatch_group.enter();
                for premiumPackages in snapshot.children.allObjects as! [DataSnapshot] {
                    if premiumPackages.key == promoAppLink {
                        packageObj = premiumPackages.value as! [String : AnyObject]
                        
                    }
                    
                }
                
                dispatch_group.leave();
                
                dispatch_group.notify(queue: DispatchQueue.main) {
                    MBProgressHUD.hide(for: self.view, animated: true);
                    if packageObj.count == 0 {
                        //self.goToHomePage()
                        return
                    }
                    self.performSegue(withIdentifier: "fromAdsToMore", sender: packageObj)
                }
            }
        })
    }
    
    func daysBetweenDates(startDate: Date, endDate: Date) -> Int
    {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        print(components.day!)
        return components.day!
    }
    
    func getBottomImageView() {
        Database.database().reference().child("GlobalVariables").child("homeBottomBanner").observe(DataEventType.value, with: { (snapshot) in
            if snapshot.childrenCount > 0 {
                var imageUrl = ""
                let dispatch_group = DispatchGroup();
                dispatch_group.enter();
                
                    let packageObj = snapshot.value as AnyObject;
                    if !((packageObj[self.countryCode] as AnyObject) is NSNull) {
                        
                            if (packageObj as! [String: AnyObject]).index(forKey: self.countryCode) != nil {
                                let countryCodeDict = packageObj[self.countryCode] as AnyObject as! [String: AnyObject]
                            if countryCodeDict["isActive"] as AnyObject as! Bool == true {
                                self.links = countryCodeDict["link"] as AnyObject as! String
                                imageUrl = countryCodeDict["img"] as AnyObject as! String
                                
                            }
                            
                        }
                    }
                
                dispatch_group.leave()
                dispatch_group.notify(queue: DispatchQueue.main) {
                    if imageUrl != "" {
                        let url = URL(string: imageUrl);
                        self.adsImageView.sd_setImage(with: url);
                        self.adsImageView.isHidden = false
                        self.adsImageView.isUserInteractionEnabled = true
                        self.tweakBubbleImageView.isHidden = true
                        self.tweakReactView.isHidden = true
                    } else {
                        self.adsImageView.isHidden = true
                        self.tweakBubbleImageView.isHidden = false
                        self.tweakReactView.isHidden = false
                    }
                }
            }

        })
    }
    
    @objc func tappedOnAdsImageView() {
        
        if  let url = URL(string: self.links) {
            UIApplication.shared.open(url)
        }
        
//        self.pkgIdsArray = NSMutableArray()
//        if UserDefaults.standard.value(forKey: "PREMIUM_MEMBER") != nil {
//            if UserDefaults.standard.value(forKey: "PREMIUM_PACKAGES") != nil {
//                let pkgsArray = UserDefaults.standard.value(forKey: "PREMIUM_PACKAGES") as! NSArray;
//                for pkgID in pkgsArray {
//                    let pkgDict = pkgID as! [String: AnyObject];
//                    let pkgIDs = pkgDict["premium_pack_id"] as! String;
//                    self.pkgIdsArray.add(pkgIDs)
//                }
//
//
//            }
//        }
//        print(self.getPromoResponse)
//        let promoImgUrl = self.getPromoResponse["promoImgUrl"] as! String
//        let promoAppLink = self.getPromoResponse["promoAppLink"] as! String
//        if promoAppLink == "PP_LABELS" {
//            self.performSegue(withIdentifier: "nutritionPack", sender: self)
//        } else if promoAppLink == "-TacvBsX4yDrtgbl6YOQ" {
//            if UserDefaults.standard.value(forKey: "PREMIUM_MEMBER") != nil {
//                let pkgsArray = UserDefaults.standard.value(forKey: "PREMIUM_PACKAGES") as! NSArray
//                if pkgsArray.count == 1 {
//                    for dict in pkgsArray {
//                        let infoDict = dict as! [String: AnyObject]
//                        let pkgID = infoDict["premium_pack_id"] as! String
//                        if pkgID == promoAppLink {
//                            for dict in self.premiumPackagesArray {
//                                let infoDict = dict as! [String: AnyObject]
//                                if infoDict["packageId"] as! String == pkgID {
//                                    self.performSegue(withIdentifier: "fromAdsToPurchase", sender: infoDict)
//                                }
//                            }
//                        } else {
//                            for dict in self.premiumPackagesArray {
//                                let infoDict = dict as! [String: AnyObject]
//                                if infoDict["packageId"] as! String == promoAppLink {
//                                    self.performSegue(withIdentifier: "nutritionPack", sender: infoDict)
//                                }
//                            }
//
//                        }
//
//                    }
//                } else if pkgsArray.count > 1 {
//                    if (self.pkgIdsArray.contains(promoAppLink)) {
//                        for dict in pkgsArray {
//                            let infoDict = dict as! [String: AnyObject]
//                            let pkgID = infoDict["premium_pack_id"] as! String
//                            if pkgID == promoAppLink {
//                                for dict in self.premiumPackagesArray {
//                                    let infoDict = dict as! [String: AnyObject]
//                                    if infoDict["packageId"] as! String == pkgID {
//                                        self.performSegue(withIdentifier: "fromAdsToPurchase", sender: infoDict)
//                                    }
//                                }
//                            }
//
//                        }
//                    } else {
//                        for dict in self.premiumPackagesArray {
//                            let infoDict = dict as! [String: AnyObject]
//                            if infoDict["packageId"] as! String == promoAppLink {
//                                self.performSegue(withIdentifier: "nutritionPack", sender: infoDict)
//                            }
//                        }
//                    }
//
//                }
//
//            } else {
//                for dict in self.premiumPackagesArray {
//                    let infoDict = dict as! [String: AnyObject]
//                    if infoDict["packageId"] as! String == promoAppLink {
//                        self.performSegue(withIdentifier: "nutritionPack", sender: infoDict)
//                    }
//                }
//            }
//        } else if promoAppLink == "-KyotHu4rPoL3YOsVxUu" {
//            if UserDefaults.standard.value(forKey: "PREMIUM_MEMBER") != nil {
//                let pkgsArray = UserDefaults.standard.value(forKey: "PREMIUM_PACKAGES") as! NSArray
//                if pkgsArray.count == 1 {
//                    for dict in pkgsArray {
//                        let infoDict = dict as! [String: AnyObject]
//                        let pkgID = infoDict["premium_pack_id"] as! String
//                        if pkgID == promoAppLink {
//                            for dict in self.premiumPackagesArray {
//                                let infoDict = dict as! [String: AnyObject]
//                                if infoDict["packageId"] as! String == pkgID {
//                                    self.performSegue(withIdentifier: "fromAdsToPurchase", sender: infoDict)
//                                }
//                            }
//                        } else {
//                            for dict in self.premiumPackagesArray {
//                                let infoDict = dict as! [String: AnyObject]
//                                if infoDict["packageId"] as! String == promoAppLink {
//                                    self.performSegue(withIdentifier: "fromAdsToMore", sender: infoDict)
//                                }
//                            }
//
//                        }
//
//                    }
//                } else if pkgsArray.count > 1 {
//                    if (self.pkgIdsArray.contains(promoAppLink)) {
//                        for dict in pkgsArray {
//                            let infoDict = dict as! [String: AnyObject]
//                            let pkgID = infoDict["premium_pack_id"] as! String
//                            if pkgID == promoAppLink {
//                                for dict in self.premiumPackagesArray {
//                                    let infoDict = dict as! [String: AnyObject]
//                                    if infoDict["packageId"] as! String == pkgID {
//                                        self.performSegue(withIdentifier: "fromAdsToPurchase", sender: infoDict)
//                                    }
//                                }
//                            }
//
//                        }
//                    } else {
//                        for dict in self.premiumPackagesArray {
//                            let infoDict = dict as! [String: AnyObject]
//                            if infoDict["packageId"] as! String == promoAppLink {
//                                self.performSegue(withIdentifier: "fromAdsToMore", sender: infoDict)
//                            }
//                        }
//                    }
//
//                }
//
//            } else {
//                for dict in self.premiumPackagesArray {
//                    let infoDict = dict as! [String: AnyObject]
//                    if infoDict["packageId"] as! String == promoAppLink {
//                        self.performSegue(withIdentifier: "fromAdsToMore", sender: infoDict)
//                    }
//                }
//            }
//        } else if promoAppLink == "-SquhLfL5nAsrhdq7GCY" {
//            if UserDefaults.standard.value(forKey: "PREMIUM_MEMBER") != nil {
//                let pkgsArray = UserDefaults.standard.value(forKey: "PREMIUM_PACKAGES") as! NSArray
//                if pkgsArray.count == 1 {
//                    for dict in pkgsArray {
//                        let infoDict = dict as! [String: AnyObject]
//                        let pkgID = infoDict["premium_pack_id"] as! String
//                        if pkgID == promoAppLink {
//                            for dict in self.premiumPackagesArray {
//                                let infoDict = dict as! [String: AnyObject]
//                                if infoDict["packageId"] as! String == pkgID {
//                                    self.performSegue(withIdentifier: "fromAdsToAiDP", sender: infoDict)
//                                }
//                            }
//                        } else {
//                            for dict in self.premiumPackagesArray {
//                                let infoDict = dict as! [String: AnyObject]
//                                if infoDict["packageId"] as! String == promoAppLink {
//                                    self.performSegue(withIdentifier: "fromAdsToMore", sender: infoDict)
//                                }
//                            }
//
//                        }
//
//                    }
//                } else if pkgsArray.count > 1 {
//                    if (self.pkgIdsArray.contains(promoAppLink)) {
//                        for dict in pkgsArray {
//                            let infoDict = dict as! [String: AnyObject]
//                            let pkgID = infoDict["premium_pack_id"] as! String
//                            if pkgID == promoAppLink {
//                                for dict in self.premiumPackagesArray {
//                                    let infoDict = dict as! [String: AnyObject]
//                                    if infoDict["packageId"] as! String == pkgID {
//                                        self.performSegue(withIdentifier: "fromAdsToAiDP", sender: infoDict)
//                                    }
//                                }
//                            }
//
//                        }
//                    } else {
//                        for dict in self.premiumPackagesArray {
//                            let infoDict = dict as! [String: AnyObject]
//                            if infoDict["packageId"] as! String == promoAppLink {
//                                self.performSegue(withIdentifier: "fromAdsToMore", sender: infoDict)
//                            }
//                        }
//                    }
//
//                }
//
//            } else {
//                for dict in self.premiumPackagesArray {
//                    let infoDict = dict as! [String: AnyObject]
//                    if infoDict["packageId"] as! String == promoAppLink {
//                        self.performSegue(withIdentifier: "fromAdsToMore", sender: infoDict)
//                    }
//                }
//            }
//        } else if promoAppLink == "-IndIWj1mSzQ1GDlBpUt" {
//
//
//            if self.userSubscribedTAE == 1 {
//
//                self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
//            } else {
//                var packageObj = [String : AnyObject]();
//                MBProgressHUD.showAdded(to: self.view, animated: true);
//                Database.database().reference().child("PremiumPackageDetailsiOS").observe(DataEventType.value, with: { (snapshot) in
//                    self.premiumPackagesArray = NSMutableArray()
//                    // this runs on the background queue
//                    // here the query starts to add new 10 rows of data to arrays
//                    if snapshot.childrenCount > 0 {
//
//                        let dispatch_group = DispatchGroup();
//                        dispatch_group.enter();
//                        for premiumPackages in snapshot.children.allObjects as! [DataSnapshot] {
//                            if premiumPackages.key == promoAppLink {
//                                packageObj = premiumPackages.value as! [String : AnyObject]
//
//                            }
//
//                        }
//
//                        dispatch_group.leave();
//
//                        dispatch_group.notify(queue: DispatchQueue.main) {
//                            MBProgressHUD.hide(for: self.view, animated: true);
//                            self.performSegue(withIdentifier: "moreInfo", sender: packageObj)
//
//
//                        }
//                    }
//                })
//
//
//            }
//
//        } else if promoAppLink == "-AiDPwdvop1HU7fj8vfL" {
//            if self.userIndMyAidpSub == 1 {
//
//                self.performSegue(withIdentifier: "myTweakAndEat", sender: promoAppLink);
//            } else {
//                var packageObj = [String : AnyObject]();
//                MBProgressHUD.showAdded(to: self.view, animated: true);
//                Database.database().reference().child("PremiumPackageDetailsiOS").observe(DataEventType.value, with: { (snapshot) in
//                    self.premiumPackagesArray = NSMutableArray()
//                    // this runs on the background queue
//                    // here the query starts to add new 10 rows of data to arrays
//                    if snapshot.childrenCount > 0 {
//
//                        let dispatch_group = DispatchGroup();
//                        dispatch_group.enter();
//                        for premiumPackages in snapshot.children.allObjects as! [DataSnapshot] {
//                            if premiumPackages.key == promoAppLink {
//                                packageObj = premiumPackages.value as! [String : AnyObject]
//
//                            }
//
//                        }
//
//                        dispatch_group.leave();
//
//                        dispatch_group.notify(queue: DispatchQueue.main) {
//                            MBProgressHUD.hide(for: self.view, animated: true);
//                            self.performSegue(withIdentifier: "moreInfo", sender: packageObj)
//
//
//                        }
//                    }
//                })
//
//
//            }
//        }
//
//
    }
    
    //    func checkUserPremiumMember() {
    //
    //        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
    //            countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
    //                if self.countryCode == "91" {
    //                self.getFirebaseData()
    //            }
    //
    //        }
    //
    //    }
    
    func getDefaultIconsView() {
         DispatchQueue.main.async {
        self.myNutritionButton.setImage(UIImage.init(named: "analytics"), for: .normal)
        self.nutritionLabelsButton.setImage(UIImage.init(named: "labels"), for: .normal)
        self.nutritionLbl1.text = "Nutrition Labels"
        self.myNutritionLbl1.text = "My Nutrition"
        self.nutritionLabelsButton.isHidden = false
        self.nutritionLbl1.isHidden = false
        self.premiumMember.isHidden = false
        self.myEdrBtn.frame = CGRect(13, 0, 45, 45)
        self.myEdrLbl1.frame = CGRect(-1, 41, 73, 40)
        self.recipeWallBtn.frame = CGRect(250, 0, 45, 45)
        self.recipeWallLbl1.frame = CGRect(225, 43, 95, 35)
        }
    }
    
    @objc func moveToActivity() {
        self.performSegue(withIdentifier: "activity", sender: self)
    }
    
    @objc func getISOCountryCode() {
        
        APIWrapper.sharedInstance.getAllOtherCountryCodes({ (responceDic : AnyObject!) -> (Void) in
            if(TweakAndEatUtils.isValidResponse(responceDic as? [String:AnyObject])) {
                let response : [String:AnyObject] = responceDic as! [String:AnyObject]
                
                if(response[TweakAndEatConstants.CALL_STATUS] as! String == TweakAndEatConstants.TWEAK_STATUS_GOOD) {
                    
                    let dispatch_group = DispatchGroup()
                    dispatch_group.enter()
                    for dict in response[TweakAndEatConstants.DATA] as AnyObject as! NSArray {
                        let dictionary = dict as! NSDictionary
                        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
                            if "\(dictionary["ctr_phonecode"] as AnyObject)"  == "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)" {
                                let isoCountryCode: String = "\(dictionary["ctr_iso"] as AnyObject)"
                                UserDefaults.standard.setValue(isoCountryCode, forKey: "COUNTRY_ISO")
                                UserDefaults.standard.synchronize()
                                
                            }
                        }
                        
                        //                        if (dictionary["ctr_active"] as AnyObject) as! Bool == true {
                        //
                        //                        }
                    }
                    
                    dispatch_group.leave();
                    dispatch_group.notify(queue: DispatchQueue.main) {
                        // self.allCountryArray = response[TweakAndEatConstants.DATA] as AnyObject as! NSArray
                        
                    }
                }
            } else {
                //error
                print("error")
                // TweakAndEatUtils.AlertView.showAlert(view: self, message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil))
            }
        }) { (error : NSError!) -> (Void) in
            //error
            print("error")
            TweakAndEatUtils.hideMBProgressHUD()
            // TweakAndEatUtils.AlertView.showAlert(view: self, message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil))
            
        }
    }
    func setUpInfoBarButton() {
        
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
        countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
                if countryCode == "91" {

                } else {
                    self.infoIconBarButton.isEnabled = false
                    self.infoIconBarButton.tintColor = .white
            }
        }

//        let infoBarButton = UIBarButtonItem(image: UIImage(named: "info-icon"), style: .plain, target: self, action: #selector(self.infoIconClick))
//        self.navigationItem.rightBarButtonItem  = infoBarButton
    }
    
    func setupSiaButton() {
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
    countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
            if countryCode == "91" {
                self.askSiaButton.isHidden = true
            } else {
                self.askSiaButton.isHidden = true
            }
}
    }
    
    func calculateBMI(massInKilograms mass: Double, heightInCentimeters height: Double) -> Double {
        return mass / ((height * height) / 10000)
    }
    
    override func viewWillAppear(_ animated: Bool)  {
        super.viewWillAppear(true)
        if UserDefaults.standard.value(forKey: "userSession") != nil {
            //UserDefaults.standard.removeObject(forKey: "ct_profile_updated")
            let dictionary = Bundle.main.infoDictionary!
            let version = dictionary["CFBundleShortVersionString"] as! String
        if UserDefaults.standard.value(forKey: "ct_profile_updated") == nil {

            let ct = CleverTapClass()
            ct.updateCleverTapWithProp(isUpdateProfile: true)
            UserDefaults.standard.setValue("YES", forKey: "ct_profile_updated")
            UserDefaults.standard.synchronize()
        }
        CleverTap.sharedInstance()?.recordEvent("Home_viewed")
        }
        self.navigationController?.isNavigationBarHidden = true;
        if UserDefaults.standard.value(forKey: "userSession") != nil {
            self.getAdDetails()
        }
//        if  self.containerViewBottomConstraint.constant == 110 {
//            self.goneUp = true
//        }
       // getTrends()
//        DispatchQueue.main.sync {
         //  dummyNavigation()
//
//        }
        
       // UIApplication.shared.addObserver(self, forKeyPath: "applicationIconBadgeNumber", options: .new, context: nil)
        UserDefaults.standard.set("WELCOME_VIEW", forKey: "SWAP_SWITCH_VIEW")
        UserDefaults.standard.synchronize()
        if UserDefaults.standard.value(forKey: "MEAN_CALORIES") != nil {
              let approxCal = UserDefaults.standard.value(forKey: "MEAN_CALORIES") as AnyObject as! Int
              DispatchQueue.main.async {
                  self.minCalCountLabel.text = "\(approxCal <= 0 ? 0: approxCal)";
              }
          }
          if UserDefaults.standard.value(forKey: "FLOATING_BUTTONS_ARRAY") != nil {
              self.floatingButtonsArray = UserDefaults.standard.value(forKey: "FLOATING_BUTTONS_ARRAY") as! [[String : AnyObject]]
          }
//        self.dummyPopUp()
//               self.link = "CALS_LEFT_FS_POPUP"
      //  print(UserDefaults.standard.value(forKey: "NOTIFICATIONWHENAPPKILLED"))
       // self.getNutritionistFBID()
//self.navigationController?.isNavigationBarHidden = true;
      //  NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GET_RECIPES_AND_TWEAKS"), object: nil);
      //  self.draggableView.translatesAutoresizingMaskIntoConstraints = false
//self.draggableContainerView.layoutIfNeeded()
       // self.swipeDownDraggingView()
       UIView.setAnimationsEnabled(true)
        let dictionary = Bundle.main.infoDictionary!;
        let version = dictionary["CFBundleShortVersionString"] as! String;
        
       self.setUpInfoBarButton()

                if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
            countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
                    if countryCode == "91" {
                        self.askSiaButton.isHidden = true
                    } else {
                        self.askSiaButton.isHidden = true
                    }
        }
       
      setUpPhilippinesView()
        if UserDefaults.standard.value(forKey: "COUNTRY_ISO") == nil {
            self.getISOCountryCode()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(WelcomeViewController.homeInfoApiCalls), name: NSNotification.Name(rawValue: "PTP-IN-APP-SUCCESSFUL"),
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(WelcomeViewController.homeInfoApiCalls), name: NSNotification.Name(rawValue: "TAECLUB-IN-APP-SUCCESSFUL"),
                                                      object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(WelcomeViewController.homeInfoApiCalls), name: NSNotification.Name(rawValue: "PREMIUM_PACK_IN-APP-SUCCESSFUL"),
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(WelcomeViewController.homeInfoApiCalls), name: NSNotification.Name(rawValue: "NUTRITION_LABELS_PURHASE_SUCCESSFUL"),
                                               object: nil)


        let refreshedToken = InstanceID.instanceID().token()
        print(refreshedToken)
        //self.menuButtonsView.isHidden = true
        if UserDefaults.standard.value(forKey: "GOALS") == nil {
            APIWrapper.sharedInstance.getGoals({(responceDic : AnyObject!) -> (Void) in
                if(TweakAndEatUtils.isValidResponse(responceDic as? [String:AnyObject])) {
                    let response : [String:AnyObject] = responceDic as! [String:AnyObject]
                    
                    if(response[TweakAndEatConstants.CALL_STATUS] as! String == TweakAndEatConstants.TWEAK_STATUS_GOOD) {
                        let goals = response[TweakAndEatConstants.DATA] as! [[String : AnyObject]]
                        
                        if goals.count > 0 {
                            
                            UserDefaults.standard.set(goals, forKey: "GOALS")
                        }
                    }
                }
            }) { (error : NSError!) -> (Void) in
                //error
                print("error")
                
                //                let alert : UIAlertView = UIAlertView(title:self.bundle.localizedString(forKey: "no_internet", value: nil, table: nil), message:self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil), delegate: nil, cancelButtonTitle: self.bundle.localizedString(forKey: "ok", value: nil, table: nil));
                // alert.show();
            }
        }
//        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
//            self.countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
//            DispatchQueue.main.async {
//
//
//                if (self.countryCode == "62" || self.countryCode == "65") {
//                    self.tweakBubbleImageView.isHidden = false
//                    self.tweakReactView.isHidden = false
//                    self.adsImageView.isHidden = true
//                    self.premiumMember.isHidden = true
//                    self.iconsView.isHidden = false
//                    //self.premiumIconBarButton.isEnabled = false
//                    self.menuButtonsView.isHidden = true
//
//                    } else if (self.countryCode == "1" || self.countryCode == "60" || self.countryCode == "65" || self.countryCode == "62" ) {
//                    self.tweakBubbleImageView.isHidden = false
//                    self.tweakReactView.isHidden = false
//                    self.adsImageView.isHidden = true
//                    //self.premiumMember.isHidden = false
//                    self.premiumMember.isUserInteractionEnabled = true
//                    //self.premiumIconBarButton.isEnabled = false
//                    self.iconsView.isHidden = true
//                    //self.menuButtonsView.isHidden = false
//
//
//                } else if self.countryCode == "91" {
//                    self.tweakBubbleImageView.isHidden = false
//                    self.tweakReactView.isHidden = false
//                    self.iconsView.isHidden = false
//                    self.menuButtonsView.isHidden = true
//                    self.adsImageView.isHidden = true
//                    //self.premiumMember.isHidden = false
//                    if let currentUserID = Auth.auth().currentUser?.uid {
//                        self.getPremiumBtn()
//                    }
//                } else {
//                    self.tweakBubbleImageView.isHidden = false
//                    self.tweakReactView.isHidden = false
//                    self.adsImageView.isHidden = true
//                    self.premiumMember.isHidden = true
//                    //self.premiumMember.isUserInteractionEnabled = false
//                    //self.premiumIconBarButton.isEnabled = false
//                    self.iconsView.isHidden = true
//                    self.menuButtonsView.isHidden = false
//                }
//            }
//        }
        UserDefaults.standard.removeObject(forKey: "PREMIUM_MEMBER")
        UserDefaults.standard.removeObject(forKey: "PREMIUM_PACKAGES")
        //UserDefaults.standard.removeObject(forKey: "remoteNotification")
        
        print("remoteNotification")
      //  print(UserDefaults.standard.value(forKey: "remoteNotification"))
//        if UserDefaults.standard.value(forKey: "APS") == nil {
//            let userInfo = UserDefaults.standard.value(forKey: "APS") as? [String:AnyObject]
//            var msg = "Hi {USERNAME},<br><br>This is Sam, Senior Nutritionist from Tweak &amp; Eat. I see your profile and ‘My AiDP’ (Artificial Intelligence Based Diet Plans) service is a perfect fit for you i.e. Healthy Eating &amp; Weight Loss while managing your Hypo &amp; Hyper Thyroidism, and low Blood Pressure. The AiDP Plan will also include specific diet to improve fertility. You will see amazing, positive change!<br><br>Please click on ‘Premium Services’ button on the Tweak &amp; Eat App page, and subscribe to<b> My AiDP</b>. Sign up today! It’s super-affordable and <b>IT’S ON SALE!</b> So Hurry!<br><br>Hi {USERNAME},<br><br>This is Sam, Senior Nutritionist from Tweak &amp; Eat. I see your profile and ‘My AiDP’ (Artificial Intelligence Based Diet Plans) service is a perfect fit for you i.e. Healthy Eating &amp; Weight Loss while managing your Hypo &amp; Hyper Thyroidism, and low Blood Pressure. The AiDP Plan will also include specific diet to improve fertility. You will see amazing, positive change!<br><br>Please click on ‘Premium Services’ button on the Tweak &amp; Eat App page, and subscribe to<b> My AiDP</b>. Sign up today! It’s super-affordable and <b>IT’S ON SALE!</b> So Hurry!<br><br>"
//            var imgUrlString = "https://tweakandeatpremiumpacks.s3.ap-south-1.amazonaws.com/my_tae_en_pps_02.png"
////            if userInfo!.index(forKey: "aps") != nil {
////                //  let apsInfo = userInfo!["aps"] as AnyObject as! NSDictionary
////                let message = userInfo!["msg"] as! String
////                msg = message
////
////                imgUrlString = userInfo!["img"] as! String
////
////            }
//            let obj = ["msg": msg, "imgUrlString":imgUrlString, "link": "-AiDPwdvop1HU7fj8vfL"] as [String: AnyObject]
//            if obj.index(forKey: "msg") != nil {
//                let message = obj["msg"] as! String
//                msg = message.html2String
//                imgUrlString = obj["imgUrlString"] as! String
//            }
//             link = obj["link"] as! String
//            self.popUpView.removeFromSuperview()
//            self.popUpView = UIView(frame: CGRect(x: (self.view.frame.origin.x), y: 0, width: (self.view.frame.width), height: (self.view.frame.height)))
//            self.view.addSubview(self.popUpView);
//            self.popUpView .backgroundColor = UIColor.black
//            self.insidePopUpView = UIView(frame: CGRect(x: 30, y: 50, width: (self.view.frame.width) - 60, height: (self.popUpView.frame.height - 100)))
//            self.insidePopUpView .backgroundColor = UIColor.white
//            self.insidePopUpView .layer.cornerRadius = 10
//            self.popUpView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
//
//            let imgView = UIImageView()
//            imgView.frame =  CGRect(x: 10, y: 10, width: self.insidePopUpView .frame.width - 20, height: 160)
//           // imgView.contentMode = .scaleAspectFit
//             imgView.clipsToBounds = true
//            imgView.layer.masksToBounds = true
//            imgView.sd_setImage(with: URL.init(string: imgUrlString))
//            let label = UITextView()
//            label.frame = CGRect(x: 10, y: imgView.frame.maxY, width: self.insidePopUpView .frame.width - 20, height: self.insidePopUpView.frame.height - 46 - 160 - 10)
//            label.isEditable = false
//            label.isSelectable = false
//            label.font = UIFont.systemFont(ofSize: 17)
//            label.textColor = UIColor.black
//            label.text = msg
//
//            let button = UIButton()
//            button.frame = CGRect(x: 0, y: self.insidePopUpView.frame.height - 46, width: self.insidePopUpView .frame.width, height: 46)
//            button.backgroundColor = UIColor.purple
//            button.setTitle("DONE", for: .normal)
//            button.addTarget(self, action: #selector(WelcomeViewController.pressed(sender:)), for: .touchUpInside)
//            self.insidePopUpView.addSubview(button)
//            self.insidePopUpView.addSubview(imgView)
//            self.insidePopUpView.addSubview(label)
//            self.insidePopUpView.removeFromSuperview()
//            self.popUpView.addSubview(self.insidePopUpView)
//            UserDefaults.standard.removeObject(forKey: "APS")
//        }
        self.view.isUserInteractionEnabled = true
     
        DispatchQueue.main.async {
            //self.roundImageView.image = UIImage.init(named: "defaultRecipe.jpg")
        }
        
        let dictionary1 = Bundle.main.infoDictionary!;
        let version1 = dictionary["CFBundleShortVersionString"] as! String;
        
        if version1 == "6.2" {
            if UserDefaults.standard.string(forKey: "userSession") != nil{
                let msisdn = UserDefaults.standard.value(forKey: "msisdn") as! String;
                
                print(msisdn.prefix(3))
                if msisdn.prefix(1) == "1" {
                    UserDefaults.standard.setValue("1", forKey: "COUNTRY_CODE");
                    UserDefaults.standard.setValue("USA", forKey: "COUNTRY_NAME")
                    
                } else if msisdn.prefix(2) == "91" {
                    UserDefaults.standard.setValue("91", forKey: "COUNTRY_CODE");
                    UserDefaults.standard.setValue("INDIA", forKey: "COUNTRY_NAME")
                    
                    
                }  else if msisdn.prefix(2) == "65" {
                    UserDefaults.standard.setValue("65", forKey: "COUNTRY_CODE");
                    UserDefaults.standard.setValue("SINGAPORE", forKey: "COUNTRY_NAME")
                    
                    
                }   else if msisdn.prefix(2) == "62" {
                    UserDefaults.standard.setValue("62", forKey: "COUNTRY_CODE");
                    UserDefaults.standard.setValue("INDONESIA", forKey: "COUNTRY_NAME")
                    
                }
//                if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
//                    let  countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
//
//                    if countryCode == "91"{
//                        self.getNutritionistFBID()
//                    }
//                }
                
            }
        }

        self.navigationItem.hidesBackButton = true
        let userdefaults = UserDefaults.standard
        if userdefaults.string(forKey: "USERBLOCKED") != nil{
            
            print("Here you will get saved value")
            UserDefaults.standard.removeObject(forKey: "USERBLOCKED")
            UserDefaults.standard.removeObject(forKey: "userSession")
            UserDefaults.standard.removeObject(forKey: "showRegistration")
            self.deleteAllData(entity: "TBL_Tweaks")
            self.deleteAllData(entity: "TBL_Contacts")
            self.deleteAllData(entity: "TBL_Reminders")
            self.alert()
            self.del()
            self.registrationProcess()
            
            return
        } else {
            print("No value in Userdefault,Either you can save value here or perform other operation")
            userdefaults.set("Here you can save value", forKey: "key")
        }
        
        if UserDefaults.standard.value(forKey: "userSession") as? String != nil {
            
            homeInfoApiCalls()
            checkActivePackages()
            
            self.checkAppVersion()
            self.getUserCallSchedueDetails()
        }
        
        if(comingFromSettings == true){
            UIView.animate(withDuration: 1.0) {
                self.tabBarController?.tabBar.isHidden = false;
            }
            comingFromSettings = false;
        }
    }
    
    func checkActivePackages() {
        APIWrapper.sharedInstance.postRequestWithHeaders(TweakAndEatURLConstants.GET_ACTIVE_PACKAGE, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, success: { response in
            var responseDic : [String:AnyObject] = response as! [String:AnyObject];
            print(responseDic)
            if responseDic["callStatus"] as! String == "GOOD" {
            if responseDic.index(forKey: "data") != nil {
                    let dataDict  = responseDic["data"] as! [String: AnyObject]
                if dataDict.count == 0 {
                   // CleverTap.sharedInstance()?.profilePush(["Subscription Status": 0])

                } else {
                var expdttmsArray = [String]()
                var pkgIdsArray = [String]()
                    if UserDefaults.standard.object(forKey: "ACTIVE_PACKAGES") == nil {
                        let ct = CleverTapClass()
                        var profile = Dictionary<String, AnyObject>()
                        expdttmsArray = dataDict["expDttms"] as! [String]
                        pkgIdsArray = dataDict["pkgIds"] as! [String]
                        profile["Subscription Package Ids"] = pkgIdsArray as AnyObject
                        profile["Expiry Dates"] = expdttmsArray as AnyObject
                        UserDefaults.standard.setValue(dataDict, forKey: "ACTIVE_PACKAGES")
                        
                        
                        if expdttmsArray.count == 0 {
                            CleverTap.sharedInstance()?.profilePush(["Subscription Status": 0])
                            profile["Subscription Package Ids"] = "-" as AnyObject
                            profile["Expiry Dates"] = "-" as AnyObject
                            ct.sendUserProfile(profile: profile)
                        } else {
                            CleverTap.sharedInstance()?.profilePush(["Subscription Status": 1])
                            ct.sendUserProfile(profile: profile)
                        }
                        

                    } else {
                        expdttmsArray = dataDict["expDttms"] as! [String]
                        pkgIdsArray = dataDict["pkgIds"] as! [String]
                        let savedActivePackageDict = UserDefaults.standard.object(forKey: "ACTIVE_PACKAGES")  as! [String: AnyObject]
                        let expdttmsArrayFromDef = savedActivePackageDict["expDttms"] as! [String]
                        let pkgIdsArrayFromDef = savedActivePackageDict["pkgIds"] as! [String]
                        
                        //if expdttmsArray.count != expdttmsArrayFromDef.count {
                            var profile = Dictionary<String, AnyObject>()
                            expdttmsArray = dataDict["expDttms"] as! [String]
                            pkgIdsArray = dataDict["pkgIds"] as! [String]
                            profile["Subscription Package Ids"] = pkgIdsArray as AnyObject
                            profile["Expiry Dates"] = expdttmsArray as AnyObject
                            UserDefaults.standard.setValue(dataDict, forKey: "ACTIVE_PACKAGES")
                        UserDefaults.standard.synchronize()
                            let ct = CleverTapClass()
                            if expdttmsArray.count
                                == 0 {
                                CleverTap.sharedInstance()?.profilePush(["Subscription Status": 0])
                                profile["Subscription Package Ids"] = "-" as AnyObject
                                profile["Expiry Dates"] = "-" as AnyObject
                                ct.sendUserProfile(profile: profile)


                            } else {
                                CleverTap.sharedInstance()?.profilePush(["Subscription Status": 1])
                                ct.sendUserProfile(profile: profile)

                            }
                        //}
                        
//                        if pkgIdsArray.count != pkgIdsArrayFromDef.count {
//                            var profile = Dictionary<String, AnyObject>()
//                            expdttmsArray = dataDict["expDttms"] as! [String]
//                            pkgIdsArray = dataDict["pkgIds"] as! [String]
//                            profile["Subscription Package Ids"] = pkgIdsArray as AnyObject
//                            profile["Expiry Dates"] = expdttmsArray as AnyObject
//                            UserDefaults.standard.setValue(dataDict, forKey: "ACTIVE_PACKAGES")
//                            let ct = CleverTapClass()
//                            ct.sendUserProfile(profile: profile)
//                            if expdttmsArray.count
//                                == 0 {
//                                CleverTap.sharedInstance()?.profilePush(["Subscription Status": 0])
//
//                            } else {
//                                CleverTap.sharedInstance()?.profilePush(["Subscription Status": 1])
//                            }
//                        }

                        
                    }
            }
                }
            }
            
            
    },
        failure : { error in
            
            //            let alertController = UIAlertController(title: self.bundle.localizedString(forKey: "no_internet", value: nil, table: nil), message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil), preferredStyle: UIAlertController.Style.alert)
            //
            //            let defaultAction = UIAlertAction(title:  self.bundle.localizedString(forKey: "ok", value: nil, table: nil), style: .cancel, handler: nil)
            //            alertController.addAction(defaultAction)
            //            self.present(alertController, animated: true, completion: nil)
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true);
                }
        })
    }
    
    @objc func alert() {
        self.registrationProcess()
    }
    
    @objc func scheduleNotification(hour : String, min : String, title:String, body: String) {
        
        if #available(iOS 10.0, *) {
            let content = UNMutableNotificationContent.init();
            content.title = title;
            content.body = body;
            content.categoryIdentifier = self.categoryId + hour + min;
            content.sound = UNNotificationSound(named: convertToUNNotificationSoundName("birds018.wav"));
            var dateInfo = DateComponents();
            dateInfo.hour = Int(hour);
            dateInfo.minute = Int(min);
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: true);
            let request = UNNotificationRequest.init(identifier: self.requestId  + hour + min, content: content, trigger: trigger);
            
            schedule(request: request);
            
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc @available(iOS 10.0, *)
    internal func schedule(request: UNNotificationRequest!) {
        UNUserNotificationCenter.current().add(request) { (error: Error?) in
            if error != nil {
            }
        }
    }
    
    @objc func addReminders() {
        
        APIWrapper.sharedInstance.getReminders(type: TBL_ReminderConstants.REMINDER_TYPE_TWEAK, { (responseDic : AnyObject!) -> (Void) in
            if(TweakAndEatUtils.isValidResponse(responseDic as? [String:AnyObject])) {
                
                let reminders =  [
                    [
                        "rmdr_id": 1,
                        "rmdr_type": 1,
                        "rmdr_name": "Breakfast Tweak Reminder",
                        "rmdr_time": "08:00",
                        "rmdr_status": "N"
                    ] ,
                    [
                        "rmdr_id": 2,
                        "rmdr_type": 1,
                        "rmdr_name": "Lunch Tweak Reminder",
                        "rmdr_time": "13:00",
                        "rmdr_status": "Y"
                    ],
                    [
                        "rmdr_id": 3,
                        "rmdr_type": 1,
                        "rmdr_name": "Dinner Tweak Reminder",
                        "rmdr_time": "20:00",
                        "rmdr_status": "Y"
                    ]
                ]
                
                if(reminders.count > 0) {
                    for reminderObj in reminders {
                        
                        DataManager.sharedInstance.saveReminders(reminder: reminderObj as [String : AnyObject]);
                        let time = reminderObj["rmdr_time"] as AnyObject;
                        let rmdrName = reminderObj["rmdr_name"] as AnyObject;
                        var rmdrBody = "";
                        
                        if rmdrName as! String == "Breakfast Tweak Reminder"{
                            rmdrBody = " Good Morning! We’re ready to Tweak your Breakfast (7:30AM to 10AM). Don’t forget to take a photo using the Tweak & Eat App before you eat! Thank you.";
                        } else if rmdrName as! String == "Lunch Tweak Reminder"{
                            rmdrBody = " Good Afternoon! We’re ready to Tweak your Lunch (12:30PM to 3PM). Don’t forget to take a photo using the Tweak & Eat App before you eat! Thank you.";
                            let timeArray = time.components(separatedBy: ":");
                            Notifications.schedule(hour: timeArray[0], min: timeArray[1], title: "Tweak & Eat Reminder" , body: reminderObj["rmdr_name"] as! String + rmdrBody)
                        } else if rmdrName as! String == "Dinner Tweak Reminder"{
                            rmdrBody = " Good Evening! We’re ready to Tweak your Dinner (7:30PM to 10PM). Don’t forget to take a photo using the Tweak & Eat App before you eat! Thank you.";
                            let timeArray = time.components(separatedBy: ":");
                            Notifications.schedule(hour: timeArray[0], min: timeArray[1], title: "Tweak & Eat Reminder" , body: reminderObj["rmdr_name"] as! String + rmdrBody)
                            
                        }
                    }
                }
            }
        }) { (error : NSError!) -> (Void) in
            print("Error in reminders");
            ////self.premiumIconBarButton.isEnabled = true;
            let alertController = UIAlertController(title: self.bundle.localizedString(forKey: "no_internet", value: nil, table: nil), message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil), preferredStyle: UIAlertController.Style.alert)
            
            let defaultAction = UIAlertAction(title:  self.bundle.localizedString(forKey: "ok", value: nil, table: nil), style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
        
    }
    
    @objc func firebaseTopicNames() {
        APIWrapper.sharedInstance.postRequestWithHeaders(TweakAndEatURLConstants.FIREBASE_TOPIC_NAME, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, success: { response in
            let responseDic : [String:AnyObject] = response as! [String:AnyObject];
            let responseResult = responseDic["callStatus"] as! String
            if  responseResult == "GOOD" {
                print("Sucess")
                if responseDic.index(forKey: "topics") != nil {
                    self.firebaseTopicNamesArray = responseDic["topics"] as AnyObject  as! NSArray
                    UserDefaults.standard.setValue(self.firebaseTopicNamesArray, forKey: "SUBSCRIBE_TOPIC")
                    if Messaging.messaging().fcmToken != nil {
                        for topic in self.firebaseTopicNamesArray {
                            Messaging.messaging().subscribe(toTopic: topic as! String)
                        }
                    }
                }
            } else{
                
            }
        }, failure : { error in
            
            let alertController = UIAlertController(title: self.bundle.localizedString(forKey: "no_internet", value: nil, table: nil), message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil), preferredStyle: UIAlertController.Style.alert)
            
            let defaultAction = UIAlertAction(title:  self.bundle.localizedString(forKey: "ok", value: nil, table: nil), style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        })
        
    }
    

    
    
    @objc func randomTitbitMessage(clickable: Bool){
        
        APIWrapper.sharedInstance.getRandomTitBitMessage({(responceDic : AnyObject!) -> (Void) in
            if(TweakAndEatUtils.isValidResponse(responceDic as? [String:AnyObject])) {
                let response : [String:AnyObject] = responceDic as! [String:AnyObject]
                let responseMessage = response["message"] as! String
                if(response[TweakAndEatConstants.CALL_STATUS] as! String == TweakAndEatConstants.TWEAK_STATUS_GOOD) {
                    if clickable == true {
                        self.cloudTapped = UITapGestureRecognizer(target: self, action: #selector(self.tappedOnCloudBubbleImage))
                        self.cloudTapped.numberOfTapsRequired = 1
                        self.cloudBubbleImage.isUserInteractionEnabled = true;
                        self.cloudBubbleImage?.addGestureRecognizer(self.cloudTapped)
                    } else {
                        self.cloudBubbleImage.removeGestureRecognizer(self.cloudTapped)
                    }
                    self.randomMessages.stopBlink()
                    if UserDefaults.standard.value(forKey: "PREMIUM_MEMBER") != nil {
                        self.randomMessages.stopBlink()
                    } else {
                        self.randomMessages.startBlink()
                        
                    }
                    self.randomMessages.text = responseMessage
                }
            } else {
                
                print("error")
                
            }
        }) { (error : NSError!) -> (Void) in
            //error
            print("error")
            //self.premiumIconBarButton.isEnabled = true;
//            let alertController = UIAlertController(title: self.bundle.localizedString(forKey: "no_internet", value: nil, table: nil), message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil), preferredStyle: UIAlertController.Style.alert)
//
//            let defaultAction = UIAlertAction(title:  self.bundle.localizedString(forKey: "ok", value: nil, table: nil), style: .cancel, handler: nil)
//            alertController.addAction(defaultAction)
//            self.present(alertController, animated: true, completion: nil)
            
        }
    }
    
    @objc func getActivitesFromHealthKit(selectedDate: String, qtyType:HKQuantityTypeIdentifier,completion: @escaping (_ stepRetrieved: Double) -> Void) {
        
        let type = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier(rawValue: qtyType.rawValue)) // The type of data we are requesting
        
        let calendar = NSCalendar.current
        let interval = NSDateComponents()
        interval.day = 1
        var anchorComponents = calendar.dateComponents(
            [ .year, .month, .day ],
            from: Date()
        )
        
        anchorComponents.hour = 0
        let anchorDate = calendar.date(from: anchorComponents)
        
        let stepsQuery = HKStatisticsCollectionQuery(quantityType: type!, quantitySamplePredicate: nil, options: .cumulativeSum, anchorDate: anchorDate!, intervalComponents: interval as DateComponents)
        stepsQuery.initialResultsHandler = {query, results, error in
            var resultCount = 0.0
            let endDate = self.formatter.date(from: selectedDate)
            if let myResults = results{
                if let sum = myResults.statistics(for: endDate!)?.sumQuantity() {
                    if qtyType == .stepCount {
                        resultCount = sum.doubleValue(for: HKUnit.count())
                        
                    } else if qtyType == .flightsClimbed {
                        resultCount = sum.doubleValue(for: HKUnit.count())
                        
                    } else if qtyType == .distanceWalkingRunning {
                        resultCount = sum.doubleValue(for: HKUnit.meter()) /
                        1000
                        
                    } else if qtyType == .activeEnergyBurned {
                        resultCount = sum.doubleValue(for: HKUnit.kilocalorie())
                    } else if qtyType == .appleExerciseTime {
                        resultCount = sum.doubleValue(for: HKUnit.minute())
                    }
                    
                }
                completion(resultCount)
                
            } else {
                // mostly not executed
                completion(resultCount)
            }
        }
        healthStore?.execute(stepsQuery)
    }
    
    @objc func getHealthActivitiesData() {
        
        DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view, animated: true);
                }
        
        let stepsCount = HKQuantityType.quantityType(
            forIdentifier: HKQuantityTypeIdentifier.stepCount)
        
        let flightsCount = HKQuantityType.quantityType(
            forIdentifier: HKQuantityTypeIdentifier.flightsClimbed)
        let distanceCount = HKQuantityType.quantityType(
            forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)
        let caloriesCount = HKQuantityType.quantityType(
            forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)
        let activeMinsCount = HKQuantityType.quantityType(
            forIdentifier: HKQuantityTypeIdentifier.appleExerciseTime)
        
        let typestoRead = NSSet(objects: stepsCount!, flightsCount!, distanceCount!, caloriesCount!, activeMinsCount!)
        self.healthStore?.requestAuthorization(toShare: nil, read: typestoRead as? Set<HKObjectType>, completion: { (success, error) in
            if success {
                print("SUCCESS")
                
                let dispatch_group1 = DispatchGroup()
                dispatch_group1.enter()
                let last7Days = Date.getDates(forLastNDays: 7)
                //var dict = [String:AnyObject]()
                
                for dates in last7Days {
                    var dict = [String:AnyObject]()
                    
                    self.getActivitesFromHealthKit(selectedDate: dates, qtyType: .stepCount, completion: {value in
                        print(" Steps: \(value)")
                        
                        dict["date"] = dates as AnyObject
                        dict["steps"] = "\(value.cleanValue)" as AnyObject
                        dict["deviceType"] = 2 as AnyObject
                        self.stepsDictionary[dates] = dict as AnyObject
                        
                    })
                }
                for dates in last7Days {
                    var dict = [String:AnyObject]()
                    
                    self.getActivitesFromHealthKit(selectedDate: dates, qtyType: .flightsClimbed, completion: {value in
                        print(" Steps: \(value)")
                        
                        dict["date"] = dates as AnyObject
                        dict["floors"] = "\(value.cleanValue)" as AnyObject
                        dict["deviceType"] = 2 as AnyObject
                        self.floorsDictionary[dates] = dict as AnyObject
                        //print(self.activitiesDictionary)
                    })
                }
                for dates in last7Days {
                    var dict = [String:AnyObject]()
                    
                    self.getActivitesFromHealthKit(selectedDate: dates, qtyType: .distanceWalkingRunning, completion: {val in
                        print(" Steps: \(val)")
                        let str = "\(val)"
                        dict["date"] = dates as AnyObject
                        if(str.contains("0.")) {
                            let doubleStr = String(format: "%.2f", val)
                            dict["distance"] = doubleStr as AnyObject
                            
                        } else {
                            dict["distance"] = "\(Double(val).rounded(toPlaces: 2))" as AnyObject
                            
                        }
                        dict["deviceType"] = 2 as AnyObject
                        self.distanceDictionary[dates] = dict as AnyObject
                        
                    })
                    
                }
                for dates in last7Days {
                    var dict = [String:AnyObject]()
                    
                    self.getActivitesFromHealthKit(selectedDate: dates, qtyType: .activeEnergyBurned, completion: {val in
                        print(" Steps: \(val)")
                        dict["date"] = dates as AnyObject
                        dict["deviceType"] = 2 as AnyObject
                        dict["calories"] = "\(val.cleanValue)" as AnyObject
                        self.caloriesDictionary[dates] = dict as AnyObject
                        
                    })
                }
                for dates in last7Days {
                    var dict = [String:AnyObject]()
                    
                    self.getActivitesFromHealthKit(selectedDate: dates, qtyType: .appleExerciseTime, completion: {val in
                        print(" Steps: \(val)")
                        dict["deviceType"] = 2 as AnyObject
                        dict["activeMins"] = "\(val.cleanValue)" as AnyObject as AnyObject
                        self.activeMinsDictionary[dates] = dict as AnyObject
                        
                    })
                }
                
                dispatch_group1.leave()
                dispatch_group1.notify(queue: DispatchQueue.main) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        MBProgressHUD.hide(for: self.view, animated: true);
                        
                        // change 2 to desired number of seconds
                        // Your code with delay
                        UserDefaults.standard.set("YES", forKey: "HEALTHKIT")
                        if self.stepsDictionary.count > 0 && self.distanceDictionary.count > 0 && self.floorsDictionary.count > 0 && self.activeMinsDictionary.count > 0 && self.caloriesDictionary.count > 0 {
                            //self.performSegue(withIdentifier: "activityTracker", sender: self)
                            let last7Days = Date.getDates(forLastNDays: 7)
                            let dispatch_group = DispatchGroup()
                            dispatch_group.enter()
                            for dates in last7Days {
                                //if !(last7Days.contains(dates)) {
                                
                                
                                let paramsDictionary = ["date": dates,
                                                        "steps":  self.stepsDictionary.index(forKey: dates) != nil ?"\((self.stepsDictionary[dates]!["steps"] as AnyObject).integerValue as Int)": 0 as Any,
                                    "floors": self.floorsDictionary.index(forKey: dates) != nil ? "\((self.floorsDictionary[dates]!["floors"] as AnyObject).integerValue as Int)": 0 as Any,
                                    "distance": self.distanceDictionary.index(forKey: dates) != nil ? "\((self.distanceDictionary[dates]!["distance"] as AnyObject).doubleValue as Double)": 0.0 as Any,
                                    "activeMins": "0",
                                    "calories": "0",
                                    "deviceType": "2"]
                                self.sendHealthkitData(dateString: dates, dict: paramsDictionary as NSDictionary)
                                // self.sendFitBitData(dateString: dates, fitBitDictionary: paramsDictionary as NSDictionary)
                                //}
                            }
                            dispatch_group.leave()
                            dispatch_group.notify(queue: DispatchQueue.main) {
                                MBProgressHUD.hide(for: self.view, animated: true);
                                UserDefaults.standard.set(last7Days as Any as! [String], forKey: "LAST7DAYS")
                            }
                        }
                        
                    }
                    
                }
            }
            else {
                MBProgressHUD.hide(for: self.view, animated: true);
            }
            
        })
    }
    
    @objc func sendHealthkitData(dateString: String, dict: NSDictionary) {
        APIWrapper.sharedInstance.postRequestWithHeaderMethod(TweakAndEatURLConstants.UPDATE_FITNESS_DATA, userSession: UserDefaults.standard.value(forKey: "userSession") as! String,parameters: dict as! [String : AnyObject] , success: { response in
            print(response)
            MBProgressHUD.hide(for: self.view, animated: true);
            let responseDic : [String:AnyObject] = response as! [String:AnyObject];
            let responseResult = responseDic["callStatus"] as! String
            if  responseResult == "GOOD" {
                MBProgressHUD.hide(for: self.view, animated: true);
            }
        }, failure : { error in
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true);
                }
            
            print("failure")
            //check_internet_connection
            TweakAndEatUtils.AlertView.showAlert(view: self, message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil))
            
        })
    }
    
    @objc func getAllCountryCodes() {
        
        DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view, animated: true);
                }
        
        APIWrapper.sharedInstance.getAllCountryCodes({ (responceDic : AnyObject!) -> (Void) in
            if(TweakAndEatUtils.isValidResponse(responceDic as? [String:AnyObject])) {
                let response : [String:AnyObject] = responceDic as! [String:AnyObject]
                
                if(response[TweakAndEatConstants.CALL_STATUS] as! String == TweakAndEatConstants.TWEAK_STATUS_GOOD) {
                    DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true);
                }
                    
                    
                    let dispatch_group = DispatchGroup()
                    dispatch_group.enter()
                    for dict in response[TweakAndEatConstants.DATA] as AnyObject as! NSArray {
                        let dictionary = dict as! NSDictionary
                        if (dictionary["ctr_active"] as AnyObject) as! Bool == true {
                            self.allCountryArray.add(dictionary)
                        }
                    }
                    
                    
                    dispatch_group.leave();
                    dispatch_group.notify(queue: DispatchQueue.main) {
                        print( self.allCountryArray)
                        self.tweakOTPView.countryCodeBtn.isUserInteractionEnabled = true;
                        if self.allCountryArray.count > 0 {
                            let countryDict = self.allCountryArray[0] as! NSDictionary
                            UserDefaults.standard.setValue(countryDict["ctr_name"] as AnyObject, forKey: "COUNTRY_NAME")
                            self.tweakOTPView.countryCode = "+" +  "\(countryDict["ctr_phonecode"] as AnyObject as! NSNumber as! Int)"
                            self.tweakOTPView.countryCodeTextField.text = "+" + "\(countryDict["ctr_phonecode"] as AnyObject as! NSNumber as! Int)"
                            if countryDict["ctr_phonecode"] as AnyObject as! NSNumber as! Int == 1 {
                                
                                self.getWeightInLbs()
                            } else {
                                self.weightFieldArray = [String]()
                                
                                for i in 20...350 {
                                    let str1 = String(i)
                                    let str2 = "kgs"
                                    let str3 = "\(str1) \(str2)"
                                    self.weightFieldArray.append(str3)
                                    
                                }
                            }
                            UserDefaults.standard.setValue("\(countryDict["ctr_phonecode"] as AnyObject as! NSNumber as! Int)", forKey: "COUNTRY_CODE")
                            self.tweakOTPView.ctrPhoneMax = (countryDict["ctr_phone_max"] as AnyObject as? Int)!
                            self.tweakOTPView.ctrPhoneMin = (countryDict["ctr_phone_min"] as AnyObject as? Int)!
                            print(self.tweakOTPView.ctrPhoneMax)
                            print(self.tweakOTPView.ctrPhoneMin)
                            let imageUrl = countryDict["ctr_flag_url"] as AnyObject as? String
                            self.tweakOTPView.flagImage.sd_setImage(with: URL(string: imageUrl!));
                            
                        }
                        
                        self.tweakOTPView.countryCodePickerView.reloadAllComponents()
                    }
                    
                }
            } else {
                //error
                DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true);
                }
                print("error")
                TweakAndEatUtils.hideMBProgressHUD()
                TweakAndEatUtils.AlertView.showAlert(view: self, message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil))
            }
        }) { (error : NSError!) -> (Void) in
            //error
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true);
                }
            
            print("error")
            TweakAndEatUtils.hideMBProgressHUD()
            
            let alertController = UIAlertController(title: "", message:  self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil), preferredStyle: UIAlertController.Style.alert)
            
            let okAction = UIAlertAction(title: self.bundle.localizedString(forKey: "retry", value: nil, table: nil)
            , style: UIAlertAction.Style.default) {
                UIAlertAction in
                let networkInfo = CTTelephonyNetworkInfo();
                let carrier = networkInfo.subscriberCellularProvider;
                let countryCode = carrier?.isoCountryCode?.uppercased();
                
                if(countryCode == nil) {
                    self.tweakOTPView.flagImage.isHidden = false
                    self.tweakOTPView.countryCodeTextField.isHidden = false
                    self.tweakOTPView.countryCodesParentView.isHidden = false
                    self.tweakOTPView.countryCodeTextField.delegate = self
                    self.tweakOTPView.countryCodePickerView.delegate = self
                    self.tweakOTPView.countryCodePickerView.dataSource = self
                    self.getAllCountryCodes()
                    
                    //                    let locale = Locale.current
                    //                    print(locale.regionCode!)
                    //                    if locale.regionCode! == "US" {
                    //                        self.tweakOTPView.countryCodesParentView.isHidden = true
                    //
                    //                        self.tweakOTPView.countryCodeLabel.text = "+1" ;
                    //                        UserDefaults.standard.setValue("1", forKey: "COUNTRY_CODE")
                    //                        self.getCountryIsd(country: "US")
                    //                    } else {
                    //                        self.getAllCountryCodes()
                    //                    }
                    
                } else {
                    self.tweakOTPView.countryCodesParentView.isHidden = true
                    
                    let country = carrier?.isoCountryCode
                    self.tweakOTPView.countryCodeLabel.text = "+\(self.getCountryPhonceCode(countryCode!))" ;
                    UserDefaults.standard.setValue(self.getCountryPhonceCode(countryCode!), forKey: "COUNTRY_CODE")
                    self.getCountryIsd(country: country!)
                }
                
            }
            alertController.addAction(okAction)
            
            // Present the controller
            self.present(alertController, animated: true, completion: nil)
            
        }
    }
    
    @objc func tappedOnStartTweakingView() {
//        if self.tapToTweakView.isHidden == false {
            self.checkTweakable()
      //  }
    }
    
    func removeBarButtonItem() {
        //self.navigationItem.rightBarButtonItems
    }
    
    func removePTPExpiryView() {
        DispatchQueue.main.async {
            self.navigationBarButtonItemTimer.tintColor = UIColor.white
            self.navigationBarButtonItemTimer.isEnabled = false
           // self.navigationBarTimerViewButton.setImage(UIImage.init(named: "\(7 - noDays)"), for: .normal)
            self.navigationBarTimerViewButton.isHidden = true
            
            self.trialPeriodExpiryView.isUserInteractionEnabled = false
//            if self.tweaksArray.count == 0 {
//                self.startTweakingView.isHidden = false
//                self.startTweakingLabel.alpha = 1.0
//                self.startTweakingView.alpha = 0.7
//            }
            //self.startTweakingView.alpha = 0.7
            self.trialPeriodExpiryView.isHidden = true

        }
    }
    
    func removePTPExpiryView(noDays: Int) {
        DispatchQueue.main.async {
            self.navigationBarButtonItemTimer.tintColor = UIColor.purple
            self.navigationBarButtonItemTimer.isEnabled = true
            self.navigationBarTimerViewButton.setImage(UIImage.init(named: "\(7 - noDays)"), for: .normal)
            self.navigationBarTimerViewButton.isHidden = false
            self.trialPeriodExpiryView.isUserInteractionEnabled = false

            if noDays == 7 {
              self.showTrialPeriodView()

            } else {
            self.trialPeriodExpiryView.isHidden = true
            }
        }
    }
    
    @objc func getCountryIsd(country: String) {
        
        APIWrapper.sharedInstance.getCountryCodes(country: country, { (responceDic : AnyObject!) -> (Void) in
            
            if(TweakAndEatUtils.isValidResponse(responceDic as? [String:AnyObject])) {
                let response : [String:AnyObject] = responceDic as! [String:AnyObject]
                
                if(response[TweakAndEatConstants.CALL_STATUS] as! String == TweakAndEatConstants.TWEAK_STATUS_GOOD) {
                    //                    let country : [AnyObject]? = response[TweakAndEatConstants.DATA] as? [AnyObject]
                    self.countryArray = response[TweakAndEatConstants.DATA] as AnyObject as! NSArray
                    self.tweakOTPView.countryCodeBtn.isUserInteractionEnabled = false
                    if self.countryArray.count > 0{
                        let countryDict = self.countryArray[0] as! NSDictionary
                        UserDefaults.standard.setValue(countryDict["ctr_name"] as AnyObject, forKey: "COUNTRY_NAME")
                        self.tweakOTPView.flagImage.isHidden = false
                        self.tweakOTPView.countryCodeTextField.text = "+" +  "\(countryDict["ctr_phonecode"] as AnyObject as! NSNumber as! Int)";
                        UserDefaults.standard.setValue("\(countryDict["ctr_phonecode"] as AnyObject as! NSNumber as! Int)", forKey: "COUNTRY_CODE");
                        if countryDict["ctr_phonecode"] as AnyObject as! NSNumber as! Int == 1 {
                            
                            self.getWeightInLbs()
                        } else {
                            self.weightFieldArray = [String]()
                            
                            for i in 20...350 {
                                let str1 = String(i)
                                let str2 = "kgs"
                                let str3 = "\(str1) \(str2)"
                                self.weightFieldArray.append(str3)
                                
                            }
                        }
                        self.tweakOTPView.countryCode = "+" +  "\(countryDict["ctr_phonecode"] as AnyObject as! NSNumber as! Int)"
                        let imageUrl = countryDict["ctr_flag_url"] as AnyObject as? String
                        self.tweakOTPView.ctrPhoneMax = (countryDict["ctr_phone_max"] as AnyObject as? Int)!
                        self.tweakOTPView.ctrPhoneMin = (countryDict["ctr_phone_min"] as AnyObject as? Int)!
                        print(self.tweakOTPView.ctrPhoneMax)
                        print(self.tweakOTPView.ctrPhoneMin)
                        self.tweakOTPView.flagImage.sd_setImage(with: URL(string: imageUrl!));
                    }
                    
                }
            } else {
                //error
                print("error")
                TweakAndEatUtils.hideMBProgressHUD()
                TweakAndEatUtils.AlertView.showAlert(view: self, message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil))
            }
        }) { (error : NSError!) -> (Void) in
            TweakAndEatUtils.hideMBProgressHUD();
            TweakAndEatUtils.AlertView.showAlert(view: self, message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil))
            //error
        }
    }
    
    func showTrialPeriodView() {
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
            self.countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
        }
//        if self.countryCode == "91" {
//            self.getClubHome2()
//        } else {
        CleverTap.sharedInstance()?.recordEvent("Freetrial_finished")
        DispatchQueue.main.async {
            self.navigationBarButtonItemTimer.tintColor = UIColor.white
            self.navigationBarButtonItemTimer.isEnabled = false
            self.navigationBarTimerViewButton.isHidden = true
            self.trialPeriodExpiryView.isHidden = false
            self.trialPeriodExpiryView.isUserInteractionEnabled = true
            self.trialPeriodExpired = true
            self.trialPeriodExpiryTextLbl.text = "Your trial period is completed.\n(Continue to use base service for free)\n\nClick here to subscribe now.";
            self.trialPeriodExpiryTextLbl.font = UIFont(name:"QUESTRIAL-REGULAR", size: 18.0)
            self.startTweakingView.isHidden = true;
            self.startTweakingLabel.alpha = 0
            self.trialPeriodExpiryView.alpha = 0.8;
        }
        //}
    }
    

    
    func getClubHome2() {
              APIWrapper.sharedInstance.postRequestWithHeaderMethodWithOutParameters(TweakAndEatURLConstants.CLUB_HOME2, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, success: { response in
                  print(response!)
                  
                  let responseDic : [String:AnyObject] = response as! [String:AnyObject];
                  let responseResult = responseDic["callStatus"] as! String;
                  if  responseResult == "GOOD" {
                      MBProgressHUD.hide(for: self.view, animated: true);
                    //self.tweakAndEatCLubExpiryViewWithButtons.isHidden = false
                      let data = responseDic["data"] as AnyObject as! [[String: AnyObject]]
                      if data.count == 0 {
                          
                      } else {
                        for dict in data {
                            
                                if dict["name"] as! String == "top_btn" {
                                    let urlString = dict["value"] as! String
                                        let url = URL(string: urlString)
                                    DispatchQueue.global(qos: .background).async {
                                        // Call your background task
                                        let data = try? Data(contentsOf: url!)
                                        // UI Updates here for task complete.
                                      
                                        if let imageData = data {
                                            UserDefaults.standard.set(imageData, forKey: "CLUBHOME2_TOP_BUTTON");
                                            let image = UIImage(data: imageData)
                                            DispatchQueue.main.async {
                                                
                                                self.taeClubHome2Btn.setImage(image, for: .normal)
                                                
                                            }
                                    }
                                    

                                        
                                    }
                                } else if dict["name"] as! String == "bottom_btn" {
                                    let urlString = dict["value"] as! String
                                        let url = URL(string: urlString)
                                    DispatchQueue.global(qos: .background).async {
                                        // Call your background task
                                        let data = try? Data(contentsOf: url!)
                                        // UI Updates here for task complete.

                                        if let imageData = data {
                                            UserDefaults.standard.set(imageData, forKey: "PERSONALIZED_SERVICES_BTN_DATA");

                                            let image = UIImage(data: imageData)
                                            DispatchQueue.main.async {
                                                
                                                self.personalisedServicesBtn.setImage(image, for: .normal)
                                                
                                            }
                                    }
                                    

                                        
                                    }
                                }
                            if dict["name"] as! String == "random_promo" {
                                 DispatchQueue.main.async {
                                self.taeClubTrialPeriodExpiryView.isHidden = false
                                self.taeClubTrialPeriodExpiryView.alpha = 0.8;

                                self.taeClubTrialPeriodExpiryViewLbl.text = (dict["value"] as! String)
                                self.taeClubTrialPeriodExpiryViewLbl.font = UIFont(name:"QUESTRIAL-REGULAR", size: 20.0)
                                }
                            }
                            if dict["name"] as! String == "random_promo_link" {
                                 DispatchQueue.main.async {
                                self.taeClubTrialPeriodExpiryView.isHidden = false
                                self.taeClubTrialPeriodExpiryView.alpha = 0.8;

                                }
                               // self.randomPromoLink = (dict["value"] as! String)

                            }
                        }
                      }
                  }
              }, failure : { error in
                  MBProgressHUD.hide(for: self.view, animated: true);
                  
                  print("failure")
                  if error?.code == -1011 {
                     // TweakAndEatUtils.AlertView.showAlert(view: self, message: "Some error occurred. Please try again...");
                      return
                  }
                 // TweakAndEatUtils.AlertView.showAlert(view: self, message: "Your internet connection appears to be offline.");
              })
    }
    func getClubHome3() {
        //MBProgressHUD.showAdded(to: self.view, animated: true)

              APIWrapper.sharedInstance.postRequestWithHeaderMethodWithOutParameters(TweakAndEatURLConstants.CLUB_HOME3, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, success: { response in
                  print(response!)
                  
                  let responseDic : [String:AnyObject] = response as! [String:AnyObject];
                  let responseResult = responseDic["callStatus"] as! String;
                  if  responseResult == "GOOD" {
                      MBProgressHUD.hide(for: self.view, animated: true);

                     let data = responseDic["data"] as AnyObject as! [[String: AnyObject]]
                    print(data)
                      if data.count == 0 {
                          
                      } else {
                        for dict in data {
                            
                        if dict["name"] as! String == "left_btn" {
                                    let urlString = dict["value"] as! String
                                        let url = URL(string: urlString)
                                    DispatchQueue.global(qos: .background).async {
                                        // Call your background task
                                        let data = try? Data(contentsOf: url!)
                                        // UI Updates here for task complete.

                                        if let imageData = data {
                                            UserDefaults.standard.set(imageData, forKey: "CLUBHOME3_LEFT_BUTTON");
                                            let image = UIImage(data: imageData)
                                            DispatchQueue.main.async {
                                                
                                                self.taeClubMemberBottomButton.setImage(image, for: .normal)
                                                self.taeClubMemberTopButton.setImage(image, for: .normal)
                                            }
                                    }
                                    

                                        
                                    }
                                } else if dict["name"] as! String == "right_btn" {
                                    let urlString = dict["value"] as! String
                                        let url = URL(string: urlString)
                                    DispatchQueue.global(qos: .background).async {
                                        // Call your background task
                                        let data = try? Data(contentsOf: url!)
                                        // UI Updates here for task complete.

                                        if let imageData = data {
                                            UserDefaults.standard.set(imageData, forKey: "CLUBHOME3_RIGHT_BUTTON");

                                            let image = UIImage(data: imageData)
                                            DispatchQueue.main.async {
                                                
                                                self.taeClubMemberTopRightButton.setImage(image, for: .normal)
                                                self.taeClubMemberBottomRightButton.setImage(image, for: .normal)

                                            }
                                    }
                                    

                                        
                                    }
                                }
                            
                        }
                      }
                  }
              }, failure : { error in
                  MBProgressHUD.hide(for: self.view, animated: true);
                  
                  print("failure")
                  if error?.code == -1011 {
                     // TweakAndEatUtils.AlertView.showAlert(view: self, message: "Some error occurred. Please try again...");
                      return
                  }
                 // TweakAndEatUtils.AlertView.showAlert(view: self, message: "Your internet connection appears to be offline.");
              })
    }
    
    func getClubHome1() {
        //MBProgressHUD.showAdded(to: self.view, animated: true)

              APIWrapper.sharedInstance.postRequestWithHeaderMethodWithOutParameters(TweakAndEatURLConstants.CLUB_HOME1, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, success: { response in
                  print(response!)
                  
                  let responseDic : [String:AnyObject] = response as! [String:AnyObject];
                  let responseResult = responseDic["callStatus"] as! String;
                  if  responseResult == "GOOD" {
                      MBProgressHUD.hide(for: self.view, animated: true);

                     let data = responseDic["data"] as AnyObject as! [[String: AnyObject]]
                      if data.count == 0 {
                          
                      } else {
                        for dict in data {
                            
                                if dict["name"] as! String == "left_btn" {
                                    let urlString = dict["value"] as! String
                                        let url = URL(string: urlString)
                                    DispatchQueue.global(qos: .background).async {
                                        // Call your background task
                                        let data = try? Data(contentsOf: url!)
                                        // UI Updates here for task complete.

                                        if let imageData = data {
                                            UserDefaults.standard.set(imageData, forKey: "CLUBHOME1_LEFT_BUTTON");
                                            let image = UIImage(data: imageData)
                                            DispatchQueue.main.async {
                                                
                                                self.clubHome1LeftBth.setImage(image, for: .normal)
                                                self.clubHome2LeftBth.setImage(image, for: .normal)
                                                self.premiumMemberTopBtn.setImage(image, for: .normal)
                                                self.premiumMemberBottomBtn.setImage(image, for: .normal)
                                                
                                            }
                                    }
                                    

                                        
                                    }
                                } else if dict["name"] as! String == "right_btn" {
                                    let urlString = dict["value"] as! String
                                        let url = URL(string: urlString)
                                    DispatchQueue.global(qos: .background).async {
                                        // Call your background task
                                        let data = try? Data(contentsOf: url!)
                                        // UI Updates here for task complete.

                                        if let imageData = data {
                                            UserDefaults.standard.set(imageData, forKey: "CLUBHOME1_RIGHT_BUTTON");

                                            let image = UIImage(data: imageData)
                                            DispatchQueue.main.async {
                                                
                                                self.clubHome1RightBth.setImage(image, for: .normal)
                                                self.clubHome2RightBth.setImage(image, for: .normal)
                                                
                                            }
                                    }
                                    

                                        
                                    }
                                }
                            
                        }
                      }
                  }
              }, failure : { error in
                  MBProgressHUD.hide(for: self.view, animated: true);
                  
                  print("failure")
                  if error?.code == -1011 {
                     // TweakAndEatUtils.AlertView.showAlert(view: self, message: "Some error occurred. Please try again...");
                      return
                  }
                 // TweakAndEatUtils.AlertView.showAlert(view: self, message: "Your internet connection appears to be offline.");
              })
    }
    
    func getStaticDateForComparison(noDays: Int) {
      

            if noDays <= 7 {
            self.removePTPExpiryView(noDays: noDays)
        } else {
            self.showTrialPeriodView()
        }
    }
    
    @objc func getUserCallSchedueDetails() {
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
                   self.countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
               }
               if self.countryCode == "91" {
        if UserDefaults.standard.value(forKey: "userSession") != nil {
       // MBProgressHUD.showAdded(to: self.view, animated: true)

        APIWrapper.sharedInstance.postRequestWithHeaderMethodWithOutParameters(TweakAndEatURLConstants.CHECK_USER_SCHEDULE, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, success: { response in
            print(response!)
            
            let responseDic : [String:AnyObject] = response as! [String:AnyObject];
            let responseResult = responseDic["callStatus"] as! String;
            if  responseResult == "GOOD" {
                self.checkUserScheduleArray = []
               // MBProgressHUD.hide(for: self.view, animated: true);
                let data = responseDic["data"] as AnyObject as! [[String: AnyObject]]
                
                if data.count == 0 {
                    UserDefaults.standard.removeObject(forKey: "CALL_SCHEDULED")
                    //UserDefaults.standard.removeObject(forKey: "CALL_SCHEDULED_FROM_CLUB")

                    
                    self.floatingCallBtn.isHidden = true
                } else {
                
self.floatingCallBtn.isHidden = false
                    self.checkUserScheduleArray = data
                    let info = self.checkUserScheduleArray.first
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
                    if (info?["nc_call_date"] is NSNull) {
                       return
                    }
                    let expDateStr =  info?["nc_call_date"] as? String
                    //let expDateStr =  "2019-07-24T17:19:43.000Z"
                    let expDate = dateFormatter.date(from: expDateStr!);
                    dateFormatter.dateFormat = "EEEE, MMM dd yyyy 'at' hh:mm a"
                    let formattedDate = dateFormatter.string(from: expDate!)
                    self.floatingCallBtn.isHidden = false
                    let stringValue = "When: " + formattedDate
                           let whenRange = stringValue.range(of: "When:")
                           let atRange = stringValue.range(of: "at")
                    
                           let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue)
                           attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSRange(whenRange!, in: stringValue))
                           attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 17), range: NSRange(whenRange!, in: stringValue))
                           attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSRange(atRange!, in: stringValue))

                          
                           
                           let userMsisdn = info?["nc_usr_msisdn"] as! String
                           let certNutText = "Our Certified Nutritionist will be calling you on your registered mobile number: " + userMsisdn
                           let msisdnRange = certNutText.range(of: userMsisdn)
                           let certAttrStr: NSMutableAttributedString = NSMutableAttributedString(string: certNutText)
                           certAttrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.purple, range: NSRange(msisdnRange!, in: certNutText))
                           certAttrStr.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 16), range: NSRange(msisdnRange!, in: certNutText))
                           let scheduleDetails = ["callDateTime": formattedDate, "certNutText":certNutText, "userMsisdn": userMsisdn] as [String: AnyObject];
                           UserDefaults.standard.set(scheduleDetails, forKey: "CALL_SCHEDULED");
                           UserDefaults.standard.synchronize()
                    if self.isCallBtnTapped == true {
                        self.isCallBtnTapped = false
                        self.callSchedulePopup = (Bundle.main.loadNibNamed("UserCallSchedulePopUp", owner: self, options: nil)! as NSArray).firstObject as? UserCallSchedulePopUp;
                              self.callSchedulePopup.frame = CGRect(0, 0, self.view.frame.width, self.view.frame.height);
                                     self.callSchedulePopup.userCallScheduleDelegate = self;
                                     self.callSchedulePopup.beginning();
                        
                        self.callSchedulePopup.whenLbl.attributedText = attributedString
                        self.callSchedulePopup.ourCerifiedNutritionistLbl.attributedText = certAttrStr
                        
                        self.view.addSubview(self.callSchedulePopup);
                    }
                }
            }
        }, failure : { error in
          //  MBProgressHUD.hide(for: self.view, animated: true);
            
            print("failure")
            if error?.code == -1011 {
           //     TweakAndEatUtils.AlertView.showAlert(view: self, message: "Your internet connection appears to be offline.");
                return
            }
          //  TweakAndEatUtils.AlertView.showAlert(view: self, message: "Your internet connection appears to be offline.");
        })
        }
        }

    }
    
    func setupSubscribeNowButton() {
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
            countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"

            if self.countryCode == "91" {
            if UserDefaults.standard.value(forKey: self.clubPackageSubscribed) != nil {
            self.subscribeNowButton.setImage(UIImage.init(named: "upgrade_now_btn"), for: .normal)
        } else {
            self.subscribeNowButton.setImage(UIImage.init(named: "subscribe_now_btn"), for: .normal)

        }
            } else {
                if self.countryCode == "62" {
                    if UserDefaults.standard.value(forKey: "LANGUAGE") != nil {
                        let language = UserDefaults.standard.value(forKey: "LANGUAGE") as! String;
                        if language == "BA" {
                            self.subscribeNowButton.setImage(UIImage.init(named: "LANGGANAN_SEKARANG_BTN"), for: .normal)

                        } else {
                            self.subscribeNowButton.setImage(UIImage.init(named: "subscribe_now_btn"), for: .normal)

                        }
                        
                    }
                } else {
                //self.subscribeNowButton.setImage(UIImage.init(named: "subscribe_now_btn"), for: .normal)
                    if UserDefaults.standard.value(forKey: self.clubPackageSubscribed) != nil {
                    self.subscribeNowButton.setImage(UIImage.init(named: "upgrade_now_btn"), for: .normal)
                } else {
                    self.subscribeNowButton.setImage(UIImage.init(named: "subscribe_now_btn"), for: .normal)

                }
                }
            }
        }
    }
    
    @objc func homeInfoApiCalls() {
        
       var floatingButtonArray = [[String: AnyObject]]()
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
            self.countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
        }
        if self.countryCode == "91" {
            self.clubPackageSubscribed = "-ClubInd3gu7tfwko6Zx"
        } else if self.countryCode == "62" {
            self.clubPackageSubscribed = "-ClubIdn4hd8flchs9Vy"
        } else if self.countryCode == "1" {
            self.clubPackageSubscribed = "-ClubUSA4tg6cvdhizQn"
        } else if self.countryCode == "65" {
            self.clubPackageSubscribed = "-ClubSGNPbeleu8beyKn"
        } else if self.countryCode == "60" {
            self.clubPackageSubscribed = "-ClubMYSheke8ebdjoWs"
        }
        if self.countryCode == "44" {
                                       self.premiumMemberBottomBtn.isHidden = true
                                       self.premiumMemberTopBtn.isHidden = true
                                   }
        if self.countryCode != "91" {
            if self.countryCode == "62" {
                self.beforeTweakImageView.image = UIImage.init(named: "before_tweak_bg_Indonesia")
                self.premiumMemberBottomBtn.setImage(UIImage.init(named: "taeClubBtnIndonesia"), for: .normal)
                self.premiumMemberTopBtn.setImage(UIImage.init(named: "taeClubBtnIndonesia"), for: .normal)
            } else {
            self.premiumMemberBottomBtn.setImage(UIImage.init(named: "tae_club_home_left_btn_1x"), for: .normal)
            self.premiumMemberTopBtn.setImage(UIImage.init(named: "tae_club_home_left_btn_1x"), for: .normal)
            }
        }
        APIWrapper.sharedInstance.postRequestWithHeaders(TweakAndEatURLConstants.HOMEINFO, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, success: { response in
            var responseDic : [String:AnyObject] = response as! [String:AnyObject];
            print(responseDic)
            self.tweakCount = responseDic["tweakTotal"] as! Int
            //self.tweakCount = 1
            //self.tweakCount = Int.random(in: 0...1)

//            DispatchQueue.global(qos: .background).async {
//                // Call your background task
//                let imgUrl = responseDic["homeBtnPremImage"] as AnyObject as! String
//                let data = try? Data(contentsOf: URL(string: imgUrl)!)
//                // UI Updates here for task complete.
//                UserDefaults.standard.set(data, forKey: "PREMIUM_BUTTON_DATA");
//                UserDefaults.standard.synchronize()
//                if let imageData = data {
//                    let image = UIImage(data: imageData)
//                    DispatchQueue.main.async {
//                        if self.countryCode != "91" {
//                            if self.countryCode == "44" {
//                                self.premiumMemberBottomBtn.isHidden = true
//                                self.premiumMemberTopBtn.isHidden = true
//                            }
//                            self.premiumMemberBottomBtn.setBackgroundImage(image, for: .normal)
//                            self.premiumMemberTopBtn.setBackgroundImage(image, for: .normal)
//                        }
//
//
//                    }
//            }
//
//
//
//            }
//            if self.countryCode != "91" {
//                self.premiumMemberTopButtonWidthConstraint.constant = 320
//                self.premiumMemberBottomButtonWidthConstraint.constant = 320
//                self.premiumMemberBottomButtonHeightConstraint.constant = 45
//                self.premiumMemberTopButtonHeightConstraint.constant = 45
//
//            }
            
            if self.countryCode == "91" {
                self.ptpPackage = "-IndAiBPtmMrS4VPnwmD"
            } else if self.countryCode == "1" {
                self.ptpPackage = "-UsaAiBPxnaopT55GJxl"
            } else if self.countryCode == "65" {
                self.ptpPackage = "-SgnAiBPJlXfM3KzDWR8"
            } else if self.countryCode == "62" {
                self.ptpPackage = "-IdnAiBPLKMO5ePamQle"
            } else if self.countryCode == "60" {
                self.ptpPackage = "-MysAiBPyaX9TgFT1YOp"
            } else if self.countryCode == "63" {
                self.ptpPackage = "-PhyAiBPcYLiSYlqhjbI"
            }
            
            let createdDateFormatter = DateFormatter()
            createdDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
            
            let crtDateStr =  responseDic["userCrtDttm"] as! String;
            let crtDate = createdDateFormatter.date(from: crtDateStr)!;
            let noDays = (self.daysBetweenDates(startDate: crtDate, endDate: Date()))
            if self.countryCode == "63" {
                let ptpUserSubscribed = responseDic["userPhlAibpSub"] as! Int
                
                if ptpUserSubscribed == 1 {
                  
                    UserDefaults.standard.set(PTPPackages.ptpPhilippinesPackage, forKey: PTPPackages.ptpPhilippinesPackage)
                    UserDefaults.standard.synchronize()
                } else {
                    UserDefaults.standard.removeObject(forKey: PTPPackages.ptpPhilippinesPackage)
                    
                }
                if responseDic["userPhlAibpSubExpDttm"] is NSNull {
                 self.getStaticDateForComparison(noDays: noDays)
                    UserDefaults.standard.removeObject(forKey: PTPPackages.ptpPhilippinesPackage)
                }  else {
                    if responseDic["userPhlAibpSubExpDttm"] as! String == "" {
                        self.getStaticDateForComparison(noDays: noDays)
                        
                        UserDefaults.standard.removeObject(forKey: PTPPackages.ptpPhilippinesPackage)
                    } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
                
                let expDateStr =  responseDic["userPhlAibpSubExpDttm"] as! String;
                let expDate = dateFormatter.date(from: expDateStr);
                        
                let currentDate = Date();
                if expDate! < currentDate {
                    self.showTrialPeriodView()
                    UserDefaults.standard.removeObject(forKey: PTPPackages.ptpPhilippinesPackage)
//                    if ptpUserSubscribed == 1 {
//                    UserDefaults.standard.set(PTPPackages.ptpPhilippinesPackage, forKey: PTPPackages.ptpPhilippinesPackage)
//                    UserDefaults.standard.synchronize()
//                    floatingButtonArray.append(["pkgName": "My AiBP" as AnyObject, "imgName": "aibp-icon" as AnyObject, "pkg": PTPPackages.ptpPhilippinesPackage as AnyObject])
//                    self.floatingCrownBtn.isHidden = false
//                    self.removePTPExpiryView()
//                    } else {
//                        UserDefaults.standard.removeObject(forKey: PTPPackages.ptpPhilippinesPackage)
//
//                    }
                } else {
                    if ptpUserSubscribed == 1 {
                    UserDefaults.standard.set(PTPPackages.ptpPhilippinesPackage, forKey: PTPPackages.ptpPhilippinesPackage)
                    UserDefaults.standard.synchronize()
                    floatingButtonArray.append(["pkgName": "My AiBP" as AnyObject, "imgName": "aibp-icon" as AnyObject, "pkg": PTPPackages.ptpPhilippinesPackage as AnyObject])
                    self.floatingCrownBtn.isHidden = false
                    self.removePTPExpiryView()
                    } else {
                        UserDefaults.standard.removeObject(forKey: PTPPackages.ptpPhilippinesPackage)

                    }
                    }
            }
            }
                
            }
            if self.countryCode == "65" {
                
                let ptpUserSubscribed = responseDic["userSgpAibpSub"] as! Int
                
                if ptpUserSubscribed == 1 {
                    UserDefaults.standard.set(PTPPackages.ptpSingaporePackage, forKey: PTPPackages.ptpSingaporePackage)
                    UserDefaults.standard.synchronize()
                    
                } else {
                    UserDefaults.standard.removeObject(forKey: PTPPackages.ptpSingaporePackage)
                    
                }
                if responseDic["userSgpAibpSubExpDttm"] is NSNull {

                    UserDefaults.standard.removeObject(forKey: PTPPackages.ptpSingaporePackage)
                }  else {
                    if responseDic["userSgpAibpSubExpDttm"] as! String == "" {

                        UserDefaults.standard.removeObject(forKey: PTPPackages.ptpSingaporePackage)
                    } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
                
                let expDateStr =  responseDic["userSgpAibpSubExpDttm"] as! String;
                let expDate = dateFormatter.date(from: expDateStr);
                
                let currentDate = Date();
                if expDate! < currentDate {
                    UserDefaults.standard.removeObject(forKey: PTPPackages.ptpSingaporePackage)
//                    if ptpUserSubscribed == 1 {
//
//                    UserDefaults.standard.set(PTPPackages.ptpSingaporePackage, forKey: PTPPackages.ptpSingaporePackage)
//                    UserDefaults.standard.synchronize()
//                    floatingButtonArray.append(["pkgName": "My AiBP" as AnyObject, "imgName": "aibp-icon" as AnyObject, "pkg": PTPPackages.ptpSingaporePackage as AnyObject])
//                    self.floatingCrownBtn.isHidden = false
//                    } else {
//                         UserDefaults.standard.removeObject(forKey: PTPPackages.ptpSingaporePackage)
//                    }
                } else {
                    if ptpUserSubscribed == 1 {

                    UserDefaults.standard.set(PTPPackages.ptpSingaporePackage, forKey: PTPPackages.ptpSingaporePackage)
                    UserDefaults.standard.synchronize()
                    floatingButtonArray.append(["pkgName": "My AiBP" as AnyObject, "imgName": "aibp-icon" as AnyObject, "pkg": PTPPackages.ptpSingaporePackage as AnyObject])
                    self.floatingCrownBtn.isHidden = false
                    } else {
                         UserDefaults.standard.removeObject(forKey: PTPPackages.ptpSingaporePackage)
                    }
                }
                }
                }
                let userSubscribed = responseDic["userSgnMyAidpSub"] as! Int
                
                if userSubscribed == 1 {
                    UserDefaults.standard.set("-SgnMyAiDPuD8WVCipga", forKey: "-SgnMyAiDPuD8WVCipga")
                    UserDefaults.standard.synchronize()
                } else {
                    UserDefaults.standard.removeObject(forKey: "-SgnMyAiDPuD8WVCipga")
                    
                }
                if responseDic["userSgnMyAidpSubExpDttm"] is NSNull {
                    
                } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
                let expDateStr =  responseDic["userSgnMyAidpSubExpDttm"] as! String;
                let expDate = dateFormatter.date(from: expDateStr);
                UserDefaults.standard.set(expDate, forKey: "AIDP_EXP_DATE")
                UserDefaults.standard.synchronize()
                let currentDate = Date();
                if expDate! < currentDate {
                      UserDefaults.standard.removeObject(forKey: "-SgnMyAiDPuD8WVCipga")
//                    if userSubscribed == 1 {
//                    UserDefaults.standard.set("-SgnMyAiDPuD8WVCipga", forKey: "-SgnMyAiDPuD8WVCipga")
//                    UserDefaults.standard.synchronize()
//                    floatingButtonArray.append(["pkgName": "My AiDP" as AnyObject, "imgName": "aidp-icon" as AnyObject, "pkg": "-SgnMyAiDPuD8WVCipga" as AnyObject])
//                    self.floatingCrownBtn.isHidden = false
//
//                    } else {
//                    UserDefaults.standard.removeObject(forKey: "-SgnMyAiDPuD8WVCipga")
//                    }
                } else {
                    if userSubscribed == 1 {
                    UserDefaults.standard.set("-SgnMyAiDPuD8WVCipga", forKey: "-SgnMyAiDPuD8WVCipga")
                    UserDefaults.standard.synchronize()
                    floatingButtonArray.append(["pkgName": "My AiDP" as AnyObject, "imgName": "aidp-icon" as AnyObject, "pkg": "-SgnMyAiDPuD8WVCipga" as AnyObject])
                    self.floatingCrownBtn.isHidden = false
                    
                    } else {
                    UserDefaults.standard.removeObject(forKey: "-SgnMyAiDPuD8WVCipga")
                    }
                    }
            }
                let userSubscribedToClub = responseDic["userTaeClubSub"] as! Int
                //let userSubscribedToClub = 0
                
                if userSubscribedToClub == 1 {
                    UserDefaults.standard.set("-ClubSGNPbeleu8beyKn", forKey: "-ClubSGNPbeleu8beyKn")
                    UserDefaults.standard.synchronize()
                  self.tweakandeatClubButtonView.isHidden = true
                                     self.tweakandeatClubButtonViewBottom.isHidden = true
                                     self.tweakAndEatCLubExpiryViewWithButtons.isHidden = true
                                     self.taeClubTrialPeriodExpiryView.isHidden = true


                } else {
                    
                    UserDefaults.standard.removeObject(forKey: "-ClubSGNPbeleu8beyKn")
                }
                if responseDic["userTaeClubSubExpDttm"] is NSNull {
              //      UserDefaults.standard.removeObject(forKey: "-ClubInd3gu7tfwko6Zx")

                } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
                let expDateStr =  responseDic["userTaeClubSubExpDttm"] as! String;
                let expDate = dateFormatter.date(from: expDateStr);
                
                let currentDate = Date();
                if expDate! < currentDate {
                    UserDefaults.standard.removeObject(forKey: "-ClubSGNPbeleu8beyKn")
//                    if userSubscribedToClub == 1 {
//                    UserDefaults.standard.set("-ClubSGNPbeleu8beyKn", forKey: "-ClubSGNPbeleu8beyKn")
//                    UserDefaults.standard.synchronize()
//
//                    } else {
//                        UserDefaults.standard.removeObject(forKey: "-ClubSGNPbeleu8beyKn")
//                        //self.tweakandeatClubButtonView.isHidden = false
//
//                    }


                } else {
                    if userSubscribedToClub == 1 {
                    UserDefaults.standard.set("-ClubSGNPbeleu8beyKn", forKey: "-ClubSGNPbeleu8beyKn")
                    UserDefaults.standard.synchronize()
                      floatingButtonArray.append(["pkgName": "Tweak & Eat Club" as AnyObject, "imgName": "tweak-and-eat-club-member-btn" as AnyObject, "pkg": "-ClubSGNPbeleu8beyKn" as AnyObject])
                      self.floatingCrownBtn.isHidden = false
                    } else {
                        UserDefaults.standard.removeObject(forKey: "-ClubSGNPbeleu8beyKn")
                        //self.tweakandeatClubButtonView.isHidden = false

                    }
                    }
                }
                if UserDefaults.standard.value(forKey: self.ptpPackage) != nil || UserDefaults.standard.value(forKey: "-SgnMyAiDPuD8WVCipga") != nil || UserDefaults.standard.value(forKey: self.clubPackageSubscribed) != nil {
                    self.removePTPExpiryView()
                } else {
                    self.getStaticDateForComparison(noDays: noDays)
                }
                
            }
            
            if self.countryCode == "62" {
                let ptpUserSubscribed = responseDic["userIdnAibpSub"] as! Int
                
                
                if ptpUserSubscribed == 1 {
                    UserDefaults.standard.set(PTPPackages.ptpIndonesiaPackage, forKey: PTPPackages.ptpIndonesiaPackage)
                    UserDefaults.standard.synchronize()
                } else {
                    UserDefaults.standard.removeObject(forKey: PTPPackages.ptpIndonesiaPackage)
                    
                }
                if responseDic["userIdnAibpSubExpDttm"] is NSNull {

                     UserDefaults.standard.removeObject(forKey: PTPPackages.ptpIndonesiaPackage)
                }  else {
                    if responseDic["userIdnAibpSubExpDttm"] as! String == "" {
                        
                        UserDefaults.standard.removeObject(forKey: PTPPackages.ptpIndonesiaPackage)
                    } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
                
                let expDateStr =  responseDic["userIdnAibpSubExpDttm"] as! String;
                let expDate = dateFormatter.date(from: expDateStr);
                
                let currentDate = Date();
                if expDate! < currentDate {
                    UserDefaults.standard.removeObject(forKey: PTPPackages.ptpIndonesiaPackage)
//                    if ptpUserSubscribed == 1 {
//                    UserDefaults.standard.set(PTPPackages.ptpIndonesiaPackage, forKey: PTPPackages.ptpIndonesiaPackage)
//                    UserDefaults.standard.synchronize()
//                    floatingButtonArray.append(["pkgName": "My AiBP" as AnyObject, "imgName": "aibp-icon" as AnyObject, "pkg": PTPPackages.ptpIndonesiaPackage as AnyObject])
//                    self.floatingCrownBtn.isHidden = false
//                    } else {
//                        UserDefaults.standard.removeObject(forKey: PTPPackages.ptpIndonesiaPackage)
//
//                    }
                } else {
                    if ptpUserSubscribed == 1 {
                    UserDefaults.standard.set(PTPPackages.ptpIndonesiaPackage, forKey: PTPPackages.ptpIndonesiaPackage)
                    UserDefaults.standard.synchronize()
                    floatingButtonArray.append(["pkgName": "My AiBP" as AnyObject, "imgName": "aibp-icon" as AnyObject, "pkg": PTPPackages.ptpIndonesiaPackage as AnyObject])
                    self.floatingCrownBtn.isHidden = false
                    } else {
                        UserDefaults.standard.removeObject(forKey: PTPPackages.ptpIndonesiaPackage)

                    }
                    }
                }
                }
                
                let userSubscribed = responseDic["userIdnMyAidpSub"] as! Int
                
                if userSubscribed == 1 {
                    UserDefaults.standard.set("-IdnMyAiDPoP9DFGkbas", forKey: "-IdnMyAiDPoP9DFGkbas")
                    UserDefaults.standard.synchronize()
                    

                } else {
                    UserDefaults.standard.removeObject(forKey: "-IdnMyAiDPoP9DFGkbas")

                }
                if responseDic["userIdnMyAidpSubExpDttm"] is NSNull {
                
                } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
                let expDateStr =  responseDic["userIdnMyAidpSubExpDttm"] as! String;
                let expDate = dateFormatter.date(from: expDateStr);
                UserDefaults.standard.set(expDate, forKey: "AIDP_EXP_DATE")
                UserDefaults.standard.synchronize()
                let currentDate = Date();
                if expDate! < currentDate {
                    UserDefaults.standard.removeObject(forKey: "-IdnMyAiDPoP9DFGkbas")
//                    if userSubscribed == 1{
//                    UserDefaults.standard.set("-IdnMyAiDPoP9DFGkbas", forKey: "-IdnMyAiDPoP9DFGkbas")
//                    UserDefaults.standard.synchronize()
//                    floatingButtonArray.append(["pkgName": "My AiDP" as AnyObject, "imgName": "aidp-icon" as AnyObject, "pkg": "-IdnMyAiDPoP9DFGkbas" as AnyObject])
//                    self.floatingCrownBtn.isHidden = false
//                    } else {
//                    UserDefaults.standard.removeObject(forKey: "-IdnMyAiDPoP9DFGkbas")
//
//                                       }

                } else {
                    if userSubscribed == 1{
                    UserDefaults.standard.set("-IdnMyAiDPoP9DFGkbas", forKey: "-IdnMyAiDPoP9DFGkbas")
                    UserDefaults.standard.synchronize()
                    floatingButtonArray.append(["pkgName": "My AiDP" as AnyObject, "imgName": "aidp-icon" as AnyObject, "pkg": "-IdnMyAiDPoP9DFGkbas" as AnyObject])
                    self.floatingCrownBtn.isHidden = false
                    } else {
                    UserDefaults.standard.removeObject(forKey: "-IdnMyAiDPoP9DFGkbas")

                                       }

                    }
                    
                } //-ClubIdn4hd8flchs9Vy
                  let userSubscribedToClub = responseDic["userTaeClubSub"] as! Int
                  //let userSubscribedToClub = 0
                  
                  if userSubscribedToClub == 1 {
                      UserDefaults.standard.set("-ClubIdn4hd8flchs9Vy", forKey: "-ClubIdn4hd8flchs9Vy")
                      UserDefaults.standard.synchronize()
                    self.tweakandeatClubButtonView.isHidden = true
                                       self.tweakandeatClubButtonViewBottom.isHidden = true
                                       self.tweakAndEatCLubExpiryViewWithButtons.isHidden = true
                                       self.taeClubTrialPeriodExpiryView.isHidden = true


                  } else {
                      
                      UserDefaults.standard.removeObject(forKey: "-ClubIdn4hd8flchs9Vy")
                  }
                  if responseDic["userTaeClubSubExpDttm"] is NSNull {
                //      UserDefaults.standard.removeObject(forKey: "-ClubInd3gu7tfwko6Zx")

                  } else {
                  let dateFormatter = DateFormatter()
                  dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
                  let expDateStr =  responseDic["userTaeClubSubExpDttm"] as! String;
                  let expDate = dateFormatter.date(from: expDateStr);
                  
                  let currentDate = Date();
                  if expDate! < currentDate {
                      UserDefaults.standard.removeObject(forKey: "-ClubIdn4hd8flchs9Vy")
//                      if userSubscribedToClub == 1 {
//                      UserDefaults.standard.set("-ClubIdn4hd8flchs9Vy", forKey: "-ClubIdn4hd8flchs9Vy")
//                      UserDefaults.standard.synchronize()
//
//                      } else {
//                          UserDefaults.standard.removeObject(forKey: "-ClubIdn4hd8flchs9Vy")
//                          //self.tweakandeatClubButtonView.isHidden = false
//
//                      }


                  } else {
                      if userSubscribedToClub == 1 {
                      UserDefaults.standard.set("-ClubIdn4hd8flchs9Vy", forKey: "-ClubIdn4hd8flchs9Vy")
                      UserDefaults.standard.synchronize()
                        floatingButtonArray.append(["pkgName": "Tweak & Eat Club" as AnyObject, "imgName": "tweak-and-eat-club-member-btn" as AnyObject, "pkg": "-ClubIdn4hd8flchs9Vy" as AnyObject])
                        self.floatingCrownBtn.isHidden = false
                      } else {
                          UserDefaults.standard.removeObject(forKey: "-ClubIdn4hd8flchs9Vy")
                          //self.tweakandeatClubButtonView.isHidden = false

                      }
                      }
                  }
                if UserDefaults.standard.value(forKey: self.ptpPackage) != nil || UserDefaults.standard.value(forKey: "-IdnMyAiDPoP9DFGkbas") != nil || UserDefaults.standard.value(forKey: "-ClubIdn4hd8flchs9Vy") != nil {
                    self.removePTPExpiryView()
                } else {
                    self.getStaticDateForComparison(noDays: noDays)
                }
            }
            
            if self.countryCode == "1" {
                let ptpUserSubscribed = responseDic["userUsaAibpSub"] as! Int
                
                if ptpUserSubscribed == 1 {
                    UserDefaults.standard.set(PTPPackages.ptpUSAPackage, forKey: PTPPackages.ptpUSAPackage)
                    UserDefaults.standard.synchronize()
                   
                } else {
                    UserDefaults.standard.removeObject(forKey: PTPPackages.ptpUSAPackage)
                    
                }
                if responseDic["userUsaAibpSubExpDttm"] is NSNull {

                    UserDefaults.standard.removeObject(forKey: PTPPackages.ptpUSAPackage)
                } else {
                    if responseDic["userUsaAibpSubExpDttm"] as! String == "" {
                        
                        UserDefaults.standard.removeObject(forKey: PTPPackages.ptpUSAPackage)
                    } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
                
                let expDateStr =  responseDic["userUsaAibpSubExpDttm"] as! String;
                let expDate = dateFormatter.date(from: expDateStr);
                
                let currentDate = Date();
                if expDate! < currentDate {
                    UserDefaults.standard.removeObject(forKey: PTPPackages.ptpUSAPackage)
//                    if ptpUserSubscribed == 1 {
//                                       UserDefaults.standard.set(PTPPackages.ptpUSAPackage, forKey: PTPPackages.ptpUSAPackage)
//                                       UserDefaults.standard.synchronize()
//                                       floatingButtonArray.append(["pkgName": "My AiBP" as AnyObject, "imgName": "aibp-icon" as AnyObject, "pkg": PTPPackages.ptpUSAPackage as AnyObject])
//                                       self.floatingCrownBtn.isHidden = false
//                                       } else {
//                                           UserDefaults.standard.removeObject(forKey: PTPPackages.ptpUSAPackage)
//
//                                       }
                } else {
                    if ptpUserSubscribed == 1 {
                    UserDefaults.standard.set(PTPPackages.ptpUSAPackage, forKey: PTPPackages.ptpUSAPackage)
                    UserDefaults.standard.synchronize()
                    floatingButtonArray.append(["pkgName": "My AiBP" as AnyObject, "imgName": "aibp-icon" as AnyObject, "pkg": PTPPackages.ptpUSAPackage as AnyObject])
                    self.floatingCrownBtn.isHidden = false
                    } else {
                        UserDefaults.standard.removeObject(forKey: PTPPackages.ptpUSAPackage)

                    }
                        }
                }
                }
                
                let userSubscribed = responseDic["userUsaSub"] as! Int
                
                if userSubscribed == 1 {
                    UserDefaults.standard.set("-MzqlVh6nXsZ2TCdAbOp", forKey: "-MzqlVh6nXsZ2TCdAbOp")
                    UserDefaults.standard.synchronize()
                  

                } else {
                    UserDefaults.standard.removeObject(forKey: "-MzqlVh6nXsZ2TCdAbOp")
                }
                if responseDic["userUsaSubExpDttm"] is NSNull {
                    
                } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
                let expDateStr =  responseDic["userUsaSubExpDttm"] as! String;
                let expDate = dateFormatter.date(from: expDateStr);
                UserDefaults.standard.set(expDate, forKey: "AIDP_EXP_DATE")
                UserDefaults.standard.synchronize()
                let currentDate = Date();
                if expDate! < currentDate {
                    UserDefaults.standard.removeObject(forKey: "-MzqlVh6nXsZ2TCdAbOp")

                } else {
                    if userSubscribed == 1 {
                    UserDefaults.standard.set("-MzqlVh6nXsZ2TCdAbOp", forKey: "-MzqlVh6nXsZ2TCdAbOp")
                    UserDefaults.standard.synchronize()
                    floatingButtonArray.append(["pkgName": "My Tweak & Eat" as AnyObject, "imgName": "tae-icon" as AnyObject, "pkg": "-MzqlVh6nXsZ2TCdAbOp" as AnyObject])
                    self.floatingCrownBtn.isHidden = false
                    } else {
                        UserDefaults.standard.removeObject(forKey: "-MzqlVh6nXsZ2TCdAbOp")

                    }
                    }
                }
                let userSubscribedToClub = responseDic["userTaeClubSub"] as! Int
                //let userSubscribedToClub = 0
                
                if userSubscribedToClub == 1 {
                    UserDefaults.standard.set("-ClubUSA4tg6cvdhizQn", forKey: "-ClubUSA4tg6cvdhizQn")
                    UserDefaults.standard.synchronize()
                  self.tweakandeatClubButtonView.isHidden = true
                                     self.tweakandeatClubButtonViewBottom.isHidden = true
                                     self.tweakAndEatCLubExpiryViewWithButtons.isHidden = true
                                     self.taeClubTrialPeriodExpiryView.isHidden = true


                } else {
                    
                    UserDefaults.standard.removeObject(forKey: "-ClubUSA4tg6cvdhizQn")
                }
                if responseDic["userTaeClubSubExpDttm"] is NSNull {
              //      UserDefaults.standard.removeObject(forKey: "-ClubInd3gu7tfwko6Zx")

                } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
                let expDateStr =  responseDic["userTaeClubSubExpDttm"] as! String;
                let expDate = dateFormatter.date(from: expDateStr);
                
                let currentDate = Date();
                if expDate! < currentDate {
                    UserDefaults.standard.removeObject(forKey: "-ClubUSA4tg6cvdhizQn")



                } else {
                    if userSubscribedToClub == 1 {
                    UserDefaults.standard.set("-ClubUSA4tg6cvdhizQn", forKey: "-ClubUSA4tg6cvdhizQn")
                    UserDefaults.standard.synchronize()
                      floatingButtonArray.append(["pkgName": "Tweak & Eat Club" as AnyObject, "imgName": "tweak-and-eat-club-member-btn" as AnyObject, "pkg": "-ClubUSA4tg6cvdhizQn" as AnyObject])
                      self.floatingCrownBtn.isHidden = false
                    } else {
                        UserDefaults.standard.removeObject(forKey: "-ClubUSA4tg6cvdhizQn")
                        //self.tweakandeatClubButtonView.isHidden = false

                    }
                    }
                }
                let userClubAidpSub = responseDic["userClubAidpSub"] as! Int
                //let userSubscribedToClub = 0
                
                if userClubAidpSub == 1 {
                    UserDefaults.standard.set("-ClubUsa5nDa1M8WcRA6", forKey: "-ClubUsa5nDa1M8WcRA6")
                    UserDefaults.standard.synchronize()
                  self.tweakandeatClubButtonView.isHidden = true
                                     self.tweakandeatClubButtonViewBottom.isHidden = true
                                     self.tweakAndEatCLubExpiryViewWithButtons.isHidden = true
                                     self.taeClubTrialPeriodExpiryView.isHidden = true


                } else {
                    
                    UserDefaults.standard.removeObject(forKey: "-ClubUsa5nDa1M8WcRA6")
                }
                if responseDic["userClubAidpSubExpDttm"] is NSNull {
              //      UserDefaults.standard.removeObject(forKey: "-ClubInd3gu7tfwko6Zx")

                } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
                let expDateStr =  responseDic["userClubAidpSubExpDttm"] as! String;
                let expDate = dateFormatter.date(from: expDateStr);
                    UserDefaults.standard.set(expDate, forKey: "AIDP_EXP_DATE")
                    UserDefaults.standard.synchronize()
                
                let currentDate = Date();
                if expDate! < currentDate {
                    UserDefaults.standard.removeObject(forKey: "-ClubUsa5nDa1M8WcRA6")



                } else {
                    if userClubAidpSub == 1 {
                    UserDefaults.standard.set("-ClubUsa5nDa1M8WcRA6", forKey: "-ClubUsa5nDa1M8WcRA6")
                    UserDefaults.standard.synchronize()
                      floatingButtonArray.append(["pkgName": "Club Package" as AnyObject, "imgName": "clubaidp" as AnyObject, "pkg": "-ClubUsa5nDa1M8WcRA6" as AnyObject])
                      self.floatingCrownBtn.isHidden = false
                    } else {
                        UserDefaults.standard.removeObject(forKey: "-ClubUsa5nDa1M8WcRA6")
                        //self.tweakandeatClubButtonView.isHidden = false

                    }
                    }
                }
                if UserDefaults.standard.value(forKey: self.ptpPackage) != nil || UserDefaults.standard.value(forKey: "-MzqlVh6nXsZ2TCdAbOp") != nil || UserDefaults.standard.value(forKey: self.clubPackageSubscribed) != nil {
                    self.removePTPExpiryView()
                } else {
                    self.getStaticDateForComparison(noDays: noDays)
                }
            } else if self.countryCode == "60" {
                let ptpUserSubscribed = responseDic["userMysAibpSub"] as! Int
                
                if ptpUserSubscribed == 1 {
                    UserDefaults.standard.set(PTPPackages.ptpMalaysiaPackage, forKey: PTPPackages.ptpMalaysiaPackage)
                    UserDefaults.standard.synchronize()
                } else {
                    UserDefaults.standard.removeObject(forKey: PTPPackages.ptpMalaysiaPackage)
                    
                }
                if responseDic["userMysAibpSubExpDttm"] is NSNull {

                    UserDefaults.standard.removeObject(forKey: PTPPackages.ptpMalaysiaPackage)
                } else {
                    if responseDic["userMysAibpSubExpDttm"] as! String == "" {
                        
                        UserDefaults.standard.removeObject(forKey: PTPPackages.ptpMalaysiaPackage)
                    } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
                
                let expDateStr =  responseDic["userMysAibpSubExpDttm"] as! String;
                let expDate = dateFormatter.date(from: expDateStr);
                
                let currentDate = Date();
                if expDate! < currentDate {

                    UserDefaults.standard.removeObject(forKey: PTPPackages.ptpMalaysiaPackage)
//                    if ptpUserSubscribed == 1 {
//                    UserDefaults.standard.set(PTPPackages.ptpMalaysiaPackage, forKey: PTPPackages.ptpMalaysiaPackage)
//                    UserDefaults.standard.synchronize()
//                    floatingButtonArray.append(["pkgName": "My AiBP" as AnyObject, "imgName": "aibp-icon" as AnyObject, "pkg": PTPPackages.ptpMalaysiaPackage as AnyObject])
//                    self.floatingCrownBtn.isHidden = false
//                    } else {
//                        UserDefaults.standard.removeObject(forKey: PTPPackages.ptpMalaysiaPackage)
//
//                    }
                } else {
                    if ptpUserSubscribed == 1 {
                    UserDefaults.standard.set(PTPPackages.ptpMalaysiaPackage, forKey: PTPPackages.ptpMalaysiaPackage)
                    UserDefaults.standard.synchronize()
                    floatingButtonArray.append(["pkgName": "My AiBP" as AnyObject, "imgName": "aibp-icon" as AnyObject, "pkg": PTPPackages.ptpMalaysiaPackage as AnyObject])
                    self.floatingCrownBtn.isHidden = false
                    } else {
                        UserDefaults.standard.removeObject(forKey: PTPPackages.ptpMalaysiaPackage)

                    }
                    }
                }
                }
                let userSubscribed = responseDic["userMysSub"] as! Int
                
                if userSubscribed == 1 {
                    UserDefaults.standard.set("-MalAXk7gLyR3BNMusfi", forKey: "-MalAXk7gLyR3BNMusfi")
                    UserDefaults.standard.synchronize()


                } else {
                    UserDefaults.standard.removeObject(forKey: "-MalAXk7gLyR3BNMusfi")
                }
                if responseDic["userMysSubExpDttm"] is NSNull {
                    
                } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
                
                let expDateStr =  responseDic["userMysSubExpDttm"] as! String;
                let expDate = dateFormatter.date(from: expDateStr);
                UserDefaults.standard.set(expDate, forKey: "AIDP_EXP_DATE")
                UserDefaults.standard.synchronize()
                let currentDate = Date();
                if expDate! < currentDate {
                    UserDefaults.standard.removeObject(forKey: "-MalAXk7gLyR3BNMusfi")
//                    if userSubscribed == 1 {
//                                       UserDefaults.standard.set("-MalAXk7gLyR3BNMusfi", forKey: "-MalAXk7gLyR3BNMusfi")
//                                       UserDefaults.standard.synchronize()
//                                       floatingButtonArray.append(["pkgName": "My AiDP" as AnyObject, "imgName": "aidp-icon" as AnyObject, "pkg": "-MalAXk7gLyR3BNMusfi" as AnyObject])
//                                       self.floatingCrownBtn.isHidden = false
//                                       } else {
//                                           UserDefaults.standard.removeObject(forKey: "-MalAXk7gLyR3BNMusfi")
//
//                                       }
                } else {
                    if userSubscribed == 1 {
                    UserDefaults.standard.set("-MalAXk7gLyR3BNMusfi", forKey: "-MalAXk7gLyR3BNMusfi")
                    UserDefaults.standard.synchronize()
                    floatingButtonArray.append(["pkgName": "My AiDP" as AnyObject, "imgName": "aidp-icon" as AnyObject, "pkg": "-MalAXk7gLyR3BNMusfi" as AnyObject])
                    self.floatingCrownBtn.isHidden = false
                    } else {
                        UserDefaults.standard.removeObject(forKey: "-MalAXk7gLyR3BNMusfi")

                    }
                    }
                }
                
                let userMysRmdSub = responseDic["userMysRmdSub"] as! Int
                
                if userMysRmdSub == 1 {
                    UserDefaults.standard.set("-MysRamadanwgtLoss99", forKey: "-MysRamadanwgtLoss99")
                    UserDefaults.standard.synchronize()
                   

                } else {
                    UserDefaults.standard.removeObject(forKey: "-MysRamadanwgtLoss99")
                }
                if responseDic["userMysRmdSubExpDttm"] is NSNull {
                    
                } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
                
                let expDateStr =  responseDic["userMysRmdSubExpDttm"] as! String;
                let expDate = dateFormatter.date(from: expDateStr);
                
                let currentDate = Date();
                if expDate! < currentDate {
                    UserDefaults.standard.removeObject(forKey: "-MysRamadanwgtLoss99")
//                    if userMysRmdSub == 1 {
//                    UserDefaults.standard.set("-MysRamadanwgtLoss99", forKey: "-MysRamadanwgtLoss99")
//                    UserDefaults.standard.synchronize()
//                    floatingButtonArray.append(["pkgName": "Ramadan Weight Loss" as AnyObject, "imgName": "ramadan-icon" as AnyObject, "pkg": "-MysRamadanwgtLoss99" as AnyObject])
//                    self.floatingCrownBtn.isHidden = false
//                    } else {
//                        UserDefaults.standard.removeObject(forKey: "-MysRamadanwgtLoss99")
//
//                    }
                } else {
                    if userMysRmdSub == 1 {
                    UserDefaults.standard.set("-MysRamadanwgtLoss99", forKey: "-MysRamadanwgtLoss99")
                    UserDefaults.standard.synchronize()
                    floatingButtonArray.append(["pkgName": "Ramadan Weight Loss" as AnyObject, "imgName": "ramadan-icon" as AnyObject, "pkg": "-MysRamadanwgtLoss99" as AnyObject])
                    self.floatingCrownBtn.isHidden = false
                    } else {
                        UserDefaults.standard.removeObject(forKey: "-MysRamadanwgtLoss99")

                    }
                    }
                }
                let userSubscribedToClub = responseDic["userTaeClubSub"] as! Int
                //let userSubscribedToClub = 0
                
                if userSubscribedToClub == 1 {
                    UserDefaults.standard.set("-ClubMYSheke8ebdjoWs", forKey: "-ClubMYSheke8ebdjoWs")
                    UserDefaults.standard.synchronize()
                  self.tweakandeatClubButtonView.isHidden = true
                                     self.tweakandeatClubButtonViewBottom.isHidden = true
                                     self.tweakAndEatCLubExpiryViewWithButtons.isHidden = true
                                     self.taeClubTrialPeriodExpiryView.isHidden = true


                } else {
                    
                    UserDefaults.standard.removeObject(forKey: "-ClubMYSheke8ebdjoWs")
                }
                if responseDic["userTaeClubSubExpDttm"] is NSNull {
              //      UserDefaults.standard.removeObject(forKey: "-ClubInd3gu7tfwko6Zx")

                } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
                let expDateStr =  responseDic["userTaeClubSubExpDttm"] as! String;
                let expDate = dateFormatter.date(from: expDateStr);
                
                let currentDate = Date();
                if expDate! < currentDate {
                    UserDefaults.standard.removeObject(forKey: "-ClubMYSheke8ebdjoWs")
//                    if userSubscribedToClub == 1 {
//                    UserDefaults.standard.set("-ClubMYSheke8ebdjoWs", forKey: "-ClubMYSheke8ebdjoWs")
//                    UserDefaults.standard.synchronize()
//
//                    } else {
//                        UserDefaults.standard.removeObject(forKey: "-ClubMYSheke8ebdjoWs")
//                        //self.tweakandeatClubButtonView.isHidden = false
//
//                    }


                } else {
                    if userSubscribedToClub == 1 {
                    UserDefaults.standard.set("-ClubMYSheke8ebdjoWs", forKey: "-ClubMYSheke8ebdjoWs")
                    UserDefaults.standard.synchronize()
                      floatingButtonArray.append(["pkgName": "Tweak & Eat Club" as AnyObject, "imgName": "tweak-and-eat-club-member-btn" as AnyObject, "pkg": "-ClubMYSheke8ebdjoWs" as AnyObject])
                      self.floatingCrownBtn.isHidden = false
                    } else {
                        UserDefaults.standard.removeObject(forKey: "-ClubMYSheke8ebdjoWs")
                        //self.tweakandeatClubButtonView.isHidden = false

                    }
                    }
                }
                if UserDefaults.standard.value(forKey: self.ptpPackage) != nil || UserDefaults.standard.value(forKey: "-MalAXk7gLyR3BNMusfi") != nil || UserDefaults.standard.value(forKey: "-MysRamadanwgtLoss99") != nil  || UserDefaults.standard.value(forKey: self.clubPackageSubscribed) != nil  {
                    
                    self.removePTPExpiryView()
                } else {
                    self.getStaticDateForComparison(noDays: noDays)
                }

            } else  if self.countryCode == "91" {
                let userClubAidpSub = responseDic["userClubAidpSub"] as! Int
                //let userSubscribedToClub = 0
                
                if userClubAidpSub == 1 {
                    UserDefaults.standard.set("-ClubInd4tUPXHgVj9w3", forKey: "-ClubInd4tUPXHgVj9w3")
                    UserDefaults.standard.synchronize()
                  self.tweakandeatClubButtonView.isHidden = true
                                     self.tweakandeatClubButtonViewBottom.isHidden = true
                                     self.tweakAndEatCLubExpiryViewWithButtons.isHidden = true
                                     self.taeClubTrialPeriodExpiryView.isHidden = true


                } else {
                    
                    UserDefaults.standard.removeObject(forKey: "-ClubInd4tUPXHgVj9w3")
                }
                if responseDic["userClubAidpSubExpDttm"] is NSNull {
              //      UserDefaults.standard.removeObject(forKey: "-ClubInd3gu7tfwko6Zx")

                } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
                let expDateStr =  responseDic["userClubAidpSubExpDttm"] as! String;
                let expDate = dateFormatter.date(from: expDateStr);
                    UserDefaults.standard.set(expDate, forKey: "AIDP_EXP_DATE")
                    UserDefaults.standard.synchronize()
                let currentDate = Date();
                if expDate! < currentDate {
                    UserDefaults.standard.removeObject(forKey: "-ClubInd4tUPXHgVj9w3")



                } else {
                    if userClubAidpSub == 1 {
                    UserDefaults.standard.set("-ClubInd4tUPXHgVj9w3", forKey: "-ClubUSA4tg6cvdhizQn")
                    UserDefaults.standard.synchronize()
                      floatingButtonArray.append(["pkgName": "Club Package" as AnyObject, "imgName": "clubaidp" as AnyObject, "pkg": "-ClubInd4tUPXHgVj9w3" as AnyObject])
                      self.floatingCrownBtn.isHidden = false
                    } else {
                        UserDefaults.standard.removeObject(forKey: "-ClubInd4tUPXHgVj9w3")
                        //self.tweakandeatClubButtonView.isHidden = false

                    }
                    }
                }
              
                let ptpUserSubscribed = responseDic["userIndAibpSub"] as! Int
                
                if ptpUserSubscribed == 1 {
                    UserDefaults.standard.set(PTPPackages.ptpIndiaPackage, forKey: PTPPackages.ptpIndiaPackage)
                    UserDefaults.standard.synchronize()
                   
                } else {
                     UserDefaults.standard.removeObject(forKey: PTPPackages.ptpIndiaPackage)
                    
                }
                if responseDic["userIndAibpSubExpDttm"] is NSNull {

                    UserDefaults.standard.removeObject(forKey: PTPPackages.ptpIndiaPackage)
                } else {
                    if responseDic["userIndAibpSubExpDttm"] as! String == "" {
                        
                        UserDefaults.standard.removeObject(forKey: PTPPackages.ptpIndiaPackage)
                    } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
                
                let expDateStr =  responseDic["userIndAibpSubExpDttm"] as! String;
                let expDate = dateFormatter.date(from: expDateStr);
                
                let currentDate = Date();
                if expDate! < currentDate {
                      UserDefaults.standard.removeObject(forKey: PTPPackages.ptpIndiaPackage)
//                    if ptpUserSubscribed == 1 {
//                                       UserDefaults.standard.set(PTPPackages.ptpIndiaPackage, forKey: PTPPackages.ptpIndiaPackage)
//                                       UserDefaults.standard.synchronize()
//                                      floatingButtonArray.append(["pkgName": "My AiBP" as AnyObject, "imgName": "aibp-icon" as AnyObject, "pkg": PTPPackages.ptpIndiaPackage as AnyObject])
//                                       self.floatingCrownBtn.isHidden = false
//                                       } else {
//                                           UserDefaults.standard.removeObject(forKey: PTPPackages.ptpIndiaPackage)
//
//                                       }
                    
                } else {
                    if ptpUserSubscribed == 1 {
                    UserDefaults.standard.set(PTPPackages.ptpIndiaPackage, forKey: PTPPackages.ptpIndiaPackage)
                    UserDefaults.standard.synchronize()
                   floatingButtonArray.append(["pkgName": "My AiBP" as AnyObject, "imgName": "aibp-icon" as AnyObject, "pkg": PTPPackages.ptpIndiaPackage as AnyObject])
                    self.floatingCrownBtn.isHidden = false
                    } else {
                        UserDefaults.standard.removeObject(forKey: PTPPackages.ptpIndiaPackage)

                    }
                        }
                }
                }
                self.packageNames = "Normal"


                self.userIndMyAidpSub = responseDic["userIndMyAidpSub"] as! Int
                
                if self.userIndMyAidpSub == 1 {
                    self.packageNames = "AiDP"
                    UserDefaults.standard.set("-AiDPwdvop1HU7fj8vfL", forKey: "-AiDPwdvop1HU7fj8vfL")
                    UserDefaults.standard.synchronize()
                   
                } else {
                    UserDefaults.standard.removeObject(forKey: "-AiDPwdvop1HU7fj8vfL")
                }
                if responseDic["userIndMyAidpSubExpDttm"] is NSNull {
                    
                } else {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
                    
                    let expDateStr =  responseDic["userIndMyAidpSubExpDttm"] as! String;
                    let expDate = dateFormatter.date(from: expDateStr);
                    UserDefaults.standard.set(expDate, forKey: "AIDP_EXP_DATE")
                    UserDefaults.standard.synchronize()
                    let currentDate = Date();
                    if expDate! < currentDate {
                        self.userIndMyAidpSub = 0
                        UserDefaults.standard.removeObject(forKey: "-AiDPwdvop1HU7fj8vfL")
//                        if self.userIndMyAidpSub == 1 {
//                                             UserDefaults.standard.set("-AiDPwdvop1HU7fj8vfL", forKey: "-AiDPwdvop1HU7fj8vfL")
//                                             UserDefaults.standard.synchronize()
//                                             floatingButtonArray.append(["pkgName": "My AiDP" as AnyObject, "imgName": "aidp-icon" as AnyObject, "pkg": "-AiDPwdvop1HU7fj8vfL" as AnyObject])
//                                             self.floatingCrownBtn.isHidden = false
//                                             } else {
//                                                 UserDefaults.standard.removeObject(forKey: "-AiDPwdvop1HU7fj8vfL")
//
//                                             }
                    } else {
                        if self.userIndMyAidpSub == 1 {
                        UserDefaults.standard.set("-AiDPwdvop1HU7fj8vfL", forKey: "-AiDPwdvop1HU7fj8vfL")
                        UserDefaults.standard.synchronize()
                        floatingButtonArray.append(["pkgName": "My AiDP" as AnyObject, "imgName": "aidp-icon" as AnyObject, "pkg": "-AiDPwdvop1HU7fj8vfL" as AnyObject])
                        self.floatingCrownBtn.isHidden = false
                        } else {
                            UserDefaults.standard.removeObject(forKey: "-AiDPwdvop1HU7fj8vfL")

                        }
                    }
                }
                
                 self.userSubscribedTAE = responseDic["userIndMyTaeSub"] as! Int
                
                if self.userSubscribedTAE == 1 {
                     self.packageNames = "MyTweakAndEat"
                    UserDefaults.standard.set("-IndIWj1mSzQ1GDlBpUt", forKey: "-IndIWj1mSzQ1GDlBpUt")
                    UserDefaults.standard.synchronize()
                  
                } else {
                    UserDefaults.standard.removeObject(forKey: "-IndIWj1mSzQ1GDlBpUt")
                }
                if responseDic["userIndMyTaeSubExpDttm"] is NSNull {
                    
                } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
                
                let expDateStr =  responseDic["userIndMyTaeSubExpDttm"] as! String;
                let expDate = dateFormatter.date(from: expDateStr);
                
                let currentDate = Date();
                if expDate! < currentDate {
                   
                    self.userSubscribedTAE = 0
                    UserDefaults.standard.removeObject(forKey: "-IndIWj1mSzQ1GDlBpUt")
//                    if self.userSubscribedTAE == 1 {
//                                    UserDefaults.standard.set("-IndIWj1mSzQ1GDlBpUt", forKey: "-IndIWj1mSzQ1GDlBpUt")
//                                    UserDefaults.standard.synchronize()
//
//                                    floatingButtonArray.append(["pkgName": "My Tweak & Eat" as AnyObject, "imgName": "tae-icon" as AnyObject, "pkg": "-IndIWj1mSzQ1GDlBpUt" as AnyObject])
//                                    self.floatingCrownBtn.isHidden = false
//                                    } else {
//                                        UserDefaults.standard.removeObject(forKey: "-IndIWj1mSzQ1GDlBpUt")
//
//                                    }
                } else {
                    if self.userSubscribedTAE == 1 {
                    UserDefaults.standard.set("-IndIWj1mSzQ1GDlBpUt", forKey: "-IndIWj1mSzQ1GDlBpUt")
                    UserDefaults.standard.synchronize()
                
                    floatingButtonArray.append(["pkgName": "My Tweak & Eat" as AnyObject, "imgName": "tae-icon" as AnyObject, "pkg": "-IndIWj1mSzQ1GDlBpUt" as AnyObject])
                    self.floatingCrownBtn.isHidden = false
                    } else {
                        UserDefaults.standard.removeObject(forKey: "-IndIWj1mSzQ1GDlBpUt")

                    }
                    }
                }
                
                var intermittentWLUser = responseDic["userIndWlIntSub"] as! Int
                
                if intermittentWLUser == 1 {
                     //self.packageNames = "MyTweakAndEat"
                    UserDefaults.standard.set("-IndWLIntusoe3uelxER", forKey: "-IndWLIntusoe3uelxER")
                    UserDefaults.standard.synchronize()
                  
                } else {
                    UserDefaults.standard.removeObject(forKey: "-IndWLIntusoe3uelxER")
                }
                if responseDic["userIndWlIntSubExpDttm"] is NSNull {
                    
                } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
                
                let expDateStr =  responseDic["userIndWlIntSubExpDttm"] as! String;
                let expDate = dateFormatter.date(from: expDateStr);
                
                let currentDate = Date();
                if expDate! < currentDate {
                   
                    intermittentWLUser = 0
                    UserDefaults.standard.removeObject(forKey: "-IndWLIntusoe3uelxER")
//                        if intermittentWLUser == 1 {
//                        UserDefaults.standard.set("-IndWLIntusoe3uelxER", forKey: "-IndWLIntusoe3uelxER")
//                        UserDefaults.standard.synchronize()
//
//                        floatingButtonArray.append(["pkgName": "Weight Loss with Intermittent Fasting" as AnyObject, "imgName": "if-icon" as AnyObject, "pkg": "-IndWLIntusoe3uelxER" as AnyObject])
//                        self.floatingCrownBtn.isHidden = false
//                        } else {
//                            UserDefaults.standard.removeObject(forKey: "-IndWLIntusoe3uelxER")
//
//                        }

                } else {
                    if intermittentWLUser == 1 {
                    UserDefaults.standard.set("-IndWLIntusoe3uelxER", forKey: "-IndWLIntusoe3uelxER")
                    UserDefaults.standard.synchronize()
                
                    floatingButtonArray.append(["pkgName": "Weight Loss with Intermittent Fasting" as AnyObject, "imgName": "if-icon" as AnyObject, "pkg": "-IndWLIntusoe3uelxER" as AnyObject])
                    self.floatingCrownBtn.isHidden = false
                    } else {
                        UserDefaults.standard.removeObject(forKey: "-IndWLIntusoe3uelxER")

                    }
                    }
                }
                let userSubscribedToClub = responseDic["userTaeClubSub"] as! Int
                //let userSubscribedToClub = 0
                
                if userSubscribedToClub == 1 {
                    UserDefaults.standard.set("-ClubInd3gu7tfwko6Zx", forKey: "-ClubInd3gu7tfwko6Zx")
                    UserDefaults.standard.synchronize()
                  self.tweakandeatClubButtonView.isHidden = true
                                     self.tweakandeatClubButtonViewBottom.isHidden = true
                                     self.tweakAndEatCLubExpiryViewWithButtons.isHidden = true
                                     self.taeClubTrialPeriodExpiryView.isHidden = true


                } else {
                    
                    UserDefaults.standard.removeObject(forKey: "-ClubInd3gu7tfwko6Zx")
                }
                if responseDic["userTaeClubSubExpDttm"] is NSNull {
              //      UserDefaults.standard.removeObject(forKey: "-ClubInd3gu7tfwko6Zx")

                } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
                let expDateStr =  responseDic["userTaeClubSubExpDttm"] as! String;
                let expDate = dateFormatter.date(from: expDateStr);
                
                let currentDate = Date();
                if expDate! < currentDate {
                    UserDefaults.standard.removeObject(forKey: "-ClubInd3gu7tfwko6Zx")
//                    if userSubscribedToClub == 1 {
//                    UserDefaults.standard.set("-ClubInd3gu7tfwko6Zx", forKey: "-ClubInd3gu7tfwko6Zx")
//                    UserDefaults.standard.synchronize()
//
//                    } else {
//                        UserDefaults.standard.removeObject(forKey: "-ClubInd3gu7tfwko6Zx")
//                        //self.tweakandeatClubButtonView.isHidden = false
//
//                    }


                } else {
                    if userSubscribedToClub == 1 {
                        floatingButtonArray.append(["pkgName": "Tweak & Eat Club" as AnyObject, "imgName": "tweak-and-eat-club-member-btn" as AnyObject, "pkg": "-ClubInd3gu7tfwko6Zx" as AnyObject])
                        self.floatingCrownBtn.isHidden = false
                    UserDefaults.standard.set("-ClubInd3gu7tfwko6Zx", forKey: "-ClubInd3gu7tfwko6Zx")
                    UserDefaults.standard.synchronize()

                    } else {
                        UserDefaults.standard.removeObject(forKey: "-ClubInd3gu7tfwko6Zx")
                        //self.tweakandeatClubButtonView.isHidden = false

                    }
                    }
                }
                
//                if UserDefaults.standard.value(forKey: self.ptpPackage) != nil || UserDefaults.standard.value(forKey: "-IndIWj1mSzQ1GDlBpUt") != nil || UserDefaults.standard.value(forKey: "-AiDPwdvop1HU7fj8vfL") != nil || UserDefaults.standard.value(forKey: "-IndWLIntusoe3uelxER") != nil {
//
//                    self.removePTPExpiryView()
//                } else {
//                    self.getStaticDateForComparison(noDays: noDays)
//                }
                
              
                
            }
//            if responseDic.index(forKey: "userLabelsCount") != nil {
//            let labelsCount = responseDic["userLabelsCount"] as! Int
//                UserDefaults.standard.set(labelsCount, forKey: "USER_LABELS_COUNT")
//                UserDefaults.standard.synchronize()
//
//                if labelsCount > 0 {
//                    floatingButtonArray.append(["pkgName": "Nutrition Labels" as AnyObject, "imgName": "nutritionLabels-icon" as AnyObject, "pkg": "-Qis3atRaproTlpr4zIs" as AnyObject])
//                    self.floatingCrownBtn.isHidden = false
//
//                    self.removePTPExpiryView()
//                   // self.getStaticDateForComparison(noDays: noDays)
//                } else {
//                }
//            }
            //UserDefaults.standard.set("-ClubInd3gu7tfwko6Zx", forKey: "-ClubInd3gu7tfwko6Zx")
            let sixDaysAfterCrtDttm = Calendar.current.date(byAdding: .day, value: 6, to: crtDate)!
            
            if sixDaysAfterCrtDttm > Date() {
                CleverTap.sharedInstance()?.profilePush(["Free Trial Status": 1])

            } else {
                CleverTap.sharedInstance()?.profilePush(["Free Trial Status": 0])

            }
            
            if self.countryCode == "91" {
                if UserDefaults.standard.value(forKey: self.ptpPackage) == nil && UserDefaults.standard.value(forKey: "-IndIWj1mSzQ1GDlBpUt") == nil && UserDefaults.standard.value(forKey: "-AiDPwdvop1HU7fj8vfL") == nil && UserDefaults.standard.value(forKey: "-IndWLIntusoe3uelxER") == nil && UserDefaults.standard.value(forKey: "-ClubInd3gu7tfwko6Zx") == nil && UserDefaults.standard.value(forKey: "-ClubInd4tUPXHgVj9w3") == nil {
                    let tenthAugDateStr = "2020-08-10"
                    let fifteenthAugDateStr = "2020-08-16"
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                    let tenthAugDate = formatter.date(from: tenthAugDateStr)!
                    let fifteenthAugDate = formatter.date(from: fifteenthAugDateStr)!
                    let sixDaysAfterCrtDttm = Calendar.current.date(byAdding: .day, value: 6, to: crtDate)!
                    //let sixDaysAfterCrtDttm = Calendar.current.date(byAdding: .day, value: -6, to: Date())!
                    //UserDefaults.standard.set("YES", forKey: "NEW_USER")
                    //UserDefaults.standard.removeObject(forKey: "NEW_USER")
                   
                    if crtDate < tenthAugDate {
                        let currentDate = Date()
                        if currentDate < fifteenthAugDate {
                            self.tweakandeatClubButtonView.isHidden = false
                            self.tweakandeatClubButtonViewBottom.isHidden = false
                            self.tweakAndEatCLubExpiryViewWithButtons.isHidden = true
                            self.taeClubTrialPeriodExpiryView.isHidden = true
                            self.topImageView.isHidden = false
                            self.trialPeriodExpired = false
                            if (self.tweakCount > 0) {
                                UserDefaults.standard.removeObject(forKey: "NEW_USER")
                                self.checkIfUserIsNewOrTrialPeriodExpired()
                            } else {
                            UserDefaults.standard.set("YES", forKey: "NEW_USER")
                            self.checkIfUserIsNewOrTrialPeriodExpired()
                            }

                        } else {
                            self.tweakandeatClubButtonView.isHidden = true
                            self.tweakandeatClubButtonViewBottom.isHidden = false
                            self.tweakAndEatCLubExpiryViewWithButtons.isHidden = false
                            self.topImageView.isHidden = true
                            self.showTrialPeriodView()
                            self.trialPeriodExpired = true
                            if self.tweakCount > 0 {
                                UserDefaults.standard.removeObject(forKey: "NEW_USER")
                                self.checkIfUserIsNewOrTrialPeriodExpired()
                            } else {
                                UserDefaults.standard.set("YES", forKey: "NEW_USER")
                                self.checkIfUserIsNewOrTrialPeriodExpired()
                            }

                        }
                    } else  {
                        if sixDaysAfterCrtDttm > Date() {
                            self.tweakandeatClubButtonView.isHidden = false
                            self.tweakandeatClubButtonViewBottom.isHidden = false
                            self.tweakAndEatCLubExpiryViewWithButtons.isHidden = true
                            self.taeClubTrialPeriodExpiryView.isHidden = true
                            self.topImageView.isHidden = false
                            self.trialPeriodExpired = false
                            if self.tweakCount > 0 {
                                UserDefaults.standard.removeObject(forKey: "NEW_USER")
                                self.checkIfUserIsNewOrTrialPeriodExpired()
                            } else {
                            UserDefaults.standard.set("YES", forKey: "NEW_USER")
                            self.checkIfUserIsNewOrTrialPeriodExpired()
                            }

                        } else {
                            self.tweakandeatClubButtonView.isHidden = true
                            self.tweakandeatClubButtonViewBottom.isHidden = false
                            self.tweakAndEatCLubExpiryViewWithButtons.isHidden = false
                            self.topImageView.isHidden = true
                            
                            self.showTrialPeriodView()
                            self.trialPeriodExpired = true
//                            let randomNum = Int.random(in: 1...2)
//                                               if randomNum == 1 {
//                                                   UserDefaults.standard.set("YES", forKey: "NEW_USER")
//                                                   self.checkIfUserIsNewOrTrialPeriodExpired()
//                                               } else {
//                                                   UserDefaults.standard.removeObject(forKey: "NEW_USER")
//                                                   self.checkIfUserIsNewOrTrialPeriodExpired()
//                                               }
                            if self.tweakCount > 0 {
                                UserDefaults.standard.removeObject(forKey: "NEW_USER")

                                self.checkIfUserIsNewOrTrialPeriodExpired()
                            } else {
                                UserDefaults.standard.set("YES", forKey: "NEW_USER")
                                self.checkIfUserIsNewOrTrialPeriodExpired()
                            }

                        }
                    }
                    
                    //ClubInd4tUPXHgVj9w3
                } else if UserDefaults.standard.value(forKey: self.ptpPackage) != nil || UserDefaults.standard.value(forKey: "-IndIWj1mSzQ1GDlBpUt") != nil || UserDefaults.standard.value(forKey: "-AiDPwdvop1HU7fj8vfL") != nil || UserDefaults.standard.value(forKey: "-IndWLIntusoe3uelxER") != nil || UserDefaults.standard.value(forKey: "-ClubInd3gu7tfwko6Zx") != nil || UserDefaults.standard.value(forKey: self.clubPackageSubscribed) != nil || UserDefaults.standard.value(forKey: "-ClubInd4tUPXHgVj9w3") != nil  {
                    self.tweakandeatClubButtonView.isHidden = true
                    self.tweakandeatClubButtonViewBottom.isHidden = true
                    self.tweakAndEatCLubExpiryViewWithButtons.isHidden = true
                    self.taeClubTrialPeriodExpiryView.isHidden = true
                    self.topImageView.isHidden = false
                    self.trialPeriodExpired = false
                    if (responseDic["tweakTotal"] as! Int) > 0 {
                        UserDefaults.standard.removeObject(forKey: "NEW_USER")
                        self.checkIfUserIsNewOrTrialPeriodExpired()
                    } else {
                        UserDefaults.standard.set("YES", forKey: "NEW_USER")
                        self.checkIfUserIsNewOrTrialPeriodExpired()
                    }
                    self.removePTPExpiryView()
                                  } else {
                    //self.showTrialPeriodView()
                                  }
            } else if self.countryCode == "62" {
                            if UserDefaults.standard.value(forKey: self.ptpPackage) == nil && UserDefaults.standard.value(forKey: self.clubPackageSubscribed) == nil && UserDefaults.standard.value(forKey: "-IdnMyAiDPoP9DFGkbas") == nil {
                                let tenthAugDateStr = "2020-08-10"
                                let fifteenthAugDateStr = "2020-08-16"
                                let formatter = DateFormatter()
                                formatter.dateFormat = "yyyy-MM-dd"
                                let tenthAugDate = formatter.date(from: tenthAugDateStr)!
                                let fifteenthAugDate = formatter.date(from: fifteenthAugDateStr)!
                                let sixDaysAfterCrtDttm = Calendar.current.date(byAdding: .day, value: 6, to: crtDate)!
                                //let sixDaysAfterCrtDttm = Calendar.current.date(byAdding: .day, value: -6, to: Date())!
                                //UserDefaults.standard.set("YES", forKey: "NEW_USER")
                                //UserDefaults.standard.removeObject(forKey: "NEW_USER")
                               
                                if crtDate < tenthAugDate {
                                    let currentDate = Date()
                                    if currentDate < fifteenthAugDate {
//                                        self.tweakandeatClubButtonView.isHidden = false
//                                        self.tweakandeatClubButtonViewBottom.isHidden = false
//                                        self.tweakAndEatCLubExpiryViewWithButtons.isHidden = true
//                                        self.taeClubTrialPeriodExpiryView.isHidden = true
                                        self.topImageView.isHidden = false
                                        self.trialPeriodExpired = false
                                        if self.tweakCount > 0 {
                                            UserDefaults.standard.removeObject(forKey: "NEW_USER")
                                            self.checkIfUserIsNewOrTrialPeriodExpired()
                                        } else {
                                        UserDefaults.standard.set("YES", forKey: "NEW_USER")
                                        self.checkIfUserIsNewOrTrialPeriodExpired()
                                        }

                                    } else {
//                                        self.tweakandeatClubButtonView.isHidden = true
//                                        self.tweakandeatClubButtonViewBottom.isHidden = false
//                                        self.tweakAndEatCLubExpiryViewWithButtons.isHidden = false
                                        self.topImageView.isHidden = true
                                        self.showTrialPeriodView()
                                        self.trialPeriodExpired = true
                                        if self.tweakCount > 0 {
                                            UserDefaults.standard.removeObject(forKey: "NEW_USER")
                                            self.checkIfUserIsNewOrTrialPeriodExpired()
                                        } else {
                                            UserDefaults.standard.set("YES", forKey: "NEW_USER")
                                            self.checkIfUserIsNewOrTrialPeriodExpired()
                                        }

                                    }
                                } else  {
                                    if sixDaysAfterCrtDttm > Date() {
//                                        self.tweakandeatClubButtonView.isHidden = false
//                                        self.tweakandeatClubButtonViewBottom.isHidden = false
//                                        self.tweakAndEatCLubExpiryViewWithButtons.isHidden = true
//                                        self.taeClubTrialPeriodExpiryView.isHidden = true
                                        self.topImageView.isHidden = false
                                        self.trialPeriodExpired = false
                                        if self.tweakCount > 0 {
                                            UserDefaults.standard.removeObject(forKey: "NEW_USER")
                                            self.checkIfUserIsNewOrTrialPeriodExpired()
                                        } else {
                                        UserDefaults.standard.set("YES", forKey: "NEW_USER")
                                        self.checkIfUserIsNewOrTrialPeriodExpired()
                                        }

                                    } else {
//                                        self.tweakandeatClubButtonView.isHidden = true
//                                        self.tweakandeatClubButtonViewBottom.isHidden = false
//                                        self.tweakAndEatCLubExpiryViewWithButtons.isHidden = false
                                        self.topImageView.isHidden = true
                                        
                                        self.showTrialPeriodView()
                                        self.trialPeriodExpired = true
            
                                        if self.tweakCount > 0 {
                                            UserDefaults.standard.removeObject(forKey: "NEW_USER")

                                            self.checkIfUserIsNewOrTrialPeriodExpired()
                                        } else {
                                            UserDefaults.standard.set("YES", forKey: "NEW_USER")
                                            self.checkIfUserIsNewOrTrialPeriodExpired()
                                        }

                                    }
                                }
                                
                                
                            } else if UserDefaults.standard.value(forKey: self.ptpPackage) == nil || UserDefaults.standard.value(forKey: "-ClubIdn4hd8flchs9Vy") == nil || UserDefaults.standard.value(forKey: "-IdnMyAiDPoP9DFGkbas") == nil || UserDefaults.standard.value(forKey: self.clubPackageSubscribed) == nil  {
//                                self.tweakandeatClubButtonView.isHidden = true
//                                self.tweakandeatClubButtonViewBottom.isHidden = true
//                                self.tweakAndEatCLubExpiryViewWithButtons.isHidden = true
//                                self.taeClubTrialPeriodExpiryView.isHidden = true
                                self.topImageView.isHidden = false
                                self.trialPeriodExpired = false
                                if self.tweakCount > 0 {
                                    UserDefaults.standard.removeObject(forKey: "NEW_USER")
                                    self.checkIfUserIsNewOrTrialPeriodExpired()
                                } else {
                                    UserDefaults.standard.set("YES", forKey: "NEW_USER")
                                    self.checkIfUserIsNewOrTrialPeriodExpired()
                                }
                                self.removePTPExpiryView()
                                              } else {
                                //self.showTrialPeriodView()
                                              }
                        } else if self.countryCode == "60" {
                                    //UserDefaults.standard.value(forKey: "-MysRamadanwgtLoss99") != nil
                                    if UserDefaults.standard.value(forKey: self.ptpPackage) != nil || UserDefaults.standard.value(forKey: "-IndIWj1mSzQ1GDlBpUt") != nil || UserDefaults.standard.value(forKey: "-AiDPwdvop1HU7fj8vfL") != nil || UserDefaults.standard.value(forKey: "-MalAXk7gLyR3BNMusfi") != nil || UserDefaults.standard.value(forKey: "-MzqlVh6nXsZ2TCdAbOp") != nil || UserDefaults.standard.value(forKey: "-IdnMyAiDPoP9DFGkbas") != nil || UserDefaults.standard.value(forKey: "-SgnMyAiDPuD8WVCipga") != nil || UserDefaults.standard.value(forKey: "-MysRamadanwgtLoss99") != nil || UserDefaults.standard.value(forKey: "-IndWLIntusoe3uelxER") != nil || UserDefaults.standard.value(forKey: "-ClubInd3gu7tfwko6Zx") != nil || UserDefaults.standard.value(forKey: self.clubPackageSubscribed) != nil {
                                        self.trialPeriodExpired = false

                                                           self.removePTPExpiryView()
                                                      } else {
                                                        self.trialPeriodExpired = true
                                                      self.getStaticDateForComparison(noDays: noDays)
                                                      }
                if (responseDic["tweakTotal"] as! Int) > 0 {
                    UserDefaults.standard.removeObject(forKey: "NEW_USER")
                    self.checkIfUserIsNewOrTrialPeriodExpired()
                } else {
                    UserDefaults.standard.set("YES", forKey: "NEW_USER")
                    self.checkIfUserIsNewOrTrialPeriodExpired()
                }
                                } else  {
                    
                                if UserDefaults.standard.value(forKey: self.ptpPackage) != nil || UserDefaults.standard.value(forKey: "-IndIWj1mSzQ1GDlBpUt") != nil || UserDefaults.standard.value(forKey: "-AiDPwdvop1HU7fj8vfL") != nil || UserDefaults.standard.value(forKey: "-MalAXk7gLyR3BNMusfi") != nil || UserDefaults.standard.value(forKey: "-MzqlVh6nXsZ2TCdAbOp") != nil || UserDefaults.standard.value(forKey: "-IdnMyAiDPoP9DFGkbas") != nil || UserDefaults.standard.value(forKey: "-SgnMyAiDPuD8WVCipga") != nil || UserDefaults.standard.value(forKey: "-IndWLIntusoe3uelxER") != nil || UserDefaults.standard.value(forKey: self.clubPackageSubscribed) != nil || UserDefaults.standard.value(forKey: "-ClubInd4tUPXHgVj9w3") != nil  || UserDefaults.standard.value(forKey: "-ClubUsa5nDa1M8WcRA6") != nil  {

                                    self.trialPeriodExpired = false
                                     self.removePTPExpiryView()
                                } else {
                                self.getStaticDateForComparison(noDays: noDays)
                                }
                if (responseDic["tweakTotal"] as! Int) > 0 {
                    UserDefaults.standard.removeObject(forKey: "NEW_USER")
                    self.checkIfUserIsNewOrTrialPeriodExpired()
                } else {
                    UserDefaults.standard.set("YES", forKey: "NEW_USER")
                    self.checkIfUserIsNewOrTrialPeriodExpired()
                }
                                }

            if UserDefaults.standard.value(forKey: "-ClubInd3gu7tfwko6Zx") != nil {
                self.taeClubMemberTopButton.isHidden = false
                self.taeClubMemberBottomButton.isHidden = false
                self.taeClubMemberTopView.isHidden = false
                self.taeClubMemberBottomView.isHidden = false
                self.getClubHome3()
                          } else {
                self.taeClubMemberTopButton.isHidden = true
                self.taeClubMemberBottomButton.isHidden = true
                self.taeClubMemberTopView.isHidden = true
                self.taeClubMemberBottomView.isHidden = true
               

            }
            let userNcPkgSub = responseDic["userNcPkgSub"] as! Int
            //let userSubscribedToClub = 0
            
            if userNcPkgSub == 1 {
                UserDefaults.standard.set("-NcInd5BosUcUeeQ9Q32", forKey: "-NcInd5BosUcUeeQ9Q32")
                UserDefaults.standard.synchronize()
                floatingButtonArray.append(["pkgName": "Nutritionist Consultant" as AnyObject, "imgName": "Nutritionist Consultant" as AnyObject, "pkg": "-NcInd5BosUcUeeQ9Q32" as AnyObject])
                self.floatingCrownBtn.isHidden = false
            


            } else {
                
                UserDefaults.standard.removeObject(forKey: "-NcInd5BosUcUeeQ9Q32")
            }

            self.setupSubscribeNowButton()
            if self.countryCode == "91" {
             self.getClubHome1()
            // self.getClubHome2()
             //self.getClub1Info()
             }

            if floatingButtonArray.count > 0 {
                self.floatingButtonsArray = floatingButtonArray
                UserDefaults.standard.setValue(self.floatingButtonsArray, forKey: "FLOATING_BUTTONS_ARRAY")
                UserDefaults.standard.synchronize()
            }
            
            let tweakStreakCountValue = responseDic["tweakStreak"] as! Int
            //     DispatchQueue.main.async { tweakTotal
            self.totalTweakCount =  String(responseDic["tweakTotal"] as! Int)

            self.tweakCountLbl.text = String(tweakStreakCountValue)
            self.tweakStreakCount = String(tweakStreakCountValue)
            

            UserDefaults.standard.set(responseDic["tweakTotal"] as! Int, forKey: "TWEAK_COUNT")
            UserDefaults.standard.synchronize()
           // self.tweakStreakLbl.text = self.bundle.localizedString(forKey: "my_tweak_streak", value: nil, table: nil)
            //   }
            self.showBadge()
            UserDefaults.standard.setValue(responseDic["userStatus"], forKey: "userStatusInfo")
            
            let userStatus = responseDic["userStatus"] as! Int
            
            if  userStatus ==  1 {
                self.firebaseTopicNames()
                
                if responseDic.index(forKey: "cloudClickable") != nil {
                    
                    if responseDic["cloudClickable"] as! Bool == true {
                        self.cloudTapped = UITapGestureRecognizer(target: self, action: #selector(self.tappedOnCloudBubbleImage))
                        self.cloudTapped.numberOfTapsRequired = 1
                        self.cloudBubbleImage.isUserInteractionEnabled = true;
                        self.cloudBubbleImage?.addGestureRecognizer(self.cloudTapped)
                    } else {
                        self.cloudBubbleImage.removeGestureRecognizer(self.cloudTapped)
                    }
                } else {
                    self.cloudBubbleImage.removeGestureRecognizer(self.cloudTapped)
                    
                }
                self.randomMessages.stopBlink()
                
                if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
                    
                    if self.countryCode == "91" {
                        if UserDefaults.standard.value(forKey: "PREMIUM_MEMBER") != nil {
                            
                            self.randomMessages.stopBlink()
                        } else {
                            self.randomMessages.startBlink()
                            
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    self.randomMessages.text = responseDic["homeMessage"] as! String

                    
                    
                    // self.roundImageView.sd_setImage(with: URL(string: responseDic["homeImage"] as! String), placeholderImage: UIImage.init(named: "defaultRecipe.jpg"))
                    self.foodImageView.sd_setImage(with: URL(string: responseDic["homeImage"] as! String), placeholderImage: UIImage.init(named: "defaultRecipe.jpg"))
                }
                if self.trialPeriodExpired == true {
                    self.tapToTweakView.isHidden = true
                } else {
                    if self.tapToTweak == true {
                        self.checkTweakable()
                    }
                }
               
                
               

               
                
                if (UserDefaults.standard.value(forKey: "HEALTHKIT") != nil &&  UserDefaults.standard.value(forKey: "FITBIT_TOKEN") == nil) {
                    DispatchQueue.global().async() {
                        if UserDefaults.standard.value(forKey: "LAST7DAYS") != nil {
                            
                            let last7Days = UserDefaults.standard.value(forKey: "LAST7DAYS") as! [String]
                            if (last7Days.contains(Date.getWantedDate(forLastNDays: 1)) && last7Days.contains(Date.getWantedDate(forLastNDays: 2)) && last7Days.contains(Date.getWantedDate(forLastNDays: 3)) && last7Days.contains(Date.getWantedDate(forLastNDays: 4)) && last7Days.contains(Date.getWantedDate(forLastNDays: 5)) && last7Days.contains(Date.getWantedDate(forLastNDays: 6)) && last7Days.contains(Date.getWantedDate(forLastNDays: 7)))   {
                                
                            } else {
                                
                                self.getHealthActivitiesData()
                                
                            }
                        }
                    }
                }
                
                if (UserDefaults.standard.value(forKey: "FITBIT_TOKEN") != nil && UserDefaults.standard.value(forKey: "HEALTHKIT") == nil) {
                    
                    if UserDefaults.standard.value(forKey: "LAST7DAYS") != nil {
                        
                        let last7Days = UserDefaults.standard.value(forKey: "LAST7DAYS") as! [String]
                        if (last7Days.contains(Date.getWantedDate(forLastNDays: 1)) && last7Days.contains(Date.getWantedDate(forLastNDays: 2)) && last7Days.contains(Date.getWantedDate(forLastNDays: 3)) && last7Days.contains(Date.getWantedDate(forLastNDays: 4)) && last7Days.contains(Date.getWantedDate(forLastNDays: 5)) && last7Days.contains(Date.getWantedDate(forLastNDays: 6)) && last7Days.contains(Date.getWantedDate(forLastNDays: 7)))   {
                            
                        } else {
                            self.fitBitSyncView.isHidden = false
                            self.spinner.startAnimating()
                            let dispatch_group = DispatchGroup()
                            dispatch_group.enter()
                            for i in 1 ... 7 {
                                if !(last7Days.contains(Date.getWantedDate(forLastNDays: i))) {
                                    self.getActivities(selectedDate: Date.getWantedDate(forLastNDays: i))
                                }
                            }
                            dispatch_group.leave()
                            dispatch_group.notify(queue: DispatchQueue.main) {
                                self.fitBitSyncView.isHidden = true
                                self.spinner.stopAnimating()
                                let last7Days = Date.getDates(forLastNDays: 7)
                                
                                UserDefaults.standard.set(last7Days as Any as! [String], forKey: "LAST7DAYS")
                            }
                            
                        }
                    }
                }
                
            }
            else if  userStatus == 0 {
                UserDefaults.standard.removeObject(forKey: "userSession")
                UserDefaults.standard.removeObject(forKey: "showRegistration")
                UserDefaults.standard.setValue("YES", forKey: "USERBLOCKED")
                self.deleteAllData(entity: "TBL_Tweaks")
                self.deleteAllData(entity: "TBL_Contacts")
                self.deleteAllData(entity: "TBL_Reminders")
                self.alert()
                self.del()
                
            }
           // UserDefaults.standard.removeObject(forKey: "-IndIWj1mSzQ1GDlBpUt")
            
        }, failure : { error in
            
            //            let alertController = UIAlertController(title: self.bundle.localizedString(forKey: "no_internet", value: nil, table: nil), message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil), preferredStyle: UIAlertController.Style.alert)
            //
            //            let defaultAction = UIAlertAction(title:  self.bundle.localizedString(forKey: "ok", value: nil, table: nil), style: .cancel, handler: nil)
            //            alertController.addAction(defaultAction)
            //            self.present(alertController, animated: true, completion: nil)
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true);
                }
        })
        
//        let randomInt = Int.random(in: 0...1)
//        if randomInt == 0 {
//            //DispatchQueue.main.async {
//                            self.dummyNav2(packageIDs: "-IndIWj1mSzQ1GDlBpUt", identifier: "MYTAE_PUR_IND_OP_3M")
//
//           // }
//        } else {
//           // DispatchQueue.main.async {
//                            self.dummyNav2(packageIDs: "-IndWLIntusoe3uelxER", identifier: "WLIF_PUR_IND_OP_3M")
//
//            //}
//
//        }
        
    }
    
    @objc func getActivities(selectedDate: String) {
        FitbitAPI.sharedInstance.authorize(with: UserDefaults.standard.value(forKey: "FITBIT_TOKEN") as! String)
        let datePath = "https://api.fitbit.com/1/user/-/activities/date/\(selectedDate).json"
        
        guard let session = FitbitAPI.sharedInstance.session,
            let stepURL = URL(string: datePath) else {
                return
        }
        let dataTask = session.dataTask(with: stepURL) { (data, response, error) in
            guard let response = response as? HTTPURLResponse, response.statusCode < 300 else {
                 DispatchQueue.main.async {
                self.fitBitSyncView.isHidden = true
                self.spinner.stopAnimating()
                     TweakAndEatUtils.AlertView.showAlert(view: self, message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil))
                }
               
                return
            }
            
            guard let data = data,
                let dictionary = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String: AnyObject] else {
                    DispatchQueue.main.async {

                    self.fitBitSyncView.isHidden = true
                    self.spinner.stopAnimating()
                    }
                    self.disconnectDevice(token: UserDefaults.standard.value(forKey: "FITBIT_TOKEN") as! String)
                    
                    return
            }
            self.sendFitBitData(dateString: selectedDate, fitBitDictionary: dictionary as NSDictionary)
            
        }
        dataTask.resume()
    }
    
    @objc func base64String(_ string: String) -> String {
        // Create NSData object
        let nsdata: Data? = string.data(using: .utf8)
        // Get NSString from NSData object in Base64
        let base64Encoded = nsdata?.base64EncodedString(options: [])
        return base64Encoded ?? ""
    }
    
    
    @objc func disconnectDevice(token: String) {
        
        DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view, animated: true);
                }
        let clientID = FitBitDetails.clientID
        let clientSecret = FitBitDetails.clientSecret
        let base64 = base64String("\(clientID):\(clientSecret)")
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization": "Basic \(base64)"
        ]
        let parameters = ["token": token]
        
        AF.request("https://api.fitbit.com/oauth2/revoke", method: .post, parameters: parameters, encoding:  URLEncoding.httpBody, headers: headers).responseJSON { (response:AFDataResponse<Any>) in
            
            switch(response.result) {
            case.success(let data):
                print("success",data)
                DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true);
                }
                
                UserDefaults.standard.removeObject(forKey: "FITBIT_TOKEN")
                let alertController = UIAlertController(title: "DISCONNECTED!", message: "You've been logged out from FITBIT. Please goto My Fitness and try logging in again to stay connected with FitBit. You will be logged out after one day if you select only 1 day access to your Fitbit data while logging in.", preferredStyle: UIAlertController.Style.alert)
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    NSLog("OK Pressed")
                    
                }
                
                // Add the actions
                alertController.addAction(okAction)
                
                // Present the controller
                self.present(alertController, animated: true, completion: nil)
                
            case.failure(let error):
                print("Not Success",error)
                DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true);
                }
                
                //TweakAndEatUtils.AlertView.showAlert(view: self, message: "Your internet connection is appears to be offline !!")
            }
        }
    }
    
    @objc func sendFitBitData(dateString: String, fitBitDictionary: NSDictionary) {
        let activities = fitBitDictionary["summary"] as AnyObject as! NSDictionary
        var floors = ""
        if let floorsVal = activities["floors"]  {
            floors = "\(floorsVal as! Int64)"
        } else {
            floors = "0"
        }
        var km = ""
        let distanceArray = activities["distances"] as! NSArray
        let distanceDict = distanceArray[0] as! NSDictionary
        km = "\(distanceDict["distance"] as! Double)"
        let paramsDictionary = ["date": dateString,
                                "steps": "\(activities["steps"] as! Int64)",
            "floors": floors,
            "distance": km,
            "activeMins": "\(activities["veryActiveMinutes"] as! Int64)",
            "calories": "\(activities["caloriesOut"] as! Int64)",
            "deviceType": "1"]
        
        APIWrapper.sharedInstance.postRequestWithHeaderMethod(TweakAndEatURLConstants.UPDATE_FITNESS_DATA, userSession: UserDefaults.standard.value(forKey: "userSession") as! String,parameters: paramsDictionary as [String : AnyObject] , success: { response in
            print(response)
            
            let responseDic : [String:AnyObject] = response as! [String:AnyObject];
            let responseResult = responseDic["CallStatus"] as! String
            if  responseResult == "GOOD" {
                
            }
        }, failure : { error in
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true);
                }
            self.fitBitSyncView.isHidden = true
            self.spinner.stopAnimating()
            
            print("failure")
            //            TweakAndEatUtils.AlertView.showAlert(view: self, message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil))
            
        })
        
    }
    
    // delete all records fom CoreData
    @objc func deleteAllData(entity: String)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
    
    //deleting realm data for blocked user
    @objc func del(){
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    @objc func reachabilityChanged(notification : NSNotification) {
        
    }
    
    @objc func showNetworkFailureScreen() {
        if(tweakNoNetworkView == nil) {
            tweakNoNetworkView = (Bundle.main.loadNibNamed("TweakAndEatNOIntenetVIew", owner: self, options: nil)! as NSArray).firstObject as! TweakAndEatNOIntenetVIew;
            tweakNoNetworkView.frame = self.view.frame;
            tweakNoNetworkView.beginning();
            self.view.addSubview(tweakNoNetworkView);
        } else {
            self.view.addSubview(tweakNoNetworkView);
        }
    }
    @objc func switchToSecondScreen() {
        if(self.introTextArray != nil && (self.introTextArray?.count)! > 0) {
            
            tweakTextView = (Bundle.main.loadNibNamed("TweakAndEatWelcomeScreen", owner: self, options: nil)! as NSArray).firstObject as! TweakAndEatWelcomeScreen;
            tweakTextView.frame = self.view.frame;
            tweakTextView.delegate = self;
            tweakTextView.beginning();
            self.view.addSubview(tweakTextView);
            self.tweakTextView.welcomeLabel.text = bundle.localizedString(forKey: "intro_welcome", value: nil, table: nil)
            self.tweakTextView.howItWorksLbl.text = bundle.localizedString(forKey: "intro_how_to", value: nil, table: nil)
            self.tweakTextView.okBtn.setTitle(bundle.localizedString(forKey: "ok", value: nil, table: nil), for: .normal)
            
            tweakView.removeFromSuperview();
            
            let introTextDic = self.introTextArray!.filter({ (element) -> Bool in
                if((element as! NSDictionary).value(forKey: TweakAndEatConstants.STATIC_NAME) as! String == TweakAndEatConstants.DATA_TEXT) {
                    return true;
                } else {
                    return false;
                }
            })
            
            var welcomeText : String? = nil;
            
            if(introTextDic.count > 0) {
                welcomeText = (introTextDic[0] as! NSDictionary).value(forKey: TweakAndEatConstants.STATIC_VALUE) as? String;
            }
            
            if(welcomeText != nil) {
                self.changeFonts((welcomeText!.html2AttributedString.mutableCopy()) as! NSMutableAttributedString);
            }
            
        }
    }
    
    @objc func switchToThirdScreen() {
        
        tweakOTPView = (Bundle.main.loadNibNamed("TweakAndEatOTPView", owner: self, options: nil)! as NSArray).firstObject as! TweakAndEatOTPView;
        tweakOTPView.frame = self.view.frame;
        tweakOTPView.delegate = self;
        tweakOTPView.beginning();
        self.view.addSubview(tweakOTPView);
        
        self.tweakOTPView.welcomeLabel.text = bundle.localizedString(forKey: "intro_welcome", value: nil, table: nil)
        self.tweakOTPView.numberHintLabel.text = bundle.localizedString(forKey: "not_required_zero", value: nil, table: nil)
        self.tweakOTPView.doneBarButton.title = bundle.localizedString(forKey: "action_done", value: nil, table: nil)
        self.tweakOTPView.cancelBarButton.title = bundle.localizedString(forKey: "action_cancel", value: nil, table: nil)
        self.tweakOTPView.otpLangDescLabel.text = bundle.localizedString(forKey: "preferred_language", value: nil, table: nil); self.tweakOTPView.sendANDVerifyButton.setTitle(bundle.localizedString(forKey: "button_send_code", value: nil, table: nil), for: .normal)
        self.tweakOTPView.resendButton.setTitle(bundle.localizedString(forKey: "button_resend", value: nil, table: nil), for: .normal)
        
        let networkInfo = CTTelephonyNetworkInfo();
        let carrier = networkInfo.subscriberCellularProvider;
        let countryCode = carrier?.isoCountryCode?.uppercased();
        if(countryCode == nil) {
            self.tweakOTPView.flagImage.isHidden = false
            self.tweakOTPView.countryCodeBtn.isUserInteractionEnabled = true
            self.tweakOTPView.countryCodeTextField.isHidden = false
            self.tweakOTPView.countryCodesParentView.isHidden = false
            self.tweakOTPView.countryCodeTextField.delegate = self
            self.tweakOTPView.countryCodePickerView.delegate = self
            self.tweakOTPView.countryCodePickerView.dataSource = self
            self.getAllCountryCodes()
            //            let locale = Locale.current
            //            print(locale.regionCode!)
            //            if locale.regionCode! == "US" {
            //                self.tweakOTPView.countryCodesParentView.isHidden = true
            //
            //                self.tweakOTPView.countryCodeLabel.text = "+1" ;
            //                UserDefaults.standard.setValue("1", forKey: "COUNTRY_CODE")
            //                self.getCountryIsd(country: "US")
            //            } else {
            //
            //            }
            
        } else {
            self.tweakOTPView.countryCodeBtn.isUserInteractionEnabled = false
            self.tweakOTPView.countryCodesParentView.isHidden = true
            
            let country = carrier?.isoCountryCode
            self.tweakOTPView.countryCodeLabel.text = "+\(getCountryPhonceCode(countryCode!))" ;
            UserDefaults.standard.setValue(getCountryPhonceCode(countryCode!), forKey: "COUNTRY_CODE")
            self.getCountryIsd(country: country!)
        }
      //  tweakTextView.removeFromSuperview();
        tweakView.removeFromSuperview();

        
    }
    
    @objc func switchToFourthScreen() {
        
        print(Realm.Configuration.defaultConfiguration.fileURL!);
        appDelegateTAE.networkReconnectionBlock = {
            TweakAndEatUtils.showMBProgressHUD();
            APIWrapper.sharedInstance.getAgeGroups({ (responceDic : AnyObject!) -> (Void) in
                if(TweakAndEatUtils.isValidResponse(responceDic as? [String:AnyObject])) {
                    let response : [String:AnyObject] = responceDic as! [String:AnyObject];
                    
                    if(response[TweakAndEatConstants.CALL_STATUS] as! String == TweakAndEatConstants.TWEAK_STATUS_GOOD) {
                        let ageGroups : [AnyObject]? = response[TweakAndEatConstants.DATA] as? [AnyObject];
                        
                        if(ageGroups != nil && (ageGroups?.count)! > 0) {
                            self.tweakOptionView = (Bundle.main.loadNibNamed("TweakAndEatOptionsView", owner: self, options: nil)! as NSArray).firstObject as! TweakAndEatOptionsView;
                            self.tweakOptionView.frame = self.view.frame;
                            self.view.addSubview(self.tweakOptionView);
                            self.tweakOptionView.weightTextField.delegate = self
                            self.tweakOptionView.heightTextField.delegate = self
                            self.tweakOptionView.bmiPickerView.delegate = self
                            self.tweakOptionView.bmiPickerView.dataSource = self
                            
                            self.tweakOTPView.removeFromSuperview();
                            self.tweakOptionView.beginning();
                            
                            self.tweakOptionView.nickNameLabel.text = self.bundle.localizedString(forKey: "nick_name", value: nil, table: nil);
                            self.tweakOptionView.ageLabel.text = self.bundle.localizedString(forKey: "register_age", value: nil, table: nil);
                            self.tweakOptionView.genderLabel.text = self.bundle.localizedString(forKey: "register_sex", value: nil, table: nil);
                            self.tweakOptionView.weightLabel.text = self.bundle.localizedString(forKey: "register_weight", value: nil, table: nil);
                            self.tweakOptionView.heightLabel.text = self.bundle.localizedString(forKey: "register_height", value: nil, table: nil);
                            self.tweakOptionView.selectBodyShapeLbl.text =
                                self.bundle.localizedString(forKey: "register_body_shape", value: nil, table: nil); self.tweakOptionView.nextButton.setTitle(self.bundle.localizedString(forKey: "next", value: nil, table: nil), for: .normal);
                            self.tweakOptionView.genderPrevBtn.setTitle(self.bundle.localizedString(forKey: "prev", value: nil, table: nil), for: .normal);
                            self.tweakOptionView.genderOkBtn.setTitle(self.bundle.localizedString(forKey: "ok", value: nil, table: nil), for: .normal);
                            self.tweakOptionView.pickerViewDone.title = self.bundle.localizedString(forKey: "action_done", value: nil, table: nil);
                            
                            self.tweakOptionView.delegate = self;
                            
                            self.perform(#selector(WelcomeViewController.setAgeAndGenderView(_:)), with: ageGroups, afterDelay: 1.0);
                        } else {
                            TweakAndEatUtils.hideMBProgressHUD();
                        }
                    }
                } else {
                    //error
                    TweakAndEatUtils.hideMBProgressHUD();
                }
            }) { (error : NSError!) -> (Void) in
                //error
                TweakAndEatUtils.hideMBProgressHUD();
                //self.premiumIconBarButton.isEnabled = true;
                let alertController = UIAlertController(title: self.bundle.localizedString(forKey: "no_internet", value: nil, table: nil), message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil), preferredStyle: UIAlertController.Style.alert)
                
                let defaultAction = UIAlertAction(title:  self.bundle.localizedString(forKey: "ok", value: nil, table: nil), style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        appDelegateTAE.networkReconnectionBlock!();
    }
    
    @objc func switchToFifthScreen() {
        
        self.tweakSelection = (Bundle.main.loadNibNamed("TweakAndEatSelectionView", owner: self, options: nil)! as NSArray).firstObject as! TweakAndEatSelectionView;
        tweakSelection.frame = self.view.frame;
        tweakSelection.delegate = self;
        tweakSelection.beginning();
        tweakSelection.setUpViews()
        self.view.addSubview(tweakSelection);
        self.tweakSelection.foodHabitsLabel.text = bundle.localizedString(forKey: "food_type", value: nil, table: nil);
        self.tweakSelection.allergiesLabel.text = bundle.localizedString(forKey: "allergies", value: nil, table: nil);
        
        self.tweakSelection.conditionsLabel.text = bundle.localizedString(forKey: "conditions", value: nil, table: nil);
        self.tweakSelection.okBtn.setTitle(bundle.localizedString(forKey: "ok", value: nil, table: nil), for: .normal);
        tweakOptionView.removeFromSuperview();
        
    }
    
    @objc func switchToSixthScreen() {
        
        self.switchToSeventhScreen1();
        
    }
    
    @objc func switchToGoalsView() {
        
        self.tweakGoalsView = (Bundle.main.loadNibNamed("TweakAndEatGoalsView", owner: self, options: nil)! as NSArray).firstObject as! TweakAndEatGoalsView;
        tweakGoalsView.frame = self.view.frame;
        tweakGoalsView.delegate = self;
        tweakGoalsView.beginning();
        tweakGoalsView.setUpViews()
        self.view.addSubview(tweakGoalsView);
        
        tweakSelection.removeFromSuperview();
        
    }
    
    @objc func switchToSeventhScreen(isInfoIconTapped: Bool) {
       //seventhScreen

                self.tweakFinalView = (Bundle.main.loadNibNamed("TweakAndEatFinalIntroScreen", owner: self, options: nil)! as NSArray).firstObject as! TweakAndEatFinalIntroScreen;
                        tweakFinalView.frame = self.view.frame;
                        tweakFinalView.delegate = self;
        let cellIdentifier = "item"
        tweakFinalView.collectionView.register(UINib(nibName:"HorizontalStepsIntroCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        tweakFinalView.infoIconTapped = infoIconTapped
                        tweakFinalView.beginning();
        tweakFinalView.collectionView.delegate = self
        tweakFinalView.collectionView.dataSource = self


        tweakFinalView.pageControl.numberOfPages = tweakFinalView.imageArray.count
                        self.view.addSubview(self.tweakFinalView);
              
                        self.tweakFinalView.okBtn.setTitle(bundle.localizedString(forKey: "ok", value: nil, table: nil), for: .normal)
                        self.tweakTermsServiceView.removeFromSuperview();
//            }
//        }
        
        // pieChartView.removeFromSuperview();
        
    }
    
    @objc func switchToEighthScreen() {
        self.tweakTermsServiceView = (Bundle.main.loadNibNamed("TweakServiceAgreement", owner: self, options: nil)! as NSArray).firstObject as! TweakServiceAgreement;
        tweakTermsServiceView.frame = self.view.frame;
        tweakTermsServiceView.delegate = self;
        self.view.addSubview(self.tweakTermsServiceView);
        self.tweakTermsServiceView.termsOfUseLabel.text = bundle.localizedString(forKey: "terms_of_use", value: nil, table: nil)
        self.tweakTermsServiceView.agreedBtn.setTitle(bundle.localizedString(forKey: "i_agree", value: nil, table: nil), for: .normal)
        tweakGoalsView.removeFromSuperview();
        tweakSelection.removeFromSuperview();
        tweakTermsServiceView.agreedBtn.isHighlighted = true
        tweakTermsServiceView.agreedBtn.isUserInteractionEnabled = false
        tweakTermsServiceView.termsServiceTextView.layer.cornerRadius = 8
        tweakTermsServiceView.agreedBtn.layer.cornerRadius = 5
        
        let termsOfUseTextDic = self.introTextArray!.filter({ (element) -> Bool in
            if((element as! NSDictionary).value(forKey: TweakAndEatConstants.STATIC_NAME) as! String == TweakAndEatConstants.TERMS_OF_USE) {
                return true;
            } else {
                return false;
            }
        })
        
        var termsOfUse : String? = nil;
        
        if(termsOfUseTextDic.count > 0) {
            termsOfUse = (termsOfUseTextDic[0] as! NSDictionary).value(forKey: TweakAndEatConstants.STATIC_VALUE) as? String;
        }
        
        if(termsOfUse != nil) {
            self.changeFonts1((termsOfUse!.html2AttributedString.mutableCopy()) as! NSMutableAttributedString);
        }
        
    }
    func getAttributedString(htmlText: String) -> NSAttributedString {
        let encodedData = htmlText.data(using: String.Encoding.utf8)!
                           var attributedString: NSAttributedString

                           do {
                               attributedString = try NSAttributedString(data: encodedData, options: [NSAttributedString.DocumentReadingOptionKey.documentType:NSAttributedString.DocumentType.html,NSAttributedString.DocumentReadingOptionKey.characterEncoding:NSNumber(value: String.Encoding.utf8.rawValue)], documentAttributes: nil)
                           
                             return attributedString

                           } catch let error as NSError {
                               print(error.localizedDescription)
                           } catch {
                               print("error")
                           }
        return NSAttributedString()
        
    }
    
    func removeHowToTweak() {
        self.howToTweakView.removeFromSuperview()
    }
    
    func showHowToTweakScreen() {
                self.navigationController?.isNavigationBarHidden = true;
        self.switchToSeventhScreen(isInfoIconTapped: true)

//        howToTweakView = (Bundle.main.loadNibNamed("HowToTweak", owner: self, options: nil)! as NSArray).firstObject as? HowToTweak;
//               howToTweakView.frame = self.view.frame;
//               howToTweakView.delegate = self;
//               self.view.addSubview(howToTweakView);
//               howToTweakView.beginning();
//               self.getIntroSlide2()
    }
    
    func updateUIForSlide1(data: [[String: AnyObject]] ) {
        
                if data.count == 0 {
                    
                } else {
                  for dict in data {

                        if dict["name"] as! String == "bg" {
                            self.congratsTweakerBgStr = dict["value"] as! String

                    }
                        if dict["name"] as! String == "rev1" {
                            self.congratsTweakerReview1Str = dict["value"] as! String


                    }
                        if dict["name"] as! String == "rev2" {
                            self.congratsTweakerReview2Str = dict["value"] as! String

                    }
                    
                  }
                    self.congratulationsTweakerView.screenOneBg.sd_setImage(with: URL(string: self.congratsTweakerBgStr)) { (image, error, cache, url) in
                        // Your code inside completion block
                        let ratio = image!.size.width / image!.size.height
                        let newHeight = self.congratulationsTweakerView.screenOneBg.frame.width / ratio
                        
                        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut],
                                       animations: {
                                        self.congratulationsTweakerView.screenOneBgHeighgtConstraint.constant = newHeight
                                       

                                        self.view.layoutIfNeeded()
                        }, completion: { _ in
                            if !IS_iPHONE5 {
                            
                                self.congratulationsTweakerView.backgroudView.backgroundColor = #colorLiteral(red: 0.8037554622, green: 0.1748961508, blue: 0.4208399057, alpha: 1)
                                self.congratulationsTweakerView.backgroudView.layer.cornerRadius = 5
                                self.congratulationsTweakerView.backgroudView.frame = CGRect(x: self.congratulationsTweakerView.screenOneBg.frame.origin.x + 0.5, y: self.congratulationsTweakerView.screenOneBg.frame.maxY - 20, width: self.congratulationsTweakerView.screenOneBg.frame.width - 1  , height: self.congratulationsTweakerView.nextBtn.frame.minY - self.congratulationsTweakerView.screenOneBg.frame.maxY - 20)
                            //self.view.bringSubviewToFront(self.congratulationsTweakerView.screenOneBg)
                            }
                            
                            self.congratulationsTweakerView.review1Bg.sd_setImage(with: URL(string: self.congratsTweakerReview1Str)) { (image, error, cache, url) in
                                // Your code inside completion block
                                let ratio = image!.size.width / image!.size.height
                                let newHeight = self.congratulationsTweakerView.review1Bg.frame.width / ratio
                                
                                UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut],
                                               animations: {
                                                self.congratulationsTweakerView.review1HeightConstraint.constant = newHeight
                                                self.view.layoutIfNeeded()
                                }, completion: { _ in
                                    self.congratulationsTweakerView.review2Bg.sd_setImage(with: URL(string: self.congratsTweakerReview2Str)) { (image, error, cache, url) in
                                        // Your code inside completion block
                                        let ratio = image!.size.width / image!.size.height
                                        let newHeight = self.congratulationsTweakerView.review2Bg.frame.width / ratio
                                        
                                        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut],
                                                       animations: {
                                                        self.congratulationsTweakerView.review2HeightConstraint.constant = newHeight
                                                        self.view.layoutIfNeeded()
                                        }, completion: { _ in
                                            self.congratulationsTweakerView.nextBtn.isHidden = false
                                        })
                                        
                                        
                                    }
                                })
                                
                                
                            }
                            
                        })
                        
                        
                    }

                    
                }
            }
    
    func updateUIForSlide2(data: [[String: AnyObject]] ) {
        
        if data.count == 0 {
            
        } else {
            for dict in data {
                
                if dict["name"] as! String == "bg" {
                    self.howToTweakBgStr = dict["value"] as! String
                    
                }
                if dict["name"] as! String == "step1" {
                    self.step1Str = dict["value"] as! String
                    
                    
                }
                if dict["name"] as! String == "step2" {
                    self.step2Str = dict["value"] as! String
                    
                }
                if dict["name"] as! String == "step3" {
                    self.step3Str = dict["value"] as! String
                    
                }
                if dict["name"] as! String == "text1" {
                    self.youAreDoneStr = dict["value"] as! String
                    
                }
                
            }
            self.howToTweakView.screenOneBg.sd_setImage(with: URL(string: self.howToTweakBgStr)) { (image, error, cache, url) in
                // Your code inside completion block
                let ratio = image!.size.width / image!.size.height
                let newHeight = self.howToTweakView.screenOneBg.frame.width / ratio
                
                UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut],
                               animations: {
                                self.howToTweakView.screenOneBgHeighgtConstraint.constant = newHeight
                                
                                
                                self.view.layoutIfNeeded()
                }, completion: { _ in
                    if !IS_iPHONE5 {
                    
                    self.howToTweakView.backgroudView.backgroundColor = #colorLiteral(red: 0.5112051368, green: 0.1630825996, blue: 0.6293783188, alpha: 1)
                    self.howToTweakView.backgroudView.layer.cornerRadius = 5
                        self.howToTweakView.backgroudView.frame = CGRect(x: self.howToTweakView.screenOneBg.frame.origin.x + 0.5, y: self.howToTweakView.screenOneBg.frame.maxY - 20, width: self.howToTweakView.screenOneBg.frame.width - 1  , height: self.howToTweakView.letsTweakBtn.frame.minY - self.howToTweakView.screenOneBg.frame.maxY - 20)
                       // self.view.bringSubviewToFront(self.howToTweakView.screenOneBg)
                        //self.view.bringSubviewToFront(self.howToTweakView.youAreDoneBg)

                       // self.view.addSubview(self.howToTweakView.backgroudView);
                        

                    }
                    
                    self.howToTweakView.step1Bg.sd_setImage(with: URL(string: self.step1Str)) { (image, error, cache, url) in
                        // Your code inside completion block
                        let ratio = image!.size.width / image!.size.height
                        let newHeight = self.howToTweakView.step1Bg.frame.width / ratio
                        
                        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut],
                                       animations: {
                                        self.howToTweakView.step1BgHeightConstraint.constant = newHeight
                                        self.view.layoutIfNeeded()
                        }, completion: { _ in
                            self.howToTweakView.step2Bg.sd_setImage(with: URL(string: self.step2Str)) { (image, error, cache, url) in
                                // Your code inside completion block
                                let ratio = image!.size.width / image!.size.height
                                let newHeight = self.howToTweakView.step2Bg.frame.width / ratio
                                
                                UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut],
                                               animations: {
                                                self.howToTweakView.step2BgHeightConstraint.constant = newHeight
                                                self.view.layoutIfNeeded()
                                }, completion: { _ in
                                    self.howToTweakView.step3Bg.sd_setImage(with: URL(string: self.step3Str)) { (image, error, cache, url) in
                                        // Your code inside completion block
                                        let ratio = image!.size.width / image!.size.height
                                        let newHeight = self.howToTweakView.step3Bg.frame.width / ratio
                                        
                                        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut],
                                                       animations: {
                                                        self.howToTweakView.step3BgHeightConstraint.constant = newHeight
                                                        self.view.layoutIfNeeded()
                                        }, completion: { _ in
                                            self.howToTweakView.youAreDoneBg.sd_setImage(with: URL(string: self.youAreDoneStr)) { (image, error, cache, url) in
                                                // Your code inside completion block
                                                let ratio = image!.size.width / image!.size.height
                                                let newHeight = self.howToTweakView.youAreDoneBg.frame.width / ratio
                                                
                                                UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut],
                                                               animations: {
                                                                self.howToTweakView.youAreDoneBgHeightConstraint.constant = newHeight
                                                                self.view.layoutIfNeeded()
                                                }, completion: { _ in
                                                    if self.infoIconTapped == true {
                                                    self.howToTweakView.previousBtn.isHidden = true
                                                    } else {
                                                        self.howToTweakView.previousBtn.isHidden = false

                                                    }
                                                    self.howToTweakView.letsTweakBtn.isHidden = false
                                                    self.navigationController?.navigationBar.isHidden = false
                                                })
                                                
                                                
                                            }
                                        })
                                        
                                        
                                    }
                                })
                                
                                
                            }
                        })
                        
                        
                    }
                    
                })
                
                
            }
            
            
        }
    }
    
    
   @objc func getIntroSlide1() {
        MBProgressHUD.showAdded(to: self.view, animated: true)

              APIWrapper.sharedInstance.postRequestWithHeaderMethodWithOutParameters(TweakAndEatURLConstants.INTRO_SLIDE1, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, success: { response in
                  print(response!)
                  
                  let responseDic : [String:AnyObject] = response as! [String:AnyObject];
                  let responseResult = responseDic["callStatus"] as! String;
                  if  responseResult == "GOOD" {
                      MBProgressHUD.hide(for: self.view, animated: true);
                      let data = responseDic["data"] as AnyObject as! [[String: AnyObject]]
                  
                    self.updateUIForSlide1(data: data)

                  }
              }, failure : { error in
                  MBProgressHUD.hide(for: self.view, animated: true);
                  
                  print("failure")
                  if error?.code == -1011 {
                     // TweakAndEatUtils.AlertView.showAlert(view: self, message: "Some error occurred. Please try again...");
                      return
                  }
                  //TweakAndEatUtils.AlertView.showAlert(view: self, message: "Your internet connection appears to be offline.");
              })
    }
    
    @objc func getIntroSlide2() {
         MBProgressHUD.showAdded(to: self.view, animated: true)

               APIWrapper.sharedInstance.postRequestWithHeaderMethodWithOutParameters(TweakAndEatURLConstants.INTRO_SLIDE2, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, success: { response in
                   print(response!)
                   
                   let responseDic : [String:AnyObject] = response as! [String:AnyObject];
                   let responseResult = responseDic["callStatus"] as! String;
                   if  responseResult == "GOOD" {
                       MBProgressHUD.hide(for: self.view, animated: true);
                       let data = responseDic["data"] as AnyObject as! [[String: AnyObject]]
                   
                     self.updateUIForSlide2(data: data)

                   }
               }, failure : { error in
                   MBProgressHUD.hide(for: self.view, animated: true);
                   
                   print("failure")
                   if error?.code == -1011 {
                      // TweakAndEatUtils.AlertView.showAlert(view: self, message: "Some error occurred. Please try again...");
                       return
                   }
                   //TweakAndEatUtils.AlertView.showAlert(view: self, message: "Your internet connection appears to be offline.");
               })
     }
    
    @objc func switchToSeventhScreen1() {

        tweakTermsServiceView.agreedBtn.isUserInteractionEnabled = false
        appDelegateTAE.networkReconnectionBlock = {
            
            DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view, animated: true);
                }
            
            let userInfo = NSMutableDictionary()
            userInfo.setValue(self.msisdn, forKey: "msisdn");
            
            let deviceToken : String? = UserDefaults.standard.value(forKey: "deviceToken") as? String;
            if(deviceToken != nil) {
                userInfo.setValue(deviceToken!, forKey: "deviceId");
            } else {
                userInfo.setValue("APA91bHPRgkF3JUikC4ENAHEeMrd41Zxv3hVZjC9KtT8OvPVGJ-hQMRKRrZuJAEcl7B338qju59zJMjw2DELjzEvxwYv7hH5Ynpc1ODQ0aT4U4OFEeco8ohsN5PjL1iC2dNtk2BAokeMCg2ZXKqpc8FXKmhX94kIxQ", forKey: "deviceId");
            }
            
            if self.tweakOptionView.delegate.selectedGender == self.bundle.localizedString(forKey: "male", value: nil, table: nil) {
                userInfo.setValue("M", forKey: "gender");
            } else {
                userInfo.setValue("F", forKey: "gender");
            }
            if self.tweakOptionView.bodyshapenumber == nil {
                if self.tweakOptionView.maleLabel.text == self.bundle.localizedString(forKey: "male", value: nil, table: nil) {
                    userInfo.setValue("1", forKey: "bodyShape");
                } else {
                    userInfo.setValue("6", forKey: "bodyShape");
                }
            } else {
                userInfo.setValue(self.tweakOptionView.bodyshapenumber, forKey: "bodyShape");
            }
            userInfo.setValue("", forKey: "gcmId")
            
            for _ in self.tweakSelection.selectedAllergies {
                let element = self.tweakSelection.selectedAllergies.joined(separator: ",")
                print(element)
                userInfo.setValue(element, forKey: "allergies")
            }
            for _ in self.tweakGoalsView.goals {
                let element = self.tweakGoalsView.goals.joined(separator: ",")
                print(element)
                userInfo.setValue(element, forKey: "goals")
            }
            if self.tweakGoalsView.goals.count == 0 {
                userInfo.setValue("", forKey: "goals")
            }
            if self.tweakSelection.selectedAllergies.count == 0{
                userInfo.setValue("", forKey: "allergies")
            }
            
            for _ in self.tweakSelection.selectedConditions {
                let element = self.tweakSelection.selectedConditions.joined(separator: ",")
                print(element)
                userInfo.setValue(element , forKey: "conditions")
            }
            if self.tweakSelection.selectedConditions.count == 0{
                userInfo.setValue("", forKey: "conditions")
            }
            
            userInfo.setValue(self.tweakOptionView.nickNameField.text, forKey: "nickName")
            if self.tweakSelection.foodhabit == "" {
                userInfo.setValue("1", forKeyPath: "foodhabit")
            } else {
                userInfo.setValue(self.tweakSelection.foodhabit, forKeyPath: "foodhabit")
            }
            
            userInfo.setValue(self.tweakOptionView.emailTF.text, forKey: "email")
            //userInfo.setValue(UserDefaults.standard.value(forKey: "PROVIDER_NAME"), forKey: "provider")
            userInfo.setValue("1", forKey: "ageGroup");
            userInfo.setValue(self.tweakOptionView.ageTextField.text, forKey: "age");
            
            if self.tweakOTPView.countryCodeTextField.text == "+1" {
                userInfo.setValue(self.totalCMS, forKey: "height");
            } else {
                userInfo.setValue(self.tweakOptionView.heightTextField.text, forKey: "height");
            }
            userInfo.setValue(Int((self.tweakOTPView.countryCodeTextField.text?.replacingOccurrences(of: "+", with: ""))!),forKey: "countryCode");
            var weight = Int(self.tweakOptionView.weightTextField.text!);
            if Int(((self.tweakOTPView.countryCodeTextField.text?.replacingOccurrences(of: "+", with: ""))!)) == 1 {
                let lbs = weight
                weight = Int(Double(lbs!) * 0.45)
            }
            userInfo.setValue("\(weight as! Int)", forKey: "weight");
            userInfo.setValue("IOS", forKey: "device");
            if UserDefaults.standard.value(forKey: "LANGUAGE") as! String == "AR" {
                userInfo.setValue("AR", forKey: "language")
            } else {
                userInfo.setValue("EN", forKey: "language")
            }
            
            
            let newUser = NSDictionary(object: userInfo, forKey: "newUser" as NSCopying);
            APIWrapper.sharedInstance.registerNewUser(newUser, successBlock: { (responceDic : AnyObject!) -> (Void) in
                if(TweakAndEatUtils.isValidResponse(responceDic as? [String:AnyObject])) {
                    let response  = responceDic as! [String : AnyObject];
                    print(response)
                    
                    let message = self.bundle.localizedString(forKey: "first_tweak_msg", value: nil, table: nil)
                    
                    if response.index(forKey : "isNewRegistration") != nil {
                        if response["isNewRegistration"] as AnyObject as! Bool == true {
                            CleverTap.sharedInstance()?.recordEvent("Freetrial_started")

                            let identifier = ProcessInfo.processInfo.globallyUniqueString
                            let content = UNMutableNotificationContent()
                            content.title = "First Tweaker Contest"
                            content.body = message
                            content.sound = UNNotificationSound(named: convertToUNNotificationSoundName("AirplaneDing.wav"))
                            
                            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: false)
                            let request = UNNotificationRequest.init(identifier: identifier, content: content, trigger: trigger)
                            UNUserNotificationCenter.current().add(request) { (error) in
                                // handle error
                            }
                        }
                    }
                    
                    UserDefaults.standard.setValue(response["userSession"] as Any, forKey: "userSession");
                    UserDefaults.standard.setValue(self.msisdn, forKey: "msisdn");
                    
                    let userSession : String = UserDefaults.standard.value(forKey: "userSession") as! String;
                    let firebaseUserName = response["fbUserName"] as! String
                    let firebasePassword = response["fbUserPass"] as! String
                    print(firebasePassword)
                    let profile = MyProfileInfo()
                    profile.id = self.incrementID()
                    profile.name = self.tweakOptionView.nickNameField.text!
                    profile.age = self.tweakOptionView.ageTextField.text!
                    if self.tweakOptionView.delegate.selectedGender == self.bundle.localizedString(forKey: "male", value: nil, table: nil) {
                        profile.gender = "M"
                    } else {
                        profile.gender = "F"
                    }
                    profile.msisdn = self.msisdn!
                    profile.weight = self.tweakOptionView.weightTextField.text!
                    profile.height = self.tweakOptionView.heightTextField.text!
                    if self.tweakSelection.food.count > 0 {
                        profile.foodHabits = self.tweakSelection.food.joined(separator: ",")
                    } else {
                        profile.foodHabits = ""
                    }
                    if self.tweakSelection.allergy.count > 0 {
                        profile.allergies = self.tweakSelection.allergy.joined(separator: ",")
                    } else {
                        profile.allergies = ""
                    }
                    if self.tweakSelection.conditions.count > 0 {
                        profile.conditions = self.tweakSelection.conditions.joined(separator: ",")
                    } else {
                        profile.conditions = ""
                    }
                    if self.tweakOptionView.bodyshapenumber == nil {
                        if profile.gender == "M" {
                            profile.bodyShape = "1"
                        } else {
                            profile.bodyShape = "6"
                        }
                    } else {
                        profile.bodyShape = self.tweakOptionView.bodyshapenumber
                    }
                    profile.email = self.tweakOptionView.emailTF.text!
                    profile.providerName = ""
                    for _ in self.tweakGoalsView.goals {
                        let element = self.tweakGoalsView.goals.joined(separator: ",")
                        profile.goals = element
                        
                    }
                    if self.tweakGoalsView.goals.count == 0 {
                        profile.goals = ""
                        
                    }
                    
                    
                    saveToRealmOverwrite(objType: MyProfileInfo.self, objValues: profile)
                    
                    let status: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
                    
                    let userId = status.subscriptionStatus.userId;
                    if userId != nil {
                        UserDefaults.standard.setValue(userId! as String, forKey: "PLAYER_ID");
                    } else {
                        self.tabBarController?.tabBar.isHidden = true
                        let alertController = UIAlertController(title: self.bundle.localizedString(forKey: "no_internet", value: nil, table: nil), message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil), preferredStyle: UIAlertController.Style.alert)
                        
                        let defaultAction = UIAlertAction(title: "Refresh", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                        return
                    }
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GET_TRENDS"), object: nil);
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GET_RECIPES_AND_TWEAKS"), object: nil);
                    self.getTimeLines();
                    APIWrapper.sharedInstance.sendGCM(["gcmId":UserDefaults.standard.value(forKey: "PLAYER_ID") as Any], userSession: userSession, successBlock: {(responseDic : AnyObject!) -> (Void) in
                        print("Sucess");
                      
                        if let refreshedToken = InstanceID.instanceID().token() {
                            print("fbtoken:\(refreshedToken)")
                            
                            
                            APIWrapper.sharedInstance.sendFBToken(["fbToken" : refreshedToken as Any], userSession: userSession, successBlock: {(responseDic : AnyObject!) -> (Void) in
                                print("fbtoken:\(responseDic)");
                                UserDefaults.standard.set(true, forKey: "FBTOKEN")
                                APIWrapper.sharedInstance.getRequestWithHeader( sessionString: userSession,TweakAndEatURLConstants.INVITED_EXISTING_FRIEND, success: { response in
                                    
                                    
                                  //  TweakAndEatUtils.hideMBProgressHUD();
                                    DispatchQueue.main.async {
                
                }
                                    
                                    Auth.auth().signIn(withEmail: firebaseUserName, password: firebasePassword) { (user, error) in
                                        
                                        if error == nil {
                                            UserDefaults.standard.setValue(false, forKey: "showRegistration");

                                            if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
                                                self.countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
                                               // if self.countryCode == "91" {
//                                                AppsFlyerLib.shared().logEvent("af_complete_registration", withValues: [ AFEventParamRegistrationMethod: "YES"])
                                                if UserDefaults.standard.value(forKey: "msisdn") != nil {
                                                 let msisdn = UserDefaults.standard.value(forKey: "msisdn") as! String
                                                    let data: NSData = msisdn.data(using: .utf8)! as NSData
                                                    let password = "sFdebvQawU9uZJ"
                                                    let cipherData = RNCryptor.encrypt(data: data as Data, withPassword: password)
                                                    Branch.getInstance().setIdentity(cipherData.base64EncodedString())

                                                }
//AppEvents.logEvent(.completedRegistration)

                                                let event = BranchEvent.standardEvent(.completeRegistration)
                                                event.eventDescription = "User completed registration."
                                                event.logEvent()

                                                //BranchEvent.standardEvent(.completeRegistration).logEvent()
                                                
                                               // }
                                            }
                                            //last
                                            AppEvents.logEvent(.completedRegistration, parameters: ["country": self.countryCode])

                                            let ct = CleverTapClass()
                                            ct.updateCleverTapWithProp(isUpdateProfile: false)

                                             if (self.countryCode == "91") {
                                                Analytics.logEvent("TAE_REG_SUCCESS_IND", parameters: [AnalyticsParameterItemName: "Registration successful"]);
                                                
                                                AppEvents.logEvent(.completedRegistration)
                                            } else if (self.countryCode == "1") {
                                               Analytics.logEvent("TAE_REG_SUCCESS_USA", parameters: [AnalyticsParameterItemName: "Registration successful"]);
                                            } else if (self.countryCode == "62") {
                                               Analytics.logEvent("TAE_REG_SUCCESS_IDN", parameters: [AnalyticsParameterItemName: "Registration successful"]);
                                            } else if (self.countryCode == "60") {
                                               Analytics.logEvent("TAE_REG_SUCCESS_MYS", parameters: [AnalyticsParameterItemName: "Registration successful"]);
                                                
                                             } else if (self.countryCode == "63") {
                                               Analytics.logEvent("TAE_REG_SUCCESS_PHL", parameters: [AnalyticsParameterItemName: "Registration successful"]);
                                            } else if (self.countryCode == "65") {
                                               Analytics.logEvent("TAE_REG_SUCCESS_SGP", parameters: [AnalyticsParameterItemName: "Registration successful"]);
                                            }
                                            //Print into the console if successfully logged in
                                            print("You have successfully logged in")
                                           // let country: String = UserDefaults.standard.value(forKey: "COUNTRY_NAME") as! String
                                           // let eventName = "registration_successful" + "_" + country
                                            //print(eventName)
                                           // Analytics.logEvent(eventName, parameters: [AnalyticsParameterItemName: "user registration successful !!"])
                                           
                                            
                                            self.getProfileData()
                                            
                                            
                                        } else {
                                            
                                            //Tells the user that there is an error and then gets firebase to tell them the error
                                            let alertController = UIAlertController(title: "", message:  self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil), preferredStyle: .alert)
                                            
                                            let defaultAction = UIAlertAction(title:  self.bundle.localizedString(forKey: "ok", value: nil, table: nil), style: .cancel, handler: nil)
                                            alertController.addAction(defaultAction)
                                            
                                            self.present(alertController, animated: true, completion: nil)
                                        }
                                    }
                                    
                                }, failure: { error in
                                    print("failure");
                                    let alertController = UIAlertController(title: self.bundle.localizedString(forKey: "no_internet", value: nil, table: nil), message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil), preferredStyle: UIAlertController.Style.alert)
                                    
                                    let defaultAction = UIAlertAction(title:  self.bundle.localizedString(forKey: "ok", value: nil, table: nil), style: .cancel, handler: nil)
                                    alertController.addAction(defaultAction)
                                    self.present(alertController, animated: true, completion: nil)
                                    
                                    TweakAndEatUtils.hideMBProgressHUD();
                                })
                                
                                
                            }, failureBlock: { (error : NSError!) -> (Void) in
                                //error
                                print("error");
                                let alertController = UIAlertController(title: self.bundle.localizedString(forKey: "no_internet", value: nil, table: nil), message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil), preferredStyle: UIAlertController.Style.alert)
                                
                                let defaultAction = UIAlertAction(title:  self.bundle.localizedString(forKey: "ok", value: nil, table: nil), style: .cancel, handler: nil)
                                alertController.addAction(defaultAction)
                                self.present(alertController, animated: true, completion: nil)
                                
                                DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true);
                }
                            })
                        }
                        
                    }, failureBlock: {(error : NSError!) -> (Void) in
                        print("Failure");
                        let alertController = UIAlertController(title: self.bundle.localizedString(forKey: "no_internet", value: nil, table: nil), message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil), preferredStyle: UIAlertController.Style.alert)
                        
                        let defaultAction = UIAlertAction(title:  self.bundle.localizedString(forKey: "ok", value: nil, table: nil), style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                        
                        TweakAndEatUtils.hideMBProgressHUD();
                        
                    })
                    
                }
                
            }, failureBlock: { (error : NSError!) -> (Void) in
                //error
                print("error");
                
                
                self.tweakTermsServiceView.agreedBtn.isUserInteractionEnabled = true

                let alertController = UIAlertController(title: self.bundle.localizedString(forKey: "no_internet", value: nil, table: nil), message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil), preferredStyle: UIAlertController.Style.alert)
                
                let defaultAction = UIAlertAction(title:  self.bundle.localizedString(forKey: "ok", value: nil, table: nil), style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
                
                DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true);
                }
            })
        }
        appDelegateTAE.networkReconnectionBlock!();
    }
    
    @objc func getTimeLines() {
        let userSession : String = UserDefaults.standard.value(forKey: "userSession") as! String;
        APIWrapper.sharedInstance.getTimelines(sessionString: userSession, successBlock: { (responceDic : AnyObject!) -> (Void) in
            if(TweakAndEatUtils.isValidResponse(responceDic as? [String:AnyObject])) {
                let response : [String:AnyObject] = responceDic as! [String:AnyObject];
                let tweaks : [AnyObject]? = response[TweakAndEatConstants.TWEAKS] as? [AnyObject];
                if(tweaks != nil) {
                    for tweak in tweaks! {
                        DataManager.sharedInstance.saveTweak(tweak: tweak as! NSDictionary);
                        
                    }
                    self.addReminders();
                }
            }
            
        }) { (error : NSError!) -> (Void) in
            print("failure");
            
            self.addReminders();
            TweakAndEatUtils.hideMBProgressHUD();
        }
    }
    
    @objc func resignHowToTweakScreen() {
        //self.tweakView.refreshView.isHidden = true
        self.howToTweakView.removeFromSuperview();
        
        self.tabBarController?.tabBar.isHidden = false;
        self.navigationController?.isNavigationBarHidden = true;
        UserDefaults.standard.setValue(false, forKey: "showRegistration");
    }
    
    @objc func resignRegistrationScreen() {
        //self.tweakView.refreshView.isHidden = true
        self.tweakFinalView.removeFromSuperview();
        
        self.tabBarController?.tabBar.isHidden = false;
        self.navigationController?.isNavigationBarHidden = true;
        UserDefaults.standard.setValue(false, forKey: "showRegistration");
    }
    
    @objc func setAgeAndGenderView(_ ageGroups : [AnyObject]?) {
        
        self.tweakOptionView.setGenderOptions();
        self.tweakOptionView.setImageViewsOfGender();
        TweakAndEatUtils.hideMBProgressHUD();
    }
    
    @objc func changeFonts(_ htmlString : NSMutableAttributedString) {
        htmlString.beginEditing();
        htmlString.enumerateAttribute(NSAttributedString.Key.font, in: NSMakeRange(0, htmlString.length), options: NSAttributedString.EnumerationOptions(rawValue: 0), using: { (value, range, stop) -> Void in
            if(value != nil) {
                let oldFont : UIFont = value as! UIFont;
                htmlString.removeAttribute(NSAttributedString.Key.font, range: range);
                
                if(oldFont.fontName == "TimesNewRomanPS-BoldMT") {
                    let newFont : UIFont = UIFont(name: "SourceSansPro-Semibold", size: 20)!;
                    htmlString.addAttribute(NSAttributedString.Key.font, value: newFont, range: range);
                } else {
                    let newFont : UIFont = UIFont(name: "SourceSansPro-Regular", size: 15)!;
                    htmlString.addAttribute(NSAttributedString.Key.font, value: newFont, range: range);
                }
            }
        })
        
        htmlString.enumerateAttribute(NSAttributedString.Key.foregroundColor, in: NSMakeRange(0, htmlString.length), options: NSAttributedString.EnumerationOptions(rawValue: 0), using: { (value, range, stop) -> Void in
            if(value != nil) {
                htmlString.removeAttribute(NSAttributedString.Key.foregroundColor, range: range);
                htmlString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 147.0/255, green: 147.0/255, blue: 147.0/255, alpha: 1.0), range: range);
            }
        })
        
        htmlString.endEditing();
        tweakTextView.setIntroText(htmlString);
    }
    
    @objc func changeFonts1(_ htmlString : NSMutableAttributedString) {
        htmlString.beginEditing();
        htmlString.enumerateAttribute(NSAttributedString.Key.font, in: NSMakeRange(0, htmlString.length), options: NSAttributedString.EnumerationOptions(rawValue: 0), using: { (value, range, stop) -> Void in
            if(value != nil) {
                let oldFont : UIFont = value as! UIFont;
                htmlString.removeAttribute(NSAttributedString.Key.font, range: range);
                
                if(oldFont.fontName == "TimesNewRomanPS-BoldMT") {
                    let newFont : UIFont = UIFont(name: "SourceSansPro-Semibold", size: 15)!;
                    htmlString.addAttribute(NSAttributedString.Key.font, value: newFont, range: range);
                } else {
                    let newFont : UIFont = UIFont(name: "SourceSansPro-Regular", size: 13)!;
                    htmlString.addAttribute(NSAttributedString.Key.font, value: newFont, range: range);
                }
            }
        })
        
        htmlString.enumerateAttribute(NSAttributedString.Key.foregroundColor, in: NSMakeRange(0, htmlString.length), options: NSAttributedString.EnumerationOptions(rawValue: 0), using: { (value, range, stop) -> Void in
            if(value != nil) {
                htmlString.removeAttribute(NSAttributedString.Key.foregroundColor, range: range);
                htmlString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 147.0/255, green: 147.0/255, blue: 147.0/255, alpha: 1.0), range: range);
            }
        })
        
        htmlString.endEditing();
        tweakTermsServiceView.setTermsOfUse(htmlString);
    }
    
    @IBAction func onClickOfSettings(_ sender: AnyObject) {
        self.goToSettings(index: 0)
    }
    
    @objc func goToSettings(index: Int) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let tabBarController : UITabBarController = storyBoard.instantiateViewController(withIdentifier: "settingsTabController") as! SettingsTabBarController;
        tabBarController.selectedIndex = index
        self.navigationController?.pushViewController(tabBarController, animated: true);
    }
    
    @objc func incrementID() -> Int {
        let db = DBManager()
        return (db.realm.objects(MyProfileInfo.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
    
    @IBAction func onClickOfCamera(_ sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            checkTweakable()
        } else {
            noCamera();
        }
        
    }
    
    @objc func noCamera() {
        let alertVC = UIAlertController(title: "No Camera", message: "Sorry, this device has no camera", preferredStyle: .alert);
        let okAction = UIAlertAction( title: self.bundle.localizedString(forKey: "ok", value: nil, table: nil), style:.default, handler: nil)
        alertVC.addAction(okAction);
        present(alertVC, animated: true, completion: nil);
    }
    
    
    @IBAction func videoPlayAction(_ sender: Any) {
        CleverTap.sharedInstance()?.recordEvent("Introvideo_watched")
        self.playVideo()
    }
    
    @IBAction func onClickOfNotification(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Tweak Notification", message: "Coming Soon..", preferredStyle: UIAlertController.Style.alert);
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil));
        self.present(alert, animated: true, completion: nil);
    }
    
    @IBAction func onClickOfProfile(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Contacts", message: "Coming Soon..", preferredStyle: UIAlertController.Style.alert);
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil));
        self.present(alert, animated: true, completion: nil);
    }
    
    @IBAction func onClickOfSlider(_ sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let timelineViewController : TimelinesViewController = storyBoard.instantiateViewController(withIdentifier: "timelinesViewController") as! TimelinesViewController;
        self.navigationController?.pushViewController(timelineViewController, animated: true);
    }
    
    @IBAction func navigateToSettings(_ sender: AnyObject) {
        comingFromSettings = true;
        UIView.animate(withDuration: 1.0) {
            self.tabBarController?.tabBar.isHidden = true;
        }
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let tabBarController : UITabBarController = storyBoard.instantiateViewController(withIdentifier: "settingsTabController") as! UITabBarController;
        self.navigationController?.pushViewController(tabBarController, animated: true);
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil);
    }
    
    @objc func faceDetection(detect: UIImage) {
        
        guard let personciImage = CIImage(image: detect) else {
            return
        }
        
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
        let faces = faceDetector?.features(in: personciImage)
        print(faces!.count)
        
        // Convert Core Image Coordinate to UIView Coordinate
        let ciImageSize = personciImage.extent.size
        var transform = CGAffineTransform(scaleX: 1, y: -1)
        transform = transform.translatedBy(x: 0, y: -ciImageSize.height)
        var message: String = self.bundle.localizedString(forKey: "detected_a_face", value: nil, table: nil)
        if faces!.count > 5 {
            message = "We detected so many faces!"
        } else if faces!.count > 1 && faces!.count <= 2 {
            message = "We detected faces!"
        } else if faces!.count == 2 {
            message = "We detected 2 faces!"
        } else if faces!.count == 3 {
            message = "We detected 3 faces!"
        }  else if faces!.count == 4 {
            message = "We detected 4 faces!"
        }  else if faces!.count == 5 {
            message = "We detected 5 faces!"
        }
        message = message +  self.bundle.localizedString(forKey: "detect_face", value: nil, table: nil)
        for face in faces as! [CIFaceFeature] {
            var faceViewBounds = face.bounds.applying(transform)
            
            if face.hasLeftEyePosition {
                print("Left eye bounds are \(face.leftEyePosition)")
            }
            
            if face.hasRightEyePosition {
                print("Right eye bounds are \(face.rightEyePosition)")
            }
        }
        if faces!.count > 0 {
            let alert = UIAlertController(title: self.bundle.localizedString(forKey: "say_cheese", value: nil, table: nil), message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
            countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
        }
        DispatchQueue.global().async() {
            print("Work Dispatched")
            // Do heavy or time consuming work
            let imageData: NSData = self.countryCode == "1" ?detect.jpegData(compressionQuality: 0.8)! as NSData : detect.jpegData(compressionQuality: 0.6)! as NSData
            let strBase64 = imageData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0));
            let str = "data:image/jpeg;base64,";
            let imgBase64 = str + strBase64;
            
            let currentDate = Date()
            let isoFormatter = DateFormatter()
            isoFormatter.dateFormat = "YYYY-MM-dd hh:mm:ss"
            let date = isoFormatter.string(from: currentDate);
            print(date)
            for (key,val) in self.timeZoneAbbreviations {
                let localTimeZone = val
                if localTimeZone == self.localTimeZoneName {
                    let tweakImageParams : [String : String] = ["fromOs" : "IOS", "lat" : self.latitude, "lng" : self.longitude, "newImage" : imgBase64, "userLocalTime" : date, "userLocalTimezone" : key, "fbNotify": "1" ];
                    // “userLocalTime”: “2019-06-17 14:00:00",
                    //“userLocalTimezone”: “IST”
                    DispatchQueue.main.async() {
                        
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
                        let clickViewController = storyBoard.instantiateViewController(withIdentifier: "TweakShareViewController") as! TweakShareViewController;
                        clickViewController.tweakImage = detect  as UIImage;
                        clickViewController.parameterDict1 = tweakImageParams as [String : AnyObject];
                        clickViewController.tweakCount = self.tweakCount
                        self.navigationController?.pushViewController(clickViewController, animated: false);
                        
                    }
                    return
                }
            }
            
            let tweakImageParams : [String : String] = ["fromOs" : "IOS", "lat" : self.latitude, "lng" : self.longitude, "newImage" : imgBase64, "userLocalTime" : date, "userLocalTimezone" : "", "fbNotify": "1" ];
            // “userLocalTime”: “2019-06-17 14:00:00",
            //“userLocalTimezone”: “IST”
            DispatchQueue.main.async() {
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
                let clickViewController = storyBoard.instantiateViewController(withIdentifier: "TweakShareViewController") as! TweakShareViewController;
                clickViewController.tweakImage = detect  as UIImage;
                clickViewController.parameterDict1 = tweakImageParams as [String : AnyObject];
                
                self.navigationController?.pushViewController(clickViewController, animated: false);
                
            }
            
            
            
        }
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        
        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage {
            self.faceDetection(detect: image)
            dismiss(animated:false, completion: nil);
            
        }
        
    }
    
    
    @objc func getProfileData() {
        if UserDefaults.standard.value(forKey: "userSession") as? String != nil {
            APIWrapper.sharedInstance.postRequestWithHeaders(TweakAndEatURLConstants.PROFILEFACTS, userSession: UserDefaults.standard.value(forKey: "userSession") as! String, success: { response in
                DispatchQueue.main.async {
                       MBProgressHUD.hide(for: self.view, animated: true);
                       }
                let responseDic : [String:AnyObject] = response as! [String:AnyObject];
                if responseDic.count == 2 {
                    let responseResult =  responseDic["profileData"] as! [String : Int]
                    let chartValues = TweakPieChartValues()
                    chartValues.id = self.incrementID()
                    chartValues.carbsPerc = responseResult["carbsPerc"]!
                    chartValues.proteinPerc = responseResult["proteinPerc"]!
                    chartValues.fatPerc = responseResult["fatPerc"]!
                    chartValues.fiberPerc = responseResult["otherPerc"]!
                    saveToRealmOverwrite(objType: TweakPieChartValues.self, objValues: chartValues)
                }
                
                self.switchToSeventhScreen(isInfoIconTapped: false)
                
                
            }, failure : { error in
                DispatchQueue.main.async {
                       MBProgressHUD.hide(for: self.view, animated: true);
                       }
//                let alertController = UIAlertController(title: self.bundle.localizedString(forKey: "no_internet", value: nil, table: nil), message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil), preferredStyle: UIAlertController.Style.alert)
//
//                let defaultAction = UIAlertAction(title:  self.bundle.localizedString(forKey: "ok", value: nil, table: nil), style: .cancel, handler: nil)
//                alertController.addAction(defaultAction)
//                self.present(alertController, animated: true, completion: nil)
                
            })
        }
        
    }
    
    @IBAction func dismissTapped(_ sender: Any)  {
        self.faceDetectionView.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        self.settingsBarButton.isEnabled = true
    }
    
    @IBAction func tweakStreakCountButtonTapped(_ sender: Any)  {
    }
    
    @IBAction func announcementsBtnTapped(_ sender: Any) {
        //self.performSegue(withIdentifier: "checkThisOut", sender: self)
    }
    
    @IBAction func myProfileButtonTapped(_ sender: Any) {
    }
    
    @IBAction func buzzButtonTapped(_ sender: Any) {
    }
    
    @IBAction func myWallButtonTapped(_ sender: Any) {
    }
    
    @IBAction func myEDRButtonTapped(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "myEDR"{
            let destination = segue.destination as! TimelinesViewController
            destination.fromScreen = "welcome"
        } else if segue.identifier == "profile" {
            let destination = segue.destination as! ProfileViewController
            destination.profileSegmantControl.selectedSegmentIndex = 1
            //floatingToNutrition
        } else if segue.identifier == "floatingToNutrition" {
            let pkgID = sender as! String
            let popOverVC = segue.destination as! NutritionLabelViewController;
            popOverVC.packageID = pkgID
        
        } else if segue.identifier == "nutritionPack" {
            if (sender is [String: AnyObject]) {
                let popOverVC = segue.destination as! NutritionLabelViewController;
                let cellDict = sender as! [String: AnyObject];
                popOverVC.packageID = (cellDict["packageId"] as AnyObject as? String)!;
                popOverVC.packageObj = cellDict as NSDictionary
                // popOverVC.fromCrown = self.fromCrown
            }
        } else if segue.identifier == "purchasedPackages" {
            let popOverVC = segue.destination as! PurchasedPackagesViewController
            popOverVC.packageIDArray = self.packageIDArray
            
        } else if segue.identifier == "buyPackages" {
            let popOverVC = segue.destination as! AvailablePremiumPackagesViewController
            popOverVC.fromCrown = self.fromCrown
            popOverVC.packageIDArray = self.packageIDArray
            popOverVC.indTAE = self.userSubscribedTAE
            popOverVC.indMyAidp = self.userIndMyAidpSub
        } else if segue.identifier == "fromAdsToPurchase" {
            let popOverVC = segue.destination as! PurchasedPackagesViewController
            popOverVC.packageIDArray = self.packageIDArray
            let cellDict = sender as! [String: AnyObject]
            popOverVC.smallImage = (cellDict["imgSmall"] as AnyObject as? String)!
            
            if UserDefaults.standard.value(forKey: "PREMIUM_MEMBER") != nil {
                let pkgID = (cellDict["packageId"] as AnyObject as? String)!
                let pkgsArray = UserDefaults.standard.value(forKey: "PREMIUM_PACKAGES") as! NSArray
                
                for dict in pkgsArray {
                    let pkgDict = dict as! [String: AnyObject]
                    if pkgDict["premium_pack_id"] as! String == pkgID {
                        let fbNutID = pkgDict[pkgID] as! String
                        UserDefaults.standard.setValue(fbNutID, forKey: "NutritionistFirebaseId")
                    }
                }
            }
            popOverVC.smallImage = (cellDict["imgSmallPremium"] as AnyObject as? String)!
            
            
            
        }
//        else if segue.identifier == "AIDP" {
//            let popOverVC = segue.destination as! AiDPViewController
//            let cellDict = sender as! [String: AnyObject]
//            popOverVC.smallImage = (cellDict["imgSmall"] as AnyObject as? String)!
//
//            if UserDefaults.standard.value(forKey: "PREMIUM_MEMBER") != nil {
//                let pkgID = (cellDict["packageId"] as AnyObject as? String)!
//                let pkgsArray = UserDefaults.standard.value(forKey: "PREMIUM_PACKAGES") as! NSArray
//                for dict in pkgsArray {
//                    let pkgDict = dict as! [String: AnyObject]
//                    if pkgDict["premium_pack_id"] as! String == pkgID {
//                        let fbNutID = pkgDict[pkgID] as! String
//                        UserDefaults.standard.setValue(fbNutID, forKey: "NutritionistFirebaseId")
//                    }
//                }
//            }
//            popOverVC.smallImage = (cellDict["imgSmallPremium"] as AnyObject as? String)!
//
//
//
//        }
        else if segue.identifier == "fromAdsToAiDP" {
            let popOverVC = segue.destination as! AiDPViewController
            let cellDict = sender as! [String: AnyObject]
            popOverVC.smallImage = (cellDict["imgSmall"] as AnyObject as? String)!
            
            if UserDefaults.standard.value(forKey: "PREMIUM_MEMBER") != nil {
                let pkgID = (cellDict["packageId"] as AnyObject as? String)!
                let pkgsArray = UserDefaults.standard.value(forKey: "PREMIUM_PACKAGES") as! NSArray
                for dict in pkgsArray {
                    let pkgDict = dict as! [String: AnyObject]
                    if pkgDict["premium_pack_id"] as! String == pkgID {
                        let fbNutID = pkgDict[pkgID] as! String
                        UserDefaults.standard.setValue(fbNutID, forKey: "NutritionistFirebaseId")
                    }
                }
            }
            popOverVC.smallImage = (cellDict["imgSmallPremium"] as AnyObject as? String)!
            
            
            
        } else if segue.identifier == "fromAdsToMore" {
            let popOverVC = segue.destination as! AvailablePremiumPackagesViewController
            
            let cellDict = sender as AnyObject as! [String: AnyObject]
            popOverVC.packageID = (cellDict["packageId"] as AnyObject as? String)!
            popOverVC.fromHomePopups = true
            
            
//            popOverVC.smallImage = (cellDict["imgSmall"] as AnyObject as? String)!
//            let msisdn = UserDefaults.standard.value(forKey: "msisdn") as! String;
//            popOverVC.msisdn = "+\(msisdn)";
//            let htmlStr = (cellDict["packageFullDesc"] as AnyObject as? String)!
//            popOverVC.packageFullDesc = htmlStr.html2String
//
//
//            let packagePrice = cellDict["packagePrice"] as! NSMutableArray
//            for pkgPrice in packagePrice {
//                var pkg =  pkgPrice as! NSDictionary
//                if pkg["countryCode"] as AnyObject as! String == self.countryCode {
//                    popOverVC.price = "\(pkg["transPayment"] as AnyObject as! Double)"
//                    popOverVC.paymentType = "\(pkg["paymentType"] as AnyObject as! String)"
//                    popOverVC.currency = "\(pkg["currency"] as AnyObject as! String)"
//
//                }
//            }
//
//            popOverVC.package = (cellDict["packageTitle"] as AnyObject as? String)!
//            self.myProfileInfo = uiRealm.objects(MyProfileInfo.self);
//            for myProfileObj in self.myProfileInfo! {
//                self.name = myProfileObj.name
//            }
//            popOverVC.name = self.name
//            popOverVC.packageId = (cellDict["packageId"] as AnyObject as? String)!
            
        } else if segue.identifier == "myTweakAndEat" {
            let destination = segue.destination as! MyTweakAndEatVCViewController
           // if self.countryCode == "91" {
                let pkgID = sender as! String
                destination.packageID = pkgID

           // }
        } else if segue.identifier == "moreInfo" {
            if let cellDict = sender as? [String: AnyObject] {
                let popOverVC = segue.destination as! MoreInfoPremiumPackagesViewController;
                popOverVC.smallImage = (cellDict["imgSmall"] as AnyObject as? String)!;
                let msisdn = UserDefaults.standard.value(forKey: "msisdn") as! String;
                popOverVC.msisdn = "+\(msisdn)";
                let htmlStr = (cellDict["packageFullDesc"] as AnyObject as? String)!;
                popOverVC.packageFullDesc = htmlStr.html2String;
                
                let packagePrice = cellDict["packagePrice"] as! NSMutableArray;
                for pkgPrice in packagePrice {
                    let pkg =  pkgPrice as! NSDictionary;
                    if pkg["countryCode"] as AnyObject as! String == self.countryCode {
                        if ((cellDict["packageId"] as AnyObject as? String)! == "-TacvBsX4yDrtgbl6YOQ" || (cellDict["packageId"] as AnyObject as? String)! == "-Qis3atRaproTlpr4zIs" ||  (cellDict["packageId"] as AnyObject as? String)! == "-IndIWj1mSzQ1GDlBpUt" ||  (cellDict["packageId"] as AnyObject as? String)! == "-AiDPwdvop1HU7fj8vfL" ||  (cellDict["packageId"] as AnyObject as? String)! == "-MalAXk7gLyR3BNMusfi" ||  (cellDict["packageId"] as AnyObject as? String)! == "-MzqlVh6nXsZ2TCdAbOp" ||  (cellDict["packageId"] as AnyObject as? String)! == "-SgnMyAiDPuD8WVCipga" ||  (cellDict["packageId"] as AnyObject as? String)! == "-IdnMyAiDPoP9DFGkbas" ||  (cellDict["packageId"] as AnyObject as? String)! == "-IndWLIntusoe3uelxER") {
                        } else {
                            popOverVC.price = "\(pkg["transPayment"] as AnyObject as! Double)";
                            popOverVC.paymentType = "\(pkg["paymentType"] as AnyObject as! String)";
                            popOverVC.currency = "\(pkg["currency"] as AnyObject as! String)";
                        }
                        
                    }
                }
                
                popOverVC.package = (cellDict["packageTitle"] as AnyObject as? String)!;
                popOverVC.name = self.name;
                popOverVC.packageId = (cellDict["packageId"] as AnyObject as? String)!;
                
            }
        } else if segue.identifier == "gamify" {
            let destination = segue.destination as! GamifyViewController;
            if self.sectionsForGamifyArray.count > 1 {
            destination.lastIndexSection = self.sectionsForGamifyArray.last!
            } else if self.sectionsForGamifyArray.count == 1 {
            destination.lastIndexSection = self.sectionsForGamifyArray.first!
            }
            var sectionsArray = [[String: AnyObject]]()
            for obj in self.sectionsForGamifyArray {
                let sections = obj
                if sections.index(forKey: "title") != nil {
                sectionsArray.append(sections)
                }
            }
            destination.sectionsArray = sectionsArray

        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    
    
    @IBAction func myFitnessBtnTapped(_ sender: Any) {
        
        self.fitnessBtnAction()
        
    }
    
    func fitnessBtnAction() {
        if (UserDefaults.standard.value(forKey: "FITBIT_TOKEN") == nil && UserDefaults.standard.value(forKey: "HEALTHKIT") == nil)  {
            
            self.performSegue(withIdentifier: "connectNewDevice", sender: self)
            
        } else if (UserDefaults.standard.value(forKey: "HEALTHKIT") == nil &&  UserDefaults.standard.value(forKey: "FITBIT_TOKEN") != nil) {
            self.performSegue(withIdentifier: "activityTracker", sender: self)
            
        } else if (UserDefaults.standard.value(forKey: "HEALTHKIT") != nil &&  UserDefaults.standard.value(forKey: "FITBIT_TOKEN") == nil) {
            self.performSegue(withIdentifier: "activityTracker", sender: self)
            
        }
    }
    
    @IBAction func myEdrTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "myEDR", sender: self)
    }
    
    @IBAction func refreshTweakCountTapped(_ sender: Any) {
//        if self.tweakStreakLbl.text == bundle.localizedString(forKey: "my_tweak_streak", value: nil, table: nil) {
//          //  DispatchQueue.main.async {
//            self.tweakCountLbl.text = self.totalTweakCount
//
//            self.tweakStreakLbl.text =  self.bundle.localizedString(forKey: "my_tweak_total", value: nil, table: nil)
//      //  }
//        } else if self.tweakStreakLbl.text == bundle.localizedString(forKey: "my_tweak_total", value: nil, table: nil) {
//           // DispatchQueue.main.async {
//            self.tweakCountLbl.text = self.tweakStreakCount
//
//            self.tweakStreakLbl.text = self.bundle.localizedString(forKey: "my_tweak_streak", value: nil, table: nil)
//           // }
//        }
        
        if self.tweakStreakCountButton.currentImage == UIImage.init(named: "my_tweak_streak.png") {
                        self.tweakCountLbl.text = self.tweakStreakCount
            
        } else {
                      self.tweakCountLbl.text = self.totalTweakCount

        }

        
    }
    
    @objc func getCountryPhonceCode (_ country : String) -> String {
        var countryDictionary  = ["AF":"93",
                                  "AL":"355",
                                  "DZ":"213",
                                  "AS":"1",
                                  "AD":"376",
                                  "AO":"244",
                                  "AI":"1",
                                  "AG":"1",
                                  "AR":"54",
                                  "AM":"374",
                                  "AW":"297",
                                  "AU":"61",
                                  "AT":"43",
                                  "AZ":"994",
                                  "BS":"1",
                                  "BH":"973",
                                  "BD":"880",
                                  "BB":"1",
                                  "BY":"375",
                                  "BE":"32",
                                  "BZ":"501",
                                  "BJ":"229",
                                  "BM":"1",
                                  "BT":"975",
                                  "BA":"387",
                                  "BW":"267",
                                  "BR":"55",
                                  "IO":"246",
                                  "BG":"359",
                                  "BF":"226",
                                  "BI":"257",
                                  "KH":"855",
                                  "CM":"237",
                                  "CA":"1",
                                  "CV":"238",
                                  "KY":"345",
                                  "CF":"236",
                                  "TD":"235",
                                  "CL":"56",
                                  "CN":"86",
                                  "CX":"61",
                                  "CO":"57",
                                  "KM":"269",
                                  "CG":"242",
                                  "CK":"682",
                                  "CR":"506",
                                  "HR":"385",
                                  "CU":"53",
                                  "CY":"537",
                                  "CZ":"420",
                                  "DK":"45",
                                  "DJ":"253",
                                  "DM":"1",
                                  "DO":"1",
                                  "EC":"593",
                                  "EG":"20",
                                  "SV":"503",
                                  "GQ":"240",
                                  "ER":"291",
                                  "EE":"372",
                                  "ET":"251",
                                  "FO":"298",
                                  "FJ":"679",
                                  "FI":"358",
                                  "FR":"33",
                                  "GF":"594",
                                  "PF":"689",
                                  "GA":"241",
                                  "GM":"220",
                                  "GE":"995",
                                  "DE":"49",
                                  "GH":"233",
                                  "GI":"350",
                                  "GR":"30",
                                  "GL":"299",
                                  "GD":"1",
                                  "GP":"590",
                                  "GU":"1",
                                  "GT":"502",
                                  "GN":"224",
                                  "GW":"245",
                                  "GY":"595",
                                  "HT":"509",
                                  "HN":"504",
                                  "HU":"36",
                                  "IS":"354",
                                  "IN":"91",
                                  "ID":"62",
                                  "IQ":"964",
                                  "IE":"353",
                                  "IL":"972",
                                  "IT":"39",
                                  "JM":"1",
                                  "JP":"81",
                                  "JO":"962",
                                  "KZ":"77",
                                  "KE":"254",
                                  "KI":"686",
                                  "KW":"965",
                                  "KG":"996",
                                  "LV":"371",
                                  "LB":"961",
                                  "LS":"266",
                                  "LR":"231",
                                  "LI":"423",
                                  "LT":"370",
                                  "LU":"352",
                                  "MG":"261",
                                  "MW":"265",
                                  "MY":"60",
                                  "MV":"960",
                                  "ML":"223",
                                  "MT":"356",
                                  "MH":"692",
                                  "MQ":"596",
                                  "MR":"222",
                                  "MU":"230",
                                  "YT":"262",
                                  "MX":"52",
                                  "MC":"377",
                                  "MN":"976",
                                  "ME":"382",
                                  "MS":"1",
                                  "MA":"212",
                                  "MM":"95",
                                  "NA":"264",
                                  "NR":"674",
                                  "NP":"977",
                                  "NL":"31",
                                  "AN":"599",
                                  "NC":"687",
                                  "NZ":"64",
                                  "NI":"505",
                                  "NE":"227",
                                  "NG":"234",
                                  "NU":"683",
                                  "NF":"672",
                                  "MP":"1",
                                  "NO":"47",
                                  "OM":"968",
                                  "PK":"92",
                                  "PW":"680",
                                  "PA":"507",
                                  "PG":"675",
                                  "PY":"595",
                                  "PE":"51",
                                  "PH":"63",
                                  "PL":"48",
                                  "PT":"351",
                                  "PR":"1",
                                  "QA":"974",
                                  "RO":"40",
                                  "RW":"250",
                                  "WS":"685",
                                  "SM":"378",
                                  "SA":"966",
                                  "SN":"221",
                                  "RS":"381",
                                  "SC":"248",
                                  "SL":"232",
                                  "SG":"65",
                                  "SK":"421",
                                  "SI":"386",
                                  "SB":"677",
                                  "ZA":"27",
                                  "GS":"500",
                                  "ES":"34",
                                  "LK":"94",
                                  "SD":"249",
                                  "SR":"597",
                                  "SZ":"268",
                                  "SE":"46",
                                  "CH":"41",
                                  "TJ":"992",
                                  "TH":"66",
                                  "TG":"228",
                                  "TK":"690",
                                  "TO":"676",
                                  "TT":"1",
                                  "TN":"216",
                                  "TR":"90",
                                  "TM":"993",
                                  "TC":"1",
                                  "TV":"688",
                                  "UG":"256",
                                  "UA":"380",
                                  "AE":"971",
                                  "GB":"44",
                                  "US":"1",
                                  "UY":"598",
                                  "UZ":"998",
                                  "VU":"678",
                                  "WF":"681",
                                  "YE":"967",
                                  "ZM":"260",
                                  "ZW":"263",
                                  "BO":"591",
                                  "BN":"673",
                                  "CC":"61",
                                  "CD":"243",
                                  "CI":"225",
                                  "FK":"500",
                                  "GG":"44",
                                  "VA":"379",
                                  "HK":"852",
                                  "IR":"98",
                                  "IM":"44",
                                  "JE":"44",
                                  "KP":"850",
                                  "KR":"82",
                                  "LA":"856",
                                  "LY":"218",
                                  "MO":"853",
                                  "MK":"389",
                                  "FM":"691",
                                  "MD":"373",
                                  "MZ":"258",
                                  "PS":"970",
                                  "PN":"872",
                                  "RE":"262",
                                  "RU":"7",
                                  "BL":"590",
                                  "SH":"290",
                                  "KN":"1",
                                  "LC":"1",
                                  "MF":"590",
                                  "PM":"508",
                                  "VC":"1",
                                  "ST":"239",
                                  "SO":"252",
                                  "SJ":"47",
                                  "SY":"963",
                                  "TW":"886",
                                  "TZ":"255",
                                  "TL":"670",
                                  "VE":"58",
                                  "VN":"84",
                                  "VG":"284",
                                  "VI":"340",
                                  "IDN":"62",
                                  "MYS":"60"]
        if countryDictionary[country] != nil {
            return countryDictionary[country]!
        }
            
        else {
            return ""
        }
    }
    
    @IBAction func goPremiumTapped(_ sender: Any) {
       self.myNutritionViewLast10TweaksTableView.isHidden = true
       self.myNutritionViewSelectYourMealTableView.isHidden = true
       self.mealTypeTableView.isHidden = true
        CleverTap.sharedInstance()?.recordEvent("visit_premium_packages")

        fromCrown = false
//        if countryCode == "91" {
//            Analytics.logEvent("TAE_GO_PREM_CLICKED_IND", parameters: [AnalyticsParameterItemName: "Go Premium Tapped On Home Page"])
//        }
        if UserDefaults.standard.value(forKey: "COUNTRY_CODE") != nil {
                   self.countryCode = "\(UserDefaults.standard.value(forKey: "COUNTRY_CODE") as AnyObject)"
        //if self.countryCode == "62" {
//        if UserDefaults.standard.value(forKey: "-ClubIdn4hd8flchs9Vy") != nil {
//                              self.goToTAEClubMemPage()
//
//                          } else {
//                              self.goToTAEClub()
//                          }
//            } else {
//                self.performSegue(withIdentifier: "buyPackages", sender: self);
//
//            }
            self.performSegue(withIdentifier: "buyPackages", sender: self);

        }

        
    }
    
    @objc func getNutritionistFBID() {
        let dictionary = ["key1":""]
        if UserDefaults.standard.string(forKey: "userSession") != nil{
            let userSession : String = UserDefaults.standard.value(forKey: "userSession") as! String;
            APIWrapper.sharedInstance.userPremiumPackages(sessionString: userSession, dictionary as NSDictionary, successBlock: {(responseDic : AnyObject!) -> (Void) in
                print("Sucess");
                print(responseDic)
                if responseDic["CallStatus"] as AnyObject as! String == "GOOD" {
                    DispatchQueue.global().async() {
                        
                        let dataDict = responseDic["Data"] as AnyObject as! NSDictionary
                        let dataElement = dataDict["UserPremiumPacks"] as AnyObject as! NSArray
                        var packageDictionary = [String: AnyObject]()
                        var pkgDetailsArray = NSMutableArray()
                        if dataElement.count > 0 {
                            for dict in dataElement {
                                let infoDict = dict as! [String: AnyObject]
                                let nutFBID = infoDict["nut_fb_uid"] as! String
                                let pkgID = infoDict["premium_pack_id"] as! String
                                let datePurchased = infoDict["premium_crt_dttm"] as! String
                                let amountPurchased = infoDict["premium_pay_amount"] as AnyObject
                                packageDictionary["datePurchased"] = datePurchased as AnyObject
                                packageDictionary["amountPurchased"] = amountPurchased as AnyObject
                                packageDictionary["premium_pack_id"] = pkgID as AnyObject
                                packageDictionary["nut_fb_uid"] = nutFBID as AnyObject
                                packageDictionary[pkgID] = nutFBID as AnyObject
                                pkgDetailsArray.add(packageDictionary)
                            }
                            UserDefaults.standard.setValue(pkgDetailsArray, forKey: "PREMIUM_PACKAGES")
                            UserDefaults.standard.setValue(pkgDetailsArray, forKey: "PREMIUM_MEMBER")
                            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true);
                }
                            if let currentUserID = Auth.auth().currentUser?.uid {
                                
                                self.getFirebaseData()
                            }
                            
                        } else if dataElement.count == 0 {
                            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true);
                }
                            if let currentUserID = Auth.auth().currentUser?.uid {
                                
                                self.getFirebaseData()
                            }
                        }
                    }
                }
                
            }, failureBlock: {(error : NSError!) -> (Void) in
                print("Failure");
                //            TweakAndEatUtils.AlertView.showAlert(view: self, message: self.bundle.localizedString(forKey: "check_internet_connection", value: nil, table: nil))
                
            })
        }
    }
    @objc func gotToDesiredPackageViewController() {
        if UserDefaults.standard.value(forKey: "PREMIUM_MEMBER") != nil {
            
            self.packageIDArray = NSMutableArray()
            DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view, animated: true);
                }
            let dispatch_group = DispatchGroup()
            dispatch_group.enter()
            
            if UserDefaults.standard.value(forKey: "PREMIUM_PACKAGES") != nil {
                let pkgsArray = UserDefaults.standard.value(forKey: "PREMIUM_PACKAGES") as! NSArray
                
                for pkgID in pkgsArray {
                    let pkgDict = pkgID as! [String: AnyObject]
                    let pkgIDs = pkgDict["premium_pack_id"] as! String
                    self.packageIDArray.add(pkgIDs)
                    
                }
                dispatch_group.leave()
                
                dispatch_group.notify(queue: DispatchQueue.main) {
                    MBProgressHUD.hide(for: self.view, animated: true);
                    self.performSegue(withIdentifier: "buyPackages", sender: self)
                    
                    
                }
                
            }
            
        }  else {
          
            self.performSegue(withIdentifier: "buyPackages", sender: self)
        }
    }
    
    @IBAction func premiumIconBarButtonTapped(_ sender: Any) {
        ////self.premiumIconBarButton.isEnabled = false
        fromCrown = true
        self.performSegue(withIdentifier: "buyPackages", sender: self)
        
    }
    
    @IBAction func introVideoTapped(_ sender: Any) {
        
        self.performSegue(withIdentifier: "nutritionPack", sender: self)
        
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUNNotificationSoundName(_ input: String) -> UNNotificationSoundName {
    return UNNotificationSoundName(rawValue: input)
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}

//MARK: - COLLECTIONVIEW DELEGATE AND DATASOURCE METHODS

extension WelcomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.tweakFinalView.imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath) as! HorizontalStepsIntroCell
       
        item.itemImageView.image = UIImage.init(named: self.tweakFinalView.imageArray[indexPath.row].image)!
        return item
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = self.tweakFinalView.collectionView.contentOffset.x / self.tweakFinalView.collectionView.frame.width
        self.tweakFinalView.pageControl.currentPage = Int(pageNumber)
        if Int(pageNumber) == self.tweakFinalView.imageArray.count - 1 {
            self.tweakFinalView.letsTweakBtn.isHidden = false
        } else {
            self.tweakFinalView.letsTweakBtn.isHidden = true

        }
    }
    
    
}

//MARK: - UICollectionViewDelegateFlowLayout

extension WelcomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = self.tweakFinalView.collectionView.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

//
//  ShortsViewController.swift
//  GluedInExample
//
//  Created by Ashish Verma on 10/09/24.
//

import UIKit
import GluedInSDK
import GluedInCoreSDK

class ShortsViewController: BaseViewController {

    @IBOutlet weak var buttonLaunchSDK: UIButton!
    
    var barButtonSignIn: UIBarButtonItem?
    var barButtonSignUp: UIBarButtonItem?
    var barButtonLogout: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonLaunchSDK.layer.cornerRadius = 4.0
        buttonLaunchSDK.layer.masksToBounds = true
        
        barButtonSignIn = UIBarButtonItem(
            title: "SignIn",
            style: .plain,
            target: self,
            action: #selector(onTappedSignIn)
        )
        

        barButtonSignUp = UIBarButtonItem(
            title: "SignUp",
            style: .plain,
            target: self,
            action: #selector(onTappedSignUp)
        )
        
        navigationItem.leftBarButtonItems = [barButtonSignIn!, barButtonSignUp!]
        
        barButtonLogout = UIBarButtonItem(
            title: "Logout",
            style: .plain,
            target: self,
            action: #selector(onTappedLogout)
        )
        
        navigationItem.rightBarButtonItems = [barButtonLogout!]
    }
    
    @objc func onTappedSignIn() {
        let bundle = Bundle(for: SignInViewController.self)
        let storyBoard = UIStoryboard(name: StoryBoards.SignIn.localizedString, bundle: bundle)
        if let controller = storyBoard.instantiateViewController(
            withIdentifier: SignInViewController.className
        ) as? SignInViewController {
            controller.delegate = self
            controller.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @objc func onTappedSignUp() {
        let bundle = Bundle(for: SignUpViewController.self)
        let storyBoard = UIStoryboard(name: StoryBoards.SignUp.localizedString, bundle: bundle)
        if let controller = storyBoard.instantiateViewController(
            withIdentifier: SignUpViewController.className
        ) as? SignUpViewController {
            controller.delegate = self
            controller.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @objc func onTappedLogout() {
        Auth.sharedInstance.logout { [weak self] status, msg in
            guard let weakSelf = self else { return }
            if status ?? false {
                GlobalManager.shared.setUserLoggedIn(false)
                weakSelf.updateNavigationBarOptions()
            }
            weakSelf.showAlert(title: "", message: msg ?? "")
        }
    }
    
    @IBAction func onTappedLaunchSDK(_ sender: UIButton) {
        GluedIn.shared.initSdk { [weak self] in
            guard let weakSelf = self else { return }
            if let controller = GluedIn.shared.rootControllerWithSignIn(userType: nil, adsParameter: nil, delegate: self) {
                weakSelf.updateNavigationBarOptions()
                controller.hidesBottomBarWhenPushed = true
                weakSelf.navigationController?.pushViewController(controller, animated: true)
            }
        } failure: { [weak self] error, code in
            guard let weakSelf = self else { return }
            weakSelf.showAlert(title: "Error Code: \(code)", message: error)
        }
    }
    
    func launchSDK(
        emailId: String,
        password: String,
        fullName: String = "",
        completionHandler: @escaping (_ viewController: UIViewController?) -> Void,
        failureHandler: @escaping (_ error: String, _ code: Int) -> Void
    ) {
        GluedIn.shared.initSdk {
            GluedIn.shared.quickLaunch(
                email: emailId,
                password: password,
                firebaseToken: "",
                deviceId: "",
                deviceType: "ios",
                fullName: fullName,
                autoCreate: false,
                termConditionAccepted: true,
                userType: "",
                adsParameter: nil,
                delegate: self
            ) { viewController in
                // Call the completion handler
                completionHandler(viewController)
            } failure: { error, code in
                failureHandler(error, code)  // Use failure handler
            }
        } failure: { error, code in
            failureHandler(error, code)  // Use failure handler
        }
    }
    
    func updateNavigationBarOptions() -> () {
        let status = GlobalManager.shared.isUserLoggedIn()
        barButtonSignIn?.isEnabled = !status
        barButtonSignUp?.isEnabled = !status
        barButtonLogout?.isEnabled = status
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateNavigationBarOptions()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

}

extension ShortsViewController: SignInViewControllerDelgate, SignUpViewControllerDelgate {
    
    func didUserSignIn(emailId: String, password: String) {
        launchSDK(emailId: emailId, password: password) { [weak self] viewController in
            guard let weakSelf = self else { return }
            if let controller = viewController {
                GlobalManager.shared.setUserLoggedIn(true)
                weakSelf.updateNavigationBarOptions()
                controller.hidesBottomBarWhenPushed = true
                weakSelf.navigationController?.pushViewController(controller, animated: true)
            }
        } failureHandler: { [weak self] error, code in
            guard let weakSelf = self else { return }
            weakSelf.showAlert(title: "Error Code: \(code)", message: error)
        }
    }
    
    func didUserSignUp(emailId: String, password: String, fullName: String) {
        launchSDK(emailId: emailId, password: password, fullName: fullName) { [weak self] viewController in
            guard let weakSelf = self else { return }
            if let controller = viewController {
                GlobalManager.shared.setUserLoggedIn(true)
                weakSelf.updateNavigationBarOptions()
                controller.hidesBottomBarWhenPushed = true
                weakSelf.navigationController?.pushViewController(controller, animated: true)
            }
        } failureHandler: { [weak self] error, code in
            guard let weakSelf = self else { return }
            weakSelf.showAlert(title: "Error Code: \(code)", message: error)
        }
    }
    
}

extension ShortsViewController: GluedInDelegate {
    
    func contentSocialShare(contentURL: String, title: String, description: String, thumbnailImage: UIImage) {
        
    }
    
    func requestForBannerView(viewController: UIViewController?) -> UIView {
        return UIView()
    }
    
    func requestForAdsInter(view: UIViewController) {
        
    }
    
    func getNativeAdNibName() -> String {
        return ""
    }
    
    func requestNativeAdCell() -> UITableViewCell {
        return UITableViewCell()
    }
    
    func requestForAds(feed: GluedInCoreSDK.FeedModel?, genre: [String]?, dialect: [String]?, originalLanguage: [String]?, extraParams: [GluedInCoreSDK.GAMExtraParams]?, adsId: String?, adsFormatId: [String]?) {
        
    }
    
    func getNativeAdController() -> UIViewController? {
        return nil
    }
    
    func firebaseAnalyticsEvent(name: String, properties: [String : Any]) {
        
    }
    
    func appScreenViewEvent(journeyEntryPoint: String, deviceID: String, userEmail: String, userName: String, userId: String, version: String, platformName: String, pageName: String) {
        
    }
    
    func appViewMoreEvent(Journey_entry_point: String, device_ID: String, user_email: String, user_name: String, platform_name: String, page_name: String, tab_name: String, element: String, button_type: String) {
        
    }
    
    func appContentUnLikeEvent(eventName: String?, params: [String : Any]?) {
        
    }
    
    func appContentLikeEvent(eventName: String?, params: [String : Any]?) {
        
    }
    
    func appVideoReplayEvent(eventName: String?, params: [String : Any]?) {
        
    }
    
    func appSessionEvent(eventName: String?, params: [String : Any]?) {
        
    }
    
    func appVideoPlayEvent(eventName: String?, params: [String : Any]?) {
        
    }
    
    func appVideoPauseEvent(eventName: String?, params: [String : Any]?) {
        
    }
    
    func appVideoResumeEvent(eventName: String?, params: [String : Any]?) {
        
    }
    
    func appCommentsViewedEvent(eventName: String?, params: [String : Any]?) {
        
    }
    
    func appCommentedEvent(eventName: String?, params: [String : Any]?) {
        
    }
    
    func appContentNextEvent(eventName: String?, params: [String : Any]?) {
        
    }
    
    func appContentPreviousEvent(eventName: String?, params: [String : Any]?) {
        
    }
    
    func appVideoStopEvent(device_ID: String, content_id: String, user_email: String, user_name: String, user_id: String, platform_name: String, page_name: String, tab_name: String, creator_userid: String, creator_username: String, hashtag: String, content_type: String, gluedIn_version: String, played_duration: String, content_creator_id: String, dialect_id: String, dialect_language: String, genre: String, genre_id: String, shortvideo_labels: String, video_duration: String, feed: GluedInCoreSDK.FeedModel?) {
        
    }
    
    func appViewClickEvent(device_ID: String, user_email: String, user_name: String, user_id: String, platform_name: String, page_name: String, tab_name: String, content_type: String, button_type: String, cta_name: String, gluedIn_version: String, feed: GluedInCoreSDK.FeedModel?) {
        
    }
    
    func appUserFollowEvent(eventName: String?, params: [String : Any]?) {
        
    }
    
    func appUserUnFollowEvent(eventName: String?, params: [String : Any]?) {
        
    }
    
    func appCTAClickedEvent(eventName: String?, params: [String : Any]?) {
        
    }
    
    func appProfileEditEvent(eventName: String?, params: [String : Any]?) {
        
    }
    
    func appExitEvent(eventName: String?, params: [String : Any]?) {
        
    }
    
    func appClickHashtagEvent(eventName: String?, params: [String : Any]?) {
        
    }
    
    func appClickSoundTrackEvent(eventName: String?, params: [String : Any]?) {
        
    }
    
    func appContentMuteEvent(eventName: String?, params: [String : Any]?) {
        
    }
    
    func appContentUnmuteEvent(eventName: String?, params: [String : Any]?) {
        
    }
    
    func didSelectBack() {
        
    }
    
    func onGluedInShareAction(shareData: GluedInCoreSDK.ShareData) {
        
    }
    
    func appSkipLoginEvent(device_ID: String, platform_name: String, page_name: String) {
        
    }
    
    func didSelectParentApp() {
        
    }
    
    func appTabClickEvent(Journey_entry_point: String, device_ID: String, user_email: String, user_name: String, user_id: String, platform_name: String, page_name: String, tab_name: String, button_type: String, cta_name: String, gluedIn_version: String, played_duration: String, content_creator_id: String, video_duration: String) {
        
    }
    
    func appRegisterCTAClickEvent(device_ID: String, user_email: String, user_name: String, user_isFollow: String, user_following_count: String, user_follower_count: String, platform_name: String, page_name: String) {
        
    }
    
    func appLoginCTAClickEvent(device_ID: String, user_email: String, user_name: String, user_id: String, user_isFollow: String, user_following_count: String, user_follower_count: String, platform_name: String, page_name: String, tab_name: String, button_type: String, cta_name: String, gluedIn_version: String, content_creator_id: String, video_duration: String) {
        
    }
    
    func callClientSignInView() {
        navigationController?.popToViewController(self, animated: false)
        onTappedSignIn()
    }
    
    func callClientSignUpView() {
        navigationController?.popToViewController(self, animated: false)
        onTappedSignUp()
    }
    
    func appThumbnailClickEvent(device_ID: String, user_email: String, user_name: String, user_id: String, platform_name: String, page_name: String, tab_name: String, vertical_index: String, horizontal_index: String, element: String, content_type: String, content_genre: String, button_type: String, cta_name: String, gluedIn_version: String, content_creator_id: String, shortvideo_labels: String) {
        
    }
    
    func appLaunchEvent(email: String, username: String, userId: String, version: String, deviceID: String, platformName: String) {
        
    }
    
    func appChallengeJoinEvent(page_name: String, tab_name: String, element: String, button_type: String) {
        
    }
    
    func appSearchButtonClickEvent(eventName: String?, params: [String : Any]?) {
        
    }
    
    func appChallengeShareClickEvent(device_ID: String, user_email: String, user_name: String, platform_name: String, page_name: String, tab_name: String, element: String, button_type: String, success: String, failure_reason: String, creator_userid: String, creator_username: String) {
        
    }
    
    func appCreatorRecordingDoneEvent() {
        
    }
    
    func appCameraOpenEvent() {
        
    }
    
    func appCreatorFilterAddedEvent() {
        
    }
    
    func appCreatorMusicAddedEvent() {
        
    }
    
    func appCTAsClickEvent(device_ID: String, user_email: String, user_name: String, user_id: String, platform_name: String, page_name: String, tab_name: String, element: String, button_type: String, success: String, failure_reason: String, cta_name: String, gluedIn_version: String, played_duration: String, content_creator_id: String, video_duration: String) {
        
    }
    
    func appPopupLaunchEvent(device_ID: String, user_email: String, user_name: String, platform_name: String, page_name: String, tab_name: String, popup_name: String, cta_name: String, user_id: String, gluedIn_version: String, content_creator_id: String, video_duration: String) {
        
    }
    
    func appPopupCTAsEvent(device_ID: String, user_email: String, user_name: String, user_id: String, platform_name: String, page_name: String, tab_name: String, element: String, button_type: String, popup_name: String, cta_name: String, gluedIn_version: String, played_duration: String, content_creator_id: String, video_duration: String) {
        
    }
    
    func appCreatePostEvent(device_ID: String, user_email: String, user_name: String, platform_name: String, page_name: String, tab_name: String, element: String, button_type: String, success: String, failure_reason: String, creator_userid: String, creator_username: String, hashtag: String, content_type: String, content_genre: String) {
        
    }
    
    func appViewLeaderboardEvent(Journey_entry_point: String, device_ID: String, user_email: String, user_name: String, platform_name: String, page_name: String, tab_name: String, element: String, button_type: String) {
        
    }
    
    func appUseThisHashtagEvent(device_ID: String, user_email: String, user_name: String, platform_name: String, page_name: String, tab_name: String, element: String, button_type: String, hashtag: String, content_type: String, content_genre: String) {
        
    }
    
    func onUserProfileClick(userId: String) {
        
    }
}

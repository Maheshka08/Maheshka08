//Copyright (c) 2019-present, Flyshot, Inc. All rights reserved.
//
//For Flyshot iOS SDK software
//
//You are hereby granted a non-exclusive, worldwide, royalty-free license to use, copy, modify, and distribute this software in source code or binary form for use in connection with the web services and APIs provided by Flyshot.
//
//As with any software that integrates with the Flyshot platform, your use of this software is subject to the Flyshot Policies [https://flyshot.io/privacy-policy]. This copyright notice shall be included in all copies or substantial portions of the software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import UIKit
import StoreKit

/**
Implement this protocol to work with Flyshot In-App Purchases
*/
@objc public protocol FlyshotDelegate: AnyObject {
	/**
	Flyshot will rely on this method before invoking any in-app purchase
	Implementations should contain logic to check if Flyshot should be allowed to show In-App Purchase alert for particular Product Identifier
	*/
	@objc func allowFlyshotPurchase(productIdentifier: String) -> Bool
	
	/**
	This method will be invoked as a callback on In-App Purchase event made by Flyshot
	It will pass the same parameters as you would get from Apple StoreKit paymentQueue(_:updatedTransactions:) method
	No need to finish transactions
	*/
	@objc func flyshotPurchase(paymentQueue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction])
	
	/**
	Called when Flyshot campaign was detected.
	- parameters:
	   - productId: Identifier of detected campaign
	*/
	@objc func flyshotCampaignDetected(productId: String?)
}

/**
Class providing Sdk functionality
*/
@objc public class Flyshot: NSObject {
	/**
	Gets the singleton instance of a Flyshot.
	*/
	@objc public static let shared = Flyshot()
	
	/**
	Gets the singleton instance of a TestManager
	*/
	@objc public static let test = TestManager()
	
	
	// MARK: - Configuration
	
	/**
	The delegate that will be notified when Flyshot In-App Purchases occured
	*/
	@objc public weak var delegate: FlyshotDelegate?
	
	/**
		- Parameter appsflyerId: AppsFlyer identifier
	*/
	@objc public var appsflyerId: String? {
		set {
			FlyshotManager.shared.appsflyerId = newValue
		}
		get {
			FlyshotManager.shared.appsflyerId
		}
	}

	/**
	Existing user flag
	*/
	@objc public var isExistingUser: Bool {
		set {
			FlyshotManager.shared.isExistingUser = newValue
		}
		get {
			FlyshotManager.shared.isExistingUser
		}
	}
	
	/**
	Initialize SDK
		- Parameter sdkToken: license key
	*/
	@objc public func initialize(sdkToken: String, onSuccess: @escaping () -> Void,  onFailure: @escaping (_ error: Error) -> Void) {
		FlyshotManager.shared.initialize(sdkToken: sdkToken, onSuccess: onSuccess, onFailure: onFailure)
	}
	
	/**
	Starts SDK
	*/
	@objc public func start() {
		FlyshotManager.shared.start()
	} 
	
	// MARK: - Getters
	
	/**
	Returns true/false boolean if user is associated with Flyshot
	*/
	@objc public func isFlyshotUser() -> Bool {
		return FlyshotManager.shared.isFlyshotUser()
	}
	
	/**
	Returns true/false boolean if user is eligible for Flyshot discount
	*/
	@objc public func isEligibleForDiscount(productId: String? = nil) -> Bool {
		return FlyshotManager.shared.isEligibleForDiscount(productId: productId)
	}
	
	/**
	Returns true/false boolean if user is eligible for Flyshot discount
	*/
	@objc public func isEligibleForDiscount() -> Bool {
		return FlyshotManager.shared.isEligibleForDiscount()
	}
	
	/**
	Returns true/false boolean if user is eligible for Flyshot reward
	*/
	@objc public func isEligibleForReward(productId: String? = nil) -> Bool {
		return FlyshotManager.shared.isEligibleForDiscount(productId: productId)
	}
	
	/**
	Returns true/false boolean if user is eligible for Flyshot reward
	*/
	@objc public func isEligibleForReward() -> Bool {
		return FlyshotManager.shared.isEligibleForDiscount()
	}
	
	/**
	Returns true/false boolean if user is eligible for Flyshot promo
	*/
	@objc public func isEligibleForPromo(productId: String? = nil) -> Bool {
		return FlyshotManager.shared.isEligibleForDiscount(productId: productId)
	}
	
	/**
	Returns true/false boolean if user has active campaign
	*/
	@objc public func isCampaignActive(productId: String? = nil) -> Bool {
		return FlyshotManager.shared.isCampaignActive(productId: productId)
	}
		
	/**
	Returns true/false boolean if user is eligible for Flyshot promo
	*/
	@objc public func isEligibleForPromo() -> Bool {
		return FlyshotManager.shared.isEligibleForDiscount()
	}
	
	// MARK: - Promo
	
	/**
	 Scan for  Promo Screenshots
	 onComplete return true if active promo campaign was found
	*/
	@available(*, unavailable, message: "Use upload instead")
	@objc public func scan(onComplete: @escaping (_ isPromoCampaignFound: Bool) -> Void, onFailure: ((Error) -> Void)) {
	}
	
	/**
	Upload for Promo Screenshots
	onSuccess returns campaign status
	*/
	@objc public func upload(onSuccess: @escaping (_ status: CampaignStatus) -> Void, onFailure: @escaping (_ error: Error) -> Void) {
		CampaignFetcher.shared.upload(onSuccess: onSuccess, onCanceled: { () -> (Void) in
		}, onFailure: onFailure)
	}
	
	/**
	Fetch Active Campaign
	*/
	@available(iOS, unavailable, message: "Use content instead")
	@objc public func getActiveCampaign(onSuccess: ((PromoCampaign?) -> Void)? = nil, onFailure: ((Error) -> Void)? = nil) {
		PromoManager.shared.getActiveCampaign(onSuccess: onSuccess, onFailure: onFailure)
	}
	
	/**
	Returns an array of last uploaded content
	*/
	@objc public func getContent(onSuccess: (([Post]) -> Void)? = nil, onFailure: ((Error) -> Void)? = nil) {
		PromoManager.shared.getContent(onSuccess: onSuccess, onFailure: onFailure)
	}
	
	/**
	 Requests Promo View from  Flyshot's configuration
	*/
	@objc public func requestPromoBanner() {
		PromoManager.shared.fetchPromoCampaign()
	}
	
	// MARK: - Event Tracker
	
	/**
	Send 'Conversion' event to Flyshot Analytics
	
	- Parameter amount:     	Amount value of conversion
	- Parameter productId:  	Product identifier
	- Parameter currencyCode:	ISO currency code
	- Parameter onSuccess:  	A closure which is called when event sent  successfully
	- Parameter onFailure:  	A closure which is called when event sent was failed with error
	
	- Returns: No return value
	*/
	@objc public func sendConversionEvent(amount: Double, currencyCode: String?, productId: String?, onSuccess: @escaping (() -> Void),  onFailure: @escaping ((_ error: Error) -> Void)) {
		EventTracker.shared.sendConversionEvent(productId: productId, amount: amount, currencyCode: currencyCode, onSuccess: onSuccess, onFailure: onFailure)
	}
	
	@objc public func sendConversionEvent(amount: Double, currencyCode: String?, productId: String?) {
		EventTracker.shared.sendConversionEvent(productId: productId, amount: amount, currencyCode: currencyCode, onSuccess: nil, onFailure: nil)
	}
	
	@objc public func sendConversionEvent(amount: Double, currencyCode: String?, onSuccess: @escaping (() -> Void),  onFailure: @escaping ((_ error: Error) -> Void)) {
		EventTracker.shared.sendConversionEvent(productId: nil, amount: amount, currencyCode: currencyCode, onSuccess: onSuccess, onFailure: onFailure)
	}
	
	@objc public func sendConversionEvent(amount: Double, currencyCode: String?) {
		EventTracker.shared.sendConversionEvent(productId: nil, amount: amount, currencyCode: currencyCode, onSuccess: nil, onFailure: nil)
	}
	
	@objc public func sendConversionEvent(amount: Double, onSuccess: @escaping (() -> Void),  onFailure: @escaping ((_ error: Error) -> Void)) {
		EventTracker.shared.sendConversionEvent(productId: nil, amount: amount, currencyCode: nil, onSuccess: onSuccess, onFailure: onFailure)
	}
	
	@objc public func sendConversionEvent(amount: Double) {
		EventTracker.shared.sendConversionEvent(amount: amount)
	}
	
	/**
	Send event 'name' to Flyshot Analytics
	
	- Parameter name: name of custom action
	- Parameter onSuccess:  A closure which is called when event sent  successfully
	- Parameter onFailure:  A closure which is called when event sent was failed with error
	
	- Returns: No return value
	*/
	@objc public func sendCustomEvent(name: String, onSuccess: (() -> Void)? = nil,  onFailure: ((_ error: Error) -> Void)? = nil) {
		EventTracker.shared.sendCustomEvent(name: name, onSuccess: onSuccess, onFailure: onFailure)
	}
	
	/**
	Send event 'name' to Flyshot Analytics
	
	- Parameter name: name of custom action
	
	- Returns: No return value
	*/
	@objc public func sendCustomEvent(name: String) {
		EventTracker.shared.sendCustomEvent(name: name)
	}
	
	/**
	Send event 'name' to Flyshot Analytics
	
	- Parameter name: name of custom action
	- Parameter onSuccess:  A closure which is called when event sent  successfully
	- Parameter onFailure:  A closure which is called when event sent was failed with error
	
	- Returns: No return value
	*/
	@objc public func sendEvent(name: String, onSuccess: (() -> Void)? = nil,  onFailure: ((_ error: Error) -> Void)? = nil) {
		EventTracker.shared.sendCustomEvent(name: name, onSuccess: onSuccess, onFailure: onFailure)
	}
	
	/**
	Send event 'name' to Flyshot Analytics
	
	- Parameter name: name of custom action
	
	- Returns: No return value
	*/
	@objc public func sendEvent(name: String) {
		EventTracker.shared.sendCustomEvent(name: name)
	}
	
	/**
	Send 'Sign Up' event to Flyshot Analytics
	
	- Parameter onSuccess:  A closure which is called when event sent  successfully
	- Parameter  onFailure:  A closure which is called when event sent was failed with error
	
	- Returns: No return value
	*/
	@objc public func sendSignUpEvent(onSuccess: (() -> Void)? = nil,  onFailure: ((_ error: Error) -> Void)? = nil) {
		EventTracker.shared.sendSignUpEvent(onSuccess: onSuccess, onFailure: onFailure)
	}
	
	/**
	Send 'Sign Up' event to Flyshot Analytics
	
	- Returns: No return value
	*/
	@objc public func sendSignUpEvent() {
		EventTracker.shared.sendSignUpEvent()
	}
	
	// MARK: - Init
	
	private override init() {
		super.init()
		FlyshotManager.shared.delegate = self
	}
}

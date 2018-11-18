//
//  WebServiceProxy.swift
//  Foosto
//
//  Created by Sukhpreet Kaur on 3/10/18.
//  Copyright © 2018 Sukhpreet Kaur. All rights reserved.
//

import Foundation
import UIKit

enum AppInfo {
    static let Mode = "production"
    static let AppName = "YESWA"
    static let Version =  "1.2"
    static let UserAgent = "\(Mode)/\(AppName)/\(Version)"
    static let AppColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
    static let PlaceHolderColor = UIColor(red: 70/255, green: 89/255, blue: 105/255, alpha: 1)
    
}
enum Role {
    static let RollVendor = 1
    static let RollCustomer = 2
    
}

enum PaymentMode {
    static let CASH = 0
    static let CARD = 1
}

enum OrderState:Int{
    case STATE_NEW = 1 , STATE_ACCEPTED, STATE_REJECTED,STATE_CANCELLED,STATE_STARTED,STATE_COMPLETED
}


enum Apis {
    //MARK:- Cusotmer Module Apis
   // static let KServerUrl =  "http://jupiter.ozvid.in/yeswa/"
    static let KServerUrl =  "http://yeswa.shop/"
    static let KCheckUser = "\(Apis.KServerUrl)api/user/check?auth_code="
    static let KSignUp = "api/user/signup"
    static let KGetAllBrand = "api/product/get-all-brand-list"
    static let KGetAllProduct = "api/product/get-product-list"
    static let KGetSliderImg = "api/user/slider"
    static let KAddCartProduct = "api/product/add-to-cart"
    static let KGetCartProduct = "api/product/cart-item-list"
    static let KDeleteCartProduct = "api/product/delete-cart-item"
    static let KContactUsCustomer = "api/user/contact-us"
    static let KUpdateCartProduct = "api/product/update-cart-item?id="
    static let KPlaceOrder = "api/product/add-to-order"
    static let KGetOrderList = "api/order/order-list"
    static let KSearchBrand = "api/product/brand-search"
    static let KSearchCategory = "api/product/category-search"
    static let KSwitchUser = "api/user/switch-role"
    static let KChangeOrderState = "api/order/change-state"
    static let KHelpsupport = "api/user/pages"
    static let KchangePasswordCustomer = "api/user/change-password"
    static let KNearbyVendor = "api/user/geo-vendor"
    static let KUpdateCustomerDetails = "api/user/update-customer"
    static let KSearchVendor = "api/product/home-search?page"
    static let KGetGovernorateList = "api/product/get-country"
    static let KGetGovernorateRegionList = "api/product/get-state"
    static let KGetVendorProductsList = "api/product/vendor-product-list"
    static let KAddToWishList =  "api/product-favourite/add"
    static let KGetWishListProduct = "api/product-favourite/get-list"
    static let KCancelOrder = "api/order/order-cancel"
    static let KChangeLocationSetting = "api/user/on-off-location"
    static let KFilter = "api/product/filter"
    static let KGetLatestProdcut = "api/product/get-new-products"
    static let KGetOrderDetail = "api/order/order-detail"
    static let KGetCompleteOrderListVendor = "api/order/order-complete-list"
    static let KGetUserSale = "api/user/sale"
    
//MARK :both user Api
    static let KForgotPassword = "api/user/recover"
    static let KLogout = "api/user/logout"
    static let KLogin = "api/user/login"
    static let KgetCategoryList = "api/product/category-list"
    
    // MARK:- Vendor Module Apis
    static let KSignUpVendor = "api/user/vendor-signup"
    static let KLogoutVendor = "api/user/logout"
    static let KgetBrandList = "api/product/get-brand-list"
    static let KgetProductList = "api/product/get-myproduct-list"
    static let KAddBrand = "api/product/add-brand"
    static let KAddProductWithoutVarient = "api/product/add"
    static let KGetColor = "api/product/color-list"
    static let KGetSize = "api/product/size-list"
    static let KDeleteBrand = "api/product/delete-brand"
    static let KEditBrand = "api/product/update-brand"
    static let KAddProductVarient =  "api/product/add-product-variant"
    static let KEditProudct = "api/product/update?id="
    static let KDeleteProduct = "api/product/delete"
    static let KProfileUpdate = "api/user/update-profile"
    static let KProfileImageUpdate = "api/user/update-profile-image"
    static let KProductGet = "api/product/get?id="
    static let KDeleteVariant = "api/product/delete-variant?id="
    static let KProductImageDelete = "api/product/delete-product-image?id="
    static let KProductUpdateVarient = "api/product/update-variant?id="
    static let KAddProductImage = "api/product/add-product-image?id="
    static let KUpdateDetailsVendor = "api/user/vendor-update"
}


enum TabTitle{
    public static let TAB_Home = "Home"
    public static let TAB_GeoLocaton = "Geo Locatoin"
    public static let TAB_Category = "Category"
    public static let TAB_Profile = "Profile"
    public static let TAB_Brand = "Brand"
}

enum TabTitleVendor{
    public static let TAB_Home = "Home"
    public static let TAB_Orders = "Orders"
    public static let TAB_Payment = "Payment"
    public static let TAB_Profile = "Profile"
    public static let TAB_Logout = "Logout"
}

enum HelpType {
  static let TYPE_PRIVACY_POLICY = 0;
  static let TYPE_TERMS = 1;
  static let TYPE_ABOUT = 2;
  static let TYPE_HELP = 3;
}


enum StoryboardChnage{
    public static let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    public static let vendorStoryboard = UIStoryboard(name: "Vendor", bundle: nil)
}
enum ConstantValue {
    //Done On sting
    // LoginSignUp
    static var customer  = "CUSTOMER"
    static var vendor  = "VENDOR"
    static var firstName = "First Name"
    static var lastName = "Last Name"
    static var password =  "Password"
    static var confirmPassword = "Confirm Password"
    static var newPassword = "New Password"
    static var Email = "Email"
    static var whatsAppNumber = "whatsapp Number"
    static var civilid = "civil Id"
    static var shopName = "Shop Name"
    static var location =  "Location"
    static var next =  "Next"
    static var alreadyLogin = "Already have an account? Login"
    static var forgotPassword =  "Forgot Password?"
    static var signin =  "Sign in"
  
    static var newCreateAccount = "New here? Create an account"
    static var mobile1 =  "Mobile Number 1"
    static var mobile2 =  "Mobile Number 2"
    static var city =  "City"
    static var area =  "Area"
    static var block =  "Block"
    static var street =  "Street"
    static var house =  "House"
    static var appartment =  "Apartment"
    static var office =  "Office"
    static var signup =  "Sign up"
    // ForgotPass
    static var forgotPass =  "Forgot Password"
     static var send = "Send"
    static var enterEmail =  "Enter Email"
    static var enterEmailDes =  "Enter your email below to recieve your password reset instructions"
    // TabBar
    static var home =  "Home"
    static var geoLocation =  "Geo Location"
    static var categoty =  "Category"
    static var profile =  "Profile"
    static var logOut =  "Logout"
    static var order = "Orders"
    static var brands = "Brand"
    static var Payment = "Payment"
    // ViewHeaderTitle
    static var cart = "Cart"
    static var product = "Product"
    static var productDetails = "Product Details"
    static var checkout =  "Checkout"
    // Customer Views
    static var shopbyBrand =  "Shop by Brand"
    static var latestProudcts =  "Latest Proudcts"
    static var addToCart =  "Add to Cart"
    static var color = "Color"
    static var size = "Size"
    static var quantity = "Quantity"
    static var descriptions = "Descriptions"
    static var subTotal =  "Sub Total"
    static var priceDetail = "Price Detail"
    static var items = "Items"
    static var Doller = "KD"
    static var remove =  "Remove"
    static var Name =  "Name"
    static var mobile =  "Mobile Number"
    static var address =  "Address"
    static var orderSummary = "Order Summary"
    static var shipingCharge =  "Shipping Charge"
    static var total = "Total"
    static var paymode = "Payment Mode"
    static var cash = "Cash"
    static var placeanorder = "Place an Order"
    static var search =  "Search"
    static var searchbyName =  "Search by Name"
    static var loginPlease = "Please login first"
    static var ok = "Ok"
    static var cancel = "Cancel"
    static var sureToLogin = "Are you sure you want to login"
    static var myOrder = "My orders"
    static var myProfile = "My Profile"
    static var wishList = "WishList"
    static var changePass = "Change Password"
    static var switchTovendor = "Switch to Vendor"
    static var changeLanguage = "Change Language"
    static var help = "Help"
    static var tellTinkYeswa = "Tell us what you think of YESWA"
    static var signOut = "Sign out"
    static var myAccount = "My Account"
    static var edit = "Edit"
    static var hi = "Hi"
    static var orderHistory =  "Order History"
    static var cancelled = "Cancelled"
    static var completed = "Completed"
    static var pending = "Pending"
    static var orderNo = "Order Number"
    static var price = "Price"
    static var totalprice = "Total Price"
    static var deliveryAddress = "Delivery Address"
    static var deliveryTime = "Delivery Time"
    static var paymentMethod = "Payment Method"
    static var myDetails = "My Details"
    static var saveChanges = "Save Changes"
    static var selectGovern = "Select Governorate"
    static var selectRegion = "Select Region"
    static var addressLine = "Address line"
    static var PhoneNumber =  "Phone Number"
    static var done =  "Done"
    static var canContact = "You can contact with us :"
    static var Other = "Arabic"
    static var english = "English"
    static var selectLanguage = "Select Language"
    static var rateApp = "Rate the App"
    static var sendEmail = "Could Not Send Email"
    static var swichUser = "Switch User"
    static var addnewbrand =  "Add New Brand"
    static var save = "Save"
    static var update =  "Update"
    static var enterbrand =  "Enter brand "
    static var addNewProdouct =  "Add New Product"
    static var enterTitle  =  "Enter Title"
    static var trackOrder = "Track Order"
    static var orderTracking = "Order Tracking"
    static var addDescriptions = "Add Descriptions"
    static var addProduct = "Add Product"
    static var AddPhoto = "Add Photo"
    static var selectColor = "Select Color"
    static var selectSize = "Select Size"
    static var title  =  "Title"
    static var variantProduct  =  "Varient in the Product"
     static var addMoreVariant =  "Add more Varient"
    static var yourorders  = "Your Orders"
    static var accept = "Accept"
    static var reject = "Reject"
    static var started = "Started"
    static var complete = "Complete"
    static var shopMobNo = "Shop Mobile Number"
    static var shopAddress = "Shop Address"
    static var PaymentHeader = "Payments"
    static var orderDetails  = "Order Details"
    static var locationSetting = "Location Setting"
    static var showLocation = "Do you want show your location"
    static var yes =  "YES"
    static var no =  "NO"
    static var wantOrder = "Want to place order? Please login first!"
    static var gallery =  "Gallery"
    static var camera =  "Camera"
    static var selectBrand = "Select Brand"
    static var addProductVarient = "Add Product Varient"
    static var cameraNotSupport = "Camera is not supported"
    static var alert = "Alert"
    static var connectionProblem = "Connection Problem"
    static var checkConnection = "Please check your internet connection"
    static var locationProblem = "Location Problem"
    static var enableLocation = "Please enable your location"
    static var locationServicesDetermine =  "Location Services are not able to determine your location"
    static var locationServiceOff = "Location services are off"
    static var turnOnLocation = "To track a ride, you must turn on Location Services from Settings"
    static var settings =  "Settings"
    
    //new
    static var allProduct =  "All Product"
    static var discount =  "Discount"
    static var totalPrice =  "Total Price"
    //******************************* Done On string ****************
}

enum AlertValue {
    
    static var email =  "Please enter email"
    static var validEmail =  "Please enter valid email"
    static var password =  "Please enter password"
    static var loginsuccesfully = "Login succesfully"
    static var firstname = "Please enter first name"
    static var lastName = "Please enter last name"
    static var confirmPassword =  "Please enter confirm password"
    static var samePassword =  "Password does not match"
    static var signupsuccesfully = "Signup succesfully"
    static var whatAppNumber = "Please enter whatsApp Number"
    static var civilId = "Please enter civil id"
    static var shopName = "Please enter shopName"
    static var selectLocation = "Please enter Location"
    static var phoneNumber =  "Please enter phone number"
    static var city = "Please enter city"
    static var block = "Please enter Block"
    static var area = "Please enter Area"
    static var street = "Please enter Street"
    static var house = "Please enter House Number"
    static var appartment = "Please enter Apartment Number"
    static var office = "Please enter Office Address"
    static var switchRollSuccessfully  = "Switch Roll Successfully"
    static var cantDelImage  = "you can't delete image please add more image if you want to delete this"
    static var  imageDeleted =  "Image Deleted"
    static var  noProductinCartList = "No Product in Cart List"
    static var productaddedtoyourCartSuccessfully = "Product added to your Cart Successfully"
    static var selectAddres = "Please Select Address"
    static var name = "Please enter Name"
    static var orderbyCash = "Please make sure you place an order by Cash"
    static var OrderplaceSuccessfully = "Order place Successfully"
    static var profileUpdate = "Your profile is successfully updated"
    static var yourDetailsisupdatedsuccesfully  = "Your Details is updated succesfully"
    static var newPassword  =  "Please enter new password"
    static var passwordupdatedSuccessfully = "Password updated Successfully"
    static var notConnect = "Could not connect"
    static var selectCountryFirst = "Please select country First"
    static var country = "Please select Country "
    static var state = "Please enter state"
    static var zipcode = "Please enter zipcode"
    static var nomoreitemsareavailable = "No more items are available"
    static var deleteProductSuccessfully = "Delete Product Successfully"
    static var noAvailble = "No varients are available"
    static var youcangiveratetheappaftertheAppUpload = "You can give rate the app after the App Upload"
    static var pleaseReviewyournetworksettings = "Please Review your network settings"
    static var ErrorUnabletoencodeJSONResponse = "Error: Unable to encode JSON Response"
    static var urlError = "Please check the URL : 400"
    static var sessionError = "Session Logged out"
    static var urlNotExist = "URL does not exists : 404"
    static var UnauthorizedactionError = "Unauthorized to perform this action : 401"
    static var serverError = "Server error, Please try again.."
    static var title = "Please enter title"
    static var editbrandsuccessfully = "Edit brand successfully"
    static var addbrandsuccessfully = "Brand added successfully"
    static var description = "Please enter description"
    static var selectImage = "Please select at least one image of product"
    static var addProductSucessfully = "Product Added Sucessfully"
    static var fillField = "Fill all fileds"
    static var deletebrandsuccesfully = "delete brand succesfully"
    static var varientAddedSuccessfully = "Varient Added Successfully"
    static var youcantdeleteSingleVarient =  "You can't delete Single Varient"
    static var alreadyAdded = "Selected color already added"
    static var alreadySelectSize = "Selected size already added"
    static var pleaseEnter = "Please enter"
    static var value = "value"
    static var emailPassword = "Please check your Email"
    static var helpImprovetheApp = "Help Improve the App"
    static var notSendEmail = "Your device could not send e-mail.  Please check e-mail configuration and try again."
    static var  imageAdded =  "Image Added"
    static var  changePassSucc =  "Change Password Successfully"
    //******************************* Done On string ****************
    static var  enterValidChar =  "Please Enter atleast 8 characters"
    
 
}






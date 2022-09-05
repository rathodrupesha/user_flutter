import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'zh_local.dart';

class Translations implements WidgetsLocalizations {
  const Translations();

  static Translations? current;

  // Helper method to keep the code in the widgets concise Localizations are accessed using an InheritedWidget "of" syntax
  static Translations of(BuildContext context) {
    return Localizations.of<Translations>(context, Translations) ??
        const Translations();
  }

  // Static member to have a simple access to the delegate from the MaterialApp
  static const LocalizationsDelegate<Translations> delegate =
      _TranslationsDelegate();

  @override
  TextDirection get textDirection => TextDirection.ltr;

  String get appName => 'HamroStay Staff';

  /* Media Selection */
  String get strAlert => "Alert";
  String get strTakePhoto => "Take Photo";
  String get strChooseFromExisting => "Choose Photo";
  String get strImage => "Image";
  String get strVideo => "Video";

  /* Common Button List */
  String get btnCancel => 'Cancel';
  String get btnApply => 'Apply';
  String get btnCancelOrder => 'Cancel Order';
  String get btnOk => 'OK';
  String get btnDelete => 'Delete';
  String get btnDecline => 'Decline';
  String get btnAccept => 'Accept';
  String get btnSave => 'Save';
  String get btnSubmit => 'SUBMIT';
  String get btnSubmitSmall => 'Submit';
  String get btnYes => 'Yes';
  String get btnNo => 'No';
  String get btnDone => 'Done';
  String get btnEdit => 'Edit';
  String get btnAdd => 'Add';
  String get btnConfirm => 'Confirm';
  String get btnUpdate => 'Update';
  String get btnSkip => 'Skip';

  String get strAmenities => 'Amenities';
  String get strBillInformation => 'Bill Information';
  String get strTotalAmount => 'Total Amount';
  String get strViewCheckout => 'VIEW & CHECKOUT';
  String get strDescription => 'Description:';
  String get strAdditionalDetails => 'Additional Details:';
  String get strSendRequest => 'SEND REQUEST';
  String get strSlotNotAvailable => 'Slot Not Available';
  String get strOrderSummary => 'Order Summary';

  String get strBookTheService => 'BOOK THE SERVICE';
  String get strSelectDate => 'Select Date';
  String get strSelectTimeSlot => 'Select Time Slot';
  String get strPleaseSelectTimeSlot => 'Please Select Time Slot';
  String get strNoOfPersonSmall => 'No. of Person';
  String get strImportantNotes => 'Important notes';
  String get strPleaseSelectTimeSlotSmall => 'Please select time slot.';

  String get strYourRequestHasBeenSent => 'Your request has been sent!';
  String get strYouWillHearFromOurRepresentativeShortly => 'You will hear from our representative shortly';
  String get strGoToHome => 'GO TO HOME';

  String get strNeedHelp => 'Need Help?';
  String get strCancelRequest => 'CANCEL REQUEST';
  String get strOrderIdHash => 'Order ID : #';
  String get strComplaintDetails => 'Complaint Details';
  String get strTellUsAboutYourExperience => 'Tell us about your experience';
  String get strPleaseEnterCancellationReason => 'Please enter cancellation reason';

  String get strShareYourExperience => 'Share your experience';
  String get strComments => 'Comments';
  String get strStartWritingHere => 'Start writing here...';
  String get strPleaseWriteYourReview => 'Please write your review.';

  String get strPremiumServices => 'Premium Services';
  String get strExploreOurPremiumServices => 'Explore our premium services';
  String get strPackageAvailable => 'Package Available';
  String get strYourRequestHasBeenSentToOurRespectiveDepartment => 'Your request has been sent to our respective department';
  String get strOrderIDSpace  => 'Order ID : ';
  String get strYourOrderHasBeenSentToOurChef  => 'Your order has been sent to our chef';
  String get strExpectedTime => 'Expected Time : ';
  String get strRoomNo => 'Room No : ';
  String get strPlaceOrder => 'PLACE ORDER';
  String get strSubtotal => 'Subtotal';
  String get strTax => 'Tax ';
  String get strDiscount => 'Discount';

  String get strPleaseSelectService => 'Please Select Service';
  String get strPleaseSelectServiceSmall => 'Please select service';
  String get strPleaseEnterComplaintDetail => 'Please enter complaint detail';
  String get strSelectOngoingService => 'Select ongoing service';
  String get strTypeYourMessage => 'Type your message';
  String get strDirectory => 'Directory';

  String get strMyRequest => 'My Request';
  String get strMealDetail => 'Meal Detail';
  String get strDiningOption => 'Dining Option';
  String get strViewAll => 'View All';

  /* Login Page */
  String get strLogin => 'SIGN IN';
  String get strUserName => 'Username';
  String get strPassword => 'Password';
  String get strForgotPasswordWithQuestion => 'Forgot Password?';
  String get strSignUp => 'Sign Up';
  String get strWelcome => 'Welcome!';
  String get strPleaseEnterCredentialsProvidedByTheHotelStaff => 'Please enter credentials provided by the hotel staff';
  String get strRememberMe => 'Remember Me!';
  String get strOrYouCanVisitTheFrontDesk => 'or you can visit the Front Desk';

  /*Setting Screen*/
  String get strLogout => 'Logout';
  String get strUpdateServiceStatus => 'Update Service Status';
  String get strPleaseChangeTheRespectiveStatus => 'Please change the respective status';
  String get strServiceAccepted => 'Service Accepted';
  String get strServiceInProgress => 'Service In Progress';
  String get strServiceCompleted => 'Service Completed';
  String get strEnterReason => 'Enter Reason';
  String get strChangePassword => 'Change Password';
  String get strOldPassword => 'Old Password';
  String get strNewPassword => 'New Password';
  String get strConfirmNewPassword => 'Confirm New Password';
  String get strPleaseEnterYourOldPassword => 'Please enter your old password.';
  String get strPleaseEnterNewPassword => 'Please enter new password.';
  String get strPleaseEnterConfirmPassword => 'Please enter confirm password.';
  String get strComplaintDetail => 'Complaint Detail';
  String get strMarkAsResolved => 'Mark as resolved';
  String get strNoDataFound => 'No data found';
  String get strActive => 'Active';
  String get strComplete => 'Complete';
  String get strForgotPassword => 'Forgot Password';
  String get strPleaseEnterUsername => 'Please enter username';
  String get strFromWhereDoYouWantTakePhoto => 'From where do you want to take the photo?';
  String get strGallery => 'Gallery';
  String get strCamera => 'Camera';
  String get strFirstName => 'First Name';
  String get strLastName => 'Last Name';
  String get strEmail => 'Email';
  String get strPhoneNumber => 'Phone Number';
  String get strMenu => 'Menu';
  String get strPrivacyPolicy => 'Privacy Policy';
  String get strTermsOfUse => 'Terms of Use';
  String get strAboutUs => 'About us';
  String get strFAQs => 'FAQs';
  String get strSignOut => 'Sign Out';
  String get strEditProfile => 'Edit Profile';
  String get strPressBackToExit => 'Press back again to exit app.';
  String get strDashboard => 'Dashboard';
  String get strComplaints => 'Complaints';
  String get strNotification => 'Notification';
  String get strSearchHere => ' Search here';
  String get strEstimatedTime => 'ESTIMATED TIME:';
  String get strRequestOn => 'REQUEST ON';
  String get strSlotTime => 'SLOT TIME';
  String get strNoOfPerson => 'NO. OF PERSON';
  String get strPerson => ' Person';
  String get strCancellation => 'Cancellation';
  String get strItems => 'ITEMS';
  String get strRateMe => 'Rate Me';

  String get strOurServices => 'How May I assist you ?';
  String get strOurPremiumServices => 'Our Premium Services';
  String get strMoreInfo => 'More Info';
  String get strReadMore => '...Read More';
  String get strLess => ' Less';
  String get strBookNow => ' Book Now';
  String get strNotes => 'Notes';
  String get strAllItems => 'All Items';
  String get strOurSpecialMenuFromEntireWorld => 'Our special menu from entire world';

  String get tabPending => 'Pending';
  String get tabActive => 'Active';
  String get tabCompleted => 'Completed';
  String get tabRejected => 'Rejected';

}

class _TranslationsDelegate extends LocalizationsDelegate<Translations> {
  const _TranslationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'zh'].contains(locale.languageCode);
  }

  @override
  Future<Translations> load(Locale locale) async {
    // AppLocalizations class is where the JSON loading actually runs
    if (locale.languageCode.toLowerCase() == 'en') {
      Translations.current = const Translations();
      return SynchronousFuture<Translations>(
          Translations.current ?? const Translations());
    } else if (locale.languageCode.toLowerCase() == 'zh') {
      Translations.current = const $zh();
      return SynchronousFuture<Translations>(
          Translations.current ?? const $zh());
    }
    Translations.current = const Translations();
    return SynchronousFuture<Translations>(
        Translations.current ?? const Translations());
  }

  @override
  bool shouldReload(_TranslationsDelegate old) => false;
}

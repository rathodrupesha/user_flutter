import 'package:flutter/cupertino.dart';

enum ApplicationMode {
  customer,
  dealer,
  manufacture,
}

enum ActionType {
  delete,
  repost,
  viewDetail,
  sendQuote,
  withDrawQuote,
  acceptOrder,
  rejectOrder,
  none,
  privacyPolicy,
  termsAndConditions,
  cancellationPolicy,
  contactDetails
}

typedef SliderValueChangeCallback = void Function(double value);
typedef AlertWidgetButtonActionCallback = void Function(int index);
typedef AlertTextfieldWidgetButtonActionCallback = void Function(int index, TextEditingController controller);
typedef NotificationOViewCallback = void Function(bool status);
typedef ActionCallback = void Function(ActionType type);
typedef OnTextInputChangeCallback = void Function(String val);


/* Dealer region start */
typedef CountIncreaseCallback = void Function(int);
typedef CountDecreaseCallback = void Function(int);
typedef CheckIsAITextFormFieldEmptyCallback = void Function(bool);

typedef getIdCallback = void Function(String?);
typedef apiCallback = void Function();
typedef refreshCallback = void Function();

typedef SendQuotationButtonCallback = void Function();
typedef WithdrawButtonCallback = void Function();

typedef AcceptButtonCallback = void Function();
typedef RejectButtonCallback = void Function();
typedef AcceptRejectCardCallBack = void Function();
typedef UpdateStatusButtonCallback = void Function();

typedef DialogSubmitButtonCallback = void Function();
typedef DialogCloseButtonCallback = void Function();

typedef UpdateOrderStatusButtonCallback = void Function();
typedef CancelOrderButtonCallback = void Function();

typedef TapToActionButtonCallback = void Function();

typedef MakeActionAppNotFound = void Function();

typedef CustomAlertCompleteActionCallback = void Function();
typedef CustomAlertActionCallback = void Function();

typedef DropdownValueSelectionCallback = void Function(String value);
typedef TextSelectionCallback = void Function(String value);
typedef DeliveryChargesCallback = void Function(String value);
typedef CustomAlertWidgetButtonActionCallback = void Function(int index,int role);



/* Dealer region end */
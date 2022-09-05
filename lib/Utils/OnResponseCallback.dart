abstract class OnResponseCallback{

  void onResponseReceived(dynamic response, int requestCode);

  void onResponseError(String message, int requestCode);

}
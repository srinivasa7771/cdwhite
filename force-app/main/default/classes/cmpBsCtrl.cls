/**
 * THIS CLASS TO BE EXTENDED TO COMPONENT  CONTROLLER.
 * KEY NAME TO PASS COMPONENT NAME  THANT NEED BE  REFRESHED TO VISUALFORCE PAGE CONTROLLER.
**/
public virtual class cmpBsCtrl {
public String key { get; set { if (value != null) { key = value; if (pageController != null) { pageController.setCompCtrlMap(key, this); } } } }
public pgBsCtrl pageController { get; set { if (value != null) { pageController = value; pageController.setCompCtrl(this); } } }
}
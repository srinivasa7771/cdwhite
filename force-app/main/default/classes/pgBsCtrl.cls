/**
 * THIS CLASS TO BE EXTENDED TO VISUALFORCE PAGE CONTROLLER.
 * KEY NAME TO PASS COMPONENT NAME  THANT NEED BE  REFRESHED TO VISUALFORCE PAGE CONTROLLER.
**/
public virtual class pgBsCtrl {
//This is an extension to the PARENT controller.

    private cmpBsCtrl compCtrl;
    //map  to to interact with components
    private Map<String, cmpBsCtrl> compCtrlMap;

    public virtual cmpBsCtrl getCompCtrl() {
        return compCtrl;
    }

    //getter for components
    public virtual Map<String, cmpBsCtrl> getCompCtrlMap() {
        return compCtrlMap;
    }

    public virtual void setCompCtrl(cmpBsCtrl cController) {
        compCtrl = cController;
    }

    //setter for components (child component , where we are passing key to the controller)
    public virtual void setCompCtrlMap(String key, cmpBsCtrl cController) {
        if (compCtrlMap == null) {
            compCtrlMap = new Map<String, cmpBsCtrl>();
            compCtrlMap.put(key, cController);
        }
        else {
            compCtrlMap.put(key, cController);
        }
    }

    public pgBsCtrl getThis() {
        return this;
    }
}
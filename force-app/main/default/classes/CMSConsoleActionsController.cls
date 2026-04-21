public with sharing class CMSConsoleActionsController {

    private Boolean fullscreen = false;
    private Boolean console = false;

    //method that will dispatch the url param operation to the correct Apex method
    public PageReference dispatchOperation() {
        String operation = String.escapeSingleQuotes(System.currentPageReference().getParameters().get('operation'));
        if (String.escapeSingleQuotes(System.currentPageReference().getParameters().get('fullscreen')) == 'true') fullscreen = true;
        if (String.escapeSingleQuotes(System.currentPageReference().getParameters().get('console')) == 'true') console = true;

        if (operation == 'delete_pageitem') {
            return deletePageItem();
        }
        return null;
    }

    public PageReference deletePageItem() {
        String pageitemid = String.escapeSingleQuotes(System.currentPageReference().getParameters().get('pageitemid'));
        String retUrl = String.escapeSingleQuotes(System.currentPageReference().getParameters().get('returl'));
        try {
            PageToItem__c pi = [Select p.Page__c, p.Id From PageToItem__c p where p.Id =:pageitemid];
            String pageid = pi.Page__c;
            delete pi;
            String instance;
            if (CMSForceDomain__c.getAll().get('cmsforcedomain') != null) instance = CMSForceDomain__c.getAll().get('cmsforcedomain').Url__c;
            PageReference pr = new PageReference(instance + '/apex/PreviewPage?pageid='+pageid+'&console=true&pod='+instance);
            if (fullscreen) pr = new PageReference(instance + '/apex/PreviewPage?pageid='+pageid+'&console=true&fullscreen=true&pod='+instance);
            return pr;
        }
        catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.msgException)); System.debug(LoggingLevel.ERROR, 'Exception: ' + ex.getMessage());
            return null;
        }

    }

    
    
    

}
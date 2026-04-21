public with sharing class TicketCaseExtension {
    public User U {get;set;}
    public Account A {get;set;}
    public Contact C {get;set;}
    public Case caseObject {get;set;}
    Public String ownerName {get;set;}
    Public String caseNum {get;set;}
    Public String searchvalue {get;set;}
    Public String selectedRequest {get;set;}
    Public List<g_Req__c> reqList {get;set;}
    public ApexPages.StandardController stdCntrlr {get; set;}
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Enquiry', 'Enquiry'));
        options.add(new SelectOption('Complaint', 'Complaint'));
        //options.add(new SelectOption('Feedback', 'Feedback'));
        options.add(new SelectOption('Suggestion', 'Suggestion'));
        options.add(new SelectOption('Compliments', 'Compliments'));
        return options;
    }
    public TicketCaseExtension(ApexPages.StandardController controller) {
        caseObject = new case();
        caseObject = (Case)controller.getRecord();
        this.stdCntrlr = controller;
        init();
    }
    public void init() {
        U = [select Id, isportalenabled, FirstName, contact.Account.lc__c, LastName, Name,
            AccountId, LastLoginDate, contact.id, contact.Photo_ID__c, contact.account.id from User where id =: UserInfo.getUserId() limit 1];
        //LastPasswordChangeDate
        A = U.contact.account;
        C = U.contact;
        ownerName = U.Name;
        reqList = [Select Id, Name, strsrvc__c, Con__r.Name, Con__r.p__c from g_Req__c where Acc__c=:A.Id order by createdDate DESC LIMIT 10 ];
        if (u.isportalenabled) {caseObject.AccountId=U.AccountId;caseObject.Contact=U.Contact;}
        system.debug('----reqList---'+reqList);
        if (string.isblank(U.contact.account.lc__c)) {
            //caseObject.OwnerId=ccQ.id;
            caseObject.Category__c='Onboarding';
            selectedRequest=reqList[0].name;
            caseObject.Request__c = reqList[0].Id;

        }
    }
    public void save() {
        // Save the Case
        Id newCaseId;
        try{
            caseObject.Status = 'Open';
            system.debug('final caseObject====='+caseObject);
            if (Schema.sObjectType.Case.isCreateable()) {
                insert caseObject;
            }
            //Database.SaveResult sr = Database.insert(caseObject);
            caseNum = [Select caseNumber from Case where id=:caseObject.id].caseNumber;
            /*if (sr.isSuccess()) {
                System.debug('Successfully inserted case. Case ID: ' + sr.getId());
                caseNum = [Select caseNumber from Case where id=:sr.getId()].caseNumber;
                System.debug('=======caseNum: ' + caseNum);
            }*/
        }catch (Exception e) {
            system.debug(e.getStackTraceString());
            system.debug(e.getMessage());
            Apexpages.Message errMsg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getStackTraceString());
            ApexPages.addMessage(errMsg);
            //return null;
        }

    }
    public PageReference Cancel() {
        PageReference pr = new PageReference('/myCases');
        pr.setRedirect(true);
        return pr;
    }
    public void loadSelectedReq() {
        Integer val = Integer.valueOf(String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('selId')));
        system.debug('index====='+val);
        system.debug('list val===='+reqList.size());
        caseObject.Request__c = reqList[val].Id;
        selectedRequest = reqList[val].Name;
        system.debug('caseObject.Request__c====='+caseObject.Request__c);
    }
    public void onkeyupAction() {
        System.debug('===inside onkeyupAction searchvalue before==='+searchvalue);
        String val = String.valueOf(String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('srchWrd')));
        searchvalue = val;
        System.debug('===inside onkeyupAction searchvalue after==='+searchvalue);
        searchAction();
        //return null;
    }

    public void searchAction() {
        System.debug('===inside searchAction==='+searchvalue);
        if (searchvalue != '' && searchvalue != null)
            reqList = [Select Id, Name, strsrvc__c, Con__r.Name, Con__r.p__c from g_Req__c where Acc__c=:A.Id AND Name like :+searchvalue+'%'order by createdDate DESC LIMIT 10 ];
        else
            reqList = [Select Id, Name, strsrvc__c, Con__r.Name, Con__r.p__c from g_Req__c where Acc__c=:A.Id order by createdDate DESC LIMIT 10 ];
        //return null;
    }

}
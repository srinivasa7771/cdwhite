public with sharing class MyCasesController {
    public list<Case> cases {get;set;}
    public Case newcase{get;set;}
    public string criteria{get;set;}
    public Case detailCase{get;set;}
    public User loggedInUser{get;set;}
    public FeedItem post{get;set;}
    public List<FeedItem>FeedItemList{get;set;}
    public List<feedData>feedDataList{get;set;}
    public String pageNo {get;set;}
    public Account A {get;set;}

    public MyCasesController() {
        loggedInUser  = [select FirstName, LastName, Id, username, Acc_Id__c, Contact.account.Prk__c, Contact.account.Name, contact.account.lcsta__c, contact.account.lcedt__c,
                         contact.account.lcrndt__c from User where Id = :UserInfo.getUserId()];
        A = loggedInUser.contact.account;
        RecordsPerPageslist=10;
        feedDataList = new List<feedData>();
        cases  = [SELECT CaseNumber, Service_Type__c, Request__r.Name, Request__r.srvc__r.name,
            Request__r.Applicant_Name__c, Status, CreatedDate, Contact.Name, Account.Name  FROM case WHERE Account.id=:loggedInUser.Acc_Id__c and Origin!='Survey' and createddate= last_n_days:700];
        /*system.debug('cases:::'+cases);*/
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(cases);
        stdSetController= ssc;
        newcase = new Case();
        post = new FeedItem();
        Id caseId = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('Id'));
        if (caseId != null) {
            system.debug('caseid==============='+caseId);
            detailCase = [SELECT Id, CaseNumber, Request__r.Name, Request__r.Con__r.Name, Service_Type__c, Contact.Name, CreatedDate , ClosedDate, Status, Description,
                          Request__c, Account.name, subject, Resolution_Notes__c, Case_Resolved_Date__c, Type FROM Case WHERE Id=:caseId LIMIT 1];
            FeedItemList = [SELECT Id, body, ParentId, CreatedDate, CreatedById, createdby.name, createdby.profile.name FROM FeedItem WHERE ParentId=:detailCase.id order by createdDate DESC];
            Set<Id>userIds = new Set<Id>();
            if (detailCase.Status == 'Resolved' || detailCase.Status == 'Closed') {
                feedData fdr = new feedData();
                if (detailCase.Type == 'Suggestion' || detailCase.Type == 'Compliments')
                    fdr.body = 'Thank you for your feedback.<br/>For any further queries you can contact us at support@axs.ae, or you can reach us at 800 4 axs (297)';
                else
                    fdr.body = 'Resolution: '+detailCase.Resolution_Notes__c;
                fdr.datetimeVal = detailCase.Case_Resolved_Date__c;
                fdr.UserName = 'axs support team';
                feedDataList.add(fdr);
            }
            for (FeedItem feed : FeedItemList) {
                system.debug('=====feed===='+feed);
                system.debug('=====feed body===='+feed.body != null);
                system.debug('=====feed body===='+feed.body != '');
                if (feed.body != null && feed.body != '') {
                    feedData fd = new feedData();
                    fd.body = feed.body;
                    fd.datetimeVal = feed.CreatedDate;
                    if (feed.CreatedBy.Profile.Name == 'X' || feed.CreatedBy.Profile.Name == 'Z')
                        fd.UserName = feed.CreatedBy.Name;
                    else
                        fd.UserName = 'axs support team';
                    system.debug('=====fd===='+fd);
                    feedDataList.add(fd);
                }

            }
        }
        system.debug('feedDataList:::::'+feedDataList);
    }
    public void searchCases() {

        system.debug('searchCases:::::::::::');
        system.debug('criteria:::::'+criteria);
        string caseNum = '%'+criteria+'%';
        if (criteria == 'Today') {
            cases = [SELECT Request__r.Name, Request__r.Con__r.Name, Request__r.Applicant_Name__c,
                CaseNumber, Service_Type__c, Status, CreatedDate, Contact.Name, Account.Name  FROM case WHERE createdDate = Today AND Account.id=:loggedInUser.Acc_Id__c and Origin!='Survey' LIMIT 20];
        }else if (criteria == 'My Open Cases') {
            cases = [SELECT Request__r.Name, Request__r.Con__r.Name, Request__r.Applicant_Name__c,
                CaseNumber, Service_Type__c, Status, CreatedDate, Contact.Name, Account.Name FROM case WHERE Status IN('Open') AND Account.id=:loggedInUser.Acc_Id__c and Origin!='Survey' LIMIT 20];
        }else if (criteria == 'Recently Viewed Cases') {
            List<Id>caseIdList =  new List<Id>();
            for (RecentlyViewed rv :[SELECT Id, Name FROM RecentlyViewed  WHERE Type ='Case']) {
                caseIdList.add(rv.id);
            }
            cases = [SELECT Request__r.Name, Request__r.Con__r.Name, Request__r.Applicant_Name__c,
                CaseNumber, Service_Type__c, Status, CreatedDate, Contact.Name, Account.Name  FROM case WHERE Id=:caseIdList AND Account.id=:loggedInUser.Acc_Id__c and Origin!='Survey' LIMIT 20];
        }else if (criteria == 'My In-Process Cases') {
            cases = [SELECT Request__r.Name, Request__r.Con__r.Name, Request__r.Applicant_Name__c,
                CaseNumber, Service_Type__c, Status, CreatedDate, Contact.Name, Account.Name FROM case WHERE Status IN('In Progress',
                'AXS Back Office - In Progress', 'Call Center - In Progress') AND Account.id=:loggedInUser.Acc_Id__c and Origin!='Survey' LIMIT 20];
        }else if (criteria == 'My Completed Cases') {
            cases = [SELECT Request__r.Name, Request__r.Con__r.Name, Request__r.Applicant_Name__c,
                CaseNumber, Service_Type__c, Status, CreatedDate, Contact.Name, Account.Name FROM case WHERE Status IN('Closed',
                'Resolved') AND Account.id=:loggedInUser.Acc_Id__c and Origin!='Survey' LIMIT 20];
        }else if (criteria == 'All Cases') {
            cases = [SELECT Request__r.Name, Request__r.Con__r.Name, Request__r.Applicant_Name__c,
                CaseNumber, Service_Type__c, Status, CreatedDate, Contact.Name, Account.Name  FROM case WHERE  Account.id=:loggedInUser.Acc_Id__c and Origin!='Survey' LIMIT 20];
        }else if (caseNum != null) {
            cases = [SELECT Request__r.Name, Request__r.Con__r.Name, Request__r.Applicant_Name__c,
                CaseNumber, Service_Type__c, Status, CreatedDate, Contact.Name, Account.Name  FROM case WHERE CaseNumber LIKE: caseNum AND Account.id=:loggedInUser.Acc_Id__c and Origin!='Survey'];
            //LIMIT 20
        }
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(cases);
        stdSetController= ssc;
        system.debug('cases:::::'+cases);
    }
    public void createCase() {

        system.debug('newcase:::::::'+newcase);
        if (Schema.sObjectType.Case.isCreateable()) {
            insert newcase;
        }
        system.debug('Inserted Cases:::::::'+newcase);
    }
    public PageReference  cancel() {

        system.debug('cancel:::::::'+newcase);
        return null;
    }
    public void createChatter() {

        system.debug('createChatter:::::::');
        Id caseId = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('Id'));
        post.ParentId = caseId;
        insert post;
        system.debug('inseerted post:::::::'+post);
    }
    public Pagereference getSelectedPageList() {
        this.stdSetController.setpageSize(RecordsPerPageslist);
        this.stdSetController.setpageNumber(integer.valueOf(pageNo));
        return null;
    }
    public Integer PageNumber{
        get{                                                            //To get current page number
            this.PageNumber=stdSetController.getPageNumber();
            return this.PageNumber;
        }
        set{                                                              // To navigate to the page number entered by the user
            stdSetController.setPageNumber(value);
        }
    }
    public Integer TotalPages{                                            // Total number of pages as per user selection of Records per page
        get{
            if (stdSetController.getResultSize() <=10)
                this.TotalPages=1;
            if (Math.Mod(stdSetController.getResultSize() , stdSetController.getPageSize()) == 0)
                this.TotalPages =(stdSetController.getResultSize()/stdSetController.getPageSize());
            else
                this.TotalPages = (stdSetController.getResultSize()/stdSetController.getPageSize())+1;
            System.Debug(this.TotalPages);
            return totalpages;
        }
        set;
    }
    public Integer MaxNumberOfRecords{                                    //Maximum number of records in a query list
        get{
            return stdSetController.getRecords().size();
        }
        set;
    }
    public Integer RecordsPerPageslist{
        get;set{                                                          //To select number of records per page
            // System.debug(value);
            if (value != null) {
                this.RecordsPerPagesList=value;
            }
            // else
            // this.RecordsPerPageslist=10;
        }
    }
    public void next() {
        this.stdSetController.next();
    }
    public ApexPages.StandardSetController stdSetController{

        get{
            if (stdSetController == null) {

                cases  = [SELECT CaseNumber, Service_Type__c, Status, CreatedDate, Contact.Name, Account.Name  FROM case WHERE Account.id=:loggedInUser.Acc_Id__c];
                stdSetController = new ApexPages.StandardSetController(cases);
            }
            stdSetController.setPageSize(RecordsPerPageslist);        //Limiting Number of records to be displayed per page
            return stdSetController;
        }
        set;
    }          //Instantiating a standard set controller

    public list<case> getcaseList() {                               //to display records on vf page
        return (list<case>)stdSetController.getRecords();
    }

    public class feedData
    {
        public String body {get;set;}
        public Datetime datetimeVal {get;set;}
        public String UserName {get;set;}
    }

}
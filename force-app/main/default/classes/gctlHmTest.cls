@isTest
private class gctlHmTest {
    /*MS */
    @testSetup 
    static void setup(){
        testData.init();
        User usr = testData.createportalUser('test');
        insert usr;
        
        List<user> ulist = [select contactid from user where id=:usr.id LIMIT 1];
        List<Contact> conList = [select id,accountid from contact where id=:ulist[0].contactid LIMIT 1];
        account a = new account(id=conList[0].accountid,os__c='Intiated',ORACLE_PARTY_ID__c='32710',Type='Customer - Incubation');
        update a;
        
        testData.bRulesReqCrt();testData.bRulesItemCrt();
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);
        s.uid__c='216';
        update s;
        
        g_Req__c req=testData.reqCrt(conList[0].accountId,s.Id,conList[0].Id,'Open',stg.reqq__c);
        
        update req;
    }
    static testmethod void testPositive(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        List<user> ulist = [select id from user where Email='portaluser@testorg.com' LIMIT 1];
        Account acc=[SELECT id,lc__c from Account where name='portal account' limit 1];
        acc.type='Customer - Incubation;Customer - Member';
        acc.snc__c ='CA- Outstanding Dues; CA- Outstanding Dues (Penalties)';
        acc.Prk__c='Dubai Internet City';
        update acc;
        
        Contact con =[SELECT id,accountid from Contact where lastname='portalcontact' limit 1];
        system.runAs(ulist[0]){
            //PageReference vfpage = Page.pagepastrequests;
            PageReference vfpage = new PageReference('/apex/pagepastrequests');
            vfpage.getParameters().put('flg','pndg');
            vfpage.getParameters().put('uid','true');  
            vfpage.getParameters().put('lc',acc.id);
            Test.setCurrentPage(vfpage);
            gctlHm obj = new gctlHm();
            obj.obr();
            g_Srvc__c  srv =[SELECT id,uid__c FROM g_Srvc__c where uid__c='216' limit 1];
            srv.uid__c='223';
            srv.actv__c=true;
            srv.Category__c='Dependents';
            srv.Prk__c =acc.Prk__c;
            srv.AccTp__c =acc.Type;
            srv.Menu_Category__c='Visas';
            update srv;
            g_Req__c req =[SELECT id,(SELECT ap__c from Items__r) FROM g_Req__c WHERE Acc__c=: acc.id limit 1 ];
            req.bamsgs__c ='dsadasdasdasdasd';
            req.STA__c='In Process';
            update req ;
           
            obj.A=acc;
            coninfo__c testConInfo = new coninfo__c(name__c='HR Contact',acc__c=con.accountid,con__c=con.Id,rol__c='VAT Contact; Billing Contact; Office Admin/Manager',sta__c='Active');
            insert testConInfo;
            coninfo__c testConInfo1 = new coninfo__c(name__c='HR Contact',acc__c=con.accountid,con__c=con.Id,rol__c='Marketing Contact;VAT Contact; Billing Contact; Office Admin/Manager',sta__c='Active');
            insert testConInfo1;
            coninfo__c testConInfo2 = new coninfo__c(name__c='HR Contact',acc__c=con.accountid,con__c=con.Id,rol__c='VAT Contact; Billing Contact; Office Admin/Manager',sta__c='Active');
            insert testConInfo2;
            coninfo__c testConInfo3 = new coninfo__c(name__c='HR Contact',acc__c=con.accountid,con__c=con.Id,rol__c='VAT Contact; Billing Contact; Office Admin/Manager',sta__c='Active');
            insert testConInfo3;
            obj.licCopy=obj.licCopy;
            obj.dc=obj.dc;
            obj.leaseDt=obj.leaseDt;
            obj.lcl=obj.lcl;
            obj.minBG=obj.minBG;
            obj.maxBG=obj.maxBG;
            obj.notificationRqs=obj.notificationRqs;
            obj.notificationRqs3=obj.notificationRqs3;
            obj.searchCriet=obj.searchCriet;
            obj.lst_pd=obj.lst_pd;
            obj.conMap=obj.conMap;
            obj.lst_pdClone=obj.lst_pdClone;
            obj.accidonload=obj.accidonload;
            obj.setRenewalRequest();
            obj.loadCards2(srv.id);
            obj.checkOraclePartyID();
            obj.getParkings(acc);
            obj.LoadPrivateMethods();
            obj.days='5';
            obj.status='testtt';
            obj.searchByStatus1();
            req.STA__c='Draft';
            update req ;
            obj.getdraftRQs();
            obj.getconinfoLst();
            try{
            obj.getnotificationRQs();
            obj.getallDPRqs1();
            obj.getRPExpLst();
            obj.getPassportExpLst();
            }catch(NullPointerException e){}
           // obj.getLeaseExpLst();            
            obj.searchByStatus();
            obj.getNopmntRQs();
            obj.searchPersons();
            obj.next();
            obj.pageNo='7';
            obj.getSelectedPageList();
            obj.enUser();
            obj.dsbUser();
            obj.PageNumber=23; 
            obj.getpendingRQs();
            obj.obr1();
            obj.getallDPRQs();
			obj.dat='2';            
            obj.searchByDate();
            // obj.getLicenseCopy();
            obj.getDocument();
            obj.getPOBox();
            obj.loadTransaction();
            obj.loadAccountLocation();
            Integer t = obj.TotalPages;
            Integer t1 = obj.MaxNumberOfRecords;
            Test.stopTest();
        }
    }
    static testmethod void testNegative(){
        //PageReference vfpage = Page.pagepastrequests;
        PageReference vfpage = new PageReference('/apex/pagepastrequests');
        vfpage.getParameters().put('flg','drft');
        Test.setCurrentPage(vfpage);
        gctlHm obj = new gctlHm();
        obj.obr();
    }
}
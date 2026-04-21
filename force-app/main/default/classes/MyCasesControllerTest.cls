@isTest
private class MyCasesControllerTest {
    static testmethod void method1() {
        Test.startTest();
        User u = testData.createportalUser('CaseUsr');
        insert u;
        Contact C = [Select Id, Name, AccountId, Photo_ID__c from Contact where Id=:u.contactId];
        Account A = [Select id, on__c , onar__c , Website, vespe__c, vespex__c, vetemp__c,
            vbtemp__c , vetst__c, vespst__c, vespstx__c , vbtst__c, vev__c, mxPortalUsers__c,
            Name, Email__c, lPrk__c, Building_Name__c,
                     xcublg__c, Location__c, Location_Cluster__c, xcuzn__c , Phone, Type, Prk__c, adb__c,
                         info__c, bgnr__c, bg__c, bgc__c, bgcabsc__c, bgb__c, vctemp__c, speabsc__c, vctst__c,
                         sncNt__c, vbvv__c, lcidt1__c,
                     ec__c, ecidt__c, lctp__c, ecedt__c, lcedt__c, lcsnc__c, lcsncnt__c, Legal_Framework__c,
                         psasnc__c, psasncnt__c, lcsta__c, ecsnc__c, ecsncnt__c, lcrndt__c, cosnc__c, cosncnt__c,
                         licexdt__c, licIdt__c,
                     bgsnc__c, bgsncnt__c, snc__c, voep__c, lc__c, ORACLE_PARTY_ID__c, rpa__c, os__c, adob__c , adx__c, adc__c from Account where id=:C.AccountId ];
        System.debug('A===='+A);

        System.runAs(u) {
            Case cs = new case(subject='TestCase123', Origin='Portal', Status='Open', Type='Enquiry', Priority='Medium', Account=A);
            insert cs;
            System.debug('cs===='+[SELECT CaseNumber, Request__r.Name, Request__r.Con__r.Name,
                Service_Type__c, Contact.Name, CreatedDate , ClosedDate, Status, Description, Request__c,
                Account.name, subject,
                                   Resolution_Notes__c, Case_Resolved_Date__c, Type FROM Case WHERE Id=:cs.Id LIMIT 1]);
            List<FeedItem> feedlst = new List<FeedItem>();
            feedlst.add(new FeedItem (ParentId = cs.id, type = 'ContentPost', Body = 'Hello test class1s'));
            feedlst.add(new FeedItem (ParentId = cs.id, type = 'ContentPost', Body = 'Hello test classs2'));
            feedlst.add(new FeedItem (ParentId = cs.id, type = 'ContentPost', Body = 'Hello test classs3'));
            feedlst.add(new FeedItem (ParentId = cs.id, type = 'ContentPost', Body = 'Hello test classs4'));
            insert feedlst;
            //PageReference pageRef = Page.Mycases;
            PageReference pageRef = new PageReference('/apex/Mycases');
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(cs);
            ApexPages.currentPage().getParameters().put('Id', cs.id);
            MyCasesController lcc = new MyCasesController();
            lcc.post.body = 'Test chatter post';
            lcc.createChatter();
            lcc.criteria = 'Today';
            lcc.searchCases();
            lcc.criteria='Recently Viewed Cases';
            lcc.searchCases();
            lcc.criteria='My In-Process Cases';
            lcc.searchCases();
            lcc.criteria='My Completed Cases';
            lcc.searchCases();
            lcc.criteria='All Cases';
            lcc.searchCases();
            lcc.criteria=null;
            lcc.searchCases();
            lcc.newcase = new Case(subject='TestCase5', Origin='Portal', Status='Open', Type='Enquiry', Priority='Medium', Account=A);
            lcc.createCase();
            lcc.PageNumber = 10;
            List<Case> cl= lcc.getcaseList();
            lcc.RecordsPerPageslist = 10;
            lcc.next();
            Integer recMax = lcc.MaxNumberOfRecords;
            Integer tPg = lcc.TotalPages;
            lcc.pageNo = '1';
            PageReference pf1 = lcc.getSelectedPageList();
            PageReference pf = lcc.cancel();
        }
        Test.stopTest();
    }

}
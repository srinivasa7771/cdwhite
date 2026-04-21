@isTest
private class PDSearchTest{

     static testMethod void doTest() {
         Test.startTest();
         testData.init();
          g_srvc_settings__c stg=testData.stgCrt();
            g_Srvc__c s=testData.srvcCrt(stg.Id);
            Account a=testData.accCrt(false);
            Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
            Contact emp=testData.conCrt(sp, a.Id, 'Active', 'Employee', 'Pass2', 'Egypt');
            Test.setCurrentPageReference(new PageReference('Page.myPage'));
            System.currentPageReference().getParameters().put('id', '2730');
            System.currentPageReference().getParameters().put('enc', '27301111');
            g_Req__c r=testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);
           r.xcp__c = 'MTH2343243';
          update r;
          g_reqitem__c ri = [select id from g_reqitem__c where itm__r.cd__c = 'ep'];
          g_reqDoc__c rdoc = new g_reqDoc__c(Name='Passport Copy', RQ__c=r.id);
          insert rdoc;
          g_reqitemDoc__c ritmdoc = new g_reqitemDoc__c(Name = 'Passport Copy', lbl__c ='Passport Copy',
              reqItm__c = ri.Id, reqDoc__c = rdoc.id, Req__c = true, reqOr__c = true, reqAts__c = true,
              mnAts__c = 0, mxAts__c = 5, Tp__c = 'Others');
          insert ritmdoc;
         List<Attachment> attlst = new List<Attachment>();
         Attachment att = new Attachment();
         att.parentid = rdoc.id;
         att.Name = 'Passport';
         att.Body = Blob.valueOf('');
         attlst.add(att);
         att = new Attachment();
         att.parentid = rdoc.id;
         att.Name = 'Entry Permit';
         att.Body = Blob.valueOf('');
         attlst.add(att);
         insert attlst;
         PDSearchCntrl ctrl = new PDSearchCntrl();

         ctrl.getCatOpt();
         ctrl.getItmOpt();
         ctrl.getStsOpt();
         ctrl.cleanDataTable();
         ctrl.passPrt = 'MTH2343243';
         ctrl.queryReqDoc();
         ctrl.selCatg = '';
         ctrl.selItm = '';
         ctrl.selStat = '';
         ctrl.zone = '';
         ctrl.reqItmList = new List<g_reqitem__c>();
         ctrl.finalListRqItm = new List<g_reqitem__c>();
         ctrl.mapRefReqItm = new map<String, g_reqitem__c>();

         PDSearchCntrl.rqDocWrapper pdw= new PDSearchCntrl.rqDocWrapper();
         pdw.doc = pdw.doc;
         pdw.passportNo = pdw.passportNo;
         pdw.rq = pdw.rq;
         PDSearchCntrl.DocumentInfo pd = new PDSearchCntrl.DocumentInfo();
         pd.recid = pd.recid;
         pd.fileName = pd.fileName;
         pd.fileType = pd.fileType;
         pd.attid = pd.attid;

         Test.stopTest();
     }
}
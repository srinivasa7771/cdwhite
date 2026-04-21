@isTest
private class gctlPrkTest implements HttpCalloutMock{
    public HTTPResponse respond(HTTPRequest req) {
            
			String attReqData = '{"ActionName":"insertvehicleattachment","VehicleNumber":"","contentType":"","attachmentName":"","body":""}';
            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'text/json');
            res.setBody(attReqData);
            res.setStatusCode(200);
            return res;
    		}
    @testSetup 
    static void setup(){
        testData.init();
        user u = testData.createportalUser('testp');
        insert u;
        
        testData.bRulesReqCrt();testData.bRulesItemCrt();
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);
        
    }
    
    
    static testmethod void test(){
        
        Test.startTest();
        try{
        List<g_Srvc__c> srvcLst = [select id from g_Srvc__c where Name='Srvc' LIMIT 1];
        g_Srvc__c gs = new g_Srvc__c(id=srvcLst[0].id,uid__c='197');
        update gs;
        
        List<g_srvc_settings__c> srvcsettings = [select id,reqq__c from g_srvc_settings__c where Name='srvcStg' LIMIT 1];
        List<g_srvcitm__c> srvitm = [select id from g_srvcitm__c where 	srvc__r.Name='Srvc' LIMIT 1];
        g_srvcitm_Doc__c srvItmdocs= new g_srvcitm_Doc__c(Name='Eida Card Front Side',lbl__c='test',Tp__c='Cancellation Document',
                                                          Req__c =true,mnAts__c=0,mxAts__c=0,itm__c=srvitm[0].id);
        insert srvItmdocs;
        
        system.debug('srvItmdocs:::'+srvItmdocs.id);
        List<User> ulist = [select contactId from user where Email='portaluser@testorg.com' LIMIT 1];
        system.debug('ulist--'+ulist);
        
        List<Contact> conlst = [select accountid from contact where id=:ulist[0].contactid];
        List<g_srvcitm_Status__c> stng1 = [select id from g_srvcitm_Status__c where itm__r.srvc__r.Name='Srvc' LIMIT 1];
        
        g_Req__c req=testData.reqCrt(conlst[0].accountId,gs.Id,ulist[0].contactId,'Open',srvcsettings[0].reqq__c);
        req.xdapp__c=true;
        req.xaed__c=system.today().addYears(2);
        update req;
        system.debug('req----'+req);
        
        g_reqitem__c rqitem = new g_reqitem__c(Name='test1',RQ__c=req.Id,itm__c=srvitm[0].Id,sta__c=stng1[0].Id);
        insert rqitem;
        g_reqDoc__c rdoc= new g_reqDoc__c(Name='Vehicle',RQ__c=req.Id,ats__c=5);
        insert rdoc; 
       
        system.debug('rdoc----'+rdoc);
        g_reqitemDoc__c rrdocitm = new g_reqitemDoc__c(name='Vehicle',reqItm__c=rqitem.Id,reqDoc__c=rdoc.Id,mnAts__c=1);
        
        Blob b = Blob.valueOf('Test Data');
        Attachment attachment = new Attachment();
        attachment.ParentId = rdoc.Id;
        attachment.Name = 'Test Attachment for Parent';
        attachment.Body = b;
        insert attachment;
        
        system.runAs(ulist[0]){
           
            //PageReference vfpage = Page.nrtacc;
            PageReference vfpage = new PageReference('/apex/nrtacc');
            vfpage.getParameters().put('id',req.Id);
            vfpage.getParameters().put('sid',srvcLst[0].Id);
            
            Test.setCurrentPage(vfpage);
            system.debug('req-----www'+req);	
            ApexPages.StandardController sc = new ApexPages.StandardController(req);
            gctlPrk obj = new gctlPrk(sc); 
            obj.sd =obj.sd;
            obj.srvList=obj.srvList;
            
            obj.priorityList=obj.priorityList;
            obj.srvTrnsList =obj.srvTrnsList;
            obj.saveReq();
            obj.saveDraft();
            obj.pushParkingData();
            //  obj.processParking();
            obj.loadCards2();
            obj.loadPNums();
            //obj.validateVehicle();
            obj.getParkings();
           // try{obj.getAmntAP();}catch(Exception e){}
            obj.getStDate();
            obj.saveReq1_UR();
            obj.saveReq1();
            obj.SR_AddPrk();
            obj.saveAtt();
            obj.deleteAttach();
            obj.lstCards = obj.lstCards;
            //  obj.updateItemSTA();
            obj.upsertR('open');
            
            gctlPrk.customDoc gc = new gctlPrk.customDoc();
            string DocName=gc.DocName;
            string VehName=gc.VehName;
            string ItemName =gc.ItemName;
            string ItemCode =gc.ItemCode;
            string DocLabel =gc.DocLabel;
            string DocType=gc.DocType;
            String attId =gc.attId;
            String tmpltId =gc.tmpltId;
            String attName =gc.attName;
            boolean parse=gc.parse;
            boolean isSaveRQ =gc.isSaveRQ;
            boolean isOptional =gc.isOptional;
            
            obj.empid=obj.empid;
            obj.encid=obj.encid;
            obj.sid=obj.sid;
            obj.pid=obj.pid;
            obj.empid=obj.empid;
            obj.empid=obj.empid;
            obj.lst_pd1=obj.lst_pd1;            
            obj.pgHide=obj.pgHide;
            obj.nD=obj.nD;
            obj.nDV1=obj.nDV1;
            obj.nDV2=obj.nDV2;
            obj.DV2Leng=obj.DV2Leng;
            
            obj.imageBase64=obj.imageBase64;
            obj.docName=obj.docName;
            obj.extension=obj.extension;
            obj.imageBase64=obj.imageBase64;
            obj.parseId=obj.parseId;
            obj.DocList1=obj.DocList1;
            obj.DocList1Str=obj.DocList1Str;
            
            obj.DocList1=obj.DocList1;
            obj.DocList1Str=obj.DocList1Str;
            obj.parkingString1=obj.parkingString1;
            obj.parkingCardString=obj.parkingCardString;
            obj.Eid=obj.Eid;
            
            
            

            
            
        }
       }catch(Exception e){}
        Test.stopTest();
    }
   
    
   
}
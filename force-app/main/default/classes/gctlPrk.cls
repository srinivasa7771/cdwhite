public class gctlPrk  implements Queueable,Database.AllowsCallouts {
    public String empid{get;set;}
    public String encid{get;set;}
    public String sid{get;set;}
    public String pid{get;set;}
    public g_Req__c req{get;set;}
    public gu.pgMode md{get;set;}
    public Boolean hdCnt{get;set;}
    public g_Srvc__c srv{get;set;}
    public Account Acc{get;set;}
    public List<ParkingM.AddtnlPark> lstAddparks {get;set;}
    public List<ParkingM.ParkingDetail> lst_pd{get;set;}
    public List<String> lst_pd1{get;set;}
    public static String pdMsg{get;set;}
    public Boolean pgHide{get;set;}
    public Boolean ispu{get;set;}
    public Boolean isgu{get;set;}
    public String cn{get;set;}
    public Boolean st {get;set;}
    public Map<String,Integer> el {get;set;}
    public Decimal amnt {get;set;}
    public Datetime stDt{get;set;}
    public String pt{get;set;}
    public User U {set;get;}
    public g_srvc_definition__c sd{get;set;}
    public List<String> srvList {set;get;}
    public List<g_Srvc__c> srvLst {set;get;}
    public List<string> priorityList {set;get;}
    public List<String> srvTrnsList {set;get;}
    public List<g_srvcitm_Doc__c> DocList {get;set;}
    public List<g_srvcitm_Doc__c> EIDDoc {get;set;}
    public List<customDoc> DocList1 {get;set;}
    public String DocList1Str {get;set;}
    public List<customDoc> EIDDoc1 {get;set;}
    public String parkingString {get;set;}
    public String parkingString1 {get;set;}
    public String parkingCardString {get;set;}
    public String Eid{get;set;}
    public List<g_reqDoc__c> rdocList {get;set;}
    public String rqId {set;get;}
    public String vehicleNum {set;get;}
    public String reqCardNum {set;get;}
    public string lcl{get{return UserInfo.getLocale();}}
    public Date cardExpiryDate{get;set;}
    // public String email{get;set;}public String mobile{get;set;} commented on 03/06/2022
    
    @TestVisible
    public Boolean nD{get{
        for(g_reqDoc__c d:[Select Id,Name,mxAts__c,mnAts__c,ats__c,Req__c,nt__c,or__c,reqAts__c,reqOr__c,tplt__c,upOk__c,mbr__c,mbr__r.Name From g_reqDoc__c where RQ__c =:req.Id and  Req__c=true and IsDeleted=false]){
            if(!d.upOk__c){return true;}}return false;}}
    @TestVisible
    public Boolean nDV1{get{
        for(g_reqitemDoc__c d:[Select Id,Name,mxAts__c,mnAts__c,Req__c,or__c,reqAts__c,reqOr__c,upOk__c,reqItm__r.itmCd__c From g_reqitemDoc__c where reqItm__r.itmCd__c in:req.xadh__c.split(';') and reqItm__r.RQ__r.Id =:req.Id and  Req__c=true and IsDeleted=false]){
            if(!d.upOk__c&&d.reqItm__r.itmCd__c=='0np'){return true;}}return false;}}
    @TestVisible
    public Boolean nDV2{get{ for(g_reqitemDoc__c d:[Select Id,Name,mxAts__c,mnAts__c,Req__c,or__c,reqAts__c,reqOr__c,upOk__c,reqItm__r.itmCd__c  From g_reqitemDoc__c where reqItm__r.itmCd__c in:req.xadh__c.split(';') and reqItm__r.RQ__r.Id =:req.Id and  Req__c=true and IsDeleted=false]){ if(!d.upOk__c&&d.reqItm__r.itmCd__c=='1np'){return true;}}return false;}}
    @TestVisible
    public Integer DV2Leng{get{ List<g_reqitemDoc__c> dv2 = [Select Id,Name,mxAts__c,mnAts__c,Req__c,or__c,reqAts__c,reqOr__c,upOk__c,reqItm__r.itmCd__c  From g_reqitemDoc__c where reqItm__r.itmCd__c in:req.xadh__c.split(';') and reqItm__r.itmCd__c='1np' and reqItm__r.RQ__r.Id =:req.Id and upOk__c=false and Req__c=true and IsDeleted=false]; return dv2.size();}}
    
    public transient  String imageBase64 {get;set;}
    public String docName { get; set; }
    public String extension { get; set; }
    public String parseId { get; set; }
    
    
    public void execute(QueueableContext context) {pushAttCRM();}
    
    
    public gctlPrk(String rId){ rqId = rId; system.debug('rqId --'+rqId); }
    
    
    public gctlPrk(ApexPages.StandardController c){
        DocList = new List<g_srvcitm_Doc__c>();
        EIDDoc = new List<g_srvcitm_Doc__c>();
        EIDDoc1 = new List<customDoc>();
        reqCardNum = '';
        req=(g_Req__c)c.getRecord();
        req.xadh__c = '0np;';
        rqId = ApexPages.CurrentPage().getParameters().get('id');
        reqCardNum = ApexPages.CurrentPage().getParameters().get('c');
        vehicleNum = ApexPages.CurrentPage().getParameters().get('v');
        system.debug('reqCardNum -- '+reqCardNum+' && vehicleNum -- '+vehicleNum);
        
        if(rqId!=null){
            req = [select Id,xchn__c,xadtx4__c,xcmob__c,rmob__c,xvnum__c,xcsfn__c,Service_Code__c, acc__r.id, srvc__c, srvc__r.Name,xaed__c,xdapp__c,srvc__r.stg__c, srvc__r.stg__r.pg__c,srvc__r.AddOnSrv__c, srvc__r.stg__r.reqq__c,srvc__r.stg__r.bopg__c from g_Req__c where id =: rqId]; 
            req = (g_Req__c)Database.query(req.srvc__r.stg__r.reqq__c + ' where id=\'' + rqId + '\' and isDeleted = false');
            system.debug('req -- '+req);
            EIDDoc = [select id,Name,itm__r.name,itm__r.cd__c from g_srvcitm_Doc__c where itm__r.srvc__c =:req.srvc__c and (name='Eida Card Front Side' OR name='Emirates ID Front Side')];/* like '%Eida Card%'*/
            DocList = [select id,Name,itm__r.name,itm__r.cd__c from g_srvcitm_Doc__c where Req__c =true and itm__r.srvc__c =:req.srvc__c order by ord__c];
            
            for(g_srvcitm_Doc__c sd : EIDDoc){
                customDoc d1 = new customDoc();
                d1.DocName = sd.name;
                d1.ItemName = sd.itm__r.name;
                d1.ItemCode = sd.itm__r.cd__c;
                d1.parse = true;
                EIDDoc1.add(d1);
            }
            
            rdocList = [select id from g_reqDoc__c where RQ__c =:req.Id  and reqAts__c=true and upOk__c=true];//and Req__c=true
            system.debug('rdocList--- '+rdocList);
            Map<string,Attachment> attMp = new Map<string,Attachment>();
            
            for(Attachment att : [select id,name,body,parentid from Attachment where parentid=:rdocList]){attMp.put(att.name.split('\\.')[0],att);}
            for(customDoc d : EIDDoc1){
                
                if(attMp != null && attMp.containskey(d.DocName)){Attachment att = attMp.get(d.DocName);d.attId = att.Id;Eid = att.Id;d.attName = att.name;}
            }
            
            system.debug('attMp--- '+attMp);
        }
        md = new gu.pgMode();
        // init();
        
        ispu=gu.isPortalUser(UserInfo.getProfileId());
        isgu = gu.isGuestUser(userInfo.getProfileId());
        
        md.setNew(); loadData();
        loadCards();
    }
    
    
    private void loadData(){
        
        // Boolean hasAccess2; String srvDefId = ''; commented 03/06/2022
        
        String sid = ApexPages.CurrentPage().getParameters().get('sid'); // get service id
        U = [select id,FirstName,LastName,contact.name,contact.mobilephone,contact.email,contact.account.Building_Name__c,contact.account.mtc__c,contact.account.Name,contact.account.Email__c,contact.account.Phone,MobilePhone,accountid,
             contact.account.id,contact.account.adb__c,contact.account.xcuzn__c,contact.account.xcublg__c,contact.account.bgb__c,contact.account.bgnr__c,contact.account.bg__c,contact.account.loc__c,contact.account.Type,contact.account.Prk__c,contact.account.lcsnc__c,contact.account.lcsncnt__c,contact.account.lcedt__c,contact.account.psasnc__c,contact.account.psasncnt__c,contact.account.ecsnc__c,contact.account.ecsncnt__c,contact.account.cosnc__c,contact.account.cosncnt__c,contact.account.bgsnc__c,contact.account.bgsncnt__c,contact.account.snc__c,contact.account.info__c,contact.account.vestd__c,contact.account.vbtemp__c,contact.account.vbvv__c,
             contact.account.lc__c,contact.account.ORACLE_PARTY_ID__c,contact.account.lcsta__c,contact.account.lctp__c,contact.account.session__c,contact.account.vctemp__c,contact.account.vvsfp__c,contact.account.lcrndt__c,contact.account.os__c from User where id=:UserInfo.getUserId() limit 1];
        
        system.debug('U--- '+U);
        system.debug('sid--- '+sid);
        
        if(EIDDoc.size()<1){
            EIDDoc = [select id,Name,itm__r.name,itm__r.cd__c from g_srvcitm_Doc__c where itm__r.srvc__r.id =:sid and (name='Eida Card Front Side' OR name='Emirates ID Front Side')];
            
            for(g_srvcitm_Doc__c sd : EIDDoc){customDoc d1 = new customDoc();d1.DocName = sd.name;d1.ItemName = sd.itm__r.name;d1.ItemCode = sd.itm__r.cd__c;d1.parse = true;EIDDoc1.add(d1);}
        }
        system.debug('EIDDoc1--- '+EIDDoc1);
        
        rqId = ApexPages.CurrentPage().getParameters().get('id');
        String accId = U.contact.account.id;
        if(rqId!=null){
            req = [select Id,xvnum__c,xcsfn__c, acc__r.id,Service_Code__c, srvc__c,xchn__c,xcmob__c,rmob__c, srvc__r.Name,srvc__r.stg__c, srvc__r.stg__r.pg__c,srvc__r.AddOnSrv__c,srvc__r.uid__c,xaed__c,xdapp__c,srvc__r.stg__r.reqq__c,srvc__r.stg__r.bopg__c from g_Req__c where id =: rqId]; 
            req = (g_Req__c)Database.query(req.srvc__r.stg__r.reqq__c + ' where id=\'' + rqId + '\' and isDeleted = false');
            accId = req.acc__c;
            rdocList = [select id from g_reqDoc__c where RQ__c =:req.Id  and reqAts__c=true and upOk__c=true];//and Req__c=true
            system.debug('rdocList--- '+rdocList);
            Map<string,Attachment> attMp = new Map<string,Attachment>();
            
            for(Attachment att : [select id,name,body,parentid from Attachment where parentid=:rdocList]){attMp.put(att.name.split('\\.')[0],att);           }
            for(customDoc d : EIDDoc1){
                if(attMp != null && attMp.containskey(d.DocName)){
                    Attachment att = attMp.get(d.DocName);d.attId = att.Id;Eid = att.Id; d.attName = att.name;
                }
            }
        }
        Acc= [select vetemp__c,park__c,mtc__c,Name,Email__c,Phone,id,adb__c,xcuzn__c,xcublg__c,bgb__c,bgnr__c,bg__c,loc__c,Type,Prk__c,lcsnc__c,lcsncnt__c,lcedt__c,psasnc__c,psasncnt__c,ecsnc__c,ecsncnt__c,cosnc__c,cosncnt__c,bgsnc__c,bgsncnt__c,snc__c,info__c,vestd__c,vbtemp__c,vbvv__c,lc__c,ORACLE_PARTY_ID__c,lcsta__c,lctp__c,session__c,vctemp__c,vvsfp__c,lcrndt__c,os__c from Account where id=:accId];
        
        system.debug('Account --- '+Acc);
        system.debug('sid --- '+sid);
        acc=Acc;
        getParkings();
        if(sid!=null){
            srvLst = [select id, name, uid__c,sdg__r.Name,sdg__r.slbl__c,sdg__r.sd__c from g_Srvc__c where id=:sid limit 1];
            srv = srvLst[0];
            system.debug('Service -- '+srv);
            system.debug('sdg__r.sd__c -- '+srv.sdg__r.sd__c);
            if(srv!=null){
                pt = srv.name;
                req.srvc__c = srv.id;
            }
            
        }else if(rqId!=null){
            srvLst = [select id, name, uid__c,sdg__r.Name,sdg__r.slbl__c,sdg__r.sd__c from g_Srvc__c where id=:req.srvc__c limit 1];
            system.debug('srvLst -- '+srvLst);
            if(srvLst.size()>0) srv = srvLst[0];
            if(srv!=null){ pt = srv.name;}
        }
        /*srvDefId = srv.sdg__c;
if(string.isNotBlank(srvDefId))
pgHide = !(gU.canAccess2(srvDefId,false,null));*/ // commented on 03/06/2022
        req.Acc__c = U.contact.account.id;
        req.STA__c = 'draft';
        
        /* pre populate details from account/contact*/
        if(String.isBlank(rqId)){ String phNo = (String.isNotBlank(U.contact.mobilephone))?U.contact.mobilephone:''; phNo = (String.isNotBlank(phNo)&&phNo.contains('+971'))?phNo.split('971')[1]:phNo; req.rmob__c = phNo; req.xcmob__c = phNo; req.xceml__c = (String.isNotBlank(U.contact.email))?U.contact.email:U.contact.account.email__c; req.xbrnd__c = (String.isNotBlank(U.contact.account.xcuzn__c))?U.contact.account.xcuzn__c:''; req.xbn__c = (String.isNotBlank(U.contact.account.Building_Name__c))?U.contact.account.Building_Name__c:''; System.debug('req.U.contact.account.Building_Name__c : ' + U.contact.account.Building_Name__c); }
        system.debug('Request --- '+req);
    }
    
    
    /* check vehicle validity starts*/
    public Boolean isValidVeh {set;get;}
    public PageReference checkVehVal(){ isValidVeh = false; string r = Apexpages.currentPage().getParameters().get('reqJson'); System.debug('@@reqJson :' + r); String res = WsParking.callParkingWs(r); System.debug('@@res :' + res); WsParking.Response resp = (WsParking.Response)JSON.deserialize(res,WsParking.Response.class); System.debug('@@resp :' + resp); if(resp.Status=='RecordFound') isValidVeh = true; return null; }
    
    /* check vehicle validity ends*/
    
    //public Pagereference saveReq() { system.debug('in saveReq --208'); system.debug('SERVICE CODE -- ' + req.srvc__r.uid__c); try { req.sta__c = (req.sta__c == 'Draft' || string.isBlank(req.sta__c)) ? 'Open' : req.sta__c; list < g_srvcitm__c > its = [select id, name, ATN__c from g_srvcitm__c where cd__c in: req.xadh__c.split(';') and actv__c = true and srvc__c =: req.srvc__c]; system.debug('its -- ' + its); system.debug('req.sta__c -- ' + req.sta__c); upsert req; String rName = [select name from g_req__c where id =: req.Id].name; system.debug('rName -- ' + rName); system.debug('req.xadtx4__c -- ' + req.xadtx4__c + ' srv.uid__c:: ' + srv.uid__c); String ad4 = req.xadtx4__c; ad4 = ad4.replaceAll('"OracleID":""', '"OracleID":"' + Acc.ORACLE_PARTY_ID__c + '"'); ad4 = ad4.replaceAll('"AXSId":""', '"AXSId":"' + rName + '"'); system.debug('ad4 -- ' + ad4); System.enqueueJob(new OnboardQueueable('parking', ad4, req.id + ';' + req.srvc__r.uid__c)); PageReference pageRef = new PageReference('/apex/grqsinfo?id=' + req.id); if (req.srvc__r.uid__c == gu.csStr('ParkingActivation')) { List < Contact > c = [select id, name, apc__c from contact where id =: req.Con__r.id]; if (c != null && c.size() > 0) { c[0].apc__c = req.rtacn__c; update c[0]; } } else if (srv.uid__c == gu.csStr('ParkingCancellation')) { List < Contact > c = [select id, name, apc__c from contact where apc__c =: req.rtacn__c and accountid =: U.contact.account.id]; if (c != null && c.size() > 0) { c[0].apc__c = ''; update c[0]; } } system.debug('pageRef-215 -- ' + pageRef); system.debug('its-216 -- ' + its); if (its.size() > 0) { for (g_srvcitm__c i: its) { if (i.ATN__c > 0) pageRef = new PageReference('/apex/grqpy?id=' + req.id); system.debug('pageRef-221 -- ' + pageRef); } } else if (req.xtpa__c > 0) { system.debug('req.xtpa__c -- ' + req.xtpa__c); pageRef = new PageReference('/apex/grqpy?id=' + req.id); system.debug('pageRef-227 -- ' + pageRef); } if (req.srvc__r.uid__c == '149') { updateItemSTA(); } system.debug('pageRef-229 -- ' + pageRef); return pageRef; } catch (Exception e) { system.debug('ex::' + e.getStackTraceString()); gU.AddErrorMsg(Label.msgException); System.debug(LoggingLevel.ERROR, 'Exception: ' + e.getMessage() + ' ' + e.getStackTraceString()); return null; } }
    public Pagereference saveReq() { system.debug('in saveReq --208'); system.debug('SERVICE CODE -- ' + req.srvc__r.uid__c); try { system.debug('req.sta__c -- '+req.sta__c); system.debug('req.xadh__c -- '+req.xadh__c); req.sta__c = ((req.sta__c == 'Draft' || string.isBlank(req.sta__c)) && req.xadh__c=='0np;' )?'Under Review':req.sta__c; req.sta__c = (req.sta__c == 'Draft' || string.isBlank(req.sta__c)) ? 'Open' : req.sta__c; list < g_srvcitm__c > its = [select id, name, ATN__c from g_srvcitm__c where cd__c in: req.xadh__c.split(';') and actv__c = true and srvc__c =: req.srvc__c]; system.debug('its -- ' + its); system.debug('req.sta__c -- ' + req.sta__c); upsert req; String rName = [select name from g_req__c where id =: req.Id].name; system.debug('rName -- ' + rName); system.debug('req.xadtx4__c -- ' + req.xadtx4__c + ' srv.uid__c:: ' + srv.uid__c); String ad4 = req.xadtx4__c; ad4 = ad4.replaceAll('"OracleID":""', '"OracleID":"' + Acc.ORACLE_PARTY_ID__c + '"'); ad4 = ad4.replaceAll('"AXSId":""', '"AXSId":"' + rName + '"'); system.debug('ad4 -- ' + ad4); System.enqueueJob(new OnboardQueueable('parking', ad4,rName)); PageReference pageRef = new PageReference('/apex/grqsinfo?id=' + req.id); if (req.srvc__r.uid__c == gu.csStr('ParkingActivation')) { List < Contact > c = [select id, name, apc__c from contact where id =: req.Con__r.id]; if (c != null && c.size() > 0) { c[0].apc__c = req.rtacn__c; update c[0]; } } else if (srv.uid__c == gu.csStr('ParkingCancellation')) { List < Contact > c = [select id, name, apc__c from contact where apc__c =: req.rtacn__c and accountid =: U.contact.account.id]; if (c != null && c.size() > 0) { c[0].apc__c = ''; update c[0]; } } system.debug('pageRef-215 -- ' + pageRef); system.debug('its-216 -- ' + its); system.debug('req.xtpa__c -- ' + req.xtpa__c);  if (req.xtpa__c > 0) { system.debug('req.xtpa__c -- ' + req.xtpa__c); pageRef = new PageReference('/apex/grqpy?id=' + req.id); system.debug('pageRef-227 -- ' + pageRef); } else if (its.size() > 0) { for (g_srvcitm__c i: its) { if (i.ATN__c > 0) pageRef = new PageReference('/apex/grqpy?id=' + req.id); system.debug('pageRef-221 -- ' + pageRef); } } if (req.srvc__r.uid__c == '149') { updateItemSTA(); } system.debug('pageRef-229 -- ' + pageRef); return pageRef; } catch (Exception e) { system.debug('ex::' + e.getStackTraceString()); gU.AddErrorMsg(Label.msgException); System.debug(LoggingLevel.ERROR, 'Exception: ' + e.getMessage() + ' ' + e.getStackTraceString()); return null; } }
    
    public PageReference saveDraft(){
        if(string.isBlank(req.sta__c)){req.sta__c = 'Draft';}
        //if(string.isNotBlank(req.xcfn__c)&& req.Service_Code__c=='149'){req.xchn__c=req.xcfn__c;}
        //system.debug('---req.xchn__c---'+req.xchn__c);
        try{
            system.debug('req--- '+req);
            upsert req;
            PageReference pageRef = new PageReference('/'+req.id);
            return pageRef;
        }catch(DMLException exDML){
            System.Debug('**  exDML.getDmlType(i) : ' +  exDML.getNumDml() + '   **StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION: '+StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION); 
            for (Integer i = 0; i < exDML.getNumDml(); i++) {
                if( exDML.getDmlType(i) != StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION ){System.Debug('** Exception:'+exDML.getDmlMessage(i));  gu.AddErrorMsg(Label.msgException+'3');}
            }
            return null;
        }
    }
    
    
    /* Non-RTA FREE parking starts */
    public List<ParkingM.ParkingDetails_m> lst_pd3{get;set;}
    public PageReference loadCards() { system.debug('req-- ' + req); system.debug('md-- ' + md + ' && md.isEdit -- ' + md.isEdit + ' && md.isNew -- ' + md.isNew); try { if (req != null) { system.debug('req id -- ' + req.id); system.debug('Service Code -- ' + srv.uid__c); ParkingM pm = new ParkingM(); hdCnt = false; system.debug('srv.uid__c -- ' + srv.uid__c); system.debug('Acc -- ' + Acc); if (srv.uid__c ==gu.csStr('DOCAdditionalParking')|| srv.uid__c == gu.csStr('AdditionalParking') || srv.uid__c == gu.csStr('ParkingRenewal')) { lstAddparks = pm.getAddParks(req, acc.ORACLE_PARTY_ID__c); if (lstAddparks.size() == 0) { hdCnt = true; } if (!req.STA__c.equalsIgnoreCase('open') && lstAddparks.size() == 0) { st = false; } parkingCardString = JSON.serialize(lstAddparks); system.debug('parkingCardString -- ' + parkingCardString); } else if (srv.uid__c == gu.csStr('ParkingModification')) { lst_pd3 = pm.loadCards(Acc.ORACLE_PARTY_ID__c); parkingString = JSON.serialize(lst_pd3); } else { if (String.isNotBlank(cn)) { req.xtcid__c = cn; ParkingM.shwOne = true; } else { ParkingM.shwOne = false; } String opi = ''; if (ispu) { opi = Acc.ORACLE_PARTY_ID__c; } else if (srv.uid__c == '197') { List < Account > acc1 = [SELECT id, ecedt__c, name, ORACLE_PARTY_ID__c FROM account WHERE id =: req.Acc__c]; if (acc1.size() > 0) opi = acc1[0].ORACLE_PARTY_ID__c; } System.debug('@@@@ opi : ' + opi); lst_pd3 = pm.loadCards(req, srv.uid__c, opi); parkingString = JSON.serialize(lst_pd3); System.debug('@@@@ parkingString : ' + parkingString); lst_pd1 = new List < String > (); List < ParkingM.ParkingDetail > lst_pd2 = new List < ParkingM.ParkingDetail > (); for (ParkingM.ParkingDetail p: lst_pd) { if (vehicleNum != null) { if (p.vehicleNumber == vehicleNum || p.secVclNum == vehicleNum) lst_pd2.add(p); } } system.debug('lst_pd2 -- ' + lst_pd2); for (ParkingM.ParkingDetail p: lst_pd) { lst_pd1.add(p.cardNum); } if (lst_pd2.size() > 0) parkingString1 = JSON.serialize(lst_pd2); else parkingString = JSON.serialize(lst_pd); if (!req.STA__c.equalsIgnoreCase('open') && lst_pd.size() == 0) { st = false; } System.debug('!!! ST : ' + st + ' *** pgHide: ' + pgHide); } } if (String.isNotBlank(pdMsg) && !md.isNew) { gU.AddWarningMsg(pdMsg); } } catch (Exception ex) { st = false; System.debug('Exception : ' + ex.getStackTraceString()); } return null; }
    
    
    
    
    // Push Parking data 
    public Pagereference pushParkingData() { system.debug('nd --- ' + nD); Pagereference ref;  if (!nD) { Map < String, String > response = new Map < String, String > (); response.put('ResponseCode', '0'); response.put('errMessage', ''); system.debug('request -- ' + req);  try {  if (req.STA__c == 'Open' || req.STA__c == 'draft') { ParkingM pm = new ParkingM(); pm.adh4 = req.xadtx4__c; system.debug('pm.adh4----' + req.xadtx4__c); /*response = pm.pushReqItems(req.Id,new list<g_reqitem__c>()); */ }  ref = saveReq(); System.debug('<pushParkingData> : ' + response); return ref; } catch (Exception ex) { if (ex.getMessage().contains('Apex heap size too large')) { gu.AddErrorMsg('Attachments exceeded the allowable limit!'); } } }  gU.AddErrorMsg('Vehicle Documents are missing please check'); return null; }
    
    
    // for Deactivation and cancellation
    public Pagereference processParking() { /*Boolean returnPg = false;*/ if (srv.uid__c == gu.csStr('ParkingCancellation') || srv.uid__c == gu.csStr('ParkingDeact')) { /*String status = (srv.uid__c==gu.csStr('ParkingCancellation')) ? 'Under Review' : 'Completed';*/ /*if (!req.xoca__c) {*/ Pagereference ref = saveReq(); system.debug('req.xtpa__c -- '+req.xtpa__c); if(req.xtpa__c==null||req.xtpa__c==0){ } updateItemSTA(); return ref; /*returnPg = true; }*/ } return null; }
    
    public PageReference loadCards2() {
        system.debug('loadCards2 --');
        //lst_pd = new parkingM().loadCards('29169');
        return null;
    }
    
    
    public PageReference loadPNums() {
        List<ParkingM.ParkingDetail> lst_pd2 = new List<ParkingM.ParkingDetail>();
        system.debug('lst_pd--205 '+lst_pd);
        if(lst_pd!=null&&lst_pd.size()>0){
            for(ParkingM.ParkingDetail p: lst_pd){if(p.cardNum == reqCardNum) lst_pd2.add(p);}
        }
        lst_pd = lst_pd2;
        parkingString = JSON.serialize(lst_pd2);
        return null;
    }
       
    
    public void getParkings() {
        el=new Map<String,Integer>();el.put('eligibilty',0); el.put('utilized',0);
        try{ParkingM p = new ParkingM(); el = p.getEligibility(acc);} catch(Exception ex){System.debug('@@Exception : ' + ex.getMessage() + ' ' + ex.getStackTraceString());}
    }
    /* Non-RTA FREE parking ends */
    
    
    
    
    public List<ParkingM.PkgCard> lstCards{get;set;}  
    public List<ParkingM.PkgCard> lstPaidCards{get;set;}  
    public String lstCardsStr{get;set;}
    
    
    
    public PageReference getpkgCards(){ system.debug('498 -- in getpkgCards'); system.debug('in getpkgCards 456'+req.xuvdet__c); try{ List<ParkingM.PkgCard> unpaidCards = new List<ParkingM.PkgCard>(); lstCards = new ParkingM().getpkgCards(req.xuvdet__c); lstPaidCards = new List<ParkingM.PkgCard>(); if (String.isNotBlank(req.xuvdet__c)) { lstCards = new ParkingM().getpkgCards(req.xuvdet__c); for (ParkingM.PkgCard c : lstCards) { if (c.isPaid == true) { lstPaidCards.add(c); } else { unpaidCards.add(c); } } lstCards = unpaidCards; } lstCardsStr = JSON.serialize(lstCards); System.debug('🧾 Unpaid cards JSON: ' + lstCardsStr); } catch(Exception ex){ system.debug('getMessage --'+ex.getMessage()); gu.AddInfoMsg('Couldn\'t fetch existing card details, please contact your administrator!'); } system.debug('lstCards --'+lstCards); return null; }
    //ToDo : Handle in JS
    public void getStDate(){ if(req.xfpc__c==null){stdt=System.now().addDays(2);}else{stdt=req.xfpc__c;} stDt = date.newInstance(stDt.year(), stDt.month(), stDt.day());}
    public gctlPrk(){}
    
    // public void conInfo(){Contact con  = [select id,Salutation,ms__c from Contact where id=:req.Con__c];req.xcslt__c = con.Salutation;req.xcms__c = con.ms__c;}
    
    // parking cancellation and deactivation
    // public boolean processParking(){Boolean returnPg = false;if(srv.uid__c==gu.csStr('ParkingCancellation') || srv.uid__c==gu.csStr('ParkingDeact')) {/*String status = (srv.uid__c==gu.csStr('ParkingCancellation')) ? 'Under Review' : 'Completed';*/if(!req.xoca__c) {upsertR('Under Review'); new ParkingM().pushReqItems(req.Id, new List<g_reqitem__c>()); returnPg =true; }} return returnPg;}
    /* Non RTA PAID/Additional parking ends */
    @testvisible  private void upsertR(String sta) {
        req.STA__c = sta;
        // system.debug('spouse name::' + req.xspn__c);
        upsert req;
        //update req;
    }
    
    public PageReference saveReq1_UR(){ Pagereference ref = null; try { req.STA__c='Under Review'; upsert req;} catch (DMLException exDML) {system.debug('DMLExceptionEEEEEE: ' + exDML);for (Integer i = 0; i < exDML.getNumDml(); i++) {if (exDML.getDmlType(i) != StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION) {System.Debug('** Exception:' + exDML.getDmlMessage(i));gu.AddErrorMsg(Label.msgException );}} return null; } catch (exception ex) {gu.AddErrorMsg(Label.msgException); System.debug(LoggingLevel.ERROR, 'Exception: ' + ex.getMessage() + ' ' + ex.getStackTraceString()); return null; } system.debug('req.id -- '+req.id); ref = new Pagereference('/grqsinfo?id='+req.id); ref.setRedirect(true); return ref; }
    
    public PageReference saveReq1(){
        Pagereference ref = null;
        try {
            system.debug('req -- 468 '+req);
            req.STA__c='Draft';
            upsert req;} catch (DMLException exDML) {system.debug('DMLExceptionEEEEEE: ' + exDML);for (Integer i = 0; i < exDML.getNumDml(); i++) {if (exDML.getDmlType(i) != StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION) {System.Debug('** Exception:' + exDML.getDmlMessage(i));gu.AddErrorMsg(exDML );}}
                                                     return null;     
                                                    } catch (exception ex) {system.debug('ex--- '+ex.getMessage()); gu.AddErrorMsg(Label.msgException); System.debug(LoggingLevel.ERROR, 'Exception: ' + ex.getMessage() + ' ' + ex.getStackTraceString()); return null;   }
        system.debug('req.id -- '+req.id);
        ref = new Pagereference('/'+req.id);
        ref.setRedirect(true);
        return ref;
    }
    public PageReference SR_AddPrk(){
        Pagereference ref = null;
        try {
            system.debug('req -- '+req);
            req.xneng__c = req.xrap__c; 
            if(req.xadh__c != 'vip;'){ if(req.xcawp__c == true && req.AUP__c <= 0){ req.xadh__c = updatePrSequence(req.xadh__c); } }
            else{
            req.STA__c='Open';
            }
            upsert req;
        } catch (DMLException exDML) {system.debug('DMLExceptionEEEEEE: ' + exDML);for (Integer i = 0; i < exDML.getNumDml(); i++) {if (exDML.getDmlType(i) != StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION) {System.Debug('** Exception:' + exDML.getDmlMessage(i));gu.AddErrorMsg(Label.msgException );}}
                                                     return null;     
                                                    } catch (exception ex) {gu.AddErrorMsg(Label.msgException); System.debug(LoggingLevel.ERROR, 'Exception: ' + ex.getMessage() + ' ' + ex.getStackTraceString()); return null;   }
        return null;
    }
    public String updatePrSequence(String adhocItems) { Pattern prPattern = Pattern.compile('pr(\\d+)'); Matcher m = prPattern.matcher(adhocItems); Integer maxNum = -1; while (m.find()) { Integer currentNum = Integer.valueOf(m.group(1)); if (currentNum > maxNum) { maxNum = currentNum; } } Integer nextNum = maxNum + 1; adhocItems += 'pr' + String.valueOf(nextNum) + ';'; System.debug('Updated adhocItems = ' + adhocItems); return adhocItems; }
    
    public PageReference saveAtt() { if (req.Id == null) { req.STA__c = 'Draft'; upsert req; } system.debug('Request --394 ' + req); Pagereference ref = null; try { system.debug('Rq Id::' + req.Id); system.debug('docName: ' + docName); if (req.Id != null) { List < g_reqDoc__c > rqDocList = [select id, RQ__r.name, RQ__r.xaed__c, RQ__r.xdapp__c from g_reqDoc__c where RQ__c =: req.Id and name =: docName]; if (rqDocList != null && !rqDocList.isEmpty()) { String rqNo = rqDocList[0].RQ__r.name; Attachment A = new Attachment(); if (docName.contains('vehicle')) A = new Attachment(Body = EncodingUtil.base64Decode(imageBase64), Name = docName + '.jpg', ParentId = rqDocList[0].id); else A = new Attachment(Body = EncodingUtil.base64Decode(imageBase64), Name = docName + '.jpg', ParentId = rqDocList[0].id); system.debug(docName + '\'s Attachment -- ' + A); insert A; system.debug('rqNo::' + rqNo); for (customDoc d: EIDDoc1) { if (docName.contains(d.DocName)) { d.attId = A.Id; d.attName = A.name; Eid = A.Id; } } } system.debug('request -- 440' + req); update req; /*if(!nD){ updateItemSTA(); }*/ } } catch (Exception e) { system.debug('ex::' + e.getStackTraceString()); gU.AddErrorMsg(Label.msgException); System.debug(LoggingLevel.ERROR, 'Exception: ' + e.getMessage() + ' ' + e.getStackTraceString());  } if (rqId == null || rqId == '') { ref = new Pagereference('/' + req.id); ref.setRedirect(true); return ref; } system.debug('Request -- ' + req); saveReq1(); return null; }
    
    public void pushAttCRM() { g_req__c r = [select id, name, xadtx4__c from g_req__c where id =: rqId]; String attReqData = '{"ActionName":"insertvehicleattachment","VehicleNumber":"","contentType":"","attachmentName":"","body":""}'; system.debug('xadtx4__c -- ' + r.xadtx4__c); WsParking.parkReq adhoc4 = (WsParking.parkReq) JSON.deserialize(r.xadtx4__c, WsParking.parkReq.class); WsParking.parkReq attReqData1 = (WsParking.parkReq) JSON.deserialize(attReqData, WsParking.parkReq.class); system.debug('adhoc4 -- ' + adhoc4); system.debug('adhoc4.CardsDetail[0] -- ' + adhoc4.CardsDetail[0]); system.debug('adhoc4.CardsDetail[0].Vehicles[0] -- ' + adhoc4.CardsDetail[0].Vehicles[0]); String vNum = adhoc4.CardsDetail[0].Vehicles[0].PlateNumberCode; List < g_reqDoc__c > lstRqDocs = [Select id, name from g_reqDoc__c where Req__c = true and reqAts__c = true and upOk__c = true and RQ__c =: r.id]; system.debug('lstRqDocs -- ' + lstRqDocs); List < attachment > lstAtt = [Select id, name, body from attachment where parentid =: lstRqDocs]; attReqData1.VehicleNumber = vNum; if (lstAtt.size() > 0) { system.debug('lstAtt[0].Name -- ' + lstAtt[0].Name.split('\\.')[0]); attReqData1.attachmentName = lstAtt[0].Name.split('\\.')[0]; attReqData1.contentType = lstAtt[0].Name.split('\\.')[1]; attReqData1.body = EncodingUtil.base64Encode(lstAtt[0].body); attReqData = JSON.serialize(attReqData1); String res = WsParking.callParkingWs(attReqData); System.debug('@@res :' + res); } }
    
    
    public PageReference deleteAttach(){
        try {
            string attId = Apexpages.currentPage().getParameters().get('attId');
            system.debug('deleteAttach attId >>'+ attId);
            Attachment A = new Attachment(Id = attId);delete A;for(customDoc doc : EIDDoc1){if(doc.attId == attId){doc.attId = '';doc.attName = '';Eid = null;PageReference pageRef = new PageReference('/'+req.id);return pageRef;}}
        }catch (Exception e) {
            system.debug('ex::'+e.getStackTraceString());
            gU.AddErrorMsg(e);}
        return null;
    }
    
    
    //Common methods
    public void updateItemSTA(){ list<g_reqitem__c> Itms = new list<g_reqitem__c>(); Set<g_reqitem__c> tempSet = new Set<g_reqitem__c>(); list<g_reqitem__c> Itmsfromset = new list<g_reqitem__c>(); boolean isReqCompleted = false; system.debug('Query -- SELECT Id,RQ__c,RQ__r.srvc__c,sta__c,sta__r.statype__c,sta__r.Next_Status__c,sta__r.Next_Status__r.rqSTA__c,sta__r.Next_Status__r.xcsits__c,itm__c,itm__r.cd__c from g_reqitem__c where RQ__c ='+req.id+' and isdeleted=false order by createdDate desc'); List<g_reqitem__c> itmIds=[SELECT Id,RQ__c,RQ__r.xaed__c,RQ__r.xdapp__c,RQ__r.srvc__c,sta__c,sta__r.statype__c,sta__r.Next_Status__c,sta__r.Next_Status__r.rqSTA__c,sta__r.Next_Status__r.xcsits__c,itm__c,itm__r.cd__c from g_reqitem__c where RQ__c =:req.id and sta__r.Next_Status__c!=null and isdeleted=false order by createdDate desc];   /*sta__r.isfn__c=true */ System.debug('updateItemSTA - <itmIds> : ' + itmIds); if(!itmIds.isEmpty() && itmIds.size()>0){ for(g_reqitem__c i:itmIds ){ if(i.sta__r.Next_Status__r.xcsits__c != null && i.sta__r.Next_Status__r.xcsits__c != ''){ List<String> lst = i.sta__r.Next_Status__r.xcsits__c.split(';'); Map<String,String> itmMp = new Map<String,String>(); Map<String,String> stsMp = new Map<String,String>(); for(String str : lst) itmMp.put(str.split(':')[0],str.split(':')[1]); system.debug('itmMp::'+itmMp); for(g_srvcitm_Status__c sts : [select id,cd__c,uid__c from g_srvcitm_Status__c where itm__r.srvc__c =:i.RQ__r.srvc__c and itm__r.cd__c =:itmMp.keySet() and cd__c =:itmMp.values()]) stsMp.put(sts.uid__c,sts.id); system.debug('stsMp::'+stsMp); for(g_reqitem__c ri : [select id,sta__c,itm__r.cd__c,itm__r.uid__c from g_reqitem__c where rq__c =:i.RQ__c and itm__r.cd__c=:itmMp.keySet()]){ String stsCode = itmMp.get(ri.itm__r.cd__c);  system.debug('stsCode::'+stsCode+':'+ri.itm__r.cd__c+stsCode); Itms.add(new g_reqitem__c(id=ri.id,sta__c=stsMp.get(ri.itm__r.uid__c+stsCode))); }  } if(String.isNotBlank(i.sta__r.statype__c) && i.sta__r.statype__c == 'Correction') { i.xcdocs__c = ''; i.xcnotes__c = ''; i.xr__c = ''; } if(i.sta__r.Next_Status__c!=null) {i.sta__c=i.sta__r.Next_Status__c;} if((i.sta__r.Next_Status__c !=null && i.sta__r.Next_Status__r.rqSTA__c == 'Completed') || (i.itm__r.cd__c == 'ai' && i.sta__r.Next_Status__c !=null) ){ req.STA__c = i.sta__r.Next_Status__r.rqSTA__c; isReqCompleted = true; }  Itms.add(i);   } }  system.debug('Itms====='+Itms); if(!Itms.isEmpty() && Itms.size()>0){ update Itms; if(isReqCompleted) { /*/req.STA__c='Completed';*/ update req; } } }
    
    public class customDoc{
        public id ItemSta {get;set;}
        public string DocName {get;set;}
        public string VehName {get;set;}
        public string ItemName {get;set;}
        public string ItemCode {get;set;}
        public string DocLabel {get;set;}
        public string DocType {get;set;}
        public String attId {get;set;} 
        public String tmpltId {get;set;}  
        public String attName {get;set;} 
        public boolean parse {get;set;} 
        public boolean isSaveRQ {get;set;}
        public boolean isOptional {get;set;} 
    }
    
    
    
}
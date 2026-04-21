public  with sharing class gctlMembers extends pgBsCtrl{
    public String docName { get; set; }
    public String reqDocId { get; set; }
    public String pgHide { get; set; }
    public String ispu { get; set; }
    public id accid {set;get;}
    Public  User  U{set;get;}
    public string currentPg {set;get;}
    public integer ttlShares {set;get;}
    public double shareValue {set;get;}
    public g_Req__c rq{get;set;}
    public transient  String imageBase64 {get;set;}
    public transient  String AOADoc {get;set;}
    public List <g_reqDoc__c> AOADocs {get;set;}
    public String delDocID {get;set;}
    public String delcsdDocID {get;set;}
    public List<D> docList {set;get;}
    public Boolean gmDecUploaded {set;get;}
    public Attachment gmDec {set;get;}
    public Attachment csd {set;get;}
    public Account Acc{get;set;}
    public PageReference nextPage() {return null;}
    public PageReference saveContinue() {return null; }
    public PageReference deleteAttachment() {return null;}

    public gctlRequ componentOne {get; set;}
    public String sourceOfFundJSON { get; set; }
    public void init_mem() {
        gmDecUploaded = false;

        gmDec = new Attachment();
         //=new Attachment();
        List<Attachment> aa = [SELECT id, name from attachment where parentId=:rq.id and name in('General Manager Declaration', 'Company Structure Doc') order by name desc];
        system.debug('---aa---'+aa);

        if (aa.size()>0) {
            //gmDecUploaded = true;
            gmDec = aa[0];//csd=aa[1];
            //system.debug('---aa[0]---'+aa[0]);
            //system.debug('---aa[1]---'+aa[1]);
        }

        system.debug('gmDec--- '+gmDec);
        AOADocs = [select id, name, (select id, name from Attachments order by createddate desc limit 1) from g_reqDoc__c where rq__r.id=:rq.id and (name like '%Signed AOA%' OR name='Application Form')];
        docList = new List<D>();
        for (g_reqitemDoc__c doc : [select id, name, reqDoc__r.name, reqDoc__c,
            reqDoc__r.tplt__c from g_reqitemDoc__c where reqItm__r.RQ__c =:rq.id and Req__c=true and reqAts__c=true and upOk__c=false  order by createddate]) {
            D obj = new D();
            obj.DocName = doc.reqDoc__r.name;
            obj.tmpt = doc.reqDoc__r.tplt__c;
            docList.add(obj);
        }
        system.debug('docList:'+docList);
    }

    public String attchedCorpDocId{get;set;}
    public List<String> corpDocsNames{get;set;}
    public void saveAttachment() {
        corpDocsNames = new List<String>{'Trade license copy', 'Certificate of company incorporation', 'Memorandum of association of parent company', 'Article of association of parent company'};
            system.debug('save method called: ' );
        String attName = '';
        try {
            attName = docName;
            system.debug('docName: ' + docName);
            system.debug('reqDocId: ' + reqDocId);
            attName = attName.replace('.jpg', ';');
            Attachment A = new Attachment(Body = EncodingUtil.base64Decode(imageBase64), Name = docName, ParentId = rq.id);
            if (Schema.sObjectType.Attachment.isCreateable()) {
                insert A;
            }
            //system.debug('A')
            rq.xepAtt__c= A.Id;
            for (String s:corpDocsNames) {
                if (docName.contains(s))
                    attchedCorpDocId = A.Id;
                system.debug('attchedCorpDocId -- '+attchedCorpDocId);
            }
            //system.debug('rq.xepAtt__c. ---'+rq.xepAtt__c);
        } catch (Exception e) {
            system.debug('ex::'+e.getStackTraceString());
            gU.AddErrorMsg(Label.msgException); System.debug(LoggingLevel.ERROR, 'Exception: ' + e.getMessage() + ' ' + e.getStackTraceString());
        }
    }

    //public g_reqDoc__c doc{get;set;}
    public void saveAttachment1() {
        // itm = [select id from g_reqitem__c where rq__r.id =: rq.id and name='License_Registration_Request'];
        g_reqDoc__c doc = [select id from g_reqDoc__c where rq__r.id =: rq.id and name =:docName];
        String attName = '';

        try {
            attName = docName + '.pdf';
            System.debug('AOADoc: ' + AOADoc);
            Attachment A = new Attachment(Body = EncodingUtil.base64Decode(AOADoc), Name = attName, ParentId = doc.id);
            if (Schema.sObjectType.Attachment.isCreateable()) {
                insert A;
            }

            if (docName == 'Signed AOA' || docName == 'Application Form') {
                AOADocs = [select id, name, (select id, name from Attachments order by createddate desc limit 1) from g_reqDoc__c where rq__r.id=:rq.id and (name like '%Signed AOA%' OR name='Application Form')];
            }else{
                for (D d : docList) {
                    if (d.DocName == docName) {
                        d.attId = A.Id;
                        d.attName =attName;
                    }
                }
            }
            // init_mem();
        } catch (Exception e) {
            system.debug('ex::'+e.getStackTraceString());
            gU.AddErrorMsg(Label.msgException); System.debug(LoggingLevel.ERROR, 'Exception: ' + e.getMessage() + ' ' + e.getStackTraceString());
        }
    }

    public void savegmDec1() {
        gmDecUploaded = true;
        try {
            List<g_reqitemDoc__c>  docLst =Database.query('select id, name, reqDoc__c, Req__c, reqAts__c, reqItm__c from g_reqitemDoc__c where name like \'%Declaration of Appointment as General Manager%\' and reqItm__r.RQ__c=\''+
                rq.id +'\'');
            if (docLst != null && !docLst.isEmpty()) {
              String doclbl = grqWsOnboard.updateRqDocs(docLst[0].reqDoc__c);
                docName = docName.replace(docName.substringBefore('.'), doclbl);
              Attachment A = new Attachment(Body = EncodingUtil.base64Decode(AOADoc), Name = docName, ParentId = docLst[0].reqDoc__c);
              if (Schema.sObjectType.Attachment.isCreateable()) {
                  insert A;
              }
              docLst[0].Req__c = true;
              docLst[0].reqAts__c = true;
              if (Schema.sObjectType.g_reqitemDoc__c.isUpdateable()) {
                  update docLst;
              }
              gmDec =[select id, name from Attachment where id=:A.id][0];
           }
        } catch (Exception e) {
            system.debug('ex::'+e.getStackTraceString());
            gU.AddErrorMsg(Label.msgException); System.debug(LoggingLevel.ERROR, 'Exception: ' + e.getMessage() + ' ' + e.getStackTraceString()); }
    }
    public void savecsd1() {
        try {
            List<g_reqitemDoc__c>  docLst =Database.query('select id, name, reqDoc__c, Req__c, reqAts__c, reqItm__c from g_reqitemDoc__c where name like \'%Company Structure Doc%\' and reqItm__r.RQ__c=\''+
                rq.id +'\'');
            if (docLst != null && !docLst.isEmpty()) {
                String doclbl = grqWsOnboard.updateRqDocs(docLst[0].reqDoc__c);
                docName = docName.replace(docName.substringBefore('.'), doclbl);
                Attachment A = new Attachment(Body = EncodingUtil.base64Decode(AOADoc), Name = docName, ParentId = docLst[0].reqDoc__c);
                if (Schema.sObjectType.Attachment.isCreateable()) {
                    insert A;
                }
                docLst[0].Req__c = true;
                docLst[0].reqAts__c = true;
                if (Schema.sObjectType.g_reqitemDoc__c.isUpdateable()) {
                    update docLst;
                }
                rq.xoca__c=true;
                if (Schema.sObjectType.g_req__c.isUpdateable()) {
                    update rq;
                }
                csd =[select id, name from Attachment where id=:A.id][0];
            }
        }
        catch (Exception e) {
            system.debug('ex::'+e.getStackTraceString());
            gU.AddErrorMsg(Label.msgException); System.debug(LoggingLevel.ERROR, 'Exception: ' + e.getMessage() + ' ' + e.getStackTraceString());
        }
    }

    public Attachment delAtt {get;set;}
    public Attachment delAttCsd {get;set;}
    public void deleteAOADocs() {
        String doc_id = delDocID;
        system.debug('----doc_id----'+doc_id);
        delAtt = [select id from attachment where id=:doc_id];
        if (Schema.sObjectType.Attachment.isDeletable()) {
            delete delAtt;
        }
        rq.xoca__c=false;
        if (Schema.sObjectType.g_req__c.isUpdateable()) {
            update rq;
        }
        init_mem();
    }
    public void deletecsd() {
        String doc_id = delcsdDocID;
        system.debug('----doc_id----'+doc_id);
        delAttCsd = [select id from attachment where id=:doc_id];
        if (Schema.sObjectType.Attachment.isDeletable()) {
            delete delAttCsd;
        }
        init_mem();
    }

    public gctlMembers() {
        /*U = [select id, FirstName, lastName, accountid from User where id =: UserInfo.getUserId() limit 1];
        Acc = [select id, name, licexdt__c, lcsta__c from account where id=:U.accountid];
        Id reqId = apexpages.currentpage().getparameters().get('id');
        rq = [Select  Acc__r.lcedt__c, srvc__r.xoi__c, xfb__c, xchn__c, xcsnc__c, xfsr__c,
            xddatc__c, xadtx3__c, xbtnm__c, xppor__c, rtacn__c, xccn__c, x30gr__c, xccl__c, xeng__c,
            xcawp__c, xdedln__c, ias__c, xcn__c, xlt__c, xcddocs__c, xtpa__c, xla2l__c  , xdedc__c,
            xdccaRq__c, Print__c   , xdrv__c , xadtx4__c, Provisional_Issuance__c, xaed__c, xlicd__c,
            xcs__c, xanum__c, xpmsle__c, xppsfv__c, xcne__c, xcna__c, xlne__c, xlna__c, xalfe__c,
            xaccbrand__c,
              Acc__r.lcidt1arb__c, Acc__r.Legal_Framework__c, Acc__r.lcidt__c, Acc__r.lc__c, dsgu__c, epexpdt__c
              , Acc__r.lcedtarb__c, xmloc__c, xvn__c, xdei__c, xuvdet__c, xadtx1__c, xadtx2__c,
                  Id, Name, STA__c, AT__c, AP__c, AOP__c, xdtcls__c, dsc__c, dsc__r.prct__c, xfpc__c,
                  xnry__c, spCh__c, rmob__c, xawb__c, xaloc__c, xbrnd__c, xbn__c, nt__c, srvc__r.uid__c ,
                  srvc__r.pstg__c, srvc__r.kstp__c, xltr__c, xtcdl__c, InsChk__c, xadh__c, srvc__c,
                  srvc__r.name, srvc__r.lbl__c, srvc__r.dsc__c, srvc__r.Prk__c, srvc__r.AccTp__c, Acc__r.lcsta__c,
                  Con__c, ConRol__c , ConSTA__c, srvc__r.ckgsnc__c, srvc__r.snc__c, srvc__r.stg__r.pg__c,
                  srvc__r.stg__r.apx__c, Acc__r.lrd__c, Acc__r.onar__c, Acc__c, Acc__r.ORACLE_PARTY_ID__c,
                  Acc__r.Type, Acc__r.Prk__c, Acc__r.lcsnc__c, Acc__r.lcsncnt__c, Acc__r.psasnc__c,
                  Acc__r.psasncnt__c, Acc__r.ecsnc__c, Acc__r.ecsncnt__c, Acc__r.cosnc__c, Acc__r.cosncnt__c,
                  Acc__r.bgsnc__c, Acc__r.bgsncnt__c, Acc__r.snc__c, Acc__r.info__c, Acc__r.vestd__c,
                  Acc__r.vbtemp__c, Acc__r.speabsc__c, Acc__r.os__c, LastModifiedDate, LastModifiedById,
                  CreatedDate, CreatedById, xepAtt__c, xeidav__c, xcma__c, xcacctp__c, xcha__c, xcarea__c,
                  xcmbs__c, xcbd__c, xccty__c, xcbc__c, xcnc__c, xceidid__c, xceidedt__c, xceididt__c,
                  xceml__c, xcemrt__c, xcfan__c, xcfs__c, xcfn__c, xcfnar__c, xchph__c, xcln__c, xclnar__c,
                  xcms__c, xcmn__c, xcmnar__c, xcmob__c, xcmon__c, xcof__c, xcot__c, xcjb__c, xcmoa__c,
                  xcp__c, xcped__c, xcpid__c, xcpic__c, xcpip__c, xcbp__c, xcpobx__c, xcpobxarea__c,
                  xcnp__c, xcql__c, xcrlg__c, xcslt__c, xclng__c, xcstrt__c, xcmta__c, amsgs__c, action__c,
                  srvc__r.lsctg__c, os__c, (select id, Name, estE__c, actE__c, kstp__c, sla__c, acts__c,
                  itm__c, itm__r.exp__c, itm__r.itm__r.exp__c, itm__r.itm__r.Name, itm__r.itm__r.lbl__c,
                  f__c, f__r.Name, f__r.lbl__c, f__r.Tp__c, t__c , t__r.Name, t__r.lbl__c, t__r.Tp__c ,
                  CreatedBy.Name, CreatedById, vf__c, vt__c, Duration__c, to__c, xawb__c , Activity__c,
                  cd__c, Within_SLA__c  from Status_History__r   where isDeleted=false order by itm__r.itm__r.ord__c,
                  CreatedDate), (Select Id, Name, mxAts__c, mnAts__c, ats__c, nt__c, or__c, reqAts__c,
                  reqOr__c, tplt__c, upOk__c, mbr__c, mbr__r.Name From rDocs__r where Req__c=true and IsDeleted=false),
                  (Select Id, Name, STA__c, dt__c, A__c, md__c, TP__c , fwf__c From Transactions__r where isDeleted=false),
                  (select Name, Status__c, Summary__c, Request__c, More_Details__c, Type__c, createddate from Requests__r where isDeleted=false ORDER BY createddate DESC),
                  (select id, Name, RQ__c, nc__c, rv__c, m__c, m__r.Name, vSTA__c, AP__c, AOP__c, AD__c,
                  nt__c, xprnt__c, xr__c, xcnotes__c, xef__c , xips__c, Dsc__c, DscApp__c, KF__c, cN__c,
                  scN__c, smN__c, exp__c, cXP__c, scXP__c, smXP__c, itm__c, itm__r.xf__c, itm__r.cd__c,
                  itm__r.Name, itm__r.lbl__c, itm__r.Tp__c, itm__r.Req__c, itm__r.exp__c, itm__r.prcEdt__c,
                  itm__r.dSTA__c, sta__c, sta__r.cd__c, sta__r.Name, sta__r.lbl__c, sta__r.Tp__c, sta__r.rc__c,
                  sta__r.noEXP__c, LastModifiedDate, LastModifiedById, CreatedDate, CreatedById, sta__r.staown__c,
                  sta__r.Next_Status__c, sta__r.amsgs__c, sta__r.next_status__r.rqSTA__c, sta__r.next_status__r.Courier_Stage__c,
                  sta__r.Courier_Stage__c, sta__r.rqSTA__c, sta__r.imsgs__c, sta__r.action__c, sta__r.statype__c,
                  xcdocs__c, xdcdocs__c, xfld__c From Items__r where IsDeleted=false order by itm__r.ord__c) ,
                  (SELECT id, AWB_Number__c, Courier_Booking_Log__c, Courier_req__c, Duration__c, End_Date__c,
                  From_Courier_Status__c, Start_Date__c, To_Courier_Status__c, AWB_No__c, Activity__c,
                  Item_Name__c, CreatedBy.name  , tp__c FROM Courier_Histories__r), (Select Id, CaseNumber,
                  Origin, Type, Subject, Status, Category__c, Sub_Category__c, CreatedDate, ClosedDate from Cases__r Order By IsClosed,
                  CreatedDate Desc), (select id from Attachments order by createddate desc limit 1) From g_Req__c
              where id=:reqId ];
        accid = U.accountid;*/

        currentPg = 'pg1';
        shareValue = 1000;
        ttlShares = 0;
        imageBase64 = ''; AOADoc = '';
    }

    public PageReference saveOpen1() {
        system.debug('66 saveOpen1');
        system.debug('req adhoc::'+rq.xadtx4__c);
        if (Schema.sObjectType.g_req__c.isUpdateable()) {
            update rq;
        }
        system.debug('68 saveOpen1');
       componentOne = (gctlRequ) getCompCtrlMap().get('componentOne');
       componentOne.init(rq.id);
       return null;

    }

    public g_reqitem__c itm {get;set;}
    public PageReference submitDocstoPrm1() {
        itm = [select id, sta__c from g_reqitem__c where rq__r.id =: rq.id and name='License_Registration_Request'];
        g_srvcitm_Status__c sta = [select id from g_srvcitm_Status__c where name ='AOA RIC Submited'];
        itm.sta__c = sta.id;
        rq.os__C = 'AOA RIC Submited';
        update itm;
        if (Schema.sObjectType.g_req__c.isUpdateable()) {
            update rq;
        }

        // create WScall for DDA to fetch the payment details
        // grqWsDccaGetService.getNewReqDetails('REQ-00234411');

        //getNewReqDetails , Onboarding
        ws_call__c wc = new ws_call__c();
        wc.rq_jsn__c = '';// DDA req ID
        wc.rq_itm__c = itm.id;
        wc.pmid__c = rq.id;
        wc.ws_typ__c = 'Onboarding'; wc.mtd_nm__c = 'getNewReqDetails';
        wc.intsts__c = 'Ready for Integration';
        if (Schema.sObjectType.ws_call__c.isCreateable()) {
            insert wc;
        }

        return null;
    }

    public PageReference submitToPRM() {
        rq.STA__c='Under Review';
        system.debug('Before xadtx4__c::'+rq.xadtx4__c);
        system.debug('Before xadh__c::'+rq.xadh__c);
        String adhocNew = rq.xadh__c;
        List<acc_sharehd__c> shLst = new List<acc_sharehd__c>();
        List<g_reqitem__c> tI   = new List<g_reqitem__c>();

        if (String.isNotBlank(rq.xadtx4__c) && String.isNotBlank(rq.xadh__c)) {
            rq.xadtx4__c = (rq.xadtx4__c).replace('incDate', 'dob');
             Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(rq.xadtx4__c);
            if (jsonMap.containsKey('members')) {
                List<Object> memberJson = (List<Object>)jsonMap.get('members');
                for (Object obj : memberJson) {
                    Map<String, Object> memberMap = (Map<String, Object>) obj;
                    String phoneCode = (String) memberMap.get('phoneCode');
                    String mobile = (String) memberMap.get('mobile');

                    if (phoneCode != null && mobile != null) {
                        String mobileValue = phoneCode + '-' + mobile;
                        memberMap.put('mobile', mobileValue);
                    }
                }
                rq.xadtx4__c  = JSON.Serialize(jsonMap);
            }

            grqWsOnboard.Records recs = (grqWsOnboard.Records)JSON.deserialize(rq.xadtx4__c, grqWsOnboard.Records.class);
            if (recs != null && recs.members != null && !recs.members.isEmpty()) {
                for (grqWsOnboard.Member m : recs.members) {
                    if (m.ctg == 'Shareholder' && m.role.contains('General Manager')) {
                        m.ctg =  'General Manager';
                        adhocNew = adhocNew.replace(m.ctgCode1, 'gm');
                        m.ctgCode1 = 'gm';
                    }
                    /* else if (m.ctg == 'Shareholder' && m.role.contains('Legal Representative') && !m.role.contains('General Manager')) { m.ctg =  'Legal Representative'; if ( adhocNew.contains('sh1')) adhocNew = adhocNew.replace('sh1', 'lr'); else adhocNew = adhocNew.replace('sh2', 'lr');  }*//*else if (m.ctg == 'Shareholder' && m.role.contains('Board of Director') && !m.role.contains('Legal Representative') && !m.role.contains('General Manager')) m.ctg =  'Board of Director'; */
                }

                rq.xadh__c = adhocNew;
                integer i=1;

                for (grqWsOnboard.Member m : recs.members) {
                    acc_sharehd__c ash = new acc_sharehd__c();
                    ash.accsh__c = rq.Acc__c;
                    //ash.crole__c = m.role.substringAfter(', ');
                    List<String> rllst = m.role.split(', ');
                    Set<String> lst1 = new Set<String>(rllst);
                    String crole = '';
                    for (String str : lst1) {crole += str +', ';}

                    if (m.corpORind == 'corp' && crole != null && crole.contains('Ultimate Beneficiary')) {
                        crole = crole.replace('Ultimate Beneficiary', '');
                    }
                    crole = crole.removeEnd(', ');
                    system.debug('crole:'+crole);
                    ash.crole__c = crole;
                    ash.Postion__c = m.ctg;
                    if (m.corpORind == 'corp' || m.isParentComp=='true') {
                        ash.regno__c = m.passportNo;
                        ash.Shareholder_Type__c = 'Corporate Shareholder';
                        ash.cshType__c = m.cshType;
                        ash.iAuthority__c = m.iAuthority;
                        /*if (String.isNotBlank(m.fda) && m.fda == 'true')
                         ash.fda__c = true;
                        else
                          ash.fda__c = false;*/
                        ash.cmpwebsite__c = m.website;
                    }else if (m.role.contains('Shareholder') || m.corpORind == 'ind') {
                        ash.Shareholder_Type__c = 'Individual Shareholder';
                    }
                    //if (m.role.contains('Ultimate Beneficiary')) {
                    if (String.isNotBlank(m.uboType)) {
                        system.debug('Acting SH'+m.actingAsNomineeShareholder);
                        system.debug('Acting Dir'+m.actingAsNomineeDirector);
                        ash.UBO_Type__c = m.uboType;ash.nsh__c=m.actingAsNomineeShareholder;ash.nd__c=m.actingAsNomineeDirector;
                    }
                       if (String.isNotBlank(m.legals))
                        ash.ubolglrp__c = m.legals;
                        if (String.isNotBlank(m.uboRelatedTo))
                         ash.UBO_RelatedTo__c = m.uboRelatedTo;
                        system.debug('###############m.stockExchangeListed####################');
                        system.debug(m.uboException);
                        
                        /* any specfic reason */
                        ash.uboexptype__c = m.uboException;

                    //}
                    ash.fname__c = m.fname;
                    ash.mname__c = m.mname;
                    ash.lname__c = m.lname;
                    if (String.isNotBlank(m.fname))
                        ash.xcfnar__c = ApplicantDetailController.getArabicName(m.fname);
                    if (String.isNotBlank(m.lname))
                        ash.xclnar__c = ApplicantDetailController.getArabicName(m.lname);
                    ash.passno__c = m.passportNo;
                    ash.Email__c = m.email;
                    ash.nat__c = m.nationality;
                    if (m.gender == 'M') {
                        ash.Gender__c = 'Male';
                    }else if (m.gender == 'F') {
                        ash.Gender__c = 'Female';
                    }
                    //ash.Mobile__c = m.contryCode +''+m.mobile;
                    ash.Mobile__c = m.mobile; // 1.1
                    if (String.isNotBlank(m.sh) && m.sh != 'NaN') { ash.noshrs__c = double.valueOf(m.sh);}
                    ash.shName__c = m.fullName;
                    if (String.isNotBlank(m.pIssuedDate)) { ash.pIsDt__c =  strDate(m.pIssuedDate);}
                    if (String.isNotBlank(m.pExpDate)) {ash.pExDt__c = strDate(m.pExpDate);}
                    ash.eid__c = String.isNotBlank(m.eid)?m.eid:'';
                    if (String.isNotBlank(m.eidExp)) {ash.eidedt__c = strDate(m.eidExp);}
                    if (String.isNotBlank(m.inUAE) && m.inUAE == 'yes') {
                        ash.strt__c = m.Area;
                        ash.cty__c = m.emirate;
                    }
                    if (String.isNotBlank(m.address)) {
                        ash.mstrt__c = m.address;
                    }else{
                      ash.mstrt__c = m.street;
                      ash.mcty__c = m.city;
                      ash.mcnt__c =  m.country;
                    }
                    ash.dob__c = strDate(m.dob);
                    ash.ctgCode__c = m.ctgCode1;
                    ash.ppi__c = m.placeissued;
                    ash.pob__c = String.isNotBlank(m.placeborn) ? m.placeborn : 'tst';
                    ash.phn__c = m.phoneno;
                    ash.ord__c = i;
                    i=i+1;
                    shLst.add(ash);
                }
                if (shLst != null && shLst.size() == 1)
                 rq.spnm__c = true;
                rq.xadtx4__c = JSON.serialize(recs);
            }

            if (recs.shareDetails != null ) {
                grqWsOnboard.SharesInfo  sh =recs.shareDetails;
                if (sh.totalShares != null && sh.shareValue != null) {
                    Account acc = new Account(id=rq.Acc__c);
                    acc.noshrs__c = sh.totalShares;
                    acc.shareVal__c = sh.shareValue;
                    acc.sharecap__c = (sh.totalShares * sh.shareValue);
                    if (Schema.sObjectType.Account.isUpdateable()) {
                        update acc;
                    }
                }
            }
        }
       /* if (String.isNotBlank(rq.xadtx2__c)) {
            List<grqWsOnboard.SegmentInfo> lst = (List<grqWsOnboard.SegmentInfo>) json.deserialize(rq.xadtx2__c, List<grqWsOnboard.SegmentInfo>.class);
            set<string> acts = new Set<String>();
            for (grqWsOnboard.SegmentInfo seg : lst) {acts.add(seg.name);}

            for (g_srvcitm__c i : [select id, Req__c, dSTA__c, EXP__c, Name, vspexc__c, vst__c,
                vec__c, su__c, vsu__c, vesch__c, ngs__c, ngsXP__c, vsc__c, cd__c, srvc__c, Tp__c,
                rv__c, prcEdt__c, dcr__c, DscApp__c, KF__c, scN__c, vscp__c, cN__c, smN__c, slaN__c,
                vspc__c, spChN__c, spChXP__c, scXP__c, cXP__c, smXP__c, slaXP__c, dc__c, TAX_CODE__c,
                TAX_TYPE__c, extc__c, TAXCODE_SC__c, extcsc__c, (Select Id, cd__c,
                    uid__c From Statuses__r where isDeleted = false and actv__c=true AND cd__c='n' ) From g_srvcitm__c where isDeleted = false and actv__c = true and srvc__c=:rq.srvc__c AND name=:acts]) {
                tI.add(new g_reqitem__c(Name=i.Name, itm__c=i.id, RQ__c=rq.Id,
                                        m__c=null, rv__c=i.rv__c, vSTA__c='Verified',
                                        slaN__c=i.slaN__c, slaXP__c=i.slaXP__c, ngs__c=i.ngs__c, ngsXP__c=i.ngsXP__c, TAX_CODE__c=i.TAX_CODE__c,
                                            TAX_TYPE__c=i.TAX_TYPE__c, extc__c=i.extc__c, TAXCODE_SC__c=i.TAXCODE_SC__c, extcsc__c=i.extcsc__c,
                                        DscApp__c=i.DscApp__c, KF__c=i.KF__c, cN__c=i.cN__c, cXP__c=i.cXP__c, smN__c=i.smN__c,
                                            smXP__c=i.smXP__c, scN__c=rq.spCh__c?i.spChN__c+i.scN__c:i.scN__c, scXP__c=rq.spCh__c?i.spChXP__c+i.scXP__c:i.scXP__c,
                                            vsc__c=rq.spCh__c?i.vspc__c+i.vsc__c:i.vsc__c,    vesch__c=rq.spCh__c?i.vspexc__c+i.vesch__c:i.vesch__c,
                                            vst__c=i.vst__c, vec__c=i.vec__c, su__c=i.su__c, vsu__c=i.vsu__c, sta__c = i.Statuses__r[0].Id,
                                            itmtp__c=i.Tp__c, xdcr__c=i.dcr__c, xceml__c = rq.xceml__c, dc__c = i.dc__c));
            }
        }*/

        system.debug('After xadtx4__c::'+rq.xadtx4__c);
        system.debug('After xadh__c::'+rq.xadh__c);
        /* any specfic reason to be added again*/
        if (shLst != null && !shLst.isEmpty()) {insert shLst;}
        PageReference reference;
        rq.STA__c = 'Under Review';
        rq.os__c = 'Submit to PRM';
        if (Schema.sObjectType.g_req__c.isUpdateable()) {
            update rq;
        }

       /// if (tI != null && !tI.isEmpty()) {insert tI;}

         if (rq.STA__c == 'Under Review' && rq.os__c == 'Submit to PRM') /*MS 1.1*/ {
            updateItemSTA();
        }
        return reference;
    }

    public void updateItemSTA() {
        list<g_reqitem__c> Itms = new list<g_reqitem__c>();
        boolean isReqCompleted = false;
        List<g_reqitem__c> itmIds=[SELECT Id, RQ__c, sta__c, sta__r.Next_Status__c, sta__r.Next_Status__r.rqSTA__c,
            itm__c, itm__r.cd__c from g_reqitem__c where RQ__c =:rq.id and sta__r.isfn__c=true and isdeleted=false order by createdDate desc];
        System.debug('updateItemSTA - <itmIds> : ' + itmIds);

        if (!itmIds.isEmpty() && itmIds.size()>0) {
            for (g_reqitem__c i:itmIds ) {
                i.sta__c=i.sta__r.Next_Status__c;
                if ((i.sta__r.Next_Status__c != null && i.sta__r.Next_Status__r.rqSTA__c == 'Completed') || (i.itm__r.cd__c == 'ai' && i.sta__r.Next_Status__c != null) ) {
                    rq.STA__c = i.sta__r.Next_Status__r.rqSTA__c;
                    isReqCompleted = true;
                }

                Itms.add(i);
            }
        }

        if (!Itms.isEmpty() && Itms.size()>0) {
            if (Schema.sObjectType.g_reqitem__c.isUpdateable()) {
                update Itms;
            }
        }
    }

    public void submitToVerification() {
        String itmcd = '';
        if ( rq.os__c == 'Name Approval Re-Review') {itmcd = 'na';}

        List<g_reqitem__c> riLst = [select id, sta__c, itm__c from g_reqitem__c where RQ__c=:rq.id and itm__r.cd__c =:itmcd ];

        if (riLst != null && !riLst.isEmpty()) {
            String stsid = GDRFAUtil.statusId('v', riLst[0].itm__c);
            riLst[0].sta__c = stsid;
            if (Schema.sObjectType.g_reqitem__c.isUpdateable()) {
                update riLst;
            }
        }
        rq.os__c = 'Submit to PRM';
        if (Schema.sObjectType.g_req__c.isUpdateable()) {
            update rq;
        }

    }

   /*Update lease info -- added by Meenu MS 1.1 start*/
    public PageReference updateLeaseInfo() {
        if (Schema.sObjectType.g_req__c.isUpdateable()) {
            update rq;
        }
        return null;
    }

    public PageReference saveLandDoc() {
        String prvLandDoc = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('landDocToDel'));
        system.debug('rq.xcddocs__c===335='+rq.xcddocs__c);
        map<String, list<String>> mapDocDetails = new map<String, list<String>>();
        set<String> setItmToInsert = new set<String>();
        if (String.isNotBlank(rq.xcddocs__c)) {
            List<String> doclst = rq.xcddocs__c.split(';');
            for (String strDoc: doclst) {
                if (strDoc.contains(':')) {
                    setItmToInsert.add(strDoc.split(':')[1]);
                }
            }
            if (!setItmToInsert.IsEmpty()) {
                generateRqItem(setItmToInsert);
            }
        }
        if (String.isNotBlank(prvLandDoc) && rq.xcddocs__c != prvLandDoc) {
            deleteLandDoc(prvLandDoc);
        }
        List<g_Req__c> lstrq = [Select id, xcddocs__c, xadtx4__c from g_Req__c where Id =: rq.id FOR UPDATE];
        lstrq[0].xcddocs__c = rq.xcddocs__c;
        lstrq[0].xadtx4__c = rq.xadtx4__c;
        if (Schema.sObjectType.g_Req__c.isUpdateable()) {
            update lstrq;
        }
        return null;
    }

    public void deleteLandDoc(String landDocName) {
        if ( rq.xvtyp__c == 'DED' && rq.Acc__r.clt__c == 'Land' && rq.os__c == 'members' && String.isNotBlank(landDocName) && String.isNotBlank(rq.xcddocs__c)) {
            list<g_reqDoc__c> lstDocTodelete = new list<g_reqDoc__c>();
            list<String> lstSHDocNames = new list<String>();
            for (String dcnam: landDocName.split(';')) {
                if (dcnam.contains(':')) {
                    lstSHDocNames.add(dcnam.split(':')[0]);
                }
                else {
                    lstSHDocNames.add(dcnam);
                }
            }
            set<String> setSHDocNames = new set<String>();
            list<string> curDocName = rq.xcddocs__c.split(';');
            for (String dcnam: curDocName) {
                if (dcnam.contains(':')) {
                    setSHDocNames.add(dcnam.split(':')[0]);
                }
                else {
                    setSHDocNames.add(dcnam);
                }
            }
            set<String> setToremoveDoc = new set<String>();
            for (String objName : lstSHDocNames) {
                if (!setSHDocNames.contains(objName) && objName != '') {
                    system.debug('objName == 34='+objName);
                    setToremoveDoc.add(objName);
                }
            }
            list<String> lstlandDocToremove = new list<String> ();
            lstlandDocToremove.addAll(setToremoveDoc);
            system.debug('lstlandDocToremove==='+lstlandDocToremove);
            lstDocTodelete = [Select id, Name from g_reqDoc__c where RQ__c =: rq.id and isDeleted = false and Name IN: lstlandDocToremove and Name != 'Attested Power of Attorney'];
            for (g_reqDoc__c objDoc: lstDocTodelete ) {
                system.debug('objDoc=='+objDoc);
            }
            if (!lstDocTodelete.isEmpty()) {
                if (Schema.sObjectType.g_reqDoc__c.isDeletable()) {
                    delete lstDocTodelete;
                }
            }
        }
    }

   public void generateRqItem( Set<String> setReItm) {
       List<String> lstItCode = new list<String>();
       set<String> setItCode1 = new set<String>();
       list<g_reqitem__c> lstRqItem = new list<g_reqitem__c>();
       if ( rq.xvtyp__c == 'DED' && rq.Acc__r.clt__c == 'Land' && setReItm != null && !setReItm.isEmpty()) {
           lstItCode.addAll(setReItm);
           system.debug('lstItCode=='+lstItCode);
           for (g_reqitem__c objIt: [select id, itm__r.cd__c , name from g_reqitem__c where RQ__c =: rq.Id and itm__r.cd__c In: lstItCode] ) {
               setItCode1.add(objIt.itm__r.cd__c);
           }
           system.debug('setItCode1=='+setItCode1);
           for (String strItm: lstItCode) {
               if (!setItCode1.contains(strItm)) {
                   system.debug('strItm=='+strItm);
                   rq.xadh__c+= ';'+strItm;
               }
           }
           system.debug('rq.xadh__c=='+rq.xadh__c);
           if (!lstItCode.isEmpty()) update new g_Req__c(Id = rq.id, xadh__c = rq.xadh__c);
       }
   }
    /*Update lease info --  added by Meenu MS 1.1 end*/

    public Pagereference next() {return null;}

    public Pagereference back() {return null;}

    public  Date strDate(String dt) {
        List<string> lst = dt.split('/');
        return Date.newInstance(integer.valueOf(lst[2]) , integer.valueOf(lst[1]), integer.valueOf(lst[0]));
    }

    public class D{
        public string DocName {get;set;}
        public string DocLabel {get;set;}
        public string DocType {get;set;}
        public String attId {get;set;}
        public String attName {get;set;}
        public String tmpt {get;set;}
        public boolean isOptional {get;set;}
    }

    //UBO code
     public List <UBOSubmissionCtl_2.IndvInfo> indList {set;get;}

}
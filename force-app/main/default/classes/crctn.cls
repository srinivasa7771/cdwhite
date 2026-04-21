public class crctn{
    public String crctnMsg {get;set;}
    public g_Req__c rq {get;set;}
    public Account acc {get;set;}
    public g_Srvc__c srv {get;set;}
    public List<g_reqitemDoc__c> lstRqid {get;set;}
    public Set<Id> lstRqItmid {get;set;}
    public String usrComments {get;set;}
    integer uploadedDocs;
    public Boolean ispu{get;set;}
    public String pgNm{get;set;}

    public list<D> Docs{get;set;}
    public transient  String imageBase64 {get;set;}
    public String reqDocId {get;set;}
    public String docName {get;set;}
    public Integer ds{get;set;}

    public void setrq (g_Req__c v) {
        rq= v;
    }

    public g_Req__c getrq() {
        return rq;
    }

    //*** ------- Initialization --------------------------------------------------------------------------------
    public crctn() { ds=0; system.debug('Constructor of cc docs component' ); Docs = new list<D>(); lstRqItmid = new Set<Id>();
        ispu=gU.isPortalUser(UserInfo.getProfileId());usrComments=''; }

    // map<string, string> mapOfRIType = new map<string, string>();
    map<string, Id> mapOfRIType = new map<string, Id>();

    public void init() {try{ system.debug('init called: '+Docs.size());
                            LoadData();}catch (exception ex) {gU.AddErrorMsg(ex);system.debug('line: '+ex.getLineNumber());}}

    public void LoadData() {

        string[] type = new string[]{};
        Docs = new list<D>();
        map<Id, g_reqDoc__c> mD = new map<Id, g_reqDoc__c>();
        Set<id> riIdlst = new Set<id>();
        for (g_reqitem__c ri : rq.Items__r) {
           if (ri.xcdocs__c != null && ri.xcdocs__c != '') {
                for (string s : ri.xcdocs__c.split(';') ) {
                   if (!mapOfRIType.containsKey(s))
                        mapOfRIType.put(s, ri.Id );
                }
            }
            else if (ri.xdcdocs__c != null && ri.xdcdocs__c != '') {
                for (string s : ri.xdcdocs__c.split(';') ) {
                   if (!mapOfRIType.containsKey(s))
                        mapOfRIType.put(s, ri.Id );
                }
            }
          /*if (ri.sta__r.staown__c == 'Customer' && ri.sta__r.staown__c == 'Response')
           riIdlst.add(ri.id);*/
        }

        lstRqid = new List<g_reqitemDoc__c> ();
       // if (mapOfRIType != null && !mapOfRIType.isEmpty()) {
        // if ( !mapOfRIType.isEmpty()) {
           mD = new map<Id, g_reqDoc__c>([Select Id, (Select Id, Name, CreatedBy.ProfileId, CreatedById From Attachments
                                    where isDeleted = false),
                                    (Select Tp__c, id, upOk__c, reqDoc__c, reqItm__c,
                                      reqDoc__r.Name, reqDoc__r.Req__c, reqDoc__r.mbr__c, reqDoc__r.mxAts__c, reqDoc__r.mnAts__c,
                                          reqDoc__r.ats__c, reqDoc__r.nmReqAts__c, reqDoc__r.nmReq__c, reqDoc__r.nmReqOrs__c,
                                          reqDoc__r.nt__c, reqDoc__r.or__c, reqDoc__r.RQ__c, reqDoc__r.reqAts__c, reqDoc__r.reqOr__c,
                                          reqDoc__r.tplt__c, reqDoc__r.upOk__c,
                                      reqItm__r.Name, reqItm__r.xcdf__c, reqItm__r.xcdocs__c , reqItm__r.xcnotes__c, reqItm__r.nc__c,
                                          reqItm__r.STA__c, reqItm__r.STA__r.cd__c, reqItm__r.itm__r.dSTA__c, reqItm__r.itm__r.Name,
                                          reqItm__r.itm__r.lbl__c, lbl__C From Docs__r
                                       where ((reqItm__c in: mapOfRIType.values() and name  in : mapOfRIType.keySet()) or (Req__c=true and reqAts__c=true and upOk__c=false) or (id in: lstRqItmid)) and  isDeleted = false order by reqItm__r.Name)From g_reqDoc__c where RQ__c=:rq.id]);

        //}
        for (g_reqDoc__c rd : mD.values()) {
            if (rd.Docs__r != null && !rd.Docs__r.isEmpty())
              lstRqid.addAll(rd.Docs__r);
        }
        // lstRqid = Database.query(i_Soql);
        uploadedDocs = 0;
        D D1;

        if (lstRqid.size() > 0) {
            for (g_reqitemDoc__c  rid : lstRqid) {
                   // mD.put(rid.reqDoc__c, null);
                   lstRqItmid.add(rid.id);
                    D1 = new D(new g_reqDoc__c (Id= rid.reqDoc__c, Name = rid.reqDoc__r.Name,
                        ats__c = rid.reqDoc__r.ats__c, nt__c = rid.reqDoc__r.nt__c, or__c = rid.reqDoc__r.or__c,
                        mbr__c = rid.reqDoc__r.mbr__c)) ;
                    D1.mxAts = rid.reqDoc__r.mxAts__c;
                    D1.mnAts = rid.reqDoc__r.mnAts__c;
                    D1.nmReqAts = rid.reqDoc__r.nmReqAts__c;
                    D1.nmReq = rid.reqDoc__r.nmReq__c;
                    D1.nmReqOrs = rid.reqDoc__r.nmReqOrs__c;
                    D1.Req = rid.reqDoc__r.Req__c ;
                    D1.reqAts = rid.reqDoc__r.reqAts__c ;
                    D1.reqOr = rid.reqDoc__r.reqOr__c;
                    D1.tplt = rid.reqDoc__r.tplt__c ;
                    D1.upOk = rid.reqDoc__r.upOk__c;
                    D1.DocType = rid.Tp__c ;
                    D1.ReqName = rid.reqItm__r.Name;
                    system.debug('D1.ReqName : ' + D1.ReqName);
                    if (D1.upOk == true ) uploadedDocs += 1;
                    Docs.add(D1);

            }
        }

         if (Docs.size() > 0) {
            for (D doc: Docs) {
                g_reqDoc__c dc = mD.get(doc.Doc.Id);
                doc.addAttachments(dc.Attachments);
                set<String> rqItms = new set<String>();
                for (g_reqitemDoc__c i: dc.Docs__r) {
                    system.debug('1:');
                    rqItms.add(ispu?i.reqItm__r.itm__r.lbl__c:i.reqItm__r.itm__r.Name);
                    system.debug('2:');
                    doc.VF =rq.STA__c=='Draft'||rq.STA__c=='Open'?false:(!(i.reqItm__r.nc__c)||i.reqItm__r.itm__r.dSTA__c != i.reqItm__r.STA__r.cd__c);
                }
                system.debug('3');
                String sIs ='';
                Integer i=0;
                for (String itm: rqItms) {
                    sIs = (sIs==''?'':sIs+(i == rqItms.size()-1?' and ':', '))+itm;
                    i++;
                }
                system.debug('4:');
                /*doc.Info='Needed for '+sIs;
                */}
        }

        ds=  Docs.size();

    }

   //*** ------- DB Handlers --------------------------------------------------------------------------------
      public void saveAttachment() {
         // PageReference ref = null;
          system.debug('save method called: ' );
            String attName = '';
            try {
                attName = docName;
                attName = attName.replace('.jpg', ';');
                system.debug('docName: ' + docName);
                system.debug('reqDocId: ' + reqDocId);
                Attachment A = new Attachment(Body = EncodingUtil.base64Decode(imageBase64), Name = docName, ParentId = reqDocId);
                if (Schema.sObjectType.Attachment.isCreateable()) {
                    insert A;
                }
                if (gU.csStr('Photo').contains(attName)) {
                    if (rq.xphid__c == null || rq.xphid__c != A.Id) {
                        rq.xphid__c = A.Id;
                        if (Schema.sObjectType.g_req__c.isUpdateable()) {
                            update rq;
                        }
                    }

                    if (rq.Con__r != null) {
                        Contact c = rq.Con__r;
                        c.Photo_ID__c = A.Id;
                        update C;
                    }
                }
                system.debug('save Attachment Done: '+Docs.size());
                crctnMsg = '';
                init();

    } catch (Exception e) { gU.AddErrorMsg(Label.msgException); System.debug(LoggingLevel.ERROR, 'Exception: ' + e.getMessage() + ' ' + e.getStackTraceString()); }
      //return ref;
      }

    public void deleteAttachment() {try {system.debug('Del Atts: ' + reqDocId);Attachment A = new Attachment(Id = reqDocId);delete A; crctnMsg = ''; init();}catch (Exception e) {gU.AddErrorMsg(e);}}

    public pageReference submitCorrection() {
        PageReference ref = null;
        try{

            if (validateCorrection()) {
                crctnMsg = '';
                String reqStatus = '';
                g_reqitem__c ricr = null;
                for (g_reqitem__c ri : rq.Items__r) {
                    if (ri.sta__r.Next_Status__c != null && ri.sta__r.staown__c == 'Customer') {

                        ri.sta__c = ri.sta__r.next_status__c ;
                        ri.xcdocs__c = '';
                        if (rq.srvc__r.uid__c == '208')
                        ri.xdcdocs__c = '';
                        ri.xcnotes__c = '';
                        ri.xr__c = '';
                        reqStatus = ri.sta__r.next_status__r.rqSTA__c;
                      if (ri.sta__r.next_status__r.Courier_Stage__c =='Collection' || ri.sta__r.next_status__r.Courier_Stage__c =='Delivery') {
                          ricr = ri;
                          ricr.sta__r.Courier_Stage__c =  ri.sta__r.next_status__r.Courier_Stage__c;
                        }

                    }
                }
                if (reqStatus != '') {
                  if (ricr != null) {
                           XMLParserforEmpostWebservice  cour= new XMLParserforEmpostWebservice();
                           cour.courierBooking(ricr, rq, false, Label.msgCourCol);
                      }
                   if (Schema.sObjectType.g_req__c.isUpdateable()) {
                       update rq.Items__r;
                   }
                   rq.STA__c = reqStatus;
                   rq.amsgs__c = '';
                   rq.action__c = '';
                   if (Schema.sObjectType.g_req__c.isUpdateable()) {
                       update rq;
                   }

                }
                List<FeedItem> fdItmLst = new List<FeedItem>();
                FeedItem fd =null;
                if (usrComments != null && usrComments != '') {
                    fd = createFeedItem(usrComments);
                    fdItmLst.add(fd);
                }
                fd = createFeedItem(Label.msgCRFeed);
                fd.CreatedById=Label.msgCRAXSUsr;
                fdItmLst.add(fd);
                if (Schema.sObjectType.FeedItem.isCreateable()) {
                    insert fdItmLst;
                }
                ref = new PageReference('/' + String.escapeSingleQuotes(pgNm) + '?id='+rq.id+'&m=v&rc=rc');

            }
            else
            {
              // ref = new PageReference('/grqup?id='+rq.id+'&rc=y&c='+usrComments);
               crctnMsg  = Label.msgCrcDoc;
            }
        }catch (exception ex) {System.debug(LoggingLevel.ERROR, 'Exception: ' + ex.getMessage() + ' ' + ex.getStackTraceString()); crctnMsg = ex.getMessage();}
        return ref;
    }
    private FeedItem createFeedItem(String txt) {
         FeedItem fd = new FeedItem();
         fd.body =txt;
         fd.ParentId = rq.id;
         fd.Type = 'TextPost';
         fd.Visibility = 'AllUsers';
        return fd;
    }
    public pageReference submitPayment() {
        PageReference ref = null;
        try{

            rq.xcs__c = true;
            rq.xcn__c = usrComments;
            if (Schema.sObjectType.g_req__c.isUpdateable()) {
                update rq;
            }

           if (validateCorrection()) {
                ref = new PageReference('/apex/grqpy?id='+rq.id+'&rc=y&c='+usrComments);
            }
            else
            {
                ref = new PageReference('/grqup?id='+rq.id+'&rc=y&c='+usrComments); //+'&rc=y&c='+usrComments
            }
        }catch (exception ex) {System.debug(LoggingLevel.ERROR, 'Exception: ' + ex.getMessage() + ' ' + ex.getStackTraceString()); crctnMsg = ex.getMessage();}
        return ref;
    }

    boolean validateCorrection() {
       if (Docs.size () != uploadedDocs )
           return false;
        else return true;
    }

  public Map<string, string>  getSanctions() {
       Map<string, string> mSnc = new map<string, string>();

       if (acc != null && acc.snc__c != null && acc.snc__c != '' && srv != null && srv.snc__c != null && srv.snc__c != '') {
           for (Sanction_Detail__c sncDt: [select id, Name, Sanction_Notes__c from Sanction_Detail__c where Name in: acc.snc__c.split(';')]) {
               if (srv.snc__c.contains(sncDt.Name))
               mSnc.put(sncDt.Name, sncDt.Sanction_Notes__c);
            }
       }
       return mSnc;
    }

    //*** ------- Wrappers --------------------------------------------------------------------------------
    public class D{
        public g_reqDoc__c Doc{get;set;}public D(g_reqDoc__c dc) {Doc = dc;}
        public Boolean VF{get;set;}{VF=false;}
        // public Boolean cnUp{get{return Doc.reqAts__c && Ats.size() < Doc.mxAts__c;}}
        public Boolean cnUp{get{return reqAts && Ats.size() < mxAts ;}}
        public list<Attach> Ats{get;set;}{Ats = new list<Attach>();}
        public void addAttachments(list<Attachment> lA) {for (Attachment a:lA) {Ats.add(new Attach(a));}}
        public String Info{get;set;}
        public decimal mxAts {get;set;}
        public decimal mnAts {get;set;}
        public decimal nmReqAts {get;set;}
        public decimal nmReq {get;set;}
        public decimal nmReqOrs {get;set;}

        public boolean Req {get;set;}
        public boolean reqAts {get;set;}
        public boolean reqOr {get;set;}
        public boolean upOk {get;set;}

        public string tplt {get;set;}
        public string DocType {get;set;}
        public string ReqName {get;set;}
        // public string reqCmnts {get;set;}

    }

    public class Attach{
        public Attachment At{get;set;}
        public Boolean crtbyPU{get{return gU.isPortalUser(At.CreatedBy.ProfileId);}}
        public Attach(Attachment att) {At=att;}
    }
}
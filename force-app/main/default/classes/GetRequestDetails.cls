public with sharing class GetRequestDetails {
    public g_reqitem__c reqitem{set;get;}
    public List<g_reqitem__c> reqitemLst{get;set;}
    public List<prevandupdateDetails> wraplst{get;set;}
    public List<selectedRecDetails> selectedwraplst{get;set;}
    public List<selectedRecDetails> editedwraplst{get;set;}
    public List<noteWrapper> noteWrapperlst{get;set;}
    public Blob bodyvalue{get;set;}
    public String notevalue{get;set;}
    public String selectedRec{get; set;}
    public GetRequestDetails(ApexPages.StandardController controller) {
        this.reqitem = (g_reqitem__c)controller.getRecord();
         reqitemLst=new List<g_reqitem__c>();
          wraplst=new List<prevandupdateDetails>();
          selectedwraplst=new List<selectedRecDetails>();
          editedwraplst=new List<selectedRecDetails>();
          noteWrapperlst=new List<noteWrapper>();
    }

    public void searchDetails() {
        system.debug('inisde search button');
     system.debug('reqitem.RQ__c'+reqitem.RQ__c);
     reqitemLst =[SELECT Id, Account_Name__c, itm__r.Name, RQ__r.strsrvc__c, RQ__r.Applicant_Name__c, xcp__c, xcbd__c, cXP__c, cN__c,
     scXP__c, scN__c, AV__c FROM g_reqitem__c WHERE RQ__c=:reqitem.RQ__c]; // and gp__c<0 // need to ask the exact field name; // ask about the queue
     system.debug('reqitemLst'+reqitemLst);
     system.debug('reqitemLst size'+reqitemLst.size());
      List<prevandupdateDetails> wrapperlst = new List<prevandupdateDetails>();
     for (g_reqitem__c reqitem :reqitemLst) {

       prevandupdateDetails wrapitems = new prevandupdateDetails(reqitem.Id, reqitem.Account_Name__c, reqitem.itm__r.Name, reqitem.RQ__r.strsrvc__c, reqitem.RQ__r.Applicant_Name__c, reqitem.xcp__c,
                                        reqitem.xcbd__c, reqitem.cN__c, reqitem.scN__c, reqitem.cXP__c, reqitem.scXP__c, reqitem.cN__c, reqitem.scN__c, reqitem.cXP__c, reqitem.scXP__c, reqitem.AV__c);
            wrapperlst.add(wrapitems);

     }
     if (!wrapperlst.isEmpty()) {

        wraplst=wrapperlst;

     }
    }
    public PageReference getSelected() {
        System.debug('Entered account selection block');
        selectedRec = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('recid'));
        system.debug('selectedRec'+selectedRec);
        List<selectedRecDetails> wrapperlst = new List<selectedRecDetails>();
        if (selectedRec != null) {
            reqitemLst =[SELECT Id, RQ__r.strsrvc__c, Account_Name__c, itm__r.Name, RQ__r.Applicant_Name__c, xcp__c, xcbd__c, cXP__c, cN__c,
     scXP__c, scN__c, AV__c FROM g_reqitem__c WHERE Id=:selectedRec];
     for (g_reqitem__c reqitem :reqitemLst) {

       selectedRecDetails wrapitems = new selectedRecDetails(reqitem.Id, reqitem.Account_Name__c, reqitem.itm__r.Name, reqitem.RQ__r.strsrvc__c, reqitem.RQ__r.Applicant_Name__c, reqitem.xcp__c,
                                        reqitem.xcbd__c, reqitem.cN__c, reqitem.scN__c, reqitem.cXP__c, reqitem.scXP__c, reqitem.cN__c, reqitem.scN__c, reqitem.cXP__c, reqitem.scXP__c, reqitem.AV__c);
            wrapperlst.add(wrapitems);
     }
     if (!wrapperlst.isEmpty()) {

        selectedwraplst=wrapperlst;

     }
        }else{

     for (prevandupdateDetails reqitem :wraplst) {

       selectedRecDetails wrapitems = new selectedRecDetails(reqitem.reqitemId, reqitem.accountname, reqitem.itemname, reqitem.servicename, reqitem.applicantname, reqitem.passportnumber,
                                        reqitem.dateofbirth, reqitem.servicecostold, reqitem.servicechargeold, reqitem.eservicecostold,
                                            reqitem.eservicechargeold, reqitem.servicecostnew, reqitem.servicechargenew, reqitem.eservicecostnew,
                                            reqitem.eservicechargenew, reqitem.vattax);
            wrapperlst.add(wrapitems);
     }
      if (!wrapperlst.isEmpty()) {

        selectedwraplst=wrapperlst;

     }

        }

        return null;
    }

    public pageReference navigateConfirmDetails() {
        system.debug('selectedwraplst'+selectedwraplst);
        system.debug('wraplst'+wraplst);
         List<noteWrapper> nwrapperlst = new List<noteWrapper>();
          List<selectedRecDetails> wrapperlst = new List<selectedRecDetails>();
          List<selectedRecDetails> wrapperlsterror = new List<selectedRecDetails>();
        for (selectedRecDetails reqitem :selectedwraplst) {

            if (reqitem.servicecostnew<0 || reqitem.servicechargenew<0
            || reqitem.eservicecostnew<0 || reqitem.eservicechargenew<0) {

                 selectedRecDetails wrapitems = new selectedRecDetails(reqitem.reqitemId, reqitem.accountname, reqitem.itemname, reqitem.servicename, reqitem.applicantname, reqitem.passportnumber,
                                        reqitem.dateofbirth, reqitem.servicecostold, reqitem.servicechargeold, reqitem.eservicecostold,
                                            reqitem.eservicechargeold, reqitem.servicecostnew, reqitem.servicechargenew, reqitem.eservicecostnew,
                                            reqitem.eservicechargenew, reqitem.vattax);
                    wrapperlsterror.add(wrapitems);

            }
             else if (reqitem.servicecostold != reqitem.servicecostnew || reqitem.servicechargeold != reqitem.servicechargenew
            || reqitem.eservicecostold != reqitem.eservicecostnew || reqitem.eservicechargeold != reqitem.eservicechargenew) {

          selectedRecDetails wrapitems = new selectedRecDetails(reqitem.reqitemId, reqitem.accountname, reqitem.itemname, reqitem.servicename, reqitem.applicantname, reqitem.passportnumber,
                                        reqitem.dateofbirth, reqitem.servicecostold, reqitem.servicechargeold, reqitem.eservicecostold,
                                            reqitem.eservicechargeold, reqitem.servicecostnew, reqitem.servicechargenew, reqitem.eservicecostnew,
                                            reqitem.eservicechargenew, reqitem.vattax);
            wrapperlst.add(wrapitems);

        }

            }
         if (!wrapperlsterror.isEmpty() && wrapperlsterror.size()>0) {

            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Discounts cannot be negative'));

         }

      if (!wrapperlst.isEmpty()) {

        editedwraplst=wrapperlst;

        for (selectedRecDetails reqitem : editedwraplst) {

            noteWrapper wrapitems = new noteWrapper(reqitem.reqitemId, reqitem.accountname, reqitem.itemname, reqitem.servicename, reqitem.applicantname, reqitem.passportnumber,
                                        reqitem.dateofbirth, reqitem.servicecostold, reqitem.servicechargeold, reqitem.eservicecostold,
                                            reqitem.eservicechargeold, reqitem.servicecostnew, reqitem.servicechargenew, reqitem.eservicecostnew,
                                            reqitem.eservicechargenew, reqitem.vattax, notevalue, bodyvalue);
            nwrapperlst.add(wrapitems);

        }

      }else{

             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'update atleast one record'));
        }

         if (!nwrapperlst.isEmpty()) {

             noteWrapperlst = nwrapperlst;
           PageReference retURL = new PageReference('/apex/DiscountProcess_Details');
      return retURL;

     }

            return null;
    }

    public pageReference navigatePrev() {
        PageReference retURL = new PageReference('/apex/Discount_Process');
      retURL.setRedirect(false);
      return retURL;
    }

    public pageReference submitforapproval() {
        Savepoint sp;
        system.debug('inisde submit');
        system.debug('inside noteWrapperlst'+noteWrapperlst);
        List<Request_Discounti__c> rqlst = new List<Request_Discounti__c>();
            system.debug('editedwraplst'+editedwraplst);
            system.debug('bodyvalue'+bodyvalue);
            system.debug('notevalue'+notevalue);
            system.debug('noteWrapperlst'+noteWrapperlst);
             for (noteWrapper sr : noteWrapperlst) {
            if (String.isNotBlank(notevalue)) {
                Request_Discounti__c rd= new Request_Discounti__c();
            rd.Name=sr.servicename;
            rd.Applicant_Name__c=sr.applicantname;
            rd.Passport_Number__c=sr.passportnumber;
            rd.Date_of_Birth__c=sr.dateofbirth;
            rd.Notes__c=sr.notebody;
            rd.Status__c='Draft';
            rqlst.add(rd);

        }else{

           ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Notes are madatory'));
            return null;
        }
        }

        system.debug('rqlst'+rqlst);
        system.debug('rqlst size'+rqlst.size());
        List<Note> addnte = new List<Note>();
        List<Attachment> AttachmentLst  = new List<Attachment>();
         List<Request_Discount__c> rqlstitems = new List<Request_Discount__c>();
        if (!rqlst.isEmpty()) {
            insert rqlst[0];
            Note addedntes = new Note();
            Attachment myAttachment  = new Attachment();
            addedntes.ParentId = rqlst[0].id;
                addedntes.Body = notevalue;
                addedntes.Title = 'Discount Note';
                addnte.add(addedntes);
                if (String.isNotBlank(String.valueOf(bodyvalue))) {
                     myAttachment.Name = 'Discount Attachment';
                   myAttachment.ParentId = rqlst[0].id;
                   myAttachment.Body = bodyvalue;
                    AttachmentLst.add(myAttachment);
                }
            for (noteWrapper sr : noteWrapperlst) {

                 Request_Discount__c rd= new Request_Discount__c();
                system.debug('rqlst[0].id'+rqlst[0].id);
                rd.Name=sr.applicantname+'\'s'+'  '+'New Discount Request';
            rd.MRequest_Discount__c=rqlst[0].id;
            rd.g_reqitem__c=sr.reqitemId;
            rd.Service_Cost__c=sr.servicecostnew;
            rd.Service_Charge__c=sr.servicechargenew;
            rd.EService_Cost__c=sr.eservicecostnew;
            rd.EService_Charge__c=sr.eservicechargenew;
            rqlstitems.add(rd);

                }

        }
                system.debug('addnte'+addnte);
                system.debug('AttachmentLst'+AttachmentLst);
                system.debug('rqlstitems'+rqlstitems);
                try{
   sp = Database.setSavepoint();
    if (!addnte.isEmpty()) {
       if (Schema.sObjectType.Note.isCreateable()) {
           insert addnte;
       }
    }
     if (!AttachmentLst.isEmpty()) {
        if (Schema.sObjectType.Attachment.isCreateable()) {
            insert AttachmentLst;
        }
    }
     if (!rqlstitems.isEmpty()) {
       if (Schema.sObjectType.Request_Discount__c.isCreateable()) {
           insert rqlstitems;
       }
    }

       if (!rqlst.isEmpty()) {

         Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setComments('Submitting approval request on record request discount record insert');
        req.setObjectId(rqlst[0].id);
        Approval.ProcessResult result = Approval.process(req);

     }

  }catch (Exception e) {
    Database.RollBack(sp);
}

  if (!addnte.isEmpty()) {
      PageReference retURL = new PageReference('/'+rqlst[0].Id);
      return retURL;

  }

  return null;
            }

    Public class prevandupdateDetails{
      public string reqitemId{set;get;}
      public String accountname{set;get;}
      public string itemname{set;get;}
      public string servicename{set;get;}
      public string applicantname{set;get;}
      public string passportnumber{set;get;}
      public Date dateofbirth{set;get;}
      public decimal servicecostold{set;get;}
      public decimal servicechargeold{set;get;}
      public decimal eservicecostold{set;get;}
      public decimal eservicechargeold{set;get;}
      public decimal servicecostnew{set;get;}
      public decimal servicechargenew{set;get;}
      public decimal eservicecostnew{set;get;}
      public decimal eservicechargenew{set;get;}
      public Decimal vattax{set;get;}

      public prevandupdateDetails(string reqitemId, string accountname, string itemname,
          string servicename, string applicantname, string passportnumber, Date dateofbirth,
          decimal servicecostold, decimal servicechargeold, decimal eservicecostold, decimal eservicechargeold,
                                  decimal servicecostnew, decimal servicechargenew, decimal eservicecostnew, decimal eservicechargenew, decimal vattax) {
          this.reqitemId=reqitemId;
          this.accountname=accountname;
          this.itemname=itemname;
          this.servicename=servicename;
          this.applicantname=applicantname;
          this.passportnumber=passportnumber;
          this.dateofbirth=dateofbirth;
          this.servicecostold=servicecostold;
          this.servicechargeold=servicechargeold;
          this.eservicecostold=eservicecostold;
          this.eservicechargeold=eservicechargeold;
          this.servicecostnew=servicecostnew;
          this.servicechargenew=servicechargenew;
          this.eservicecostnew=eservicecostnew;
          this.eservicechargenew=eservicechargenew;
          this.vattax=vattax;
      }
    }
    Public class selectedRecDetails{
      public string reqitemId{set;get;}
      public String accountname{set;get;}
      public string itemname{set;get;}
      public string servicename{set;get;}
      public string applicantname{set;get;}
      public string passportnumber{set;get;}
      public Date dateofbirth{set;get;}
      public decimal servicecostold{set;get;}
      public decimal servicechargeold{set;get;}
      public decimal eservicecostold{set;get;}
      public decimal eservicechargeold{set;get;}
      public decimal servicecostnew{set;get;}
      public decimal servicechargenew{set;get;}
      public decimal eservicecostnew{set;get;}
      public decimal eservicechargenew{set;get;}
      public Decimal vattax{set;get;}

      public selectedRecDetails(string reqitemId, string accountname, string itemname, string servicename,
          string applicantname, string passportnumber, Date dateofbirth, decimal servicecostold,
          decimal servicechargeold, decimal eservicecostold, decimal eservicechargeold,
                                  decimal servicecostnew, decimal servicechargenew, decimal eservicecostnew, decimal eservicechargenew, decimal vattax) {
          this.reqitemId=reqitemId;
          this.accountname=accountname;
          this.itemname=itemname;
          this.servicename=servicename;
          this.applicantname=applicantname;
          this.passportnumber=passportnumber;
          this.dateofbirth=dateofbirth;
          this.servicecostold=servicecostold;
          this.servicechargeold=servicechargeold;
          this.eservicecostold=eservicecostold;
          this.eservicechargeold=eservicechargeold;
          this.servicecostnew=servicecostnew;
          this.servicechargenew=servicechargenew;
          this.eservicecostnew=eservicecostnew;
          this.eservicechargenew=eservicechargenew;
          this.vattax=vattax;

      }
    }

    Public class noteWrapper{
      public string reqitemId{set;get;}
      public String accountname{set;get;}
      public string itemname{set;get;}
      public string servicename{set;get;}
      public string applicantname{set;get;}
      public string passportnumber{set;get;}
      public Date dateofbirth{set;get;}
      public decimal servicecostold{set;get;}
      public decimal servicechargeold{set;get;}
      public decimal eservicecostold{set;get;}
      public decimal eservicechargeold{set;get;}
      public decimal servicecostnew{set;get;}
      public decimal servicechargenew{set;get;}
      public decimal eservicecostnew{set;get;}
      public decimal eservicechargenew{set;get;}
      public Decimal vattax{set;get;}
      public String notebody{set;get;}
      public Blob attachbody{set;get;}

      public noteWrapper(string reqitemId, string accountname, string itemname, string servicename,
          string applicantname, string passportnumber, Date dateofbirth, decimal servicecostold,
          decimal servicechargeold, decimal eservicecostold, decimal eservicechargeold,
                                  decimal servicecostnew, decimal servicechargenew, decimal eservicecostnew, decimal eservicechargenew, decimal vattax, String notebody, Blob attachbody) {
          this.reqitemId=reqitemId;
          this.accountname=accountname;
          this.itemname=itemname;
          this.servicename=servicename;
          this.applicantname=applicantname;
          this.passportnumber=passportnumber;
          this.dateofbirth=dateofbirth;
          this.servicecostold=servicecostold;
          this.servicechargeold=servicechargeold;
          this.eservicecostold=eservicecostold;
          this.eservicechargeold=eservicechargeold;
          this.servicecostnew=servicecostnew;
          this.servicechargenew=servicechargenew;
          this.eservicecostnew=eservicecostnew;
          this.eservicechargenew=eservicechargenew;
          this.vattax=vattax;
          this.notebody=notebody;
          this.attachbody=attachbody;

      }
    }
}
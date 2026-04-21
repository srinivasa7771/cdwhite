public without sharing class gctlReqpy {
     
    public String encid{get;set;} public String empid{get;set;}
    public String sid{get;set;} public String pid{get;set;}
    public Boolean isgu{get;set;}
    public String pmntItems{get;set;}
    public Set<String> ctgLst {get;set;}public boolean ctgFlg {get;set;}public string selCtg {set;get;}
    public String paymentLink {get;set;}
    public User U{get;set;}
    public g_Req__c rq{get;set;} private String m_SOQL; public Set<Id> riIds;
    public String pt{get;set;}public String pDsc{get;set;}public Boolean pgHide{get;set;}
    public Boolean ispu{get;set;} public string lcl{get{return UserInfo.getLocale();}}
    public g_Tran__c T{get;set;}public list<itm> Is{get;set;}private transient decimal AOP=0;
    public List<Selectoption> pyMthds {get;set;}    public String pyMthd{get;set;}
    public Boolean payDone{get;set;} public String pdfConfirm{get;set;}
    public Boolean noAcc{get;set;} public Decimal vat{get;set;}
    public String cp {get;set;}
    public String amtWrds{get;set;}
    public Boolean stopRenewal{get;set;}/*U_S APD-3335*/
    //*** ------- Initialization --------------------------------------------------------------------------------
    public gctlReqpy(ApexPages.StandardController c){
        system.debug('gctlReqpy::::');
		stopRenewal=false;/*U_S APD-3335*/
        // rq=(g_Req__c)c.getRecord();
        if(ApexPages.currentPage().getParameters().get('id')!=null){   
            rq=[select id,xvtyp__c, xcamc__c, srvc__r.stg__r.payq__c, xppsfv__c, os__c, Acc__r.clt__c from g_Req__c where id=:ApexPages.currentPage().getParameters().get('id')];     
        }                                                     
        U = [select Id, contact.account.lc__c,FirstName,LastName,accountid, contact.account.id, contact.account.os__c, contact.account.Prk__c,
             contact.account.name,contact.account.lcsta__c,contact.account.lcrndt__c 
             from User where id =: UserInfo.getUserId() limit 1 ];
        	pgHide=false;ispu=gU.isPortalUser(UserInfo.getProfileId());init(); /*U_S APD-3335 start*/
                    if (rq.srvc__r.uid__c =='208') {
                        String jsonStr = '{ "licenseNos": [ "' + u.contact.account.lc__c + '" ] }';
                        String responseBody = DDAServices.getDDAServices(Label.LA_DDA_End_Point, 'licenseAmendment/getLicenseInfo', 'POST', jsonStr);
                        DDAMembersWrapper ref1 = (DDAMembersWrapper) System.JSON.deserialize(responseBody, DDAMembersWrapper.class);
                        if (string.isNotBlank(ref1.LicenseInfos[0].ActivityAmendmentRequestAXSRefNo)) {
                            stopRenewal = true;
                        }
                      system.debug('----stopRenewal----'+stopRenewal);
                    } /*U_S APD-3335 End */
 }
    		private void init(){noAcc=false;try{laodData();if(!isgu && rq.srvc__r.uid__c!='322')Validate();}catch(exception ex){gU.AddErrorMsg(ex);}}
    		private void laodData(){
        	sid =  ApexPages.currentPage().getParameters().get('sid');
        	Is=new list<itm>();pyMthds = new List<Selectoption>();AOP=0;ctgLst=new Set<String>();
        	isgu = gu.isGuestUser(userInfo.getProfileId());
        	cp =  ApexPages.currentPage().getParameters().get('cp');
        	system.debug('qry::'+rq.srvc__r.stg__r.payq__c);
        	if(m_SOQL==null){
            if(isgu){
                g_Req__c rqt = [Select id,name,srvc__r.stg__r.payq__c, Acc__r.clt__c  From g_Req__c where id=:rq.id];
                m_SOQL=rqt.srvc__r.stg__r.payq__c;
            } 
            else
                m_SOQL=rq.srvc__r.stg__r.payq__c;
            
        }
        rq=(g_Req__c)Database.query(m_SOQL+' where id=\''+rq.Id+'\' and isDeleted = false');
        T = new g_Tran__c(Acc__c=rq.Acc__c,RQ__c=rq.Id,TP__c='Payment',xcrce__c = rq.xceml__c);
        if (rq.srvc__r.uid__c == '322' || rq.srvc__r.uid__c == '216') {t.PRO_Email_Id__c = rq.PRM_Email__c; }        
        /*MS 1.1*//*if(rq.Items__r!=null){*/for(g_reqitem__c i:rq.Items__r){if(i.AD__c>0 && (pmntItems==null || pmntItems=='') ){Is.add(new itm(i)); if(String.isNotBlank(i.itm__r.gctg__c))ctgLst.add(i.itm__r.gctg__c);}
                                                              else if(i.AD__c>0 && (pmntItems!=null && pmntItems.contains(i.id))){Is.add(new itm(i));}
                                                              AOP+=i.AOP__c;}
                              if(ctgLst != null && ctgLst.size() >1) ctgFlg=true;
                            /*}*/
        
        if(cp == 'Y'){gu.addInfoMsg('Cash payment has been cancelled, please proceed to pay the amount using an alternative method.');}
        if(AOP>0){gu.addInfoMsg('There are open (incomplete) payments of total AED ' + AOP.format());}
        pyMthds.add(new SelectOption('','--None--'));if(rq.srvc__r.payMd__c != null){for(String p: rq.srvc__r.payMd__c.split('\\;')){pyMthds.add(new SelectOption(p,p));}}
        rq.xcmbs__c = rq.xcmbs__c.round(RoundingMode.HALF_UP); 
        amtWrds = gU.AmountInWords(rq.xcmbs__c.intValue() + 411); /*MS 1.1*/
    }
    @testvisible private void Validate(){if(!hasAccess()){pgHide=true;}gU.checkNav();}
    public void chkPmntItems(){
        system.debug('pmntItems---- *'+pmntItems);
    }
    
    @testvisible private Boolean hasAccess(){
        Boolean blOk=gU.canReqSrvc(rq.srvc__c,true,'grqpy');if(!blOk){gU.addInfoMsg(Label.msgNoPrivilege);noAcc=true;}
        if(rq.STA__c!='Open'&&rq.STA__c!='Under Review'&&rq.STA__c!='In Process'){
            blOk=false;}
        /* if(Is.size()<=0 || rq.AT__c <=0){gU.addInfoMsg(Label.msgNoAmount);blOk=false;}*/
        list < g_reqitem__c > lstReqItm;
        for (g_reqitem__c objRitm: rq.Items__r) {
            if (lstReqItm == null)
                lstReqItm = new list < g_reqitem__c > ();
            lstReqItm.add(objRitm);
        }
        if (lstReqItm == null) {gU.addInfoMsg('Missing required items');blOk = false;} 
        else if (lstReqItm.size() < 0) {gU.addInfoMsg(Label.msgNoItems);blOk = false;}
        
        
        if(nD && rq.xdrv__c == false){gU.addInfoMsg(Label.msgNoDocuments); blOk= false;}
        if(!nD && rq.srvc__r.uid__c=='208' && (rq.xpmsle__c == true && !rq.xcawp__c)){gU.addInfoMsg(Label.msgDDAVerification); blOk= false;} 
        if(!nD && rq.srvc__r.uid__c=='208' && !rq.xcawp__c && !rq.tsrv__c && (rq.xmloc__c == true || rq.xtpa__c==0)){gU.addInfoMsg(Label.msgDDAVerification); blOk= false;}
        
        if(pyMthds.size()<=1){gU.AddErrorMsg('Settings Error: Canot identify supported payment types');blOk=false;}
        return blOk;
    }
    public Boolean nD { get { /*MS 1.1 start*/ list < g_reqDoc__c > lstReqDoc = new List < g_reqDoc__c > (); for (g_reqDoc__c objDoc: rq.rDocs__r) { lstReqDoc.add(objDoc); } if (lstReqDoc.isEmpty()) { return false; } /*MS 1.1 end */ /*if(rq.rDocs__r==null){return false;}*/ for (g_reqDoc__c d: [Select Id, upOk__c,(select id from Attachments) From g_reqDoc__c where RQ__c =: rq.Id and Req__c = true and IsDeleted = false]) { if (d.Attachments.size()==0) { return true; } } return false; } }/*US APD3911*/
    //*** ------- DB Handlers --------------------------------------------------------------------------------
    @testvisible private Boolean crtPay(String STA, String mthd, String ref) {
        Savepoint sp = null;
        try {
            system.debug('pmntItems::---- *' + pmntItems);
            Integer cnt = 0;
            Decimal Amt2Pay = 0;
            for (itm i: Is) {
                if (i.s) {
                    cnt++;
                    Amt2Pay += i.I.AD__c;
                }
            }
            if (cnt == 0) {
                gU.AddWarningMsg(Label.msgNoItemSlct);
                return false;
            }
            if (mthd == 'Credit / Debit Card')
                T.gwrf__c = ref;
            T.STA__c = STA;
            T.md__c = mthd;
            T.dt__c = Date.today(); //T.xcrce__c = rq.xceml__c;
            sp = Database.setSavepoint();
            
            if (mthd == 'Customer Deposit') {
                Account A = [select Id, adb__c, vato__c, va__c from Account where id =: T.Acc__c FOR UPDATE];
                if (A.adb__c < Amt2Pay) {
                    gU.AddWarningMsg(Label.msgNoADBlnc); pyMthd = '';laodData(); return false;
                }
            }
            list < g_TranItem__c > TIs = new list < g_TranItem__c > ();
            riIds = new Set < Id > ();
            upsert T;
            
            String memail, mob;
            if (String.isNotBlank(rq.rmob__c)) mob = rq.rmob__c;
            else if (String.isNotBlank(rq.xcmob__c)) mob = rq.xcmob__c;
            if (String.isNotBlank(mob)) {
                mob = mob.replaceAll('\\D', '').replaceFirst('971', '').replaceFirst('0', '');
                memail = '971' + mob + '@email.smsglobal.com';
            }
            
			/* if(rq.rmob__c!=null){ memail='971'+rq.rmob__c+'@email.smsglobal.com';} if(rq.xcmob__c!=null){ memail='971'+rq.xcmob__c+'@email.smsglobal.com'; }*/ /*  for (itm i: Is) { if (i.s && (String.isNotBlank(selCtg) && selCtg.contains(i.I.itm__r.gctg__c)) && (String.isBlank(pmntItems) || (String.isNotBlank(pmntItems) && pmntItems.contains(i.I.id) ))) { if ((i.I.vsc__c != 0 || i.I.vst__c != 0) || (i.I.exp__c && (i.I.vesch__c != 0 || i.I.vec__c != 0))) { Decimal govtFee = i.I.KF__c + i.I.smN__c + (i.I.exp__c ? i.I.smXP__c : 0); Decimal govtVATFee = 0; Decimal nonGovtFee = 0; Decimal vatAmt = 0; Decimal vatAmtGvt = 0; String taxCode = i.I.TAX_CODE__c; String taxCodeGov = i.I.TAXCODE_SC__c; if (i.I.vst__c != 0) { vatAmtGvt = i.I.vst__c; govtVATFee = i.I.cN__c; } else govtFee = govtFee + i.I.cN__c; if (i.I.vsc__c != 0) nonGovtFee = i.I.scN__c; else govtFee = govtFee + i.I.scN__c; if (mthd == 'Cash' && i.I.su__c != null && i.I.su__c > 0) nonGovtFee = nonGovtFee + (i.I.su__c != null ? i.I.su__c : 0) + (i.I.vsu__c != null ? i.I.vsu__c : 0); if (i.I.exp__c && i.I.vesch__c != 0) { taxCode = i.I.extc__c; nonGovtFee = nonGovtFee + i.I.scXP__c; } else if (i.I.exp__c && i.I.vesch__c == 0) { govtFee = govtFee + i.I.scXP__c; taxCodeGov = i.I.extcsc__c; } if (i.I.exp__c && i.I.vec__c != 0) { govtVATFee = govtVATFee + i.I.cXP__c; vatAmtGvt = vatAmtGvt + i.I.vec__c; } else if (i.I.exp__c && i.I.vec__c == 0) { govtFee = govtFee + i.I.cXP__c; } govtFee = govtFee - i.I.tgop__c; govtVATFee = govtVATFee - (i.I.tgovp__c - i.I.tvatp__c); nonGovtFee = nonGovtFee - (i.I.tngop__c - i.I.tvngp__c); vatAmt = i.I.AV__c - vatAmtGvt + i.I.tvatp__c; vatAmtGvt = vatAmtGvt - i.I.tvatp__c; if (govtFee > 0) { TIs.add(new g_TranItem__c(itm__c = i.I.Id, T__c = T.Id, A__c = govtFee, VAT__c = 0, exp__c = i.I.exp__c, STA__c = T.STA__c, Tp__c = T.Tp__c, TAX_CODE__c = gu.csStr('TAXCodeEXEMPTED'))); } if (govtVATFee > 0) { TIs.add(new g_TranItem__c(itm__c = i.I.Id, T__c = T.Id, A__c = govtVATFee + vatAmtGvt, VAT__c = vatAmtGvt, exp__c = i.I.exp__c, STA__c = T.STA__c, Tp__c = T.Tp__c, TAX_CODE__c = ((taxCodeGov != null && taxCodeGov == 'EXEMPTED') ? gu.csStr('TAXCodeEXEMPTED') : taxCodeGov) )); } if (nonGovtFee > 0) { TIs.add(new g_TranItem__c(itm__c = i.I.Id, T__c = T.Id, A__c = nonGovtFee + vatAmt, VAT__c = vatAmt, ngs__c = true, exp__c = i.I.exp__c, STA__c = T.STA__c, Tp__c = T.Tp__c, TAX_CODE__c = ((taxCode != null && taxCode == 'EXEMPTED') ? gu.csStr('TAXCodeEXEMPTED') : taxCode) )); } } else { TIs.add(new g_TranItem__c(itm__c = i.I.Id, T__c = T.Id, A__c = i.I.AD__c, VAT__c = 0, exp__c = i.I.exp__c, STA__c = T.STA__c, Tp__c = T.Tp__c, TAX_CODE__c = gu.csStr('TAXCodeEXEMPTED'))); if (mthd == 'Cash' && i.I.su__c != null && i.I.su__c > 0) TIs.add(new g_TranItem__c(itm__c = i.I.Id, T__c = T.Id, A__c = (i.I.su__c != null ? i.I.su__c : 0) + (i.I.vsu__c != null ? i.I.vsu__c : 0), VAT__c = (i.I.vsu__c != null ? i.I.vsu__c : 0), ngs__c = true, exp__c = i.I.exp__c, STA__c = T.STA__c, Tp__c = T.Tp__c, TAX_CODE__c = i.I.TAX_CODE__c)); } riIds.add(i.I.Id); } }*/
            
            for (itm i: Is) {
               if (i.s && (String.isNotBlank(selCtg) && selCtg.contains(i.I.itm__r.gctg__c)) && (String.isBlank(pmntItems) || (String.isNotBlank(pmntItems) && pmntItems.contains(i.I.id)))) {
                    system.debug('test:::');
                    if ((i.I.vsc__c != 0 || i.I.vst__c != 0) || (i.I.exp__c && (i.I.vesch__c != 0 || i.I.vec__c != 0))) { Decimal govtFee = i.I.KF__c + i.I.smN__c + (i.I.exp__c ? i.I.smXP__c : 0); Decimal govtVATFee = 0; Decimal nonGovtFee = 0; Decimal vatAmt = 0; Decimal vatAmtGvt = 0; String taxCode = i.I.TAX_CODE__c; String taxCodeGov = i.I.TAXCODE_SC__c; if (i.I.vst__c != 0) { vatAmtGvt = i.I.vst__c; govtVATFee = i.I.cN__c; } else govtFee = govtFee + i.I.cN__c; if (i.I.vsc__c != 0) nonGovtFee = i.I.scN__c; else govtFee = govtFee + i.I.scN__c; if (mthd == 'Cash' && i.I.su__c != null && i.I.su__c > 0) nonGovtFee = nonGovtFee + (i.I.su__c != null ? i.I.su__c : 0) + (i.I.vsu__c != null ? i.I.vsu__c : 0); if (i.I.exp__c && i.I.vesch__c != 0) { taxCode = i.I.extc__c; nonGovtFee = nonGovtFee + i.I.scXP__c; } else if (i.I.exp__c && i.I.vesch__c == 0) { govtFee = govtFee + i.I.scXP__c; taxCodeGov = i.I.extcsc__c; } if (i.I.exp__c && i.I.vec__c != 0) { govtVATFee = govtVATFee + i.I.cXP__c; vatAmtGvt = vatAmtGvt + i.I.vec__c; } else if (i.I.exp__c && i.I.vec__c == 0) { govtFee = govtFee + i.I.cXP__c; } govtFee = govtFee - i.I.tgop__c; govtVATFee = govtVATFee - (i.I.tgovp__c - i.I.tvatp__c); nonGovtFee = nonGovtFee - (i.I.tngop__c - i.I.tvngp__c); vatAmt = i.I.AV__c - vatAmtGvt + i.I.tvatp__c; vatAmtGvt = vatAmtGvt - i.I.tvatp__c; system.debug('govtFee:::' + govtFee); if (govtFee > 0) { TIs.add(new g_TranItem__c(Client_Email__c = rq.xceml__c, itm__c = i.I.Id, xccliapp__c = memail, T__c = T.Id, A__c = govtFee, VAT__c = 0, exp__c = i.I.exp__c, STA__c = T.STA__c, Tp__c = T.Tp__c, TAX_CODE__c = gu.csStr('TAXCodeEXEMPTED'))); } if (govtVATFee > 0) { TIs.add(new g_TranItem__c(Client_Email__c = rq.xceml__c, itm__c = i.I.Id, xccliapp__c = memail, T__c = T.Id, A__c = govtVATFee + vatAmtGvt, VAT__c = vatAmtGvt, exp__c = i.I.exp__c, STA__c = T.STA__c, Tp__c = T.Tp__c, TAX_CODE__c = ((taxCodeGov != null && taxCodeGov == 'EXEMPTED') ? gu.csStr('TAXCodeEXEMPTED') : taxCodeGov))); } if (nonGovtFee > 0) { TIs.add(new g_TranItem__c(Client_Email__c = rq.xceml__c, itm__c = i.I.Id, xccliapp__c = memail, T__c = T.Id, A__c = nonGovtFee + vatAmt, VAT__c = vatAmt, ngs__c = true, exp__c = i.I.exp__c, STA__c = T.STA__c, Tp__c = T.Tp__c, TAX_CODE__c = ((taxCode != null && taxCode == 'EXEMPTED') ? gu.csStr('TAXCodeEXEMPTED') : taxCode))); } }
                     else {
                        TIs.add(new g_TranItem__c(Client_Email__c = rq.xceml__c, itm__c = i.I.Id, xccliapp__c = memail, T__c = T.Id, A__c = i.I.AD__c, VAT__c = 0, exp__c = i.I.exp__c, STA__c = T.STA__c, Tp__c = T.Tp__c, TAX_CODE__c = gu.csStr('TAXCodeEXEMPTED')));
                        if (mthd == 'Cash' && i.I.su__c != null && i.I.su__c > 0) TIs.add(new g_TranItem__c(itm__c = i.I.Id, xccliapp__c = memail, T__c = T.Id, A__c = (i.I.su__c != null ? i.I.su__c : 0) + (i.I.vsu__c != null ? i.I.vsu__c : 0), VAT__c = (i.I.vsu__c != null ? i.I.vsu__c : 0), ngs__c = true, exp__c = i.I.exp__c, STA__c = T.STA__c, Tp__c = T.Tp__c, TAX_CODE__c = i.I.TAX_CODE__c));
                    }
                    riIds.add(i.I.Id);
                }
            }
            
            if (TIs.size() > 0) {
                insert TIs;
            }
            T = [Select TP__c, RQ__r.name, VAT__c, dt__c, A__c, STA__c, nt__c, md__c, gwdt__c, gwmsg__c, gwrf__c, gwcd__c, Acc__r.adx__c, Acc__r.va__c, Acc__r.vato__c, Acc__r.bg__c, Acc__r.Name, Acc__r.BillingStreet, Acc__r.BillingPostalCode, Acc__r.lc__c, Name, Id, RQ__c, cq__c, cdt__c, ci__c, Bnk__c, Acc__c From g_Tran__c g where id =: T.Id];
            system.debug('rq.STA__c::' + rq.STA__c);
            system.debug('STA::' + STA);
            if ((rq.STA__c == 'Draft' || rq.STA__c == 'Open' || rq.STA__c == 'In Process') && STA == 'Completed') {
                system.debug('update underreview::');
                /* start update by Meenu MS 1.1*/
                rq.os__c = (rq.Acc__r.clt__c == 'Land' && rq.os__c == 'Application Payment' && rq.xvtyp__c == 'DED') ? 'Submit To PRM' : rq.os__c;
                 system.debug('update underreview:3:'+ rq.os__c );
                if (rq.Acc__r.clt__c == 'Land' && rq.xvtyp__c == 'DED' && rq.os__c == 'Submit To PRM') {
                    updateItemSTA(rq.Id);
                }
                /* end update by Meenu MS 1.1*/
                if(rq.srvc__r.uid__c == '156' && rq.xadh__c != 'vip;'){ //PJ
                    Integer paidCount = 0; Integer unpaidCount = 0; Boolean allPaid = true; Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(rq.xadtx4__c); String newCardList = (String) jsonMap.get('Cardlist'); Set<String> paidCards = new Set<String>(); if (!String.isBlank(newCardList)) { for (String c : newCardList.split(';')) { if (!String.isBlank(c)) paidCards.add(c.trim()); } } if(String.isNotBlank(rq.xuvdet__c) && rq.xrpid__c != null){ Map<String, Object> jsonMapCards = (Map<String, Object>) JSON.deserializeUntyped(rq.xuvdet__c); List<Object> cardsList = (List<Object>) jsonMapCards.get('cardslist');  for (Object obj : cardsList) { Map<String, Object> card = (Map<String, Object>) obj; card.put('isSelected', true); String cardNumber = (String) card.get('CardNumber'); if (paidCards.contains(cardNumber)) { card.put('isPaid', true); card.put('CardExpireDate', rq.xrpid__c); } if ((Boolean) card.get('isPaid') == true) paidCount++; else{ unpaidCount++; allPaid = false; } } rq.xispd__c = allPaid; rq.STA__c= allPaid ? 'Completed' : rq.STA__c ; jsonMapCards.put('cardslist', cardsList);  rq.xuvdet__c = JSON.serialize(jsonMapCards); } if(rq.xcawp__c == false){ /* Updating this to identify first payment is paid and next item to be created. */ rq.xcawp__c = true; } if(rq.xcmta__c > 0 && rq.xss__c > 0){ rq.xcmoa__c = rq.xtpa__c ; /* Updating this field store latest top amount which user submit for renewal. Later this will be sent to CCRM. */ rq.xrped__c = rq.xrpid__c ; /* Updating this field store latest expire date which user submit for renewal. Later this will be sent to CCRM. */ rq.xrap__c = rq.xss__c - paidCount; decimal finalTopUpAmt = (rq.xcmta__c / rq.xss__c) * rq.xrap__c ; /* Added this to get amount value based on remaining slots. */ rq.xtpa__c = finalTopUpAmt; rq.xrpid__c = rq.xaed__c ; }
                }
                else{
                rq.STA__c = 'Under Review';
                }                
                update rq;
            }
            grqH.rH h = new grqH.rH();
            //h.transItms=TIs;
            h.AP(rq, T, riIds);
            return true;
        } catch (exception ex) {
            system.debug('exception::' + ex.getStackTraceString());
            if (sp != null) {Database.rollback(sp); } gU.AddErrorMsg(ex);payDone = false;return false;
        }
    }

    public String updatePrSequence(String adhocItems) { Pattern prPattern = Pattern.compile('pr(\\d+)'); Matcher m = prPattern.matcher(adhocItems); Integer maxNum = -1; while (m.find()) { Integer currentNum = Integer.valueOf(m.group(1)); if (currentNum > maxNum) { maxNum = currentNum; } } Integer nextNum = maxNum + 1; adhocItems += 'pr' + String.valueOf(nextNum) + ';'; System.debug('Updated adhocItems = ' + adhocItems); return adhocItems; }
    private void clrChqInfo(){T.cq__c = null;T.cdt__c = null;T.ci__c = null;T.Bnk__c = null;}
    private Pagereference processPay(){
        Pagereference ref = null;
        try{
            if(nD && rq.xdrv__c == false){gU.addInfoMsg(Label.msgNoDocuments);  return null;}
            /*if(rq.srvc__r.uid__c == gu.csStr('AdditionalParking')){Map<String,String> response  = new ParkingM().getAmntAP(Date.newInstance(rq.xaed__c.year(),rq.xaed__c.month(),rq.xaed__c.day()),rq.xanum__c);Decimal amnt = Math.round(Decimal.valueOf(response.get('amount')) * rq.xrap__c);if(response.get('errorCode')=='0' && !rq.xdapp__c && Math.round(rq.xtpa__c) != amnt) {gU.addErrorMsg('There\'s change in price, please refresh the page for updated amount and try again.' );rq.xtpa__c = amnt; update rq;return null;}else if(response.get('errorCode')!='0'){gU.addErrorMsg('Error while updating the price, please contact your administrator.' );return null;}}*/
            /*if (rq.srvc__r.uid__c == gu.csStr('AdditionalParking')) { Map < String, String > response = new ParkingM().getAmntAP(Date.newInstance(rq.xaed__c.year(), rq.xaed__c.month(), rq.xaed__c.day()), rq.xanum__c); Decimal amnt = Math.round(Decimal.valueOf(response.get('amount')) * rq.xrap__c); if (response.get('errorCode') == '0' && !rq.xdapp__c && Math.round(rq.xtpa__c) != amnt) { gU.addErrorMsg('There\'s change in price, please refresh the page for updated amount and try again.'); System.debug('<processPay> There\'s change in price, please refresh the page for updated amount and try again.'); rq.xtpa__c = amnt; update rq; return null; } else if (response.get('errorCode') != '0') { gU.addErrorMsg('Error while updating the price, please contact your administrator.'); System.debug('<processPay> Error while updating the price, please contact your administrator.'); return null; } }*/
            system.debug('pyMthd::'+pyMthd);
            if(pyMthd=='Customer Deposit'||pyMthd=='Debit Memo'){
                clrChqInfo();
                //rcc
				/*MS 1.1 start*/
                list < g_reqitem__c > lstItm = new list < g_reqitem__c > ();
                for (g_reqitem__c objItm: rq.Items__r) {
                    lstItm.add(objItm);
                }
                List<g_reqitem__c>  courBk=[SELECT Id,RQ__c,sta__c,xcub__c,sta__r.Courier_Stage__c,sta__r.next_status__r.Courier_Stage__c,sta__r.cd__c,Name,xcasc__c,exp__c from g_reqitem__c where (sta__r.Courier_Stage__c<> null  or sta__r.next_status__r.Courier_Stage__c<>null) and id in :lstItm  order by createdDate desc limit 1]; /*Ms 1.1*/
                /*MS 1.1 Ends*/                g_reqitem__c ri;
                for(g_reqitem__c i:courBk){if(i.sta__r.Courier_Stage__c=='Collection' || i.sta__r.next_status__r.Courier_Stage__c=='Collection' || i.sta__r.Courier_Stage__c=='Delivery'){ri=i;}}
                
                XMLParserforEmpostWebservice  cour= new XMLParserforEmpostWebservice();
                
                if(ri!=null && (ri.sta__r.Courier_Stage__c=='Collection' || ri.sta__r.Courier_Stage__c=='Delivery' || ri.sta__r.next_status__r.Courier_Stage__c=='Collection')) {
                    if(ri.sta__r.next_status__r.Courier_Stage__c=='Collection')
                    {ri.sta__r.Courier_Stage__c = ri.sta__r.next_status__r.Courier_Stage__c; }
                    cour.courierBooking(ri, rq, false,'');
                }
                
                // added for correction component
                 String rc = ApexPages.currentPage().getParameters().get('rc');
                List<g_reqitem__c> rqItmLst = new List<g_reqitem__c>();
                /*MS 1.1*/
                if(!lstItm.isEmpty() && rc != null && rc=='y') { String usrComments = ApexPages.currentPage().getParameters().get('c'); for(g_reqitem__c rii : lstItm){ if(rc=='y' && rii.sta__r.Next_Status__c!=null && rii.sta__r.staown__c == 'Customer'){ rii.sta__c = rii.sta__r.next_status__c ; rii.xcdocs__c = ''; rii.xcnotes__c = ''; rii.xr__c = ''; rqItmLst.add(rii); } }  update rqItmLst;  List<FeedItem> fdItmLst = new List<FeedItem>(); FeedItem fd =null; if(usrComments != null && usrComments != '') { fd = createFeedItem(usrComments); fdItmLst.add(fd); }  rq.xcn__c = ''; rq.xcs__c = false; update rq; fd = createFeedItem(Label.msgCRFeed); fdItmLst.add(fd); insert fdItmLst;  }
               /* end of cc*/
                if(crtPay('Completed',pyMthd,'')){
                    ref = new Pagereference('/apex/grqpyinfo?tid='+T.id);
                    gU.AddSuccessMsg('Payment has been processed successfully. Reference Number: ' + T.Name);payDone = true;pdfConfirm = 'apex/gtrcpt?Id='+T.Id;//return null;
                }
            }
            else if(pyMthd=='Cash'||pyMthd=='Wire Transfer'||pyMthd=='Bank Letter'){
                if (pyMthd != 'Wire Transfer')
                clrChqInfo();
                if(crtPay('Open',pyMthd,'')){ref = new Pagereference('/apex/grqpycinfo?tid='+T.id+'&id='+T.RQ__c);gU.AddSuccessMsg('Transaction has been registered successfully. Reference Number: ' + T.Name + '. Once we receive the payment, the transaction will be completed automatically');payDone = true;pdfConfirm = 'apex/gtrinv?Id='+T.Id;
                                             /*return null;*/
				}
                
            }
            else if(pyMthd=='Cheque'){if(crtPay('Open',pyMthd,'')){ref = new Pagereference('/apex/grqpycinfo?tid='+T.id+'&id='+T.RQ__c);gU.AddSuccessMsg('Transaction has been registered successfully. Reference Number: ' + T.Name + '. Once we receive the payment, the transaction will be completed automatically');payDone = true;pdfConfirm = 'apex/gtrinv?Id='+T.Id;
                                                                   /*return null;*/
			}
			}              
            else if(pyMthd=='Credit / Debit Card'){
                clrChqInfo();
                system.debug(T.A__c);
                system.debug(T.Id);
                payDone = true;pdfConfirm = null;
                crtPayCard();
             //ref = new Pagereference('/apex/grqpyInfo?tid='+T.id+'&id='+T.RQ__c); //if(crtPay('Open',pyMthd)){gU.AddInfoMsg('111Transaction has been registered successfully. Reference Number: ' + T.Name + '. You will be redirected to the Payment Gateway to process your payment');gU.DEG_PrepareCall(T.A__c,T.Id);payDone = true;pdfConfirm = null;return null;} /* if(crtPay('Open',pyMthd)){ gU.AddInfoMsg('Transaction has been registered successfully. Reference Number: ' + T.Name + '. You will be redirected to the Payment Gateway to process your payment'); system.debug('nefore prepare cal;#####################################');gU.DEG_PrepareCall(T.A__c,T.Id); system.debug('After prepare call#####################################');payDone = true;pdfConfirm = null;//return null; } */
            }
            else {
                gU.AddWarningMsg(Label.msgNoPayMethod);payDone = false;pdfConfirm = null;return null;
            }
            System.debug('--PayDone-- : ' +Paydone);
            
        }catch(exception ex){ String msg = ex.getMessage(); if (msg.contains('Upsert failed. First exception on row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION')) { msg = msg.replace('Upsert failed. First exception on row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION', ''); msg = msg.replace('[]', ''); } gU.AddErrorMsg(msg);}
        return ref;
    }
    @testvisible private FeedItem createFeedItem(String txt){
        FeedItem fd = new FeedItem();
        fd.body =txt;fd.ParentId = rq.id;
        fd.Type = 'TextPost';
        fd.Visibility = 'AllUsers';  
        return fd;
    }
    
    public PageReference save(){return processPay();}
    public PageReference payAmt(){return processPay();}
    public PageReference saveReq(){
        pagereference ref = null;
        boolean isv = true;
        if(rq.srvc__r.uid__c=='tbg'){
            Decimal BG = rq.Acc__r.bg__c == null ? 0 : rq.Acc__r.bg__c;
            if (System.Math.mod(rq.xtpa__c.longValue(), gU.csCurr('minBG').longValue()) != 0) {
                //r.addError(Label.msgBGMLTP);
                gU.addWarningMsg(Label.msgBGMLTP);
                isv = false;
            }
            if (rq.xtpa__c + BG > gU.csCurr('maxBG') && rq.sta__c != 'Cancelled' && rq.STA__c != 'Rejected') {
                gU.addWarningMsg(Label.msgBGOL.replaceAll('XX', (gU.csCurr('maxBG') - BG).format()));
                isv = false;
            }
        }
        if(isv){
            update rq;
            list < g_reqitem__c > tU = new list < g_reqitem__c > ();
            for (g_reqitem__c i: [select Id, RQ__c, scN__c from g_reqitem__c where isDeleted = false and RQ__c=:rq.id]) {
                i.scN__c = rq.xtpa__c;
                tU.add(i);
            }
            if (tU.size() > 0) {
                update tU;
            }
            ref = new pagereference('/apex/grqpy1?id=' + rq.Id+'&cn=' + rq.srvc__r.uid__c);
            ref.setRedirect(true);
        }
        return ref;}
    public void CnclPayment(){try{String aid = ApexPages.currentPage().getParameters().get('aid');if(aid==null){gU.addWarningMsg(Label.msgPayNoCancel);return;}for(g_Tran__c tr: rq.Transactions__r){if(aid == tr.ID && tr.STA__c =='Open' && tr.md__c != 'Credit / Debit Card' && tr.TP__c=='Payment'){tr.STA__c = 'Cancelled';update tr;gU.AddSuccessMsg('Succenssfully cancelled transaction: ' + tr.Name);return;}}gU.addWarningMsg(Label.msgPayNoCancel);}catch(exception ex){gU.AddErrorMsg(ex);}}
    public pagereference authenticateUser(){
        String  empid = ApexPages.currentPage().getParameters().get('empid');
        encid = ApexPages.currentPage().getParameters().get('enc');
        sid =  ApexPages.currentPage().getParameters().get('sid');
        isgu = gu.isGuestUser(userInfo.getProfileId());
        pagereference pg=null;
        
        if(gu.isGuestUser(userInfo.getProfileId())){
            System.debug('** Is Guest User');
            if ((rq.srvc__r.uid__c != 'dnc' && (empid == '' || empid == null || encid == '' || encid == null   || !DEG_Checksum(empid,encid))&& !Test.isRunningTest())){
                pg = new pagereference('/apex/AccesDeniedPage');
            }
            noAcc=false;
            
        }
        //else if (rq.srvc__r.uid__c == '208') { g_req__c urq = [select id, srvc__r.stg__r.payq__c, xdccaRq__c, Acc__r.lc__c, Acc__r.dccaexId__c, xcbd__c, xdei__c, xmamd__c, xpmsle__c from g_req__c where id =: rq.id]; boolean amdFlg = false; if (urq.xpmsle__c && urq.xmamd__c) amdFlg = true; String dccaRes = grqWsDccaGetService.getReqDetails(urq.Acc__r.lc__c, String.ValueOf(urq.xcbd__c), urq.xdei__c, amdFlg); urq.xdccaRq__c = dccaRes; update urq; rq = urq; init(); return null; }
        else if (rq.srvc__r.uid__c == '208') { g_req__c urq = [select id, srvc__r.stg__r.payq__c, xdccaRq__c, Acc__r.lc__c, Acc__r.dccaexId__c, xcbd__c, xdei__c, xmamd__c, xpmsle__c from g_req__c where id =: rq.id]; boolean amdFlg = false; if (urq.xpmsle__c && urq.xmamd__c) amdFlg = true; String dccaRes = grqWsDccaGetService.getReqDetails(urq.Acc__r.lc__c, String.ValueOf(urq.xcbd__c), urq.xdei__c, amdFlg); urq.xdccaRq__c = dccaRes; update urq; grqH.rAfter=true; rq = urq; laodData(); return null; }
        else if(rq.srvc__r.uid__c == '322'){ Decimal ddaAmnt = 0; List<g_reqitem__c> riLst = [select id,scN__c,rq__c,rq__r.xdccaRq__c from g_reqitem__c where rq__c=:rq.id and itm__r.cd__c = 'frl' and rq__r.srvc__r.uid__c ='322' ]; if(riLst !=null && !riLst.isEmpty()){ String dccaRes = grqWsDccaGetService.getNewReqDetails(riLst[0].rq__r.xdccaRq__c); system.debug('dccaRes::'+dccaRes); if(String.isNotBlank(dccaRes)){ grqWsDccaGetService jj= (grqWsDccaGetService) System.JSON.deserialize(dccaRes, grqWsDccaGetService.class);  if(jj.Data.get(0).amount != null){ ddaAmnt = jj.Data.get(0).amount; system.debug('ddaAmnt@@@@@@@@@@@@@@@@@1'+ddaAmnt); } } if(ddaAmnt != 0){ riLst[0].scN__c = ddaAmnt-20; update riLst; }  } Is=new list<itm>(); rq=(g_Req__c)Database.query(m_SOQL+' where id=\''+rq.Id+'\' and isDeleted = false'); if(rq.Items__r!=null){for(g_reqitem__c i:rq.Items__r){if(i.AD__c>0 && (pmntItems==null || pmntItems=='') ){Is.add(new itm(i)); if(String.isNotBlank(i.itm__r.gctg__c))ctgLst.add(i.itm__r.gctg__c);} else if(i.AD__c>0 && (pmntItems!=null && pmntItems.contains(i.id))){Is.add(new itm(i));} AOP+=i.AOP__c;} if(ctgLst != null && ctgLst.size() >1) ctgFlg=true; } return null; }
		else if (rq.srvc__r.uid__c == '220' ) { List < g_reqitem__c > riLst = [select id,itmCd__c from g_reqitem__c where rq__c =: rq.id and itmCd__c not in('dsr','ddd','kf','inf') and (name like '%Segment%' OR name like '%Activity%' OR name like '%Channels%' OR name like '%Titles%') limit 1]; if (riLst != null && !riLst.isEmpty()) { String responseBody = DDAServices.getDDAServices(Label.LA_DDA_End_Point,'licenseAmendment/serviceCalculateFees','POST',rq.xadtx3__c); DccaBatchUtil.LAResponseWrapper ref = (DccaBatchUtil.LAResponseWrapper)System.JSON.deserialize(responseBody,DccaBatchUtil.LAResponseWrapper.class); system.debug('---ref---'+ref); if(ref.srList[0].totalAmount!=null && ref.srList[0].totalAmount>0){ riLst[0].scn__c=ref.srList[0].totalAmount-20; system.debug('---amount to be paid---'+riLst[0].scn__c); update riLst; } Is = new list < itm > (); rq = (g_Req__c) Database.query(m_SOQL + ' where id=\'' + rq.Id + '\' and isDeleted = false'); if (rq.Items__r != null) { for (g_reqitem__c i: rq.Items__r) { if (i.AD__c > 0 && (pmntItems == null || pmntItems == '')) { Is.add(new itm(i)); if (String.isNotBlank(i.itm__r.gctg__c)) ctgLst.add(i.itm__r.gctg__c); } else if (i.AD__c > 0 && (pmntItems != null && pmntItems.contains(i.id))) { Is.add(new itm(i)); } AOP += i.AOP__c; } if (ctgLst != null && ctgLst.size() > 1) ctgFlg = true; } } return null; }
        /*else if((rq.srvc__r.uid__c == '001' || rq.srvc__r.uid__c == '002' || rq.srvc__r.uid__c == '021'|| rq.srvc__r.uid__c == '020' || rq.srvc__r.uid__c == '040' || rq.srvc__r.uid__c == '078' || rq.srvc__r.uid__c == '003' || rq.srvc__r.uid__c == '004' || rq.srvc__r.uid__c == '303' || rq.srvc__r.uid__c == '304') && rq.AP__c==0 && !((rq.xadh__c).contains('ic;'))){ Date dob=rq.xcbd__c;Date dt=Date.today();Integer y=dob.monthsBetween(dt) / 12; if(y<50){} if(!rq.x30gr__c){ pg = new pagereference('/apex/grqGdrfa?id='+rq.id); } }*/
        else{return null;}
        return pg;
        
    }
    public static boolean DEG_Checksum(String msg, String encText) {
        String eCd = EncodingUtil.convertToHex(Crypto.generateDigest('SHA1', blob.valueOf('P@ssw0rdAXSHRMS'+msg))).toUpperCase();
        System.debug('** eCd:'+eCd);    System.debug('** encText:'+encText);
        return eCd == encText;
    }
    //*** ------- Wrappers --------------------------------------------------------------------------------
    public class itm{public g_reqitem__c I{get;set;}public Boolean s{get;set;}public Boolean r{get;set;}public itm(g_reqitem__c itm){I=itm;s=true;r = I.itm__r.Req__c;}}
    public class Trn{public g_Tran__c T{get;set;}public Trn(g_Tran__c trn){T = trn;}}
    public Pagereference crtPayCard(){
        system.debug('crtPayCardcrtPayCardcrtPayCard >>>');
        String accessToken = '';
        String referenceNo = '';
        PageReference ref = null;
        String niAPIKey=gU.csStr('NI-APIKEY');//ZTY4NjA1MDAtNDZlNy00YjAxLWE1NTktMDZmNDE0YzVlNDhlOjIzYzBiYTU1LTAxMTItNDYyMC04Y2FhLTUxZDM2M2M2M2Y1OQ==
        String niEndPoint=gU.csStr('NIENDPOINT');//https://identity-uat.ngenius-payments.com/auth/realms/ni/protocol/openid-connect/token
        String niPayUrl=gU.csStr('NIPAYMENTURL');//https://api-gateway-uat.ngenius-payments.com/transactions/outlets/d0e91b8f-476d-4a4b-aae7-075755b0159a/orders
        String returnURL=gU.csStr('RETURNURL');//https://pgso-axs.cs31.force.com/grqpyc
        //String email=gU.csStr('NIEMAIL');//email
        String email=UserInfo.getUserEmail();
        Integer cnt=0; Decimal Amt2Pay=0;
        system.debug('niPayUrlniPayUrlniPayUrlniPayUrlniPayUrl >>>'+niPayUrl);
        try{  for(itm i:Is){if(i.s && (String.isBlank(selCtg) || (String.isNotBlank(selCtg) && selCtg.contains(i.I.itm__r.gctg__c))))
        {cnt++;Amt2Pay+=i.I.AD__c+i.I.AV__c;}}  /* g_Tran__c T = crtCCPay('Open','Credit / Debit Card',referenceNo); If(T == null){gU.AddWarningMsg(Label.msgException);payDone = false;pdfConfirm = null; return null;}*/ HttpRequest req = New HttpRequest(); req.setHeader('Content-Type', 'application/x-www-form-urlencoded'); /* basic + API key will be chnagedin production*/ /*req.setHeader('Authorization', 'Basic:ZTY4NjA1MDAtNDZlNy00YjAxLWE1NTktMDZmNDE0YzVlNDhlOjIzYzBiYTU1LTAxMTItNDYyMC04Y2FhLTUxZDM2M2M2M2Y1OQ==');*/ req.setHeader('Authorization', 'Basic:'+niAPIKey); req.setMethod('POST'); req.setBody('grant_type=client_credentials'); /* no change in end point move it to custom settings*/ /*req.setEndpoint('https://identity-uat.ngenius-payments.com/auth/realms/ni/protocol/openid-connect/token');*/ req.setEndpoint(niEndPoint); system.debug('req >>>'+req); Http http = New Http(); HTTPResponse res = http.send(req); system.debug('res >>>'+res); system.debug('res >>>'+res.getBody()); String resStr = res.getBody(); accessToken = getJsonResponse(resStr,'AccessToken'); system.debug('accessToken::'+accessToken); }catch(Exception e){gU.AddErrorMsg(e); system.debug('exception1:'+e.getMessage());}
        try{ HttpRequest req = New HttpRequest(); req.setHeader('Content-Type', 'application/vnd.ni-payment.v2+json'); req.setHeader('Authorization', 'Bearer '+accessToken); req.setHeader('Accept', 'application/vnd.ni-payment.v2+json'); req.setMethod('POST'); /*Decimal amount = rq.xtpa__c *100; */ Decimal amount = Amt2Pay*100; system.debug('returnURL::'+returnURL); system.debug('Amt2Pay::'+Amt2Pay); /*system.debug('json::{"action":"SALE","amount":{"currencyCode":"AED","value": '+integer.valueOf(amount)+'},"language": "en","merchantAttributes":{"redirectUrl":"https://pgso-axs.cs31.force.com/grqpyc","skipConfirmationPage":true},"emailAddress":"srinivasa.varanasi@gmail.com"}');*/ req.setBody('{"action":"SALE","amount":{"currencyCode":"AED","value": '+integer.valueOf(amount)+'},"language": "en","merchantAttributes":{"redirectUrl":"'+returnURL+'","skipConfirmationPage":true},"emailAddress":"'+email+'"}'); /*key will be chnage in production  outlet Ref#d0e91b8f-476d-4a4b-aae7-075755b0159a');*/ /*req.setEndpoint('https://api-gateway-uat.ngenius-payments.com/transactions/outlets/d0e91b8f-476d-4a4b-aae7-075755b0159a/orders');*/ req.setEndpoint(niPayUrl); Http http = New Http(); /*system.debug('Grant type header set');*/ HTTPResponse res = http.send(req); system.debug('res'+res.getBody()); String resStr = res.getBody(); paymentLink = getJsonResponse(resStr,'PaymentLink'); referenceNo = getJsonResponse(resStr,'reference'); system.debug('@@@@@@@@@@@@@@@@ Order Ref##############'); system.debug('referenceNo::'+referenceNo); system.debug('@@@@@@@@@@@@@@@@ Order Ref##############'); system.debug('paymentLinkpaymentLink::'+paymentLink); }catch(Exception e){gU.AddErrorMsg(e);system.debug('exception2:'+e.getMessage());}
        if(paymentLink != ''){
            /*T.gwrf__c = referenceNo;
				update T;*/
            crtPay('Open','Credit / Debit Card',referenceNo);
            ref = new PageReference(paymentLink);
            ref.setRedirect(true);
        }
        return ref;
    }
    
    @testvisible private string getJsonResponse(String jsonStr,String jsonType){ String res = ''; try{ Map<String, Object> results = (Map<String, Object>)JSON.deserializeUntyped(jsonStr); if(jsonType == 'AccessToken') res = (String)results.get('access_token'); else if(jsonType == 'PaymentLink') { Map<string,Object> links = (Map<string,Object>)results.get('_links'); Map<string,Object> payment = (Map<string,Object>)links.get('payment'); res = (string)payment.get('href'); }  else if(jsonType == 'reference') { res = (String)results.get('reference'); } system.debug('res::'+res); }catch(Exception ex){gU.AddErrorMsg(ex);system.debug('ex::'+ex.getStackTraceString());} return res; }
	 
    /**

     * Method: updateItemSTA
     * parameter : g_req__c id
     * Desc: To update next status on req item.
     */

     public void updateItemSTA(String rqId) { g_req__c rq = new g_req__c(Id = rqId); list < g_reqitem__c > Itms = new list < g_reqitem__c > (); boolean isReqCompleted = false; try{ List < g_reqitem__c > itmIds = [SELECT Id, RQ__c, sta__c, sta__r.Next_Status__c, sta__r.Next_Status__r.rqSTA__c, itm__c, itm__r.cd__c from g_reqitem__c where RQ__c =: rqId and sta__r.isfn__c = true and isdeleted = false order by createdDate desc ]; /*To be checked with Srini MS 1.1*/ g_srvcitm_Status__c verSta = [SELECT id , name , itm__r.cd__c, rqSTA__c from g_srvcitm_Status__c where cd__c = 'v' and srv_code__c = '216' and itm__r.cd__c = 'nl' limit 1]; System.debug('updateItemSTA - <itmIds> : ' + itmIds); System.debug('updateItemSTA - verSta : ' + verSta); if (!itmIds.isEmpty() && itmIds.size() > 0) { for (g_reqitem__c i: itmIds) { i.sta__c = verSta.id; if ((i.sta__r.Next_Status__c != null && i.sta__r.Next_Status__r.rqSTA__c == 'Completed') || (i.itm__r.cd__c == 'ai' && i.sta__r.Next_Status__c != null)) { rq.STA__c = verSta.rqSTA__c; isReqCompleted = true; } Itms.add(i); } } if (!Itms.isEmpty() && Itms.size() > 0) { update Itms; } }catch(Exception e){} }
}
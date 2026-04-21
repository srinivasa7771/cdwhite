public class refundFormBanKController {
    public Boolean rfUploaded{get;set;}
    public g_Req__c req {get;set;}
    public String docName { get; set; }
    public transient  String imageBase64 {get;set;}
    public transient  String imageBase264 {get;set;}
    public String reqId{get;set;}
    public String srvcID{get;set;}
    public g_Srvc__c srv{get;set;}
    public Account Acc{get;set;}
    public Boolean pgHide{get;set;}
    public g_srvc_definition__c sd{get;set;}
    public List<D> docList {set;get;}
    public User U {set;get;}
    private Boolean hasSanctions{
        get{    grqH.rH h = new grqH.rH ();return !h.BC(req, srv, Acc);
           }
    }
    public refundFormBanKController() {
        docList = new List<D>();
        String sid = String.escapeSingleQuotes(ApexPages.CurrentPage().getParameters().get('sid'));
        reqId = apexpages.currentpage().getparameters().get('id');
        system.debug('reqId -- '+reqId);
        rfUploaded = false;
        List<String> dLst = new List<String>{'Manager Consent Letter:Manager Consent Letter', 'Bank Letter:Bank Letter', 'Emirates ID:Emirates ID'};
            for (String docNm : dLst) {
                List<String> docNmLst = docNm.split(':');
                D obj = new D();
                obj.DocName = docNmLst[0];
                obj.DocLabel = docNmLst[1];
                if (docNmLst[0] == 'Manager Consent Letter') {
                    obj.parse = true;
                    obj.isSaveRQ = true;
                }
                else
                    obj.parse = false;
                docList.add(obj);
            }
        U = [select id, FirstName, LastName, contact.account.mtc__c, contact.account.Name, contact.account.Email__c, contact.account.Phone, MobilePhone, accountid,
             contact.account.id, contact.account.Legal_Framework__c, contact.account.intsts__c,
                 contact.account.bacnm__c, contact.account.banum__c, contact.account.iban__c, contact.account.bknm__c,
                 contact.account.basft__c, contact.account.bfrc__c, contact.account.bfsc__c, contact.account.adb__c,
                 contact.account.xcuzn__c, contact.account.xcublg__c, contact.account.bgb__c, contact.account.bgnr__c,
                 contact.account.bg__c, contact.account.loc__c, contact.account.Type, contact.account.Prk__c,
                 contact.account.lcsnc__c, contact.account.lcsncnt__c, contact.account.lcedt__c, contact.account.psasnc__c,
                 contact.account.psasncnt__c, contact.account.ecsnc__c, contact.account.ecsncnt__c,
                 contact.account.cosnc__c, contact.account.cosncnt__c, contact.account.bgsnc__c, contact.account.bgsncnt__c,
                 contact.account.snc__c, contact.account.info__c, contact.account.vestd__c, contact.account.vbtemp__c,
                 contact.account.vbvv__c,
             contact.account.lc__c, contact.account.bandb__r.curcode__c, contact.account.bandb__r.Name,
                 contact.account.bandb__r.ccode__c, contact.account.bandb__r.Branch_Name__c, contact.account.bandb__r.Country__c,
                 contact.account.bandb__c, contact.account.bifc__c, contact.account.vbtst__c, contact.account.ORACLE_PARTY_ID__c,
                 contact.account.lcsta__c, contact.account.lctp__c, contact.account.session__c, contact.account.vctemp__c,
                 contact.account.vvsfp__c, contact.account.lcrndt__c, contact.account.os__c, contact.account.vespe__c from User where id=:UserInfo.getUserId() limit 1];

        Acc= U.contact.account;
        if (reqId == null) {
            req=new g_Req__c();
            req.srvc__c = sid;
            req.acc__c = Acc.Id;
        }
        else{
            req = [select id, name, acc__c, srvc__c, srvc__r.stg__r.reqq__c, xadh__c, sta__c from g_req__c where id=:reqId];
            req = (g_Req__c)Database.query(req.srvc__r.stg__r.reqq__c + ' where id=\'' + String.escapeSingleQuotes(reqId) + '\' and isDeleted = false');
            sid = req.srvc__c;
            Map<string, Attachment> attMp = new Map<string, Attachment>();
            List<g_reqDoc__c> rdocList = [select id, tplt2__c from g_reqDoc__c where RQ__c =:reqId and reqAts__c=true and upOk__c=true];
            for (Attachment att : [select id, name, body, parentid from Attachment where parentid=:rdocList]) {
                attMp.put(att.name.split('\\.')[0], att);
            }
            for (D doc : docList) {
                if (attMp != null && attMp.containskey(doc.DocName)) {
                    Attachment att = attMp.get(doc.DocName);
                    doc.attId = att.Id;
                    doc.attName = att.name;
                    doc.tmpltId = (doc.DocName == 'Manager Consent Letter')?'/servlet/servlet.FileDownload?file=015Ik000000kYFw':'';
                }
            }
        }
        srv = [select id, uid__c, name, sdg__c, sdg__r.sd__c, sdg__r.slbl__c, sdg__r.docslbl__c, lbl__c, dsc__c, Prk__c, AccTp__c, conrol__c, consta__c,
               sprrole__c, sprsta__c, ckgsnc__c, snc__c, stg__r.pg__c, stg__r.apx__c, stg__r.reqq__c from g_Srvc__c where id=: sid limit 1];

    }

    public List < SelectOption > getBankOptions() {

        List < SelectOption > bankOptions = new List < SelectOption > ();
        Map < String, String > mapCC = new Map < String, String > {
            'ABN AMRO'=>'ABN AMRO',
                'ABU DHABI COMMERCIAL BANK'=>'ABU DHABI COMMERCIAL BANK',
                'ABU DHABI ISLAMIC BANK'=>'ABU DHABI ISLAMIC BANK',
                'AHLI UNITED BANK'=>'AHLI UNITED BANK',
                'AJMAN BANK'=>'AJMAN BANK',
                'AL AHLI BANK OF KUWAIT K.S.C.P.'=>'AL AHLI BANK OF KUWAIT K.S.C.P.',
                'AL HILAL BANK'=>'AL HILAL BANK',
                'AL KHALIJI FRANCE S.A.'=>'AL KHALIJI FRANCE S.A.',
                'AL MARYAH COMMUNITY BANK'=>'AL MARYAH COMMUNITY BANK',
                'AL MASRAF'=>'AL MASRAF',
                'AL RAJHI BANK'=>'AL RAJHI BANK',
                'ALAHLI BANK'=>'ALAHLI BANK',
                'ANZ'=>'ANZ',
                'AP/AR Netting Bank'=>'AP/AR Netting Bank',
                'ARAB AFRICAN INTERNATIONAL BANK'=>'ARAB AFRICAN INTERNATIONAL BANK',
                'ARAB BANK'=>'ARAB BANK',
                'ARAB BANK FOR INVESTMENT AND FOREIGN TRADE'=>'ARAB BANK FOR INVESTMENT AND FOREIGN TRADE',
                'ATTIJARIWAFA BANK'=>'ATTIJARIWAFA BANK',
                'BANK MELLI IRAN'=>'BANK MELLI IRAN',
                'BANK MENDES GANS - BMG - ING'=>'BANK MENDES GANS - BMG - ING',
                'BANK OF AMERICA - BOA'=>'BANK OF AMERICA - BOA',
                'BANK OF BARODA'=>'BANK OF BARODA',
                'BANK OF CHINA - BOC'=>'BANK OF CHINA - BOC',
                'BANK OF SHARJAH'=>'BANK OF SHARJAH',
                'BANQUE BANORIENT FRANCE'=>'BANQUE BANORIENT FRANCE',
                'BANQUE DE COMMERCE ET DE PLACEMENTS'=>'BANQUE DE COMMERCE ET DE PLACEMENTS',
                'BANQUE DU CAIRE'=>'BANQUE DU CAIRE',
                'BANQUE MISR'=>'BANQUE MISR',
                'BANQUE POPULAIRE - BPCE GROUP'=>'BANQUE POPULAIRE - BPCE GROUP',
                'BARCLAYS'=>'BARCLAYS',
                'BLOM BANK'=>'BLOM BANK',
                'BLOM BANK FRANCE / BANQUE BANORABE'=>'BLOM BANK FRANCE / BANQUE BANORABE',
                'BNP'=>'BNP',
                'BNZ FOREIGN CURRENCY ACCOUNTS'=>'BNZ FOREIGN CURRENCY ACCOUNTS',
                'CALIFORNIA BANK AND TRUST'=>'CALIFORNIA BANK AND TRUST',
                'CENTRAL BANK OF UAE'=>'CENTRAL BANK OF UAE',
                'CITIBANK'=>'CITIBANK',
                'COMMERCIAL BANK INTERNATIONAL - CBI'=>'COMMERCIAL BANK INTERNATIONAL - CBI',
                'COMMERCIAL BANK OF DUBAI'=>'COMMERCIAL BANK OF DUBAI',
                'COMMERCIAL BANK OF QATAR'=>'COMMERCIAL BANK OF QATAR',
                'CREDIT AGRICOLE - CA'=>'CREDIT AGRICOLE - CA',
                'CREDIT AGRICOLE - CACIB'=>'CREDIT AGRICOLE - CACIB',
                'DEUTSCHE BANK - DB'=>'DEUTSCHE BANK - DB',
                'DH Petty Cashier'=>'DH Petty Cashier',
                'DOHA BANK'=>'DOHA BANK',
                'DUBAI ISLAMIC BANK'=>'DUBAI ISLAMIC BANK',
                'Delete POC 3'=>'Delete POC 3',
                'Dummy Bank'=>'Dummy Bank',
                'EL NILEIN BANK'=>'EL NILEIN BANK',
                'EMIRATES BANK'=>'EMIRATES BANK',
                'EMIRATES BANK INTERNATIONAL PJSC'=>'EMIRATES BANK INTERNATIONAL PJSC',
                'EMIRATES DEVELOPMENT BANK'=>'EMIRATES DEVELOPMENT BANK',
                'EMIRATES ISLAMIC'=>'EMIRATES ISLAMIC',
                'EMIRATES NBD'=>'EMIRATES NBD',
                'EMIRATES NBD BANK PJSC'=>'EMIRATES NBD BANK PJSC',
                'ENBD PrePay Account'=>'ENBD PrePay Account',
                'FINANCE HOUSE'=>'FINANCE HOUSE',
                'FIRST ABU DHABI BANK'=>'FIRST ABU DHABI BANK',
                'FIRST GULF BANK'=>'FIRST GULF BANK',
                'GULF INTERNATIONAL BANK'=>'GULF INTERNATIONAL BANK',
                'HABIB BANK'=>'HABIB BANK',
                'HABIB BANK AG ZURICH'=>'HABIB BANK AG ZURICH',
                'HABIB BANK AG ZURICH'=>'HABIB BANK AG ZURICH',
                'HSBC'=>'HSBC',
                'HYPOVEREINSBANK AG'=>'HYPOVEREINSBANK AG',
                'INTESA SANPAOLO - ABU DHABI BRANCH'=>'INTESA SANPAOLO - ABU DHABI BRANCH',
                'INVESTBANK'=>'INVESTBANK',
                'JANATA BANK LIMITED'=>'JANATA BANK LIMITED',
                'LLOYDS BANK PLC'=>'LLOYDS BANK PLC',
                'MASHREQ BANK'=>'MASHREQ BANK',
                'MCB BANK'=>'MCB BANK',
                'MONTE PASCHI'=>'MONTE PASCHI',
                'MUFG - BTMU - BANK OF TOKYO-MITSUBISHI UFJ - UNION BANK'=>'MUFG - BTMU - BANK OF TOKYO-MITSUBISHI UFJ - UNION BANK',
                'MUSLIM COMMERCIAL BANK'=>'MUSLIM COMMERCIAL BANK',
                'NATIONAL BANK OF ABU DHABI'=>'NATIONAL BANK OF ABU DHABI',
                'NATIONAL BANK OF BAHRAIN BSC'=>'NATIONAL BANK OF BAHRAIN BSC',
                'NATIONAL BANK OF DUBAI'=>'NATIONAL BANK OF DUBAI',
                'NATIONAL BANK OF FUJAIRAH'=>'NATIONAL BANK OF FUJAIRAH',
                'NATIONAL BANK OF KUWAIT'=>'NATIONAL BANK OF KUWAIT',
                'NATIONAL BANK OF OMAN'=>'NATIONAL BANK OF OMAN',
                'NATIONAL BANK OF UMM AL QAIWAIN'=>'NATIONAL BANK OF UMM AL QAIWAIN',
                'NATIONAL WESTMINSTER BANK'=>'NATIONAL WESTMINSTER BANK',
                'NOOR ISLAMIC BANK'=>'NOOR ISLAMIC BANK',
                'NOQODI'=>'NOQODI',
                'NORDEA'=>'NORDEA',
                'RAKBANK - NATIONAL BANK OF RAS AL-KHAIMAH'=>'RAKBANK - NATIONAL BANK OF RAS AL-KHAIMAH',
                'RBS - ROYAL BANK OF SCOTLAND'=>'RBS - ROYAL BANK OF SCOTLAND',
                'REGIONS BANK'=>'REGIONS BANK',
                'Ratibi Prepaid Card'=>'Ratibi Prepaid Card',
                'SAMBA BANK'=>'SAMBA BANK',
                'SAUDI NATIONAL BANK'=>'SAUDI NATIONAL BANK',
                'SCB - STANDARD CHARTERED BANK'=>'SCB - STANDARD CHARTERED BANK',
                'SHARJAH ISLAMIC BANK'=>'SHARJAH ISLAMIC BANK',
                'SMBC - SUMITOMO MITSUI BANKING CORPORATION'=>'SMBC - SUMITOMO MITSUI BANKING CORPORATION',
                'STANDARD BANK - STANBIC'=>'STANDARD BANK - STANBIC',
                'SUNTRUST'=>'SUNTRUST',
                'SVB - SILICON VALLEY BANK'=>'SVB - SILICON VALLEY BANK',
                'TD CANADA TRUST'=>'TD CANADA TRUST',
                'UBS'=>'UBS',
                'ULSTER BANK - RBS - ROYAL BANK OF SCOTLAND'=>'ULSTER BANK - RBS - ROYAL BANK OF SCOTLAND',
                'UNION NATIONAL BANK'=>'UNION NATIONAL BANK',
                'UNITED ARAB BANK'=>'UNITED ARAB BANK',
                'UNITED BANK LTD.'=>'UNITED BANK LTD.',
                'UNITED NATIONAL BANK'=>'UNITED NATIONAL BANK',
                'VGS INTERCOMPANY BANK'=>'VGS INTERCOMPANY BANK',
                'WIO Bank'=>'WIO Bank'

                };
                    bankOptions.add(new SelectOption('', '--None--'));
        for (String s: mapCC.keySet()) {
            bankOptions.add(new SelectOption(mapCC.get(s), s));
        }
        return bankOptions;
    }
    public PageReference saveDraft_m() {
        PageReference reference=null;
        try{
            system.debug('in saveDraft ');
            /*req = new g_req__c();
req.acc__c = Acc.Id;
req.srvc__c = srv.Id;*/
            req.sta__c = 'Draft';
            if (Schema.sObjectType.g_req__c.isCreateable()) {
                upsert req;
            }
            system.debug('req --  '+req);
            Map<String, String> xad4 = new Map<String, String>();

            List<Account> ac=[select id, ORACLE_PARTY_ID__c, Yardi_Cutsomer_Code__c, bacnm__c,
                banum__c, bandb__r.curcode__c, bandb__r.Name, bandb__r.ccode__c, bandb__r.Branch_Name__c,
                bandb__r.Country__c, iban__c, bknm__c, basft__c, bfsc__c, bifc__c, bfrc__c, InBcd__c from Account where id=:Acc.Id];
            g_req__c rrr=[select id, name from g_req__c where id=:req.id][0];
            adh4 adh = (adh4) JSON.deserialize(req.xadtx4__c, adh4.class);
            ac[0].bandb__c= adh.gbrnlkid;
            ac[0].bacnm__c= adh.g_bacnm;
            ac[0].bknm__c= adh.g_bacnm;
            ac[0].banum__c= adh.g_banum;
            ac[0].iban__c= adh.g_iban;
            ac[0].basft__c= adh.g_basft;
            ac[0].bfrc__c= adh.g_bfrc;
            ac[0].bfsc__c= adh.g_bfsc;
            ac[0].bifc__c= adh.g_bifc;
            ac[0].InBcd__c= adh.inba;

         String gbrnlkid=adh.gbrnlkid;
        b_and_b__c bandb=[select id, Name, Branch_Name__c, ccode__c, Country__c, curcode__c from b_and_b__c where id=:gbrnlkid  limit 1];
            adh.crncy = bandb.ccode__c;
            adh.bName = bandb.Name;
            adh.cntry = bandb.Country__c;
            adh.branch = bandb.Branch_Name__c;
            req.xadtx4__c = JSON.serialize(adh);
           /* update Acc;*/

            BankDetails b=new BankDetails();
            b.BankName=bandb.Name;
            b.BankBranchName=bandb.Branch_Name__c;
            b.BankAccountNumber=ac[0].banum__c;
            b.BankAccountName=ac[0].bacnm__c;
            b.IBAN=ac[0].iban__c;
            b.PrimaryFlag='true';
            b.CountryCode=bandb.ccode__c;
            b.CountryName=bandb.Country__c;
            b.FusionAccountNumber=ac[0].ORACLE_PARTY_ID__c;
            b.CurrencyCode=bandb.curcode__c;
            b.Description='https://integration.dubaiholding.com/ic/builder/rt/DH_SALESFORCE_DOC_DOWNLOAD/live/webApps/bank_letter_attachment_downloader/?call_type=cust&amp;account_number='+rrr.name;
            /*'https://dhsoicap-axgfix83p9dp-dx.integration.ocp.oraclecloud.com/ic/builder/rt/DH_Bank_Letter_Attachment_Downloade/live/webApps/bank_letter_attachment_downloader/?call_type=cust&amp;account_number='+rrr.name;
            */ b.Routing_Code=ac[0].bfrc__c;
            b.Beneficiary_Bank_Sort_Code=ac[0].bfsc__c;
            b.ifscCode=ac[0].bifc__c;
            b.IntermediaryBankAccountNumber = adh.inba;
            b.IntermediaryBankBankName = adh.inbaName;
            b.IntermediaryBankCountryCode = adh.inbaCntr;
            b.IntermediaryBankBranchNumber = adh.inbaBrnchNum;
            b.IntermediaryBankIBAN = adh.inbaIBAN;
            b.IntermediaryBankBIC = adh.inbaBIC;
            String fuJson = JSON.serialize(b) ;
            system.debug('XXXXXXXXX-'+fuJson);
            req.xadtx1__c=fuJson;

            Map<String, Object> jsonObj = new Map<String, Object>();
            jsonObj.put('Country Name ', bandb.Country__c);
            jsonObj.put('Currency Code ', bandb.curcode__c);
            jsonObj.put('Intermediary Code ', ac[0].InBcd__c);
            jsonObj.put('IFSC Code ', ac[0].bifc__c);
            jsonObj.put('IBAN ', ac[0].iban__c);
            jsonObj.put('Routing Code ', ac[0].bfrc__c);
            jsonObj.put('Swift Code ', ac[0].basft__c);
            jsonObj.put('Sort Code ', ac[0].bfsc__c);
            jsonObj.put('Bank Account Number ', ac[0].banum__c);
            jsonObj.put('Bank Branch Name ', bandb.Branch_Name__c);
            jsonObj.put('Bank Name ', bandb.Name);
            jsonObj.put('Bank Account Name ', ac[0].bacnm__c);
            String dfuJson = JSON.serialize(jsonObj) ;
            req.xadtx3__c=dfuJson;

            yardiBankDetails yD=new yardiBankDetails();
            yD.YARDI_CUSTOMER_CODE=ac[0].Yardi_Cutsomer_Code__c;
            yD.BENEFICIARY_NAME=ac[0].bacnm__c;
            yD.BENEFICIARY_BANK=bandb.Name;
            yD.CURRENCY_Code=bandb.curcode__c;
            yD.BENEFICIARY_IBAN_NO=ac[0].iban__c != null?ac[0].iban__c:'NA';
            yD.BENEFICIARY_ACCOUNT_NO=ac[0].banum__c;
            yD.BENEFICARY_BANK_ADDR1=bandb.Branch_Name__c;
            yD.BENEFICARY_BANK_ADDR2='';
            yD.BENEFICARY_BANK_ADDR3='';
            yD.BENEFICIARY_BANK_COUNTRY=bandb.Country__c;
            yD.BENEFICIARY_BANK_SWIFT_CODE=ac[0].basft__c;
            yD.ROUTING_CODE=ac[0].bfrc__c;
            yD.INTERMEDIARY_BANK_SWIFT_CODE=ac[0].InBcd__c;
            yD.BENEFICIARY_BANK_SORT_CODE=ac[0].bfsc__c;
            yD.EXT_REF_NUMBER='Customer update bank account WRT AXS SR#'+rrr.Name;
            yD.BENEFICIARY_BANK_IFSC_CODE=ac[0].bifc__c;
            String yardiJson = JSON.serialize(yD) ;
            system.debug('XXXXXXXXX-'+fuJson);
            req.xadtx2__c=yardiJson;
            system.debug('req ---'+req);
            if (Schema.sObjectType.g_req__c.isUpdateable()) {
                update req;
            }
            saveAttachment_r();

            //PageReference pageRef = new PageReference('/apex/grfb?id='+req.id+'&sid='+srv.Id);
            reference=new PageReference('/apex/grfb?id='+req.id+'&sid='+srv.Id);
            reference.setRedirect(true);

            //return pageRef;
        }Catch(Exception e) {}
        return reference;
    }

    public PageReference saveAttachment_r() {
        system.debug('in saveAttachment '+req.id);
        List<g_reqDoc__c> reqDoc= [select id, name from g_reqDoc__c where RQ__c=:req.id and name=:docName];
        system.debug('docName --  '+docName);
        system.debug('reqDoc --  '+reqDoc);
        Attachment A = new Attachment(Body = EncodingUtil.base64Decode(imageBase264), Name = docName+'.pdf', ParentId = reqDoc[0].id);
        system.debug('2 A>>>' + A);
        system.debug('A --  '+A);
        if (Schema.sObjectType.Attachment.isCreateable()) {
            insert A;
        }

        Attachment reqA = new Attachment(Body = EncodingUtil.base64Decode(imageBase264), Name = docName+'.pdf', ParentId = Acc.id);
        if (Schema.sObjectType.Attachment.isCreateable()) {
            insert reqA;
        }

        Att yat=new Att();
        yat.Object_type='478';
        yat.Attachment_Type=docName;
        yat.Record_Code='1016051';//cnumber c0042071
        yat.File_name=docName+'.pdf';
        yat.Attachment=imageBase264;
        String fuJson = JSON.serialize(yat) ;
        system.debug('fuJson'+fuJson);

        // gTYardiInvCreation.createBankAccAttYardi(fuJson);

        PageReference reference=new PageReference('/apex/grfb?id='+req.id+'&sid='+srv.Id);
        reference.setRedirect(true);

        return reference;
    }
    public PageReference saveReq() {
        req.sta__c = 'Under Review';
        if (Schema.sObjectType.g_req__c.isCreateable()) {
            upsert req;
        }
        PageReference reference=new PageReference('/apex/grqstatus?id='+req.id);
        reference.setRedirect(true);

        return reference;
    }
    public PageReference saveRF() {
        system.debug('in saveRF -- '+Acc.id);
        try{
            Attachment A = new Attachment(Body = EncodingUtil.base64Decode(imageBase264), Name = 'Bank_Letter.pdf', ParentId = Acc.id);
            system.debug('2 A>>>' + A);
            if (Schema.sObjectType.Attachment.isCreateable()) {
                insert A;
            }

            req.acc__c = Acc.Id;
            req.xadh__c = 'rf;';
            req.sta__C = 'Open';
            Upsert req;

            List<g_reqDoc__c> reqDoc= [select id, name, RQ__r.Name from g_reqDoc__c where RQ__c=:req.id and name='Bank Letter'];

            Attachment reqA = new Attachment(Body = EncodingUtil.base64Decode(imageBase264), Name = 'Bank_Letter.pdf', ParentId = reqDoc[0].id);

            if (Schema.sObjectType.Attachment.isCreateable()) {
                insert reqA;
            }

            Acc.intsts__c = 'Ready for Integration';
            //update Acc;

            List<Account> ac=[select id, ORACLE_PARTY_ID__c, Yardi_Cutsomer_Code__c, bacnm__c,
                banum__c, bandb__r.curcode__c, bandb__r.Name, bandb__r.ccode__c, bandb__r.Branch_Name__c,
                bandb__r.Country__c, iban__c, bknm__c, basft__c, bfsc__c, bifc__c, bfrc__c, InBcd__c from Account where id=:Acc.Id];
            g_req__c rrr=[select id, name from g_req__c where id=:req.id][0];
            adh4 adh = (adh4) JSON.deserialize(req.xadtx4__c, adh4.class);
            ac[0].bandb__c= adh.gbrnlkid;
            ac[0].bacnm__c= adh.g_bacnm;
            ac[0].bknm__c= adh.g_bacnm;
            ac[0].banum__c= adh.g_banum;
            ac[0].iban__c= adh.g_iban;
            ac[0].basft__c= adh.g_basft;
            ac[0].bfrc__c= adh.g_bfrc;
            ac[0].bfsc__c= adh.g_bfsc;
            ac[0].bifc__c= adh.g_bifc;
            ac[0].InBcd__c= adh.inba;

         String gbrnlkid=adh.gbrnlkid;
        b_and_b__c bandb=[select id, Name, Branch_Name__c, ccode__c, Country__c, curcode__c from b_and_b__c where id=:gbrnlkid  limit 1];
        adh.crncy = bandb.ccode__c; adh.bName = bandb.Name; adh.cntry = bandb.Country__c; adh.branch = bandb.Branch_Name__c; req.xadtx4__c = JSON.serialize(adh);

           // List<Account> ac=[select id, ORACLE_PARTY_ID__c, Yardi_Cutsomer_Code__c, bacnm__c, banum__c, bandb__r.curcode__c, bandb__r.Name, bandb__r.ccode__c, bandb__r.Branch_Name__c, bandb__r.Country__c, iban__c, bknm__c, basft__c, bfsc__c, bifc__c, bfrc__c, InBcd__c from Account where id=:Acc.Id];
            BankDetails b=new BankDetails();
            b.BankName=bandb.Name;
            b.BankBranchName=bandb.Branch_Name__c;
            b.BankAccountNumber=ac[0].banum__c;
            b.BankAccountName=ac[0].bacnm__c;
            b.IBAN=ac[0].iban__c;
            b.PrimaryFlag='true';
            b.CountryCode=bandb.ccode__c;
            b.CountryName=bandb.Country__c;
            b.FusionAccountNumber=ac[0].ORACLE_PARTY_ID__c;
            b.CurrencyCode=bandb.curcode__c;
            b.Description='https://integration.dubaiholding.com/ic/builder/rt/DH_SALESFORCE_DOC_DOWNLOAD/live/webApps/bank_letter_attachment_downloader/?call_type=cust&amp;account_number='+
                reqDoc[0].RQ__r.Name;
            /*b.Description='https://dhsoicap-axgfix83p9dp-dx.integration.ocp.oraclecloud.com/ic/builder/rt/DH_Bank_Letter_Attachment_Downloade/live/webApps/bank_letter_attachment_downloader/?call_type=cust&amp;account_number='+reqDoc[0].RQ__r.Name;
            */ b.Routing_Code=ac[0].bfrc__c;
            b.Beneficiary_Bank_Sort_Code=ac[0].bfsc__c;
            b.ifscCode=ac[0].bifc__c;
            b.IntermediaryBankAccountNumber = adh.inba;
            b.IntermediaryBankBankName = adh.inbaName;
            b.IntermediaryBankCountryCode = adh.inbaCntr;
            b.IntermediaryBankBranchNumber = adh.inbaBrnchNum;
            b.IntermediaryBankIBAN = adh.inbaIBAN;
            b.IntermediaryBankBIC = adh.inbaBIC;
            String fuJson = JSON.serialize(b) ;

            Map<String, Object> jsonObj = new Map<String, Object>();
            jsonObj.put('Country Name ', bandb.Country__c);
            jsonObj.put('Currency Code ', bandb.curcode__c);
            jsonObj.put('Intermediary Code ', ac[0].InBcd__c);
            jsonObj.put('IFSC Code ', ac[0].bifc__c);
            jsonObj.put('IBAN ', ac[0].iban__c);
            jsonObj.put('Routing Code ', ac[0].bfrc__c);
            jsonObj.put('Swift Code ', ac[0].basft__c);
            jsonObj.put('Sort Code ', ac[0].bfsc__c);
            jsonObj.put('Bank Account Number ', ac[0].banum__c);
            jsonObj.put('Bank Branch Name ', bandb.Branch_Name__c);
            jsonObj.put('Bank Name ', bandb.Name);
            jsonObj.put('Bank Account Name ', ac[0].bacnm__c);

            String dfuJson = JSON.serialize(jsonObj) ;
            req.xadtx3__c=dfuJson;

            yardiBankDetails yD=new yardiBankDetails();
            yD.YARDI_CUSTOMER_CODE=ac[0].Yardi_Cutsomer_Code__c;
            yD.BENEFICIARY_NAME=ac[0].bacnm__c;
            yD.BENEFICIARY_BANK=bandb.Name;
            yD.CURRENCY_Code=bandb.curcode__c;
            yD.BENEFICIARY_IBAN_NO=ac[0].iban__c;
            yD.BENEFICIARY_ACCOUNT_NO=ac[0].banum__c;
            yD.BENEFICARY_BANK_ADDR1=bandb.Branch_Name__c;
            yD.BENEFICARY_BANK_ADDR2='';
            yD.BENEFICARY_BANK_ADDR3='';
            yD.BENEFICIARY_BANK_COUNTRY=bandb.Country__c;
            yD.BENEFICIARY_BANK_SWIFT_CODE=ac[0].basft__c;
            yD.ROUTING_CODE=ac[0].bfrc__c;
            yD.INTERMEDIARY_BANK_SWIFT_CODE=ac[0].InBcd__c;
            yD.BENEFICIARY_BANK_SORT_CODE=ac[0].bfsc__c;
            yD.EXT_REF_NUMBER='Customer update bank account WRT AXS SR#'+reqDoc[0].RQ__r.Name;
            yD.BENEFICIARY_BANK_IFSC_CODE=ac[0].bifc__c;
            String yardiJson = JSON.serialize(yD) ;

            system.debug('XXXXXXXXX-'+fuJson);
            req.xadtx2__c=yardiJson;
            req.xadtx1__c=fuJson;
            /// gtFussionWs.createBankAcc(xx);

            // String xx='{"": "HSBC", "": "Hong Kong", "": "Main Branch", "": "999998989974291747916", "": "", "": "MBC BANK HSBC HK", "": "ABET3232323322", "": "true", "CountryCode": "HK", "FusionAccountNumber": "TDD-19789"}';
            // String x= gtFussionWs.createBankAcc('{"BankName": "HSBC", "CountryName": "Hong Kong", "BankBranchName": "Main Branch", "BankAccountNumber": "999998989974291747916", "CurrencyCode": "", "BankAccountName": "MBC BANK HSBC HK", "IBAN": "ABET3232323322", "PrimaryFlag": "true", "CountryCode": "HK", "FusionAccountNumber": "TDD-19789"}');
            //    gU.AddErrorMsg(x);

        }catch (Exception e) {system.debug('====e=='+e);system.debug(e.getStackTraceString());}

        PageReference pageRef = new PageReference('/apex/grqStatus');
        pageRef.getParameters().put('id', req.id);

        return pageRef;
    }

    //Get country code -- added by Meenu
    public List < SelectOption > getVfsCountriesOptions() {
        List < SelectOption > countryOptions = new List < SelectOption > ();
        Map < String, String > mapCC = new Map < String, String > {
            'United Arab Emirates' => 'uae',
                'Armenia' => 'xam',
                'Australia' => 'xau',
                'Austria' => 'xat',
                'Azerbaijan' => 'xaz',
                'Bahrain' => 'xbx',
                'Bangladesh' => 'xbd',
                'Belarus' => 'xbl',
                'Belgium' => 'xbe',
                'Bosnia and Herzegovina ' => 'xba',
                'Brazil' => 'xbr',
                'Canada' => 'xca',
                'Czech Republic' => 'czp',
                'Colombia' => 'xco',
                'Cyprus' => 'xcy',
                'Denmark' => 'xdk',
                'Egypt ' => 'ept',
                'Estonia ' => 'xst',
                'France' => 'xfr',
                'Greece' => 'xgr',
                'Georgia' => 'gia',
                'Germany' => 'gmn',
                'Hungary' => 'xhu',
                'Hong Kong' => 'hk',
                'India' => 'xin',
                'Indonesia' => 'ida',
                'Ireland' => 'xie',
                'Italy' => 'xit',
                'Japan' => 'jpn',
                'Jordan' => 'jrn',
                'Kuwait' => 'xkw',
                'Kyrgyzstan' => 'xkg',
                'Kenya' => 'kya',
                'Latvia' => 'xlv',
                'Lebanon' => 'xlb',
                'Luxembourg' => 'xlu',
                'Malaysia' => 'xmy',
                'Mauritius' => 'mts',
                'Morocco' => 'mro',
                'Monacco' => 'xmn',
                'Netherlands' => 'xnl',
                'New Zealand' => 'xnz',
                'Norway' => 'xnw',
                'Nigeria' => 'nga',
                'Oman' => 'xom',
                'Pakistan' => 'xpk',
                'Philippines' => 'xph',
                'Poland' => 'xpl',
                'Portugal' => 'xpt',
                'Qatar' => 'qtr',
                'Romania' => 'rma',
                'Saudi Arabia' => 'xsa',
                'Seychelles' => 'xsc',
                'Spain' => 'xes',
                'Sri Lanka' => 'xsl',
                'Sweden' => 'xse',
                'Switzerland' => 'xch',
                'Singapore' => 'Sge',
                'Slovakia' => 'Ska',
                'South Africa' => 'Saa',
                'South Korea' => 'Ska',
                'Tunisia' => 'xtn',
                'Turkey' => 'xtr',
                'Uzbekistan' => 'xuz',
                'United Kingdom' => 'xuk',
                'United States of America' => 'usa',
                'Venezuela' => 'xve',
                'Vietnam' => 'xvn',
                'Zimbabwe' => 'Zmb'
                };
                    countryOptions.add(new SelectOption('', '--None--'));
        for (String s: mapCC.keySet()) {
            countryOptions.add(new SelectOption(mapCC.get(s), s));
        }
        return countryOptions;
    }
    public Boolean nD {
        get {
            /*if (req.rDocs__r == null || req.rDocs__r.isEmpty()) {
                return false;
            }
            */ for (g_reqDoc__c d: [select id, upOk__c from g_reqDoc__c where RQ__c =: req.id]) {
                if (!d.upOk__c) {
                    return true;
                }
            }
            return false;
        }
    }

    public class BankDetails{

        public String BankName{set;get;}
        public String CountryName{set;get;}
        public String BankBranchName{set;get;}
        public String BankAccountNumber{set;get;}
        public String  CurrencyCode{set;get;}
        public String  BankAccountName{set;get;}
        public String IBAN{set;get;}
        public String PrimaryFlag{set;get;}
        public String CountryCode{set;get;}
        public String FusionAccountNumber{set;get;}// [arty id]
        public String Description{set;get;}
        public String Routing_Code{set;get;}
        public String Beneficiary_Bank_Sort_Code{set;get;}
        public String ifscCode{set;get;}
        public String IntermediaryBankAccountNumber { set; get; }
        public String IntermediaryBankBankName { set; get; }
        public String IntermediaryBankCountryCode { set; get; }
        public String IntermediaryBankBranchNumber { set; get; }
        public String IntermediaryBankIBAN { set; get; }
        public String IntermediaryBankBIC { set; get; }

    }

    public class yardiBankDetails{

        public String YARDI_CUSTOMER_CODE{set;get;}
        public String BENEFICIARY_NAME{set;get;}
        public String BENEFICIARY_BANK{set;get;}
        public String CURRENCY_Code{set;get;}
        public String BENEFICIARY_IBAN_NO{set;get;}
        public String BENEFICIARY_ACCOUNT_NO{set;get;}
        public String BENEFICARY_BANK_ADDR1{set;get;}
        public String BENEFICARY_BANK_ADDR2{set;get;}
        public String BENEFICARY_BANK_ADDR3{set;get;}
        public String BENEFICIARY_BANK_COUNTRY{set;get;}
        public String BENEFICIARY_BANK_SWIFT_CODE{set;get;}
        public String ROUTING_CODE{set;get;}
        public String INTERMEDIARY_BANK_SWIFT_CODE{set;get;}
        public String BENEFICIARY_BANK_SORT_CODE{set;get;}
        public String EXT_REF_NUMBER{set;get;}
        public String BENEFICIARY_BANK_IFSC_CODE{set;get;}

    }

    public class adh4{

        public String  g_bacnm{set;get;}
        public String  bandb{set;get;}
        public String  g_banum{set;get;}
        public String  g_iban{set;get;}
        public String  g_basft{set;get;}
        public String  g_bfrc{set;get;}
        public String  g_bfsc{set;get;}
        public String  g_bifc{set;get;}
        public String  gbrnlkid{set;get;}
        public String  inba{set;get;}
        public String inbaName { set; get; }
        public String inbaCntr { set; get; }
        public String inbaBrnchNum { set; get; }
        public String inbaIBAN { set; get; }
        public String inbaBIC { set; get; }
        public String branch { set; get; }
        public String crncy { set; get; }
        public String bName { set; get; }
        public String cntry { set; get; }
    }

    public class Att{
        Public String     Object_type{set;get;}
        Public String     Attachment_Type{set;get;}
        Public String     Record_Code{set;get;}
        Public String     File_name{set;get;}
        Public String     Attachment{set;get;}

    }

    public class D{
        public string DocName {
            get;
            set;
        }
        public string DocLabel {
            get;
            set;
        }
        public string DocType {
            get;
            set;
        }
        public String tmpltId {
            get;
            set;
        }
        public String attId {
            get;
            set;
        }
        public String attName {
            get;
            set;
        }
        public boolean parse {
            get;
            set;
        }
        public boolean isSaveRQ {
            get;
            set;
        }
        public boolean isOptional {
            get;
            set;
        }
    }

}
public with sharing class ddtectl {
    public g_reqitem__c rqI {
        set;
        get;
    }
    public List < g_reqitemDoc__c > rqIDoc {
        set;
        get;
    }
    /*public String imageURL{
        get;
        set;
    }
    */ public List < Id > photos {
        set;
        get;
    }
    public String dob {
        set;
        get;
    }
    public String pIDate {
        set;
        get;
    }
    public String pEDate {
        set;
        get;
    }
    public String eidaExpDate {
        set;
        get;
    }
    public String rpIDate {
        set;
        get;
    }
    public String rpEDate {
        set;
        get;
    }
    public String ddtConfig {
        set;
        get;
    }
    public String vvOccupation {
        set;
        get;
    }
    public String ovisaNumberP1 {
        set;
        get;
    }
    public String cnar {
        set;
        get;
    }
    public String ovisaNumberP2 {
        set;
        get;
    }
    public String ovisaNumberP3 {
        set;
        get;
    }
    public String visaNumberP1 {
        set;
        get;
    }
    public String visaNumberP2 {
        set;
        get;
    }
    public String visaNumberP3 {
        set;
        get;
    }
    public String visaNumberEidaP3 {
        set;
        get;
    }
    public String visaNumberEidaP4 {
        set;
        get;
    }
    public String vvisaNumberP1 {
        set;
        get;
    }
    public String vvisaNumberP2 {
        set;
        get;
    }
    public String vvisaNumberP3 {
        set;
        get;
    }
    public String spVisaNumberP1 {
        set;
        get;
    }
    public String spVisaNumberP2 {
        set;
        get;
    }
    public String spVisaNumberP3 {
        set;
        get;
    }
    public String spVVisaNumberP1 {
        set;
        get;
    }
    public String spVVisaNumberP2 {
        set;
        get;
    }
    public String spVVisaNumberP3 {
        set;
        get;
    }
    public String ecNoP1 {
        set;
        get;
    }
    public String ecNoP2 {
        set;
        get;
    }
    public String ecNoP3 {
        set;
        get;
    }
    public String ecNoStP3 {
        set;
        get;
    }
    public String spRpExpiryYr {
        set;
        get;
    }
    public String spRpIssueYr {
        set;
        get;
    }
    public String spVRpExpiryYr {
        set;
        get;
    }
    public String spVRpIssueYr {
        set;
        get;
    }
    public String spBirthYr {
        set;
        get;
    }
    public String spVBirthYr {
        set;
        get;
    }
    public String ctBirthYr {
        set;
        get;
    }
    public String spName {
        set;
        get;
    }
    public String spVName {
        set;
        get;
    }
    public String estName {
        set;
        get;
    }
    public String estNameSt {
        set;
        get;
    }
    public String commActivity {
        set;
        get;
    }
    public String stCommActivity {
        set;
        get;
    }
    public String estTypeCode {
        set;
        get;
    }
    public String stEstTypeCode {
        set;
        get;
    }
    public String contactFN {
        set;
        get;
    }
    public String mohAddress {
        set;
        get;
    }
    public String yrsOfResidence {
        set;
        get;
    }
    public String yrsOfTransfer {
        set;
        get;
    }
    public String transType {
        set;
        get;
    }
    public String qlHardCode {
        set;
        get;
    }
    public String occpHardCode {
        set;
        get;
    }
    public String mohOccpHardCode {
        set;
        get;
    }
    public String mohOccpNameHardCode {
        set;
        get;
    }
    public String ioUAE {
        set;
        get;
    }
    public String eidaMobile {
        set;
        get;
    }
    public String eidaSType {
        set;
        get;
    }
    public String eidaYears {
        set;
        get;
    }
    public String workMode {
        set;
        get;
    }
    public List < Attachment > attList {
        set;
        get;
    }
    public List < AttachmentWrapper > attWrapList {
        set;
        get;
    }
    public String att1 {
        set;
        get;
    }
    /*public blob fileb{
        get;
        set;
    }
    */ public Integer totalPhotos {
        get {
            return photos.size();
        }
    }
    public String uid {
        set;
        get;
    }
    public String uidyr {
        set;
        get;
    }
    public integer ageOfContact {
        set;
        get;
    }
    public String OldSponNumber {
        set;
        get;
    }
    public String OldSponNumber1 {
        set;
        get;
    }
    public String OldSponNumber2 {
        set;
        get;
    }
    public String OldSponNumber3 {
        set;
        get;
    }
    private String m_SOQL;
    public ddtectl() {
        initVars();
        init(String.escapeSingleQuotes(ApexPages.CurrentPage().getParameters().get('id')));
    }
    private void initVars() {
        qlHardCode = '1';
        occpHardCode = '1';
        mohOccpHardCode = '1';
        mohOccpHardCode = '1';
        mohOccpNameHardCode = '1';
        visaNumberP1 = '0';
        visaNumberP2 = '0';
        visaNumberP3 = '0';
        spVisaNumberP1 = '0';
        spVisaNumberP2 = '0';
        spVisaNumberP3 = '0';
        spRpIssueYr = '1900';
        spRpExpiryYr = '1900';
        spVVisaNumberP1 = '0';
        spVVisaNumberP2 = '0';
        spVVisaNumberP3 = '0';
        spVRpIssueYr = '1900';
        spVRpExpiryYr = '1900';
        ovisaNumberP1 = '1';
        ovisaNumberP2 = '1';
        ovisaNumberP3 = '1';
        yrsOfTransfer = '1';
        transType = '\'e\'';
        ioUAE = '1';
        ecNoP1 = '0';
        ecNoP2 = '0';
        ecNoP3 = '0';
        eidaSType = '\'N\'';
        eidaYears = '1';
        eidaMobile = '1';
        workMode = '\'Private Sector\'';
        visaNumberEidaP3 = '0';
        visaNumberEidaP4 = '0';
        uid = uidyr = '';
        yrsOfResidence = '1';
        OldSponNumber = '0';
        OldSponNumber1 = '0';
        OldSponNumber2 = '0';
        OldSponNumber1 = '0';
    }
    private void init(id ReqItemId) {
        rqI = [Select Id, xcstrt__c, xcpobx__c, xccty__c, RQ__r.xecnop__c, RQ__r.xecedtp__c,
            RQ__r.xcitn__c, RQ__r.xcmonar__c, RQ__r.xcpipoar__c, RQ__r.xcpobar__c, RQ__r.xcarea__c,
            RQ__r.xaloc__c, RQ__r.xchph__c, RQ__r.xcpobx__c, RQ__r.xccty__c, xceidedt__c, RQ__r.xceidedt__c,
            Name, xf__c, RQ__r.srvc__r.stg__r.itmq__c, RQ__r.xcemrt__c, xcp__c, xcped__c, xcpid__c,
            xcpic__c, xcpip__c, xcnc__c, xcslt__c, xcfn__c, xcmn__c, xcln__c, xcbd__c, RQ__r.xcmob__c,
            RQ__r.Name, RQ__r.Spr__c, RQ__r.Acc__c, RQ__r.Acc__r.ec__c, RQ__r.Acc__r.ecedt__c,
            RQ__r.Acc__r.onar__c, RQ__r.Acc__r.Name, RQ__r.Acc__r.BillingCity, RQ__r.Acc__r.lctp__c,
            RQ__r.Acc__r.BillingPostalCode, RQ__r.Acc__r.Phone, RQ__r.Acc__r.Type, RQ__r.Acc__r.Prk__c,
            RQ__r.xeidav__c, RQ__r.Con__r.Id, RQ__r.Con__r.flnm__c, RQ__r.Con__c, RQ__r.Con__r.FirstName,
            RQ__r.Con__r.FlnAr__c, RQ__r.Con__r.mn__c, RQ__r.Con__r.mnar__c, RQ__r.Con__r.Name,
            RQ__r.Con__r.Email, RQ__r.Con__r.fnar__c, RQ__r.Con__r.LastName, RQ__r.Con__r.lnar__c,
            RQ__r.Con__r.nc__c, RQ__r.Con__r.qc__c, RQ__r.Con__r.ot__c, RQ__r.Con__r.Birthdate,
            RQ__r.Con__r.bp__c, RQ__r.Con__r.bc__c, RQ__r.Con__r.p__c, RQ__r.Con__r.pip__c, RQ__r.Con__r.eid__c,
            RQ__r.Con__r.eed__c, RQ__r.Con__r.pic__c, RQ__r.Con__r.rped__c, RQ__r.Con__r.eidid__c,
            RQ__r.Con__r.eidedt__c, RQ__r.Con__r.eididt__c, RQ__r.Con__r.rpui__c, RQ__r.Con__r.jb__c,
            RQ__r.Con__r.jb__r.moh__c, RQ__r.Con__r.jb__r.jtm__c, RQ__r.Con__r.jb__r.jcm__c,
            RQ__r.Con__r.pid__c, RQ__r.Con__r.ped__c, RQ__r.Con__r.rlg__c, RQ__r.Con__r.ms__c,
            RQ__r.Con__r.np__c, RQ__r.xphid__c, RQ__r.Con__r.MobilePhone, RQ__r.Con__r.HomePhone,
            RQ__r.Con__r.ql__c, RQ__r.Con__r.mon__c, RQ__r.Con__r.lng__c, RQ__r.Con__r.jb__r.name,
            RQ__r.Con__r.jb__r.cd__c, RQ__r.Con__r.Salutation, RQ__r.Con__r.e__c, RQ__r.Con__r.rp__c,
            RQ__r.Con__r.rpid__c, RQ__r.Con__r.fan__c, RQ__r.Con__r.mona__c, RQ__r.Con__r.pipa__c,
            RQ__r.Con__r.bpa__c, RQ__r.Con__r.strt__c, RQ__r.Con__r.pobx__c, RQ__r.Con__r.ha__c,
            RQ__r.Con__r.Spon__r.rp__c, RQ__r.Con__r.Spon__r.e__c, RQ__r.Con__r.Spon__r.FirstName,
            RQ__r.Con__r.Spon__r.rol__c, RQ__r.Con__r.Spon__r.LastName, RQ__r.Con__r.Spon__r.fnar__c,
            RQ__r.Con__r.Spon__r.lnar__c, RQ__r.Con__r.Spon__r.nc__c, RQ__r.Con__r.Spon__r.Salutation,
            RQ__r.Con__r.Spon__r.Birthdate, RQ__r.Con__r.Spon__r.rpid__c, RQ__r.Con__r.Spon__r.rped__c,
            RQ__r.Con__r.Spon__r.p__c, RQ__r.Con__r.Spon__r.ped__c, RQ__r.Con__r.Spon__r.mon__c,
            RQ__r.Con__r.Spon__r.Name, RQ__r.Con__r.rol__c, RQ__r.Con__r.Spon__r.mn__c, RQ__r.Con__r.Spon__r.mnar__c,
            RQ__r.Con__r.emrt__c, RQ__r.Con__r.cty__c, RQ__r.Con__r.area__c, RQ__r.CreatedBy.Email,
            RQ__r.CreatedBy.MobilePhone, sta__r.jscfddt__c, sta__r.itm__r.cd__c, xcjb__r.cd__c,
            RQ__r.xcot__c, RQ__r.e__c, RQ__r.xctp__c, RQ__r.srvc__r.uid__c, RQ__r.xcslt__c, RQ__r.xcbc__c,
            RQ__r.xcjb__r.cd__c, RQ__r.xcpic__c, RQ__r.xcrlg__c, RQ__r.xcms__c, RQ__r.xcnp__c,
            RQ__r.xcql__c, RQ__r.xclng__c, RQ__r.xcmon__c, RQ__r.xcln__c, RQ__r.xclnar__c, RQ__r.xcfn__c,
            RQ__r.xcfnar__c, RQ__r.xcbp__c, RQ__r.xcpip__c, RQ__r.xcp__c, RQ__r.xcpid__c, RQ__r.xcped__c,
            RQ__r.xcbd__c, RQ__r.xcnc__c, RQ__r.xcmn__c, RQ__r.xcmnar__c, RQ__r.Spr__r.Name,
            RQ__r.Spr__r.nc__c, RQ__r.Con__r.Spon__r.MobilePhone, RQ__r.Spr__r.Salutation, RQ__r.xcsrs__c,
            RQ__r.Spr__r.e__c, RQ__r.Spr__r.rp__c, RQ__r.Spr__r.rpid__c, RQ__r.Spr__r.rped__c,
            RQ__r.Spr__r.Birthdate, RQ__r.Con__r.Spon__r.mgs__c, RQ__r.Spr__r.p__c, RQ__r.Spr__r.ped__c,
            RQ__r.Spr__r.mon__c, RQ__r.Spr__r.rol__c, RQ__r.Spr__r.FirstName, RQ__r.Spr__r.mn__c,
            RQ__r.Spr__r.mnar__c, RQ__r.Spr__r.Email, RQ__r.Spr__r.fnar__c, RQ__r.Spr__r.LastName,
            RQ__r.Spr__r.lnar__c, RQ__r.rmob__c, RQ__r.srvc__r.Name, xcjb__c, exp__c, (Select Id,
            Name, Tp__c, reqDoc__r.Name, reqItm__r.itmCd__c, reqDoc__r.Id From itmsDocs__r) from g_reqitem__c where isDeleted = false and id =: ReqItemId limit 1];
        if (rqI.RQ__r.Con__r.homephone != null) {
            rqI.RQ__r.Con__r.homephone = rqI.RQ__r.Con__r.homephone.contains('+') ? rqI.RQ__r.Con__r.homephone.replace('+', '00') : rqI.RQ__r.Con__r.homephone;
        }
        if (rqI.RQ__r.Con__r.nc__c != null && rqI.RQ__r.Con__r.nc__c != '') {
            cnar = [select cnar__c, name from country__c where name =: rqI.RQ__r.Con__r.nc__c limit 1].cnar__c;
        }
        rqIDoc = [Select Id, Name, Tp__c, reqDoc__r.Name, reqItm__r.itmCd__c, reqDoc__r.Id From g_reqitemDoc__c where reqItm__r.RQ__c =: rqI.RQ__r.Id];
        CleanData();
        SetConfigFile();
        /*To Remove ddtConfig = rqI.RQ__r.Con__r.rlg__c == 'Muslim' ?  'ddt_eida_ren_Muslim' : 'ddt_eida_ren';
        eidaSType = '\'Residency renewal - Change sponsor\'';
        eidaYears = '\'On\'';
        workMode = '\'Student\'';
        To Remove*/ System.debug('** rqI size is:' + rqI.Name);
        System.debug('** rqI eed__c:' + rqI.RQ__r.Con__r.eed__c);
        Map < Id, String > docTypeNameFromId = new Map < Id, String > ();
        Map < Id, String > ItemCodeFromId = new Map < Id, String > ();
        Set < Id > Ids = new Set < Id > ();
        /* for (g_reqitemDoc__c itmD: rqI.itmsDocs__r) {
            Ids.add(itmD.reqDoc__r.Id);
            docTypeNameFromId.put(itmD.reqDoc__r.Id, itmD.Tp__c);
            ItemCodeFromId.put(itmD.reqDoc__r.Id, itmD.reqItm__r.itmCd__c);
        }
        */ if (rqI.RQ__r.srvc__r.uid__c == '005' || rqI.RQ__r.srvc__r.uid__c == '006' || rqI.RQ__r.srvc__r.uid__c == '012' || rqI.RQ__r.srvc__r.uid__c == '013' || rqI.RQ__r.srvc__r.uid__c == '045' || rqI.RQ__r.srvc__r.uid__c == '056' || rqI.RQ__r.srvc__r.uid__c == '057' || rqI.RQ__r.srvc__r.uid__c == '009' || rqI.RQ__r.srvc__r.uid__c == '014' || rqI.RQ__r.srvc__r.uid__c == '119' || rqI.RQ__r.srvc__r.uid__c == '046') {
            for (g_reqitemDoc__c itmD: rqIDoc) {
                System.debug('** rqIDoc EIDA:' + itmD.Name + ' code:' + itmD.reqItm__r.itmCd__c);
                /* if (itmD.Name == 'Personal Photo' || itmD.Name == 'Passport Copy' || itmD.Name == 'Eida Card (Front Side)' || itmD.Name == 'Eida Card (Back Side)' || itmD.Name == 'Entry Permit' || itmD.Name == 'Passport with Visa Page') {
                    */ Ids.add(itmD.reqDoc__r.Id);
                /* }
                */ docTypeNameFromId.put(itmD.reqDoc__r.Id, itmD.Tp__c);
                ItemCodeFromId.put(itmD.reqDoc__r.Id, itmD.reqItm__r.itmCd__c);
            }
        }
        else if (rqI.sta__r.itm__r.cd__c == 'ia') {
            for (g_reqitemDoc__c itmD: rqIDoc) {
                System.debug('** rqIDoc EIDA:' + itmD.Name + ' code:' + itmD.reqItm__r.itmCd__c);
                if (itmD.Name == 'Personal Photo' || itmD.Name == 'Passport Copy' || itmD.Name == 'Passport First Page' || itmD.Name == 'Passport Last Page' || itmD.Name == 'Eida Card (Front Side)' || itmD.Name == 'Eida Card (Back Side)' || itmD.Name == 'Entry Permit' || itmD.Name == 'Passport with Visa Page') {
                    Ids.add(itmD.reqDoc__r.Id);
                }
                docTypeNameFromId.put(itmD.reqDoc__r.Id, itmD.Tp__c);
                ItemCodeFromId.put(itmD.reqDoc__r.Id, itmD.reqItm__r.itmCd__c);
            }
        }
        else if (rqI.sta__r.itm__r.cd__c == 'ep') {
            for (g_reqitemDoc__c itmD: rqIDoc) {
                System.debug('** rqIDoc EIDA:' + itmD.Name + ' code:' + itmD.reqItm__r.itmCd__c);
                if (itmD.Name == 'Personal Photo' || itmD.Name == 'Good conduct certificate' || itmD.Name == 'Education Certificate(Attested)' || itmD.Name == 'Passport Copy' || itmD.Name == 'Passport First Page' || itmD.Name == 'Passport Last Page' || itmD.Name == 'Eida Card (Front Side)' || itmD.Name == 'Eida Card (Back Side)' || itmD.Name == 'Visa Copy' || itmD.Name == 'Student Undertaking Letter' || itmD.Name == 'Entry Permit' || itmD.Name == 'Passport with Visa Page') {
                    Ids.add(itmD.reqDoc__r.Id);
                }
                docTypeNameFromId.put(itmD.reqDoc__r.Id, itmD.Tp__c);
                ItemCodeFromId.put(itmD.reqDoc__r.Id, itmD.reqItm__r.itmCd__c);
            }
        }
        else if (rqI.sta__r.itm__r.cd__c == 'rt') {
            for (g_reqitemDoc__c itmD: rqIDoc) {
                System.debug('** rqIDoc EIDA:' + itmD.Name + ' code:' + itmD.reqItm__r.itmCd__c);
                if (itmD.Name == 'Personal Photo' || itmD.Name == 'Good conduct certificate' || itmD.Name == 'Education Certificate(Attested)' || itmD.Name == 'Passport Copy' || itmD.Name == 'Eida Card (Front Side)' || itmD.Name == 'Eida Card (Back Side)' || itmD.Name == 'Visa Copy' || itmD.Name == 'Student Undertaking Letter' || itmD.Name == 'Entry Permit' || itmD.Name == 'Passport with Visa Page' || itmD.Name == 'NOC(In Arabic) letter from Sponsor' || itmD.Name == 'Establishment Card Copy' || itmD.Name == 'EIDA IDN Certificate' || itmD.Name == 'Health Insurance Doc') {
                    Ids.add(itmD.reqDoc__r.Id);
                }
                docTypeNameFromId.put(itmD.reqDoc__r.Id, itmD.Tp__c);
                ItemCodeFromId.put(itmD.reqDoc__r.Id, itmD.reqItm__r.itmCd__c);
            }
        }
        else {
            for (g_reqitemDoc__c itmD: rqIDoc) {
                System.debug('** rqIDoc Except EIDA:' + itmD.Name + ' code:' + itmD.reqItm__r.itmCd__c);
                if (itmD.Name == 'Personal Photo') {
                    Ids.add(itmD.reqDoc__r.Id);
                }
                docTypeNameFromId.put(itmD.reqDoc__r.Id, itmD.Tp__c);
                ItemCodeFromId.put(itmD.reqDoc__r.Id, itmD.reqItm__r.itmCd__c);
            }
        }
        photos = new List < Id > ();
        attList = new List < Attachment > ();
        attWrapList = new List < AttachmentWrapper > ();
        for (Attachment att: [select Id, Name, Body, ParentId from Attachment where ParentId in: Ids]) {
            try {
                photos.Add(att.Id);
                attList.Add(att);
                AttachmentWrapper aWrap = new AttachmentWrapper();
                aWrap.att = att;
                aWrap.attCode = EncodingUtil.base64Encode(att.Body);
                aWrap.reqDocName = docTypeNameFromId.get(att.ParentId);
                aWrap.itemCode = ItemCodeFromId.get(att.ParentId);
                attWrapList.add(aWrap);
            }
            catch (Exception e) {
                System.debug('** Exception while iterating attachments: ' + e);
            }
        }
        ParseVisa();
        ParseVVisa();
        ParseSponsor();
        ParseContact();
        ParseECNo();
        ParseEstName();
        ParseFN();
        ParseMohAddress();
        SetVVOccupation();
        ParseOldSponEstno();
    }
    public void CleanData() {
        try {
            if (rqI.RQ__r.Acc__r.Name != null && rqI.RQ__r.Acc__r.Name != '') {
                if (rqI.RQ__r.Acc__r.Name.contains('\'')) {
                    rqI.RQ__r.Acc__r.Name = rqI.RQ__r.Acc__r.Name.replace('\'', ' ');
                    rqI.RQ__r.Acc__r.Name = '\'' + rqI.RQ__r.Acc__r.Name + '\'';
                }
            }
            if (rqI.RQ__r.Con__r.bp__c != null && rqI.RQ__r.Con__r.bp__c != '') {
                if (rqI.RQ__r.Con__r.bp__c.contains(', ')) {
                    rqI.RQ__r.Con__r.bp__c = rqI.RQ__r.Con__r.bp__c.replace(', ', ' ');
                }
            }
            if (rqI.RQ__r.Con__r.FirstName != null && rqI.RQ__r.Con__r.FirstName != '') {
                if (rqI.RQ__r.Con__r.FirstName.contains('\'')) {
                    rqI.RQ__r.Con__r.FirstName = rqI.RQ__r.Con__r.FirstName.replace('\'', ' ');
                }
                if (rqI.RQ__r.Con__r.FirstName.contains(', ')) {
                    rqI.RQ__r.Con__r.FirstName = rqI.RQ__r.Con__r.FirstName.replace(', ', ' ');
                }
            }
            if (rqI.RQ__r.Con__r.mn__c != null && rqI.RQ__r.Con__r.mn__c != '') {
                if (rqI.RQ__r.Con__r.mn__c.contains('\'')) {
                    rqI.RQ__r.Con__r.mn__c = rqI.RQ__r.Con__r.mn__c.replace('\'', ' ');
                }
                if (rqI.RQ__r.Con__r.mn__c.contains(', ')) {
                    rqI.RQ__r.Con__r.mn__c = rqI.RQ__r.Con__r.mn__c.replace(', ', ' ');
                }
            }
            if (rqI.RQ__r.Con__r.fan__c != null && rqI.RQ__r.Con__r.fan__c != '') {
                if (rqI.RQ__r.Con__r.fan__c.contains('\'')) {
                    rqI.RQ__r.Con__r.fan__c = rqI.RQ__r.Con__r.fan__c.replace('\'', ' ');
                }
                if (rqI.RQ__r.Con__r.fan__c.contains(', ')) {
                    rqI.RQ__r.Con__r.fan__c = rqI.RQ__r.Con__r.fan__c.replace(', ', ' ');
                }
            }
            if (rqI.RQ__r.Con__r.LastName != null && rqI.RQ__r.Con__r.LastName != '') {
                if (rqI.RQ__r.Con__r.LastName.contains('\'')) {
                    rqI.RQ__r.Con__r.LastName = rqI.RQ__r.Con__r.LastName.replace('\'', ' ');
                }
                if (rqI.RQ__r.Con__r.LastName.contains(', ')) {
                    rqI.RQ__r.Con__r.LastName = rqI.RQ__r.Con__r.LastName.replace(', ', ' ');
                }
            }
        }
        catch (Exception e) {
            System.debug('** Exception while CleanData(): ' + e);
        }
    }
    public String rqIJS {
        get {
            return JSON.serialize(rqI);
        }
    }
    public String attJS {
        get {
            return JSON.serialize(attWrapList);
        }
    }
    public class AttachmentWrapper {
        public Attachment att {
            set;
            get;
        }
        public String attCode {
            set;
            get;
        }
        public String reqDocName {
            set;
            get;
        }
        public String itemCode {
            set;
            get;
        }
        public AttachmentWrapper() {
            att = new Attachment();
        }
    }
    public void ParseSponsor() {
        try {
            if (rqI.RQ__r.Con__r.Spon__r.Name != null && rqI.RQ__r.Con__r.Spon__r.Name != '') {
                spName = rqI.RQ__r.Con__r.Spon__r.Name;
            }
            else if (rqI.RQ__r.Acc__r.Name != null && rqI.RQ__r.Acc__r.Name != '') {
                spName = rqI.RQ__r.Acc__r.Name;
            }
        }
        catch (Exception e) {
            System.debug('** Exception while ParseSponsor(): ' + e);
        }
    }
    public void ParseContact() {
        try {
            if (rqI.RQ__r.Con__r.Birthdate != null) {
                Date ctBirthDate = rqI.RQ__r.Con__r.Birthdate;
                dob = ctBirthDate.format();
                ctBirthYr = String.valueOf(ctBirthDate.year());
            }
            else {
                ctBirthYr = '1900';
            }
            if (rqI.RQ__r.Con__r.Birthdate != null) {
                ageOfContact = integer.valueOf(Math.FLOOR(rqI.RQ__r.Con__r.Birthdate.daysBetween(Date.TODAY()) / 365.2425));
            }
            if (rqi.RQ__r.Con__r.pid__c != null) {
                Date ctIssueDate = rqI.RQ__r.xcpid__c;
                pIDate = ctIssueDate.format();
            }
            if (rqi.RQ__r.Con__r.ped__c != null) {
                Date ctExpiryDate = rqI.RQ__r.xcped__c;
                pEDate = ctExpiryDate.format();
            }
            if (rqi.RQ__r.Con__r.eidid__c != null) {
                Date eidaEDate = rqI.RQ__r.xceidedt__c != null ? rqI.RQ__r.xceidedt__c : rqI.RQ__r.Con__r.eidedt__c;
                eidaExpDate = eidaEDate.format();
            }
            if (rqi.RQ__r.Con__r.rpid__c != null) {
                Date ctIssueDate = rqI.RQ__r.Con__r.rpid__c;
                rpIDate = ctIssueDate.format();
            }
            if (rqi.RQ__r.Con__r.rped__c != null) {
                Date ctIssueDate = rqI.RQ__r.Con__r.rped__c;
                rpEDate = ctIssueDate.format();
            }
            if (rqI.RQ__r.Con__r.MobilePhone != null && rqI.RQ__r.Con__r.MobilePhone != '') {
                eidaMobile = '\'' + rqI.RQ__r.Con__r.MobilePhone + '\'';
            }
            else if (rqI.RQ__r.CreatedBy.MobilePhone != null && rqI.RQ__r.CreatedBy.MobilePhone != '') {
                eidaMobile = '\'' + rqI.RQ__r.CreatedBy.MobilePhone + '\'';
            }
            else {
                eidaMobile = '0';
            }
            if (rqI.RQ__r.Con__r.rol__c != null && rqI.RQ__r.Con__r.rol__c != '') {
                if (rqI.RQ__r.Con__r.rol__c == 'Spouse') {
                    qlHardCode = '304';
                    occpHardCode = '9900011';
                    mohOccpHardCode = '7458';
                    mohOccpNameHardCode = '\'HOUSEWIFE\'';
                }
                else if (rqI.RQ__r.Con__r.rol__c == 'Student') {
                    qlHardCode = '101';
                    occpHardCode = '9900015';
                    mohOccpHardCode = '112';
                    mohOccpNameHardCode = '\'STUDENT\'';
                }
                else if (rqI.RQ__r.Con__r.rol__c == 'Child') {
                    qlHardCode = '101';
                    occpHardCode = '9900015';
                    mohOccpHardCode = '112';
                    mohOccpNameHardCode = '\'STUDENT\'';
                }
                else if (rqI.RQ__r.Con__r.rol__c == 'Housemaid') {
                    qlHardCode = '350';
                    occpHardCode = '5132075';
                    mohOccpHardCode = '4832';
                    mohOccpNameHardCode = '\'NONE\'';
                }
                else {
                    qlHardCode = '1';
                    occpHardCode = '1';
                    mohOccpHardCode = '1';
                    mohOccpHardCode = '1';
                    mohOccpNameHardCode = '1';
                }
            }
            else {
                qlHardCode = '1';
                occpHardCode = '1';
                mohOccpHardCode = '1';
                mohOccpHardCode = '1';
                mohOccpNameHardCode = '1';
            }
        }
        catch (Exception e) {
            System.debug('** Exception while ParseContact(): ' + e);
        }
    }
    public void ParseVVisa() {
        try {
            if (rqI.RQ__r.e__c != null && rqI.RQ__r.e__c != '') {
                string[] visaNumber = rqI.RQ__r.e__c.split('/');
                vvisaNumberP1 = visaNumber[0];
                vvisaNumberP2 = visaNumber[1];
                vvisaNumberP3 = visaNumber[2];
            }
            else {
                vvisaNumberP1 = '1';
                vvisaNumberP2 = '1';
                vvisaNumberP3 = '1';
            }
        }
        catch (Exception e) {
            System.debug('** Exception while retreiving visa: ' + e);
        }
    }
    public void ParseOldSponEstno() {
        try {
            if (rqI.RQ__r.xecnop__c != null && rqI.RQ__r.xecnop__c != '') {
                string[] OldSponNumber = rqI.RQ__r.xecnop__c.split('/');
                /***string OldSponNumber = '26204739';
                OldSponNumber1 = OldSponNumber.substring(0, 1);
                OldSponNumber2 = OldSponNumber.substring(1, 2);
                OldSponNumber3 = OldSponNumber.substring(2, 8);
                ***/ OldSponNumber1 = OldSponNumber[0];
                OldSponNumber2 = OldSponNumber[1];
                OldSponNumber3 = OldSponNumber[2];
            }
            else {
                OldSponNumber1 = '1';
                OldSponNumber2 = '1';
                OldSponNumber3 = '1';
            }
        }
        catch (Exception e) {
            System.debug('** Exception while retreiving OldSponEstNo: ' + e);
        }
    }
    public void ParseVisa() {
        try {
            if (rqI.RQ__r.Con__r.rp__c != null && rqI.RQ__r.Con__r.rp__c != '') {
                string[] visaNumber = rqI.RQ__r.Con__r.rp__c.split('/');
                visaNumberP1 = visaNumber[0];
                visaNumberP2 = visaNumber[1];
                visaNumberP3 = visaNumber[2];
                visaNumberEidaP3 = visaNumberP3.substring(0, 1);
                visaNumberEidaP4 = '\'' + visaNumberP3.substring(1) + '\'';
                System.debug('** visaNumberEidaP4:' + visaNumberEidaP4);
            }
            else if (rqI.RQ__r.Con__r.e__c != null && rqI.RQ__r.Con__r.e__c != '') {
                string[] visaNumber = rqI.RQ__r.Con__r.e__c.split('/');
                visaNumberP1 = visaNumber[0];
                visaNumberP2 = visaNumber[1];
                visaNumberP3 = visaNumber[2];
                visaNumberEidaP3 = visaNumberP3.substring(0, 1);
                visaNumberEidaP4 = '\'' + visaNumberP3.substring(1) + '\'';
            }
            else if (rqI.RQ__r.e__c != null && rqI.RQ__r.e__c != '') {
                string[] visaNumber = rqI.RQ__r.e__c.split('/');
                visaNumberP1 = visaNumber[0];
                visaNumberP2 = visaNumber[1];
                visaNumberP3 = visaNumber[2];
                visaNumberEidaP3 = visaNumberP3.substring(0, 1);
                visaNumberEidaP4 = '\'' + visaNumberP3.substring(1) + '\'';
            }
            else {
                visaNumberP1 = '1';
                visaNumberP2 = '1';
                visaNumberP3 = '1';
                spRpIssueYr = '1900';
                spRpExpiryYr = '1900';
            }
            if (rqI.RQ__r.Con__r.rped__c != null) {
                Double daysBet = Date.today().daysBetween(rqI.RQ__r.Con__r.rped__c);
                System.debug('** Years (daysBet):' + daysBet.format());
                Double years = daysBet / 365;
                System.debug('** Years:' + years.format());
                if (years <= 1) {
                    yrsOfResidence = '1';
                }
                else if (years > 1 && years <= 2) {
                    yrsOfResidence = '2';
                }
                else if (years > 2) {
                    yrsOfResidence = '3';
                }
                else {
                    yrsOfResidence = '1';
                }
            }
            else {
                yrsOfResidence = '1';
            }
        }
        catch (Exception e) {
            System.debug('** Exception while retreiving Contact visa: ' + e);
            visaNumberP1 = '1';
            visaNumberP2 = '1';
            visaNumberP3 = '1';
            spRpIssueYr = '1900';
            spRpExpiryYr = '1900';
        }
        try {
            System.debug('*** rqI.RQ__r.Con__r.Spon__r.rp__c:' + rqI.RQ__r.Con__r.Spon__r.rp__c);
            if (rqI.RQ__r.Con__r.Spon__r.rp__c != null && rqI.RQ__r.Con__r.Spon__r.rp__c != '') {
                string[] visaNumber = rqI.RQ__r.Con__r.Spon__r.rp__c.split('/');
                spVisaNumberP1 = visaNumber[0];
                spVisaNumberP2 = visaNumber[1];
                spVisaNumberP3 = visaNumber[2];
            }
            else if (rqI.RQ__r.Con__r.Spon__r.e__c != null && rqI.RQ__r.Con__r.Spon__r.e__c != '') {
                string[] visaNumber = rqI.RQ__r.Con__r.Spon__r.e__c.split('/');
                spVisaNumberP1 = visaNumber[0];
                spVisaNumberP2 = visaNumber[1];
                spVisaNumberP3 = visaNumber[2];
            }
            else {
                spVisaNumberP1 = '1';
                spVisaNumberP2 = '1';
                spVisaNumberP3 = '1';
            }
            if (rqI.RQ__r.Con__r.Spon__r.rpid__c != null && rqI.RQ__r.Con__r.Spon__r.rped__c != null) {
                Date rpIssueDate = rqI.RQ__r.Con__r.Spon__r.rpid__c;
                Date rpExpiryDate = rqI.RQ__r.Con__r.Spon__r.rped__c;
                spRpIssueYr = String.valueOf(rpIssueDate.year());
                spRpExpiryYr = String.valueOf(rpExpiryDate.year());
            }
            else {
                spRpIssueYr = '1900';
                spRpExpiryYr = '1900';
            }
            if (rqI.RQ__r.Con__r.Spon__r.Birthdate != null) {
                Date spBirthDate = rqI.RQ__r.Con__r.Spon__r.Birthdate;
                spBirthYr = String.valueOf(spBirthDate.year());
            }
            else {
                spBirthYr = '1900';
            }
        }
        catch (Exception e) {
            System.debug('** Exception while retreiving Contact -> Sponsor visa: ' + e);
            spVisaNumberP1 = '1';
            spVisaNumberP2 = '1';
            spVisaNumberP3 = '1';
            spRpIssueYr = '1900';
            spRpExpiryYr = '1900';
            spBirthYr = '1900';
        }
        try {
            System.debug('** sp rp:' + rqI.RQ__r.Spr__r.rp__c);
            if (rqI.RQ__r.Spr__r.rp__c != null && rqI.RQ__r.Spr__r.rp__c != '') {
                string[] visaNumber = rqI.RQ__r.Spr__r.rp__c.split('/');
                spVVisaNumberP1 = visaNumber[0];
                spVVisaNumberP2 = visaNumber[1];
                spVVisaNumberP3 = visaNumber[2];
                Date rpIssueDate = rqI.RQ__r.Spr__r.rpid__c;
                Date rpExpiryDate = rqI.RQ__r.Spr__r.rped__c;
                Date spVBirthDate = rqI.RQ__r.Spr__r.Birthdate;
                if (rpIssueDate != null) {
                    spVRpIssueYr = String.valueOf(rpIssueDate.year());
                }
                if (rpExpiryDate != null) {
                    spVRpExpiryYr = String.valueOf(rpExpiryDate.year());
                }
                if (spVBirthDate != null) {
                    spVBirthYr = String.valueOf(spVBirthDate.year());
                }
            }
            else if (rqI.RQ__r.Spr__r.e__c != null && rqI.RQ__r.Spr__r.e__c != '') {
                string[] visaNumber = rqI.RQ__r.Spr__r.e__c.split('/');
                spVVisaNumberP1 = visaNumber[0];
                spVVisaNumberP2 = visaNumber[1];
                spVVisaNumberP3 = visaNumber[2];
            }
            else {
                spVVisaNumberP1 = '1';
                spVVisaNumberP2 = '1';
                spVVisaNumberP3 = '1';
                spVRpIssueYr = '1900';
                spVRpExpiryYr = '1900';
            }
        }
        catch (Exception e) {
            System.debug('** Exception while retreiving sp visit visa: ' + e);
            spVVisaNumberP1 = '1';
            spVVisaNumberP2 = '1';
            spVVisaNumberP3 = '1';
            spVRpIssueYr = '1900';
            spVRpExpiryYr = '1900';
        }
    }
    public void ParseECNo() {
        try {
            System.debug('** rqI.RQ__r.Acc__r.ec__c:' + rqI.RQ__r.Acc__r.ec__c);
            if (rqI.RQ__r.Acc__r.ec__c != null && rqI.RQ__r.Acc__r.ec__c != '') {
                string[] ecNo = rqI.RQ__r.Acc__r.ec__c.split('/');
                ecNoP1 = ecNo[0];
                ecNoP2 = ecNo[1];
                ecNoP3 = ecNo[2];
            }
            else {
                ecNoP1 = '1';
                ecNoP2 = '1';
                ecNoP3 = '1';
            }
            System.debug('** ecNoP1:' + ecNoP1);
            System.debug('** ecNoP2:' + ecNoP2);
            System.debug('** ecNoP3:' + ecNoP3);
        }
        catch (Exception e) {
            System.debug('** Exception while retreiving ecno: ' + e);
            ecNoP1 = '1';
            ecNoP2 = '1';
            ecNoP3 = '1';
        }
    }
    public void ParseFN() {
        try {
            if (rqI.RQ__r.Con__r.mn__c == null || rqI.RQ__r.Con__r.mn__c == '') {
                contactFN = '\'' + rqI.RQ__r.Con__r.FirstName + ' ' + rqI.RQ__r.Con__r.LastName + '\'';
            }
            else {
                contactFN = '\'' + rqI.RQ__r.Con__r.FirstName + ' ' + rqI.RQ__r.Con__r.mn__c + ' ' + rqI.RQ__r.Con__r.LastName + '\'';
            }
        }
        catch (Exception e) {
            System.debug('** Exception while ParseFN(): ' + e);
            contactFN = '\'' + 'NF' + '\'';
        }
    }
    public void ParseMohAddress() {
        try {
            if (rqI.RQ__r.Name == null || rqI.RQ__r.Name == '') {
                mohAddress = '\'73000 Dubai UAE\'';
            }
            else {
                mohAddress = '\'73000 Dubai UAE' + ' ' + rqI.RQ__r.Name + '\'';
            }
        }
        catch (Exception e) {
            System.debug('** Exception while ParseFN(): ' + e);
            mohAddress = '\'' + 'NF' + '\'';
        }
    }
    public void ParseEstName() {
        try {
            if (rqI.RQ__r.Acc__r.Type != null && rqI.RQ__r.Acc__r.Prk__c != null && rqI.RQ__r.Acc__r.Type != '' && rqI.RQ__r.Acc__r.Prk__c != '') {
                if (rqI.RQ__r.Acc__r.Prk__c == 'Dubai Healthcare City') {
                    ecNoStP3 = '28';
                    estNameSt = '\'Dubai Health Care City\'';
                    stEstTypeCode = '2';
                    stCommActivity = '\'GOVERNMENT\'';
                    if (rqI.RQ__r.Acc__r.Type == 'Customer - Internal') {
                        estName = '\'Dubai Health Care City\'';
                        ecNoP3 = '28';
                        commActivity = '\'GOVERNMENT\'';
                        estTypeCode = '2';
                    }
                    else {
                        estName = '\'' + rqI.RQ__r.Acc__r.Name + ' DHCC' + '\'';
                        commActivity = '\'FREE ZONE\'';
                        estTypeCode = '6';
                    }
                }
                else if (rqI.RQ__r.Acc__r.Prk__c != 'Dubai Healthcare City') {
                    /*ecNoStP3 = '27';
                    estNameSt = '\'Dubai Knowledge Park\'';
                    stCommActivity = '\'GOVERNMENT\'';
                    stEstTypeCode = '2';
                    */ ecNoStP3 = ecNoP3;
                    estNameSt = '\'' + rqI.RQ__r.Acc__r.Name + ' '+gu.csStr('ddteEstName') + '\'';
                    stCommActivity = '\'FREE ZONE\'';
                    stEstTypeCode = '6';
                    if (rqI.RQ__r.Acc__r.Type == 'Customer - Internal') {
                        estName = '\''+gu.csStr('ddteEstName')+'\'';
                        ecNoP3 = '64';
                        commActivity = '\'GOVERNMENT\'';
                        estTypeCode = '2';
                    }
                    else {
                        estName = '\'' + rqI.RQ__r.Acc__r.Name + ' Tecom Authority' + '\'';
                        commActivity = '\'FREE ZONE\'';
                        estTypeCode = '6';
                    }
                }
                else {
                    estName = '\'NF\'';
                    estNameSt = '\'NF\'';
                    commActivity = '\'NF\'';
                    stCommActivity = '\'NF\'';
                    stEstTypeCode = '1';
                    estTypeCode = '1';
                }
                if (estName.contains('\'')) {
                    estName = estName.replace('\'', '');
                    estName = '\'' + estName + '\'';
                }
                System.debug('** estName:' + estName);
                System.debug('** estNameSt:' + estNameSt);
            }
        }
        catch (Exception e) {
            System.debug('** Exception while retreiving est name: ' + e);
            estName = '\'NF\'';
            estNameSt = '\'NF\'';
            commActivity = '\'NF\'';
            stCommActivity = '\'NF\'';
            stEstTypeCode = '1';
            estTypeCode = '1';
        }
    }
    public void SetVVOccupation() {
        try {
            if (rqI.RQ__r.xcsrs__c == null || rqI.RQ__r.xcsrs__c == '') {
                vvOccupation = '2';
            }
            else if (rqI.RQ__r.xcsrs__c == 'Spouse' && (rqI.RQ__r.xcslt__c == 'Mrs.' || rqI.RQ__r.xcslt__c == 'Ms.')) {
                vvOccupation = '9900011';
            }
            else {
                vvOccupation = '2';
            }
            System.debug('** vvOccupation:' + vvOccupation);
        }
        catch (Exception e) {
            System.debug('** Exception while SetVVOccupation(): ' + e);
            vvOccupation = '2';
        }
    }
    public void SetConfigFile() {
        try {
            uid = rqI.RQ__r.srvc__r.uid__c;
            uidyr = (uid == '045' || uid == '056' || uid == '005' || uid == '012') ? '3' : ((uid == '119' || uid == '138' || uid == '139') ? '1' : '');
            if (rqI.sta__r.itm__r.cd__c == 'ia') {
                if (rqI.RQ__r.xeidav__c == 'No') {
                    if (uid == '003' || uid == '040' || uid == '020' || uid == '001') {
                        /*Employee Visa for 3 years*/ ddtConfig = rqI.RQ__r.Con__r.rlg__c == 'Muslim' ? 'ddt_eida_new_Muslim' : 'ddt_eida_new';
                        eidaSType = '\'New Residency\'';
                        eidaYears = '\'Th\'';
                        workMode = '\'Private Sector\'';
                    }
                    if (uid == '002' || uid == '021' || uid == '004' || uid == '078') {
                        /*Employee Visa for 1 year*/ ddtConfig = rqI.RQ__r.Con__r.rlg__c == 'Muslim' ? 'ddt_eida_new_Muslim' : 'ddt_eida_new';
                        eidaSType = '\'New Residency\'';
                        eidaYears = '\'On\'';
                        workMode = '\'Private Sector\'';
                    }
                    if (uid == '016' || uid == '055') {
                        /*Employee Visa Renewal for 3 years*/ ddtConfig = rqI.RQ__r.Con__r.rlg__c == 'Muslim' ? 'ddt_eida_ren_Muslim' : 'ddt_eida_ren';
                        /* eidaSType = '\'Residency Renewal - Same Sponsor\'';
                        */ eidaSType = '\'RR\'';
                        eidaYears = '\'Th\'';
                        workMode = '\'Private Sector\'';
                    }
                    if (uid == '105' || uid == '106') {
                        /*Employee Visa Renewal for 1 year*/ ddtConfig = rqI.RQ__r.Con__r.rlg__c == 'Muslim' ? 'ddt_eida_ren_Muslim' : 'ddt_eida_ren';
                        eidaSType = '\'Residency Renewal - Same Sponsor\'';
                        eidaYears = '\'On\'';
                        workMode = '\'Private Sector\'';
                    }
                    if (uid == '010' || uid == '025' || uid == '027' || uid == '080' || uid == '188' || uid == '189' || uid == '190' || uid == '191' || uid == '192' || uid == '193') {
                        /*Employee Transfer for 3 years*/ ddtConfig = rqI.RQ__r.Con__r.rlg__c == 'Muslim' ? 'ddt_eida_ren_intTransfer_Muslim' : 'ddt_eida_ren_intTransfer';
                        eidaSType = '\'Residency renewal - Change sponsor\'';
                        eidaYears = '\'Th\'';
                        workMode = '\'Private Sector\'';
                    }
                    if (uid == '015' || uid == '026' || uid == '028' || uid == '081') {
                        /*Employee Transfer for 1 year*/ ddtConfig = rqI.RQ__r.Con__r.rlg__c == 'Muslim' ? 'ddt_eida_ren_intTransfer_Muslim' : 'ddt_eida_ren_intTransfer';
                        eidaSType = '\'Residency renewal - Change sponsor\'';
                        eidaYears = '\'On\'';
                        workMode = '\'Private Sector\'';
                    }
                    if (uid == '103') {
                        /*Employee Internal Transfer(within freezone)*/ ddtConfig = rqI.RQ__r.Con__r.rlg__c == 'Muslim' ? 'ddt_eida_ren_intTransfer_Muslim' : 'ddt_eida_ren_intTransfer';
                        eidaSType = '\'Residency renewal - Change sponsor\'';
                        eidaYears = '\'Th\'';
                        workMode = '\'Private Sector\'';
                    }
                    if (uid == '005' || uid == '012') {
                        /*Spouse Visa for 3 years*/ ddtConfig = rqI.RQ__r.Con__r.rlg__c == 'Muslim' ? 'ddt_eida_new_Muslim' : 'ddt_eida_new';
                        eidaSType = '\'New Residency\'';
                        eidaYears = '\'Th\'';
                        workMode = '\'Not Working\'';
                    }
                    /*Spouse Visa for 1 year*/ /*TODO*/ if (uid == '045' || uid == '056') {
                        /*Spouse Visa Renewal for 3 years*/ ddtConfig = rqI.RQ__r.Con__r.rlg__c == 'Muslim' ? 'ddt_eida_ren_Muslim' : 'ddt_eida_ren';
                        eidaSType = '\'Residency Renewal - Same Sponsor\'';
                        eidaYears = '\'Th\'';
                        workMode = '\'Not Working\'';
                    }
                    if (uid == '119') {
                        /*Spouse Visa Renewal for 1 year*/ ddtConfig = rqI.RQ__r.Con__r.rlg__c == 'Muslim' ? 'ddt_eida_ren_Muslim' : 'ddt_eida_ren';
                        eidaSType = '\'Residency Renewal - Same Sponsor\'';
                        eidaYears = '\'On\'';
                        workMode = '\'Not Working\'';
                    }
                    if (uid == '023' || uid == '018') {
                        /*Spouse Visa Transfer for 3 years*/ ddtConfig = rqI.RQ__r.Con__r.rlg__c == 'Muslim' ? 'ddt_eida_ren_intTransfer_Muslim' : 'ddt_eida_ren_intTransfer';
                        eidaSType = '\'Residency renewal - Change sponsor\'';
                        eidaYears = '\'Th\'';
                        workMode = '\'Not Working\'';
                    }
                    if (uid == '117') {
                        /*Spouse Visa Transfer for 1 year*/ ddtConfig = rqI.RQ__r.Con__r.rlg__c == 'Muslim' ? 'ddt_eida_ren_intTransfer_Muslim' : 'ddt_eida_ren_intTransfer';
                        eidaSType = '\'Residency renewal - Change sponsor\'';
                        eidaYears = '\'On\'';
                        workMode = '\'Not Working\'';
                    }
                    if (uid == '006' || uid == '013') {
                        /*Child Visa for 3 years*/ ddtConfig = rqI.RQ__r.Con__r.rlg__c == 'Muslim' ? 'ddt_eida_new_Muslim' : 'ddt_eida_new';
                        eidaSType = '\'New Residency\'';
                        eidaYears = '\'Th\'';
                        workMode = '\'Not Working\'';
                    }
                    /*Child Visa for 1 year*/ /*TODO*/ if (uid == '046' || uid == '057') {
                        /*Child Visa Renewal for 3 years*/ ddtConfig = rqI.RQ__r.Con__r.rlg__c == 'Muslim' ? 'ddt_eida_ren_Muslim' : 'ddt_eida_ren';
                        eidaSType = '\'Residency Renewal - Same Sponsor\'';
                        eidaYears = '\'Th\'';
                        workMode = '\'Not Working\'';
                    }
                    if (uid == '120') {
                        /*Child Visa Renewal for 1 year*/ ddtConfig = rqI.RQ__r.Con__r.rlg__c == 'Muslim' ? 'ddt_eida_ren_Muslim' : 'ddt_eida_ren';
                        eidaSType = '\'Residency Renewal - Same Sponsor\'';
                        eidaYears = '\'On\'';
                        workMode = '\'Not Working\'';
                    }
                    /*Child Visa Transfer for 3 years*/ if (uid == '017' || uid == '024') {
                        ddtConfig = rqI.RQ__r.Con__r.rlg__c == 'Muslim' ? 'ddt_eida_ren_intTransfer_Muslim' : 'ddt_eida_ren_intTransfer';
                        eidaSType = '\'Residency renewal - Change sponsor\'';
                        eidaYears = '\'Th\'';
                        workMode = '\'Not Working\'';
                    }
                    /*Child Visa Transfer for 1 year*/ if (uid == '118') {
                        ddtConfig = rqI.RQ__r.Con__r.rlg__c == 'Muslim' ? 'ddt_eida_ren_intTransfer_Muslim' : 'ddt_eida_ren_intTransfer';
                        eidaSType = '\'Residency renewal - Change sponsor\'';
                        eidaYears = '\'On\'';
                        workMode = '\'Not Working\'';
                    }
                    /*Newborn Visa for 3 years*/ if (uid == '009' || uid == '014') {
                        ddtConfig = 'ddt_eida_new';
                        eidaSType = '\'New Residency\'';
                        eidaYears = '\'Th\'';
                        workMode = '\'Not Working\'';
                    }
                    /*Newborn Visa for 1 year*/ /*TODO*/ /*Housemaid Visa for 2 years*/ if (uid == '008') {
                        ddtConfig = rqI.RQ__r.Con__r.rlg__c == 'Muslim' ? 'ddt_eida_new_Muslim' : 'ddt_eida_new';
                        eidaSType = '\'New Residency\'';
                        eidaYears = '\'Tw\'';
                        workMode = '\'Private Sector\'';
                    }
                    /*Housemaid Visa for 1 year*/ if (uid == '007') {
                        ddtConfig = rqI.RQ__r.Con__r.rlg__c == 'Muslim' ? 'ddt_eida_new_Muslim' : 'ddt_eida_new';
                        eidaSType = '\'New Residency\'';
                        eidaYears = '\'On\'';
                        workMode = '\'Private Sector\'';
                    }
                    /*Housemaid Visa Renewal for 2 years*/ if (uid == '049') {
                        ddtConfig = rqI.RQ__r.Con__r.rlg__c == 'Muslim' ? 'ddt_eida_ren_Muslim' : 'ddt_eida_ren';
                        eidaSType = '\'Residency Renewal - Same Sponsor\'';
                        eidaYears = '\'Tw\'';
                        workMode = '\'Private Sector\'';
                    }
                    /*Housemaid Visa Renewal for 1 year*/ if (uid == '047') {
                        ddtConfig = rqI.RQ__r.Con__r.rlg__c == 'Muslim' ? 'ddt_eida_ren_Muslim' : 'ddt_eida_ren';
                        eidaSType = '\'Residency Renewal - Same Sponsor\'';
                        eidaYears = '\'On\'';
                        workMode = '\'Private Sector\'';
                    }
                    /*Student Visa for 1 year*/ if (uid == '011' || uid == '022') {
                        ddtConfig = rqI.RQ__r.Con__r.rlg__c == 'Muslim' ? 'ddt_eida_new_Muslim' : 'ddt_eida_new';
                        eidaSType = '\'New Residency\'';
                        eidaYears = '\'On\'';
                        workMode = '\'Student\'';
                    }
                    /*Student Visa Renewal for 1 year*/ if (uid == '044' || uid == '082') {
                        ddtConfig = rqI.RQ__r.Con__r.rlg__c == 'Muslim' ? 'ddt_eida_ren_Muslim' : 'ddt_eida_ren';
                        eidaSType = '\'Residency Renewal - Same Sponsor\'';
                        eidaYears = '\'On\'';
                        workMode = '\'Student\'';
                    }
                    /*Student Visa Transfer for 1 year*/ if (uid == '019' || uid == '029') {
                        ddtConfig = rqI.RQ__r.Con__r.rlg__c == 'Muslim' ? 'ddt_eida_ren_intTransfer_Muslim' : 'ddt_eida_ren_intTransfer';
                        eidaSType = '\'Residency renewal - Change sponsor\'';
                        eidaYears = '\'On\'';
                        workMode = '\'Student\'';
                    }
                }
                else if (rqI.RQ__r.xeidav__c == 'Yes' || rqI.RQ__r.xeidav__c == 'Lost') {
                    /*Employee Visa for 3 years*/ if (uid == '003' || uid == '040' || uid == '020' || uid == '021' || uid == '078' || uid == '001') {
                        ddtConfig = rqI.RQ__r.Con__r.rlg__c == 'Muslim' ? 'ddt_eida_ren_rp_new_Muslim' : 'ddt_eida_ren_rp_new';
                        eidaSType = '\'New Residency\'';
                        eidaYears = '\'Th\'';
                        workMode = '\'Private Sector\'';
                    }
                    /*Employee Visa for 1 year*/ if (uid == '002' || uid == '021' || uid == '004' || uid == '078') {
                        ddtConfig = rqI.RQ__r.Con__r.rlg__c == 'Muslim' ? 'ddt_eida_ren_chg_spon_Muslim' : 'ddt_eida_ren_chg_spon';
                        eidaSType = '\'Residency renewal - Change sponsor\'';
                        eidaYears = '\'On\'';
                        workMode = '\'Private Sector\'';
                    }
                    /*Employee Visa Renewal for 3 years*/ if (uid == '016' || uid == '055') {
                        ddtConfig = rqI.RQ__r.Con__r.rlg__c == 'Muslim' ? 'ddt_eida_ren_Muslim' : 'ddt_eida_ren';
                        eidaSType = '\'Residency Renewal - Same Sponsor\'';
                        eidaYears = '\'Th\'';
                        workMode = '\'Private Sector\'';
                    }
                    /*Employee Visa Renewal for 1 year*/ if (uid == '105' || uid == '106') {
                        ddtConfig = rqI.RQ__r.Con__r.rlg__c == 'Muslim' ? 'ddt_eida_ren_Muslim' : 'ddt_eida_ren';
                        eidaSType = '\'Residency Renewal - Same Sponsor\'';
                        eidaYears = '\'On\'';
                        workMode = '\'Private Sector\'';
                    }
                    /*Employee Transfer for 3 years*/ if (uid == '010' || uid == '025' || uid == '027' || uid == '080' || uid == '188' || uid == '189' || uid == '190' || uid == '191' || uid == '192' || uid == '193') {
                        ddtConfig = rqI.RQ__r.Con__r.rlg__c == 'Muslim' ? 'ddt_eida_ren_chg_spon_Muslim' : 'ddt_eida_ren_chg_spon';
                        eidaSType = '\'Residency renewal - Change sponsor\'';
                        eidaYears = '\'Th\'';
                        workMode = '\'Private Sector\'';
                    }
                    /*Employee Transfer for 1 year*/ if (uid == '015' || uid == '026' || uid == '028' || uid == '081') {
                        ddtConfig = rqI.RQ__r.Con__r.rlg__c == 'Muslim' ? 'ddt_eida_ren_chg_spon_Muslim' : 'ddt_eida_ren_chg_spon';
                        eidaSType = '\'Residency renewal - Change sponsor\'';
                        eidaYears = '\'On\'';
                        workMode = '\'Private Sector\'';
                    }
                    if (uid == '103') {
                        /*Employee Internal Transfer(within freezone)*/ ddtConfig = rqI.RQ__r.Con__r.rlg__c == 'Muslim' ? 'ddt_eida_ren_chg_spon_Muslim' : 'ddt_eida_ren_chg_spon';
                        eidaSType = '\'Residency renewal - Change sponsor\'';
                        eidaYears = '\'On\'';
                        workMode = '\'Private Sector\'';
                    }
                    /*Spouse Visa for 3 years*/ if (uid == '005' || uid == '012') {
                        ddtConfig = rqI.RQ__r.Con__r.rlg__c == 'Muslim' ? 'ddt_eida_ren_chg_spon_Muslim' : 'ddt_eida_ren_chg_spon';
                        eidaSType = '\'Residency renewal - Change sponsor\'';
                        eidaYears = '\'Th\'';
                        workMode = '\'Not Working\'';
                    }
                    /*Spouse Visa for 1 year*/ /*TODO*/ /*Spouse Visa Renewal for 3 years*/ if (uid == '045' || uid == '056') {
                        ddtConfig = rqI.RQ__r.Con__r.rlg__c == 'Muslim' ? 'ddt_eida_ren_Muslim' : 'ddt_eida_ren';
                        eidaSType = '\'Residency Renewal - Same Sponsor\'';
                        eidaYears = '\'Th\'';
                        workMode = '\'Not Working\'';
                    }
                    /*Spouse Visa Renewal for 1 year*/ if (uid == '119') {
                        ddtConfig = rqI.RQ__r.Con__r.rlg__c == 'Muslim' ? 'ddt_eida_ren_Muslim' : 'ddt_eida_ren';
                        eidaSType = '\'Residency Renewal - Same Sponsor\'';
                        eidaYears = '\'On\'';
                        workMode = '\'Not Working\'';
                    }
                    /*Spouse Visa Transfer for 3 years*/ if (uid == '023' || uid == '018') {
                        ddtConfig = rqI.RQ__r.Con__r.rlg__c == 'Muslim' ? 'ddt_eida_ren_chg_spon_Muslim' : 'ddt_eida_ren_chg_spon';
                        eidaSType = '\'Residency renewal - Change sponsor\'';
                        eidaYears = '\'Th\'';
                        workMode = '\'Not Working\'';
                    }
                    /*Spouse Visa Transfer for 1 year*/ if (uid == '117') {
                        ddtConfig = rqI.RQ__r.Con__r.rlg__c == 'Muslim' ? 'ddt_eida_ren_chg_spon_Muslim' : 'ddt_eida_ren_chg_spon';
                        eidaSType = '\'Residency renewal - Change sponsor\'';
                        eidaYears = '\'On\'';
                        workMode = '\'Not Working\'';
                    }
                    /*Child Visa for 3 years*/ if (uid == '006' || uid == '013') {
                        ddtConfig = rqI.RQ__r.Con__r.rlg__c == 'Muslim' ? 'ddt_eida_ren_chg_spon_Muslim' : 'ddt_eida_ren_chg_spon';
                        eidaSType = '\'Residency renewal - Change sponsor\'';
                        eidaYears = '\'Th\'';
                        workMode = '\'Not Working\'';
                    }
                    /*Child Visa for 1 year*/ /*TODO*/ /*Child Visa Renewal for 3 years*/ if (uid == '046' || uid == '057') {
                        ddtConfig = rqI.RQ__r.Con__r.rlg__c == 'Muslim' ? 'ddt_eida_ren_Muslim' : 'ddt_eida_ren';
                        eidaSType = '\'Residency Renewal - Same Sponsor\'';
                        eidaYears = '\'Th\'';
                        workMode = '\'Not Working\'';
                    }
                    /*Child Visa Renewal for 1 year*/ if (uid == '120') {
                        ddtConfig = rqI.RQ__r.Con__r.rlg__c == 'Muslim' ? 'ddt_eida_ren_Muslim' : 'ddt_eida_ren';
                        eidaSType = '\'Residency Renewal - Same Sponsor\'';
                        eidaYears = '\'On\'';
                        workMode = '\'Not Working\'';
                    }
                    /*Child Visa Transfer for 3 years*/ if (uid == '017' || uid == '024') {
                        ddtConfig = rqI.RQ__r.Con__r.rlg__c == 'Muslim' ? 'ddt_eida_ren_chg_spon_Muslim' : 'ddt_eida_ren_chg_spon';
                        eidaSType = '\'Residency renewal - Change sponsor\'';
                        eidaYears = '\'Th\'';
                        workMode = '\'Not Working\'';
                    }
                    /*Child Visa Transfer for 1 year*/ if (uid == '118') {
                        ddtConfig = rqI.RQ__r.Con__r.rlg__c == 'Muslim' ? 'ddt_eida_ren_chg_spon_Muslim' : 'ddt_eida_ren_chg_spon';
                        eidaSType = '\'Residency renewal - Change sponsor\'';
                        eidaYears = '\'On\'';
                        workMode = '\'Not Working\'';
                    }
                    /*Newborn Visa for 3 years*/ if (uid == '009' || uid == '014') {
                        ddtConfig = rqI.RQ__r.Con__r.rlg__c == 'Muslim' ? 'ddt_eida_ren_chg_spon_Muslim' : 'ddt_eida_ren_chg_spon';
                        eidaSType = '\'Residency renewal - Change sponsor\'';
                        eidaYears = '\'Th\'';
                        workMode = '\'Not Working\'';
                    }
                    /*Newborn Visa for 1 year*/ /*TODO*/ /*Housemaid Visa for 2 years*/ if (uid == '008') {
                        ddtConfig = rqI.RQ__r.Con__r.rlg__c == 'Muslim' ? 'ddt_eida_ren_chg_spon_Muslim' : 'ddt_eida_ren_chg_spon';
                        eidaSType = '\'Residency renewal - Change sponsor\'';
                        eidaYears = '\'Tw\'';
                        workMode = '\'Private Sector\'';
                    }
                    /*Housemaid Visa for 1 year*/ if (uid == '007') {
                        ddtConfig = rqI.RQ__r.Con__r.rlg__c == 'Muslim' ? 'ddt_eida_ren_chg_spon_Muslim' : 'ddt_eida_ren_chg_spon';
                        eidaSType = '\'Residency renewal - Change sponsor\'';
                        eidaYears = '\'On\'';
                        workMode = '\'Private Sector\'';
                    }
                    /*Housemaid Visa Renewal for 2 years*/ if (uid == '049') {
                        ddtConfig = rqI.RQ__r.Con__r.rlg__c == 'Muslim' ? 'ddt_eida_ren_Muslim' : 'ddt_eida_ren';
                        eidaSType = '\'Residency Renewal - Same Sponsor\'';
                        eidaYears = '\'Tw\'';
                        workMode = '\'Private Sector\'';
                    }
                    /*Housemaid Visa Renewal for 1 year*/ if (uid == '047') {
                        ddtConfig = rqI.RQ__r.Con__r.rlg__c == 'Muslim' ? 'ddt_eida_ren_Muslim' : 'ddt_eida_ren';
                        eidaSType = '\'Residency Renewal - Same Sponsor\'';
                        eidaYears = '\'On\'';
                        workMode = '\'Private Sector\'';
                    }
                    /*Student Visa for 1 year*/ if (uid == '011' || uid == '022') {
                        ddtConfig = rqI.RQ__r.Con__r.rlg__c == 'Muslim' ? 'ddt_eida_ren_chg_spon_Muslim' : 'ddt_eida_ren_chg_spon';
                        eidaSType = '\'Residency renewal - Change sponsor\'';
                        eidaYears = '\'On\'';
                        workMode = '\'Student\'';
                    }
                    /*Student Visa Renewal for 1 year*/ if (uid == '044' || uid == '082') {
                        ddtConfig = rqI.RQ__r.Con__r.rlg__c == 'Muslim' ? 'ddt_eida_ren_Muslim' : rqI.RQ__r.Con__r.rlg__c == 'Muslim' ? 'ddt_eida_ren_Muslim' : 'ddt_eida_ren';
                        eidaSType = '\'Residency Renewal - Same Sponsor\'';
                        eidaYears = '\'On\'';
                        workMode = '\'Student\'';
                    }
                    /*Student Visa Transfer for 1 year*/ if (uid == '019' || uid == '029') {
                        ddtConfig = rqI.RQ__r.Con__r.rlg__c == 'Muslim' ? 'ddt_eida_ren_chg_spon_Muslim' : 'ddt_eida_ren_chg_spon';
                        eidaSType = '\'Residency renewal - Change sponsor\'';
                        eidaYears = '\'On\'';
                        workMode = '\'Student\'';
                    }
                }
                ovisaNumberP1 = '1';
                ovisaNumberP2 = '1';
                ovisaNumberP3 = '1';
                yrsOfTransfer = '1';
                transType = '\'e\'';
            }
            else if (rqI.sta__r.itm__r.cd__c == 'rt') {
                System.debug('**Previous Visa Number:' + rqI.RQ__r.e__c);
                string[] vNo = rqI.RQ__r.e__c.split('/');
                ovisaNumberP1 = vNo[0];
                ovisaNumberP2 = vNo[1];
                ovisaNumberP3 = vNo[2];
                if (ovisaNumberP1 != null && ovisaNumberP1 != '') {
                    if (ovisaNumberP1 == '201') {
                        /*Inside Dubai*/ /*transType refers to old sponsor type as e for establishment and r for resident*/ if ((uid == '010' || uid == '027' || uid == '025' || uid == '080' || uid == '188' || uid == '189' || uid == '190' || uid == '191' || uid == '192' || uid == '193') && rqI.RQ__r.xctp__c == 'Government Transfer') {
                            /*ddtConfig = 'ddt_res_spon_tran_se_estspon';
                            */ ddtConfig = 'ddte_3Rel_Tran';
                            yrsOfTransfer = '3';
                            transType = '\'e\'';
                        }
                        if (uid == '025' && rqI.RQ__r.xctp__c == 'Government Transfer') {
                            ddtConfig = 'ddt_res_spon_tran_se_estspon_int';
                            yrsOfTransfer = '3';
                            transType = '\'e\'';
                        }
                        if ((uid == '010' || uid == '027' || uid == '025' || uid == '080' || uid == '188' || uid == '189' || uid == '190' || uid == '191' || uid == '192' || uid == '193') && rqI.RQ__r.xctp__c == 'Dependent Transfer') {
                            /* ddtConfig = 'ddt_res_spon_tran_se_estspon';
                            */ ddtConfig = 'ddte_3Rel_Tran';
                            yrsOfTransfer = '3';
                            transType = '\'r\'';
                        }
                        if (uid == '025' && rqI.RQ__r.xctp__c == 'Dependent Transfer') {
                            ddtConfig = 'ddt_res_spon_tran_se_estspon_int';
                            yrsOfTransfer = '3';
                            transType = '\'r\'';
                        }
                        if ((uid == '018' || uid == '023') && rqI.RQ__r.xctp__c == 'Government Transfer') {
                            ddtConfig = 'ddt_res_spon_tran_se_resspon';
                            yrsOfTransfer = '3';
                            transType = '\'e\'';
                        }
                        if ((uid == '018' || uid == '023') && rqI.RQ__r.xctp__c == 'Dependent Transfer') {
                            ddtConfig = 'ddt_res_spon_tran_se_resspon';
                            yrsOfTransfer = '3';
                            transType = '\'r\'';
                        }
                        if ((uid == '015' || uid == '028' || uid == '081') && rqI.RQ__r.xctp__c == 'Government Transfer') {
                            ddtConfig = 'ddt_res_spon_tran_se_estspon';
                            yrsOfTransfer = '1';
                            transType = '\'e\'';
                        }
                        if ((uid == '015' || uid == '028' || uid == '081') && rqI.RQ__r.xctp__c == 'Dependent Transfer') {
                            ddtConfig = 'ddt_res_spon_tran_se_estspon';
                            yrsOfTransfer = '1';
                            transType = '\'r\'';
                        }
                        if ((uid == '019' || uid == '029') && rqI.RQ__r.xctp__c == 'Government Transfer') {
                            ddtConfig = 'ddt_res_spon_tran_se_estspon_st';
                            yrsOfTransfer = '1';
                            transType = '\'e\'';
                        }
                        if ((uid == '019' || uid == '029') && rqI.RQ__r.xctp__c == 'Dependent Transfer') {
                            ddtConfig = 'ddt_res_spon_tran_se_estspon_st';
                            yrsOfTransfer = '1';
                            transType = '\'r\'';
                        }
                        if ((uid == '017' || uid == '024') && rqI.RQ__r.xctp__c == 'Dependent Transfer') {
                            ddtConfig = 'ddt_res_spon_tran_se_resspon';
                            yrsOfTransfer = '3';
                            transType = '\'r\'';
                        }
                    }
                    else {
                        /*Outside Dubai*/ /*transType refers to old sponsor type as e for establishment and r for resident*/ if ((uid == '010' || uid == '027' || uid == '025' || uid == '080') && rqI.RQ__r.xctp__c == 'Government Transfer') {
                            ddtConfig = 'ddt_res_spon_tran_ae_estspon';
                            yrsOfTransfer = '3';
                            transType = '\'e\'';
                        }
                        if (uid == '025' && rqI.RQ__r.xctp__c == 'Government Transfer') {
                            ddtConfig = 'ddt_res_spon_tran_ae_estspon_int';
                            yrsOfTransfer = '3';
                            transType = '\'e\'';
                        }
                        if ((uid == '010' || uid == '027' || uid == '080') && rqI.RQ__r.xctp__c == 'Dependent Transfer') {
                            ddtConfig = 'ddt_res_spon_tran_ae_estspon';
                            yrsOfTransfer = '3';
                            transType = '\'r\'';
                        }
                        if (uid == '025' && rqI.RQ__r.xctp__c == 'Dependent Transfer') {
                            ddtConfig = 'ddt_res_spon_tran_ae_estspon_int';
                            yrsOfTransfer = '3';
                            transType = '\'r\'';
                        }
                        if ((uid == '018' || uid == '023') && rqI.RQ__r.xctp__c == 'Government Transfer') {
                            ddtConfig = 'ddt_res_spon_tran_ae_resspon';
                            yrsOfTransfer = '3';
                            transType = '\'e\'';
                        }
                        if ((uid == '018' || uid == '023') && rqI.RQ__r.xctp__c == 'Dependent Transfer') {
                            ddtConfig = 'ddt_res_spon_tran_ae_resspon';
                            yrsOfTransfer = '3';
                            transType = '\'r\'';
                        }
                        if ((uid == '015' || uid == '028' || uid == '081') && rqI.RQ__r.xctp__c == 'Government Transfer') {
                            ddtConfig = 'ddt_res_spon_tran_ae_estspon';
                            yrsOfTransfer = '1';
                            transType = '\'e\'';
                        }
                        if ((uid == '015' || uid == '028' || uid == '081') && rqI.RQ__r.xctp__c == 'Dependent Transfer') {
                            ddtConfig = 'ddt_res_spon_tran_ae_estspon';
                            yrsOfTransfer = '1';
                            transType = '\'r\'';
                        }
                        if ((uid == '019' || uid == '029') && rqI.RQ__r.xctp__c == 'Government Transfer') {
                            ddtConfig = 'ddt_res_spon_tran_ae_estspon_st';
                            yrsOfTransfer = '1';
                            transType = '\'e\'';
                        }
                        if ((uid == '019' || uid == '029') && rqI.RQ__r.xctp__c == 'Dependent Transfer') {
                            ddtConfig = 'ddt_res_spon_tran_ae_estspon_st';
                            yrsOfTransfer = '1';
                            transType = '\'r\'';
                        }
                        if ((uid == '017' || uid == '024') && rqI.RQ__r.xctp__c == 'Dependent Transfer') {
                            ddtConfig = 'ddt_res_spon_tran_ae_resspon';
                            yrsOfTransfer = '3';
                            transType = '\'r\'';
                        }
                    }
                }
            }
            else {
                ddtConfig = rqI.sta__r.jscfddt__c;
                ovisaNumberP1 = '1';
                ovisaNumberP2 = '1';
                ovisaNumberP3 = '1';
                yrsOfTransfer = '1';
                transType = '\'e\'';
            }
            /*Dependent Cancellation*/ if (uid == '090') {
                if (rqI.sta__r.itm__r.cd__c == 'ins') {
                    /*RP cancellation Inside UAE*/ if (rqI.RQ__r.Con__r.Spon__r.rol__c == 'Employee') {
                        /*Residence sponsor*/ /*ddtConfig = 'ddt_res_cncl_cnclresdep';
                        */ ddtConfig = 'ddte_rp_dep_can_iu';
                        ioUAE = '1';
                    }
                    else if (rqI.RQ__r.Con__r.Spon__r.rol__c == 'Non Sponsored') {
                        /*File No sponsor*/ ddtConfig = 'ddt_res_cncl_cnclnatdep';
                        ioUAE = '1';
                    }
                }
                else if (rqI.sta__r.itm__r.cd__c == 'oua') {
                    /*RP cancellation outside UAE with passport*/ if (rqI.RQ__r.Con__r.Spon__r.rol__c == 'Employee') {
                        /*Residence sponsor*/ ddtConfig = 'ddt_res_cncl_cnclresdep';
                        ioUAE = '2';
                    }
                    else if (rqI.RQ__r.Con__r.Spon__r.rol__c == 'Non Sponsored') {
                        /*File No sponsor*/ ddtConfig = 'ddt_res_cncl_cnclnatdep';
                        ioUAE = '2';
                    }
                }
                else if (rqI.sta__r.itm__r.cd__c == 'oup') {
                    /*RP cancellation outside UAE without passport*/ if (rqI.RQ__r.Con__r.Spon__r.rol__c == 'Employee') {
                        /*Residence sponsor*/ ddtConfig = 'ddt_res_cncl_cnclresdep';
                        ioUAE = '2';
                    }
                    else if (rqI.RQ__r.Con__r.Spon__r.rol__c == 'Non Sponsored') {
                        /*File No sponsor*/ ddtConfig = 'ddt_res_cncl_cnclnatdep';
                        ioUAE = '2';
                    }
                }
            }
            System.debug('*** Config file Choosen:' + ddtConfig);
        }
        catch (Exception e) {
            System.debug('** Exception while SetConfigFile(): ' + e);
        }
    }
}
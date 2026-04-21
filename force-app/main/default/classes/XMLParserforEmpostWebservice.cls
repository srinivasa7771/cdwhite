Public class XMLParserforEmpostWebservice {
    Public String location {
        get;
        set;
    }
    Public String assginedTo {
        get;
        set;
    }
    Public String ctype {
        get;
        set;
    }
    public String uid {
        get;
        set;
    }
    public Datetime createdon {
        get;
        set;
    }
    public String bookingSTG {
        get;
        set;
    }
    public String awbno {
        get;
        set;
    }
    public class XMLtoApex {

        Public String Name {
            get;
            set;
        }
        //public String status{get;set;}
        Public String count {
            get;
            set;
        }
        Public String AIRWAYBILL;
        public String StatusReason, ContentTypeID, ContentTypeName, AWB;
        public String Status, Cancelled, CourierName;

    }
    public class summary {
        public String status {
            get;
            set;
        }
        Public String count {
            get;
            set;
        }
    }
    public List < summary > summary;
    public List < XMLtoApex > settings;

    Public list < summary > jsonToList(String empostJson) {
        XMLParserforEmpostWebservice parsedJSON = (XMLParserforEmpostWebservice) System.JSON.deserialize(empostJson, XMLParserforEmpostWebservice.class);
        List < summary > respObj = parsedJSON.summary;
        List < XMLParserforEmpostWebservice.summary > courSumm = new List < XMLParserforEmpostWebservice.summary > ();
        Integer at = 0, dupCan = 0;
        Boolean flg = false;
        for (XMLParserforEmpostWebservice.summary dp: respObj) {
            if (dp.status.trim() == 'Cancelled') {
                dupCan = dupCan + Integer.valueOf(dp.count.trim());
            }
            if (dp.status == 'Alloted (Transit)') {
                at = Integer.valueOf(dp.count.trim());
            }
        }
        for (XMLParserforEmpostWebservice.summary s: respObj) {
            if (s.status == 'Alloted') {
                s.count = String.valueOf((Integer.valueOf(s.count.trim()) + at));
                courSumm.add(s);
            } else if (s.status.trim() == 'Cancelled' && !flg) {
                s.count = String.valueOf(dupCan);
                flg = true;
                courSumm.add(s);
            } else if (s.status != 'Alloted (Transit)' && s.status.trim() != 'Cancelled') {
                courSumm.add(s);
            }
        }

        return courSumm;
    }

    list < XMLtoApex > LstxaObj = new list < XMLtoApex > ();
    public list < XMLtoApex > XMLParser(String strXml) {
        Dom.Document doc = new Dom.Document();
        if (strXml != null) {
            doc.load(strXml);
            Dom.XMLNode ordDtls = doc.getRootElement();
            for (Dom.XMLNode pchild: ordDtls.getChildElements()) {
                XMLtoApex xaObj = new XMLtoApex();
                for (Dom.XMLNode child: pchild.getChildElements()) {
                    if (child.getName().equalsIgnoreCase('Name')) xaObj.Name = child.getText();
                    if (child.getName().equalsIgnoreCase('Count')) xaObj.Count = child.getText();
                    if (child.getName().equalsIgnoreCase('AIRWAYBILL')) xaObj.AIRWAYBILL = child.getText();
                    if (child.getName().equalsIgnoreCase('StatusReason')) xaObj.StatusReason = child.getText();
                    if (child.getName().equalsIgnoreCase('ContentTypeID')) xaObj.ContentTypeID = child.getText();
                    if (child.getName().equalsIgnoreCase('ContentTypeName')) xaObj.ContentTypeName = child.getText();
                    if (child.getName().equalsIgnoreCase('AWB')) xaObj.AWB = child.getText();
                    if (child.getName().equalsIgnoreCase('Status')) xaObj.Status = child.getText();
                    if (child.getName().equalsIgnoreCase('Cancelled')) xaObj.Cancelled = child.getText();
                    if (child.getName().equalsIgnoreCase('CourierName')) xaObj.CourierName = child.getText();
                }
                LstxaObj.add(xaObj);
            }
        }
        return LstxaObj;
    }

    Public String CreateBooking(g_Req__c RequestObj, String Courier_Stage) {
        system.debug('**CreateBooking--Start');
        EmpostBookingUtil eutil= new EmpostBookingUtil();
         List<g_Req__c> req=[select con__r.middlename, CreatedBy.email, srvc__r.sdg__r.ptype__c,
             srvc__r.stg__r.itmq__c, xoca__c, ias__c, xengt__c, xeng__c, xneng__c, xvown__c, xtr2__c,
             xltr_others__c, print__c, xln__c, xcst__c, xvbr__c, xvch__c, xvn__c, xwdt__c, xbdt__c,
             xvtyp__c, xbtnm__c, xltr__c, xlt__c, xla2__c, xla2d__c, xltp__c, xnld__c, xloc__c,
             xccn__c, srvc__r.stg__r.json__c, xcmonar__c, xcfanar__c, xengp__c, xai__c, xsi__c,
             srvc__r.xoi__c, srvc__r.addonsrv__c, srvc__r.milestone_stage__c, mtc__c, xcjb__r.jtm__c,
             con__r.name, con__r.job_title_formula__c, con__r.bp__c, con__r.ped__c, con__r.personal_photo__c,
             con__c, xard__c, con__r.spon__r.xpmi__c, con__r.spon__r.idtxt__c, con__r.spon__r.name,
             con__r.spon__r.xpno__c, con__r.spon__r.intp__c, con__r.spon__r.birthdate, spr__r.idtxt__c,
             spr__r.xpno__c, con__r.e__c, spr__r.xpmi__c, spr__r.intp__c, spr__r.birthdate, i_sta__c,
             xtpa__c, id, name, sta__c, at__c, ap__c, aop__c, xdtcls__c, dsc__c, dsc__r.prct__c,
             xfpc__c, spch__c, rmob__c, xawb__c, xaloc__c, xbrnd__c, xbn__c, nt__c, srvc__r.uid__c,
             conrol__c , xadh__c, xpgs__c, inschk__c, xintp__c, con__r.rol__c, con__r.firstname,
             con__r.lastname, con__r.emrt__c, con__r.p__c, con__r.email, con__r.mobilephone, con__r.salutation,
             con__r.ms__c, con__r.nc__c, con__r.eidid__c, con__r.pobx__c, con__r.mbs__c, con__r.ma__c,
             con__r.mta__c, con__r.moa__c, con__r.birthdate, con__r.rpui__c, srvc__c, srvc__r.name,
             srvc__r.lbl__c, srvc__r.dsc__c, srvc__r.prk__c, srvc__r.acctp__c, srvc__r.ckgsnc__c,
             srvc__r.snc__c, srvc__r.stg__r.pg__c, srvc__r.stg__r.apx__c, srvc__r.stg__r.reqq__c,
             acc__c, acc__r.name, acc__r.lcedt__c , acc__r.mtc__c, acc__r.type, acc__r.prk__c,
             acc__r.lcsnc__c, acc__r.lcsncnt__c, acc__r.psasnc__c, acc__r.psasncnt__c, acc__r.ecsnc__c,
             acc__r.ecsncnt__c, acc__r.cosnc__c, acc__r.cosncnt__c, acc__r.bgsnc__c, acc__r.bgsncnt__c,
             acc__r.snc__c, acc__r.info__c, acc__r.vestd__c, acc__r.vbtemp__c, acc__r.sncnt__c,
             lastmodifieddate, lastmodifiedbyid, createddate, createdbyid, createdby.name, item_count__c,
             xeidav__c, xcma__c, xcacctp__c, xcha__c, xcarea__c, xcmbs__c, xcbd__c, xccty__c,
             xcbc__c, xcnc__c, xceidid__c, xceidedt__c, xceididt__c, xceml__c, xcemrt__c, xcfan__c,
             xcfs__c, xcfn__c, xcfnar__c, xchph__c, xcln__c, xclnar__c, xcms__c, xcmn__c, xcmnar__c,
             xcmob__c, xcmon__c, xcof__c, xcot__c, xcjb__c, xcmoa__c, xcp__c, xcped__c, xcpid__c,
             xcpic__c, xcpip__c, xcbp__c, xcpobx__c, xcpobxarea__c, xcnp__c, xcql__c, xcrlg__c,
             xcslt__c, xclng__c, xcstrt__c, xcmta__c, xdedc__c, xdedln__c, xosa__c, xphid__c,
             xcs__c, xcn__c, zone__c, full_name__c, amsgs__c, action__c, xspn__c, xinsv__c, xcpobar__c,
             con__r.eid__c, con__r.eed__c, con__r.rp__c, con__r.rpid__c, con__r.rped__c, con__r.eididt__c,
             con__r.eidedt__c, con__r.idtxt__c, con__r.ididt__c, con__r.idedt__c, xcpipoar__c,
             srvc__r.pstg__c, srvc__r.kstp__c, xcddocs__c, xmloc__c, srvc__r.category__c, xcqc__c,
             xcdd__c, xcqemrt__c, aup__c, xcamdt__c, slan__c , srvc__r.sdg__r.skpsd__c , gender__c,
             expcnt__c, noexp__c, aupv__c, expflg__c , nofnm__c, spnm__c, afn__c, xspnar__c, ntk__c,
             ntkar__c , acc__r.Legal_Framework__c , piFlg__c from g_req__c where id=: RequestObj.id];
        String bjson=eutil.createBookingJson(req[0], Courier_Stage);

        //String Xmldata = BuildXMLforCreateBooking(RequestObj, Courier_Stage);
        return  EmpostcourierWs.createBooking(bjson);

        //return CreateBooking(RequestObj.Name, Xmldata);
    }
    Public String CreateBooking(String srn, String Xmldata) {
        system.debug('**CreateBooking--Start');
        String vCreateBooking;
        try {
            EmpostWebservice.PopulateSoap proxyClass = new EmpostWebservice.PopulateSoap();
            system.debug('**CreateBooking--Start1');
            String vLogin;
            String[] UserPass = gU.csStr('Courier_login').split(', ');
            system.debug('**CreateBooking--Start2');
            vLogin = proxyClass.login(UserPass[0], UserPass[1]);
            system.debug('**CreateBooking--Start3' + vLogin);
            /* String Xmldata = BuildXMLforCreateBooking(RequestObj, Courier_Stage);
            */ System.debug('--Xmldata-- : ' + Xmldata);
            /*  vCreateBooking = proxyClass.CreateBooking(Xmldata, vLogin);
            */ /* incase of awb number is zero */ if (vCreateBooking.contains('<STATUS>FAILED</STATUS>') || vCreateBooking.contains('<AIRWAYBILL>0</AIRWAYBILL>')) {
                errorLog(srn, Xmldata, 'Booking', vCreateBooking);
                /*return null;
            */ }
            Integer Index = vCreateBooking.indexOf('>');
            vCreateBooking = vCreateBooking.substring(Index + 1, vCreateBooking.length());
            vCreateBooking = '<TempElement>' + vCreateBooking + '</TempElement>';
        }
        Catch(Exception e) {
            system.debug('ex::'+e.getStackTraceString());
            errorLog(srn, Xmldata, 'Booking', e.getMessage());
            vCreateBooking = null;
        }
        system.debug('**CreateBooking--END');
        return vCreateBooking;
    }

    public void errorLog(String rqName, String data, String errTyp, String exp) {
        cuerrlg__c errLog = new cuerrlg__c();
        errLog.rq__c = rqName;
        errLog.cuexp__c = exp;
        errLog.errTyp__c = errTyp;
        errLog.cxml__c = data;
        if (Schema.sObjectType.cuerrlg__c.isCreateable()) {
            insert errLog;
        }
    }
    // Public EmpostWebservice.ArrayOfBOOKINGTYPE GetBookingTypes(String UserName, String Password) { EmpostWebservice.PopulateSoap  proxyClass = new EmpostWebservice.PopulateSoap(); String vLogin = proxyClass.login(UserName, Password); EmpostWebservice.ArrayOfBOOKINGTYPE vBookingTypes = proxyClass.GetBookingTypes(); return vBookingTypes; }
    Public String GetContentTypes(String UserName, String Password) {
        EmpostWebservice.PopulateSoap proxyClass = new EmpostWebservice.PopulateSoap();
        String vLogin;
        vLogin = proxyClass.login(UserName, Password);
        String vContentTypes;
        vContentTypes = proxyClass.GetContentTypes(vLogin);
        /* vContentTypes = '<?xml version="1.0" encoding="utf-16"?><ContentTypeInfo><ContentType><ContentTypeID>192</ContentTypeID><ContentTypeName>NBC Collection</ContentTypeName></ContentType><ContentType><ContentTypeID>184</ContentTypeID><ContentTypeName>Documents</ContentTypeName></ContentType></ContentTypeInfo>';
        */ Integer Index = vContentTypes.indexOf('>');
        vContentTypes = vContentTypes.substring(Index + 1, vContentTypes.length());
        return vContentTypes;
    }
    Public static String GetUpdatedStatusByAWB(String[] LstAWB) {
        String vLogin, vCancelBooking;
        String[] UserPass = gU.csStr('Courier_login').split(', ');
        EmpostWebservice.PopulateSoap proxyClass = new EmpostWebservice.PopulateSoap();
        vLogin = proxyClass.login(UserPass[0], UserPass[1]);
        EmpostWebservice.ArrayOfString easObj = new EmpostWebservice.ArrayOfString();
        easObj.string_x = LstAWB;
        String vUpdatedStatusByAWB;
        Integer Index = vUpdatedStatusByAWB.indexOf('>');
        vUpdatedStatusByAWB = vUpdatedStatusByAWB.substring(Index + 1, vUpdatedStatusByAWB.length());
        return vUpdatedStatusByAWB;
    }
    //@future(callout=true)
    Public static string CancelBooking(String[] LstAWB) {
        String[] UserPass = gU.csStr('Courier_login').split(', ');
        EmpostWebservice.PopulateSoap proxyClass = new EmpostWebservice.PopulateSoap();
        EmpostWebservice.ArrayOfString easObj = new EmpostWebservice.ArrayOfString();
        easObj.string_x = LstAWB;
        String vLogin, vCancelBooking;
        vLogin = proxyClass.login(UserPass[0], UserPass[1]);
        vCancelBooking = proxyClass.CancelBooking(easObj, vLogin);
        System.debug('--vCancelBooking-- ' + vCancelBooking);
        Integer Index = vCancelBooking.indexOf('>');
        vCancelBooking = vCancelBooking.substring(Index + 1, vCancelBooking.length());
        return vCancelBooking;
    }

    Public static String GetStatusSummary(String fromDate, String toDate) {
        String[] UserPass = gU.csStr('Courier_login').split(', ');
        EmpostWebservice.PopulateSoap proxyClass = new EmpostWebservice.PopulateSoap();
        String vLogin, vGetStatusSummary;
        vLogin = proxyClass.login(UserPass[0], UserPass[1]);
        /* vLogin = proxyClass.login('61812', '61812');
        */ vGetStatusSummary = proxyClass.GetStatusSummary(fromDate, vLogin);
        Integer Index = vGetStatusSummary.indexOf('>');
        vGetStatusSummary = vGetStatusSummary.substring(Index + 1, vGetStatusSummary.length());
        return vGetStatusSummary;
    }

    Public String BuildXMLforCreateBooking(g_Req__c RequestObj, String Courier_Stage) {
        String zoneId = RequestObj.Zone__c;
        zoneId = 'Dubai International Academic City';
        if (zoneId == 'Dubai Design District') {
            zoneId = 'D3';
        }
        if (zoneId == 'Dubai Healthcare City') {
            zoneId = 'DHCC';
        }
        if (zoneId == 'Dubai International Academic City') {
            zoneId = 'DIAC';
        }
        if (zoneId == 'Dubai Internet City') {
            zoneId = 'DIC';
        }
        if (zoneId == 'Dubai Knowledge Village') {
            zoneId = 'DKV';
        }
        if (zoneId == 'Dubai Media City') {
            zoneId = 'DMC';
        }
        if (zoneId == 'Dubai Outsource Zone') {
            zoneId = 'DOZ';
        }
        if (zoneId == 'Dubai Studio City') {
            zoneId = 'DSC';
        }
        if (zoneId == 'DuBiotech') {
            zoneId = 'DuBiotech';
        }
        if (zoneId == 'Enpark') {
            zoneId = 'Enpark';
        }
        if (zoneId == ' Dubai Science Park') {
            zoneId = 'DSP';
        }
        if (zoneId == 'International Media Production Zone') {
            zoneId = 'IMPZ';
        }
        String cmpName = RequestObj.Acc__r.Name;
        /* +' - '+ RequestObj.Full_Name__c;
        */ String strXML = '<BookingInfo>';
        strXML += '<BookingType>' + Courier_Stage.toUpperCase() + '</BookingType>';
        if (Courier_Stage == 'COLLECTION') {
            if (assginedTo != null) {
                strXML += '<EmpID>' + assginedTo + '</EmpID>';
            }
            else {
                if (cmpName.length() > 50) {
                    strXML += '<EmpID>' + cmpName.substring(0, 50) + '</EmpID>';
                }
                else {
                    strXML += '<EmpID>' + cmpName + '</EmpID>';
                }
            }
        }
        else {
            strXML += '<EmpID>' + UserInfo.getName() + '</EmpID>';
        }
        strXML += '<Branch>' + 'AXS Office' + '</Branch>';
        /*strXML += '<EMPPhone>'+  RequestObj.Full_Name__c +'</EMPPhone>';
        */ strXML += '<EMPPhone>' + '8004297' + '</EMPPhone>';
        /*company name*/ String bng = 'AXS Satellite Office at DKV ';
        String zid = 'DKP';
        System.debug('***cmpName : ' + cmpName);
        if (cmpName.length() > 50) {
            strXML += '<CompanyName>' + cmpName.substring(0, 49) + '</CompanyName>';
        }
        else {
            strXML += '<CompanyName>' + cmpName + '</CompanyName>';
        }
        if (Courier_Stage == 'COLLECTION') {
            if (location != null && location.trim().length() > 0 && location == 'KV') {
                strXML += '<Address>AXS Satellite Office at DKV </Address>';
                bng = 'AXS Satellite Office at DKV ';
                zid = 'DKP';
            }
            else if (location != null && location.trim().length() > 0 && location == 'DIAC') {
                strXML += '<Address>AXS Satellite Office at DIAC </Address>';
                bng = 'AXS Satellite Office at DIAC';
                zid = 'DIAC';
            }
            else if (location != null && location.trim().length() > 0 && location == 'DHCC') {
                strXML += '<Address>AXS Satellite Office at DHCC </Address>';
                bng = 'AXS Satellite Office at DHCC';
                zid = 'DHCC';
            }
            else {
                strXML += '<Address>' + RequestObj.xaloc__c + ' - ' + RequestObj.CreatedBy.Name + '</Address>';
            }
        }
        else {
            strXML += '<Address>' + RequestObj.xaloc__c + ' - ' + RequestObj.CreatedBy.Name + '</Address>';
        }
        strXML += '<Zone>' + RequestObj.Zone__c + '</Zone>';
        strXML += '<Phone>' + RequestObj.rmob__c + '</Phone>';
        strXML += '<Mobile>' + RequestObj.rmob__c + '</Mobile>';
        if (Courier_Stage == 'COLLECTION') {
            strXML += '<RepresentativeName>' + RequestObj.Acc__r.Name + ' - ' + RequestObj.Full_Name__c + '</RepresentativeName>';
        }
        else {
            strXML += '<RepresentativeName>' + UserInfo.getFirstName() + ' ' + UserInfo.getLastName() + '</RepresentativeName>';
        }
        strXML += '<SRNo>' + RequestObj.Name + '</SRNo>';
        if (assginedTo != null) {
            strXML += '<TeamCode>' + assginedTo + '</TeamCode>';
        }
        else {
            strXML += '<TeamCode>' + assginedTo + '</TeamCode>';
        }
        if (RequestObj.xbn__c != null) {
            bng = RequestObj.xbn__c;
            zid = RequestObj.xbrnd__c;
        }
        strXML += '<Building>' + bng + '</Building>';
        strXML += '<ZoneID>' + zid + '</ZoneID>';
        strXML += '<ContentTypeId>184</ContentTypeId>';
        strXML += '<TimeStamp>' + '10:10' + '</TimeStamp>';
        strXML += '<HashCode>' + '71498034f26917d3c16b34d7b71626717ae17747' + '</HashCode>';
        strXML += ' <CreatedOn>' + createdon.format('dd-MMM-yyyy hh:mm:ss') + '</CreatedOn>';
        strXML += '  <URN>' + uid + '</URN>';
        system.debug('***********uid**************');
        system.debug(uid);
        system.debug('*************************');
        strXML += '</BookingInfo>';
        return strXML;
    }

    Public static String GetCourierInfo(String zone, String licenceKey) {
        String vLogin, vCancelBooking;
        String[] UserPass = gU.csStr('Courier_login').split(', ');
        EmpostWebservice.PopulateSoap proxyClass = new EmpostWebservice.PopulateSoap();
        vLogin = proxyClass.login(UserPass[0], UserPass[1]);
        String courierId;
        courierId = proxyClass.GetCourierInfo(zone, licenceKey, vLogin);
        courierId = courierId.substringBetween('<ID>', '</ID>');
        return courierId;
    }

    public void courierBooking(g_reqitem__c ri, g_req__c rq, Boolean isAdoch, String loc) {
        system.debug('*******************courierBooking --- start');

        String stage = ri.sta__r.Courier_Stage__c;
        if (ri.sta__r.Courier_Stage__c != null && ri.sta__r.Courier_Stage__c != 'None') {
            stage = ri.sta__r.Courier_Stage__c;
        } else {
            stage = ri.xcub__c;
        }
        //stage=bookingSTG;
        if (isAdoch) {
            stage = ctype;
        }

        system.debug('*******************courierBooking --- start' + stage);
        list < g_cmb__c > culst = new list < g_cmb__c > ();
        // if (ri.sta__r.Courier_Stage__c=='Any') {stage=ri.xcub__c;}
        String returnVal;
        list < g_cmb__c > existingBooking = new list < g_cmb__c > ();
        if (!isAdoch) {
            existingBooking = [SELECT Id, Name from g_cmb__c where xcb__c =: stage and itm__c =: ri.id and adh__c =: isAdoch and sta__c != 'Delivered'
                and sta__c != 'Cancelled'
                and itmsta__c =: ri.sta__c limit 1
            ];
        } else if (isAdoch) {
            existingBooking = [SELECT Id, Name from g_cmb__c where xcb__c =: stage and itm__c =: ri.id and adh__c =: isAdoch and sta__c != 'Delivered'
                and sta__c != 'Cancelled'
                and itmsta__c =: ri.sta__c limit 1
            ];
        }

        if (existingBooking.isEmpty()) {
            system.debug('*******************courierBooking --- 2' + existingBooking.isEmpty());
            if (ri.exp__c) {
                assginedTo = 'X' + ri.xcasc__c;
            } else {
                assginedTo = ri.xcasc__c;
            }
            location = loc;
            //booking created on
            createdon = Datetime.now();
            //unique ID for couirer booking
            uid = ri.id + ri.sta__r.cd__c + isAdoch + stage + Datetime.now().format('ddmmyyyyHH');
            
            String CB = CreateBooking(rq, stage.toUpperCase());
            System.debug('CB#####################################--'+CB);
            

            if (CB != null) {
                awbno = CB;
                        culst.add(new g_cmb__c(xawb__c = Long.valueOf(CB), coubdt__c = createdon,
                            uid__c = uid, sta__c = 'At Dispatcher', adh__c = isAdoch, tmpstamp__c = Datetime.now(),
                            itm__c = ri.id, xcb__c = stage, itmsta__c = ri.sta__c, xccpd__c = CB));

            } else {
                awbno = '0';
                culst.add(new g_cmb__c(xawb__c = 0, sta__c = 'At Dispatcher',
                    tmpstamp__c = Datetime.now(), uid__c = uid, coubdt__c = createdon,
                    itm__c = ri.id, adh__c = isAdoch, xcb__c = stage, itmsta__c = ri.sta__c,
                    xccpd__c = 'NA'));
            }
            if (!culst.isEmpty()) {
                if (Schema.sObjectType.g_cmb__c.isCreateable()) {
                    insert culst;
                }
            }
        }
        system.debug('*******************courierBooking --- END');
    }

}
public class grqWsInsH {
    public static void insgeneratePolicy(List < g_reqitem__c > rqItSet, map < Id, g_Req__c > mapItmPolicyGen, String wsTyp, String wsMd, map < Id, Contact > mCtct) {
        system.debug('insgeneratePolicy::::');
        Map<String, String> ntINSMap = new Map<String, String>();
        List < ws_call__c > wsList = new List < ws_call__c > ();
        try{
            List < g_reqitem__c > paidrqItSet=new List < g_reqitem__c >();
            for (g_reqitem__c ri: rqItSet) {
                if (ri.AP__c>0) {
                    paidrqItSet.add(ri);
                }
            }
            for (Country__c cnt : [Select id, name, ntadnic__c from Country__c where ntadnic__c != null]) {
                ntINSMap.put(cnt.name, (cnt.ntadnic__c).toUpperCase());
            }
            for (g_reqitem__c ri: paidrqItSet) {
                g_Req__c rq = mapItmPolicyGen.get(ri.Id);
                gctlInsHelper insCrt = new gctlInsHelper();
                String insNt ='';
                if (String.isNotBlank(rq.xcnc__c)&&ntINSMap.containsKey(rq.xcnc__c)) {
                    insNt = ntINSMap.get(rq.xcnc__c);
                }else{
                    insNt = (rq.xcnc__c).toUpperCase();
                }
                InsuranceWrapper.Insurance ins = new InsuranceWrapper.Insurance();
                InsuranceWrapper.QuoteInfo qInfo = new InsuranceWrapper.QuoteInfo();
                InsuranceWrapper.PersonalInfo perInfo = new InsuranceWrapper.PersonalInfo();
                InsuranceWrapper.SponsorInfo spInfo = new InsuranceWrapper.SponsorInfo();
                InsuranceWrapper.InsuredInfo insInfo = new InsuranceWrapper.InsuredInfo();
                InsuranceWrapper.PolicyInfo plc = new InsuranceWrapper.PolicyInfo();
                InsuranceWrapper.PartnerInfo pi = new InsuranceWrapper.PartnerInfo();
                List < InsuranceWrapper.InsuredInfo > lstInsInfo = new List < InsuranceWrapper.InsuredInfo > ();
                system.debug('rq'+rq);
                Boolean isDependent = (rq.Con__r.rol__c == 'Spouse' || rq.Con__r.rol__c == 'Child');
                Contact con = mCtct.get(rq.con__c); /*/spInfo.MobileNo = (String.isNotBlank(rq.rmob__c) && rq.rmob__c.length() >= 10) ? rq.rmob__c.right(9) : '';*/
                String insMob = '';
                if (String.isNotBlank(rq.xcmob__c)) {
                    insMob = rq.xcmob__c.trim();
                }else if (String.isNotBlank(rq.rmob__c)) {
                    insMob = rq.rmob__c.trim();
                }
                else if (rq.Con__c != null && String.isNotBlank(rq.Con__r.MobilePhone)) {
                    insMob = rq.Con__r.MobilePhone.trim();
                }
                if (String.isNotBlank(insMob)) {
                    insMob = insMob.replaceAll(' ', '');
                    insMob = insMob.replaceAll('-', '');
                    if (insMob.contains('+971')) {
                        insMob = insMob.replace('+971', '0');
                    }
                    spInfo.MobileNo = (insMob.length() >= 10) ? insMob.right(9) : insMob;
                }
                if (String.isNotBlank(rq.xceml__c)) {
                    spInfo.EmailId = rq.xceml__c;
                } else {
                    spInfo.EmailId = rq.createdBy.Email;
                }
                /*spInfo.EmailId = rq.xceml__c;*/

                /*if (!test.isRunningTest()) {spInfo.TradeLicenseNo = rq.Acc__r.lc__c;spInfo.VATRegNo = rq.Acc__r.van__c;}
spInfo.City = 'DUBAI';
spInfo.Address = rq.xbrnd__c + ', ' + rq.xbn__c + ', ' + rq.xaloc__c;
spInfo.POBoxNo = (String.isNotBlank(rq.xcpobx__c)) ? rq.xcpobx__c : rq.Con__r.pobx__c;
String ph;
if (isDependent) {
if (rq.xard__c) {
spInfo.Name = (isDependent) ? rq.Spr__r.Name : rq.Acc__r.Name;
if (rq.Spr__r.MobilePhone != null) {ph = rq.Spr__r.MobilePhone;} else {ph = rq.Acc__r.Phone;}
if (string.isNotBlank(rq.Spr__r.xpmi__c)) {
spInfo.IsADNICMember = 'YES';
} else {
spInfo.IsADNICMember = 'NO';
spInfo.SponsorPFNo = rq.Spr__r.idtxt__c;
}
spInfo.DOB = gctlInsHelper.getFDt('' + String.ValueOf(rq.Spr__r.Birthdate), '-');
} else {
if (rq.Con__r.Spon__r.MobilePhone != null) {ph = rq.Con__r.Spon__r.MobilePhone;} else {ph = rq.Acc__r.Phone;}
spInfo.Name = (isDependent) ? rq.Con__r.Spon__r.Name : rq.Acc__r.Name;
if (string.isNotBlank(rq.Con__r.Spon__r.xpmi__c)) {
spInfo.IsADNICMember = 'YES';
} else {
spInfo.IsADNICMember = 'NO'; spInfo.SponsorPFNo = rq.Con__r.Spon__r.idtxt__c;
}
spInfo.DOB = gctlInsHelper.getFDt('' + String.ValueOf(rq.Con__r.Spon__r.Birthdate), '-');
}
if (String.isBlank(spInfo.POBoxNo) && rq.Spr__c != null) {
spInfo.POBoxNo = rq.Spr__r.pobx__c;
}
} else {
spInfo.Name = rq.Acc__r.Name;ph = rq.rmob__c;
}
if (ph != null) {
ph = ph.trim();ph = ph.replaceAll(' ', '');ph = ph.replaceAll('-', '');if (ph.contains('+971')) {ph = ph.replace('+971', '0');}
spInfo.PhoneNo = (ph.length() >= 10) ? ph.right(9) : ph;
}*/
                if (!test.isRunningTest()) {
                    spInfo.TradeLicenseNo = rq.Acc__r.lc__c;
                    spInfo.VATRegNo = rq.Acc__r.van__c;
                    spInfo.City = 'DUBAI';
                    String addr = rq.xbrnd__c + ', ' + rq.xbn__c + ', ' + rq.xaloc__c;
                    spInfo.Address = String.isNotBlank(addr) ? addr.replaceAll('\n', ', ') : '';
                    spInfo.POBoxNo = (String.isNotBlank(rq.xcpobx__c)) ? rq.xcpobx__c : rq.Con__r.pobx__c;
                    String ph;
                    if (isDependent) {
                        if (rq.xard__c) {
                            spInfo.Name = (isDependent) ? rq.Spr__r.Name : rq.Acc__r.Name;
                            if (rq.Spr__r.MobilePhone != null) {
                                ph = rq.Spr__r.MobilePhone;
                            }
                            else {
                                ph = rq.Acc__r.Phone;
                            }
                            if (string.isNotBlank(rq.Spr__r.xpmi__c)) {
                                spInfo.IsADNICMember = 'YES';
                                spInfo.SponsorMedPolicyNo = rq.Spr__r.xpmi__c;
                            }
                            else {
                                spInfo.IsADNICMember = 'NO';
                                spInfo.SponsorPFNo = rq.Spr__r.idtxt__c;
                            }
                            spInfo.DOB = gctlInsHelper.getFDt('' + String.ValueOf(rq.Spr__r.Birthdate), '-');
                        }
                        else {
                            if (rq.Con__r.Spon__r.MobilePhone != null) {
                                ph = rq.Con__r.Spon__r.MobilePhone;
                            }
                            else {
                                ph = rq.Acc__r.Phone;
                            }
                            spInfo.Name = (isDependent) ? rq.Con__r.Spon__r.Name : rq.Acc__r.Name;
                            if (string.isNotBlank(rq.Con__r.Spon__r.xpmi__c)) {
                                spInfo.IsADNICMember = 'YES';
                                spInfo.SponsorMedPolicyNo = rq.Spr__r.xpmi__c;
                            }
                            else {
                                spInfo.IsADNICMember = 'NO';
                                spInfo.SponsorPFNo = rq.Con__r.Spon__r.idtxt__c;
                            }
                            spInfo.DOB = gctlInsHelper.getFDt('' + String.ValueOf(rq.Con__r.Spon__r.Birthdate), '-');
                        }
                        if (String.isBlank(spInfo.POBoxNo) && rq.Spr__c != null) {
                            spInfo.POBoxNo = rq.Spr__r.pobx__c;
                        }
                    }
                    else {
                        spInfo.Name = rq.Acc__r.Name;
                        ph = rq.rmob__c;
                    }
                    if (ph != null) {
                        ph = ph.trim();
                        ph = ph.replaceAll(' ', '');
                        ph = ph.replaceAll('-', '');
                        if (ph.contains('+971')) {
                            ph = ph.replace('+971', '0');
                        }
                        spInfo.PhoneNo = (ph.length() >= 10) ? ph.right(9) : ph;
                    }
                }
                if (String.isNOTBlank(spInfo.POBoxNo)) {
                    spInfo.POBoxNo = (spInfo.POBoxNo).replaceAll('[^0-9]', '');
                }
                if (String.isBlank(spInfo.POBoxNo)) spInfo.POBoxNo = '73000';
                spInfo.PersonalInfo = perInfo;
                //Adding personal Info
                perInfo.nationality = insNt;
                perInfo.placeOfBirth = rq.Con__r.bp__c; //rq.xcbp__c;
                String strText = perInfo.placeOfBirth;
                If(String.IsNotBlank(strText))perInfo.placeOfBirth = strText.replaceAll('[^a-zA-Z0-9\\s+]', '');
                String perAddr = rq.xbrnd__c + ', ' + rq.xbn__c + ', ' + rq.xaloc__c;
                perInfo.currentAddress = String.isNotBlank(perAddr) ? perAddr.replaceAll('\n', ', ') : '';
                perInfo.placeOfWork = 'AL SAFA SECOND';
                perInfo.passportNumber = gctlInsHelper.upperCase(rq.xcp__c);
                if (rq.xceidid__c != null && rq.xceidid__c.length() == 15) {
                    perInfo.eidNumber = rq.xceidid__c.substring(0, 3) + '-' + rq.xceidid__c.substring(3, 7) + '-' + rq.xceidid__c.substring(7, 14) + '-' + rq.xceidid__c.substring(14, 15);
                } else {
                    perInfo.eidNumber = rq.xceidid__c;
                }
                perInfo.contactDetails = '';
                perInfo.birthCertificateNumber = '';
                perInfo.permanentResidency = '';

                insInfo.placeOfBirth = rq.Con__r.bp__c; //
                String strText1 = insInfo.placeOfBirth;
                If(String.IsNotBlank(strText1))insInfo.placeOfBirth = strText1.replaceAll('[^a-zA-Z0-9\\s+]', '');
                insInfo.currentAddress = 'Dubai';
                insInfo.placeOfWork = 'Dubai';
                insInfo.contactDetails = String.isNotBlank(rq.Con__r.area__c)? rq.Con__r.area__c : 'Dubai'; //
                insInfo.permanentResidency =  adnicAxsMaps.nationilityMap(rq.Con__r.nc__c);
                if (String.isNotBlank(rq.xceml__c)) {
                    insInfo.emailId = rq.xceml__c;
                } else {
                    insInfo.emailId = rq.createdBy.Email;
                }
                //insInfo.PersonalInfo =perInfo;
                insInfo.Name = rq.xcfn__c + ' ' + rq.xcln__c;
                insInfo.DOB = gctlInsHelper.getFDt('' + String.ValueOf(rq.xcbd__c), '-');
                insInfo.PregnantStatus = String.isBlank(rq.xpgs__c) ? 'NO' : gctlInsHelper.upperCase(rq.xpgs__c);
                insInfo.MaritalStatus = String.isNotBlank(rq.xcms__c) ? gctlInsHelper.upperCase(rq.xcms__c) : 'SINGLE';
                insInfo.Gender = (rq.xcslt__c == 'Mr.') ? 'MALE' : 'FEMALE';

                insInfo.PreviouslyCovered =  String.isnotBlank(rq.Con__r.xpmi__c) ?'YES': 'NO';

                if (rq.Con__r.rol__c == 'Student') {
                    insInfo.Relationship = 'ST';
                } else if (rq.Con__r.rol__c == 'Spouse') {
                    insInfo.Relationship = 'S';
                } else if (rq.Con__r.rol__c == 'Child') {
                    insInfo.Relationship = 'C';
                } else {
                    insInfo.Relationship = 'E';
                }
                /*//insInfo.MobileNo = (String.isNotBlank(rq.rmob__c) && rq.rmob__c.length() >= 10) ? rq.rmob__c.right(9) : rq.rmob__c;
                */ /***if (String.isNotBlank(rq.xcmob__c)) {
                    String mob = rq.xcmob__c.trim();
                    mob=mob.replaceAll(' ', '');
                    mob=mob.replaceAll('-', '');
                    if (mob.contains('+971')) {
                        mob=mob.replace('+971', '0');
                    }
                    insInfo.MobileNo = (mob.length()>=10) ? mob.right(9):mob;
                }
                ***/

                if (String.isNotBlank(insMob)) {
                    insMob = insMob.replaceAll(' ', '');
                    insMob = insMob.replaceAll('-', '');
                    if (insMob.contains('+971')) {insMob = insMob.replace('+971', '0');}
                    insInfo.mobileNo = (insMob.length() >= 10) ? insMob.right(9) : insMob;
                }
                insInfo.Nationality = insNt;
                insInfo.PassportNo = gctlInsHelper.upperCase(rq.xcp__c);
                insInfo.UIDNo = (rq.Con__r.rol__c == 'Child' && String.isBlank(rq.Con__r.rpui__c)) ? '0' : rq.Con__r.rpui__c;
                if (rq.xceidid__c != null && rq.xceidid__c.length() == 15) {
                    insInfo.EmiratesId = rq.xceidid__c.substring(0, 3) + '-' + rq.xceidid__c.substring(3, 7) + '-' + rq.xceidid__c.substring(7, 14) + '-' + rq.xceidid__c.substring(14, 15);
                } else {insInfo.EmiratesId = rq.xceidid__c;}
                if (String.isNotBlank(insInfo.EmiratesId)) {
                    insInfo.EmiratesId = insInfo.EmiratesId.replaceAll(' ', '');
                } /*//insInfo.EmiratesIdApplicationNo = (String.isNotBlank(rq.Con__r.xean__c)) ? '800' + rq.Con__r.xean__c : '';*/
                if (!test.isRunningTest()) {
                    If(String.IsBlank(rq.xceidid__c)) {insInfo.EmiratesIdApplicationNo = con.xean__c;}
                }
                /*/(String.isNotBlank(rq.Con__r.xean__c)) ? ((rq.Con__r.xean__c.trim().startsWith('800')) ? rq.Con__r.xean__c.trim() : '800' + rq.Con__r.xean__c.trim()) : '';
                }
                */ /*/insInfo.EmiratesIdApplicationNo ='800126373281817281273' ;
                */
                insInfo.OccupationalIndustry = 'OTHER SERVICES & ACTIVITIES';
                insInfo.WorkLocation = 'AL SAFA SECOND';
                insInfo.Commission = 'No';
                insInfo.ResidenceLocation = String.isNotBlank(rq.Con__r.area__c) ? rq.Con__r.area__c : 'DUBAI';
                String epno = String.isNotBlank(rq.Con__r.e__c) ? rq.Con__r.e__c : rq.Con__r.rp__c; /*/ 201/2016/7/190320*/
                String formattedEpno = '';
                if (string.isNotBlank(epno) && epno.length() > 10) {formattedEpno = epno.substring(0, 10) + '/' + epno.substring(10, epno.length());
                                                                    System.debug('str :' + formattedEpno);
                                                                   }
                insInfo.EntryPermitNo = formattedEpno;
                if (String.isBlank(insInfo.EntryPermitNo) && String.isNotBlank(insInfo.EmiratesId)) { insInfo.EntryPermitNo =  (insInfo.EmiratesId).replaceAll('-', '');}
                insInfo.MemberCategory = 'Dubai residency';

                if (rq.Con__r.rol__c == 'Spouse' || rq.Con__r.rol__c == 'Child') {
                    qInfo.PolicyType = 'F';
                } else { qInfo.PolicyType = 'E';}
                qInfo.VisaEmirate = 'Dubai';
                if (rq.xcma__c == null)rq.xcma__c=0.00;if (rq.xcmta__c == null)rq.xcmta__c=0.00;if (rq.xcmoa__c == null)rq.xcmoa__c=0.00;
                Decimal totalSal = rq.xcmbs__c + rq.xcma__c + rq.xcmta__c + rq.xcmoa__c;
                qInfo.SalaryBand = totalSal > 4000 ? 'ABOVE 4000' : 'BELOW 4000';

                insInfo.SalaryCap = (totalSal <= 4000) ? 'Less than 4000' : (totalSal > 4000 && totalSal <= 12000) ? '4001 and 12000' : 'More than 12000';
                qInfo.PlanType = rq.xintp__c.ToUpperCase();
                qInfo.NoOfPersonsToInsure = '1';
                qInfo.IncludingSponsor = 'NO';
                qInfo.RefNo = rq.xirfn__c;
                qInfo.QuotationNo = rq.xqno__c;
                qInfo.disclaimer = 'YES';
                if (qInfo.PlanType == 'BASIC') {
                    qInfo.SalaryBand = 'BELOW 4000';
                    insInfo.SalaryCap = 'Less than 4000';
                }
                if (!test.isRunningTest() && String.isNotBlank(Con.xpno__c)) {
                    qInfo.MemberId = Con.xpno__c;
                }

                lstInsInfo.add(insInfo);
                plc.PolicyStartDate = ''; /*/gctlInsHelper.getFDt('' + String.ValueOf(system.today()), '-');*/
                plc.PolicyEndDate = ''; /*/gctlInsHelper.getFDt('' + String.ValueOf(System.today().addDays(-1).addYears(1)), '-');*/
                plc.FinalPremiumAmt = String.ValueOf(rq.xtpa__c);
                plc.PaymentType = 'ON ACCOUNT';
                plc.PaymentRefNo = rq.Name;
                Map < String, adnicWS__c > adnicValues = adnicWS__c.getAll();
                pi.PartnerId = adnicValues.get('Json Creation').PartnerID__c;
                ins.QuoteInfo = qInfo;
                ins.SponsorInfo = spInfo;
                ins.InsuredInfo = lstInsInfo;
                ins.PolicyInfo = plc;
                ins.PartnerInfo = pi;
                String jsonBody = JSON.serialize(ins);
                //System.debug('jsonBody:::::' + jsonBody);
                //jsonBody = jsonBody.replace(', "errorInfo":null, "DocumentInfo":null}', '}');
                //System.debug('jsonBody after replacing:::::' + jsonBody);

                ws_call__c ws = new ws_call__c();
                ws.rq_jsn__c = jsonBody;
                ws.ws_typ__c = wsTyp;
                ws.mtd_nm__c = wsMd;
                ws.intsts__c = 'Ready for Integration';
                ws.uid__c = rq.id + '' + ri.Id + '' + ri.sta__c + system.today() + wsMd;
                ws.rq_itm__c = ri.id;
                wsList.add(ws);
            }
        }catch (Exception e) {}
        try {Insert wsList; } catch (Exception e) {}
    }
    public static void uploadPolicyDoc(list < id > rqItSet, map < Id, String > mapItmPolicyGen, map < Id, String > mapRqIdItm, String wsTyp, String wsMd) {
        system.debug('uploadPolicyDoc:::::');
        List < ws_call__c > wsList = new List < ws_call__c > ();
        List < g_Req__c > rqList = new List < g_Req__c > ();
        map < Id, g_reqitem__c > mapReg = new map < Id, g_reqitem__c > ();
        map < Id, map < String, Attachment >> mapAtt = new map < Id, map < String, Attachment >> ();
        map < Id, Id > mapRqItWs = new map < Id, Id > ();
        map < Id, map < String, Id >> reqItmDoc = new map < Id, map < String, Id >> ();
        String docLstLabel = System.Label.inrDocList;
        String attLstLabel = System.Label.inrAttList;
        system.debug('docLstLabel:::::::'+docLstLabel);
        system.debug('attLstLabel:::::::'+attLstLabel);
        List<string>docLst = docLstLabel.split(';');
        List<string>attLst = attLstLabel.split(';');
        List < g_reqDoc__c > rqIDoc = [Select Id, Name, RQ__c, RQ__r.Id from g_reqDoc__c where RQ__c in: mapRqIdItm.values() and Name LIKE :docLst];
        system.debug('rqIDoc:::' + rqIDoc);
        set < Id > reqDcIds = new set < Id > ();
        for (g_reqDoc__c rqDoc: rqIDoc) {
            if (!reqItmDoc.containsKey(rqDoc.RQ__r.Id)) {
                reqItmDoc.put(rqDoc.RQ__r.Id, new map < String, id > ());
            }
            reqItmDoc.get(rqDoc.RQ__r.Id).put(rqDoc.name, rqDoc.Id); reqDcIds.add(rqDoc.Id);
        }
        system.debug('reqDcIds::::' + reqDcIds);
        system.debug('reqItmDoc:::' + reqItmDoc);
        List < Attachment > attList = [Select Id, Body, Description, Name, ParentId from Attachment where ParentId in: reqDcIds and Name LIKE :attLst];
        for (Attachment att: attList) {
            if (!mapAtt.containsKey(att.id)) {mapAtt.put(att.ParentId, new map < String, Attachment > ());}
            mapAtt.get(att.ParentId).put(att.Name, att);
        }
        system.debug('mapAtt::::' + mapAtt);
        for (Id ri: rqItSet) {
            String rqId = mapRqIdItm.get(ri);
            InsuranceWrapper.uploadDoc ins = new InsuranceWrapper.uploadDoc();
            List < InsuranceWrapper.DocumentInfo > lstdocInfo = new List < InsuranceWrapper.DocumentInfo > ();
            InsuranceWrapper.DocumentInfo docInfo = new InsuranceWrapper.DocumentInfo();
            InsuranceWrapper.PartnerInfo pi = new InsuranceWrapper.PartnerInfo();
            try {
                system.debug('JJ inside Passport Copy');
                String mebId = mapItmPolicyGen.get(ri);
                for (String docName:docLst) {
                    system.debug('docName::::'+docName);
                    If(reqItmDoc.get(rqId).get(docName) != null) {
                        /*Entry Permit Copy:UID, Passport:PASSPORT;EIDA Application form:EMIRATESID;*/
                        docInfo.DocumentCategory = docName.contains('Passport')?'PASSPORT':''; docInfo.DocumentName = docName+'.JPG';  docInfo.MemberId = mebId;
                        id rqDocId = reqItmDoc.get(rqId).get(docName);
                        if (mapAtt.get(rqDocId).containsKey(docName+'.jpg')) {
                            docInfo.DocumentContent = EncodingUtil.base64Encode(mapAtt.get(rqDocId).get(docName+'.jpg').Body);
                        }
                        lstdocInfo.add(docInfo);
                        system.debug(docName+' docInfo::::' + docInfo);
                    }
                }
                Map < String, adnicWS__c > adnicValues = adnicWS__c.getAll();
                pi.PartnerId = adnicValues.get('Json Creation').PartnerID__c;
                Integer i = 0;
                for (InsuranceWrapper.DocumentInfo doc: lstdocInfo) {
                    ins.PartnerInfo = pi;
                    List < InsuranceWrapper.DocumentInfo > docList = new List < InsuranceWrapper.DocumentInfo > ();
                    docList.add(doc); ins.DocumentInfo = docList; String jsonBody = JSON.serialize(ins);
                    System.debug('jsonBody : ' + jsonBody);
                    ws_call__c ws = new ws_call__c();
                    ws.rq_jsn__c = jsonBody; ws.ws_typ__c = wsTyp; ws.mtd_nm__c = wsMd;
                    ws.uid__c = rqId + '' + ri + '' + '' + wsMd + i + System.now();
                    ws.rq_itm__c = ri; ws.intsts__c = 'Ready for Integration'; wsList.add(ws);
                    i++;
                }
            } catch (Exception e) {
                System.debug('#Exception : ' + e.getMessage() + ' ' + e.getStackTraceString());
            }
        }
        try {
            Insert wsList;
        } catch (Exception ex) {System.debug('#Exception : ' + ex.getMessage() + ' ' + ex.getStackTraceString());}
    }

    public static void createBankAcc(g_Req__c rq, g_reqitem__c ri) {
        system.debug('######################createBankAcc---'+rq.id);
        try {

                     List<g_reqitem__c> rqI=[select id, name, RQ__r.xadtx1__c  from g_reqitem__c where RQ__c=:rq.id  limit 1];

                    system.debug('######################rqIrqIrqI---'+rqI[0].id);
                     ws_call__c ws = new ws_call__c();
                    ws.rq_jsn__c = rqI[0].RQ__r.xadtx1__c;
                    ws.ws_typ__c = 'CreateBankFu';
                    ws.mtd_nm__c = 'BankAccUpdate';
                    ws.uid__c = rq.id + '' + rqI[0].id + '' + '' + 'BankAccUpdate'  + System.now();
                    ws.rq_itm__c = rqI[0].id; ws.intsts__c = 'Ready for Integration';
                    if (Schema.sObjectType.ws_call__c.isCreateable()) {
                        insert ws;
                    }
        } catch (Exception ex) {System.debug('#Exception : ' + ex.getMessage() + ' ' + ex.getStackTraceString());}

 }

    public static void createCDBGRefund(g_Req__c rq, g_reqitem__c ri) {
        system.debug('######################createBankAcc---'+rq.id);
        try {
            List<g_reqitem__c> rqI=[select id, sta__r.cd__c, xrramt__c, xramt__c, xcnotes__c, name, RQ__r.xadtx1__c  from g_reqitem__c where RQ__c=:rq.id  limit 1];
            String  refundJson=rqI[0].RQ__r.xadtx1__c;
            customerRefund crf=    (customerRefund) System.JSON.deserialize(refundJson, customerRefund.class);
            if (rqI[0].xramt__c != null && rqI[0].xramt__c>0  ) {
                crf.REFUND_AMOUNT=rqI[0].xramt__c;
                crf.REMITTANCE_MESSAGE_2=rqI[0].xcnotes__c;
                refundJson=JSON.serialize(crf);
            }
            system.debug('######################rqIrqIrqI---'+rqI[0].id);
            ws_call__c ws = new ws_call__c();
            ws.rq_jsn__c = refundJson;
            ws.ws_typ__c = 'CreateCDBGREF';
            ws.mtd_nm__c = 'CustomerRefund';
            ws.uid__c = rq.id + '' + rqI[0].id + '' + '' + 'CustomerRefund'  + System.now();
            ws.rq_itm__c = rqI[0].id;
            ws.intsts__c = 'Ready for Integration';
            if (Schema.sObjectType.ws_call__c.isCreateable()) {
                insert ws;
            }
        }
        catch (Exception ex) {
            System.debug('#Exception : ' + ex.getMessage() + ' ' + ex.getStackTraceString());
        }
    }
    public static void createMedicalRequest(List < g_reqitem__c > riLst, String wsTyp, String wsMd) {
        List < ws_call__c > wsList = new List < ws_call__c > ();
        Set<Id> rqidLst = new Set<Id>();
        List < BusinessHours > mBH = [select id from BusinessHours where IsDefault = true];
        if (riLst != null && !riLst.isEmpty()) {
            for (g_reqitem__c ri: riLst) rqidLst.add(ri.RQ__c);
            for (g_reqitem__c ri: [select id, exp__c from g_reqitem__c where RQ__c=:rqidLst and itm__r.cd__c = 'md' and sta__r.cd__c in ('n', 'rv', 'v')]) {
                ws_call__c wc = new ws_call__c();
                wc.rq_itm__c = ri.id;
                wc.ws_typ__c = wsTyp;
                wc.mtd_nm__c = wsMd;
                DateTime dt = BusinessHours.add(mBH[0].id, System.now(), 60 * 60 * 1000L * 16);
                wc.sdt__c = dt;
                wc.intsts__c = 'Ready for Integration';
                if (ri.exp__c) wc.sdt__c = datetime.now();
                wsList.add(wc);
            }
        }
        if (wsList != null && !wsList.isEmpty()) insert wsList;
    }
    //public static void createRPRequest(List < g_reqitem__c > riLst, String wsTyp, String wsMd) { List < ws_call__c > wsList = new List < ws_call__c > (); Set < Id > rqidLst = new Set < Id > (); Set < Id > rqMokidLst = new Set < Id > (); if (riLst != null && !riLst.isEmpty()) { for (g_reqitem__c ri: riLst) rqidLst.add(ri.RQ__c); for (g_reqitem__c ti: [select id, RQ__c from g_reqitem__c where RQ__c =: rqidLst and itm__r.cd__c in ('md', 'moh') and Sta__r.cd__c = 'ok']) { rqMokidLst.add(ti.RQ__c); } for (g_reqitem__c ri: [select id, exp__c from g_reqitem__c where AD__c <= 0 and RQ__c =: rqMokidLst and itm__r.cd__c = 'rp' and sta__r.cd__c in ('n', 'rv', 'v', 'ppr', 'dec', 'dcc', 'ics', 'aid', 'rc', 'nc') ]) { ws_call__c wc = new ws_call__c(); wc.rq_itm__c = ri.id; wc.ws_typ__c = wsTyp; wc.mtd_nm__c = wsMd; wc.intsts__c = 'Ready for Integration'; wc.sdt__c = datetime.now(); wsList.add(wc); } } if (wsList != null && !wsList.isEmpty()) insert wsList; }
    public static void createRPRequest(List < g_reqitem__c > riLst, String wsTyp, String wsMd) {
        List < ws_call__c > wsList = new List < ws_call__c > ();
        Set < Id > rqidLst = new Set < Id > ();
        Set < Id > noMedidLst = new Set < Id > ();
        Set < Id > rqMokidLst = new Set < Id > ();
        Set < Id > MedidLst = new Set < Id > ();
        if (riLst != null && !riLst.isEmpty()) {
            for (g_reqitem__c ri: riLst) {
                rqidLst.add(ri.RQ__c);
                noMedidLst.add(ri.RQ__c);
            }
            for (g_reqitem__c ti: [select id, RQ__c from g_reqitem__c where RQ__c =: rqidLst and itm__r.cd__c in ('md', 'moh') and Sta__r.cd__c = 'ok']) {
                rqMokidLst.add(ti.RQ__c);
            }
            for (g_reqitem__c ti: [select id, RQ__c from g_reqitem__c where RQ__c =: rqidLst and itm__r.cd__c in ('md', 'moh')]) {
                MedidLst.add(ti.RQ__c);
            }
            noMedidLst.removeAll(MedidLst);
            for (g_reqitem__c ti: [select id, RQ__c from g_reqitem__c where RQ__c =: noMedidLst and itm__r.cd__c in ('ia') and Sta__r.cd__c in ('ok', 'ebn', 'ebr')]) {
                rqMokidLst.add(ti.RQ__c);
            }
            for (g_reqitem__c ri: [select id, exp__c from g_reqitem__c where AD__c <= 0 and RQ__c =: rqMokidLst and(itm__r.cd__c = 'rp' or itm__r.cd__c = 'ins') and Name!='Golden Residency' and sta__r.cd__c in ('n',
                'rv', 'v', 'ppr', 'dec', 'dcc', 'ics', 'aid',
                'rc', 'nc')]) {
                ws_call__c wc = new ws_call__c();
                wc.rq_itm__c = ri.id;
                wc.ws_typ__c = wsTyp;
                wc.mtd_nm__c = wsMd;
                wc.intsts__c = 'Ready for Integration';
                wc.sdt__c = datetime.now();
                wsList.add(wc);
            }
        }
        if (wsList != null && !wsList.isEmpty()) insert wsList;
    }
    public static void createLARequest(List < g_reqitem__c > riLst, String wsTyp, String wsMd) {
        List < ws_call__c > wsList = new List < ws_call__c > ();
        Set < Id > rqidLst = new Set < Id > ();
        Set < Id > rqMokidLst = new Set < Id > ();
        if (riLst != null && !riLst.isEmpty()) {
            for (g_reqitem__c ri: riLst) rqidLst.add(ri.RQ__c);
            for (g_reqitem__c ri: [select id, exp__c from g_reqitem__c where AD__c <= 0 and RQ__c =: rqidLst and itm__r.cd__c = 'la' and sta__r.cd__c in ('n', 'rv', 'v') ]) {
                ws_call__c wc = new ws_call__c();
                wc.rq_itm__c = ri.id;
                wc.ws_typ__c = wsTyp;
                wc.mtd_nm__c = wsMd;
                wc.intsts__c = 'Ready for Integration';
                wc.sdt__c = datetime.now();
                wsList.add(wc);
            }
        }
        if (wsList != null && !wsList.isEmpty()) insert wsList;
    }
    public static void createUserLA(List < id > riLst) {
        List < ws_call__c > wsList = new List < ws_call__c > ();
        Set < Id > rqidLst = new Set < Id > ();
        List<Account> lstAcc = new List<Account>();
        if (riLst != null && !riLst.isEmpty()) {
            List < g_reqitem__c > riList =  [select id, exp__c, RQ__c, RQ__r.Acc__c, RQ__r.Acc__r.lc__c from g_reqitem__c where id IN :riLst];
            ws_call__c wsCall = new ws_call__c();
            wsCall.rq_jsn__c = riList[0].RQ__r.Acc__r.lc__c;
            wsCall.pmid__c = riList[0].RQ__r.Acc__c;
            wsCall.intsts__c = 'Ready for Integration';
            wsCall.ws_typ__c = 'UserCreation';
            wsList.add(wsCall);
        }
        if (wsList != null && !wsList.isEmpty()) insert wsList;
    }
    public static void createLAMD(List < g_reqitem__c > riLst, String wsTyp, String wsMd) {
        List < ws_call__c > wsList = new List < ws_call__c > ();
        Set < Id > rqidLst = new Set < Id > ();
        Set < Id > rqMokidLst = new Set < Id > ();
        if (riLst != null && !riLst.isEmpty()) {
            for (g_reqitem__c ri: riLst) rqidLst.add(ri.RQ__c);
            for (g_reqitem__c ri: [select id, exp__c,
                RQ__r.Name from g_reqitem__c where AD__c <= 0 and RQ__c =: rqidLst and itm__r.cd__c = 'ddd' and sta__r.cd__c in ('n',
                'rv', 'v', 'rc', 'rcc', 'ok') ]) {
                String reqjs = '{ "serviceRequests": [ { "axsRefNo": "'+ri.RQ__r.Name+'", "customerFeedback":"Delivered"} ] } ';
                ws_call__c wc = new ws_call__c();
                wc.rq_itm__c = ri.id;
                wc.rq_jsn__c = reqjs;
                wc.ws_typ__c = wsTyp;
                wc.mtd_nm__c = wsMd;
                wc.intsts__c = 'Ready for Integration';
                wc.sdt__c = datetime.now();
                wsList.add(wc);
            }
        }
        if (wsList != null && !wsList.isEmpty()) insert wsList;
    }

}
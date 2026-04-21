public class ObTmplCtl {
    public string role {
        set;
        get;
    }
    public string memName {
        set;
        get;
    }
    public string rid {
        set;
        get;
    }
    public string cmpname {
        set;
        get;
    }
    public List < g_Req__c > rLst {
        set;
        get;
    }
    public list < Member > memberLst {
        set;
        get;
    }
    public LARequestWrapper adhoc3Data {
        set;
        get;
    }
    public boolean shwPt2 {
        get;
        set;
    }
    public DccaBatchUtil.LAResponseWrapper adhoc4Data {
        set;
        get;
    }
    public ctrlLAReqWrapper laReqWrapper {
        set;
        get;
    }
    public LARequestWrapper.Members memInfo {
        set;
        get;
    }
    public List < LARequestWrapper.Members > dir_add {
        set;
        get;
    }
    public mdWrapper.IdentityInfo gm {
        set;
        get;
    }
    public LARequestWrapper.Members memberInfo {
        set;
        get;
    }
    public DDAMembersWrapper.LicenseInfos companyInfo {
        get;
        set;
    }
    public List < LARequestWrapper.Members > dir_remove {
        set;
        get;
    }
    public LARequestWrapper.Addresses homeAddress {
        set;
        get;
    }
    public LARequestWrapper.Addresses uaeAddress {
        set;
        get;
    }
    public String gmFullName {
        get;
        set;
    }
    public String gmPPNo {
        get;
        set;
    }
    public String gmNationality {
        get;
        set;
    }
    public string auditorName {
        get;
        set;
    }
    public string lcNo {
        get;
        set;
    }
    public g_req__c rq {
        get;
        set;
    }
    public List < mdWrapper > mdList {
        get;
        set;
    }
    public List < mdWrapper.IdentityInfo > infoList {
        get;
        set;
    }
    public List < DDAMembersWrapper.Members > allMembers {
        get;
        set;
    }
    public DDAMembersWrapper.Members currentGM {
        get;
        set;
    }
    public List < String > listActivities {
        get;
        set;
    }
    public List < String > ddaIDs {
        get;
        set;
    }
    public List < String > listSegments {
        get;
        set;
    }
    public List < String > listDirectors {
        get;
        set;
    }
    public ObTmplCtl() {
        rid = apexpages.currentpage().getparameters().get('id');
        String memId = apexpages.currentpage().getparameters().get('mid');
        listActivities = new List < String > ();
        ddaIDs = new List < String > ();
        listSegments = new List < String > ();
        rq = [select id, xcamc__c, Service_Code__c, createddate, name, acc__r.lc__c, acc__r.name, acc__r.Legal_Framework__c, xcfn__c, xcnc__c, xadh__c, xadtx2__c, xadtx3__c, xadtx4__c from g_req__c where id =: rid];
        List < g_reqDoc__c > rd = new List < g_reqDoc__c > ();
        List < g_reqDoc__c > passportDocList = new List < g_reqDoc__c > ();
        String ricDoc = '', ppDocName = '', genRicName = '';
        if (rq.Service_Code__c == '220') {
            rd = [SELECT Id, ppn__c, Name FROM g_reqDoc__c WHERE Id =: memId];
            if (!rd.isEmpty()) {
                String recName = rd[0].Name;
                ricDoc = recName;
                if (recName.contains('-')) ricDoc = recName.substringAfter('-').trim();
                ppDocName = 'Passport Copy - ' + ricDoc;
            }
            passportDocList = [SELECT Id, ppn__c, Name, (SELECT Id, Name FROM Attachments) FROM g_reqDoc__c WHERE Name =: ppDocName AND rq__c =: rid];
            if (!passportDocList.isEmpty()) {
                g_reqDoc__c reqDoc = passportDocList[0];
                if (reqDoc.Attachments != null && !reqDoc.Attachments.isEmpty()) {
                    String attName = reqDoc.Attachments[0].Name;
                    genRicName = attName;
                    if (attName.contains('-')) genRicName = attName.substringAfter('-').trim();
                    if (genRicName.contains('.')) genRicName = genRicName.substring(0, genRicName.lastIndexOf('.'));
                }
            }
        }
        if (!String.isEmpty(rq.xadtx4__c) && rq.Service_Code__c == '220') {
            if (rq.xcamc__c.contains('Segment') || rq.xcamc__c.contains('Activity') || rq.xcamc__c.contains('Ttile') || rq.xcamc__c.contains('Channel')) {
                laReqWrapper = (ctrlLAReqWrapper) JSON.deserialize(rq.xadtx3__c, ctrlLAReqWrapper.class);
                for (ctrlLAReqWrapper.Activities objAct: laReqWrapper.ServiceRequests[0].Activities) {
                    listActivities.add(objAct.name);
                    ddaIDs.add(objAct.ddaId);
                }
                adhoc4Data = (DccaBatchUtil.LAResponseWrapper) JSON.deserialize(rq.xadtx4__c, DccaBatchUtil.LAResponseWrapper.class);
                for (DccaBatchUtil.SrActivities activity: adhoc4Data.srList[0].srActivities) {
                    if (ddaIDs.contains(activity.ddaId) && !listSegments.contains(activity.segmentName)) listSegments.add(activity.segmentName);
                }
            }
        } else {
            adhoc4Data = null;
        }
        if (rq.xcamc__c == 'Change of General Manager') role = 'General Manager';
        if (rq.xcamc__c == 'Appoint/Change of Secretary') role = 'Secretary';
        adhoc3Data = (LARequestWrapper) System.JSON.deserialize(rq.xadtx3__c, LARequestWrapper.class);
        if (adhoc3Data.serviceRequests != null && adhoc3Data.serviceRequests[0].members != null && !adhoc3Data.serviceRequests[0].members.isEmpty()) {
            auditorName = adhoc3Data.serviceRequests[0].members[0].operatingName;
            lcNo = adhoc3Data.serviceRequests[0].members[0].registrationNo;
            memInfo = adhoc3Data.serviceRequests[0].members[0];
            if (memInfo.positions == 'Manager') memInfo.positions = 'General Manager';
            if (!String.isBlank(rq.xadtx2__c)) {
                for (LARequestWrapper.Members m: adhoc3Data.serviceRequests[0].members) {
                    String memberName = (m.firstname + ' ' + m.laStname).trim();
                    if (memberName.toLowerCase() == genRicName.toLowerCase()) {
                        memInfo = m;
                        break;
                    }
                }
            }
            if (rq.xcamc__c == 'Change of General Manager' || rq.xcamc__c == 'Appoint/Change of Secretary') {
                for (LARequestWrapper.Members m: adhoc3Data.serviceRequests[0].members) {
                    if (m.actiontype != 'DataUpdate') memInfo = m;
                }
            }
            if (memInfo != null && memInfo.addresses != null) {
                for (LARequestWrapper.Addresses addr: memInfo.addresses) {
                    if (addr.type == 'UAE' && !String.isBlank(addr.postalcode)) {
                        addr.area = addr.buildingNo + ',' + addr.street + ',' + addr.area;
                        uaeAddress = addr;
                    }
                    if (addr.type == 'HOME') homeAddress = addr;
                }
            }
        }
        dir_add = new List < LARequestWrapper.Members > ();
        dir_remove = new List < LARequestWrapper.Members > ();
        memName = apexpages.currentpage().getparameters().get('mn');
        rq = [select id, createddate, xcamc__c, name, acc__r.lc__c, acc__r.name, acc__r.Legal_Framework__c, xcfn__c, xcnc__c, xadh__c, xadtx3__c from g_req__c where id =: rid];
        adhoc3Data = (LARequestWrapper) System.JSON.deserialize(rq.xadtx3__c, LARequestWrapper.class);
        Map < String, LARequestWrapper.Members > mebMap = new Map < String, LARequestWrapper.Members > ();
        Map < String, LARequestWrapper.Members > rmvMenbMap = new Map < String, LARequestWrapper.Members > ();
        if (adhoc3Data.serviceRequests != null) {
            for (LARequestWrapper.Members mem: adhoc3Data.serviceRequests[0].members) {
                if (mem.positions == 'Director' && (mem.actionType == 'ADD' || mem.actionType == 'UPDATEINFO')) {
                    if (!mebMap.containsKey(mem.passports[0].docNo)) mebMap.put(mem.passports[0].docNo, mem);
                } else if (mem.positions == 'Director' && mem.actionType == 'REMOVE') {
                    rmvMenbMap.put(mem.passports[0].docNo, mem);
                }
                if (String.isNotBlank(memName)) {
                    String fullName = mem.firstName + ' ' + mem.lastName;
                    if (fullName == memName) {
                        mem.gender = mem.gender == 'F' ? 'Female' : 'Male';
                        memberInfo = mem;
                        for (LARequestWrapper.Addresses addr: mem.addresses) {
                            if (addr.type == 'UAE') {
                                addr.area = addr.buildingNo + ',' + addr.street + ',' + addr.area;
                                uaeAddress = addr;
                            }
                            if (addr.type == 'HOME') homeAddress = addr;
                        }
                    }
                }
            }
        }
        dir_add = mebMap.values();
        dir_remove = rmvMenbMap.values();
    }
    public void fetchMembers() {
        shwPt2 = true;
        String jsonStr = '{ "licenseNos": [ "' + rq.acc__r.lc__c + '" ] }';
        String responseBody = '';
        if (!Test.isRunningTest()) {
            responseBody = DDAServices.getDDAServices(Label.LA_DDA_End_Point, 'licenseAmendment/getLicenseInfo', 'POST', jsonStr);
            DDAMembersWrapper ref = (DDAMembersWrapper) System.JSON.deserialize(responseBody, DDAMembersWrapper.class);
            companyInfo = ref.LicenseInfos[0];
            allMembers = ref.LicenseInfos[0].Members;
            for (DDAMembersWrapper.Members mem: ref.LicenseInfos[0].Members) {
                if (mem.positions.contains('Manager')) currentGM = mem;
                system.debug('--mem--' + mem);
                if (!mem.positions.contains('Secretary') && rq.xcamc__c == 'Appointment Change of Secretary') {
                    shwPt2 = false;
                }
                if (rq.xcamc__c == 'Change of General Manager' && mem.positions.contains('Manager')) currentGM = mem;
                if (rq.xcamc__c == 'Appoint/Change of Secretary' && mem.positions.contains('Secretary')) currentGM = mem;
            }
        }
    }
    public void directorsInfo() {
        String jsonStr = '{"methodname":"membersupdate", "data":{"licenseNum":"' + rq.acc__r.lc__c + '"}}';
        String responseBody = '';
        if (!Test.isRunningTest()) {
            responseBody = DDAServices.getDDAServices(Label.LA_DDA_End_Point, 'onbordingapi', 'POST', jsonStr);
            infoList = new List < mdWrapper.IdentityInfo > ();
            mdList = (List < mdWrapper > ) System.JSON.deserialize(responseBody, List < mdWrapper > .class);
            gmFullName = adhoc3Data.serviceRequests[0].members[0].firstName + ' ' + adhoc3Data.serviceRequests[0].members[0].lastName;
            gmNationality = adhoc3Data.serviceRequests[0].members[0].nationality;
            gmPPNo = adhoc3Data.serviceRequests[0].members[0].passports[0].docNo;
            system.debug('adhoc3Data[0].members -- ' + adhoc3Data);
            gm = new mdWrapper.IdentityInfo();
            system.debug('mdList -- ' + mdList);
            mdList[0].DirectersIdentityInfo = new List < mdWrapper.IdentityInfo > ();
            mdList[0].MembersIdentityInfo = new List < mdWrapper.IdentityInfo > ();
            for (mdWrapper.IdentityInfo info: mdList[0].IdentityInfo) {
                if (info != null && info.role == 'Director') {
                    mdList[0].DirectersIdentityInfo.add(info);
                } else if (info != null && info.role == 'Manager') {
                    gm = info;
                } else if (info != null) {
                    mdList[0].MembersIdentityInfo.add(info);
                }
            }
        }
    }
    public void memberInfo() {
        rid = apexpages.currentpage().getparameters().get('id');
        memberLst = new list < Member > ();
        Map < String, String > mbmp = new Map < String, String > ();
        if (string.isNotBlank(rid)) {
            rLst = [select id, xdei__c, xcfn__c, xadtx3__c, xfb__c, Acc__r.name from g_Req__c where id =: rid];
            if (rLst != null && !rLst.isEmpty()) {
                cmpname = rLst[0].Acc__r.name;
                String jsbody = '{"serviceRequestId":"' + rLst[0].xdei__c + '","Regenerate":"true","Method":"GetResolutionInfo","LicenseNumber":"104248","Data":{"resolution":null,"pdfParams":null,"documentName":"Resolution","docConfig":null,"body":null,"aoaParams":null}}';
                Http h = new Http();
                HttpRequest request = new HttpRequest();
                HttpResponse response = new HttpResponse();
                request.setHeader('Content-Type', 'application/json');
                request.setHeader('accept', 'application/json');
                request.setEndpoint('callout:DCCA_Auth/apexrest/LicenseService');
                request.setMethod('POST');
                request.setBody(jsbody);
                request.setTimeout(60000);
                try {
                    if (!Test.isRunningTest()) response = h.send(request);
                    if (response.getStatusCode() == 200) {
                        String jsonResp = response.getBody();
                        System.debug('###<getDocument> jsonResp: ' + jsonResp);
                        grqWsDccaGetService.Document data = (grqWsDccaGetService.Document) JSON.deserialize(jsonResp, grqWsDccaGetService.Document.class);
                        if (data != null && data.Data != null) {
                            /*data != null && data.Data != null) {*/
                            PDFGeneratorWS.Resoulution_PDF_Param resparam = data.Data.resolution;
                            mbmp.put(resparam.manager.name, resparam.manager.position);
                            if (rLst[0].xfb__c == 'FZ-LLC') {
                                if (resparam.shareholders.Member != null && !resparam.shareholders.Member.isEmpty()) {
                                    for (PDFGeneratorWS.Member mb: resparam.shareholders.Member) {
                                        if (mb.position == 'Individual Shareholder') {
                                            if (mbmp != null && mbmp.containsKey(mb.name)) {
                                                String ps = mbmp.get(mb.name);
                                                ps = ps + ',' + 'Shareholder';
                                                mbmp.put(mb.name, ps);
                                            } else mbmp.put(mb.name, 'Shareholder');
                                        }
                                    }
                                }
                                if (resparam.directors.Member != null && !resparam.directors.Member.isEmpty()) {
                                    for (PDFGeneratorWS.Member mb: resparam.directors.Member) {
                                        if (mb.position == 'Director') {
                                            if (mbmp != null && mbmp.containsKey(mb.name)) {
                                                String psdr = mbmp.get(mb.name);
                                                psdr = psdr + ',' + 'Director';
                                                mbmp.put(mb.name, psdr);
                                            } else mbmp.put(mb.name, 'Director');
                                        }
                                    }
                                }
                            }
                            for (String mbr: mbmp.keyset()) {
                                Member m = new Member();
                                m.name = mbr;
                                m.position = mbmp.get(mbr);
                                memberLst.add(m);
                            }
                            system.debug('Mem lst:' + memberLst);
                        }
                    }
                } catch (System.CalloutException e) {
                    System.debug('###<getMemberDocument> Exception: ' + e.getMessage() + ' ###ExpStack: ' + e.getStackTraceString());
                }
            }
        }
    }
    public class Member {
        public string name {
            set;
            get;
        }
        public string position {
            set;
            get;
        }
    }

}
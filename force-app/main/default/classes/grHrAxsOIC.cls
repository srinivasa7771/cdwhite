global class grHrAxsOIC {

    public static final String FAILURE_MSG = 'Failed to Insert.';
    public static final String SUCCESS = '0';
    public static final String FAILED = '1';

    webservice static rqResp createDepReq(hcRequest hcrq) {
        rqResp resp = new rqResp();
        resp.personExtraInfoId = hcrq.personExtraInfoId;
        System.debug('<< hcrq >> : ' + hcrq);

        String name = hcrq.firstName;
        String lName= hcrq.lastName;
        String gender= hcrq.gender;
        String relationship = hcrq.relationship;
        String passportNo = hcrq.passportNo;
        String nationality = hcrq.nationality;
        String pExpiryDate = hcrq.pExpiryDate;
        String pIssueDate = hcrq.pIssueDate;
        String pPlaceofIssue = hcrq.pPlaceofIssue;
        String birthDate = hcrq.dob;
        String personId = String.isNotBlank(hcrq.personId) ? 'TG'+hcrq.personId : '';
        if (String.isNotBlank(nationality) && String.isNotBlank(passportNo)) {
            List<Contact> spon = new List<Contact>(); String sponAXSid = '';
            if (String.isNotBlank(hcrq.sponsorAxsID) ) {sponAXSid = hcrq.sponsorAxsID;System.debug('sponsorAxsID : ' + hcrq.sponsorAxsID);
            }
            else if (String.isNotBlank(hcrq.personId)) {
                spon = [SELECT id, name, idtxt__c from contact WHERE idtxt__c=:personId];
                if (spon.size()>0) {
                    sponAXSid = spon[0].id;
                    System.debug('sponId : ' + spon[0].id);
                }
            }

            System.debug('sponAXSid : ' + sponAXSid);
            system.debug('System.Label.TecomAccnt:::'+System.Label.TecomAccnt);
            if (String.isBlank(sponAXSid)) {resp.status = FAILURE_MSG;   resp.respCode='1';resp.respMsg = 'sponsorAxsID should not be blank.';return resp;}
            System.debug('hcrq::::'+hcrq);
            g_req__c rq = new g_req__c( xcfn__c=name, xcln__c=lName, Spr__c=sponAXSid, xcp__c=passportNo,
                xcnc__c=nationality, xcpip__c=pPlaceofIssue, xcbd__c=Date.parse(birthDate), xcpid__c=Date.parse(pIssueDate),
                xcped__c=Date.parse(pExpiryDate), xcslt__c = (gender=='Male') ? 'Mr.' : 'Mrs.', xdccn__c = hcrq.costCenterName,
                sta__c='Draft', Acc__c=System.Label.TecomAccnt);

            rq.srvc__c = relationship.equalsIgnoreCase('Child') ? System.Label.childVisa_sfId : System.Label.spouseVisa_sfId; //'a0L2000000YQVLDEA5':'a0L2000000YQVLEEA5';
            try{
                if (Schema.sObjectType.g_req__c.isCreateable()) {
                    insert rq;
                }

                List<g_req__c> lstRq = [SELECT Id, Name, Con__c From g_req__c where id=:rq.id];
                if (lstRq.size()>0) {
                    resp.axsId = lstRq[0].Id;
                    resp.SRN =  lstRq[0].Name;
                    resp.conID =  lstRq[0].Con__c;
                    resp.status = 'Success';
                    resp.respMsg = 'Request# '+  lstRq[0].Name +' Inserted Successfully';
                    resp.respCode=SUCCESS;
                }else{resp.status = FAILURE_MSG;   resp.respCode=FAILED;resp.respMsg = 'Technical error. Please try after some time or contact axs-support.';}

            }catch (Exception ex) {
                resp.status = FAILURE_MSG;   resp.respCode=FAILED;
                //response msg should not contain more than 499 chars
                if (String.isNotBlank(ex.getMessage()) && ex.getMessage().length()>498) {resp.respMsg = ex.getMessage().substring(0, 498);  }else{resp.respMsg = ex.getMessage();}
            }

        }else{resp.status = FAILURE_MSG; resp.respCode=FAILED;resp.respMsg = 'Passport# and Nationality cannot be Blank.';}

        System.debug('RESPONSE : ' + resp);return resp;
    }

    /*webservice static rqResp insertDoc(String reqNo, String docName, String docBody) {

        rqResp resp = new rqResp();

        List<g_reqDoc__c> lstRqDoc = [Select Id, name from g_reqDoc__c WHERE RQ__r.name=:ReqNo AND Name=:docName];

        if (lstRqDoc.size()>0) {
            Attachment attachment   = new Attachment();
            attachment.contentType   = 'application/pdf';
            attachment.name      = docName + '.pdf';
            attachment.parentId   = lstRqDoc[0].Id;
            attachment.body     = EncodingUtil.base64Decode(docBody);

            try{
                if (Schema.sObjectType.Attachment.isCreateable()) {
                    insert attachment;
                }
                resp.status = 'Inserted successfully.';   resp.respCode=SUCCESS;
            }catch (Exception ex) {
                resp.status = FAILURE_MSG;   resp.respCode=FAILED;
                if (String.isNotBlank(ex.getMessage()) && ex.getMessage().length()>498) {
                    resp.respMsg = ex.getMessage().substring(0, 498);
                }else{resp.respMsg = ex.getMessage();}
            }
        }else{resp.status = 'No such Request Document Found - [' + docName +']';   resp.respCode=SUCCESS;}

        return resp;
    }

    webservice static hcRequest getReqDetails(String reqNumber) {
        hcRequest hcrq = new hcRequest();  //76871420190618

        List<g_req__c> lstRq = [SELECT Id, Name, xcslt__c, xcfn__c, xcln__c, xcbd__c, xcp__c,
            xcpid__c, xcped__c, xcpip__c, xceidid__c, xceididt__c, xceidedt__c, xcmn__c, xcfan__c,
            xcmon__c, xclnar__c, xcmnar__c, xcms__c, xcbp__c, xcbc__c,  xcrlg__c, xcnc__c, xcnp__c,
            xcpic__c, xchph__c, xcha__c , xcmob__c , xceml__c , xbrnd__c , rmob__c , xbn__c,
            xaloc__c, nt__c, xcemrt__c, xccty__c, xcstrt__c, xcarea__c, xcpobx__c, xcacctp__c,
            xcpobxarea__c FROM g_req__c WHERE Name=:reqNumber];

        if (lstRq.size()>0) {
            g_req__c rq = lstRq[0];
            hcrq.salutation = rq.xcslt__c;    hcrq.firstName = rq.xcfn__c;
            hcrq.lastName = rq.xcln__c;      hcrq.dob = ''+rq.xcbd__c;
            hcrq.passportNo = rq.xcp__c;    hcrq.pIssueDate = ''+rq.xcpid__c;
            hcrq.pExpiryDate = ''+rq.xcped__c;  hcrq.pPlaceofIssue = rq.xcpip__c;
            //hcrq.relationship = rq.xcslt__c;   hcrq.isInsideUAE = rq.xcslt__c; hcrq.sponsorName = rq.xcslt__c;   hcrq.UIDNo = rq.xcslt__c; hcrq.EIDA = rq.xceidid__c;

            hcrq.emiratesID = rq.xceidid__c;  hcrq.EIDAExpiryDate = ''+rq.xceidedt__c;  hcrq.EIDAIssueDate = ''+rq.xceididt__c;
            hcrq.middleName = rq.xcmn__c;     hcrq.fatherName = rq.xcfan__c;
            hcrq.motherName = rq.xcmon__c;     hcrq.lastNameAr = rq.xclnar__c;
            hcrq.middleNameAr = rq.xcmnar__c;   hcrq.mStatus = rq.xcms__c;
            hcrq.placeOfBirth = rq.xcbp__c;    hcrq.counrtyOfBirth = rq.xcbc__c;
            hcrq.religion = rq.xcrlg__c;     hcrq.curNationality = rq.xcnc__c;
            hcrq.prevNationality = rq.xcnp__c;  hcrq.pIssuingCountry = rq.xcpic__c;
            hcrq.hCPhone = rq.xchph__c;      hcrq.addOutUAE = rq.xcha__c;
            hcrq.mobile = rq.xcmob__c;      hcrq.email = rq.xceml__c;
            ///hcrq.qLevel = rq.xcql__c;    hcrq.fieldOfStudy = rq.xcfs__c; hcrq.occupationType = rq.xcot__c;  hcrq.occupationField = rq.xcnp__c;
            hcrq.deliveryZone = rq.xbrnd__c;  hcrq.refMobile = rq.rmob__c;
            hcrq.buildingName = rq.xbn__c;    hcrq.location = rq.xaloc__c;
            hcrq.emirate = rq.xcemrt__c;    hcrq.city = rq.xccty__c;
            hcrq.street = rq.xcstrt__c;      hcrq.area = rq.xcarea__c;
            hcrq.POBox = rq.xcpobx__c;       hcrq.accomodationType = rq.xcacctp__c;
             hcrq.notes = rq.nt__c;        hcrq.POBoxArea = rq.xcpobxarea__c;

        }

        System.debug('hcrq : ' + hcrq);

        return hcrq;
    }*/

    global class HcRequest {
        webService String firstName, personId, AXSID, lastName, dob, gender, relationship,
            nationality, isInsideUAE, passportNo, pIssueDate, pExpiryDate, pPlaceofIssue, occupationField,
            refMobile, deliveryZone, buildingName, location, notes, emirate, city, street, area,
            POBox, POBoxArea, accomodationType;
        webService String RPN, sponsorType, sponsorName, sponsorAxsID, UIDNo, rpIssueDate, rpExpiryDate, emiratesID, EIDA, EIDAIssueDate, EIDAExpiryDate, eidExpiryDate, personExtraInfoId;
        webService String costCenterName, salutation, middleName, fatherName, motherName,
            firstNameAr, lastNameAr, middleNameAr, mStatus, placeOfBirth, counrtyOfBirth, religion,
            curNationality, prevNationality, pIssuingCountry, hCPhone, addOutUAE, mobile, email,
            qLevel, fieldOfStudy, occupationType;
    }
    global class rqResp {webService String respCode, personExtraInfoId , status, respMsg, SRN, axsId, conID;}

}
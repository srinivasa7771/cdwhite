public class gwsPMSIntegration {

    public static String upsertContractInfo(ws_call__c ws) {
       String reqBody = '', resStr = '';
       String licNo = '', partyId='', licType='';
       try{
         //List<Account> accLst = [select id, name, ORACLE_PARTY_ID__c, park__c from account where lc__c=:licNo];
         if (ws.ws_typ__c == 'Onboarding') {
            licType = 'New';
           }
            else{
                licNo = ws.rq_itm__r.RQ__r.Acc__r.lc__c;
                licType = 'Renewal';
            }
           String endPoint = 'callout:TECOM_QA/apexrest/pms';
           //String endPoint = 'callout:'+label.CRM_Instance+'/apexrest/pms';
           partyId = ws.rq_itm__r.RQ__r.Acc__r.ORACLE_PARTY_ID__c;
           List<PMSDataWrapper.ContractInformation> contractList = null;
           if (ws.ws_typ__c == 'Onboarding')
              contractList = (List<PMSDataWrapper.ContractInformation>) Json.deserialize(ws.rq_itm__r.RQ__r.activitiesFL__c, List<PMSDataWrapper.ContractInformation>.class);
           else{
               List<String> ofcItmCdList = Label.PMSOfcItmCd.split(';');
               contractList = new List<PMSDataWrapper.ContractInformation>();
               List<g_reqitem__c> rilcList = [select id, xpreno__c, xptp__c, xpstp__c, xoffnoarb__c,
                   xlesd__c, xplt__c, xpltar__c, xasf__c, xcasqm__c, xargno__c, xflr__c, xflrarb__c,
                   xisma__c, xleed__c, xbldg__c, xbldgarb__c from g_reqitem__c where rq__c=: ws.rq_itm__r.RQ__c and xleatp__c='PMS Lease' and itm__r.cd__c=:ofcItmCdList];
                if (rilcList != null && !rilcList.isEmpty()) {

                 Map<String, List<g_reqitem__c>> lsMp = new Map<String, List<g_reqitem__c>>();
                  for (g_reqitem__c ri: rilcList) {
                      if (lsMp.containsKey(ri.xargno__c)) {
                        List<g_reqitem__c> riLst = lsMp.get(ri.xargno__c);
                        riLst.add(ri);
                        lsMp.put(ri.xargno__c, riLst);
                      }
                      else{
                          List<g_reqitem__c> riLst = new List<g_reqitem__c>();
                          riLst.add(ri); lsMp.put(ri.xargno__c, riLst);
                      }
                  }
                    if (lsMp != null && !lsMp.isEmpty()) {

                        for (String agno : lsMp.keySet()) {
                          List<g_reqitem__c> riLst = lsMp.get(agno);
                           PMSDataWrapper.ContractInformation contract = new PMSDataWrapper.ContractInformation();
                           contract.contractNumber = agno;
                           List<PMSDataWrapper.PropertyInformationList> propertyInformationList = new List<PMSDataWrapper.PropertyInformationList>();
                            for (g_reqitem__c ri : riLst) {
                             PMSDataWrapper.PropertyInformationList p = new PMSDataWrapper.PropertyInformationList();
                             p.Area = String.valueOf(ri.xcasqm__c);
                             p.unitNumber = ri.xpreno__c;
                             p.unitNumberArb = ri.xoffnoarb__c;
                             p.approvalRefNumber = p.unitNumber;
                             p.propertyType =  ri.xptp__c;
                             p.propertySubType =  ri.xpstp__c;  //'Office';
                             p.floorEN = ri.xflr__c;
                             p.floorAR = ri.xflrarb__c;
                             p.isMainAddr = ri.xisma__c;
                             Date sdt = ri.xlesd__c;
                             contract.startDate = sdt.month()+'/'+sdt.day()+'/'+sdt.year();
                             Date eDt = ri.xleed__c;
                             contract.endDate = eDt.month()+'/'+eDt.day()+'/'+eDt.year();
                             PMSDataWrapper.Name buildingName = new PMSDataWrapper.Name();
                             buildingName.englishName = ri.xbldg__c;
                             buildingName.arabicName = ri.xbldgarb__c;
                             contract.buildingName = buildingName;
                             propertyInformationList.add(p);
                            }
                            contract.propertyInformationList = propertyInformationList;
                            contractList.add(contract);
                        }

                    }

                }
               else if (String.isNotBlank(ws.rq_itm__r.RQ__r.xvnum__c)) {
                 contractList = (List<PMSDataWrapper.ContractInformation>) Json.deserialize(ws.rq_itm__r.RQ__r.xadtx2__c, List<PMSDataWrapper.ContractInformation>.class);
               }
               else{
                   PMSDataWrapper.ContractInformation contract = new PMSDataWrapper.ContractInformation();
                   List<PMSDataWrapper.PropertyInformationList> propertyInformationList = new List<PMSDataWrapper.PropertyInformationList>();
                   PMSDataWrapper.PropertyInformationList p = new PMSDataWrapper.PropertyInformationList();
                   p.Area = String.valueOf(0);
                   p.unitNumber = null;
                   p.unitNumberArb = null;
                   p.approvalRefNumber = null;
                   p.propertyType = 'Office';
                   p.propertySubType = 'Office';
                   p.floorEN = null;
                   p.floorAR = null;
                   p.isMainAddr = false;
                   contract.startDate = null;
                   contract.endDate = null;
                   contract.buildingName = null;
                   propertyInformationList.add(p);
                   contract.propertyInformationList = propertyInformationList;
                   contractList.add(contract);
               }
           }

           if (contractList != null && !contractList.isEmpty()) {

               PMSDataWrapper pmsData = new PMSDataWrapper();
               pmsData.methodName = 'upsertpmslease';
               List<PMSDataWrapper.Data> dataLst = new List<PMSDataWrapper.Data>();
               for (PMSDataWrapper.ContractInformation contract : contractList) {
                  PMSDataWrapper.Data data = new PMSDataWrapper.Data();
                  data.oraclePartyId = partyId;
                  data.contractNumber = contract.contractNumber;
                  data.landNumber = contract.landNumber;
                  data.contractStatus = 'Active';
                  date cstDt =  Date.today();
                   if (String.isNotBlank(contract.startDate)) {
                     List<string> lstStrDt = contract.startDate.split('/');
                     date cstrDt = date.parse(lstStrDt[1]+'/'+lstStrDt[0]+'/'+lstStrDt[2]);
                       //cstDt = Date.today().adddays(-2);
                      data.contractStartDate = string.valueOf(cstrDt);
                   }
                    if (String.isNotBlank(contract.endDate)) {
                      List<string> lstEndDt = contract.endDate.split('/');
                      date cenDt = date.parse(lstEndDt[1]+'/'+lstEndDt[0]+'/'+lstEndDt[2]);
                      //date cenDt = cstDt.addYears(1).adddays(-1);
                      data.contractEndDate = string.valueOf(cenDt);
                   }
                  data.licenseIssuer = 'DUBAI DEVELOPMENT AUTHORITY';
                  data.makaniNumber = contract.makaniNumber;
                  data.pushToDDA = true;
                  data.type = licType;
                  /* if (ws.ws_typ__c != 'Onboarding' && String.isBlank(ws.rq_itm__r.RQ__r.xvnum__c)) {*/
                   if (contract.buildingName != null) {
                       data.buildingName = contract.buildingName.englishName;
                       data.buildingNameArabic = String.isNotBlank(contract.buildingName.arabicName) ? (contract.buildingName.arabicName) : (GDRFAUtil.engToArabicByChar(data.buildingName, ''));
                   }

                   List<PMS_BuldInfo__c> buldList = [select id, Building_Name__c, BuildingName_Arabic__c, BU_Code__c from PMS_BuldInfo__c where Building_Name__c=:data.buildingName];

                  data.businessPark = (buldList != null && buldList.size()>0) ? (buldList[0].BU_Code__c) : ws.rq_itm__r.RQ__r.Acc__r.park__c.toUpperCase();  //'DIC'; //acc.park__c
                   if (ws.ws_typ__c == 'Onboarding' && buldList != null && !buldList.isEmpty() && String.isNotBlank(buldList[0].BuildingName_Arabic__c)) {
                       data.buildingNameArabic = buldList[0].BuildingName_Arabic__c;
                   }
                 /* }*/
                  List<PMSDataWrapper.LeaseItems> leaselst = new List<PMSDataWrapper.LeaseItems>();
                   decimal propertyArea = 0;
                   integer i=0;
                  for (PMSDataWrapper.PropertyInformationList property: contract.propertyInformationList) {
                      if (String.isNotBlank(property.unitNumber)) {
                       PMSDataWrapper.LeaseItems leaseItm = new PMSDataWrapper.LeaseItems();
                       leaseItm.isMainAddress = false;
                       leaseItm.propertyName = property.unitNumber;
                      if (ws.ws_typ__c != 'Onboarding' && String.isBlank(ws.rq_itm__r.RQ__r.xvnum__c)) {
                       leaseItm.propertyNameArabic = String.isNotBlank(property.unitNumberArb) ? property.unitNumberArb : property.unitNumber;
                       leaseItm.approvalReferenceNumber = property.approvalRefNumber;
                       if (String.isNotBlank(property.floorEN)) {leaseItm.floorEN = property.floorEN; leaseItm.floorAR =  property.floorAR;
                        if (property.floorEN.isNumeric())  leaseItm.floorNumber = integer.valueOf(property.floorEN);  }
                      }
                      /* else if (String.isNotBlank(property.unitNumber) && property.unitNumber.isNumeric()) {
                         leaseItm.floorEN = property.unitNumber.left(1);
                         leaseItm.floorAR =  leaseItm.floorEN;
                         leaseItm.floorNumber = integer.valueOf(leaseItm.floorEN);
                       }
                       else{ leaseItm.floorEN = '2'; leaseItm.floorAR = '2';   leaseItm.floorNumber = 2; }*/
                       leaseItm.propertyType = 'Unit';
                       leaseItm.ejariPropertyType = property.propertyType;
                       leaseItm.ejariPropertyTypeArabic =  'مكتب';  //GDRFAUtil.engToArabicByChar(leaseItm.ejariPropertyType, '');
                       leaseItm.ejariPropertySubtype = property.propertySubType;
                       leaseItm.ejariPropertySubtypeArabic = 'مكتب'; //GDRFAUtil.engToArabicByChar(leaseItm.ejariPropertySubtype, '');
                       propertyArea = (String.isNotBlank(property.Area)) ? decimal.valueOf(property.Area) : 0.0 ;
                       leaseItm.size = (propertyArea *10.7639).setScale(2, RoundingMode.HALF_UP);
                       if (contract.location != null)
                       leaseItm.location = contract.location.name.englishName;
                       leaseItm.usage = property.propertyUsage;
                      if (String.isNotBlank(property.dewa))
                      data.dewaAccountNumber =  property.dewa;
                       if (property.isMainAddr != null && property.isMainAddr)
                           leaseItm.isMainAddress = true;
                       else if (String.isNotBlank(ws.rq_itm__r.RQ__r.xopn__c) && ws.rq_itm__r.RQ__r.xopn__c == property.unitNumber)
                       //if (i == 0)
                        leaseItm.isMainAddress = true;

                        i=i+1;
                        leaselst.add(leaseItm);
                      }
                   }
                   data.leaseItems = leaselst;
                  dataLst.add(data);

               }
               pmsData.data = dataLst;
               reqBody =(String)Json.serialize(pmsData);
           }
           ws.rq_jsn__c = reqBody;
           system.debug('reqBody::'+reqBody);
           //reqBody = '{"validationErrorsList":null, "timeStamp":null, "responseCode":null, "response":null, "methodName":"upsertpmslease", "dedLicenseNumber":null, "data":[{"type":"New", "pushToDDA":true, "oraclePartyId":"1719809", "makaniNumber":null, "licenseIssuer":"DUBAI DEVELOPMENT AUTHORITY", "leaseItems":[{"usage":"Commercial", "size":3964.67, "psf":null, "propertyTypeArabic":null, "propertyType":"Unit", "propertyNameArabic":"101", "propertyName":"101", "parentPmsContractNumber":null, "location":"Trade Center First", "isMainAddress":true, "ejariPropertyTypeArabic":"مكتب", "ejariPropertyType":"Office", "ejariPropertySubtypeArabic":"مكتب", "ejariPropertySubtype":"Office", "approvalReferenceNumber":"242250"}, {"usage":"Commercial", "size":1726.64, "psf":null, "propertyTypeArabic":null, "propertyType":"Unit", "propertyNameArabic":"102", "propertyName":"102", "parentPmsContractNumber":null, "location":"Trade Center First", "isMainAddress":false, "ejariPropertyTypeArabic":"مكتب", "ejariPropertyType":"Office", "ejariPropertySubtypeArabic":"مكتب", "ejariPropertySubtype":"Office", "approvalReferenceNumber":"242251"}], "landNumber":"33", "dmNumber":null, "dewaAccountNumber":"335065757", "contractStartDate":"2020-08-01", "contractNumber":"0120200816003017", "contractEndDate":"2025-07-30", "businessPark":"DIC", "buildingNameArabic":"برج لطيفه", "buildingName":"LATIFA TOWER"}], "contractNumber":null}';
           HTTPResponse httpRes = httpResponse(reqBody, endPoint, 'POST');
          if (httpRes != null && httpRes.getStatusCode() == 200) {
              resStr = httpRes.getBody();
           system.debug('res1::' + httpRes.getBody());
           /* [{
           "pmsLeaseId":"a3Y7A0000002GW4UAM", "isSuccess":true, "errorMessage":""}
           , {
           "pmsLeaseId":"a3Y7A0000002GW4UAM", "isSuccess":true, "errorMessage":""}
           , {
           "pmsLeaseId":"a3Y7A0000002GW4UAM", "isSuccess":true, "errorMessage":""}
           ]
 */

           //res = httpRes.getBody();
          }

        }catch (Exception ex) {

          system.debug('ex::' + ex.getStackTraceString());
       }
        return resStr;

    }
    public static List<PMSContractDataWrapper.ContractInformation> getEjariContractInfoByContractNo(String contractNo) {
       List<PMSContractDataWrapper.ContractInformation> contractList = null;
       List<PMSContractDataWrapper.ContractInformation> contractListFiltered = new List <PMSContractDataWrapper.ContractInformation>();
        try{
           String reqBody = '{"ContractNumber" : "'+contractNo+'"}';
            String res = getEJariContractInfo(reqBody, 'AXS_ERES_GET_CONTRACT_DETAILS/1.0/getcontractdetails');
            if (String.isNotBlank(res)) {
                PMSContractDataWrapper data = (PMSContractDataWrapper) json.deserialize(res, PMSContractDataWrapper.class);
                if (data != null && data.ResponseCode == 'Success' && data.Response.ContractInformation != null) {
                    system.debug('res::' + data.Response.ContractInformation);
                    contractList = new List<PMSContractDataWrapper.ContractInformation>();
                    contractList.add( data.Response.ContractInformation);
                }
            }
        }
        catch (Exception ex) {

        system.debug('ex::' + ex.getStackTraceString());
       }
        if (contractList != null && contractList.size()>0) {
         List<String> pmsExclBlds = Label.PMSExcBldgs.split(';');
         List<String> pmsExclPrType = Label.PMSExclPrType.split(';');
         for (PMSContractDataWrapper.ContractInformation c: contractList) {
             if (c.buildingName != null && !pmsExclBlds.contains(c.buildingName.englishName) && !pmsExclPrType.contains(c.propertyInformationList[0].propertyType) ) {
                 contractListFiltered.add(c);
             }
         }
     }
     return contractListFiltered;
 }
    public static List<PMSDataWrapper.ContractInformation> getEjariContractInfoByLicenseNo(String licNo, integer licIssuerId) {
     List<PMSDataWrapper.ContractInformation> contractList = null;
     List<PMSDataWrapper.ContractInformation> contractListFiltered = new List <PMSDataWrapper.ContractInformation>();
        try{
           String reqBody = '{"LicenseNumber" : "'+licNo+'", "LicenseStateId": 1, "LicenseIssuerId": '+licIssuerId+' }';
            system.debug('reqBody -- '+reqBody);
            String res = getEJariContractInfo(reqBody, 'AXS_ERES_GET_CONTRACT_LIST/1.0/getcontractlistbylicensenumber');
            if (String.isNotBlank(res)) {
                PMSDataWrapper data = (PMSDataWrapper) json.deserialize(res, PMSDataWrapper.class);
                if (data != null && data.ResponseCode == 'Success' && data.Response.ContractInformation != null) {
                   contractList = data.Response.ContractInformation;

                }
            }
        }
        catch (Exception ex) {

        system.debug('ex::' + ex.getStackTraceString());
       }
     if (contractList != null && contractList.size()>0) {
         List<String> pmsExclBlds = Label.PMSExcBldgs.split(';');
         List<String> pmsExclPrType = Label.PMSExclPrType.split(';');
         for (PMSDataWrapper.ContractInformation c: contractList) {
             if (c.buildingName != null && String.isNotblank(c.buildingName.englishName) && !pmsExclBlds.contains(c.buildingName.englishName) && c.propertyInformationList != null && c.propertyInformationList.size() > 0 && String.isNotBlank(c.propertyInformationList[0].propertyType) &&  !pmsExclPrType.contains(c.propertyInformationList[0].propertyType) ) {
                 contractListFiltered.add(c);
             }
         }
     }
     return contractListFiltered;
 }
    public static List<PMSDataWrapper.ContractInformation> getEjariContractInfoByLicenseNo(String licNo) {
       system.debug('licNo -- '+licNo);
       List<PMSDataWrapper.ContractInformation> contractList = new List<PMSDataWrapper.ContractInformation>();
        List<PMSDataWrapper.ContractInformation> contractInfo = null;
        contractInfo = getEjariContractInfoByLicenseNo(licNo, 47);
        if (contractInfo != null && !contractInfo.isEmpty())
            contractList.addAll(contractInfo);
        contractInfo = getEjariContractInfoByLicenseNo(licNo, 17);
        if (contractInfo != null && !contractInfo.isEmpty())
            contractList.addAll(contractInfo);
        contractInfo = getEjariContractInfoByLicenseNo(licNo, 25);
        if (contractInfo != null && !contractInfo.isEmpty())
            contractList.addAll(contractInfo);
        contractInfo = getEjariContractInfoByLicenseNo(licNo, 35);
        if (contractInfo != null && !contractInfo.isEmpty())
            contractList.addAll(contractInfo);
        contractInfo = getEjariContractInfoByLicenseNo(licNo, 16);
        if (contractInfo != null && !contractInfo.isEmpty())
            contractList.addAll(contractInfo);
        contractInfo = getEjariContractInfoByLicenseNo(licNo, 28);
        if (contractInfo != null && !contractInfo.isEmpty())
            contractList.addAll(contractInfo);
     return contractList;
 }
    public static string getEJariContractInfo(String rqStr, String serviceName) {
       String res = '';
       try {

        String endPoint = 'callout:OIC_Integration_PROD/'+serviceName; //GetContractByDEDNo
        //String reqBody = '{"DEDLicenseNumber": "'+licNo+'"}';
        HTTPResponse httpRes = httpResponse(rqStr, endPoint, 'POST');
        if (httpRes != null && httpRes.getStatusCode() == 200) {
         system.debug('res1::' + httpRes.getBody());
         res = httpRes.getBody();
        }

     } catch (Exception ex) {
        gU.AddErrorMsg(ex);
        system.debug('ex::' + ex.getStackTraceString());
    }
     return res;

    }
    public static boolean isValid(String ArbStr) {
      Boolean flg = true;
      String regex = '^[A-Za-z]+$';
      Pattern engStrPattern = Pattern.compile(regex);
      Matcher engStrMatcher = engStrPattern.matcher(ArbStr);
      if (!(engStrMatcher.matches())) {
        flg = false;
      }
      return flg;
    }
    public static HTTPResponse httpResponse(String requestString, String endpointUrl, String methodType) {
        HTTPResponse res;
        try{
        HttpRequest req = New HttpRequest();
        req.setHeader('Content-Type', 'application/json');
        req.setTimeout(90000);
        req.setMethod(methodType);
        if (methodType == 'POST' && String.isNotBlank(requestString)) {req.setBody(requestString);}
        req.setEndpoint('callout:gwsPMSIntegration_API');
        Http http = new Http();
        res = http.send(req);
        }catch (Exception e) {system.debug(e.getStackTraceString());}

        return res;
    }
    public static void insertPMSOffLoc(g_Req__c rq) {
        try{
            if (String.isNotBlank(rq.xadtx2__c) && !rq.xppsfv__c) {
                List<String> ofcItmCdList = Label.PMSOfcItmCd.split(';');
                List<g_reqitem__c> delRqItmList = [select id from g_reqitem__c where rq__c=:rq.id and itm__r.cd__c=:ofcItmCdList];
                if (delRqItmList != null && !delRqItmList.isEmpty()) delete delRqItmList;
                Map<string, g_srvcitm__c> srvmp = new Map<string, g_srvcitm__c>();
                list < g_reqitem__c > tI = new list < g_reqitem__c > ();
                List<PMSDataWrapper.ContractInformation> contractlist = (List<PMSDataWrapper.ContractInformation>) json.deserialize(rq.xadtx2__c, List<PMSDataWrapper.ContractInformation>.class);
                if (contractlist != null && !contractlist.isEmpty()) {
                    for (g_srvcitm__c i: [Select id, Req__c, Name, cd__c, srvc__c, rv__c, prcEdt__c, DscApp__c,
                        KF__c, scN__c, cN__c, smN__c, slaN__c, spChN__c, scXP__c, cXP__c, smXP__c, slaXP__c,
                        vsc__c, vst__c, vec__c, vesch__c, ngs__c, ngsXP__c, su__c, vsu__c, TAX_CODE__c, TAX_TYPE__c,
                        extc__c, TAXCODE_SC__c, extcsc__c, (Select Id From Statuses__r where isDeleted = false and cd__c ='n' limit 1) From g_srvcitm__c where isDeleted = false and actv__c = true and srvc__c=:rq.srvc__c and cd__c=:ofcItmCdList]) {
                        srvmp.put(i.cd__c, i);
                    }
                    integer j=2, i=1;
                    String sitmCd = '';
                    boolean strxmu = false;
                    for (PMSDataWrapper.ContractInformation c:contractlist) {
                        String strArg, strxbldg, strxbldgarb, strxbu, strxbuarb, strxflr, strxflrarb, strxoffno, strxoffnoarb, strcd, strxleed, strpstp;
                        Date xstrxleed, xstrxlesd;
                        Decimal areaSM = 0, areaSF=0;
                        strArg =c.contractNumber;
                        strxbldg = (c.buildingName != null) ? c.buildingName.englishName : '';
                        strxbldgarb = (c.buildingName != null) ? c.buildingName.arabicName : '';
                        if (c.propertyInformationList != null && !c.propertyInformationList.isEmpty()) {
                            for (PMSDataWrapper.PropertyInformationList ci: c.propertyInformationList) {
                                if (j <= 9) {
                                    sitmCd = 'lc'+j;
                                }
                                else{
                                    sitmCd = 'la'+i;
                                    i = i+1;
                                }
                                system.debug('sitmCd::'+sitmCd);
                                if (srvmp != null && srvmp.containsKey(sitmCd)) {
                                    g_srvcitm__c itm = srvmp.get(sitmCd);
                                    strxoffno = ci.unitNumber;
                                    strxoffnoarb = ci.unitNumber;
                                    strpstp = ci.PropertySubType;
                                    if (String.isNotBlank(c.startDate)) {
                                        List<string> lstStrDt = c.startDate.split('/');
                                        xstrxlesd = date.parse(lstStrDt[1]+'/'+lstStrDt[0]+'/'+lstStrDt[2]);
                                    }
                                    if (String.isNotBlank(c.endDate)) {
                                        List<string> lstEndDt = c.endDate.split('/');
                                        xstrxleed = date.parse(lstEndDt[1]+'/'+lstEndDt[0]+'/'+lstEndDt[2]);
                                    }
                                    areaSM = ((String.isNotBlank(ci.Area)) ? decimal.valueOf(ci.Area) : 0.0);
                                    areaSF = (areaSM*10.7639).setScale(2, RoundingMode.HALF_UP);
                                    tI.add(new g_reqitem__c(Name = itm.Name, RQ__c = rq.Id, itm__c = itm.Id,
                                        sta__c = itm.Statuses__r[0].Id, DscApp__c = itm.DscApp__c, exp__c = false,
                                        KF__c = itm.KF__c, scN__c =itm.scN__c, cN__c = itm.cN__c, smN__c = itm.smN__c,
                                        slaN__c = itm.slaN__c, scXP__c = itm.scXP__c, cXP__c = itm.cXP__c,
                                        smXP__c = itm.smXP__c, slaXP__c = itm.slaXP__c, vsc__c = itm.vsc__c,
                                        vst__c = itm.vst__c, vec__c = itm.vec__c, vesch__c = itm.vesch__c,
                                        ngs__c = itm.ngs__c, ngsXP__c = itm.ngsXP__c, su__c = itm.su__c,
                                        vsu__c = itm.vsu__c, TAX_CODE__c = itm.TAX_CODE__c, TAX_TYPE__c = itm.TAX_TYPE__c,
                                        extc__c = itm.extc__c, TAXCODE_SC__c = itm.TAXCODE_SC__c, extcsc__c = itm.extcsc__c,
                                        xbldg__c = strxbldg, xbldgarb__c = strxbldgarb, xbu__c = strxbu,
                                        xbuarb__c = strxbuarb, xflr__c = strxflr, xflrarb__c = strxflrarb,
                                        xpreno__c = strxoffno, xlesd__c = xstrxlesd, xleed__c = xstrxleed,
                                        xoffnoarb__c = strxoffnoarb, xisma__c = strxmu, xargno__c = strArg,
                                        xcasqm__c=areaSM, xasf__c=areaSF, xleatp__c='PMS Lease', xpstp__c=strpstp));
                                    j=j+1;
                                }
                            }
                        }
                    }
                    if (tI != null && !tI.isEmpty()) {
                        system.debug('tI size::'+tI.size());
                        if (Schema.sObjectType.g_reqitem__c.isCreateable()) {
                            insert tI;
                        }
                    }
                }
            }
        }
        catch (Exception ex) {
            system.debug('ex insert pms offc location:'+ex.getMessage());
        }
    }
    public static void updateLeaseInfo(g_Req__c rq) {
       system.debug('rq.activitiesFL__c::'+rq.activitiesFL__c);
        List<PMSDataWrapper.ContractInformation> contractlist = (List<PMSDataWrapper.ContractInformation>) json.deserialize(rq.activitiesFL__c, List<PMSDataWrapper.ContractInformation>.class);

      Decimal psffee = 0, psffeeIcVat=0, ttlAreaSft=0, psffeeVat=0;
        Date csdt = null;
            Integer remainder=0;
            Date graceEndDate = null;
        if (contractlist != null && !contractlist.isEmpty()) {
           PMSDataWrapper.ContractInformation contract = contractlist[0];
            Decimal ttlAreaSM = 0, ttlAreaSF=0;

            if (String.isnotblank(contract.startDate)) {
                List<String> stdList = contract.startDate.split('/');
                csdt = Date.newInstance(integer.valueOf(stdList[2]), integer.valueOf(stdList[0]), integer.valueOf(stdList[1]));
                List<String> edList = contract.endDate.split('/');
                integer endDtDay = integer.valueOf(edList[1]);
                Date cedt = Date.newInstance(integer.valueOf(edList[2]), integer.valueOf(edList[0]), integer.valueOf(edList[1]));
                integer val = csdt.monthsBetween(cedt);
                if (cedt.day()>csdt.Day()) {val++;}
                if (val == 11) {val=12;}
                if (endDtDay == 30 || endDtDay == 31 )
                  remainder = math.mod(val+1, 12);
                else
                  remainder = math.mod(val, 12);
                graceEndDate = cedt;
                if (remainder >0)
                 graceEndDate = csdt.addMonths(remainder+12).adddays(-1);

            }
            system.debug('graceEndDate:'+graceEndDate);
            if (contract.propertyInformationList != null && !contract.propertyInformationList.isEmpty()) {
                for (PMSDataWrapper.PropertyInformationList property: contract.propertyInformationList) {
                    ttlAreaSM = (ttlAreaSM + ((String.isNotBlank(property.Area)) ? decimal.valueOf(property.Area) : 0.0));
                }
                ttlAreaSF = (ttlAreaSM*10.7639).setScale(2, RoundingMode.HALF_UP);
                psffee = (ttlAreaSF * decimal.valueOf(Label.PSFFeeSF));
                system.debug('remainder:'+remainder);
                if (remainder != 0) {
                  psffee = (psffee/12);
                  system.debug('psffee1:'+psffee);
                  psffee = psffee * (12+remainder);
                  system.debug('psffee2:'+psffee);
                }
                ttlAreaSft = ttlAreaSF;
                psffeeVat =  ((psffee * 5)/100).setScale(2, RoundingMode.HALF_UP);
                psffeeIcVat = psffee + psffeeVat;
                psffeeIcVat = psffeeIcVat.setScale(2, RoundingMode.HALF_UP);
            }
        }
      // List < g_Req__c > rqLst = [select id, xvnum__c, xsvn__c, os__c, DDA_INV__c, activitiesFL__c, name, xadtx3__c, xdccaRq__c, xadtx2__c, xdei__c, xadh__c, acc__c, acc__r.id, acc__r.lcedt__c, skpu__c from g_Req__c where name=:ws.xrno__c limit 1];

grqWsOnboard.Records rec = (grqWsOnboard.Records) JSON.deserialize(rq.xadtx3__c, grqWsOnboard.Records.class);

      rq.os__c = 'CCL Accepted';
      if (String.isBlank(rq.xadh__c)) {
         rq.xadh__c = '';
     } else {
         rq.xadh__c += ';';
    }

String paySch = '{"workorders":[{"status":"Approved", "recType":"Brand_Approval", "recid":"0WO2R0000059dE0WAI", "parentid":null, "members":null, "ddaRQNo":null, "ddaRQId":null}, {"status":"Waiting for Original Documents", "recType":"License_Registration_Request", "recid":"0WO2R0000059dE2WAI", "parentid":null, "members":null, "ddaRQNo":null, "ddaRQId":null}, {"status":"Approved", "recType":"Security_Clearance", "recid":"0WO2R0000059dE1WAI", "parentid":null, "members":null, "ddaRQNo":null, "ddaRQId":null}], "usrName":"Ramzieh Kahil", "scWorkid":"0WO2R0000059dE1WAI", "respMsg":"Success", "requestid":"a0E2y000006RTdzEAG", "quotes":[{"units":[{"status":"Soft Booked", "productName":"DSC-DSC Tower-1209", "name":"1209", "isActive":true, "floor":"Twelfth Floor", "buildingName":"DSC Tower", "area":759.47}], "totalOfrPrice":129109.9, "totalDiscount":15.00, "totalBstRate":170880.75, "status":"Accepted", "rqtype":"New", "requestId":"a0E2y000006RTdzEAG", "quoteNo":"00078446", "quoteName":"Quote - New - Office - 20220126", "quoteId":"0Q02R000002GeGiSAK", "opportunityId":"0062R00000xKv6cQAC", "lsStDt":"2022-02-02", "lsStatus":null, "lsEndDt":"2025-02-01", "locDet":null, "agNo":"AG-083771"}], "proposedLegalForm":"DDA", "prmPhone":"00971 4 3914605", "prmMobile":"+971 504767977", "prmLastName":"Kahil", "prmFirstName":"Ramzieh", "prmEmail":"ramzieh.kahil@dmc.ae", "paymentSchedules":[{"yearNo":"1", "vatAmount":0, "totalDays":0, "totalAmountIncludingVat":0, "tenantCode":0, "quote":0, "propertyCode":0, "Id":"a0r2R00000P5XJMQA3", "description":"Ejari Service Charge", "chargeTo":"2022-02-02", "chargeFrom":"2022-02-02", "chargeCode":"ejarisc", "billedAmount":0}, {"yearNo":"1", "vatAmount":0, "totalDays":0, "totalAmountIncludingVat":0, "tenantCode":0, "quote":0, "propertyCode":0, "Id":"a0r2R00000P5XJNQA3", "description":"Ejari Services", "chargeTo":"2022-02-02", "chargeFrom":"2022-02-02", "chargeCode":"ejrsvc", "billedAmount":0}, {"yearNo":"1", "vatAmount":0, "totalDays":0, "totalAmountIncludingVat":0, "tenantCode":0, "quote":0, "propertyCode":0, "Id":"a0r2R00000P5XJOQA3", "description":"Rental Income - Office", "chargeTo":"2022-05-01", "chargeFrom":"2022-02-02", "chargeCode":"rntoff", "billedAmount":0}, {"yearNo":"1", "vatAmount":0, "totalDays":0, "totalAmountIncludingVat":0, "tenantCode":0, "quote":0, "propertyCode":0, "Id":"a0r2R00000P5XJPQA3", "description":"PSF Fee", "chargeTo":"2022-05-01", "chargeFrom":"2022-02-02", "chargeCode":"psf", "billedAmount":0}, {"yearNo":"1", "vatAmount":0, "totalDays":0, "totalAmountIncludingVat":0, "tenantCode":0, "quote":0, "propertyCode":0, "Id":"a0r2R00000P5XJPQA4", "description":"Service Charge", "chargeTo":"2022-05-01", "chargeFrom":"2022-02-02", "chargeCode":"srvchrg", "billedAmount":0}], "oppId":"0062R00000xKv6cQAC", "onbReqid":"a2l2R000004O0VoQAK", "nameResWorkid":"0WO2R0000059dE2WAI", "members":[{"website":null, "uboType":null, "uboRelatedTo":null, "uboOwnedbyUAE":null, "uboDeclaration":null, "street":null, "stockExchangeListed":null, "sh":"50", "security":null, "salutation":"Mr.", "rpNo":null, "rpExpDate":null, "role":"Member;Board of Directors;General Manager;Ultimate Beneficiary", "postalCode":null, "placeissued":"United Arab Emirates", "pIssuedDate":null, "phoneno":"0553822838", "pExpDate":"2024-05-26", "passportNo":"FF4262724", "nationality":"United Arab Emirates", "mobile":"+971553822838", "mname":null, "mailingStreet":null, "mailingPostalCode":null, "mailingCountry":null, "mailingCity":null, "lnameAr":null, "lname":"Alfarsi", "legals":null, "iAuthority":null, "gender":"Male", "fnameAr":null, "fname":"Majid", "email":"majidmohammed@skyi.ae", "eid":null, "eExpDate":null, "dob":"1996-06-23", "ctgCode":null, "cshType":null, "corpORind":"Individual Shareholder", "conid":"0032R00002KXrWAQA1", "city":null, "birthplace":null}], "lrWorkid":null, "licenseType":"DDA", "legalFramework":"DDA", "lcExpdate":"2023-02-03", "isSuccess":true, "hseWorkid":null, "documents":[{"name":"Signed Article of Association", "isFileAttached":true, "isCallforReview":false, "gracePeriod":false, "description":"Signed Article of Association", "ddaDocId":"a3e6F0000018SW0QAM", "ccrmParentId":"0WO2R0000059dE2WAI", "ccrmDocId":"a0H2R00001IwlRVUAZ"}, {"name":"Valid Passport Copy - Majid Alfarsi", "isFileAttached":true, "isCallforReview":false, "gracePeriod":false, "description":"Valid Passport Copy - Majid Alfarsi", "ddaDocId":"a3e6F0000018SYkQAM", "ccrmParentId":"0WO2R0000059dE2WAI", "ccrmDocId":"a0H2R00001IwlbbUAB"}, {"name":"Resolution for the Incorporation of an FZ-LLC", "isFileAttached":true, "isCallforReview":false, "gracePeriod":false, "description":"Resolution for the Incorporation of an FZ-LLC", "ddaDocId":"a3e6F0000018SW2QAM", "ccrmParentId":"0WO2R0000059dE2WAI", "ccrmDocId":"a0H2R00001IwlRXUAZ"}, {"name":"General Declaration and Undertaking Form", "isFileAttached":true, "isCallforReview":false, "gracePeriod":false, "description":"General Declaration and Undertaking Form", "ddaDocId":"a3e6F0000018SW1QAM", "ccrmParentId":"0WO2R0000059dE2WAI", "ccrmDocId":"a0H2R00001IwlRWUAZ"}], "DDAReqNo":null, "crmAccName":"Sky I Aerial Photography FZ-LLC", "crmAccId":"0012R00002H1j4wQAB", "caseid":null, "businessPark":"DDA", "brandWorkid":"0WO2R0000059dE0WAI", "actvities":[{"title":null, "segment":"Production (Film/TV and Radio)", "name":"Post Production", "channel":null, "actId":"a0L2R00000KCy1DUAT"}, {"title":null, "segment":"Production (Film/TV and Radio)", "name":"Production - Film, TV, and Radio", "channel":null, "actId":"a0L2R00000KCxp7UAD"}, {"title":null, "segment":"Production (Film/TV and Radio)", "name":"Production ? Corporate/Social Videos", "channel":null, "actId":"a0L2R00000KCxlMUAT"}]}';
grqWsOnboard.Records DmmypaySch = (grqWsOnboard.Records) JSON.deserialize(paySch, grqWsOnboard.Records.class);
rec.paymentSchedules = DmmypaySch.paymentSchedules;
List < grqWsOnboard.ActivityInfo > DDALts = new List < grqWsOnboard.ActivityInfo > ();
List < grqWsOnboard.ActivityInfo > lstActs = new List < grqWsOnboard.ActivityInfo > ();
List < grqWsOnboard.SegmentInfo > lstSegments2 = new List < grqWsOnboard.SegmentInfo > ();
String DDA_INV = '';
if (rec.paymentSchedules != null && rec.paymentSchedules.size() > 0) {
List < grqWsOnboard.SegmentInfo > lstSegments = (List < grqWsOnboard.SegmentInfo > ) json.deserialize(rq.xadtx2__c, List < grqWsOnboard.SegmentInfo > .class);
                if (lstSegments == null) {
                    lstSegments = new List < grqWsOnboard.SegmentInfo > ();
                }
                //create a map  for Terms
                ///rec.paymentSchedules.sort();
                System.debug('SORT>>> : ' + JSON.serialize(rec.paymentSchedules));
                Map < Integer, List < grqWsOnboard.PaymentSchedules >> termsMap = new Map < Integer, List < grqWsOnboard.PaymentSchedules >> ();
                List < String > chrgCdLst = Label.Charge_Code_Yardi.split(';');
                List < grqWsOnboard.PaymentSchedules > paySchule;
                paySchule = new List < grqWsOnboard.PaymentSchedules > ();
                Integer Terms = 1;
                String fromDate = '';
                system.debug('Terms---' + Terms);
                for (grqWsOnboard.PaymentSchedules py: rec.paymentSchedules) {

                    if (!chrgCdLst.contains(py.chargeCode)) {
                        /* py.chargeCode!='rntoff' && py.chargeCode!='srvchrg' && py.chargeCode!='in5deinc' */
                        py.term = '1'; //1
                        paySchule.add(py);
                    } else if (py.chargeFrom == fromDate || fromDate == '') {
                        py.term = '' + Terms; //1
                        paySchule.add(py);
                        fromDate = py.chargeFrom;
                        system.debug('fromDate---' + fromDate);
                        system.debug('Terms---' + Terms);
                    }
                    else {
                        fromDate = py.chargeFrom;
                        termsMap.put(Terms, paySchule);
                        paySchule = new List < grqWsOnboard.PaymentSchedules > ();
                        Terms++;
                        py.term = '' + Terms;
                        paySchule.add(py);
                        system.debug('fromDate---' + fromDate);
                        system.debug('Terms---' + Terms);
                    }

                }
                termsMap.put(Terms, paySchule);
                List < grqWsOnboard.PaymentSchedules > paySchTrms = new List < grqWsOnboard.PaymentSchedules > ();

                System.debug('termsMap>>> : ' + JSON.serialize(termsMap));
                for (Integer key: termsMap.keySet()) {
                    List < grqWsOnboard.PaymentSchedules > payS = termsMap.get(key);
                    System.debug('payS>>> : ' + JSON.serialize(payS));
                    for (grqWsOnboard.PaymentSchedules py: payS) {

                        grqWsOnboard.ActivityInfo act = new grqWsOnboard.ActivityInfo(py.description, 'CCRM-' + py.quote);
                        List < String > lstActDocs = new List < String > ();
                        act.docs = lstActDocs;
                        act.price = '' + py.billedAmount;
                        act.vatAmount = '' + py.vatAmount;
                        act.totalPrice = '' + py.totalAmountIncludingVat;
                        act.chargeCode = py.chargeCode;
                        act.propertyCode = py.propertyCode;
                        act.tenantCode = py.tenantCode;
                        act.chargeFrom = py.chargeFrom;
                        act.chargeTo = py.chargeTo;
                        act.description = py.description;
                        act.term = py.term;
                        lstActs.add(act);

                    }
                }
        String res = grqWsDccaGetService.getNewReqDetails(rq.xdccaRq__c);
        grqWsDccaGetService dccaResp = (grqWsDccaGetService) System.JSON.deserialize(res, grqWsDccaGetService.class);
        DDA_INV = dccaResp.invno;
        Map < String, grqWsOnboard.ActivityInfo > mapLstActs = new Map < String, grqWsOnboard.ActivityInfo > ();
        List < grqWsDccaGetService.LineItems > ddaItms = dccaResp.Data[0].lines;
        Decimal in5Price = 0;
        if (ddaItms != null) {
          for (grqWsDccaGetService.LineItems dda: ddaItms) {
                        String Name = '';
                        if (dda.lineName != 'Registration Fees' && dda.lineName != 'Knowledge Dirham' && dda.lineName != 'Innovation Dirham' && dda.lineName != 'Economic Register Fee') {
                            Name = 'New Licence Fee';
                        } else {
                            Name = dda.lineName;
                        }
                        if (String.isNotBlank(Name)) {
                            grqWsOnboard.ActivityInfo act = new grqWsOnboard.ActivityInfo(Name, 'dda');
                            List < String > lstActDocs = new List < String > ();
                            act.docs = lstActDocs;
                            if (Name == 'New Licence Fee' && dda.amount != null) {
                                in5Price = in5Price + Decimal.valueOf(dda.amount);
                                act.price = '' + in5Price;
                                act.vatAmount = '0';
                                act.totalPrice = '' + in5Price;
                            } else {
                                if (!mapLstActs.isEmpty() && mapLstActs.containsKey(Name)) {
                                    grqWsOnboard.ActivityInfo exAct = (grqWsOnboard.ActivityInfo) mapLstActs.get(Name);
                                    act.price = '' + (Decimal.valueOf(exAct.price) + Decimal.valueOf(dda.amount));
                                } else {
                                    act.price = '' + dda.amount;
                                }
                                act.vatAmount = '0';
                                act.totalPrice = act.price;
                            }
                            act.description = Name;
                            act.term = '1';
                            act.actId = 'dda';
                            // lstActs.add(act);
                            mapLstActs.put(Name, act);
                        }
                    }
                    DDALts = mapLstActs.values();
                    lstActs.addAll(DDALts);
 }
             Integer itemNo = 1;
                for (grqWsOnboard.ActivityInfo curAct: lstActs) {
                    grqWsOnboard.SegmentInfo sInfo = new grqWsOnboard.SegmentInfo();
                    if (curAct.actId == 'dda') {
                        if (curAct.Name == 'New Licence Fee') {
                            sInfo.segId = 'dr';
                        }
                        if (curAct.Name == 'Registration Fees') {
                            sInfo.segId = 'rgf';
                        }
                        if (curAct.Name == 'Knowledge Dirham') {
                            sInfo.segId = 'kf';
                        }
                        if (curAct.Name == 'Innovation Dirham') {
                            sInfo.segId = 'inf';
                        }
                        if (curAct.Name == 'Economic Register Fee') {
                            sInfo.segId = 'erf';
                        }
                        sInfo.name = curAct.Name;
                    }
                    else if (!curAct.Name.contains('Ejari Service') && curAct.Name != 'Refundable Security Deposit' && curAct.Name != 'PSF Fee' && curAct.actId != 'dda') {

                        sInfo.segId = curAct.term + 'py';
                        if (Integer.valueOf(curAct.term) <= 12 && !rq.xadh__c.contains(curAct.term + 'py;')) {
                            rq.xadh__c += curAct.term + 'py;';
                        }
                        sInfo.name = 'Lease Fees - Term ' + curAct.term;

                    }
                    else if (curAct.Name == 'Refundable Security Deposit' && curAct.actId != 'dda') {
                        sInfo.segId = 'sc';
                        if (Integer.valueOf(curAct.term) <= 12 && !rq.xadh__c.contains('sc;')) {
                            rq.xadh__c += 'sc;';
                        }
                        sInfo.name = 'Refundable Security Deposit';
                    }
                    else if (curAct.Name == 'PSF Fee' && curAct.actId != 'dda') {

                        sInfo.segId = 'psf';
                        if ( !rq.xadh__c.contains('psf;')) {
                            rq.xadh__c += 'psf;';
                        }
                        sInfo.name = 'PSF Fee';

                    }
                    else {
                        String itmCd = (curAct.Name.equalsIgnoreCase('Ejari Services')) ? 'ej' : 'ejc';
                        sInfo.segId = itmCd;
                        sInfo.name = curAct.Name;
                        if (Integer.valueOf(curAct.term) <= 12 && !rq.xadh__c.contains(itmCd + ';')) {
                            rq.xadh__c += itmCd + ';';
                        }
                    }

                    curAct.name = '';
                    curAct.actId = sInfo.name;
                    // sInfo.SegActivities =  new List<grqWsOnboard.ActivityInfo>{curAct};
                    sInfo.vatAmount = curAct.vatAmount;

                    sInfo.term = curAct.term;
                    if (sInfo.segId == 'psf') {
                     sInfo.price = ''+psffee;
                     sInfo.vatAmount = ''+psffeeVat;
                     sInfo.totalPrice = ''+psffeeIcVat;
                    }
                    else{
                     sInfo.price = curAct.price;
                     sInfo.totalPrice = curAct.totalPrice;
                     }
                    sInfo.chargeCode = curAct.chargeCode;
                    sInfo.propertyCode = curAct.propertyCode;
                    sInfo.tenantCode = curAct.tenantCode;
                    sInfo.chargeFrom = curAct.chargeFrom;
                    sInfo.chargeTo = curAct.chargeTo;

                    lstSegments2.add(sInfo);
                }
    }
    System.debug('lstSegments2>>> : ' + JSON.serialize(lstSegments2));
    rq.xadtx1__c = JSON.serialize(lstSegments2);
    rq.DDA_INV__c = DDA_INV;
    rq.activitiesFL__c = JSON.serialize(contractlist);
    rq.xvnum__c = String.valueOf(psffeeIcVat);
    rq.xsvn__c =  String.valueOf(ttlAreaSft);
    rq.xcpid__c = csdt;
    rq.xcped__c = graceEndDate;
    rq.xppsfv__c = true;
     System.debug('after payment sc xadh__c : ' + rq.xadh__c);
     if (String.isNotBlank(rq.xadh__c)) {
          rq.xadh__c = rq.xadh__c.replaceAll(';;', ';');
           rq.xadh__c += ';';
     }

    if (Schema.sObjectType.g_req__c.isUpdateable()) {
        update rq;
    }
        List<g_reqitem__c> psfItmLst = [select id, name from g_reqitem__c where rq__c=:rq.id and itm__r.cd__c='psf'];
        if (psfItmLst != null && !psfItmLst.isEmpty()) {
                           ws_call__c ws = new ws_call__c();
                            ws.rq_itm__c = psfItmLst[0].id;
                            ws.ws_typ__c = 'Onboarding';
                            ws.mtd_nm__c = 'updatePMSInfo';
                            ws.intsts__c = 'Ready for Integration';
                            ws.uid__c = psfItmLst[0].id + ''+system.now() +'PMSInfo' ;
                           if (Schema.sObjectType.ws_call__c.isCreateable()) {
                               insert ws;
                           }
        }
 }

    public static void updateLeaseAmdInfo(g_req__c rq) {
        List < PMSAmdDataWrapper.UnitInfo > unitList = (List < PMSAmdDataWrapper.UnitInfo > ) json.deserialize(rq.xadtx4__c, List < PMSAmdDataWrapper.UnitInfo > .class);
        Map<String, List<PMSAmdDataWrapper.UnitInfo>> unitMap = new Map<String, List<PMSAmdDataWrapper.UnitInfo>>();
        if (unitList != null && !unitList.IsEmpty()) {
            for (PMSAmdDataWrapper.UnitInfo u : unitList) {
                if (String.isNotBlank(u.sts) && u.sts == 'M' ) {
                    if (unitMap != null && unitMap.containskey(u.contractNo)) {
                        List<PMSAmdDataWrapper.UnitInfo> uList = unitMap.get(u.contractNo);
                        uList.add(u);
                        unitMap.put(u.contractNo, uList);
                    }
                    else{
                        List<PMSAmdDataWrapper.UnitInfo> uList = new List<PMSAmdDataWrapper.UnitInfo>();
                        uList.add(u);
                        unitMap.put(u.contractNo, uList);
                    }
                }
            }
        }
        Decimal ejariLeaseArea = 0.0;
        Decimal psffeeIcVat = 0.0;
        List<String> ofcItmCdList = Label.PMSOfcItmCd.split(';');
        Map<String, List<g_reqitem__c>> lsMp = new Map<String, List<g_reqitem__c>>();
        List<PMSDataWrapper.ContractInformation> contractList = new List<PMSDataWrapper.ContractInformation>();
        List<g_reqitem__c> rilcList = [select id, xpreno__c, xptp__c, xpstp__c, xoffnoarb__c,
            xlesd__c, xplt__c, xpltar__c, xasf__c, xcasqm__c, xargno__c, xflr__c, xflrarb__c,
            xisma__c, xleed__c, xbldg__c, xbldgarb__c from g_reqitem__c where rq__c=:rq.id  and xlamdtp__c='New' and itm__r.cd__c=:ofcItmCdList];
        if (rilcList != null && !rilcList.isEmpty()) {
            for (g_reqitem__c ri: rilcList) {
                if (lsMp.containsKey(ri.xargno__c)) {
                    List<g_reqitem__c> riLst = lsMp.get(ri.xargno__c);
                    riLst.add(ri);
                    lsMp.put(ri.xargno__c, riLst);
                }
                else{
                    List<g_reqitem__c> riLst = new List<g_reqitem__c>();
                    riLst.add(ri);
                    lsMp.put(ri.xargno__c, riLst);
                }
            }
            if (lsMp != null && !lsMp.isEmpty()) {
                for (String agno : lsMp.keySet()) {
                    List<g_reqitem__c> riLst = lsMp.get(agno);
                    PMSDataWrapper.ContractInformation contract = new PMSDataWrapper.ContractInformation();
                    contract.contractNumber = agno;
                    List<PMSDataWrapper.PropertyInformationList> propertyInformationList = new List<PMSDataWrapper.PropertyInformationList>();
                    for (g_reqitem__c ri : riLst) {
                        PMSDataWrapper.PropertyInformationList p = new PMSDataWrapper.PropertyInformationList();
                        p.Area = String.valueOf(ri.xcasqm__c);
                        ejariLeaseArea = ejariLeaseArea +ri.xasf__c;
                        p.unitNumber = ri.xpreno__c;
                        p.unitNumberArb = ri.xoffnoarb__c;
                        p.approvalRefNumber = p.unitNumber;
                        p.propertyType =  ri.xptp__c;
                        p.propertySubType =  ri.xpstp__c;
                        p.floorEN = ri.xflr__c;
                        p.floorAR = ri.xflrarb__c;
                        p.isMainAddr = ri.xisma__c;
                        Date sdt = ri.xlesd__c;
                        contract.startDate = sdt.month()+'/'+sdt.day()+'/'+sdt.year();
                        Date eDt = ri.xleed__c;
                        contract.endDate = eDt.month()+'/'+eDt.day()+'/'+eDt.year();
                        PMSDataWrapper.Name buildingName = new PMSDataWrapper.Name();
                        buildingName.englishName = ri.xbldg__c;
                        buildingName.arabicName = ri.xbldgarb__c;
                        contract.buildingName = buildingName;
                        propertyInformationList.add(p);
                    }
                    contract.propertyInformationList = propertyInformationList;
                    contractList.add(contract);
                }
            }
        }
        if (unitMap != null && !unitMap.isEmpty()) {
            for (String agno : unitMap.keySet()) {
                List<PMSAmdDataWrapper.UnitInfo> riLst = unitMap.get(agno);
                PMSDataWrapper.ContractInformation contract = new PMSDataWrapper.ContractInformation();
                contract.contractNumber = agno;
                List<PMSDataWrapper.PropertyInformationList> propertyInformationList = new List<PMSDataWrapper.PropertyInformationList>();
                for (PMSAmdDataWrapper.UnitInfo ri : riLst) {
                    PMSDataWrapper.PropertyInformationList p = new PMSDataWrapper.PropertyInformationList();
                    p.Area =String.valueOf(ri.areaSft);
                    p.unitNumber = ri.unitNoEn;
                    p.unitNumberArb = ri.unitNoAr;
                    p.approvalRefNumber = ri.unitNoEn;
                    p.propertyType =  ri.propertyTypeEn;
                    p.propertySubType =  ri.propertySubTypeEn;
                    p.floorEN = ri.floor;
                    p.floorAR = ri.floor;
                    p.isMainAddr = false;
                    contract.startDate = ri.contractStartDate;
                    contract.endDate = ri.contractEndDate;
                    PMSDataWrapper.Name buildingName = new PMSDataWrapper.Name();
                    buildingName.englishName = ri.building;
                    buildingName.arabicName = ri.buildingAr;
                    contract.buildingName = buildingName;
                    propertyInformationList.add(p);
                }
                contract.propertyInformationList = propertyInformationList;
                contractList.add(contract);
            }
        }
        rq.xadtx2__c =  JSON.serialize(contractList);
        rq.xcawp__c = true;
        rq.xppsfv__c = true;
        if (ejariLeaseArea != null && ejariLeaseArea != 0) {
            psffeeIcVat = (ejariLeaseArea * decimal.valueOf(Label.PSFFeeSF));
            psffeeIcVat = (psffeeIcVat + ((psffeeIcVat * 5) / 100)).setScale(2, RoundingMode.HALF_UP);
            rq.xsvn__c = String.valueOf(ejariLeaseArea);
            rq.xvnum__c = String.valueOf(psffeeIcVat);
        }
        system.debug('xvnum__c::'+rq.xvnum__c+':xcawp__c:'+rq.xcawp__c);
        if (Schema.sObjectType.g_req__c.isUpdateable()) {
            update rq;
        }
    }

    public static string ejariLeaseStr(String rid) {
        String leaseStr = '';
         List<String> ofcItmCdList = Label.PMSOfcItmCd.split(';');
        List<PMSDataWrapper.ContractInformation> contractList = new List<PMSDataWrapper.ContractInformation>();
        List<g_reqitem__c> rilcList = [select id, xpreno__c, xpstp__c, xoffnoarb__c, xlesd__c,
            xplt__c, xpltar__c, xasf__c, xcasqm__c, xargno__c, xflr__c, xflrarb__c, xisma__c,
            xleed__c, xbldg__c, xbldgarb__c from g_reqitem__c where rq__c=:rid and xleatp__c='PMS Lease' and itm__r.cd__c=:ofcItmCdList ];
        if (rilcList != null && !rilcList.isEmpty()) {

                 Map<String, List<g_reqitem__c>> lsMp = new Map<String, List<g_reqitem__c>>();
                  for (g_reqitem__c ri: rilcList) {
                      if (lsMp.containsKey(ri.xargno__c)) {
                        List<g_reqitem__c> riLst = lsMp.get(ri.xargno__c);
                        riLst.add(ri);
                        lsMp.put(ri.xargno__c, riLst);
                      }
                      else{
                          List<g_reqitem__c> riLst = new List<g_reqitem__c>();
                          riLst.add(ri); lsMp.put(ri.xargno__c, riLst);
                      }
                  }
                    if (lsMp != null && !lsMp.isEmpty()) {

                        for (String agno : lsMp.keySet()) {
                          List<g_reqitem__c> riLst = lsMp.get(agno);
                           PMSDataWrapper.ContractInformation contract = new PMSDataWrapper.ContractInformation();
                           contract.contractNumber = agno;
                           List<PMSDataWrapper.PropertyInformationList> propertyInformationList = new List<PMSDataWrapper.PropertyInformationList>();
                            for (g_reqitem__c ri : riLst) {
                             PMSDataWrapper.PropertyInformationList p = new PMSDataWrapper.PropertyInformationList();
                             p.Area = String.valueOf(ri.xcasqm__c);
                             p.unitNumber = ri.xpreno__c;
                             p.unitNumberArb = ri.xoffnoarb__c;
                             p.approvalRefNumber = p.unitNumber;
                             p.propertySubType =  ri.xpstp__c;  //'Office';
                             p.floorEN = ri.xflr__c;
                             p.floorAR = ri.xflrarb__c;
                             p.isMainAddr = ri.xisma__c;
                             Date sdt = ri.xlesd__c;
                             contract.startDate = sdt.month()+'/'+sdt.day()+'/'+sdt.year();
                             Date eDt = ri.xleed__c;
                             contract.endDate = eDt.month()+'/'+eDt.day()+'/'+eDt.year();
                             PMSDataWrapper.Name buildingName = new PMSDataWrapper.Name();
                             buildingName.englishName = ri.xbldg__c;
                             buildingName.arabicName = ri.xbldgarb__c;
                             contract.buildingName = buildingName;
                             propertyInformationList.add(p);
                            }
                            contract.propertyInformationList = propertyInformationList;
                            contractList.add(contract);
                        }

                    }
            if (contractList != null && !contractList.isEmpty()) {
                leaseStr = JSON.serialize(contractList);
            }

    }
        return leaseStr;
    }

    public static void insertPMSAmndOffLoc(g_Req__c rq) {
        try{
            if (String.isNotBlank(rq.xadtx4__c) ) {
                List<String> ofcItmCdList = Label.PMSOfcItmCd.split(';');
                List<g_reqitem__c> delRqItmList = [select id from g_reqitem__c where rq__c=:rq.id and itm__r.cd__c=:ofcItmCdList];
                if (delRqItmList != null && !delRqItmList.isEmpty()) delete delRqItmList;
                Map<string, g_srvcitm__c> srvmp = new Map<string, g_srvcitm__c>();
                list < g_reqitem__c > tI = new list < g_reqitem__c > ();
                List<PMSAmdDataWrapper.UnitInfo> contractlist = (List<PMSAmdDataWrapper.UnitInfo>) json.deserialize(rq.xadtx4__c, List<PMSAmdDataWrapper.UnitInfo>.class);
                if (contractlist != null && !contractlist.isEmpty()) {
                    for (g_srvcitm__c i: [Select id, Req__c, Name, cd__c, srvc__c, rv__c, prcEdt__c, DscApp__c,
                        KF__c, scN__c, cN__c, smN__c, slaN__c, spChN__c, scXP__c, cXP__c, smXP__c, slaXP__c,
                        vsc__c, vst__c, vec__c, vesch__c, ngs__c, ngsXP__c, su__c, vsu__c, TAX_CODE__c, TAX_TYPE__c,
                        extc__c, TAXCODE_SC__c, extcsc__c, (Select Id From Statuses__r where isDeleted = false and cd__c ='n' limit 1) From g_srvcitm__c where isDeleted = false and actv__c = true and srvc__c=:rq.srvc__c and cd__c=:ofcItmCdList]) {
                        srvmp.put(i.cd__c, i);
                    }
                    integer j=2, i=1;
                    String sitmCd = '';
                    boolean strxmu = false;
                    String strArg, strxbldg, strxbldgarb, strxbu, strxbuarb, strxflr, strxflrarb, strxoffno, strxoffnoarb, strcd, strxleed, strpstp, strAmdtp;
                    Date xstrxleed, xstrxlesd;
                    Decimal areaSM = 0, areaSF=0;
                    for (PMSAmdDataWrapper.UnitInfo c:contractlist) {
                        if (String.isNotBlank(c.sts) && (c.sts == 'N' || c.sts == 'T')) {
                            areaSM = 0;
                            areaSF=0;
                            strArg =c.contractNo;
                            strxbldg = (c.building != null) ? c.building : '';
                            strxbldgarb = (c.buildingAr != null) ? c.buildingAr : '';
                            strAmdtp = '';
                            if (j <= 9) {
                                sitmCd = 'lc'+j;
                            }
                            else{
                                sitmCd = 'la'+i;
                                i = i+1;
                            }
                            system.debug('sitmCd::'+sitmCd);
                            if (srvmp != null && srvmp.containsKey(sitmCd)) {
                                g_srvcitm__c itm = srvmp.get(sitmCd);
                                strxoffno = c.unitNoEn;
                                strxoffnoarb = c.unitNoAr;
                                strpstp = c.propertySubTypeEn;
                                if (String.isNotBlank(c.contractStartDate)) {
                                    List<string> lstStrDt = c.contractStartDate.split('/');
                                    xstrxlesd = date.parse(lstStrDt[0]+'/'+lstStrDt[1]+'/'+lstStrDt[2]);
                                }
                                if (String.isNotBlank(c.contractEndDate)) {
                                    List<string> lstEndDt = c.contractEndDate.split('/');
                                    xstrxleed = date.parse(lstEndDt[0]+'/'+lstEndDt[1]+'/'+lstEndDt[2]);
                                }
                                if (c.sts == 'N') strAmdtp = 'New';
                                else strAmdtp = 'Terminate';
                                areaSM = c.areaSm;
                                areaSF = c.areaSft;
                                tI.add(new g_reqitem__c(Name = itm.Name, RQ__c = rq.Id, itm__c = itm.Id,
                                    sta__c = itm.Statuses__r[0].Id, DscApp__c = itm.DscApp__c, exp__c = false,
                                    KF__c = itm.KF__c, scN__c =itm.scN__c, cN__c = itm.cN__c, smN__c = itm.smN__c,
                                    slaN__c = itm.slaN__c, scXP__c = itm.scXP__c, cXP__c = itm.cXP__c,
                                    smXP__c = itm.smXP__c, slaXP__c = itm.slaXP__c, vsc__c = itm.vsc__c,
                                    vst__c = itm.vst__c, vec__c = itm.vec__c, vesch__c = itm.vesch__c,
                                    ngs__c = itm.ngs__c, ngsXP__c = itm.ngsXP__c, su__c = itm.su__c,
                                    vsu__c = itm.vsu__c, TAX_CODE__c = itm.TAX_CODE__c, TAX_TYPE__c = itm.TAX_TYPE__c,
                                    extc__c = itm.extc__c, TAXCODE_SC__c = itm.TAXCODE_SC__c, extcsc__c = itm.extcsc__c,
                                    xbldg__c = strxbldg, xbldgarb__c = strxbldgarb, xbu__c = strxbu,
                                    xbuarb__c = strxbuarb, xflr__c = strxflr, xflrarb__c = strxflrarb,
                                    xpreno__c = strxoffno, xlesd__c = xstrxlesd, xleed__c = xstrxleed,
                                    xoffnoarb__c = strxoffnoarb, xisma__c = strxmu, xargno__c = strArg,
                                    xcasqm__c=areaSM, xasf__c=areaSF, xleatp__c='PMS Lease', xpstp__c=strpstp,
                                    xlamdtp__c=strAmdtp));
                                j=j+1;
                            }
                        }
                    }
                    if (tI != null && !tI.isEmpty()) {
                        system.debug('tI size::'+tI.size());
                        if (Schema.sObjectType.g_reqitem__c.isCreateable()) {
                            insert tI;
                        }
                    }
                }
            }
        }
        catch (Exception ex) {
            system.debug('ex insert pms offc location:'+ex.getMessage());
        }
    }
}
public class ctrlPMSupdateinfo {
    public static void upsertContractInfo(List < id > wIdLst) {
        List < ws_call__c > wslst = [Select Id, rq_itm__r.RQ__r.Acc__r.park__c, adhoc_text1__c, ws_typ__c, rq_itm__r.RQ__r.xopn__c, rq_itm__r.RQ__r.activitiesFL__c, rq_itm__r.RQ__r.Acc__r.lc__c, rq_itm__r.itm__c, rq_itm__r.RQ__r.xdccaRq__c, rq_itm__r.RQ__r.xvnum__c, rq_itm__r.RQ__r.xadtx2__c, rq_itm__r.RQ__r.xvn__c, rq_itm__r.RQ__r.Acc__r.ORACLE_PARTY_ID__c, rq_jsn__c, intsts__c, res_jsn__c, err_msg__c, pmid__c, rq_itm__c, xrno__c from ws_call__c where id in:wIdLst];
        ws_call__c ws = wslst[0];
        Map < String, String > alphaAr= new Map < String, String >();

        alphaAr.put('A', 'أ');
        alphaAr.put('B', 'ب');
        alphaAr.put('C', 'ج');
        alphaAr.put('D', 'د');
        alphaAr.put('E', 'هـ');
        alphaAr.put('F', 'و');
        alphaAr.put('G', 'ز');
        alphaAr.put('H', 'ح');
        alphaAr.put('I', 'ط');
        alphaAr.put('J', 'ي');
        alphaAr.put('K', 'ك');
        alphaAr.put('L', 'ل');
        alphaAr.put('M', 'م');
        alphaAr.put('N', 'ن');
        alphaAr.put('O', 'س');
        alphaAr.put('P', 'ع');
        alphaAr.put('Q', 'ف');
        alphaAr.put('R', 'ص');
        alphaAr.put('S', 'ق');
        alphaAr.put('T', 'ر');
        alphaAr.put('U', 'ش');
        alphaAr.put('V', 'ت');
        alphaAr.put('W', 'ث');
        alphaAr.put('X', 'خ');
        alphaAr.put('Y', 'ذ');
        alphaAr.put('Z', 'ض');
        alphaAr.put('AA', 'ظ');
        alphaAr.put('AB', 'غ');
        alphaAr.put('UNIT', 'وحدة');
        alphaAr.put('SHOWROOM', 'معرض');
        alphaAr.put('SHOP', 'محل');
        alphaAr.put('RETAIL', 'محل');
        alphaAr.put('DESK', 'مكتب');
        alphaAr.put('SH', 'محل');
        alphaAr.put('WAREHOUSE', 'مستودع');
        alphaAr.put('KIOSK', 'كشك');
        alphaAr.put('WH', 'دبليو اتش');
        alphaAr.put('OFFICE', 'المكتب');
        alphaAr.put('G', 'ز.');
        alphaAr.put('SHOP-M', 'محل ام');
        alphaAr.put('Hypermarket', 'هايبر ماركت');
        alphaAr.put('NoorS', 'نور - س');
        String arGround = 'الأرضي';
        String offAr = 'مكتب';
        String gApiToken = [Select id, tokenvalue__c from GDRFAAPITOKEN__mdt LIMIT 1].tokenvalue__c;
        List < String > ground_floor = new List < String > {'UNIT', 'NoorS', 'SHOWROOM', 'SHOP', 'RETAIL', 'DESK', 'SH',
            'WAREHOUSE', 'KIOSK', 'WH', 'OFFICE', 'G',
            '-G', 'Hypermarket', 'R'};

                List < String > mezzanine = new List < String > { 'M0', '-M', 'SHOP-M' };

                    List < String > ground_floor_building = new List < String > { 'Me\'aisem City Centre', 'Meaisem City Centre', 'City Centre'};

                        String reqBody = '', resStr = '';
        String licNo = '', partyId = '', licType = '';
        try {
            //List<Account> accLst = [select id,name,ORACLE_PARTY_ID__c,park__c from account where lc__c=:licNo];
            if (ws.ws_typ__c == 'Onboarding') {
                licType = 'New';
            } else {
                licNo = ws.rq_itm__r.RQ__r.Acc__r.lc__c;
                licType = 'Renewal';
            }
            // String endPoint = 'callout:TECOM_QA/apexrest/pms';
            String endPoint = 'callout:'+label.CRM_Instance+'/apexrest/pms';
            partyId = ws.rq_itm__r.RQ__r.Acc__r.ORACLE_PARTY_ID__c;
            List < PMSDataWrapper.ContractInformation > contractList = null;
            if (ws.ws_typ__c == 'Onboarding')
                contractList = (List < PMSDataWrapper.ContractInformation > ) Json.deserialize(ws.rq_itm__r.RQ__r.activitiesFL__c, List < PMSDataWrapper.ContractInformation > .class);
            else if (ws.ws_typ__c == 'Lease Amendment')
                contractList = (List < PMSDataWrapper.ContractInformation > ) Json.deserialize(ws.rq_itm__r.RQ__r.xadtx2__c, List < PMSDataWrapper.ContractInformation > .class);

            else {
                List < String > ofcItmCdList = Label.PMSOfcItmCd.split(';');
                contractList = new List < PMSDataWrapper.ContractInformation > ();
                //******Fetch floor information from CRM and DDA*******//
                Map < String, grqWsDccaGetService.Products > CRMUnitsMapd = new Map < String, grqWsDccaGetService.Products > ();
                Map < String, grqWsDccaGetService.Products > DDAUnitsMapd = new Map < String, grqWsDccaGetService.Products > ();

                //DDA MAP
                String allLoc = grqWsDccaGetService.loaddccaLoc(licNo);
                grqWsDccaGetService.ActivityLocations alldccaLoc = new grqWsDccaGetService.ActivityLocations();
                alldccaLoc = (grqWsDccaGetService.ActivityLocations) JSON.deserialize(allLoc, grqWsDccaGetService.ActivityLocations.class);
                system.debug('alldccaLoc===1233='+alldccaLoc);
                for (grqWsDccaGetService.Products prd: alldccaLoc.locationList[0].prodList) {
                    System.debug('==prd =' + prd.ProductName);
                    DDAUnitsMapd.put(prd.ProductName, prd);
                }


                //CRM MAP
                List < grqWsDccaGetService.Records > tecomLeaseList = new List < grqWsDccaGetService.Records > ();
                tecomLeaseList = grqWsDccaGetService.loadD3Loc(partyId);
                system.debug('tecomLeaseList==='+tecomLeaseList);
                if (!tecomLeaseList.isEmpty())
                {
                    for (grqWsDccaGetService.Products prd: tecomLeaseList[0].Products) {
                        System.debug('==prd =' + prd.ProductName);
                        CRMUnitsMapd.put(prd.ProductName, prd);
                    }
                }
                //*************//
                List < g_reqitem__c > rilcList = [select id, RQ__r.xadtx4__c, xpreno__c, xptp__c, xpstp__c, xoffnoarb__c, xlesd__c, xplt__c, xpltar__c, xasf__c, xcasqm__c, xargno__c, xflr__c, xflrarb__c, xisma__c, xleed__c, xbldg__c, xbldgarb__c from g_reqitem__c where rq__c =: ws.rq_itm__r.RQ__c and xleatp__c = 'PMS Lease'
                                                  and itm__r.cd__c =: ofcItmCdList
                                                 ];
                if (rilcList != null && !rilcList.isEmpty()) {


                    Map < String, List < g_reqitem__c >> lsMp = new Map < String, List < g_reqitem__c >> ();
                    for (g_reqitem__c ri: rilcList) {
                        if (lsMp.containsKey(ri.xargno__c)) {
                            List < g_reqitem__c > riLst = lsMp.get(ri.xargno__c);
                            riLst.add(ri);
                            lsMp.put(ri.xargno__c, riLst);
                        } else {
                            List < g_reqitem__c > riLst = new List < g_reqitem__c > ();
                            riLst.add(ri);
                            lsMp.put(ri.xargno__c, riLst);
                        }
                    }
                    if (lsMp != null && !lsMp.isEmpty()) {

                        for (String agno: lsMp.keySet()) {
                            List < g_reqitem__c > riLst = lsMp.get(agno);
                            PMSDataWrapper.ContractInformation contract = new PMSDataWrapper.ContractInformation();
                            contract.contractNumber = agno;
                            List < PMSDataWrapper.PropertyInformationList > propertyInformationList = new List < PMSDataWrapper.PropertyInformationList > ();
                            for (g_reqitem__c ri: riLst) {
                                PMSDataWrapper.PropertyInformationList p = new PMSDataWrapper.PropertyInformationList();
                                p.Area = String.valueOf(ri.xcasqm__c);
                                p.unitNumber = ri.xpreno__c;
                                p.unitNumberArb = ri.xoffnoarb__c;
                                p.approvalRefNumber = p.unitNumber;
                                p.propertyType = ri.xptp__c;
                                p.propertySubType = ri.xpstp__c; //'Office';
                                p.floorEN = ri.xflr__c;
                                p.floorAR = ri.xflrarb__c;
                                p.isMainAddr = ri.xisma__c;
                                Date sdt = ri.xlesd__c;
                                contract.startDate = sdt.month() + '/' + sdt.day() + '/' + sdt.year();
                                Date eDt = ri.xleed__c;
                                contract.endDate = eDt.month() + '/' + eDt.day() + '/' + eDt.year();
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

                } else if (String.isNotBlank(ws.rq_itm__r.RQ__r.xvnum__c)) {
                    contractList = (List < PMSDataWrapper.ContractInformation > ) Json.deserialize(ws.rq_itm__r.RQ__r.xadtx2__c, List < PMSDataWrapper.ContractInformation > .class);
                } else {
                    PMSDataWrapper.ContractInformation contract = new PMSDataWrapper.ContractInformation();
                    List < PMSDataWrapper.PropertyInformationList > propertyInformationList = new List < PMSDataWrapper.PropertyInformationList > ();
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
                List < PMSDataWrapper.Data > dataLst = new List < PMSDataWrapper.Data > ();
                for (PMSDataWrapper.ContractInformation contract: contractList) {
                    PMSDataWrapper.Data data = new PMSDataWrapper.Data();
                    data.oraclePartyId = partyId;
                    data.contractNumber = contract.contractNumber;
                    data.landNumber = contract.landNumber;
                    data.contractStatus = 'Active';
                    date cstDt = Date.today();
                    if (String.isNotBlank(contract.startDate)) {
                        List < string > lstStrDt = contract.startDate.split('/');
                        date cstrDt = date.parse(lstStrDt[1] + '/' + lstStrDt[0] + '/' + lstStrDt[2]);
                        //cstDt = Date.today().adddays(-2);
                        data.contractStartDate = string.valueOf(cstrDt);
                    }
                    if (String.isNotBlank(contract.endDate)) {
                        List < string > lstEndDt = contract.endDate.split('/');
                        date cenDt = date.parse(lstEndDt[1] + '/' + lstEndDt[0] + '/' + lstEndDt[2]);
                        //date cenDt = cstDt.addYears(1).adddays(-1);
                        data.contractEndDate = string.valueOf(cenDt);
                    }
                    data.licenseIssuer = 'DUBAI DEVELOPMENT AUTHORITY';
                    data.makaniNumber = contract.makaniNumber;
                    data.pushToDDA = true;
                    data.type = licType;

                    if (contract.buildingName != null) {
                        data.buildingName = contract.buildingName.englishName;
                        data.buildingNameArabic = String.isNotBlank(contract.buildingName.arabicName) ? (contract.buildingName.arabicName) : (GDRFAUtil.engToArabicByChar(data.buildingName, ''));
                            }

                    List < PMS_BuldInfo__c > buldList = [select id, Building_Name__c, BuildingName_Arabic__c, BU_Code__c from PMS_BuldInfo__c where Building_Name__c =: data.buildingName];

                    data.businessPark = (buldList != null && buldList.size() > 0) ? (buldList[0].BU_Code__c) : ws.rq_itm__r.RQ__r.Acc__r.park__c.toUpperCase();

                    if (ws.ws_typ__c == 'Onboarding' && buldList != null && !buldList.isEmpty() && String.isNotBlank(buldList[0].BuildingName_Arabic__c)) {
                        data.buildingNameArabic = buldList[0].BuildingName_Arabic__c;
                    }

                    List < PMSDataWrapper.LeaseItems > leaselst = new List < PMSDataWrapper.LeaseItems > ();
                    decimal propertyArea = 0;
                    integer i = 0;
                    for (PMSDataWrapper.PropertyInformationList property: contract.propertyInformationList) {
                        if (String.isNotBlank(property.unitNumber)) {
                            PMSDataWrapper.LeaseItems leaseItm = new PMSDataWrapper.LeaseItems();
                            leaseItm.isMainAddress = false;
                            leaseItm.propertyName = property.unitNumber;
                            //arabic property name to be moved to util
                            String xx = property.unitNumber;
                            system.debug('property.unitNumber======'+property.unitNumber);
                            String nonAr = GDRFAUtil.engToArabicByChar(property.unitNumber, '').replace('null', '');
                            String yy = xx.replace(nonAr, '').replace('null', '').trim().reverse();
                            String arb = nonAr + '' + yy;
                            String ff = '';
                            String[] stringCharacters = arb.split('');
                            for (String x: stringCharacters) {
                                if (alphaAr.containsKey(x)) {
                                    System.debug('x--' + x + alphaAr.get(x));
                                    arb = arb.replace(x, alphaAr.get(x));
                                }
                            }
                            String flr = '';
                            if (nonAr.isNumeric()) {
                                if (nonAr.startsWith('0')) {
                                    flr = 'Ground';
                                    leaseItm.floorEN = flr;
                                    leaseItm.floorAR = arGround;
                                    flr = '0';
                                } else if (nonAr.length() == 3) {
                                    flr = nonAr.length() == 3 ? '0' + nonAr.SubString(0, 1) : '0';
                                } else if (nonAr.length() == 4) {
                                    flr = nonAr.length() == 4 ? nonAr.SubString(0, 2) : '0';
                                }


                            }

                            System.debug('arb--' + arb);
                            leaseItm.propertyNameArabic = arb;
                            leaseItm.floorEN = flr;
                            leaseItm.floorAR = flr;

                            /* Numeric */

                            if (xx.isNumeric()) {
                                leaseItm.propertyName = property.unitNumber;
                                leaseItm.propertyNameArabic = property.unitNumber;
                                if (nonAr.length() == 3) {
                                    flr = nonAr.length() == 3 ? '0' + nonAr.SubString(0, 1) : '0';
                                } else if (nonAr.length() == 4) {
                                    flr = nonAr.length() == 4 ? nonAr.SubString(0, 2) : '0';
                                }

                                leaseItm.floorEN = flr;
                                leaseItm.floorAR = flr;
                                if (flr == '0') {
                                    flr = 'Ground';
                                    leaseItm.floorEN = flr;
                                    leaseItm.floorAR = arGround;
                                    leaseItm.floorNumber = 0;
                                }

                            }

                            //ground floor
                            nonAr = GDRFAUtil.engToArabicByChar(property.unitNumber, '').replace('null', '');
                            yy = xx.replace(nonAr, '').replace('-', '').replace('_', '').replace('null', '').replaceAll('[^a-zA-Z_]', '').trim();
                            system.debug('#########ground_floor####################--' + yy);
                            if (ground_floor.contains(yy)) {
                                if (alphaAr.containsKey(yy)) {
                                    arb = alphaAr.get(yy);
                                }
                                leaseItm.propertyName = property.unitNumber;
                                leaseItm.propertyNameArabic = nonAr + '-' + arb;
                                leaseItm.floorEN = 'Ground';
                                leaseItm.floorAR = 'الأرضي';
                                
                            } else if (mezzanine.contains(yy)) {
                                if (alphaAr.containsKey(yy)) {
                                    arb = alphaAr.get(yy);
                                }
                                leaseItm.propertyName = property.unitNumber;
                                leaseItm.propertyNameArabic = nonAr + '-' + arb;
                                flr = 'Mezzanine';
                                leaseItm.floorAR = 'الميزانين';
                            } else if (yy.contains('FL')) {
                                String regex = '[^0-9]';
                                String flrNo = (property.unitNumber).replaceAll(regex, '');
                                leaseItm.floorEN = flrNo;
                                leaseItm.floorAR = flrNo;
                                leaseItm.propertyName = property.unitNumber;
                                String nonArc = (property.unitNumber).replace(flrNo, '').replaceAll('[^a-zA-Z]+', '');
                                nonAr = GDRFAUtil.engToArabicStr(nonArc, gApiToken);
                                nonAr = flrNo + '-' + nonAr;
                            } else if (flr != null && flr == '0') {
                                system.debug('#########regex-frl###########--');
                                String regex = '[^0-9]';
                                String flrNo = (property.unitNumber).replaceAll(regex, '');
                                system.debug('#########flrNo###########--' + flrNo);
                                leaseItm.floorEN = 'Ground';
                                leaseItm.floorAR = arGround;
                                leaseItm.propertyName = property.unitNumber;
                                String nonArc = (property.unitNumber).replace(flrNo, '').replaceAll('[^a-zA-Z]+', '');
                                system.debug('#########nonArc###########--' + nonArc);
                                nonAr = GDRFAUtil.engToArabicStr(nonArc, gApiToken);
                                nonAr = flrNo + '-' + nonAr;
                                system.debug('#########nonAr###########--' + nonAr);

                            }




                            //############################################################
                            if (flr.isNumeric()) {
                                leaseItm.floorNumber = integer.valueOf(flr);
                            }
                            System.debug('property.unitNumberArbproperty.unitNumberArb--' + property.unitNumberArb);

                            if (ws.ws_typ__c == 'Onboarding' && String.isBlank(ws.rq_itm__r.RQ__r.xvnum__c)) {
                                leaseItm.propertyNameArabic = String.isNotBlank(property.unitNumberArb) ? property.unitNumberArb : property.unitNumber;
                                leaseItm.approvalReferenceNumber = property.approvalRefNumber;
                                if (String.isNotBlank(property.floorEN)) {
                                    leaseItm.floorEN = property.floorEN;
                                    leaseItm.floorAR = property.floorAR;
                                    if (property.floorEN.isNumeric()) leaseItm.floorNumber = integer.valueOf(property.floorEN);
                                }
                            }

                            leaseItm.propertyType = 'Unit';
                            leaseItm.ejariPropertyType = property.propertyType;
                            leaseItm.ejariPropertyTypeArabic = //GDRFAUtil.engToArabicByChar(leaseItm.ejariPropertyType,'');
                                leaseItm.ejariPropertySubtype = property.propertySubType;

                            leaseItm.ejariPropertySubtypeArabic = offAr; //GDRFAUtil.engToArabicByChar(leaseItm.ejariPropertySubtype,'').replace('null','');
                            propertyArea = (String.isNotBlank(property.Area)) ? decimal.valueOf(property.Area) : 0.0;
                            leaseItm.size = (propertyArea * 10.7639).setScale(2, RoundingMode.HALF_UP);
                            if (contract.location != null)
                                leaseItm.location = contract.location.name.englishName;
                            leaseItm.usage = property.propertyUsage;
                            if (String.isNotBlank(property.dewa))
                                data.dewaAccountNumber = property.dewa;
                            if (property.isMainAddr != null && property.isMainAddr)
                                leaseItm.isMainAddress = true;
                            else if (String.isNotBlank(ws.rq_itm__r.RQ__r.xopn__c) && ws.rq_itm__r.RQ__r.xopn__c == property.unitNumber)
                                //if (i==0)
                                leaseItm.isMainAddress = true;

                            i = i + 1;
                            leaseItm.propertyNameArabic = (leaseItm.propertyNameArabic).replace('null', '');
                            leaselst.add(leaseItm);
                        }
                    }
                    data.leaseItems = leaselst;
                    dataLst.add(data);

                }
                pmsData.data = dataLst;
                reqBody = (String) Json.serialize(pmsData);
            }
            ws.rq_jsn__c = reqBody;
            // insert ws;
            system.debug('reqBody::' + reqBody);
            system.debug('reqBody--' + reqBody);
        } catch (Exception ex) {
            system.debug('ex::' + ex.getStackTraceString()+ ex.getMessage());
        }
        // List<ws_call__c> objws = [Select Id, rq_itm__r.RQ__r.Acc__r.park__c, adhoc_text1__c, ws_typ__c, rq_itm__r.RQ__r.xopn__c, rq_itm__r.RQ__r.activitiesFL__c, rq_itm__r.RQ__r.Acc__r.lc__c, rq_itm__r.itm__c, rq_itm__r.RQ__r.xdccaRq__c, rq_itm__r.RQ__r.xvnum__c, rq_itm__r.RQ__r.xadtx2__c, rq_itm__r.RQ__r.xvn__c, rq_itm__r.RQ__r.Acc__r.ORACLE_PARTY_ID__c, rq_jsn__c, intsts__c, res_jsn__c, err_msg__c, pmid__c, rq_itm__c, xrno__c from ws_call__c where id in:wIdLst];
        // ws=objws[0];
        system.debug('Lic NO:' + ws.rq_itm__r.RQ__r.xdccaRq__c);
        if (String.isNotBlank(ws.rq_itm__r.RQ__r.xdccaRq__c)) { //String.isNotBlank(ws.rq_itm__r.RQ__r.xdccaRq__c)
            //String resJson = gwsPMSIntegration.upsertContractInfo(ws);
            String requestBody = ws.rq_jsn__c;
            // String endPoint = 'callout:TECOM_QA/apexrest/pms';
            String endPoint = 'callout:' + label.CRM_Instance + '/apexrest/pms';
            String resJson = '';
            HTTPResponse httpRes = gwsPMSIntegration.httpResponse(requestBody, endPoint, 'POST');
            if (httpRes != null && httpRes.getStatusCode() == 200) {
                resJson = httpRes.getBody();
                system.debug('res1::' + httpRes.getBody());
            }
            system.debug('resJson:;' + resJson);
            if (Test.isRunningtest())
            {
                resJson = '[{"type":"PMS Lease","isSuccess":true,"Id":"23234324"}]';
            }
            if (String.isNotBlank(resJson)) {
                List < PMSDataWrapper.PMSLeaseResponse > pmsResponseList = (List < PMSDataWrapper.PMSLeaseResponse > ) Json.deserialize(resJson, List < PMSDataWrapper.PMSLeaseResponse >.class);
                if (pmsResponseList != null && !pmsResponseList.isEmpty()) {
                    boolean pmsFlg = true;
                    String leaseid = '';
                    for (PMSDataWrapper.PMSLeaseResponse pmsRes: pmsResponseList) {
                        if (pmsRes.isSuccess && pmsRes.type == 'PMS Lease') {
                            ws.intsts__c = 'Success';
                            ws.res_jsn__c = resJson;
                            leaseid = pmsRes.Id;
                            update ws;
                            /*create invoice ws call*/
                            String rqId= ws.rq_itm__r.RQ__c;
                            if (rqId!=null){
                                List<g_tran__c> T = [select id,A__c,md__c,RQ__r.name, name,RQ__r.xdei__c,RQ__r.Service_Code__c, TP__c,sta__c from g_tran__c where rq__c=:rqId and sta__c='Completed' limit 1];
                                system.debug('tran -- '+T[0]);
                                system.debug('RQ__r.Service_Code__c -- '+T[0].RQ__r.Service_Code__c);
                                List<g_reqitem__c> rqitm = [select id, name, RQ__r.xdei__c from g_reqitem__c where rq__c=:rqId  limit 1];
                                system.debug('rqitm -- '+rqitm[0]);
                                grqWsDccaInvoiceService.invWsCreation(T[0], T[0].RQ__r.xdei__c, rqitm[0].id);
                            }

                        } else if (!pmsRes.isSuccess && pmsRes.type == 'PMS Lease') {
                            pmsFlg = false;
                            ws.intsts__c = 'Failed';
                            ws.res_jsn__c = resJson;
                            update ws;
                        }
                    }

                }


            } else {
                ws.intsts__c = 'Failed';
                update ws;
            }
        }
    }
}
public class grDDAReq {
    public Account Acc{get;set;}
    public g_Req__c rq{get;set;}

    public grqWsDccaGetService.ActivityLocations allAct {get;set;}
    public Transient List<grqWsDccaGetService.Locations> dccalocList {get;set;}
    public Transient List<grqWsDccaGetService.Activities> dccaActList {get;set;}
    public Transient List<grqWsDccaGetService.Records> tecomd3LsList {get;set;}
    public Transient List<grqWsDccaGetService.Records> tecomLeaseList {get;set;} public Transient List<grqWsDccaGetService.Records> tecomd3LeaseList {get;set;}
    public Transient List<grqWsDccaGetService.Records> d3LeaseList {get;set;}
    public Transient List<grqWsDccaGetService.Records> crmAgrList {get;set;}
    public map<String, Integer> priceMap {get;set;} public map<String, Integer> chanTMap {get;set;} public map<String, Integer> addMainOffMap {get;set;}
    public map<String, String> agreeLocMap {get;set;}
    public map<String, String > agreeLocMap2 {get;set;}
    public  String agreeNoAmd {get;set;} public  boolean amedFlag{get;set;}
    public map<String, String> dccaStatusMap {get;set;}
    public String  regOfficeDcca{get;set;}
    public  String leaseDt{get;set;}
    public map<String, List<String>> newmapLoc {get;set;}
    public map<String, List<String> > finalAgreeLoc {get;set;} public  String newRegOffDcca{get;set;}
    public   Map<String, String> mapAct {get;set;}
    public   Map<String, String> mapprc {get;set;}
    public grDDAReq() {

        allAct = new grqWsDccaGetService.ActivityLocations();
        dccalocList = new List<grqWsDccaGetService.Locations>();
        dccaActList = new List<grqWsDccaGetService.Activities>();
        tecomLeaseList = new  List<grqWsDccaGetService.Records> ();
        tecomd3LsList = new  List<grqWsDccaGetService.Records> ();
        d3LeaseList  = new List<grqWsDccaGetService.Records>();

        crmAgrList = new List<grqWsDccaGetService.Records>();
        dccaStatusMap = new map<String, String>();
        //priceMap  = new map<String, Integer>();
        //chanTMap  = new map<String, Integer>();
        newmapLoc  = new map<String, List<String>>();
          agreeLocMap  = new map<String, String>();
        agreeLocMap2 = new map<String, String>();
        finalAgreeLoc = new map<String, List<String>>();
         mapAct = new map<String, String>();
         mapprc = new map<String, String>();
         amedFlag = false;
    }

public void LoadAllLocSeg(Boolean isShwloc) {
    grqWsDccaGetService.ActivityLocations  allActSeg = new grqWsDccaGetService.ActivityLocations();
    grqWsDccaGetService.ActivityLocations  alldccaLoc = new grqWsDccaGetService.ActivityLocations();
    String allSegAct;
    String allLoc;
    String regAddDDA = '';

    if (Acc != null && Acc.lc__c != null) {
        allSegAct = grqWsDccaGetService.loadAllSeg(Acc.lc__c);
        allActSeg = ( grqWsDccaGetService.ActivityLocations ) JSON.deserialize( allSegAct, grqWsDccaGetService.ActivityLocations.class);

        if (allActSeg != null) {
            system.debug('JJJ allSegAct'+allSegAct);

            if (isShwloc) { rq.xadtx1__c = allSegAct;}
            dccaActList = allActSeg.act;}
        allLoc = grqWsDccaGetService.loaddccaLoc(Acc.lc__c);

        if (isShwloc) {rq.xadtx4__c = allLoc;}
        system.debug('+++allLoc'+allLoc);
        alldccaLoc = ( grqWsDccaGetService.ActivityLocations ) JSON.deserialize( allLoc, grqWsDccaGetService.ActivityLocations.class);
        if (alldccaLoc != null && alldccaLoc.locationList != null) dccalocList = alldccaLoc.locationList;
        //grqWsDccaGetService.loaddccaLoc(Acc.lc__c);
        //
        system.debug('jjj Inside 0');
        if (dccaActList != null && dccaActList.size()>0 && alldccaLoc.errorCode=='0') {
            system.debug('jjj Inside 1');
            for (grqWsDccaGetService.Locations loc : dccalocList) {
                system.debug('jjj Inside 2');
                List<grqWsDccaGetService.products> prdLst = new  List<grqWsDccaGetService.products>();
                prdLst =loc.prodList;
                for (grqWsDccaGetService.products prd : prdLst) {
                    system.debug('jjj Inside 3');
                    system.debug('jjj prd'+prd);
                    if (prd.regOff == true) {
                        regAddDDA = loc.AgreementNo + '' + prd.UnitNumber;
                        regOfficeDcca = loc.AgreementNo +';Premises:'+prd.UnitNumber+', Floor:'+prd.Floor+', Building:'+prd.buildingName;
                    }
                    system.debug('jjj regOfficeDcca'+regOfficeDcca);
                }
            }

        }

        if (dccaActList != null && dccaActList.size()>0)
            mapAct=grqWsDccaGetService.actMap;
        mapprc=grqWsDccaGetService.priceMap;
    }
    if (dccalocList != null && dccalocList.size()!=0) {
        for (grqWsDccaGetService.Locations loc : dccalocList) {
            system.debug('loc.Status'+loc.Status);
            dccaStatusMap.put(loc.AgreementNo, loc.Status+loc.IsMainAdd);

            String locFull ='Premises:'+loc.OfficeNo+', Floor:'+loc.Floor+', Building:'+loc.BuildingName+', Business Park:'+loc.BusinessPark;
            system.debug('############loc.AgreementNo111####################');
            system.debug(loc.AgreementNo);
            system.debug(locFull);
            

            agreeLocMap.put(loc.AgreementNo, locFull) ;
            system.debug('JJJ locFull'+locFull);
        }

    }

    tecomLeaseList = new  List<grqWsDccaGetService.Records>();
    system.debug(' dccaStatusMap'+ dccaStatusMap);
    if (rq.xpmsle__c && String.isNotBlank(rq.xadtx2__c)) {
        List < PMSDataWrapper.ContractInformation > contractlist = (List < PMSDataWrapper.ContractInformation > ) JSON.deserialize(rq.xadtx2__c, List < PMSDataWrapper.ContractInformation > .class);
        Set < String > ctrList = new Set < String > ();
        if (contractlist != null && !contractlist.isEmpty()) {
            for (PMSDataWrapper.ContractInformation ctr: contractlist) {
                if (ctrList != null && !ctrList.contains(ctr.contractNumber)) {
                    grqWsDccaGetService.Records rec = new grqWsDccaGetService.Records();
                    rec.ContractNumber = ctr.contractNumber;
                    rec.AgNo = ctr.contractNumber;
                    rec.LeaseType = 'Ejari';
                    if (String.isNotBlank(ctr.startDate)) {
                        List < string > lstStrDt = ctr.startDate.split('/');
                        rec.ContractStartDate = lstStrDt[2] + '-' + lstStrDt[0] + '-' + lstStrDt[1];
                    }
                    if (String.isNotBlank(ctr.endDate)) {
                        List < string > lstEndDt = ctr.endDate.split('/');
                        rec.ContractEndDate = lstEndDt[2] + '-' + lstEndDt[0] + '-' + lstEndDt[1];
                    }
                    rec.BuildingName = ctr.buildingName.englishName;
                    rec.Status = 'Active';
                    ctrList.add(rec.ContractNumber);
                    List < grqWsDccaGetService.Units > unitList = new List < grqWsDccaGetService.Units > ();
                    if (ctr.PropertyInformationList != null && !ctr.PropertyInformationList.isEmpty()) {
                        for (PMSDataWrapper.PropertyInformationList p: ctr.PropertyInformationList) {
                            grqWsDccaGetService.Units u = new grqWsDccaGetService.Units();
                            u.UnitNoEnglish = p.unitNumber;
                            unitList.add(u);
                        }
                        rec.Units = unitList;
                    }
                    tecomLeaseList.add(rec);
                }
            }
        }
    }
    if (Acc != null && Acc.ORACLE_PARTY_ID__c != null && isShwloc) {
       /* if (rq.xpmsle__c) {
         tecomLeaseList = grqWsDccaGetService.loadTecomCRMLoc(Acc.ORACLE_PARTY_ID__c);
         system.debug('######################tecomLeaseList#############################');
         system.debug('JJJJJ tecomLeaseList00'+tecomLeaseList);
        }*/

            d3LeaseList = grqWsDccaGetService.loadD3Loc(Acc.ORACLE_PARTY_ID__c);

    }
    system.debug('######################d3LeaseList#############################');

    if (d3LeaseList != null && !d3LeaseList.isEmpty() && d3LeaseList.size()>0) {
        tecomLeaseList.addAll(d3LeaseList);
        tecomd3LsList.addAll(d3LeaseList);
    }
    system.debug('JJJJJ tecomLeaseList11'+tecomLeaseList);
    Set < String > ejariUnitLst = new Set < String > ();
    agreeNoAmd ='';
    if (tecomLeaseList != null && !tecomLeaseList.isEmpty() && tecomLeaseList.size()>0) {
        List<grqWsDccaGetService.Records> filteredLeaseList =grqWsDccaGetService.filterCategories(tecomLeaseList);
        for (grqWsDccaGetService.Records rc:filteredLeaseList) {
            if (rc.AgNo != null && rc.AgNo !='null' && (rc.AgNo).length()>0 && (rc.RenewalOpp == null || rc.RenewalOpp=='')) {

                string sta = String.isNotBlank(rc.ContractNumber) ? rc.Status : rc.ContractStatusReason;
                if (sta == 'Active' || sta == 'Under Termination' || sta == 'Lease Printed' || sta == 'Customer sign' || sta == 'Customer Signed' || sta == 'Tecom Sign' || sta == 'Tecom Signed' || sta == 'Ready for Activation' || sta == 'Lease Signed' || (sta.contains('Collected by BP')) || (sta.contains('Signed by BP')) || (sta.contains('Counter Signed')) || (sta.contains('Ready for Activation'))) {
                        sta = 'Active';
                    }

                    if (!(dccaStatusMap.containsKey(rc.AgNo)) || ((dccaStatusMap.containsKey(rc.AgNo)) && (!dccaStatusMap.get(rc.AgNo).contains(sta)) && !(dccaStatusMap.get(rc.AgNo).contains('true'))) || ((dccaStatusMap.containsKey(rc.AgNo)) && sta == 'Active' && (dccaStatusMap.get(rc.AgNo).contains('false')))) {
                        if (String.isNotBlank(sta) && sta == 'Active' && rc.ContractEndDate != null && (Date.valueOf(grqWsDccaGetService.formatDt2(grqWsDccaGetService.formatDt(rc.ContractEndDate))) > Date.today())) {
                            /* rc.ContractStatusReason!='Draft' && rc.ContractStatusReason!='Lease Verified' && rc.ContractStatusReason!='Printed' */
                            amedFlag = true;
                            If(String.isBlank(agreeNoAmd)) {
                                agreeNoAmd = +'*' + rc.AgNo;
                            } else {
                                agreeNoAmd = agreeNoAmd + ', ' + '*' + rc.AgNo;
                            }
                        }
                    }
                    if (!amedFlag && String.isNotBlank(rc.ContractNumber) && rc.Units != null && !rc.Units.isEmpty()) {
                        for (grqWsDccaGetService.Units u: rc.Units) {
                            ejariUnitLst.add(rc.ContractNumber + '' + u.UnitNoEnglish);

                        }
                        if (!ejariUnitLst.contains(regAddDDA)) {
                            amedFlag = true;
                        }
                }

            }
        }
    }

    for (grqWsDccaGetService.Records rc:tecomLeaseList) {
        if (!String.IsBlank(rc.ContractStartDate)) {
            rc.ContractStartDate = grqWsDccaGetService.formatDt(rc.ContractStartDate);
        }
        if (!String.IsBlank(rc.ContractEndDate)  ) {
            rc.ContractEndDate = grqWsDccaGetService.formatDt(rc.ContractEndDate);
        }
    }

    system.debug('######################tecomLeaseList#############################');

    if ((tecomLeaseList != null && tecomLeaseList.size()>0) || ACC.Legal_Framework__c == 'Freelancer') {
        system.debug('######################tecomLeaseList33#############################'+tecomLeaseList);
        //system.debug('ACC.lcedt__c'+ACC.lcedt__c);
        if (ACC.lcedt__c != null && isShwloc) {
            leaseDt=grqWsDccaGetService.getNewLicDt(tecomLeaseList, ACC.lcedt__c, Acc.Legal_Framework__c);
                                           if (leaseDt != null) {
                                               if (  rq.xcebr__c != null && rq.xcebr__c) {
                                                   Date currentLicExp=ACC.lcedt__c;
                                                   Date  newUniExpDate= Date.newInstance(Date.today().Year()+1, 03, 31);
                                                   Date  UniEpDt= Date.newInstance(Date.today().Year(), 03, 31);
                                                   Integer nays= currentLicExp.daysBetween(UniEpDt);
                                                       if (nays >= 30) {newUniExpDate=UniEpDt;}

                                                    leaseDt=newUniExpDate.year()+'-'+newUniExpDate.month()+'-'+newUniExpDate.day();
                                                  rq.xcbd__c=newUniExpDate;

                                                    }
                                               else{rq.xcbd__c=Date.parse(leaseDt);}

                                                            }
                                          // if (leaseDt != null &&  !rq.xcawp__c) {  rq.xcbd__c=Date.parse(leaseDt);}

                                          }
    }

    if (isShwloc) {rq.xdedln__c =leaseDt;}

    if (tecomLeaseList != null && tecomLeaseList.size()>0 ) if (tecomLeaseList.size()<2)tecomLeaseList[0].regOff=true;
    String agreementNo;
    if (tecomLeaseList != null && tecomLeaseList.size()>0 ) {

        for ( grqWsDccaGetService.Records ag : tecomLeaseList) {

            if (String.isBlank(agreementNo)) {agreementNo = ag.AgNo +'x'; }
            else {agreementNo =agreementNo+ ag.AgNo +'x'; }
            //}
        }
    }
    /*if (!String.isBlank(agreementNo) &&  rq.xpmsle__c)
        crmAgrList =  grqWsDccaGetService.getAgreements(agreementNo);*/
    system.debug('###################### crmAgrList#############################');
    system.debug(crmAgrList);

    List<grqWsDccaGetService.Records> d3AgrList = new List<grqWsDccaGetService.Records>();
    if (!String.isBlank(agreementNo))
        d3AgrList = grqWsDccaGetService.getD3Agreements(agreementNo);

    if (d3AgrList != null && !d3AgrList.isEmpty() && d3AgrList.size()>0) {
        crmAgrList.addAll(d3AgrList);
    }

    //Filter Out for Units
    if (crmAgrList != null && crmAgrList.size()>0) {
        for (grqWsDccaGetService.Records rec :crmAgrList) {
            List<grqWsDccaGetService.Units> allUnits= new List<grqWsDccaGetService.Units> ();
            if (rec != null && rec.Units != null && rec.Units.size()>0)
                allUnits= rec.Units;
            system.debug('JJJJJ allUnits'+allUnits);
            if (allUnits != null && allUnits.size()>0) {
                rec.Units= grqWsDccaGetService.filterCategoriesForUnits(allUnits);
            }
            system.debug('JJJJJ rec.Units'+rec.Units);
        }
    }
    if (rq.xpmsle__c && String.isNotBlank(rq.xadtx2__c)) {
        List < PMSDataWrapper.ContractInformation > ejariContractList = (List < PMSDataWrapper.ContractInformation > ) JSON.deserialize(rq.xadtx2__c,
            List < PMSDataWrapper.ContractInformation > .class);
        List < grqWsDccaGetService.Units > unitList = new List < grqWsDccaGetService.Units > ();
        for (PMSDataWrapper.ContractInformation c: ejariContractList) {
            grqWsDccaGetService.Records rec = new grqWsDccaGetService.Records();
            rec.AgNo = c.contractNumber;
            rec.ContractStartDate = c.startDate;
            rec.ContractEnddate = c.endDate;
            if (String.isNotBlank(c.ContractNumber) && c.propertyInformationList != null && !c.propertyInformationList.isEmpty()) {
                for (PMSDataWrapper.PropertyInformationList p: c.propertyInformationList) {
                    grqWsDccaGetService.Units u = new grqWsDccaGetService.Units();
                    u.UnitNoEnglish = p.unitNumber;
                    if (String.isNotBlank(p.unitNumber) && p.unitNumber.isNumeric()) {
                        u.FloorEnglish = p.unitNumber.left(1);
                    }
                    else u.FloorEnglish = '2';
                    u.BuildingName = c.buildingName.englishName;
                    u.BusinessPark = 'DIC';
                    unitList.add(u);
                }
                rec.Units = unitList;
            }
            crmAgrList.add(rec);
        }
    }

    Map<String, grqWsDccaGetService.Records > tecomLeaseListMap = new Map<String, grqWsDccaGetService.Records >();
    for ( grqWsDccaGetService.Records rec : tecomLeaseList) {
        String agrNo = (String.isNotBlank(rec.AgNo) ? rec.AgNo : rec.ContractNumber);
            tecomLeaseListMap.put(agrNo, rec);
    }

    if (crmAgrList != null && crmAgrList.size()>0) {
        for (grqWsDccaGetService.Records rec :crmAgrList) {
            // List<String> listOfAdd = new List<String>();
            system.debug('JJJJJ rec'+rec);
            List<String> listOfAdd = new List<String>();
            List<grqWsDccaGetService.Units> allUnits= new List<grqWsDccaGetService.Units> ();
            if (rec != null && rec.Units != null && rec.Units.size()>0)
                allUnits= rec.Units;
            if (allUnits != null && allUnits.size()>0) {
                for (grqWsDccaGetService.Units un : allUnits) {
                    String key = rec.AgNo+'Floor:'+un.FloorEnglish +'Building:'+ un.BuildingName+'Business Park:'+ un.BusinessPark;
                    un.UniqueKey = key;
                    un.AgNo = rec.AgNo;

                    if ( rec.AgNo != null && tecomLeaseListMap.containsKey(rec.AgNo)) {
                        un.ContractStartDate = tecomLeaseListMap.get(rec.AgNo).ContractStartDate;
                        un.ContractEnddate = tecomLeaseListMap.get(rec.AgNo).ContractEndDate;
                        system.debug('JJJJJ   un.ContractStartDate'+  un.ContractStartDate);
                        system.debug('JJJJJ   un.ContractEnddate'+  un.ContractEnddate);
                    }
                }
            }
        }
    }
    Map<String, grqWsDccaGetService.Units > ReqUnitMap = new  Map<String, grqWsDccaGetService.Units >();
    List<grqWsDccaGetService.Units> reqOffList= new List<grqWsDccaGetService.Units>();

    if (crmAgrList != null && crmAgrList.size()>0) {
        system.debug('JJJJJ  crmAgrList'+ crmAgrList);
        for (grqWsDccaGetService.Records rec :crmAgrList) {

            // List<String> listOfAdd = new List<String>();
            List<String> listOfAdd = new List<String>();
            List<grqWsDccaGetService.Units> allUnits= new List<grqWsDccaGetService.Units> ();
            //PSF
            /*List<grqWsDccaGetService.Invoices> allpaymentPSF= new List<grqWsDccaGetService.Invoices> ();
            if (rec != null && tecomLeaseListMap.containsKey(rec.AgNo)) {
                 system.debug(tecomLeaseListMap.get(rec.AgNo));
            allpaymentPSF =tecomLeaseListMap.get(rec.AgNo).Invoices;
                if (allpaymentPSF != null && allpaymentPSF.size()>0) {  system.debug('allpaymentPSF'+allpaymentPSF);

                                                                  rec.Invoices = new  List<grqWsDccaGetService.Invoices>();
                                                                   rec.Invoices.addAll(allpaymentPSF);

                                                                  }
            }*/
            //PSF
            if (rec != null && rec.Units != null && rec.Units.size()>0)
                allUnits= rec.Units;
            if (allUnits != null && allUnits.size()>0) {
                for (grqWsDccaGetService.Units un : allUnits) {
                    String newloc ='';
                    If(un.BuildingName != null || un.BusinessPark != null || un.CommercialName != null || un.FloorEnglish != null || un.UnitName != null || un.UnitNoEnglish != null) {
                        newloc = 'Premises:'+un.UnitNoEnglish+', Floor:'+ un.FloorEnglish+', Building:'+un.BuildingName+', Business Park:'+un.BusinessPark;
                    }
                    listOfAdd.add(newloc);
                    String key = rec.AgNo+'Premises:'+un.UnitNoEnglish+'Floor:'+un.FloorEnglish +'Building:'+ un.BuildingName+'Business Park:'+ un.BusinessPark;
                    un.UniqueKey = key;
                    un.AgNo = rec.AgNo;
                    //   newloc.ls_std__c = loc.ContractStartDate;
                    //newloc.ls_end__c = loc.ContractEnddate;
                    // un.ContractStartDate = rec.ContractStartDate;
                    //    un.ContractEnddate = rec.ContractEndDate;
                    //ReqUnitMap.put(key, un);
                    reqOffList.add(un);
                }
            }

            //  if (rec.ContractEndDate != null &&  (Date.valueOf(grqWsDccaGetService.formatDt2(rec.ContractEndDate))> Date.today())) {
            newmapLoc.put(rec.AgNo, listOfAdd);

            // }

            // newmapLoc.put(rec.AgNo, listOfAdd);
        }
    }

    if (crmAgrList != null) {
        grqWsDccaGetService.ResponseData newResp = new grqWsDccaGetService.ResponseData();
        List< grqWsDccaGetService.Records> newRec = new List<grqWsDccaGetService.Records>();
        newResp.Records =crmAgrList;

        //newRec.Units =reqOffList;
        //if (isShwloc) {
            //  rq.xadtx3__c = String.ValueOf(crmAgrList);
            rq.xadtx3__c = JSON.serialize(newResp);
      //  }

    }
    //New Map
    map<String, string> mergeLocMap = new map<String, string>();
    if (crmAgrList != null && crmAgrList.size() > 0) {
        for (grqWsDccaGetService.Records rec: crmAgrList) {
            Set<String> adhocList = new  Set<String>();
            List < String > listOfAdd = new List < String > ();
            List < grqWsDccaGetService.Units > allUnits = new List < grqWsDccaGetService.Units > ();
            if (rec != null && rec.Units != null && rec.Units.size() > 0) allUnits = rec.Units;
            if (allUnits != null && allUnits.size() > 0) {
                for (grqWsDccaGetService.Units loc: allUnits) {
                    if (loc.BuildingName != null && loc.FloorEnglish != null && loc.BusinessPark != null) {
                        string mergeOffNo;
                        string Key = loc.FloorEnglish + loc.BuildingName + loc.BusinessPark;
                        adhocList.add(Key);
                        system.debug('Key' + Key);
                        if (agreeLocMap2.containsKey(Key)) {
                            String fullloc = agreeLocMap2.get(Key);
                            system.debug('fullloc' + fullloc);
                            map < String, String > splitMap = new map < String, String > ();
                            String[] spltFullLoc = fullloc.split(', ');
                            for (String st: spltFullLoc) {
                                String[] splt2FullLoc2 = st.split(':');
                                system.debug('splt2FullLoc2' + splt2FullLoc2);
                                if (splt2FullLoc2 != null && splt2FullLoc2.size() > 1) splitMap.put(splt2FullLoc2[0], splt2FullLoc2[1]);
                            }
                            system.debug('splitMap' + splitMap);
                            if (splitMap != null && splitMap.containsKey('Premises')) {
                                mergeOffNo = splitMap.get('Premises');
                                String locoff = loc.UnitNoEnglish;
                                if (!mergeOffNo.contains(locoff)) {
                                    mergeOffNo = mergeOffNo + '/' + locoff;
                                }
                            }
                            system.debug('mergeOffNo' + mergeOffNo);
                            If(mergeOffNo != null)  mergeOffNo = grqWsDccaGetService.sortPermises(mergeOffNo, '/');
                            system.debug('*********mergeOffNo********' + mergeOffNo);
                            String newLoc = 'Premises:' + mergeOffNo + ', Floor:' + loc.FloorEnglish + ', Building:' + loc.BuildingName + ', Business Park:' + loc.BusinessPark;
                            agreeLocMap2.put(Key, newLoc);
                        }
                        else {
                            String locFull = 'Premises:' + loc.UnitNoEnglish + ', Floor:' + loc.FloorEnglish + ', Building:' + loc.BuildingName + ', Business Park:' + loc.BusinessPark;
                            agreeLocMap2.put(Key, locFull);
                            system.debug('FIRST agreeLocMap2' + agreeLocMap2);
                        }
                    }
                }
            }
            List<String> lst = new  List<String>();
            for (String ag: agreeLocMap2.keyset()) {
                String stringVal= agreeLocMap2.get(ag);
                mergeLocMap.put(ag, stringVal);
                system.debug('******stringVal******'+stringVal);
                stringVal = stringVal.replace( '/' , ', ' );
                agreeLocMap2.put(ag, stringVal);
                /*  lst.add(stringVal);
            */ }
            for (String st : adhocList) {
                If(agreeLocMap2.containsKey(st)) {
                    lst.add(agreeLocMap2.get(st));
                }
            }
            /* finalAgreeLoc.put(rec.AgNo, lst);
            */ if (lst != null && lst.size()>0) finalAgreeLoc.put(rec.AgNo, lst);
        }
    }
    // To recome Agrement which dont have units after filter
    //

    List<grqWsDccaGetService.Records> newtecomLeaseList= new  List<grqWsDccaGetService.Records>();
    if (tecomLeaseList != null && tecomLeaseList.size()>0 ) {
        for ( grqWsDccaGetService.Records ag : tecomLeaseList) {
            if (finalAgreeLoc.containsKey(ag.AgNo)) {
                newtecomLeaseList.add(ag);
            }
        }
        if (newtecomLeaseList != null && !newtecomLeaseList.isEmpty()) {
            tecomLeaseList.clear();
            tecomLeaseList.addAll(newtecomLeaseList);
        }
    }

    //EndMap
    //
    //
    map<String, List <grqWsDccaGetService.Units >> argUnitMap = new map<String, List <grqWsDccaGetService.Units >>();

    if (crmAgrList != null && crmAgrList.size() > 0) {
        for (grqWsDccaGetService.Records rec: crmAgrList) {

            List < grqWsDccaGetService.Units > allUnits = new List < grqWsDccaGetService.Units > ();
            if (rec != null && rec.Units != null && rec.Units.size() > 0)
                allUnits = rec.Units;
            system.debug('JJJJ allUnits'+allUnits);
            if (allUnits != null && allUnits.size() > 0) {
                for (grqWsDccaGetService.Units un: allUnits) {
                    if (argUnitMap.containsKey(rec.AgNo)) { List <grqWsDccaGetService.Units > allnewunits = new List <grqWsDccaGetService.Units >();
                        allnewunits  = argUnitMap.get(rec.AgNo);allnewunits.add(un);argUnitMap.put(rec.AgNo, allnewunits);
                    }else{
                        argUnitMap.put(rec.AgNo, new List<grqWsDccaGetService.Units>{un});

                    }

                }
            }

        }
    }
    if (argUnitMap != null)
        argUnitMap =grqWsDccaGetService.remapUnitsAgr(argUnitMap);

    grqWsDccaGetService.ActivityLocations finaljson = new grqWsDccaGetService.ActivityLocations();
    List<grqWsDccaGetService.Locations> reqLoc = new  List<grqWsDccaGetService.Locations>();
    Map<String, grqWsDccaGetService.Records > getFinaltecomLeaseList= new Map<String, grqWsDccaGetService.Records >();
    for ( grqWsDccaGetService.Records rec : tecomLeaseList) {
        getFinaltecomLeaseList.put(rec.AgNo, rec);
    }
    system.debug('******getFinaltecomLeaseList***'+getFinaltecomLeaseList);

    Set<String> uniqKey = new Set<String>();

    for (string str: argUnitMap.Keyset()) {
        grqWsDccaGetService.Records rec = new grqWsDccaGetService.Records();
        List < grqWsDccaGetService.Units > allUnits = new List < grqWsDccaGetService.Units > ();
        if (getFinaltecomLeaseList.containsKey(str)) {
            rec = getFinaltecomLeaseList.get(str);
            allUnits = argUnitMap.get(rec.AgNo);
            system.debug('******rec.AgNo******'+rec.AgNo);
            system.debug('******allUnits******'+allUnits);
            for (grqWsDccaGetService.Units un: allUnits) {
                system.debug('******un******'+un);
                string Key =  un.FloorEnglish + un.BuildingName+ un.BusinessPark;
                system.debug('**********uniqKey*******'+uniqKey);
                uniqKey.add(key);
                grqWsDccaGetService.Locations loc= new grqWsDccaGetService.Locations();
                loc.isRegoff = false ;
                loc.AgreementNo = rec.AgNo;
                if (loc.ContractStartDate != null) loc.ContractStartDate = Date.valueOf(grqWsDccaGetService.formatDt2(rec.ContractStartDate));
                if (loc.ContractEnddate != null) loc.ContractEnddate = Date.valueOf(grqWsDccaGetService.formatDt2(rec.ContractEndDate));
                loc.ContractStatusReason= rec.ContractStatusReason;
                loc.Status = rec.ContractStatus;
                if (un != null ) {
                    loc.OfficeNo = un.UnitNoEnglish;
                    loc.BuildingName = un.BuildingName;
                    loc.Floor = un.FloorEnglish;
                    loc.BusinessPark = un.BusinessPark;
                    loc.ArabicOfficeNo = un.UnitNoArabic;
                    loc.ArabicFloor = un.FloorArabic;
                    loc.ArabicBuildingName = un.BuildingNameArabic;
                    loc.AgreementNo = rec.AgNo;
                }
                reqLoc.add(loc);
                system.debug('******reqLoc******'+reqLoc);
            /*  }
        */ }
    }
    }

    String jsonBody ;
    if (reqLoc != null && reqLoc.size()>0 ) {
        finaljson.locationList = reqLoc;
        jsonBody = JSON.serialize(finaljson);
        system.debug('******jsonBody******'+jsonBody);
        /*if (isShwloc) {rq.xadtx2__c =jsonBody;}*/
    }

    String x='n/a;';
    for (String key : newmapLoc.keySet()) {
        if (newmapLoc.containsKey(key)) {
            List<String> values = newmapLoc.get(key);
            String add;

            If(values != null  && values.size()>0 )
                add=values.get(0);

            if ( String.isNotBlank(add) && x.contains(add)) { system.debug('******key******'+key); newmapLoc.remove(key);
            }else{
                x=x+add+';';
                system.debug('******xxx******'+x);
            }

        }
    }

    //newmapLoc.values()
    if (regOfficeDcca != null && !String.ISBLANK(regOfficeDcca)) {
        string[] spltreg ;
        spltreg = regOfficeDcca.split(';');

        if (spltreg != null && newmapLoc.containsKey(spltreg[0])) {

            List<string> lstOff ;
            lstOff = newmapLoc.get(spltreg[0]);

            for (string st : lstOff) {if (st.contains(spltreg[1])) { newRegOffDcca = spltreg[0]+';'+st; }}
        }

    }

     }

}
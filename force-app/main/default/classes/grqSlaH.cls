public class grqSlaH {
    private static final String STAGE_DELIMITER = '[;]{1}[\\s]?'; // for semi colon
    private  static final String BUSINESS_HOUR_NAME = 'BH';
    private  Boolean checkMilestone = false;
    private static Integer toDay=28800000;
    private static Integer toHour=3600000;
    private  static Decimal threshold=0;
    //create milestone
    public static void crtMlstn(List<g_Req__c> lstRq, map<Id, g_Srvc__c> mSrvc) {
        List<g_Milestone__c> lstMst = new List<g_Milestone__c>();
        Integer idx = 0;
        try{
            for (g_Req__c req : lstRq) {
                if (String.isBlank(req.mstStg__c)) break;
                List<String> lstStg = mSrvc.get(req.srvc__c).Milestone_Stage__c.split(STAGE_DELIMITER);
                List<String> lstSla = mSrvc.get(req.srvc__c).Milestone_SLA__c.split(STAGE_DELIMITER);
                 List<String> lstExpSla = mSrvc.get(req.srvc__c).ExpMilestone_SLA__c.split(STAGE_DELIMITER);
                idx = 0;
                for (String stageName : lstStg) {
                     List<String> stageNmLst = stageName.split(':');
                    lstMst.add(new g_Milestone__c(Request__c = req.Id, Status__c='Draft',
                        Total_Duration__c=0, Name__c = stageNmLst[0], mdesc__c=stageNmLst[1],
                        ExpSLA__c = Integer.valueOf(lstExpSla[idx]), SLA__c = Integer.valueOf(lstSla[idx])));
                    idx=idx+1;
                }
            }
            Database.insert(lstMst);
            idx=0;
            List<g_Milestone__c> updateMst = new List<g_Milestone__c>();
            while (lstMst != null && idx<lstMst.size()-1) {
                if (lstMst.get(idx+1).Request__c == lstMst.get(idx).Request__c) {
                    lstMst.get(idx+1).pmstone__c=lstMst.get(idx).id;
                    updateMst.add(lstMst.get(idx+1));
                }
                idx++;
            }
            Database.update(updateMst);
        }catch (Exception e) {system.debug(e.getStackTraceString());}
    }
    public static void prepItms(list<g_reqitem__c> news, map<Id, g_reqitem__c>olds, map<Id, g_srvcitm_Status__c>mSTA) {
            System.debug('#####sac'+gStg__c.getValues('slaExpiry'));
            threshold = gStg__c.getValues('slaExpiry').Number_Value__c;
            BusinessHours mBH;
            if (mBH == null) { //making sure we SOQL is not done more than once
                mBH = [SELECT Id FROM BusinessHours WHERE id= :gU.csStr('BH')];
            }

            Map<String, String> itmCds = new Map<String, String>();
            Map<String, String> statusSlaMap = new Map<string, String>();
            Map<String, String> requestStatusTypeMap = new Map<String, String>();
            System.debug('%%%mSTA = '+mSTA);
            for (g_reqitem__c i: news) {
                if (olds != NULL && olds.containsKey(i.Id)) {
                    g_reqitem__c o = olds.get(i.Id);
                    if (mSTA.containsKey(i.sta__c)) {
                        g_srvcitm_Status__c nSTA = mSTA.get(i.sta__c);
                        requestStatusTypeMap.put(i.Id, nSTA.Tp__c);
                        if (o.sta__c != i.sta__c) {
                            if ((nSTA.Shift_At__c=='Immediate') && !String.isBlank(nSTA.Shift_Items__c)) {
                                splitShiftItems(nSTA.Shift_Items__c, i, statusSlaMap, itmCds, null);
                            }
                        }
                    }
                }
            }
            System.debug('%#%#itmCds'+itmCds);
            System.debug('sadsf***'+requestStatusTypeMap);
            List<g_reqitem__c> itemsToShift = new List<g_reqitem__c>();
            for (g_reqitem__c i: news) {
                g_srvcitm_Status__c nSTA = mSTA.get(i.sta__c);
                Boolean isExp = i.exp__c;
                if (olds == null) {
                    //set item dates
                    i.dtic__c = Datetime.now();
                    setItemDates(i, mBH.Id);
                    i.xcsla__c=mSTA.get(i.sta__c).Exclude_SLA__c;
                    //set status dates
                    setStatusDates(i, isExp, mBH.Id, threshold, nSTA.slaN__c, nSTA.slaXP__c);
                }else{ //change the status dates if status is changed on item
                    if (olds.get(i.Id).sta__c != i.sta__c) {
                        i.dtsc__c = Datetime.now();
                        setStatusDates(i, isExp, mBH.Id, threshold, nSTA.slaN__c, nSTA.slaXP__c);
                           i.xcsla__c=mSTA.get(i.sta__c).Exclude_SLA__c;
                    }
                }
                //if item is completed or cancelled or rejected
                if (nSTA.Tp__c!='Open') {
                    if (i.dtic__c == null) {
                        i.dtic__c = Datetime.now();
                        i.xcsla__c=mSTA.get(i.sta__c).Exclude_SLA__c;
                    }
                    if (i.dtiacls__c == null) {
                        i.dtiacls__c=Datetime.now();
                        i.xitdur__c = ((Double)BusinessHours.diff(mBH.Id, i.dtic__c, i.dtiacls__c))/toHour;
                    }// Calculate Item duration in days.
                } else{i.dtiacls__c=null;}

                if (itmCds.containsKey(i.RQ__c+i.itmCd__c)) {
                    itemsToShift.add(i);
                }
                i.nm__c = nSTA.nm__c;
                i.STAtp__c = nSTA.Tp__c;
            }
            System.debug('%%%%%itemsToShift%%%'+itemsToShift);
            if (itemsToShift.size()>0)
                shiftItems(itemsToShift, false, mBH.Id, statusSlaMap, mSTA);

    }

    private static void setStatusDates(g_reqitem__c i, Boolean isExp, Id businessHoursId, Decimal thresholdVal, Decimal statusSlaNr, Decimal statusSlaEx) {
        Decimal exOrNrDate = isExp?statusSlaEx:statusSlaNr;
        i.dtsecls__c = BusinessHours.add(businessHoursId, i.dtsc__c, toHour* ((Long)(exOrNrDate)));
        i.xsed__c = ((Double)BusinessHours.diff(businessHoursId, i.dtsc__c , i.dtsecls__c))/toHour;
        i.dtseln__c =  BusinessHours.add(businessHoursId, i.dtsc__c, toHour * ((Long)(statusSlaNr*thresholdVal)/100));
        i.dtselx__c =  BusinessHours.add(businessHoursId, i.dtsc__c, toHour * ((Long)(statusSlaEx*thresholdVal)/100));
    }

    private static void setItemDates(g_reqitem__c i, Id businessHoursId) {
        i.dtieclsx__c = BusinessHours.add(businessHoursId, i.dtic__c, (Long)i.islax__c*toHour);
        i.dtieclsn__c = BusinessHours.add(businessHoursId, i.dtic__c, (Long)i.islan__c*toHour);
        i.xited__c = ((Double)BusinessHours.diff(businessHoursId, i.dtic__c, (i.exp__c?i.dtieclsx__c:i.dtieclsn__c)))/toDay;
    }

    //By Sachin Kadian
    //09/05/2016
    //To split the shift items and add to map or list
    public static void splitShiftItems(String itemsToSplit, g_reqitem__c item, Map<string, String> statusSlaMap, Map<String, String> itmCds, Set<String> itmCodesToShift) {
        //nSTA.Shift_Items__c.split(';')
        for (String shiftItemsCode : itemsToSplit.split(';')) {
            if (shiftItemsCode != NULL && shiftItemsCode != '') {
                List<String> shiftItemsCodeSplit = shiftItemsCode.split('-');
                String key = '';
                String val = 'I';
                if (shiftItemsCodeSplit != null && shiftItemsCodeSplit.size()>0) {
                    key = shiftItemsCodeSplit[0];
                    if (shiftItemsCodeSplit.size()>1)
                        val = shiftItemsCodeSplit[1];
                }
                statusSlaMap.put(item.RQ__c+key, val);
                if (itmCds != NULL)
                    itmCds.put(item.RQ__c+key, key);
                if (itmCodesToShift != NULL)
                    itmCodesToShift.add(key);
            }
        }
    }

    //By Sachin Kadian
    //05/04/2016
    //To shift the items
    public static void shiftItems(List<g_reqitem__c> itemsToShift, Boolean doUpdate, Id businessHourId, Map<String, String> statusSlaMap, map<Id, g_srvcitm_Status__c> statusMap) {
        threshold = gStg__c.getValues('slaExpiry').Number_Value__c;
        for (g_reqitem__c item : itemsToShift) {
            System.debug('$$$$shifting'+item.itmCd__c);
            System.debug('$$$$item'+item);
            String statusType;
            Decimal statusSlaNr, statusSlaEx;
            if (statusMap != NULL) {
                statusType = statusMap.get(item.sta__c).TP__c;
                statusSlaNr = statusMap.get(item.sta__c).slaN__c;
                statusSlaEx = statusMap.get(item.sta__c).slaXP__c;
            }else{
                statusType = item.sta__r.Tp__c;
                statusSlaNr = item.sta__r.slaN__c;
                statusSlaEx = item.sta__r.slaXP__c;
            }
            Boolean isExp = item.exp__c;
            if (statusType == 'Open') {
                System.debug('$$$$shifting'+item.itmCd__c);
                DateTime timeToShift = System.now();
                if (item.dtic__c == item.dtsc__c) {
                    item.dtic__c = System.now();
                }
                item.dtsc__c = System.now();
                setItemDates(item, businessHourId);
                setStatusDates(item, isExp, businessHourId, threshold, statusSlaNr, statusSlaEx);
                if (statusSlaMap != NULL && statusSlaMap.containsKey(item.RQ__c+item.itmCd__c)) {
                    String slaStatusToSet = statusSlaMap.get(item.RQ__c+item.itmCd__c);
                    if (slaStatusToSet == 'T')
                        item.xcsla__c = true;
                    else if (slaStatusToSet == 'F')
                        item.xcsla__c = false;
                }
            }
        }
        if (doUpdate)
            if (Schema.sObjectType.g_reqitem__c.isUpdateable()) {
                update itemsToShift;
            }
    }
}
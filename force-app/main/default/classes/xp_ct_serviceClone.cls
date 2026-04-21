public with sharing class xp_ct_serviceClone {
 public String serviceID {
     get;
     set;
 }
 public String newServiceName {
     get;
     set;
 }
 public String serviceType {
     get;
     set;
 }
 public g_Srvc__c newserviceObj {
     get;
     set;
 }
 public List < g_Srvc__c > serviceList {
     get;
     set;
 }
 public List < SelectOption > selectServiceType {
     get;
     set;
 }
 public List < SelectOption > selectServList {
     get;
     set;
 }
 public String serviceItemId {
     get;
     set;
 }
 public String oldServCode {
     get;
     set;
 }
 public String uniqServCode {
     get;
     set;
 }
 public String newItemUniqCode {
     get;
     set;
 }
 public String newItemName {
     get;
     set;
 }
 public List < g_srvcitm_Doc__c > doclist {
     get;
     set;
 }
 public List < g_srvcitm_Status__c > itemstatusList {
     set;
     get;
 }
 public List < g_srvcitm__c > serItemEntries {
     set;
     get;
 }
 public String newSrvcId = '';
 public xp_ct_serviceClone() {
     init();
 }
 public void init() {
     serviceList = [select id, name, uid__c from g_Srvc__c Order by name Asc];
     selectServList = getServList();
     itemstatusList = new List < g_srvcitm_Status__c > ();
     doclist = new List < g_srvcitm_Doc__c > ();
     serItemEntries = new List < g_srvcitm__c > ();
 }
 public List < SelectOption > getServList() {
     List < SelectOption > options = new List < SelectOption > ();
     SelectOption option1 = new SelectOption('-1', '--Select Service--');
     options.add(option1);
     for (Integer i = 0;
     i < serviceList.size();
     i++) {
         SelectOption option = new SelectOption(serviceList[i].id, serviceList[i].Name + '=>' + serviceList[i].uid__c);
         options.add(option);
     }
     return options;
 }
 public void refreshService() {
     try {
         List < g_Srvc__c > srvLst = [select id, uid__c, (select id, uid__c from Items__r) from g_Srvc__c where uid__c =: oldServCode];
         if (srvLst != null && !srvLst.isEmpty()) {
             srvLst[0].uid__c = uniqServCode;
             List < g_srvcitm_Status__c > stslst = [select id, uid__c from g_srvcitm_Status__c where itm__r.srvc__c =: srvLst[0].id];
             List < g_srvcitm__c > itmLst = srvLst[0].Items__r;
             for (g_srvcitm__c itm: itmLst) {
                 itm.uid__c = '';
             }
             for (g_srvcitm_Status__c sts: stslst) { sts.uid__c = ''; }
             if (Schema.sObjectType.g_Srvc__c.isUpdateable()) {
                 update srvLst;
             }
             if (Schema.sObjectType.g_srvcitm__c.isUpdateable()) {
                 update itmLst;
             }
             if (Schema.sObjectType.g_srvcitm_Status__c.isUpdateable()) {
                 update stslst;
             }
         }
     }
     catch (Exception ex) {
         system.debug('ex::' + ex.getStackTraceString());
     }
 }
 public void cloneService() {
     try {
         /*Code to fetch all fields of the object dynamically */ List < g_Srvc__c > srvcList;
         String queryStr = fetchFields('g_Srvc__c', ' where Id =: serviceID limit 1');
         if (String.isNotBlank(queryStr)) {
             srvcList = Database.query(queryStr);
         }
         System.debug('====srvcList===' + srvcList);
         /* End */ if (srvcList != null && !srvcList.isEmpty()) {
             newserviceObj = srvcList[0].clone(false, true, false, false);
             if (newserviceObj != null) {
                 newserviceObj.Name = newServiceName;
                 newserviceObj.uid__c = uniqServCode;
                 newserviceObj.Old_Sf_Id__c = '';
                 newserviceObj.actv__c = false;
                 if (Schema.sObjectType.ws_call__c.isCreateable()) {
                     upsert newserviceObj;
                 }
             }
             newSrvcId = newserviceObj.Id;
             cloneServiceItem(srvcList[0], newserviceObj);
         }
     }
     catch (Exception e) {
         System.debug('====Exception====' + e);
         gU.AddErrorMsg(e);
     }
 }
 public void cloneServiceItem(g_Srvc__c serviceObj, g_Srvc__c newserviceObj) {
     /* Code to fetch all fields of the object dynamically */ List < g_srvcitm__c > serviceItemEntries;
     String srvcId = serviceObj.id;
     String queryStr = fetchFields('g_srvcitm__c', ' where srvc__c =: srvcId');
     if (String.isNotBlank(queryStr)) {
         serviceItemEntries = Database.query(queryStr);
     }
     System.debug('====serviceItemEntrie===' + serviceItemEntries);
     /* End */ try {
         g_srvcitm__c orgObj = null;
         g_srvcitm__c cloneObj = null;
         List < g_srvcitm__c > clonedSrItems = null;
         if (serviceItemEntries != null && !serviceItemEntries.isEmpty()) {
             clonedSrItems = new List < g_srvcitm__c > ();
             for (g_srvcitm__c serviceItemEntry: serviceItemEntries) {
                 orgObj = serviceItemEntry;
                 cloneObj = orgObj.clone(false, true, false, false);
                 cloneObj.srvc__c = newserviceObj.Id;
                 cloneObj.uid__c = uniqServCode + cloneObj.cd__c;
                 cloneObj.Old_Sf_Id__c = '';
                 clonedSrItems.add(cloneObj);
             }
             if (Schema.sObjectType.g_srvcitm__c.isCreateable()) {
                 upsert clonedSrItems;
             }
             Integer index = 0;
             Map < id, g_srvcitm__c > orgItemNewItmMap = new Map < id, g_srvcitm__c > ();
             Map < id, g_srvcitm__c > orgItemMap = new Map < id, g_srvcitm__c > ();
             for (g_srvcitm__c orgItm: serviceItemEntries) {
                 g_srvcitm__c newItm = clonedSrItems.get(index);
                 orgItemNewItmMap.put(orgItm.id, newItm);
                 orgItemMap.put(orgItm.id, orgItm);
                 cloneItemRequiredDocs(orgItm, newItm);
                 index++;
             }
             cloneItemStatus1(orgItemNewItmMap, orgItemMap);
         }
     }
     catch (Exception e) {
         System.debug('====Exception====' + e);
         gU.AddErrorMsg(e);
     }
 }
 public void cloneServiceItemByID() {
     /* Code to fetch all fields of the object dynamically */ List < g_srvcitm__c > serviceItemEntries;
     String queryStr = fetchFields('g_srvcitm__c', ' where Id =: serviceItemId limit 1');
     if (String.isNotBlank(queryStr)) {
         serviceItemEntries = Database.query(queryStr);
     }
     System.debug('====serviceItemEntrie===' + serviceItemEntries);
     /* End */ g_srvcitm__c orgObj = null;
     g_srvcitm__c cloneObj = null;
     List < g_srvcitm__c > clonedSrItems = null;
     if (serviceItemEntries != null && !serviceItemEntries.isEmpty()) {
         clonedSrItems = new List < g_srvcitm__c > ();
         for (g_srvcitm__c serviceItemEntry: serviceItemEntries) {
             orgObj = serviceItemEntry;
             cloneObj = orgObj.clone(false, true, false, false);
             cloneObj.srvc__c = serviceID;
             cloneObj.uid__c = uniqServCode + cloneObj.cd__c;
             cloneObj.cd__c = uniqServCode + cloneObj.cd__c;
             clonedSrItems.add(cloneObj);
         }
         if (Schema.sObjectType.g_srvcitm__c.isCreateable()) {
             upsert clonedSrItems;
         }
         Integer index = 0;
         Map < id, g_srvcitm__c > orgItemNewItmMap = new Map < id, g_srvcitm__c > ();
         Map < id, g_srvcitm__c > orgItemMap = new Map < id, g_srvcitm__c > ();
         for (g_srvcitm__c orgItm: serviceItemEntries) {
             g_srvcitm__c newItm = clonedSrItems.get(index);
             orgItemNewItmMap.put(orgItm.id, newItm);
             orgItemMap.put(orgItm.id, orgItm);
             cloneItemRequiredDocs(orgItm, newItm);
             index++;
         }
         cloneItemStatus1(orgItemNewItmMap, orgItemMap);
     }
 }
 public void cloneItemByIDSameSer() {
     /* Code to fetch all fields of the object dynamically */ List < g_srvcitm__c > serviceItemEntries;
     String queryStr = fetchFields('g_srvcitm__c', ' where Id =: serviceItemId limit 1');
     if (String.isNotBlank(queryStr)) {
         serviceItemEntries = Database.query(queryStr);
     }
     System.debug('====serviceItemEntrie===' + serviceItemEntries);
     /* End */ g_srvcitm__c orgObj = null;
     g_srvcitm__c cloneObj = null;
     List < g_srvcitm__c > clonedSrItems = null;
     if (serviceItemEntries != null && !serviceItemEntries.isEmpty()) {
         clonedSrItems = new List < g_srvcitm__c > ();
         for (g_srvcitm__c serviceItemEntry: serviceItemEntries) {
             orgObj = serviceItemEntry;
             cloneObj = orgObj.clone(false, true, false, false);
             cloneObj.srvc__c = serviceID;
             cloneObj.Name = newItemName;
             cloneObj.lbl__c = newItemName;
             cloneObj.uid__c = uniqServCode + newItemUniqCode;
             cloneObj.cd__c = uniqServCode + newItemUniqCode;
             clonedSrItems.add(cloneObj);
         }
         if (Schema.sObjectType.g_srvcitm__c.isCreateable()) {
             upsert clonedSrItems;
         }
         Map < id, g_srvcitm__c > orgItemNewItmMap = new Map < id, g_srvcitm__c > ();
         Map < id, g_srvcitm__c > orgItemMap = new Map < id, g_srvcitm__c > ();
         Integer index = 0;
         for (g_srvcitm__c orgItm: serviceItemEntries) {
             g_srvcitm__c newItm = clonedSrItems.get(index);
             orgItemNewItmMap.put(orgItm.id, newItm);
             orgItemMap.put(orgItm.id, orgItm);
             cloneItemRequiredDocs(orgItm, newItm);
             index++;
         }
         cloneItemStatus1(orgItemNewItmMap, orgItemMap);
         cloneItemRequiredDocs1(orgItemNewItmMap);
     }
 }
 public void cloneItemStatus1(Map < Id, g_srvcitm__c > orgItemNewItmMap, Map < id, g_srvcitm__c > orgItemMap) {
     try {
         /* Code to fetch all fields of the object dynamically */ List < g_srvcitm_Status__c > orgSrItmStatuses;
         Set < Id > orgobjId = orgItemNewItmMap.keySet();
         String queryStr = fetchFields('g_srvcitm_Status__c', ' where itm__c IN: orgobjId');
         if (String.isNotBlank(queryStr)) {
             orgSrItmStatuses = Database.query(queryStr);
         }
         System.debug('====orgSrItmStatuses===' + orgSrItmStatuses);
         /* End */ List < g_srvcitm_Status__c > clonedsrItmStatuses = null;
         if (orgSrItmStatuses != null && !orgSrItmStatuses.isEmpty()) {
             clonedsrItmStatuses = new List < g_srvcitm_Status__c > ();
             for (g_srvcitm_Status__c srItmStatus: orgSrItmStatuses) {
                 g_srvcitm_Status__c orgsrItmStatus = srItmStatus;
                 g_srvcitm_Status__c cloneObj = orgsrItmStatus.clone(false, true, false, false);
                 cloneObj.itm__c = orgItemNewItmMap.get(srItmStatus.itm__c).Id;
                 cloneObj.uid__c = uniqServCode + orgItemMap.get(srItmStatus.itm__c).cd__c + cloneObj.cd__c;
                 clonedsrItmStatuses.add(cloneObj);
             }
             if (Schema.sObjectType.g_srvcitm_Status__c.isCreateable()) {
                 upsert clonedsrItmStatuses;
             }
             Integer index = 0;
             /* List<Notification_Status__c> notifListToUpdate = new List<Notification_Status__c>();
             */ Map < id, g_srvcitm_Status__c > orgItmNewItmMap = new Map < id, g_srvcitm_Status__c > ();
             for (g_srvcitm_Status__c orgItm: orgSrItmStatuses) {
                 g_srvcitm_Status__c newItm = clonedsrItmStatuses.get(index);
                 orgItmNewItmMap.put(orgItm.id, newItm);
                 index++;
             }
             /* upsert notifListToUpdate;
             */ cloneNotificationStngs(orgItmNewItmMap);
         }
     }
     catch (Exception e) {
         System.debug('====Exception====' + e);
         gU.AddErrorMsg(e);
     }
 }
 public void cloneItemStatus(g_srvcitm__c orgObj, g_srvcitm__c newObj) {
     try {
         /* Code to fetch all fields of the object dynamically */ List < g_srvcitm_Status__c > orgSrItmStatuses;
         String orgobjId = orgObj.id;
         String queryStr = fetchFields('g_srvcitm_Status__c', ' where itm__c =: orgobjId');
         if (String.isNotBlank(queryStr)) {
             orgSrItmStatuses = Database.query(queryStr);
         }
         System.debug('====orgSrItmStatuses===' + orgSrItmStatuses);
         /* End */ g_srvcitm_Status__c orgsrItmStatus = null;
         g_srvcitm_Status__c cloneObj = null;
         List < g_srvcitm_Status__c > clonedsrItmStatuses = null;
         if (orgSrItmStatuses != null && !orgSrItmStatuses.isEmpty()) {
             clonedsrItmStatuses = new List < g_srvcitm_Status__c > ();
             for (g_srvcitm_Status__c srItmStatus: orgSrItmStatuses) {
                 orgsrItmStatus = srItmStatus;
                 cloneObj = orgsrItmStatus.clone(false, true, false, false);
                 cloneObj.itm__c = newObj.Id;
                 cloneObj.uid__c = uniqServCode + orgObj.cd__c + cloneObj.cd__c;
                 clonedsrItmStatuses.add(cloneObj);
             }
             if (Schema.sObjectType.g_srvcitm_Status__c.isCreateable()) {
                 upsert clonedsrItmStatuses;
             }
             Integer index = 0;
             /* List<Notification_Status__c> notifListToUpdate = new List<Notification_Status__c>();
             */ Map < id, g_srvcitm_Status__c > orgItemNewItmMap = new Map < id, g_srvcitm_Status__c > ();
             for (g_srvcitm_Status__c orgItm: orgSrItmStatuses) {
                 g_srvcitm_Status__c newItm = clonedsrItmStatuses.get(index);
                 orgItemNewItmMap.put(orgItm.id, newItm);
                 index++;
             }
             /* upsert notifListToUpdate;
             */ cloneNotificationStngs(orgItemNewItmMap);
         }
     }
     catch (Exception e) {
         System.debug('====Exception====' + e);
         gU.AddErrorMsg(e);
     }
 }
 public void cloneItemRequiredDocs1(Map < Id, g_srvcitm__c > orgItemNewItmMap) {
     try {
         /* Code to fetch all fields of the object dynamically */ List < g_srvcitm_Doc__c > itmRdlist;
         Set < Id > orgobjId = orgItemNewItmMap.keySet();
         String queryStr = fetchFields('g_srvcitm_Doc__c', ' where itm__c IN: orgobjId');
         if (String.isNotBlank(queryStr)) {
             itmRdlist = Database.query(queryStr);
         }
         System.debug('====itmRdlist===' + itmRdlist);
         /* End */ List < g_srvcitm_Doc__c > clonedsrItmRd = null;
         if (itmRdlist != null) {
             clonedsrItmRd = new List < g_srvcitm_Doc__c > ();
             for (g_srvcitm_Doc__c stItmRd: itmRdlist) {
                 g_srvcitm_Doc__c orgItmRd = stItmRd;
                 g_srvcitm_Doc__c cloneObj = orgItmRd.clone(false, true, false, false);
                 cloneObj.itm__c = orgItemNewItmMap.get(stItmRd.itm__c).Id;
                 clonedsrItmRd.add(cloneObj);
             }
             if (Schema.sObjectType.g_srvcitm_Doc__c.isCreateable()) {
                 upsert clonedsrItmRd;
             }
         }
     }
     catch (Exception e) {
         System.debug('====Exception====' + e);
         gU.AddErrorMsg(e);
     }
 }
 public void cloneItemRequiredDocs(g_srvcitm__c orgObj, g_srvcitm__c newObj) {
     try {
         /* Code to fetch all fields of the object dynamically */ List < g_srvcitm_Doc__c > itmRdlist;
         String orgobjId = orgObj.id;
         String queryStr = fetchFields('g_srvcitm_Doc__c', ' where itm__c =: orgobjId');
         if (String.isNotBlank(queryStr)) {
             itmRdlist = Database.query(queryStr);
         }
         System.debug('====itmRdlist===' + itmRdlist);
         /* End */ g_srvcitm_Doc__c orgItmRd = null;
         g_srvcitm_Doc__c cloneObj = null;
         List < g_srvcitm_Doc__c > clonedsrItmRd = null;
         if (itmRdlist != null) {
             clonedsrItmRd = new List < g_srvcitm_Doc__c > ();
             for (g_srvcitm_Doc__c stItmRd: itmRdlist) {
                 orgItmRd = stItmRd;
                 cloneObj = orgItmRd.clone(false, true, false, false);
                 cloneObj.itm__c = newObj.Id;
                 clonedsrItmRd.add(cloneObj);
             }
             if (Schema.sObjectType.g_srvcitm_Doc__c.isCreateable()) {
                 upsert clonedsrItmRd;
             }
         }
     }
     catch (Exception e) {
         System.debug('====Exception====' + e);
         gU.AddErrorMsg(e);
     }
 }
 public void cloneNotificationStngs(Map < Id, g_srvcitm_Status__c > orgObjNewObjMap) {
     try {
         List < Notification_Status__c > notifList;
         List < Notification_Status__c > notifListUpsert = new List < Notification_Status__c > ();
         Set < Id > OrgIds = orgObjNewObjMap.keySet();
         String queryStr = fetchFields('Notification_Status__c', ' where Status__c IN: OrgIds');
         if (String.isNotBlank(queryStr)) {
             notifList = Database.query(queryStr);
         }
         System.debug('====notifList===' + notifList);
         /*End*/ if (notifList != null && !notifList.isEmpty()) {
             for (Notification_Status__c ntfy: notifList) {
                 Notification_Status__c newNotifSetObj = ntfy.clone(false, true, false, false);
                 if (newNotifSetObj != null) {
                     /* System.debug('===' + String.escapeSingleQuotes(newSrvcId) + '==='+newObj.itm__c+'==='+newObj.Id);
                     */ newNotifSetObj.Service__c = newSrvcId;
                     newNotifSetObj.Service_Item__c = orgObjNewObjMap.get(ntfy.Status__c).itm__c;
                     newNotifSetObj.Status__c = orgObjNewObjMap.get(ntfy.Status__c).Id;
                     newNotifSetObj.uid__c = '';
                     notifListUpsert.add(newNotifSetObj);
                 }
             }
         }
         Upsert notifListUpsert;
     }
     catch (Exception e) {
         System.debug('====Exception====' + e);
         gU.AddErrorMsg(e);
     }
 }
 public void deleteService() {
     try {
         List < g_Srvc__c > serviceObjs = [Select g.id, g.actv__c From g_Srvc__c g where g.actv__c = false limit 1];
         for (g_Srvc__c serviceObj: serviceObjs) {
             if (serviceObj.id != 'a012000001dXUkC') {
                 getServiceItems(serviceObj);
             }
         }
         if (Schema.sObjectType.g_srvcitm_Doc__c.isDeletable()) {
             delete doclist;
         }
         if (Schema.sObjectType.g_srvcitm_Status__c.isDeletable()) {
             delete itemstatusList;
         }
         if (Schema.sObjectType.g_srvcitm__c.isDeletable()) {
             delete serItemEntries;
         }
         if (Schema.sObjectType.g_Srvc__c.isDeletable()) {
             delete serviceObjs;
         }
     }
     catch (Exception e) {
         System.debug('====Exception====' + e);
     }
 }
 public void getServiceItems(g_Srvc__c serviceObj) {
     List < g_srvcitm__c > serviceItemEntries = null;
     serviceItemEntries = [Select g.id From g_srvcitm__c g where srvc__c =: serviceObj.id];
     g_srvcitm__c orgObj = null;
     g_srvcitm__c cloneObj = null;
     List < g_srvcitm__c > clonedSrItems = null;
     if (serviceItemEntries != null) {
         clonedSrItems = new List < g_srvcitm__c > ();
         for (g_srvcitm__c serviceItemEntry: serviceItemEntries) {
             orgObj = serviceItemEntry;
             getItemStatus(orgObj);
             getItemRequiredDocs(orgObj);
             serItemEntries.add(orgObj);
         }
     }
 }
 public void getItemStatus(g_srvcitm__c orgObj) {
     g_srvcitm_Status__c orgsrItmStatus = null;
     List < g_srvcitm_Status__c > orgSrItmStatuses = [Select g.id From g_srvcitm_Status__c g where itm__c =: orgObj.id];
     if (orgSrItmStatuses != null) {
         for (g_srvcitm_Status__c srItmStatus: orgSrItmStatuses) {
             orgsrItmStatus = srItmStatus;
             itemstatusList.add(orgsrItmStatus);
         }
     }
 }
 public void getItemRequiredDocs(g_srvcitm__c orgObj) {
     g_srvcitm_Doc__c orgItmRd = null;
     g_srvcitm_Doc__c cloneObj = null;
     List < g_srvcitm_Doc__c > itmRdlist = null;
     itmRdlist = [Select g.id From g_srvcitm_Doc__c g where itm__c =: orgObj.Id];
     if (itmRdlist != null) {
         for (g_srvcitm_Doc__c stItmRd: itmRdlist) {
             orgItmRd = stItmRd;
             doclist.add(orgItmRd);
         }
     }
 }
 public void deleteServiceItemById() {
     List < g_srvcitm__c > serviceItemEntries = null;
     serviceItemEntries = [Select g.id From g_srvcitm__c g where id =: serviceItemId];
     g_srvcitm__c orgObj = null;
     g_srvcitm__c cloneObj = null;
     List < g_srvcitm__c > clonedSrItems = null;
     if (serviceItemEntries != null) {
         clonedSrItems = new List < g_srvcitm__c > ();
         for (g_srvcitm__c serviceItemEntry: serviceItemEntries) {
             orgObj = serviceItemEntry;
             getItemStatus(orgObj);
             getItemRequiredDocs(orgObj);
             serItemEntries.add(orgObj);
         }
         if (Schema.sObjectType.g_srvcitm_Doc__c.isDeletable()) {
             delete doclist;
         }
         if (Schema.sObjectType.g_srvcitm_Status__c.isDeletable()) {
             delete itemstatusList;
         }
         if (Schema.sObjectType.g_srvcitm__c.isDeletable()) {
             delete serviceItemEntries;
         }
     }
 }
 /* Method to fetch all fields dynamically from SObject */ public String fetchFields(String SobjectApiName, String conditions) {
     try {
         System.debug(SobjectApiName + '====input params====' + conditions);
         Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
         Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
         String commaSepratedFields = '';
         for (String fieldName: fieldMap.keyset()) {
             if (commaSepratedFields == null || commaSepratedFields == '') {
                 commaSepratedFields = fieldName;
             }
             else {
                 commaSepratedFields = commaSepratedFields + ', ' + fieldName;
             }
         }
         String query = 'select ' + String.escapeSingleQuotes(commaSepratedFields) + ' from ' + SobjectApiName + conditions;
         System.debug('====query====' + query);
         return query;
     }
     Catch(Exception ex) {
         System.debug('====Exception====' + ex);
         return '';
     }
 }
}
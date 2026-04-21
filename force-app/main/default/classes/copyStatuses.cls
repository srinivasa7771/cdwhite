public class copyStatuses {

  public static void setConfigData(String srvcCode, String processItms) {
      /*//processItms - onlyUpdate, OnlyInsert, upsert, doNothing //copyStatuses.setConfigData('00X', 'OnlyInsert');
      */ List<g_srvc__c>  srvc = [select id, name from g_srvc__c where uid__c = :srvcCode limit 1];
      if (srvc == null || srvc.size()==0) {
          System.debug('#### Service code not found!');
          return;
      }
      Http h = new Http();
      HttpRequest request= new HttpRequest();
      HttpResponse response= new HttpResponse();
      request.setHeader('Content-Type', 'application/json');
      request.setHeader('accept', 'application/json');
      request.setEndpoint('callout:AXSQA/apexrest/configs/');
      request.setTimeout(90000);
      request.setMethod('POST');
      request.setBody(srvcCode);
      try{
          response = h.send(request);
          String resp = response.getBody();
          System.debug('configData:: ' + resp);
          resp = resp.replace('\\"', '"');
          resp = resp.replace('"{"', '{"');
          resp = resp.replace('"}]}"', '"}]}');
          ConfigData configData = (ConfigData)JSON.deserialize(resp, ConfigData.class);
          /*//List<g_srvcitm__c> lstOldItms =  configData.itms;
          List<g_srvcitm_Doc__c> lstOldDocs =  configData.docs;
          */ System.debug('configData:: ' + configData.itms);
          if (String.isBlank(processItms)) {
              processItms='doNothing';
          }
          insertItms(srvc[0].Id, srvcCode, processItms, configData.itms, configData.docs, configData.statuses, configData);
          ws_call__c wsCall = new ws_call__c();
          wsCall.rq_jsn__c = 'Service Code: ' + srvcCode + '   ** Service ID: ' +srvc[0].Id;
          wsCall.ws_typ__c = 'CopyStatuses_success';
          if (Schema.sObjectType.ws_call__c.isCreateable()) {
              insert wsCall;
          }
      }
      catch (Exception e) {
          ws_call__c wsCall = new ws_call__c();
          wsCall.rq_jsn__c = 'Service Code: ' + srvcCode + '   ** Service ID: ' +srvc[0].Id;
          wsCall.ws_typ__c = 'CopyStatuses';
          String errormsg = '\n\n #### getMessage: '+ e.getMessage() + '######## stack trace ::: ' + e.getStackTraceString();
          /*/'RESPONSE --- ' +response.getBody() + */ wsCall.err_msg__c= errormsg;
          if (Schema.sObjectType.ws_call__c.isCreateable()) {
              insert wsCall;
          }
      }
  }
    /**
     * inserts items first, then docs and the related stauses
     **/
    public static void insertItms(String newSrvcID, String srvcCode, String processItms,
        List<g_srvcitm__c> lstOldItms, List<g_srvcitm_Doc__c> lstOldDocs, List<g_srvcitm_Status__c> oldStatuses,
        ConfigData configData) {
        Map<String, g_srvcitm__c> oldUIDsByItmID = new Map<String, g_srvcitm__c>();
        Map<String, String> newItmsByUID = new Map<String, String>();
        List<g_srvcitm_Doc__c> lstDocsToInsert = new List<g_srvcitm_Doc__c>();
        List<g_srvcitm__c> lstItmsToInsert = new List<g_srvcitm__c>();
        List<g_srvcitm__c> lstItmsToUpdate = new List<g_srvcitm__c>();
        g_Srvc__c srvc = [select id, name, stg__c, copyCofig__c from g_Srvc__c where uid__c = :srvcCode limit 1];
        /*g_srvc_settings__c settingsNew = [Select id, name, reqq__c, stsq__c, pg__c, payq__c, itmq__c, docq__c, json__c, formFields__c, dfjs__c, apx__c, iapx__c, reqbrules__c, itmbrules__c, bopg__c from g_srvc_settings__c where id= :srvc.stg__c limit 1];
        g_srvc_settings__c settingsOld =  configData.settings;
        settingsNew.name=settingsOld.name;
        settingsNew.reqq__c=settingsOld.reqq__c;
        settingsNew.stsq__c=settingsOld.stsq__c;
        settingsNew.pg__c=settingsOld.pg__c;
        settingsNew.payq__c=settingsOld.payq__c;
        settingsNew.itmq__c=settingsOld.itmq__c;
        settingsNew.docq__c=settingsOld.docq__c;
        settingsNew.json__c=settingsOld.json__c;
        settingsNew.formFields__c=settingsOld.formFields__c;
        settingsNew.dfjs__c=settingsOld.dfjs__c;
        settingsNew.apx__c=settingsOld.apx__c;
        settingsNew.iapx__c=settingsOld.iapx__c;
        settingsNew.reqbrules__c=settingsOld.reqbrules__c;
        settingsNew.itmbrules__c=settingsOld.itmbrules__c;
        settingsNew.bopg__c=settingsOld.bopg__c;
        update settingsNew;
        */   Map<id, g_srvcitm__c> mapNewItms = new Map<id, g_srvcitm__c>([Select srvc__c,
            uid__c, Srv_Code__c, actv__c, aln__c, avFrm__c, avTo__c, cd__c,
            cN__c, cXP__c, dcca_refId__c, dcr__c, dc__c, Dsbl__c, DscApp__c,
            dSTA__c, elv__c, EXP__c, extcsc__c, extc__c, Finance_Group__c,
            gctg__c, ilv__c, jsddt__c, KF__c, lbl__c, lvc__c, lvdy__c, lvd__c,
            Milestone_SLA__c, mv__c, mxcnt__c, Name, ngsXP__c, ngs__c, ORA_Distribution_Set__c,
            ORA_Memo_Line__c, ord__c, payNt__c, prcEdt__c, Pricing_Configured__c,
            Req__c, rv__c, scN__c, scXP__c, shortn__c, slaN__c, slaXP__c,
            SLA_Configured__c, smN__c, smXP__c, spChN__c, spChXP__c, Stage__c,
            su__c, TAXCODE_SC__c, TAX_CODE__c, TAX_TYPE__c, TempStatusWCancel__c,
            Temp_Acc_type__c, Tp__c, vecp__c, vec__c, veschp__c, vesch__c,
            vscp__c, vsc__c, vspc__c, vspexc__c, vspex__c, vsp__c, vstp__c,
            vst__c, vsu__c, xcnopro__c, xf__c, xif__c, xkf__c, xnld__c from g_srvcitm__c  where Srv_Code__c = :srvcCode]);
        for (g_srvcitm__c oldItm: lstOldItms) {
            oldUIDsByItmID.put(oldItm.Id, oldItm);
        }
        for (g_srvcitm__c newItm: mapNewItms.values()) {
            newItmsByUID.put(newItm.uid__c, newItm.Id);
        }
        for (String str : oldUIDsByItmID.keySet()) {
            g_srvcitm__c oldItm = oldUIDsByItmID.get(str);
            if (oldItm != null) {
                String newUID = oldItm.uid__c;
                String newItmID = newItmsByUID.get(newUID);
                if (String.isNotBlank(newItmID)) {
                    /*/update the item*/ g_srvcitm__c newItm  = mapNewItms.get(newItmID);
                    newItm.srvc__c=newSrvcID;
                    newItm.aln__c=oldItm.aln__c;
                    newItm.avFrm__c=oldItm.avFrm__c;
                    newItm.avTo__c=oldItm.avTo__c;
                    newItm.cd__c=oldItm.cd__c;
                    newItm.cN__c=oldItm.cN__c;
                    newItm.cXP__c=oldItm.cXP__c;
                    newItm.dcca_refId__c=oldItm.dcca_refId__c;
                    newItm.dcr__c=oldItm.dcr__c;
                    newItm.dc__c=oldItm.dc__c;
                    newItm.Dsbl__c=oldItm.Dsbl__c;
                    newItm.DscApp__c=oldItm.DscApp__c;
                    newItm.dSTA__c=oldItm.dSTA__c;
                    newItm.elv__c=oldItm.elv__c;
                    newItm.EXP__c=oldItm.EXP__c;
                    newItm.extcsc__c=oldItm.extcsc__c;
                    newItm.extc__c=oldItm.extc__c;
                    newItm.Finance_Group__c=oldItm.Finance_Group__c;
                    newItm.gctg__c=oldItm.gctg__c;
                    newItm.ilv__c=oldItm.ilv__c;
                    newItm.jsddt__c=oldItm.jsddt__c;
                    newItm.KF__c=oldItm.KF__c;
                    newItm.lbl__c=oldItm.lbl__c;
                    newItm.lvc__c=oldItm.lvc__c;
                    newItm.lvdy__c=oldItm.lvdy__c;
                    newItm.lvd__c=oldItm.lvd__c;
                    newItm.Milestone_SLA__c=oldItm.Milestone_SLA__c;
                    newItm.mv__c=oldItm.mv__c;
                    newItm.mxcnt__c=oldItm.mxcnt__c;
                    newItm.Name=oldItm.Name;
                    newItm.ngsXP__c=oldItm.ngsXP__c;
                    newItm.ngs__c=oldItm.ngs__c;
                    newItm.ORA_Distribution_Set__c=oldItm.ORA_Distribution_Set__c;
                    newItm.ORA_Memo_Line__c=oldItm.ORA_Memo_Line__c;
                    newItm.ord__c=oldItm.ord__c;
                    newItm.payNt__c=oldItm.payNt__c;
                    newItm.prcEdt__c=oldItm.prcEdt__c;
                    newItm.Pricing_Configured__c=oldItm.Pricing_Configured__c;
                    newItm.Req__c=oldItm.Req__c;
                    newItm.rv__c=oldItm.rv__c;
                    newItm.scN__c=oldItm.scN__c;
                    newItm.scXP__c=oldItm.scXP__c;
                    newItm.shortn__c=oldItm.shortn__c;
                    newItm.slaN__c=oldItm.slaN__c;
                    newItm.slaXP__c=oldItm.slaXP__c;
                    newItm.SLA_Configured__c=oldItm.SLA_Configured__c;
                    newItm.smN__c=oldItm.smN__c;
                    newItm.smXP__c=oldItm.smXP__c;
                    newItm.spChN__c=oldItm.spChN__c;
                    newItm.spChXP__c=oldItm.spChXP__c;
                    newItm.Stage__c=oldItm.Stage__c;
                    newItm.su__c=oldItm.su__c;
                    newItm.TAXCODE_SC__c=oldItm.TAXCODE_SC__c;
                    newItm.TAX_CODE__c=oldItm.TAX_CODE__c;
                    newItm.TAX_TYPE__c=oldItm.TAX_TYPE__c;
                    newItm.Tp__c=oldItm.Tp__c;
                    newItm.vecp__c=oldItm.vecp__c;
                    newItm.veschp__c=oldItm.veschp__c;
                    newItm.vspex__c=oldItm.vspex__c;
                    newItm.vsp__c=oldItm.vsp__c;
                    newItm.vstp__c=oldItm.vstp__c;
                    newItm.vsu__c=oldItm.vsu__c;
                    newItm.xcnopro__c=oldItm.xcnopro__c;
                    newItm.xf__c=oldItm.xf__c;
                    newItm.xif__c=oldItm.xif__c;
                    newItm.xkf__c=oldItm.xkf__c;
                    newItm.xnld__c=oldItm.xnld__c;
                    lstItmsToUpdate.add(newItm);
                }
                else{
                    /*/insert the item*/ lstItmsToInsert.add(new g_srvcitm__c(srvc__c=newSrvcID, aln__c=oldItm.aln__c, avFrm__c=oldItm.avFrm__c, avTo__c=oldItm.avTo__c, cd__c=oldItm.cd__c, cN__c=oldItm.cN__c, cXP__c=oldItm.cXP__c, dcca_refId__c=oldItm.dcca_refId__c, dcr__c=oldItm.dcr__c, dc__c=oldItm.dc__c, Dsbl__c=oldItm.Dsbl__c, DscApp__c=oldItm.DscApp__c, dSTA__c=oldItm.dSTA__c, elv__c=oldItm.elv__c, EXP__c=oldItm.EXP__c, extcsc__c=oldItm.extcsc__c, extc__c=oldItm.extc__c, Finance_Group__c=oldItm.Finance_Group__c, gctg__c=oldItm.gctg__c, ilv__c=oldItm.ilv__c, jsddt__c=oldItm.jsddt__c, KF__c=oldItm.KF__c, lbl__c=oldItm.lbl__c, lvc__c=oldItm.lvc__c, lvdy__c=oldItm.lvdy__c, lvd__c=oldItm.lvd__c, Milestone_SLA__c=oldItm.Milestone_SLA__c, mv__c=oldItm.mv__c, mxcnt__c=oldItm.mxcnt__c, Name=oldItm.Name, ngsXP__c=oldItm.ngsXP__c, ngs__c=oldItm.ngs__c, ORA_Distribution_Set__c=oldItm.ORA_Distribution_Set__c, ORA_Memo_Line__c=oldItm.ORA_Memo_Line__c, ord__c=oldItm.ord__c, payNt__c=oldItm.payNt__c, prcEdt__c=oldItm.prcEdt__c, Pricing_Configured__c=oldItm.Pricing_Configured__c, Req__c=oldItm.Req__c, rv__c=oldItm.rv__c, scN__c=oldItm.scN__c, scXP__c=oldItm.scXP__c, shortn__c=oldItm.shortn__c, slaN__c=oldItm.slaN__c, slaXP__c=oldItm.slaXP__c, SLA_Configured__c=oldItm.SLA_Configured__c, smN__c=oldItm.smN__c, smXP__c=oldItm.smXP__c, spChN__c=oldItm.spChN__c, spChXP__c=oldItm.spChXP__c, Stage__c=oldItm.Stage__c, su__c=oldItm.su__c, TAXCODE_SC__c=oldItm.TAXCODE_SC__c, TAX_CODE__c=oldItm.TAX_CODE__c, TAX_TYPE__c=oldItm.TAX_TYPE__c, Tp__c=oldItm.Tp__c, vecp__c=oldItm.vecp__c,  veschp__c=oldItm.veschp__c, vspex__c=oldItm.vspex__c, vsp__c=oldItm.vsp__c, vstp__c=oldItm.vstp__c, vsu__c=oldItm.vsu__c, xcnopro__c=oldItm.xcnopro__c, xf__c=oldItm.xf__c, xif__c=oldItm.xif__c, xkf__c=oldItm.xkf__c, xnld__c=oldItm.xnld__c));
                }
            }
        }
        System.debug('Item to be UPDATED:: ' + lstItmsToUpdate.size());
        System.debug('Item to be inserted:: ' + lstItmsToInsert.size());
        /*/processItms - onlyUpdate, OnlyInsert, upsert, doNothing*/ if (processItms.equalsIgnoreCase('upsert') || processItms.equalsIgnoreCase('OnlyInsert')) {
            if (Schema.sObjectType.g_srvcitm__c.isCreateable()) {
                insert lstItmsToInsert;
            }
        }
        if (processItms.equalsIgnoreCase('upsert') || processItms.equalsIgnoreCase('onlyUpdate')) {
            if (Schema.sObjectType.g_srvcitm__c.isUpdateable()) {
                update lstItmsToUpdate;
            }
        }
        /*/################################################################################################################*/ mapNewItms = new Map<id, g_srvcitm__c>([Select srvc__c, uid__c, Srv_Code__c, actv__c, aln__c, avFrm__c, avTo__c, cd__c, cN__c, cXP__c, dcca_refId__c, dcr__c, dc__c, Dsbl__c, DscApp__c, dSTA__c, elv__c, EXP__c, extcsc__c, extc__c, Finance_Group__c, gctg__c, ilv__c, jsddt__c, KF__c, lbl__c, lvc__c, lvdy__c, lvd__c, Milestone_SLA__c, mv__c, mxcnt__c, Name, ngsXP__c, ngs__c, ORA_Distribution_Set__c, ORA_Memo_Line__c, ord__c, payNt__c, prcEdt__c, Pricing_Configured__c, Req__c, rv__c, scN__c, scXP__c, shortn__c, slaN__c, slaXP__c, SLA_Configured__c, smN__c, smXP__c, spChN__c, spChXP__c, Stage__c, su__c, TAXCODE_SC__c, TAX_CODE__c, TAX_TYPE__c, TempStatusWCancel__c, Temp_Acc_type__c, Tp__c, vecp__c, vec__c, veschp__c, vesch__c, vscp__c, vsc__c, vspc__c, vspexc__c, vspex__c, vsp__c, vstp__c, vst__c, vsu__c, xcnopro__c, xf__c, xif__c, xkf__c, xnld__c from g_srvcitm__c  where Srv_Code__c = :srvcCode]);
        for (g_srvcitm__c newItm: mapNewItms.values()) {
            newItmsByUID.put(newItm.uid__c, newItm.Id);
        }
        List<g_srvcitm_Doc__c> listDocs = [ SELECT id, name, itm__c from g_srvcitm_Doc__c where Srv_Code__c = :srvcCode];
        if (Schema.sObjectType.g_srvcitm_Doc__c.isDeletable()) {
            delete listDocs;
        }
        for (g_srvcitm_Doc__c oldDoc : lstOldDocs) {
            g_srvcitm__c oldItm = oldUIDsByItmID.get(oldDoc.itm__c);
            if (oldItm != null) {
                String newUID = oldItm.UID__C;
                String newItmID = newItmsByUID.get(newUID);
                if (String.isNotBlank(newItmID)) {
                    lstDocsToInsert.add(new g_srvcitm_Doc__c(itm__c = newItmID, Att_Type__c=oldDoc.Att_Type__c,
                        Doc_Description__c=oldDoc.Doc_Description__c, Download_Doc_Link__c=oldDoc.Download_Doc_Link__c,
                        lbl__c=oldDoc.lbl__c, mnAts__c=oldDoc.mnAts__c, mxAts__c=oldDoc.mxAts__c,
                        Name=oldDoc.Name, Old_Sf_Id__c=oldDoc.Old_Sf_Id__c, ord__c=oldDoc.ord__c,
                        reqAts__c=oldDoc.reqAts__c, reqOr__c=oldDoc.reqOr__c, Req__c=oldDoc.Req__c,
                        rqc__c=oldDoc.rqc__c, Tp__c=oldDoc.Tp__c));
                }
            }
        }
        System.debug('lstDocsToInsert:: ' + lstDocsToInsert.size());
        if (Schema.sObjectType.g_srvcitm_Doc__c.isCreateable()) {
            insert lstDocsToInsert;
        }
        /* //################################################################################################################ //oldStatuses*/ List<g_srvcitm_Status__c> lstStaToInsert = new List<g_srvcitm_Status__c>();
        List<g_srvcitm_Status__c> lstStaToUpdate = new List<g_srvcitm_Status__c>();
        Map<String, g_srvcitm_Status__c> mapStUids = new map<String, g_srvcitm_Status__c>();
        Map<String, ID> mapNweOldItemIDS = new map<String, ID>();
        Map<Id, g_srvcitm_Status__c> newStatuses = new Map<Id, g_srvcitm_Status__c>([SELECT action__c,
            acttype__c, actv__c, amsgs__c, Assignee__c, Baction__c, cd__c, Claimable_Refundable_Configured__c,
            clmA__c, clm__c, cmthd__c, Courier_Notes_Configured__c, Courier_Notes__c, Courier_Stage__c,
            Courier_Status__c, daction__c, eCumsg__c, eNumsg__c, Exclude_SLA__c, exsyst__c, hisl__c,
            Id, imsgs__c, isfn__c, Item__c, itm__c, itm__r.uid__c, ivraction__c, ivrmsg__c, jscfddt__c,
            jsovddt__c, KPIs_Configured__c, kstp__c, lbl__c, MilestomeCHk__c, MileStone_Check__c,
            Milestone_Mismatch__c, Milestone__c, MStage__c, Name, namsgs__c, nm__c, noEXP__c,
            Notification_Configured__c, nt__c, Old_Sf_Id__c, Overhead__c, rc__c, reqv__c, Responsibilty__c,
            rfndA__c, rfnd__c, RiMl__c, rqSTA__c, Score__c, ServceName__c, Service_Group__c,
            Shift_At__c, Shift_Items__c, Shift_Type__c, slaat__c, slaa__c, slaN__c, slaXP__c,
            SLA_Configured__c, smstxt__c, srvCode__c, srv_code__c, staown__c, statype__c, stk__c,
            Task_Label__c, tempChk__c, Temp_Acct__c, Temp_Srv__c, tmpid__c, tmp__c, Tp__c, uid__c,
            ws_mtd__c, ws_typ__c, xai__c, xcsits__c, xsi__c  FROM g_srvcitm_Status__c where srvCode__c = :srvcCode ]);
        for (g_srvcitm_Status__c st : newStatuses.values()) {
            mapStUids.put(st.uid__c, st);
        }
        System.debug('mapStUids:: ' + mapStUids);
        for (g_srvcitm_Status__c Ex : oldStatuses) {
            String newItmUID = Ex.uid__c;
            System.debug('newItmUID:: ' + newItmUID);
            if (mapStUids.containsKey(newItmUID)) {
                g_srvcitm_Status__c newItm = mapStUids.get(newItmUID);
                newItm.action__c=ex.action__c;
                newItm.acttype__c=ex.acttype__c;
                newItm.actv__c=ex.actv__c;
                newItm.amsgs__c=ex.amsgs__c;
                newItm.Assignee__c=ex.Assignee__c;
                newItm.Baction__c=ex.Baction__c;
                newItm.cd__c=ex.cd__c;
                newItm.Claimable_Refundable_Configured__c=ex.Claimable_Refundable_Configured__c;
                newItm.clmA__c=ex.clmA__c;
                newItm.clm__c=ex.clm__c;
                newItm.cmthd__c=ex.cmthd__c;
                newItm.Courier_Notes_Configured__c=ex.Courier_Notes_Configured__c;
                newItm.Courier_Notes__c=ex.Courier_Notes__c;
                newItm.Courier_Stage__c=ex.Courier_Stage__c;
                newItm.daction__c=ex.daction__c;
                newItm.eCumsg__c=ex.eCumsg__c;
                newItm.eNumsg__c=ex.eNumsg__c;
                newItm.Exclude_SLA__c=ex.Exclude_SLA__c;
                newItm.exsyst__c=ex.exsyst__c;
                newItm.hisl__c=ex.hisl__c;
                newItm.imsgs__c=ex.imsgs__c;
                newItm.isfn__c=ex.isfn__c;
                newItm.ivraction__c=ex.ivraction__c;
                newItm.ivrmsg__c=ex.ivrmsg__c;
                newItm.jsovddt__c=ex.jsovddt__c;
                newItm.kstp__c=ex.kstp__c;
                newItm.lbl__c=ex.lbl__c;
                newItm.Milestone__c=ex.Milestone__c;
                newItm.Name=ex.Name;
                newItm.namsgs__c=ex.namsgs__c;
                newItm.nm__c=ex.nm__c;
                newItm.noEXP__c=ex.noEXP__c;
                newItm.Notification_Configured__c=ex.Notification_Configured__c;
                newItm.nt__c=ex.nt__c;
                newItm.Overhead__c=ex.Overhead__c;
                newItm.rc__c=ex.rc__c;
                newItm.rfndA__c=ex.rfndA__c;
                newItm.rfnd__c=ex.rfnd__c;
                newItm.rqSTA__c=ex.rqSTA__c;
                newItm.Score__c=ex.Score__c;
                newItm.Shift_At__c=ex.Shift_At__c;
                newItm.Shift_Items__c=ex.Shift_Items__c;
                newItm.Shift_Type__c=ex.Shift_Type__c;
                newItm.slaat__c=ex.slaat__c;
                newItm.slaa__c=ex.slaa__c;
                newItm.slaN__c=ex.slaN__c;
                newItm.slaXP__c=ex.slaXP__c;
                newItm.SLA_Configured__c=ex.SLA_Configured__c;
                newItm.smstxt__c=ex.smstxt__c;
                newItm.staown__c=ex.staown__c;
                newItm.statype__c=ex.statype__c;
                newItm.stk__c=ex.stk__c;
                newItm.Task_Label__c=ex.Task_Label__c;
                newItm.tempChk__c=ex.tempChk__c;
                newItm.Tp__c=ex.Tp__c;
                newItm.ws_mtd__c=ex.ws_mtd__c;
                newItm.ws_typ__c=ex.ws_typ__c;
                newItm.xai__c=ex.xai__c;
                newItm.xcsits__c=ex.xcsits__c;
                newItm.xsi__c=ex.xsi__c;
                lstStaToUpdate.add(newItm);
            }
            else if (newItmsByUID.containsKey(Ex.itm__r.uid__c)) {
                Id itemID = newItmsByUID.get(Ex.itm__r.uid__c);
                g_srvcitm_Status__c newItm = new g_srvcitm_Status__c(itm__c=itemID, action__c=ex.action__c,
                    acttype__c=ex.acttype__c, actv__c=ex.actv__c, amsgs__c=ex.amsgs__c, Assignee__c=ex.Assignee__c,
                    Baction__c=ex.Baction__c, cd__c=ex.cd__c, Claimable_Refundable_Configured__c=ex.Claimable_Refundable_Configured__c,
                    clmA__c=ex.clmA__c, clm__c=ex.clm__c, cmthd__c=ex.cmthd__c, Courier_Notes_Configured__c=ex.Courier_Notes_Configured__c,
                    Courier_Notes__c=ex.Courier_Notes__c, Courier_Stage__c=ex.Courier_Stage__c, daction__c=ex.daction__c,
                    eCumsg__c=ex.eCumsg__c, eNumsg__c=ex.eNumsg__c, Exclude_SLA__c=ex.Exclude_SLA__c,
                    exsyst__c=ex.exsyst__c, hisl__c=ex.hisl__c, imsgs__c=ex.imsgs__c, isfn__c=ex.isfn__c,
                    ivraction__c=ex.ivraction__c, ivrmsg__c=ex.ivrmsg__c, jsovddt__c=ex.jsovddt__c, kstp__c=ex.kstp__c,
                    lbl__c=ex.lbl__c, Milestone__c=ex.Milestone__c, Name=ex.Name, namsgs__c=ex.namsgs__c,
                    nm__c=ex.nm__c, noEXP__c=ex.noEXP__c, Notification_Configured__c=ex.Notification_Configured__c,
                    nt__c=ex.nt__c, Overhead__c=ex.Overhead__c, rc__c=ex.rc__c, rfndA__c=ex.rfndA__c,
                    rfnd__c=ex.rfnd__c, rqSTA__c=ex.rqSTA__c, Score__c=ex.Score__c, Shift_At__c=ex.Shift_At__c,
                    Shift_Items__c=ex.Shift_Items__c, Shift_Type__c=ex.Shift_Type__c, slaat__c=ex.slaat__c,
                    slaa__c=ex.slaa__c, slaN__c=ex.slaN__c, slaXP__c=ex.slaXP__c, SLA_Configured__c=ex.SLA_Configured__c,
                    smstxt__c=ex.smstxt__c, staown__c=ex.staown__c, statype__c=ex.statype__c, stk__c=ex.stk__c,
                    Task_Label__c=ex.Task_Label__c, tempChk__c=ex.tempChk__c, Tp__c=ex.Tp__c, ws_mtd__c=ex.ws_mtd__c,
                    ws_typ__c=ex.ws_typ__c, xai__c=ex.xai__c, xcsits__c=ex.xcsits__c, xsi__c=ex.xsi__c);
                lstStaToInsert.add(newItm);
            }
        }
        System.debug('lstStaToUpdate:: ' +lstStaToUpdate);
        System.debug('lstStaToInsert:: ' +lstStaToInsert);
        insert lstStaToInsert;
        if (Schema.sObjectType.g_srvcitm_Status__c.isUpdateable()) {
            update lstStaToUpdate;
        }
        srvc.copyCofig__c = true;
        if (Schema.sObjectType.g_srvc__c.isUpdateable()) {
            update srvc;
        }
    }

    //################################################################################################################
    /**
     * copies extenal statuses to internal service
     * from code is srvcCode of external service and toCode is of internal
     **/
    //################################################################################################################

    public static void copyStatuses(String fromCode, String toCode, boolean processItems) {
        try{
            String oldCode=fromCode;
            String newItmCode=toCode;
            List<String> codes = new List<String>();
            codes.add(newItmCode);
            codes.add(oldCode);
            Map<String, ID> mapNweOldItemIDS = new map<String, ID>();
            List<g_srvcitm__c> lstItmsToUpdate = new List<g_srvcitm__c>();
            List<g_srvcitm__c> lstItmsToInsert = new List<g_srvcitm__c>();
            List<g_srvcitm__c> lstItmsToCopyFrom = new List<g_srvcitm__c>();
            List<g_Srvc__c> lstSrvc = new List<g_Srvc__c>();
            map<String, ID> mapSrvcUIDs = new Map<String, ID>();
            Map<id, g_srvcitm__c> mapAllItms = new Map<id, g_srvcitm__c>([Select id, srvc__c,
                uid__c, Srv_Code__c, actv__c, aln__c, avFrm__c, avTo__c, cd__c, cN__c, cXP__c, dcca_refId__c,
                dcr__c, dc__c, Dsbl__c, DscApp__c, dSTA__c, elv__c, EXP__c, extcsc__c, extc__c, Finance_Group__c,
                gctg__c, ilv__c, jsddt__c, KF__c, lbl__c, lvc__c, lvdy__c, lvd__c, Milestone_SLA__c,
                mv__c, mxcnt__c, Name, ngsXP__c, ngs__c, ORA_Distribution_Set__c, ORA_Memo_Line__c,
                ord__c, payNt__c, prcEdt__c, Pricing_Configured__c, Req__c, rv__c, scN__c, scXP__c,
                shortn__c, slaN__c, slaXP__c, SLA_Configured__c, smN__c, smXP__c, spChN__c, spChXP__c,
                Stage__c, su__c, TAXCODE_SC__c, TAX_CODE__c, TAX_TYPE__c, TempStatusWCancel__c, Temp_Acc_type__c,
                Tp__c, vecp__c, vec__c, veschp__c, vesch__c, vscp__c, vsc__c, vspc__c, vspexc__c,
                vspex__c, vsp__c, vstp__c, vst__c, vsu__c, xcnopro__c, xf__c, xif__c, xkf__c, xnld__c from g_srvcitm__c  where Srv_Code__c = :codes]);
            for (g_srvcitm__c itm : mapAllItms.values()) {
                mapNweOldItemIDS.put(itm.uid__c, itm.id);
                if (itm.Srv_Code__c == toCode) {
                    lstItmsToUpdate.add(itm);
                }
                else{
                    lstItmsToCopyFrom.add(itm);
                }
            }
            if (processItems) {
                lstSrvc = [select id, name, uid__C, stg__c, copyCofig__c from g_Srvc__c where uid__c = :codes];
                for (g_Srvc__c srv: lstSrvc) {
                    mapSrvcUIDs.put(srv.uid__c, srv.Id);
                }
                System.debug('### mapSrvcUIDs : ' + mapSrvcUIDs);
                for (g_srvcitm__c oldItm : lstItmsToCopyFrom) {
                    system.debug('lstItmsToCopyFrom::'+oldItm.cd__c);
                    lstItmsToInsert.add(new g_srvcitm__c(srvc__c=mapSrvcUIDs.get(toCode),
                        aln__c=oldItm.aln__c, avFrm__c=oldItm.avFrm__c, avTo__c=oldItm.avTo__c,
                        cd__c=oldItm.cd__c, cN__c=oldItm.cN__c, cXP__c=oldItm.cXP__c,
                        dcca_refId__c=oldItm.dcca_refId__c, dcr__c=oldItm.dcr__c, dc__c=oldItm.dc__c,
                        Dsbl__c=oldItm.Dsbl__c, DscApp__c=oldItm.DscApp__c, dSTA__c=oldItm.dSTA__c,
                        elv__c=oldItm.elv__c, EXP__c=oldItm.EXP__c, extcsc__c=oldItm.extcsc__c,
                        extc__c=oldItm.extc__c, Finance_Group__c=oldItm.Finance_Group__c,
                        gctg__c=oldItm.gctg__c, ilv__c=oldItm.ilv__c, jsddt__c=oldItm.jsddt__c,
                        KF__c=oldItm.KF__c, lbl__c=oldItm.lbl__c, lvc__c=oldItm.lvc__c,
                        lvdy__c=oldItm.lvdy__c, lvd__c=oldItm.lvd__c, Milestone_SLA__c=oldItm.Milestone_SLA__c,
                        mv__c=oldItm.mv__c, mxcnt__c=oldItm.mxcnt__c, Name=oldItm.Name,
                        ngsXP__c=oldItm.ngsXP__c, ngs__c=oldItm.ngs__c, ORA_Distribution_Set__c=oldItm.ORA_Distribution_Set__c,
                        ORA_Memo_Line__c=oldItm.ORA_Memo_Line__c, ord__c=oldItm.ord__c,
                        payNt__c=oldItm.payNt__c, prcEdt__c=oldItm.prcEdt__c, Pricing_Configured__c=oldItm.Pricing_Configured__c,
                        Req__c=oldItm.Req__c, rv__c=oldItm.rv__c, scN__c=oldItm.scN__c,
                        scXP__c=oldItm.scXP__c, shortn__c=oldItm.shortn__c, slaN__c=oldItm.slaN__c,
                        slaXP__c=oldItm.slaXP__c, SLA_Configured__c=oldItm.SLA_Configured__c,
                        smN__c=oldItm.smN__c, smXP__c=oldItm.smXP__c, spChN__c=oldItm.spChN__c,
                        spChXP__c=oldItm.spChXP__c, Stage__c=oldItm.Stage__c, su__c=oldItm.su__c,
                        TAXCODE_SC__c=oldItm.TAXCODE_SC__c, TAX_CODE__c=oldItm.TAX_CODE__c,
                        TAX_TYPE__c=oldItm.TAX_TYPE__c, Tp__c=oldItm.Tp__c, vecp__c=oldItm.vecp__c,
                        veschp__c=oldItm.veschp__c, vspex__c=oldItm.vspex__c, vsp__c=oldItm.vsp__c,
                        vstp__c=oldItm.vstp__c, vsu__c=oldItm.vsu__c, xcnopro__c=oldItm.xcnopro__c,
                        xf__c=oldItm.xf__c, xif__c=oldItm.xif__c, xkf__c=oldItm.xkf__c,
                        xnld__c=oldItm.xnld__c));
                }
                System.debug('### INSERTING THE ITEMS');
                /*/insert lstItmsToInsert;
                */ database.insert(lstItmsToInsert, false);
                return;
            }
            for (g_srvcitm__c newItm:lstItmsToUpdate) {
                String oldItmUID = newItm.uid__c.replace(toCode, fromCode);
                if (String.isNotBlank(oldItmUID)) {
                    String oldItmID = mapNweOldItemIDS.get(oldItmUID);
                    if (String.isNotBlank(oldItmUID)) {
                        g_srvcitm__c oldItm = mapAllItms.get(oldItmID);
                        /*/newItm.srvc__c=newSrvcID;
                        */ if (oldItm != null) {
                            newItm.aln__c=oldItm.aln__c;
                            newItm.avFrm__c=oldItm.avFrm__c;
                            newItm.avTo__c=oldItm.avTo__c;
                            newItm.cd__c=oldItm.cd__c;
                            newItm.cN__c=oldItm.cN__c;
                            newItm.cXP__c=oldItm.cXP__c;
                            newItm.dcca_refId__c=oldItm.dcca_refId__c;
                            newItm.dcr__c=oldItm.dcr__c;
                            newItm.dc__c=oldItm.dc__c;
                            newItm.Dsbl__c=oldItm.Dsbl__c;
                            newItm.DscApp__c=oldItm.DscApp__c;
                            newItm.dSTA__c=oldItm.dSTA__c;
                            newItm.elv__c=oldItm.elv__c;
                            newItm.EXP__c=oldItm.EXP__c;
                            newItm.extcsc__c=oldItm.extcsc__c;
                            newItm.extc__c=oldItm.extc__c;
                            newItm.Finance_Group__c=oldItm.Finance_Group__c;
                            newItm.gctg__c=oldItm.gctg__c;
                            newItm.ilv__c=oldItm.ilv__c;
                            newItm.jsddt__c=oldItm.jsddt__c;
                            newItm.KF__c=oldItm.KF__c;
                            newItm.lbl__c=oldItm.lbl__c;
                            newItm.lvc__c=oldItm.lvc__c;
                            newItm.lvdy__c=oldItm.lvdy__c;
                            newItm.lvd__c=oldItm.lvd__c;
                            newItm.Milestone_SLA__c=oldItm.Milestone_SLA__c;
                            newItm.mv__c=oldItm.mv__c;
                            newItm.mxcnt__c=oldItm.mxcnt__c;
                            newItm.Name=oldItm.Name;
                            newItm.ngsXP__c=oldItm.ngsXP__c;
                            newItm.ngs__c=oldItm.ngs__c;
                            newItm.ORA_Distribution_Set__c=oldItm.ORA_Distribution_Set__c;
                            newItm.ORA_Memo_Line__c=oldItm.ORA_Memo_Line__c;
                            newItm.ord__c=oldItm.ord__c;
                            newItm.payNt__c=oldItm.payNt__c;
                            newItm.prcEdt__c=oldItm.prcEdt__c;
                            newItm.Pricing_Configured__c=oldItm.Pricing_Configured__c;
                            newItm.Req__c=oldItm.Req__c;
                            newItm.rv__c=oldItm.rv__c;
                            newItm.scN__c=oldItm.scN__c;
                            newItm.scXP__c=oldItm.scXP__c;
                            newItm.shortn__c=oldItm.shortn__c;
                            newItm.slaN__c=oldItm.slaN__c;
                            newItm.slaXP__c=oldItm.slaXP__c;
                            newItm.SLA_Configured__c=oldItm.SLA_Configured__c;
                            newItm.smN__c=oldItm.smN__c;
                            newItm.smXP__c=oldItm.smXP__c;
                            newItm.spChN__c=oldItm.spChN__c;
                            newItm.spChXP__c=oldItm.spChXP__c;
                            newItm.Stage__c=oldItm.Stage__c;
                            newItm.su__c=oldItm.su__c;
                            newItm.TAXCODE_SC__c=oldItm.TAXCODE_SC__c;
                            newItm.TAX_CODE__c=oldItm.TAX_CODE__c;
                            newItm.TAX_TYPE__c=oldItm.TAX_TYPE__c;
                            newItm.Tp__c=oldItm.Tp__c;
                            newItm.vecp__c=oldItm.vecp__c;
                            newItm.veschp__c=oldItm.veschp__c;
                            newItm.vspex__c=oldItm.vspex__c;
                            newItm.vsp__c=oldItm.vsp__c;
                            newItm.vstp__c=oldItm.vstp__c;
                            newItm.vsu__c=oldItm.vsu__c;
                            newItm.xcnopro__c=oldItm.xcnopro__c;
                            newItm.xf__c=oldItm.xf__c;
                            newItm.xif__c=oldItm.xif__c;
                            newItm.xkf__c=oldItm.xkf__c;
                            newItm.xnld__c=oldItm.xnld__c;
                        }
                    }
                }
            }
            System.debug('### UPDATING THE ITEMS');
            if (Schema.sObjectType.g_srvcitm__c.isUpdateable()) {
                update lstItmsToUpdate;
            }
            /*//################################################################################################################ //List<g_srvcitm__c> lstItems = [Select id, srvc__c, Srv_Code__c, uid__c from g_srvcitm__c where Srv_Code__c in :codes ];
            */  List<g_srvcitm_Status__c> statuses = [SELECT action__c, acttype__c,
                actv__c, amsgs__c, Assignee__c, Baction__c, cd__c, Claimable_Refundable_Configured__c,
                clmA__c, clm__c, cmthd__c, Courier_Notes_Configured__c, Courier_Notes__c,
                Courier_Stage__c, Courier_Status__c, daction__c, eCumsg__c, eNumsg__c,
                Exclude_SLA__c, exsyst__c, hisl__c, Id, imsgs__c, isfn__c, Item__c,
                itm__c, itm__r.uid__c, ivraction__c, ivrmsg__c, jscfddt__c, jsovddt__c,
                KPIs_Configured__c, kstp__c, lbl__c, MilestomeCHk__c, MileStone_Check__c,
                Milestone_Mismatch__c, Milestone__c, MStage__c, Name, namsgs__c,
                nm__c, noEXP__c, Notification_Configured__c, nt__c, Old_Sf_Id__c,
                Overhead__c, rc__c, reqv__c, Responsibilty__c, rfndA__c, rfnd__c,
                RiMl__c, rqSTA__c, Score__c, ServceName__c, Service_Group__c,
                Shift_At__c, Shift_Items__c, Shift_Type__c, slaat__c, slaa__c,
                slaN__c, slaXP__c, SLA_Configured__c, smstxt__c, srvCode__c,
                srv_code__c, staown__c, statype__c, stk__c, Task_Label__c, tempChk__c,
                Temp_Acct__c, Temp_Srv__c, tmpid__c, tmp__c, Tp__c, uid__c, ws_mtd__c,
                ws_typ__c, xai__c, xcsits__c, xsi__c  FROM g_srvcitm_Status__c where srvCode__c in :codes ];
            /*/and cd__c in ('n', 'nT', 'c')*/    Map<String, g_srvcitm_Status__c> mapStUids = new map<String, g_srvcitm_Status__c>();
            List<g_srvcitm_Status__c> listEX = new List<g_srvcitm_Status__c>();
            List<g_srvcitm_Status__c> listToUpdate = new List<g_srvcitm_Status__c>();
            List<g_srvcitm_Status__c> listToinsert = new List<g_srvcitm_Status__c>();
            for (g_srvcitm_Status__c st : statuses) {
                mapStUids.put(st.uid__c, st);
                /*/mapNweOldItemIDS.put(st.itm__r.uid__c, st.itm__c);
                */ if (st.srvCode__c == oldCode) {
                    listEX.add(st);
                }
            }
            /*for (g_srvcitm__c itm : lstItems) {
                mapNweOldItemIDS.put(itm.uid__c, itm.id);
            }
            */   System.debug('****mapStUids*******' + mapStUids);
            System.debug('****mapNweOldItemIDS*******' + mapNweOldItemIDS);
            for (g_srvcitm_Status__c Ex : listEX) {
                if (String.isNotBlank(Ex.uid__c)) {
                    String newItmUID = Ex.uid__c.replace(oldCode, newItmCode);
                    /*/System.debug('****newItmUID*******' + newItmUID);
                    */  if (mapStUids.containsKey(newItmUID)) {
                        g_srvcitm_Status__c newItm = mapStUids.get(newItmUID);
                        /** with comms**/ newItm.action__c=ex.action__c;
                        newItm.acttype__c=ex.acttype__c;
                        newItm.actv__c=ex.actv__c;
                        newItm.amsgs__c=ex.amsgs__c;
                        newItm.Assignee__c=ex.Assignee__c;
                        newItm.Baction__c=ex.Baction__c;
                        newItm.cd__c=ex.cd__c;
                        newItm.Claimable_Refundable_Configured__c=ex.Claimable_Refundable_Configured__c;
                        newItm.clmA__c=ex.clmA__c;
                        newItm.clm__c=ex.clm__c;
                        newItm.cmthd__c=ex.cmthd__c;
                        newItm.Courier_Notes_Configured__c=ex.Courier_Notes_Configured__c;
                        newItm.Courier_Notes__c=ex.Courier_Notes__c;
                        newItm.Courier_Stage__c=ex.Courier_Stage__c;
                        newItm.daction__c=ex.daction__c;
                        newItm.eCumsg__c=ex.eCumsg__c;
                        newItm.eNumsg__c=ex.eNumsg__c;
                        newItm.Exclude_SLA__c=ex.Exclude_SLA__c;
                        newItm.exsyst__c=ex.exsyst__c;
                        newItm.hisl__c=ex.hisl__c;
                        newItm.imsgs__c=ex.imsgs__c;
                        newItm.isfn__c=ex.isfn__c;
                        newItm.ivraction__c=ex.ivraction__c;
                        newItm.ivrmsg__c=ex.ivrmsg__c;
                        newItm.jsovddt__c=ex.jsovddt__c;
                        newItm.kstp__c=ex.kstp__c;
                        newItm.lbl__c=ex.lbl__c;
                        newItm.Milestone__c=ex.Milestone__c;
                        newItm.Name=ex.Name;
                        newItm.namsgs__c=ex.namsgs__c;
                        newItm.nm__c=ex.nm__c;
                        newItm.noEXP__c=ex.noEXP__c;
                        newItm.Notification_Configured__c=ex.Notification_Configured__c;
                        newItm.nt__c=ex.nt__c;
                        newItm.Overhead__c=ex.Overhead__c;
                        newItm.rc__c=ex.rc__c;
                        newItm.rfndA__c=ex.rfndA__c;
                        newItm.rfnd__c=ex.rfnd__c;
                        newItm.rqSTA__c=ex.rqSTA__c;
                        newItm.Score__c=ex.Score__c;
                        newItm.Shift_At__c=ex.Shift_At__c;
                        newItm.Shift_Items__c=ex.Shift_Items__c;
                        newItm.Shift_Type__c=ex.Shift_Type__c;
                        newItm.slaat__c=ex.slaat__c;
                        newItm.slaa__c=ex.slaa__c;
                        newItm.slaN__c=ex.slaN__c;
                        newItm.slaXP__c=ex.slaXP__c;
                        newItm.SLA_Configured__c=ex.SLA_Configured__c;
                        newItm.smstxt__c=ex.smstxt__c;
                        newItm.staown__c=ex.staown__c;
                        newItm.statype__c=ex.statype__c;
                        newItm.stk__c=ex.stk__c;
                        newItm.Task_Label__c=ex.Task_Label__c;
                        newItm.tempChk__c=ex.tempChk__c;
                        newItm.Tp__c=ex.Tp__c;
                        newItm.ws_mtd__c=ex.ws_mtd__c;
                        newItm.ws_typ__c=ex.ws_typ__c;
                        newItm.xai__c=ex.xai__c;
                        newItm.xcsits__c=ex.xcsits__c;
                        newItm.xsi__c=ex.xsi__c;
                        /** without comms**/ /*/newItm.action__c=ex.action__c;
                        newItm.acttype__c=ex.acttype__c;
                        newItm.actv__c=ex.actv__c;
                        newItm.Assignee__c=ex.Assignee__c;
                        newItm.cd__c=ex.cd__c;
                        newItm.Claimable_Refundable_Configured__c=ex.Claimable_Refundable_Configured__c;
                        newItm.clmA__c=ex.clmA__c;
                        newItm.clm__c=ex.clm__c;
                        newItm.cmthd__c=ex.cmthd__c;
                        newItm.Courier_Notes_Configured__c=ex.Courier_Notes_Configured__c;
                        newItm.Courier_Notes__c=ex.Courier_Notes__c;
                        newItm.Courier_Stage__c=ex.Courier_Stage__c;
                        newItm.Exclude_SLA__c=ex.Exclude_SLA__c;
                        newItm.exsyst__c=ex.exsyst__c;
                        newItm.imsgs__c=ex.imsgs__c;
                        newItm.isfn__c=ex.isfn__c;
                        newItm.jsovddt__c=ex.jsovddt__c;
                        newItm.kstp__c=ex.kstp__c;
                        newItm.lbl__c=ex.lbl__c;
                        newItm.Milestone__c=ex.Milestone__c;
                        newItm.Name=ex.Name;
                        newItm.namsgs__c=ex.namsgs__c;
                        newItm.nm__c=ex.nm__c;
                        newItm.noEXP__c=ex.noEXP__c;
                        newItm.Notification_Configured__c=ex.Notification_Configured__c;
                        newItm.nt__c=ex.nt__c;
                        newItm.Overhead__c=ex.Overhead__c;
                        newItm.rc__c=ex.rc__c;
                        newItm.rfndA__c=ex.rfndA__c;
                        newItm.rfnd__c=ex.rfnd__c;
                        newItm.rqSTA__c=ex.rqSTA__c;
                        newItm.Score__c=ex.Score__c;
                        newItm.Shift_At__c=ex.Shift_At__c;
                        newItm.Shift_Items__c=ex.Shift_Items__c;
                        newItm.Shift_Type__c=ex.Shift_Type__c;
                        newItm.slaat__c=ex.slaat__c;
                        newItm.slaa__c=ex.slaa__c;
                        newItm.slaN__c=ex.slaN__c;
                        newItm.slaXP__c=ex.slaXP__c;
                        newItm.SLA_Configured__c=ex.SLA_Configured__c;
                        newItm.staown__c=ex.staown__c;
                        newItm.statype__c=ex.statype__c;
                        newItm.stk__c=ex.stk__c;
                        newItm.tempChk__c=ex.tempChk__c;
                        newItm.Tp__c=ex.Tp__c;
                        newItm.ws_mtd__c=ex.ws_mtd__c;
                        newItm.ws_typ__c=ex.ws_typ__c;
                        newItm.xai__c=ex.xai__c;
                        newItm.xcsits__c=ex.xcsits__c;
                        newItm.xsi__c=ex.xsi__c;
                        */  /*//System.debug('****UPDAtE ITEM*******' + ex.uid__c);
                        */ listToUpdate.add(newItm);
                    }
                    else if (mapNweOldItemIDS.containsKey(Ex.itm__r.uid__c)) {
                        Id itemID = mapNweOldItemIDS.get(Ex.itm__r.uid__c.replace(oldCode, newItmCode));
                        System.debug('****itemID*******' + itemID);
                        if (itemID != null) {
                            g_srvcitm_Status__c newItm = new g_srvcitm_Status__c(itm__c=itemID, action__c=ex.action__c,
                                acttype__c=ex.acttype__c, actv__c=ex.actv__c, amsgs__c=ex.amsgs__c, Assignee__c=ex.Assignee__c,
                                Baction__c=ex.Baction__c, cd__c=ex.cd__c, Claimable_Refundable_Configured__c=ex.Claimable_Refundable_Configured__c,
                                clmA__c=ex.clmA__c, clm__c=ex.clm__c, cmthd__c=ex.cmthd__c, Courier_Notes_Configured__c=ex.Courier_Notes_Configured__c,
                                Courier_Notes__c=ex.Courier_Notes__c, Courier_Stage__c=ex.Courier_Stage__c, daction__c=ex.daction__c,
                                eCumsg__c=ex.eCumsg__c, eNumsg__c=ex.eNumsg__c, Exclude_SLA__c=ex.Exclude_SLA__c,
                                exsyst__c=ex.exsyst__c, hisl__c=ex.hisl__c, imsgs__c=ex.imsgs__c, isfn__c=ex.isfn__c,
                                ivraction__c=ex.ivraction__c, ivrmsg__c=ex.ivrmsg__c, jsovddt__c=ex.jsovddt__c, kstp__c=ex.kstp__c,
                                lbl__c=ex.lbl__c, Milestone__c=ex.Milestone__c, Name=ex.Name, namsgs__c=ex.namsgs__c,
                                nm__c=ex.nm__c, noEXP__c=ex.noEXP__c, Notification_Configured__c=ex.Notification_Configured__c,
                                nt__c=ex.nt__c, Overhead__c=ex.Overhead__c, rc__c=ex.rc__c, rfndA__c=ex.rfndA__c,
                                rfnd__c=ex.rfnd__c, rqSTA__c=ex.rqSTA__c, Score__c=ex.Score__c, Shift_At__c=ex.Shift_At__c,
                                Shift_Items__c=ex.Shift_Items__c, Shift_Type__c=ex.Shift_Type__c, slaat__c=ex.slaat__c,
                                slaa__c=ex.slaa__c, slaN__c=ex.slaN__c, slaXP__c=ex.slaXP__c, SLA_Configured__c=ex.SLA_Configured__c,
                                smstxt__c=ex.smstxt__c, staown__c=ex.staown__c, statype__c=ex.statype__c, stk__c=ex.stk__c,
                                Task_Label__c=ex.Task_Label__c, tempChk__c=ex.tempChk__c, Tp__c=ex.Tp__c, ws_mtd__c=ex.ws_mtd__c,
                                ws_typ__c=ex.ws_typ__c, xai__c=ex.xai__c, xcsits__c=ex.xcsits__c, xsi__c=ex.xsi__c);
                            listToinsert.add(newItm);
                        }
                    }
                }
            }
            if (Schema.sObjectType.g_srvcitm_Status__c.isUpdateable()) {
                update listToUpdate;
            }
            if (Schema.sObjectType.g_srvcitm_Status__c.isCreateable()) {
                insert listToinsert;
            }
            List<g_srvcitm_Doc__c> lstDocsToInsert = new List<g_srvcitm_Doc__c>();
            List<g_srvcitm_Doc__c> docsNew = [SELECT Att_Type__c, Doc_Description__c, Download_Doc_Link__c,
                itm__c, itm__r.uid__c, lbl__c, mnAts__c, mxAts__c, Name, Old_Sf_Id__c, ord__c, reqAts__c,
                reqOr__c, Req__c, rqc__c, Tp__c FROM g_srvcitm_Doc__c where Srv_Code__c =: fromCode];
            for (g_srvcitm_Doc__c doc : docsNew) {
                Id itemID = mapNweOldItemIDS.get(doc.itm__r.uid__c.replace(oldCode, newItmCode));
                if (itemID != null) {
                    lstDocsToInsert.add(new g_srvcitm_Doc__c(itm__c = itemID, Att_Type__c=doc.Att_Type__c,
                        Doc_Description__c=doc.Doc_Description__c, Download_Doc_Link__c=doc.Download_Doc_Link__c,
                        lbl__c=doc.lbl__c, mnAts__c=doc.mnAts__c, mxAts__c=doc.mxAts__c,
                        Name=doc.Name, Old_Sf_Id__c=doc.Old_Sf_Id__c, ord__c=doc.ord__c,
                        reqAts__c=doc.reqAts__c, reqOr__c=doc.reqOr__c, Req__c=doc.Req__c,
                        rqc__c=doc.rqc__c, Tp__c=doc.Tp__c));
                    /*/ lstDocsToInsert.add(new g_srvcitm_Doc__c(itm__c = newItmID, Att_Type__c=oldDoc.Att_Type__c, Doc_Description__c=oldDoc.Doc_Description__c, Download_Doc_Link__c=oldDoc.Download_Doc_Link__c, lbl__c=oldDoc.lbl__c, mnAts__c=oldDoc.mnAts__c, mxAts__c=oldDoc.mxAts__c, Name=oldDoc.Name, Old_Sf_Id__c=oldDoc.Old_Sf_Id__c, ord__c=oldDoc.ord__c, reqAts__c=oldDoc.reqAts__c, reqOr__c=oldDoc.reqOr__c, Req__c=oldDoc.Req__c, rqc__c=oldDoc.rqc__c, Tp__c=oldDoc.Tp__c));
                */ }
            }
            if (docsNew != null && docsNew.size()>0) {
                List<g_srvcitm_Doc__c> docsOld = [SELECT Att_Type__c, Doc_Description__c, Download_Doc_Link__c,
                    itm__c, lbl__c, mnAts__c, mxAts__c, Name, Old_Sf_Id__c, ord__c, reqAts__c, reqOr__c,
                    Req__c, rqc__c, Tp__c FROM g_srvcitm_Doc__c where Srv_Code__c =: toCode];
                if (Schema.sObjectType.g_srvcitm_Doc__c.isDeletable()) {
                    delete docsOld;
                }
                System.debug('lstDocsToInsert:: ' + lstDocsToInsert.size());
                if (Schema.sObjectType.g_srvcitm_Doc__c.isCreateable()) {
                    insert lstDocsToInsert;
                }
            }
            g_Srvc__c srvc = [select id, name, stg__c, copyCofig__c from g_Srvc__c where uid__c = :toCode limit 1];
            srvc.copyCofig__c = true;
            if (Schema.sObjectType.g_srvc__c.isUpdateable()) {
                update srvc;
            }
            ws_call__c wsCall = new ws_call__c();
            /*/fromCode, String toCode*/ wsCall.rq_jsn__c = 'fromCode: ' + fromCode + '   ** toCode: ' +toCode;
            wsCall.ws_typ__c = 'SuccessInernalSrvcs';
            if (Schema.sObjectType.ws_call__c.isCreateable()) {
                insert wsCall;
            }
        }
        catch (Exception e) {
            ws_call__c wsCall = new ws_call__c();
            /*/fromCode, String toCode*/ wsCall.rq_jsn__c = 'fromCode: ' + fromCode + '   ** toCode: ' +toCode;
            wsCall.ws_typ__c = 'FailedInernalSrvcs';
            String errormsg = '\n\n #### getMessage: '+ e.getMessage() + '######## stack trace ::: ' + e.getStackTraceString();
            /*/'RESPONSE --- ' +response.getBody() + */ wsCall.err_msg__c= errormsg;
            if (Schema.sObjectType.ws_call__c.isCreateable()) {
                insert wsCall;
            }
        }
    }

    //################################################################################################################
    //################################################################################################################
   public static void updateNextStatuses(String srvCode, Map<String, String> mapStatuses) {
       if (mapStatuses == null || mapStatuses.size()==0) {
           mapStatuses = new Map<String, String> {
           'rc'=>'v', 'rcc'=>'vcc', 'nc'=>'cc', 'ncc'=>'ccc'}
           ;
       }
       List<String> allStatuses = New List<String>();
       allStatuses.addAll(mapStatuses.keySet());
       allStatuses.addAll(mapStatuses.values());
       allStatuses.add('rv');
       System.debug('allStatuses: ' +allStatuses);
       List<g_srvcitm_Status__c> lstToUpdate = new List<g_srvcitm_Status__c>();
       List<g_srvcitm_Status__c> sts = [select id, cd__c, Next_Status__c, staown__c, name,
           statype__c, srvCode__c, itm__r.id from g_srvcitm_Status__c where cd__c = :allStatuses and srvCode__c=:srvCode];
       map<String, Id> mapSts = new Map<String, Id>();
       for (g_srvcitm_Status__c s : sts) {
           mapSts.put(s.itm__r.id+'-'+s.cd__c, s.id);
       }
       for (g_srvcitm_Status__c s : sts) {
           if (mapStatuses.containsKey(s.cd__c) && String.isBlank(s.Next_Status__c)) {
               String nxtCd = '-'+ mapStatuses.get(s.cd__c);
               String nxtStaId = mapSts.get(s.itm__r.id+nxtCd);
               if (s.cd__c=='rc' && String.isBlank(nxtStaId)) {
                   nxtStaId = mapSts.get(s.itm__r.id+'-rv');
               }
               s.Next_Status__c = nxtStaId;
               s.staown__c = 'Customer';
               s.statype__c = 'Process';
               lstToUpdate.add(s);
           }
       }
       System.debug('lstToUpdate size(): ' + lstToUpdate.size());
       if (Schema.sObjectType.g_srvcitm_Status__c.isUpdateable()) {
           update lstToUpdate;
       }
   }

    public class ConfigData{
        public List<g_srvcitm_Doc__c> docs {
            get;
            set;
        }
        public List<g_srvcitm__c> itms {
            get;
            set;
        }
        public List<g_srvcitm_Status__c> statuses {
            get;
            set;
        }
        public g_srvc_settings__c settings {
            get;
            set;
        }
        public ConfigData() {
            docs = new List<g_srvcitm_Doc__c>();
            itms = new List<g_srvcitm__c>();
            statuses = new List<g_srvcitm_Status__c>();
            settings = new g_srvc_settings__c();
        }
    }
}
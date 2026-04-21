global class AccountSnapshotBatch implements Database.Batchable < sObject > , Schedulable , Database.AllowsCallouts {
   global Database.QueryLocator start(Database.BatchableContext BC) {
  String query = 'select id, name, ORACLE_PARTY_ID__c, lc__c, lcsta__c, Prk__c, adob__c, adc__c, adx__c, adb__c, adr__c, tadr__c, bgnr__c, bgc__c, bg__c, bgcabsc__c, '+
                  'bgb__c, xpbg__c, bgrf__c, tbgr__c, vespe__c, voep__c, vespex__c, vcspe__c, vetemp__c, vcac__c, vbtemp__c, vcid__c, vestd__c, vctemp__c, speabsc__c, '+
                  'vespst__c, vcspst__c, vespstx__c, vcnspst__c, vetst__c, vctst__c, vbtst__c, spsabsc__c from account';
  return Database.getQueryLocator(query);
 }
 global void execute(Database.BatchableContext BC, List <Account> scope) {
   List<acc_snap__c> accHistLst = new List<acc_snap__c>();
   for (Account acc : scope) {
      acc_snap__c a = new acc_snap__c();
      a.accName__c = acc.name;
      a.ORACLE_PARTY_ID__c = acc.ORACLE_PARTY_ID__c;
      a.lc__c = acc.lc__c;
      a.lcsta__c = acc.lcsta__c;
      a.Prk__c = acc.Prk__c;
      a.adob__c =acc.adob__c;
      a.adc__c = acc.adc__c;
      a.adx__c = acc.adx__c;
      a.adb__c = acc.adb__c;a.adr__c=acc.adr__c;
      a.tadr__c = acc.tadr__c;
      a.bgnr__c = acc.bgnr__c;a.bgc__c = acc.bgc__c;
      a.bg__c = acc.bg__c;a.bgcabsc__c = acc.bgcabsc__c;
      a.bgb__c = acc.bgb__c;a.xpbg__c = acc.xpbg__c;a.bgrf__c = acc.bgrf__c;
      a.tbgr__c = acc.tbgr__c;
      a.vespe__c = acc.vespe__c;a.voep__c=acc.voep__c;a.vespex__c=acc.vespex__c;a.vcspe__c=acc.vcspe__c;
      a.vetemp__c=acc.vetemp__c;a.vcac__c=acc.vcac__c;a.vbtemp__c=acc.vbtemp__c;a.vcid__c=acc.vcid__c;a.vestd__c=acc.vestd__c;a.vctemp__c=acc.vctemp__c;a.speabsc__c=acc.speabsc__c;
      a.vespst__c = acc.vespst__c;
      a.vcspst__c=acc.vcspst__c;
      a.vespstx__c=acc.vespstx__c;
      a.vcnspst__c=acc.vcnspst__c;
      a.vetst__c=acc.vetst__c;
      a.vctst__c=acc.vctst__c;
      a.vbtst__c=acc.vbtst__c;
      a.spsabsc__c=acc.spsabsc__c;
      accHistLst.add(a);
   }
   if (Schema.sObjectType.acc_snap__c.isCreateable()) {
       insert accHistLst;
   }

 }

 global void finish(Database.BatchableContext BC) {}
 global void execute(SchedulableContext sc) {
        AccountSnapshotBatch  b = new AccountSnapshotBatch();
        database.executebatch(b, 1000);
     }

}
public class BatchContactRPValidity implements Database.Batchable < sObject > , Database.AllowsCallouts {
  public String query;
  public String role;
  public String gApiToken;
  public Date dt;
  public Map < String, Map < String, String >> getLookupIdByTypeNname = new Map < String, Map < String, String >> ();
  public BatchContactRPValidity(String rl) {
      role = rl;
      gApiToken = [Select id, tokenvalue__c from GDRFAAPITOKEN__mdt LIMIT 1].tokenvalue__c;
      getLookupIdByTypeNname = GDRFAUtil.LookupIdByTypeNname();
      dt = Date.today().addMonths(6);
      query = 'select id, rp__c, rped__c, rpid__c, e__c, firstname, Birthdate, nc__c, STA__c, Missing_RP_Data__c from contact where account.ORACLE_PARTY_ID__c  != \'999999999\' and STA__c in (\'Active\', \'Under Activation\') and rol__c=:role and (rped__c =null or rped__c<:dt)';
      //in (\'Employee\', \'Non Sponsored\', \'Student\', \'Spouse\', \'Child\')
  }
  public BatchContactRPValidity(String rl, id conid) {
      gApiToken = [Select id, tokenvalue__c from GDRFAAPITOKEN__mdt LIMIT 1].tokenvalue__c;
      getLookupIdByTypeNname = GDRFAUtil.LookupIdByTypeNname();
      query = 'select id, rp__c, rped__c, rpid__c, e__c, firstname, Birthdate, nc__c, STA__c, Missing_RP_Data__c from contact where id=\'' + conid + '\'';
  }
  public Database.QueryLocator start(Database.BatchableContext BC) {
        system.debug('query::' + query);
        return Database.getQueryLocator(query);
   }
  public void execute(Database.BatchableContext BC, List < contact > scope) {
      contact con = scope[0];
      String fileno = '', nameEn='';
      if (String.isNotBlank(con.rp__c))
          fileno = (con.rp__c).replace('/', '');
      else if (String.isNotBlank(con.e__c))
          fileno = (con.e__c).replace('/', '');
      if (String.isNotBlank(con.firstname))
       nameEn = con.firstname.substringBefore(' ');
      String countryid = getLookupIdByTypeNname.get('Country').get((con.nc__c).toUpperCase());
      if (String.isNotBlank(nameEn) && String.isNotBlank(fileno) && con.Birthdate != null && String.isNotBlank(countryid)) {
         ApplicationDetailsWrapper res = GDRFAUtil.getApplicantRPDetails(nameEn, fileno, countryid, String.valueOf(con.Birthdate), gApiToken);
          if (res != null && res.IsSuccess != null && res.IsSuccess) {
              if (String.isBlank(con.rp__c))
               con.rp__c = con.e__c;
              con.rpid__c = date.valueOf(res.IssueDate);
              con.rped__c = date.valueOf(res.expiryDate);
              if (con.rped__c > Date.today())
                con.STA__c = 'Active';

          }
          else{
              con.Missing_RP_Data__c = true;
          }
      }
      else{
           con.Missing_RP_Data__c = true;
      }
      if (Schema.sObjectType.Contact.isUpdateable()) {
          update con;
      }
  }
  public void finish(Database.BatchableContext BC) {}
}
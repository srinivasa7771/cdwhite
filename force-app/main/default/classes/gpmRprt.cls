public class gpmRprt {
 Public String accid {set;get;}
 Public Account acc {set;get;}
public Decimal osE {
        get;
        set;
    } {
        osE = 0;
    }
public Decimal sE {
        get;
        set;
    } {
        sE = 0;
    }
public Decimal nsE {
        get;
        set;
    } {
        nsE = 0;
    }
 Public gpmRprt() {
   accid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('accid'));
   acc = [select id, name, voep__c, vcspe__c, vcac__c, vcid__c, vbtemp__c, vetemp__c,
       (select id, rol__c from Contacts where os__c=true and STA__c in ('Draft', 'Under Activation', 'Active', 'Under Deactivation')) from Account where id=:accid];
  /* List<AggregateResult> agrLst= [select count(Id) cnt from AccountcontactRelation where isDirect = false and contactId in (select id from Contact where accountid =:accid and os__c=true) and sts__c = 'Active'];
    if (agrLst != null && !agrLst.isEmpty())
    osE = (Decimal)agrLst.get(0).get('cnt'); */
    Decimal t1=0;
    Decimal t2=0;
    if (acc != null && acc.contacts != null && !acc.contacts.isEmpty()) {
     osE = acc.contacts.size();

      for (Contact con : acc.contacts) {
          if (con.rol__c == 'Employee')
           t1 = t1+1;
          if (con.rol__c == 'Non Sponsored')
           t2 = t2+1;
      }

    }
    sE = acc.vcspe__c-t1;
    nsE = acc.vcid__c+acc.vcac__c-t2;
 }

}
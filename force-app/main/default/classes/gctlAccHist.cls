public class gctlAccHist {
   public id accid {set;get;}
   public gctlAccHist(ApexPages.StandardController sc) {
        accid = (Id)sc.getRecord().id;
    }
   public List<AccountHistory> getAccHistLst() {
       List<AccountHistory> lst = new List<AccountHistory>();
       lst = [select id, createddate, createdby.name, Field, NewValue, OldValue from AccountHistory where AccountId=:accid  order by createddate desc limit 2000 ALL ROWS];
      return lst;
   }
}
public with sharing class AccountDataController {
    public class AccountWrapper {
        @AuraEnabled public Account account;
        @AuraEnabled public Integer totalOpportunities;
        @AuraEnabled public Decimal closedWonValue;
        @AuraEnabled public List<Contact> contacts;

        public AccountWrapper(Account account) {
            this.account = account;
            this.totalOpportunities = 0;
            this.closedWonValue = 0;
            this.contacts = new List<Contact>();
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static List<AccountWrapper> getAccountData() {
        List<Account> accounts = [
            SELECT Id, Name, (SELECT Id, Amount, StageName FROM Opportunities),
                    (SELECT Id, Name, Email FROM Contacts)
            FROM Account
            WHERE Id IN (SELECT AccountId FROM Opportunity)
        ];

        List<AccountWrapper> accountWrappers = new List<AccountWrapper>();

        for (Account acc : accounts) {
            AccountWrapper wrapper = new AccountWrapper(acc);

            for (Opportunity opp : acc.Opportunities) {
                wrapper.totalOpportunities++;
                if (opp.StageName == 'Closed Won') {
                    wrapper.closedWonValue += opp.Amount;
                }
            }

            wrapper.contacts = acc.Contacts;

            accountWrappers.add(wrapper);
        }

        return accountWrappers;
    }
}
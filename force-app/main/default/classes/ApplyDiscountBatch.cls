public with sharing class ApplyDiscountBatch implements Database.Batchable<SObject> {
    private Date closeDateCriteria;
    private String stageCriteria;
    private Decimal discountPercentage;

    public ApplyDiscountBatch(Date closeDate, String stage, Decimal discount) {
        this.closeDateCriteria = closeDate;
        this.stageCriteria = stage;
        this.discountPercentage = discount;
    }

    public Database.QueryLocator start(Database.BatchableContext BC) {
        // Find OpportunityLineItems where the parent Opportunity meets criteria
        String query = 'SELECT Id, UnitPrice FROM OpportunityLineItem ' + 
                       'WHERE Opportunity.CloseDate = :closeDateCriteria ' + 
                       'AND Opportunity.StageName = :stageCriteria';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext BC, List<OpportunityLineItem> scope) {
        for (OpportunityLineItem item : scope) {
            item.UnitPrice = item.UnitPrice * (1 - discountPercentage / 100);
        }
        update scope; // Apply updates in bulk to prevent DML limit issues
    }

    public void finish(Database.BatchableContext BC) {
        // Optional: Log or notify completion
        System.debug('Discount application batch job completed.');
    }
}
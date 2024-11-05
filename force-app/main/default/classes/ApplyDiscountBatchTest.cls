@isTest
public class ApplyDiscountBatchTest {

    @isTest
    static void testBatchJob() {
        // Set up test data
        Opportunity opp = new Opportunity(Name = 'Test Opportunity', CloseDate = Date.today(), StageName = 'Closed Won');
        insert opp;

        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, UnitPrice = 100, Quantity = 1);
        insert oli;

        Test.startTest();

        // Run the batch with 10% discount
        ApplyDiscountBatch batch = new ApplyDiscountBatch(Date.today(), 'Closed Won', 10);
        Database.executeBatch(batch);

        Test.stopTest();

        // Verify the discount was applied correctly
        oli = [SELECT UnitPrice FROM OpportunityLineItem WHERE Id = :oli.Id];
        System.assertEquals(90, oli.UnitPrice, 'The discount was not applied correctly.');
    }

    @isTest
    static void testScheduler() {
        Test.startTest();

        // Schedule the batch job
        String cronExpression = '0 0 0 1 * ?';
        System.schedule('Monthly Discount Application', cronExpression, new DiscountBatchScheduler());

        Test.stopTest();

        // Verify that the scheduled job is set up
        CronTrigger ct = [SELECT Id, CronExpression FROM CronTrigger WHERE CronJobDetail.Name = 'Monthly Discount Application' LIMIT 1];
        System.assertEquals(cronExpression, ct.CronExpression, 'Scheduled job cron expression did not match.');
    }
}
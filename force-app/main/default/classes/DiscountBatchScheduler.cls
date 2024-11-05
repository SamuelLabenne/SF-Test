public class DiscountBatchScheduler implements Schedulable {

    public void execute(SchedulableContext SC) {
        // Define the parameters for the batch job
        Date closeDate = Date.today(); // Example: current date (adjust as needed)
        String stage = 'Closed Won'; // Example stage
        Decimal discount = 10; // 10% discount

        ApplyDiscountBatch batch = new ApplyDiscountBatch(closeDate, stage, discount);
        Database.executeBatch(batch);
    }
}
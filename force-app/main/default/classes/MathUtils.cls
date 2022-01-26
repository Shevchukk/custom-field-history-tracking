public class MathUtils {
    public static Decimal calculateAverage(List<Decimal> nums) {
        Decimal sum = 0;
        for (Decimal i : nums) {
            sum += i;
        }
        if(nums.size() > 0) {

       	 	return sum/nums.size();
        }
        else {
            return 0.0;
        }
    }
}
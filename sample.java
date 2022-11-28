package test_repo;

public class sample
{
    private int empId;
    private String empName;
    private String empDepartment;
    private static int counter = 0;
    sample(String name, String Department)
    {
        this.empId = counter;
        this.empName = name;
        this.empDepartment = Department; 
        counter++;
    }
    public static void main(String[] args)
    {
        sample s = new sample("Jim","Harper");
        System.out.println(s.empDepartment);
    }
}

namespace PlantCare.Model.Requests
{
    public class UsernameEmailCheckRequest
    {
        public string? KorisnickoIme { get; set; }
        public string? Email { get; set; }
        public int? IgnoreId { get; set; }
    }
}

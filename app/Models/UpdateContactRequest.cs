namespace WebApi.Controllers
{
    public class UpdateContactRequest
    {
        public string FullName { get; set; } = null!;
        public string Email { get; set; } = null!;
    }
}
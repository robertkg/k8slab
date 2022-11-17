namespace WebApi.Models;

public class AddContactRequest
{
    public string FullName { get; set; } = null!;
    public string Email { get; set; } = null!;
}
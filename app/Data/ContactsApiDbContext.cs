using WebApi.Models;
using Microsoft.EntityFrameworkCore;

namespace WebApi.Data;

public class ContactsApiDbContext : DbContext
{

    // Create constructor
    public ContactsApiDbContext(DbContextOptions options) : base(options)
    {

    }

    // Create properties: Tables for EF Core
    public DbSet<Contact> Contacts { get; set; }

}
using Microsoft.AspNetCore.Mvc;
using WebApi.Data;
using WebApi.Models;

namespace WebApi.Controllers;

[ApiController]
[Route("api/[controller]")]
public class ContactsController : Controller
{

    private readonly ContactsApiDbContext dbContext;

    // Create constructor to inject DB context to access DB tables
    public ContactsController(ContactsApiDbContext dbContext)
    {
        this.dbContext = dbContext;
    }

    [HttpGet]
    public IActionResult GetContacts()
    {
        return Ok(dbContext.Contacts.ToList());
    }

    [HttpPost]
    public IActionResult AddContact(AddContactRequest addContactRequest)
    {
        var contact = new Contact()
        {
            Id = Guid.NewGuid(),
            FullName = addContactRequest.FullName,
            Email = addContactRequest.Email
        };

        dbContext.Contacts.Add(contact);
        // await dbContext.Contacts.AddAsync(contact); // async option, method must also be async, action must also be wrapped in task
        dbContext.SaveChanges();
        return Ok(contact);

    }

    [HttpPut]
    [Route("{id:guid}")]
    public IActionResult UpdateContact([FromRoute] Guid id, UpdateContactRequest updateContactRequest)
    {
        var contact = dbContext.Contacts.Find(id);

        if (contact == null)
        {
            return NotFound();
        }

        contact.FullName = updateContactRequest.FullName;
        contact.Email = updateContactRequest.Email;
        dbContext.SaveChanges();

        return Ok(contact);
    }
}
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;

var builder = WebApplication.CreateBuilder(args);


// Enable Swagger OpenAPI
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Add database context to dependency injection (DI)
builder.Services.AddDbContext<TaskDb>(options => {
    options.UseSqlServer(builder.Configuration.GetConnectionString("WebApiDbConnection"));
});
// Enable output of database exceptions
builder.Services.AddDatabaseDeveloperPageExceptionFilter();

var app = builder.Build();

// DI middlewire
app.UseSwagger();
app.UseSwaggerUI();

app.MapGet("/", () => "k8slab.webapi");

app.MapGet("/tasks", async (TaskDb db) =>
    await db.Todos.ToListAsync());

app.MapPost("/tasks", async (Task todo, TaskDb db) =>
{
    db.Todos.Add(todo);
    await db.SaveChangesAsync();
    return Results.Created($"/tasks/{todo.Id}", todo);
});

app.Run();


// Model
// A model is a class that represents data that the app manages. The model for this app is the Todo class.
class Task
{
    public int Id { get; set; }
    public string? Name { get; set; }
    public bool IsComplete { get; set; }
}

// Database context
// The database context is the main class that coordinates Entity Framework functionality for a data model. This class is created by deriving from the Microsoft.EntityFrameworkCore.DbContext class.
class TaskDb : DbContext
{
    public TaskDb(DbContextOptions<TaskDb> options)
        : base(options) { }

    public DbSet<Task> Todos => Set<Task>();
}
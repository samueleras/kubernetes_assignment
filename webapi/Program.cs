using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Hosting;

var builder = WebApplication.CreateBuilder(args);
builder.Services.AddControllers();

var app = builder.Build();

// Serve static files from wwwroot
app.UseDefaultFiles();
app.UseStaticFiles();

// API endpoint that returns a JSON response
app.MapGet("/api/hello", () => Results.Json(new { message = "Hello from API! With CI/CD. Test" }));

// Explicitly listen on all network interfaces
app.Urls.Add("http://0.0.0.0:8080");

app.Run();

public partial class Program { }